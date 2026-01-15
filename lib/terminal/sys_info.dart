import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:battery_plus/battery_plus.dart';

class SysInfo {
  static Future<String> uname() async {
    try {
      final lines = await File('/proc/version').readAsLines();
      return lines.isNotEmpty ? lines.first : 'unknown';
    } catch (_) {
      return 'unknown';
    }
  }

  static Future<String> arch() async {
    return Platform.version;
  }

  static Future<String> uptime() async {
    try {
      final content = await File('/proc/uptime').readAsString();
      final seconds = double.parse(content.split(' ').first);
      final hours = seconds ~/ 3600;
      final minutes = (seconds % 3600) ~/ 60;
      return '${hours}h ${minutes}m';
    } catch (_) {
      return 'unknown';
    }
  }

  static Future<String> cpu() async {
    try {
      final lines = await File('/proc/cpuinfo').readAsLines();
      final cores =
          lines.where((l) => l.startsWith('processor')).length;
      return 'cores=$cores';
    } catch (_) {
      return 'unknown';
    }
  }

  static Future<String> mem() async {
    try {
      final lines = await File('/proc/meminfo').readAsLines();
      final total = lines.firstWhere((l) => l.startsWith('MemTotal'));
      final free = lines.firstWhere((l) => l.startsWith('MemAvailable'));
      return '${total.trim()} | ${free.trim()}';
    } catch (_) {
      return 'unknown';
    }
  }

  static Future<String> disk() async {
    try {
      final dir = await getApplicationDocumentsDirectory();
      final stat = await dir.stat();
      return 'app_fs size=${stat.size}';
    } catch (_) {
      return 'unknown';
    }
  }

  static Future<String> network() async {
    try {
      final ifaces = await NetworkInterface.list();
      if (ifaces.isEmpty) return 'no interfaces';
      return ifaces.map((i) => i.name).join(', ');
    } catch (_) {
      return 'unknown';
    }
  }

  static Future<String> battery() async {
    try {
      final battery = Battery();
      final level = await battery.batteryLevel;
      final state = await battery.batteryState;
      return 'level=$level% state=$state';
    } catch (_) {
      return 'unknown';
    }
  }
}
