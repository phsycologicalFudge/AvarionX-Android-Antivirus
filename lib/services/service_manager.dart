import 'dart:developer' as dev;
import 'package:flutter/services.dart';

class AvServiceManager {
  static bool _isRunning = true;

  static const MethodChannel _vpnChannel = MethodChannel("cs_vpn_control");

  static Future<void> startProtection() async {
    dev.log('Starting ColourSwift AV services...');
    _isRunning = true;
    await Future.delayed(const Duration(milliseconds: 500));
    dev.log('AV services started.');
  }

  static Future<void> stopProtection() async {
    dev.log('Stopping ColourSwift AV services...');
    _isRunning = false;
    await Future.delayed(const Duration(milliseconds: 500));
    dev.log('AV services stopped.');
  }

  static Future<void> startVpn({String dnsMode = 'malware'}) async {
    String nativeMode;
    switch (dnsMode) {
      case 'cloud':
        nativeMode = 'cloud';
        break;
      case 'adult':
      case 'basic_adult':
        nativeMode = 'basic_adult';
        break;
      case 'malware':
      case 'basic_malware':
      default:
        nativeMode = 'basic_malware';
        break;
    }

    try {
      await _vpnChannel.invokeMethod(
        "startVpn",
        {
          "dns_mode": nativeMode,
        },
      );
      dev.log("VPN start requested (dns=$nativeMode).");
    } catch (e) {
      dev.log("VPN start failed: $e");
    }
  }

  static Future<void> stopVpn() async {
    try {
      await _vpnChannel.invokeMethod("stopVpn");
      dev.log("VPN stop requested.");
    } catch (e) {
      dev.log("VPN stop failed: $e");
    }
  }

  static bool get isRunning => _isRunning;
}
