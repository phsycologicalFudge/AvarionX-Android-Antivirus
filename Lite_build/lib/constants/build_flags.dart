const bool kEnableAds =
bool.fromEnvironment('ENABLE_ADS', defaultValue: true);

class BuildFlags {
  static const bool isLiteBuild = bool.fromEnvironment('LIGHT_PORT', defaultValue: false);
  static const bool enablePasswordManager = !isLiteBuild;
  static const bool enableCleaner = !isLiteBuild;
  static const bool enableScheduledScans = !isLiteBuild;
  static const bool enableApkAnalyser = !isLiteBuild;
  static const bool enableLinkChecker = !isLiteBuild;
  static const bool enableTerminal = !isLiteBuild;
  static const bool enableQuarantine = !isLiteBuild;
  static const bool enableSecurityReport = !isLiteBuild;
  static const bool enableProFeatures = !isLiteBuild;
  static const bool enableCloudScanToggle = !isLiteBuild;
  static const bool enableSettings = !isLiteBuild;
  static const bool enableVpnIntegration = !isLiteBuild;
  static const bool enableShizukuRtp = !isLiteBuild;
}