// Copyright (c) 2024-2026 ColourSwift Ltd. All rights reserved.
//
// This file is part of the ColourSwift SDK and is proprietary software.
// Access to the ColourSwift Cloud API is granted solely for use within authorised ColourSwift applications (AVarionX, AVarionX VPN, and SafeHaven-derived FOSS projects).
// Use of this code or the API it interfaces with outside the ColourSwift ecosystem, including in third-party apps or services, is strictly prohibited without explicit written permission from ColourSwift Ltd.
//
// Contact: support@colourswift.com

import 'dart:convert';
import 'dart:math';
import 'package:crypto/crypto.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class CloudAuthService {
  static const _storage = FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
  );

  static const _keyClientUuid = 'av_client_uuid';
  static const _keySessionToken = 'av_session_token';
  static const _keySessionExpiresAt = 'av_session_expires_at';

  static const _registerEndpoint = 'https://api.colourswift.com/hash_cloud/register';
  static const _refreshThresholdDays = 3;

  static String? _sessionToken;

  static String? get sessionToken => _sessionToken;

  static String _generateUuid() {
    final rng = Random.secure();
    final bytes = List<int>.generate(16, (_) => rng.nextInt(256));
    bytes[6] = (bytes[6] & 0x0f) | 0x40;
    bytes[8] = (bytes[8] & 0x3f) | 0x80;
    String hex(int b) => b.toRadixString(16).padLeft(2, '0');
    return '${bytes.sublist(0, 4).map(hex).join()}-'
        '${bytes.sublist(4, 6).map(hex).join()}-'
        '${bytes.sublist(6, 8).map(hex).join()}-'
        '${bytes.sublist(8, 10).map(hex).join()}-'
        '${bytes.sublist(10).map(hex).join()}';
  }

  static String _hashUuid(String uuid) {
    return sha256.convert(utf8.encode(uuid)).toString();
  }

  static Future<String> _getOrCreateUuid() async {
    final existing = await _storage.read(key: _keyClientUuid);
    if (existing != null && existing.isNotEmpty) return existing;
    final uuid = _generateUuid();
    await _storage.write(key: _keyClientUuid, value: uuid);
    return uuid;
  }

  static Future<bool> _register() async {
    try {
      final uuid = await _getOrCreateUuid();
      final clientHash = _hashUuid(uuid);

      final res = await http.post(
        Uri.parse(_registerEndpoint),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'client_hash': clientHash}),
      ).timeout(const Duration(seconds: 10));

      if (res.statusCode != 200) return false;

      final data = jsonDecode(res.body) as Map<String, dynamic>;
      final token = data['session_token'] as String?;
      final expiresIn = data['expires_in'] as int?;
      if (token == null || expiresIn == null) return false;

      final expiresAt = (DateTime.now().millisecondsSinceEpoch ~/ 1000) + expiresIn;

      await _storage.write(key: _keySessionToken, value: token);
      await _storage.write(key: _keySessionExpiresAt, value: expiresAt.toString());

      _sessionToken = token;
      return true;
    } catch (_) {
      return false;
    }
  }

  static Future<void> ensureRegistered() async {
    final token = await _storage.read(key: _keySessionToken);
    final expiresAtStr = await _storage.read(key: _keySessionExpiresAt);

    if (token != null && token.isNotEmpty && expiresAtStr != null) {
      final expiresAt = int.tryParse(expiresAtStr) ?? 0;
      final now = DateTime.now().millisecondsSinceEpoch ~/ 1000;
      final daysLeft = (expiresAt - now) / 86400;

      if (daysLeft > _refreshThresholdDays) {
        _sessionToken = token;
        return;
      }
    }

    await _register();
  }
}