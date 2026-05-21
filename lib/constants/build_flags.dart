const bool kEnableAds =
bool.fromEnvironment('ENABLE_ADS', defaultValue: true); // Legacy, will remove later.

const bool kGithubBuild =
bool.fromEnvironment('GITHUB_BUILD', defaultValue: false);