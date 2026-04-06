import 'package:flutter/services.dart';

class ForegroundService {
  static const _channel = MethodChannel('colourswift/foreground_service');

  static Future<void> start({
    String title = 'AvarionX Security',
    String text = 'Realtime protection active',
  }) async {
    try {
      await _channel.invokeMethod('startService', {
        'title': title,
        'text': text,
      });
    } catch (_) {}
  }

  static Future<void> toast({required String text}) async {
    try {
      await _channel.invokeMethod('toast', {'text': text});
    } catch (_) {}
  }

  static Future<void> stop() async {
    try {
      await _channel.invokeMethod('stopService');
    } catch (_) {}
  }

  static Future<void> notify({
    required String title,
    required String text,
    int? autoDismissAfterSeconds,
    bool openQuarantineOnClick = false,
  }) async {
    try {
      await _channel.invokeMethod('showNotification', {
        'title': title,
        'text': text,
        'autoDismissAfterSeconds': autoDismissAfterSeconds,
        'openQuarantine': openQuarantineOnClick,
      });
    } catch (_) {}
  }

  static Future<void> showScanOngoing({
    String title = 'Scheduled scan running',
    String text = 'Scanning files...',
  }) async {
    try {
      await _channel.invokeMethod('showScanOngoing', {
        'title': title,
        'text': text,
      });
    } catch (_) {}
  }

  static Future<void> updateScanOngoing({
    String title = 'Scheduled scan running',
    required String text,
  }) async {
    try {
      await _channel.invokeMethod('updateScanOngoing', {
        'title': title,
        'text': text,
      });
    } catch (_) {}
  }

  static Future<void> hideScanOngoing() async {
    try {
      await _channel.invokeMethod('hideScanOngoing');
    } catch (_) {}
  }
}