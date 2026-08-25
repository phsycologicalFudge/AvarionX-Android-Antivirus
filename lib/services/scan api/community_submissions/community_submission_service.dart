import 'dart:io';
import 'dart:typed_data';

import 'package:crypto/crypto.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../scan_types.dart';
import '../../foreground_service.dart';
import '../../quarantine_service.dart';
import 'api.dart';

enum SubmissionSource { rtp, manualScan }

class CommunitySubmissionService {
  CommunitySubmissionService._();

  static const int maxUploadBytes = 30 * 1024 * 1024;

  static const _kMasterEnabled = 'community_submission_enabled';
  static const _kAskedOnce = 'community_submission_asked';
  static const _kRtpEnabled = 'community_submission_rtp_enabled';
  static const _kManualEnabled = 'community_submission_manual_enabled';
  static const _kWifiOnly = 'community_submission_wifi_only';
  static const _kChargingOnly = 'community_submission_charging_only';
  static const _kSelectedFilesOnly = 'community_submission_selected_only';

  static Future<bool> isEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_kMasterEnabled) ?? false;
  }

  static Future<void> setEnabled(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    final saved = await prefs.setBool(_kMasterEnabled, value);
    debugPrint('[COMMUNITY] Pref write master=$value saved=$saved');
  }

  static Future<bool> hasBeenAsked() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_kAskedOnce) ?? false;
  }

  static Future<void> markAsked() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_kAskedOnce, true);
  }

  static Future<bool> isRtpEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_kRtpEnabled) ?? true;
  }

  static Future<void> setRtpEnabled(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    final saved = await prefs.setBool(_kRtpEnabled, value);
    debugPrint('[COMMUNITY] Pref write rtp=$value saved=$saved');
  }

  static Future<bool> isManualScanEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_kManualEnabled) ?? true;
  }

  static Future<void> setManualScanEnabled(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    final saved = await prefs.setBool(_kManualEnabled, value);
    debugPrint('[COMMUNITY] Pref write manual=$value saved=$saved');
  }

  static Future<bool> isWifiOnly() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_kWifiOnly) ?? true;
  }

  static Future<void> setWifiOnly(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    final saved = await prefs.setBool(_kWifiOnly, value);
    debugPrint('[COMMUNITY] Pref write wifiOnly=$value saved=$saved');
  }

  static Future<bool> isChargingOnly() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_kChargingOnly) ?? false;
  }

  static Future<void> setChargingOnly(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    final saved = await prefs.setBool(_kChargingOnly, value);
    debugPrint('[COMMUNITY] Pref write chargingOnly=$value saved=$saved');
  }

  static Future<bool> isSelectedFilesOnly() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_kSelectedFilesOnly) ?? false;
  }

  static Future<void> setSelectedFilesOnly(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    final saved = await prefs.setBool(_kSelectedFilesOnly, value);
    debugPrint('[COMMUNITY] Pref write selectedOnly=$value saved=$saved');
  }

  static List<DetectionResult> selectSamplesForUpload(
    Iterable<DetectionResult> detections,
  ) {
    const mb = 1024 * 1024;
    const upperLargeThreshold = 2099 * mb ~/ 100;

    final buckets = <List<DetectionResult>>[
      <DetectionResult>[],
      <DetectionResult>[],
      <DetectionResult>[],
      <DetectionResult>[],
      <DetectionResult>[],
      <DetectionResult>[],
    ];

    for (final detection in detections) {
      final size = detection.apkSize ?? 0;
      if (size <= 0 || size > maxUploadBytes) continue;

      if (size <= 2 * mb) {
        buckets[0].add(detection);
      } else if (size <= 5 * mb) {
        buckets[1].add(detection);
      } else if (size <= 10 * mb) {
        buckets[2].add(detection);
      } else if (size <= 15 * mb) {
        buckets[3].add(detection);
      } else if (size <= upperLargeThreshold) {
        buckets[4].add(detection);
      } else {
        buckets[5].add(detection);
      }
    }

    const limits = <int>[20, 10, 5, 4, 2, 1];
    final selected = <DetectionResult>[];

    for (var i = 0; i < buckets.length; i++) {
      final bucket = buckets[i]..shuffle();
      final take = bucket.length < limits[i] ? bucket.length : limits[i];
      selected.addAll(bucket.take(take));
      debugPrint(
        '[COMMUNITY] Bucket index=$i candidates=${bucket.length} selected=$take limit=${limits[i]}',
      );
    }

    debugPrint(
      '[COMMUNITY] Batch selection candidates=${detections.length} selected=${selected.length}',
    );
    return selected;
  }


  static Future<void> processManualDetections(
    Iterable<DetectionResult> detections,
  ) async {
    final candidates = List<DetectionResult>.from(detections);
    final pending = selectSamplesForUpload(candidates);

    debugPrint(
      '[COMMUNITY] Submission pass started detections=${candidates.length} selected=${pending.length}',
    );

    if (pending.isEmpty) return;

    final masterEnabled = await isEnabled();
    final manualEnabled = await isManualScanEnabled();

    if (!masterEnabled || !manualEnabled) {
      debugPrint(
        '[COMMUNITY] Submission pass skipped master=$masterEnabled manual=$manualEnabled',
      );
      return;
    }

    await ForegroundService.startUploadHost();
    debugPrint('[COMMUNITY] Upload foreground host acquired');

    try {
      final eligible = <DetectionResult>[];
      final hashes = <String>[];

      for (final detection in pending) {
      final path = detection.path;
      final apkSize = detection.apkSize ?? 0;

      if (path == null || path.isEmpty) {
        debugPrint(
          '[COMMUNITY] Skipped detection with no source path name=${detection.name}',
        );
        continue;
      }

      final shouldSubmit = await shouldQueueForUpload(
        source: SubmissionSource.manualScan,
        path: path,
        isDetected: true,
        apkSize: apkSize,
      );

      if (!shouldSubmit) continue;

      try {
        final hash = await _sha256ForDetection(detection);
        debugPrint(
          '[COMMUNITY] SHA256 ready name=${detection.name} sha256=$hash',
        );
        eligible.add(detection);
        hashes.add(hash);
      } catch (e) {
        debugPrint(
          '[COMMUNITY] Hashing failed name=${detection.name} error=$e',
        );
      }
    }

      if (eligible.isEmpty) return;

      debugPrint('[COMMUNITY] Preflight starting samples=${eligible.length}');
      final preflight = await checkCommunitySamples(hashes);
      debugPrint(
        '[COMMUNITY] Preflight finished ok=${preflight.ok} status=${preflight.statusCode} missing=${preflight.missingIndexes.length} error=${preflight.error ?? 'null'}',
      );

      if (!preflight.ok || preflight.missingIndexes.isEmpty) return;

      final missingIndexes = preflight.missingIndexes
          .where((index) => index >= 0 && index < eligible.length)
          .toSet();

      if (missingIndexes.isEmpty) return;

      for (var i = 0; i < eligible.length; i++) {
        if (!missingIndexes.contains(i)) {
          debugPrint(
            '[COMMUNITY] Server already has sample name=${eligible[i].name} sha256=${hashes[i]}',
          );
          continue;
        }

        final detection = eligible[i];
        final hash = hashes[i];

        try {
          final quarantinePath = detection.quarantinePath;
          debugPrint(
            '[COMMUNITY] Preparing upload name=${detection.name} sha256=$hash quarantinePath=${quarantinePath ?? 'null'}',
          );

          if (quarantinePath != null && quarantinePath.isNotEmpty) {
            final bytes = await QuarantineService.readQuarantinedBytes(
              quarantinePath,
            );
            debugPrint(
              '[COMMUNITY] Quarantine sample recovered bytes=${bytes.length}',
            );
            await submitBytes(bytes, hash);
          } else {
            await submit(detection.path!, hash);
          }
        } catch (e) {
          debugPrint(
            '[COMMUNITY] Submission failed name=${detection.name} error=$e',
          );
        }
      }
    } finally {
      await ForegroundService.stopUploadHost();
      debugPrint('[COMMUNITY] Upload foreground host released');
    }
  }

  static Future<String> _sha256ForDetection(DetectionResult detection) async {
    final quarantinePath = detection.quarantinePath;
    if (quarantinePath != null && quarantinePath.isNotEmpty) {
      final bytes = await QuarantineService.readQuarantinedBytes(quarantinePath);
      return sha256.convert(bytes).toString();
    }

    final path = detection.path;
    if (path == null || path.isEmpty) {
      throw StateError('missing_sample_path');
    }

    final digest = await sha256.bind(File(path).openRead()).first;
    return digest.toString();
  }

  static Future<bool> shouldQueueForUpload({
    required SubmissionSource source,
    required String path,
    required bool isDetected,
    required int apkSize,
  }) async {
    debugPrint(
      '[COMMUNITY] Eligibility check source=${source.name} path=$path detected=$isDetected size=$apkSize',
    );

    if (!isDetected) {
      debugPrint('[COMMUNITY] Rejected: sample is not detected');
      return false;
    }

    if (!isApkPath(path)) {
      debugPrint('[COMMUNITY] Rejected: path is not an APK');
      return false;
    }

    if (apkSize <= 0) {
      debugPrint('[COMMUNITY] Rejected: APK size is invalid');
      return false;
    }

    if (apkSize > maxUploadBytes) {
      debugPrint(
        '[COMMUNITY] Rejected: APK exceeds limit size=$apkSize limit=$maxUploadBytes',
      );
      return false;
    }

    final masterEnabled = await isEnabled();
    debugPrint('[COMMUNITY] Master enabled=$masterEnabled');

    if (!masterEnabled) {
      debugPrint('[COMMUNITY] Rejected: community submission is disabled');
      return false;
    }

    final sourceEnabled = switch (source) {
      SubmissionSource.rtp => await isRtpEnabled(),
      SubmissionSource.manualScan => await isManualScanEnabled(),
    };

    debugPrint(
      '[COMMUNITY] Source enabled source=${source.name} enabled=$sourceEnabled',
    );

    if (!sourceEnabled) {
      debugPrint('[COMMUNITY] Rejected: submission source is disabled');
      return false;
    }

    debugPrint('[COMMUNITY] Accepted for upload');
    return true;
  }

  static Future<CommunitySubmitResult> submit(
    String path,
    String sha256Value,
  ) async {
    try {
      debugPrint('[COMMUNITY] Reading sample path=$path');
      final bytes = await File(path).readAsBytes();
      debugPrint('[COMMUNITY] Read ${bytes.length} bytes from sample');
      return await submitBytes(bytes, sha256Value);
    } catch (e) {
      debugPrint('[COMMUNITY] Failed reading sample error=$e');
      rethrow;
    }
  }

  static Future<CommunitySubmitResult> submitBytes(
    Uint8List bytes,
    String sha256Value,
  ) async {
    debugPrint(
      '[COMMUNITY] Upload starting bytes=${bytes.length} sha256=$sha256Value',
    );

    try {
      final result = await submitCommunitySample(bytes, sha256Value);
      debugPrint(
        '[COMMUNITY] Upload finished ok=${result.ok} existing=${result.existing} status=${result.statusCode} sampleId=${result.sampleId ?? 'null'} sha256=${result.sha256 ?? sha256Value} error=${result.error ?? 'null'}',
      );
      return result;
    } catch (e) {
      debugPrint('[COMMUNITY] Upload threw exception error=$e');
      rethrow;
    }
  }
}