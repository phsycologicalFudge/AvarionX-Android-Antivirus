class AdsConfig {
  static bool enabled = bool.fromEnvironment(
    'ADS_ENABLED',
    defaultValue: false,
  );

  static const bool isTest = bool.fromEnvironment(
    'ADS_TEST',
    defaultValue: true,
  );

  static const String appId =
      'ca-app-pub-4198956812643415~8113061137';

  static const String bannerUnit =
      'ca-app-pub-4198956812643415/5695421984';

  static const String testBannerUnit =
      'ca-app-pub-3940256099942544/6300978111';
}
