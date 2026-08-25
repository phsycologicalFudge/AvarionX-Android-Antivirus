import 'dart:async';
import 'package:flutter/foundation.dart';

class LogBuffer {
  static final List<String> _messages = [];
  static final ValueNotifier<int> notifier = ValueNotifier<int>(0);
  static Timer? _flushTimer;

  static void add(String msg) {
    final now = DateTime.now();
    final time =
        "${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}:${now.second.toString().padLeft(2, '0')}";
    _messages.add('[$time] $msg');
    if (_messages.length > 300) _messages.removeAt(0);
    if (_flushTimer != null) return;
    _flushTimer = Timer(const Duration(milliseconds: 120), () {
      _flushTimer = null;
      notifier.value++;
    });
  }

  static List<String> get all => List.unmodifiable(_messages);

  static void clear() {
    _messages.clear();
    try {
      _flushTimer?.cancel();
    } catch (_) {}
    _flushTimer = null;
    notifier.value++;
  }
}
