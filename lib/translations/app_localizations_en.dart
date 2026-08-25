// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'AvarionX';

  @override
  String get ok => 'OK';

  @override
  String get cancel => 'Cancel';

  @override
  String get footerHome => 'Home';

  @override
  String get footerExplore => 'Explore';

  @override
  String get footerRemoved => 'Removed';

  @override
  String get footerSettings => 'Settings';

  @override
  String get proBadge => 'Premium';

  @override
  String get updateDbTitle => 'Updating Database';

  @override
  String updateDbVersionLabel(Object version) {
    return 'Version $version';
  }

  @override
  String get companionAppsSectionTitle => 'More from AvarionX';

  @override
  String get cleanerReclaimableLabel => 'Can be freed';

  @override
  String get exploreMultiThreadingTitle => 'Multi-Threading';

  @override
  String get exploreMultiThreadingSubtitle => 'Experimental engine control';

  @override
  String get updateDbAutoDownloadLabel =>
      'Automatically download future updates';

  @override
  String get updateDbUpdatedAutoOn => 'Database updated • Auto updates enabled';

  @override
  String get updateDbUpdatedSuccess => 'Database updated successfully';

  @override
  String get updateDbUpdateFailed => 'Database update failed';

  @override
  String get engineReadyBanner => 'VX-TITANIUM-v9';

  @override
  String get scanButton => 'Scan';

  @override
  String get scanModeFullTitle => 'Full Device Scan';

  @override
  String get scanModeFullSubtitle => 'Scans all readable storage files.';

  @override
  String get scanModeSmartTitle => 'Smart Scan [Recommended]';

  @override
  String get scanModeSmartSubtitle => 'Scans files that could contain malware.';

  @override
  String get scanModeRapidTitle => 'Rapid Scan';

  @override
  String get scanModeRapidSubtitle => 'Checks recent APKs in Downloads.';

  @override
  String get scanModeInstalledTitle => 'Installed Apps';

  @override
  String get scanModeInstalledSubtitle =>
      'Scans your installed apps for threats.';

  @override
  String get scanModeSingleTitle => 'File / App Scan';

  @override
  String get scanModeSingleSubtitle => 'Pick a file or app to scan.';

  @override
  String get useCloudAssistedScan => 'Use cloud-assisted scan';

  @override
  String get protectionTitle => 'Protection';

  @override
  String get stateOffLine1 => 'Device protection is off';

  @override
  String get stateOffLine2 => 'Tap to turn on';

  @override
  String get stateAdvancedActiveLine1 => 'Advanced protection is active';

  @override
  String get stateFileOnlyLine1 => 'File Protection active';

  @override
  String get stateFileOnlyLine2 => 'Network protection disabled';

  @override
  String get stateVpnConflictLine2 => 'Another VPN is active';

  @override
  String get stateProtectedLine1 => 'Device Protected';

  @override
  String get stateProtectedLine2 => 'Tap to turn off';

  @override
  String get dbUpdating => 'Database updating';

  @override
  String dbVersionAutoUpdated(Object version) {
    return 'Database v$version';
  }

  @override
  String get rtpInfoTitle => 'Realtime Protection';

  @override
  String get rtpInfoBody =>
      'Along with blocking suspicious files downloaded intentionally (or by malware), RTP uses a local VPN to block malicious domains system-wide.\n\nWhen enabled, network filtering remains active unless:\n• Disabled manually via Terminal\n• Replaced by another VPN\n\nFile protection continues regardless as long as RTP is enabled.';

  @override
  String get scanTitleDefault => 'Scan';

  @override
  String get scanTitleSmart => 'Smart Scan';

  @override
  String get scanTitleRapid => 'Rapid Scan';

  @override
  String get scanTitleInstalled => 'Scan Installed Apps';

  @override
  String get scanTitleFull => 'Full Device Scan';

  @override
  String get scanTitleSingle => 'Single Scan';

  @override
  String get cancellingScan => 'Cancelling scan…';

  @override
  String get cancelScan => 'Cancel Scan';

  @override
  String get scanProgressZero => 'Progress: 0%';

  @override
  String scanProgressWithPct(Object pct, Object scanned, Object total) {
    return 'Progress: $pct% ($scanned / $total)';
  }

  @override
  String scanProgressFullItems(Object count) {
    return 'Scanned: $count items';
  }

  @override
  String get initializing => 'Initializing...';

  @override
  String get scanningEllipsis => 'Scanning...';

  @override
  String get fullScanInfoTitle => 'Full Device Scan';

  @override
  String get fullScanInfoBody =>
      'This mode scans every readable file in storage, unfiltered.\n\nCloud-assisted scanning and app scanning are not used in this mode.';

  @override
  String get scanComplete => 'Scan Complete';

  @override
  String pillSuspiciousCount(Object count) {
    return 'Suspicious: $count';
  }

  @override
  String pillCleanCount(Object count) {
    return 'Clean: $count';
  }

  @override
  String pillScannedCount(Object count) {
    return 'Scanned: $count';
  }

  @override
  String get resultNoThreatsTitle => 'No threats detected';

  @override
  String get resultNoThreatsBody => 'No threats detected in scanned items.';

  @override
  String get resultSuspiciousAppsTitle => 'Suspicious apps';

  @override
  String get resultSuspiciousItemsTitle => 'Suspicious items';

  @override
  String get returnHome => 'Return Home';

  @override
  String get emptyTitle => 'No vulnerable files to scan';

  @override
  String get emptyBody =>
      'Your device did not contain any files matching the scan criteria.';

  @override
  String get knownMalware => 'Known malware';

  @override
  String get suspiciousActivityDetected => 'Suspicious activity detected';

  @override
  String get maliciousActivityDetected => 'Malicious activity detected';

  @override
  String get androidBankingTrojan => 'Android banking trojan';

  @override
  String get androidSpyware => 'Android spyware';

  @override
  String get androidAdware => 'Android adware';

  @override
  String get androidSmsFraud => 'Android SMS fraud';

  @override
  String get threatLevelConfirmed => 'Confirmed';

  @override
  String get threatLevelHigh => 'High';

  @override
  String get threatLevelMedium => 'Medium';

  @override
  String threatLevelLabel(Object level) {
    return 'Threat level: $level';
  }

  @override
  String get explainFoundInCloud =>
      'This item is listed in the ColourSwift cloud threat database.';

  @override
  String get explainFoundInOffline =>
      'This item is listed in the offline malware database on your device.';

  @override
  String get explainBanker =>
      'Designed to steal financial credentials, often using overlays, keylogging, or traffic interception.';

  @override
  String get explainSpyware =>
      'Silently monitors activity or collects personal data such as messages, location, or device identifiers.';

  @override
  String get explainAdware =>
      'Displays intrusive ads, performs redirects, or generates fraudulent ad traffic.';

  @override
  String get explainSmsFraud =>
      'Attempts to send or trigger SMS actions without consent, which can cause unexpected charges.';

  @override
  String get explainGenericMalware =>
      'Strong indicators of malicious intent were detected, even though it does not match a named family.';

  @override
  String get explainSuspiciousDefault =>
      'Indicators of suspicious behavior were detected. This can include abuse patterns seen in malware, but it may also be a false positive.';

  @override
  String get singleChoiceScanFile => 'Scan a file';

  @override
  String get singleChoiceScanInstalledApp => 'Scan an installed app';

  @override
  String get singleChoiceManageExclusions => 'Manage exclusions';

  @override
  String get labelKnownMalwareDb => 'Found in malware database';

  @override
  String get labelFoundInCloudDb => 'Found in cloud database';

  @override
  String get logEngineFullDeviceScan => '[ENGINE] Full device scan';

  @override
  String get logEngineTargetStorage => '[ENGINE] Target: /storage/emulated/0';

  @override
  String get logEngineNoFilesFound => '[ENGINE] No files found.';

  @override
  String logEngineFilesEnumerated(Object count) {
    return '[ENGINE] Files enumerated: $count';
  }

  @override
  String get logEngineNoReadableFilesFound =>
      '[ENGINE] No readable files found.';

  @override
  String logEngineInstalledAppsFound(Object count) {
    return '[ENGINE] Installed apps found: $count';
  }

  @override
  String get logModeCloudAssisted => '[MODE] Cloud-assisted mode';

  @override
  String get logModeOffline => '[MODE] Offline mode';

  @override
  String get logStageHashing => '[STAGE 1] Getting file hashes (cached)...';

  @override
  String get logStageCloudLookup => '[STAGE 2] Cloud hash lookup...';

  @override
  String logStageLocalScanning(Object stage) {
    return '[STAGE $stage] Local scanning files...';
  }

  @override
  String logCloudHashHits(Object count) {
    return '[CLOUD] $count hash hits';
  }

  @override
  String logSummary(Object suspicious, Object clean) {
    return '[SUMMARY] $suspicious suspicious • $clean clean';
  }

  @override
  String logErrorPrefix(Object message) {
    return '[ERROR] $message';
  }

  @override
  String get genericUnknownAppName => 'Unknown';

  @override
  String get genericUnknownFileName => 'Unknown';

  @override
  String get featuresDrawerTitle => 'Features';

  @override
  String get recommendedSectionTitle => 'Recommended';

  @override
  String get featureNetworkProtection => 'Network Protection';

  @override
  String get featureLinkChecker => 'Link Checker';

  @override
  String get featureMetaPass => 'MetaPass';

  @override
  String get featureCleanerPro => 'Cleaner Pro';

  @override
  String get featureTerminal => 'Terminal';

  @override
  String get featureScheduledScans => 'Scheduled Scans';

  @override
  String get networkStatusDisconnected => 'Disconnected';

  @override
  String get networkStatusConnecting => 'Connecting';

  @override
  String get networkStatusConnected => 'Connected';

  @override
  String get networkUsageTitle => 'Usage';

  @override
  String get networkUsageEnableVpnToView => 'Enable VPN to view usage.';

  @override
  String get networkUsageUnlimited => 'Unlimited';

  @override
  String networkUsageUsedOf(Object used, Object limit) {
    return '$used / $limit';
  }

  @override
  String networkUsageResetsOn(Object y, Object m, Object d) {
    return 'Resets on $y-$m-$d';
  }

  @override
  String networkUsageUpdatedAt(Object hh, Object mm) {
    return 'Updated $hh:$mm';
  }

  @override
  String get networkCardStatusAvailable => 'Available';

  @override
  String get networkCardStatusDisabled => 'Disabled';

  @override
  String get networkCardStatusCustom => 'Custom';

  @override
  String get networkCardStatusReady => 'Ready';

  @override
  String get networkCardStatusOpen => 'Open';

  @override
  String get networkCardStatusComingSoon => 'Coming soon';

  @override
  String get networkCardBlocklistsTitle => 'Blocklists';

  @override
  String get networkCardBlocklistsSubtitle => 'Filtering controls';

  @override
  String get networkCardUpstreamTitle => 'Upstream';

  @override
  String get networkCardUpstreamSubtitle => 'Resolver selection';

  @override
  String get networkCardAppsTitle => 'Apps';

  @override
  String get networkCardAppsSubtitle => 'Block apps on WiFi';

  @override
  String get networkCardLogsTitle => 'Logs';

  @override
  String get networkCardLogsSubtitle => 'Live DNS events';

  @override
  String get networkCardSpeedTitle => 'Speed';

  @override
  String get networkCardSpeedSubtitle => 'DNS test';

  @override
  String get networkCardAboutTitle => 'About';

  @override
  String get networkCardAboutSubtitle => 'GitHub';

  @override
  String get networkLogsStatusNoActivity => 'No activity';

  @override
  String networkLogsStatusRecent(Object count) {
    return '$count recent';
  }

  @override
  String get networkResolverTitle => 'Resolver';

  @override
  String get networkResolverIpLabel => 'Resolver IP';

  @override
  String get networkResolverIpHint => 'Example: 1.1.1.1';

  @override
  String get networkSpeedTestTitle => 'Speed test';

  @override
  String get networkSpeedTestBody =>
      'Runs a DNS speed tester using your current settings.';

  @override
  String get networkSpeedTestRun => 'Run speed test';

  @override
  String get networkBlocklistsRecommendedTitle => 'Recommended';

  @override
  String get networkBlocklistsCsMalwareTitle => 'ColourSwift Malware';

  @override
  String get networkBlocklistsCsAdsTitle => 'ColourSwift ads';

  @override
  String get networkBlocklistsSeeGithub => 'See GitHub for details...';

  @override
  String get networkBlocklistsMalwareSection => 'Malware';

  @override
  String get networkBlocklistsMalwareTitle => 'Malware blocklist';

  @override
  String get networkBlocklistsMalwareSources =>
      'HaGeZi TIF • URLHaus • DigitalSide • Spam404';

  @override
  String get networkBlocklistsAdsSection => 'Ads';

  @override
  String get networkBlocklistsAdsTitle => 'Ads blocklist';

  @override
  String get networkBlocklistsAdsSources =>
      'OISD • AdAway • Yoyo • AnudeepND • Firebog AdGuard';

  @override
  String get networkBlocklistsTrackersSection => 'Trackers';

  @override
  String get networkBlocklistsTrackersTitle => 'Trackers blocklist';

  @override
  String get networkBlocklistsTrackersSources =>
      'EasyPrivacy • Disconnect • Frogeye • Perflyst • WindowsSpyBlocker';

  @override
  String get networkBlocklistsGamblingSection => 'Gambling';

  @override
  String get networkBlocklistsGamblingTitle => 'Gambling blocklist';

  @override
  String get networkBlocklistsGamblingSources => 'HaGeZi Gambling';

  @override
  String get networkBlocklistsSocialSection => 'Social media';

  @override
  String get networkBlocklistsSocialTitle => 'Social media blocklist';

  @override
  String get networkBlocklistsSocialSources => 'HaGeZi Social';

  @override
  String get networkBlocklistsAdultSection => '18+';

  @override
  String get networkBlocklistsAdultTitle => 'Adult blocklist';

  @override
  String get networkBlocklistsAdultSources => 'StevenBlack 18+ • HaGeZi NSFW';

  @override
  String get networkLiveLogsTitle => 'Live logs';

  @override
  String get networkLiveLogsEmpty => 'No requests yet.';

  @override
  String get networkLiveLogsBlocked => 'Blocked';

  @override
  String get networkLiveLogsAllowed => 'Allowed';

  @override
  String get recommendedMetaPassDesc => 'Generate secure offline passwords.';

  @override
  String get recommendedCleanerProDesc =>
      'Find duplicates, old media, and unused apps to reclaim storage automatically.';

  @override
  String get recommendedLinkCheckerDesc =>
      'Check suspicious links with the safe view feature, risk free.';

  @override
  String get recommendedNetworkProtectionDesc =>
      'Keep your internet connection safe from malware.';

  @override
  String get recommendedTerminalDesc => 'An advanced feature for Shizuku';

  @override
  String get recommendedScheduledScansDesc => 'Automatic background scans.';

  @override
  String get metaPassTitle => 'MetaPass';

  @override
  String get metaPassHowItWorks => 'How MetaPass works';

  @override
  String get metaPassOk => 'OK';

  @override
  String get metaPassSettings => 'Settings';

  @override
  String get metaPassPoweredBy => 'powered by VX-TITANIUM';

  @override
  String get metaPassLoading => 'Loading…';

  @override
  String get metaPassEmptyTitle => 'No entries yet';

  @override
  String get metaPassEmptyBody =>
      'Add an app or website.\nPasswords are generated on-device from your secret meta password.';

  @override
  String get metaPassAddFirstEntry => 'Add first entry';

  @override
  String get metaPassTapToCopyHint => 'Tap to copy. Long-press to remove.';

  @override
  String get metaPassCopyTooltip => 'Copy password';

  @override
  String get metaPassAdd => 'Add';

  @override
  String get metaPassPickFromInstalledApps => 'Pick from installed apps';

  @override
  String get metaPassAddWebsiteOrLabel => 'Add website or custom label';

  @override
  String get metaPassSelectApp => 'Select an app';

  @override
  String get metaPassSearchApps => 'Search apps';

  @override
  String get metaPassCancel => 'Cancel';

  @override
  String get metaPassContinue => 'Continue';

  @override
  String get metaPassSave => 'Save';

  @override
  String get metaPassAddEntryTitle => 'Add entry';

  @override
  String get metaPassNameOrUrl => 'Name or URL';

  @override
  String get metaPassNameOrUrlHint => 'e.g. nextcloud, steam, example.com';

  @override
  String get metaPassVersion => 'Version';

  @override
  String get metaPassLength => 'Length';

  @override
  String get metaPassSetMetaTitle => 'Set Meta Password';

  @override
  String get metaPassSetMetaBody =>
      'Enter your meta password. It never leaves this device. All vault passwords rely on it.';

  @override
  String get metaPassMetaLabel => 'Meta password';

  @override
  String get metaPassRememberThisDevice =>
      'Remember for this device (stored securely)';

  @override
  String get metaPassChangingMetaWarning =>
      'Changing this later changes all generated passwords. Using the same meta password restores them.';

  @override
  String get metaPassRemoveEntryTitle => 'Remove entry';

  @override
  String metaPassRemoveEntryBody(Object label) {
    return 'Remove \"$label\" from your vault?';
  }

  @override
  String get metaPassRemove => 'Remove';

  @override
  String metaPassPasswordCopied(Object label, Object version, Object length) {
    return 'Password copied for $label (v$version, $length chars)';
  }

  @override
  String metaPassGenerateFailed(Object error) {
    return 'Failed to generate password: $error';
  }

  @override
  String metaPassLoadAppsFailed(Object error) {
    return 'Failed to load apps: $error';
  }

  @override
  String metaPassChars(Object length) {
    return '$length chars';
  }

  @override
  String metaPassVersionShort(Object version) {
    return 'v$version';
  }

  @override
  String get metaPassInfoBody =>
      'Passwords are never stored.\n\nEach entry derives a password from:\n• Your meta password\n• The label(name)\n• The version and length\n\nReinstalling the app with the same meta password and labels regenerates the same passwords.';

  @override
  String get passwordSettingsTitle => 'Password settings';

  @override
  String get passwordSettingsSectionMetaPass => 'MetaPass';

  @override
  String get passwordSettingsMetaPasswordTitle => 'Meta password';

  @override
  String get passwordSettingsMetaNotSet => 'Not set';

  @override
  String get passwordSettingsMetaStoredSecurely =>
      'Stored securely on this device';

  @override
  String get passwordSettingsChange => 'Change';

  @override
  String get passwordSettingsSetMetaPassTitle => 'Set MetaPass';

  @override
  String get passwordSettingsMetaPasswordLabel => 'Meta password';

  @override
  String get passwordSettingsChangingAltersAll =>
      'Changing this alters all passwords.\nUsing the same MetaPass restores them.';

  @override
  String get passwordSettingsCancel => 'Cancel';

  @override
  String get passwordSettingsSave => 'Save';

  @override
  String get passwordSettingsSectionRestoreCode => 'Restore code';

  @override
  String get passwordSettingsGenerateRestoreCode => 'Generate restore code';

  @override
  String get passwordSettingsCopy => 'Copy';

  @override
  String get passwordSettingsRestoreCodeCopied => 'Restore code copied';

  @override
  String get passwordSettingsSectionRestoreFromCode => 'Restore from code';

  @override
  String get passwordSettingsRestoreCodeLabel => 'Restore code';

  @override
  String get passwordSettingsRestore => 'Restore';

  @override
  String get passwordSettingsVaultRestored => 'Vault restored';

  @override
  String get passwordSettingsFooterInfo =>
      'Passwords are never stored.\n\nThe restore code contains only structure data. Combined with your MetaPass, it rebuilds your vault.';

  @override
  String get onboardingAppName => 'AVarionx Security';

  @override
  String get onboardingStorageTitle => 'Storage access';

  @override
  String get onboardingStorageDesc =>
      'This permission is required to scan files on your device. You can grant this now or later.';

  @override
  String get onboardingStorageFootnote =>
      'You can skip this, but you will be asked again when you choose a scan mode.';

  @override
  String get onboardingStorageSnack =>
      'Storage permission is required for scanning.';

  @override
  String get onboardingNotificationsTitle => 'Notifications';

  @override
  String get onboardingNotificationsDesc =>
      'Used for real time alerts, scan status, and quarantine updates.';

  @override
  String get onboardingNotificationsFootnote =>
      'Required by Android for RealTime Protection.';

  @override
  String get onboardingNetworkTitle => 'Network protection';

  @override
  String get onboardingNetworkDesc =>
      'Enables Wi Fi protection using Androids VPN permission.';

  @override
  String get onboardingNetworkFootnote => 'This is optional but recommended.';

  @override
  String get onboardingGranted => 'Granted';

  @override
  String get onboardingNotGranted => 'Not granted';

  @override
  String get onboardingGrantAccess => 'Grant access';

  @override
  String get onboardingAllowNotifications => 'Allow notifications';

  @override
  String get onboardingAllowVpnAccess => 'Allow VPN access';

  @override
  String get onboardingBack => 'Back';

  @override
  String get onboardingNext => 'Next';

  @override
  String get onboardingFinish => 'Finish';

  @override
  String get onboardingSetupCompleteTitle => 'Setup complete';

  @override
  String get onboardingSetupCompleteDesc =>
      'We reccomend running a Full Device Scan (this does not scan installed apps currently), or go straight to the home screen.';

  @override
  String get onboardingRunFullScan => 'Run full device scan';

  @override
  String get onboardingGoHome => 'Go to home';

  @override
  String get networkProtectionTitle => 'Network Protection';

  @override
  String networkStatusConnectedToDns(Object dns) {
    return 'Connected to $dns';
  }

  @override
  String get networkStatusVpnConflictDetail => 'Another VPN is active';

  @override
  String get networkStatusOffDetail => 'Network protection is off';

  @override
  String get networkModeMalwareTitle => 'Malware Blocking Only';

  @override
  String get networkModeMalwareSubtitle => 'Uses 1.1.1.2';

  @override
  String get networkModeMalwareDescription =>
      'Combines AvarionX’s local malware database with Cloudflare’s online threat intelligence for maximum malware protection.';

  @override
  String get networkModeAdultTitle => 'Malware & Adult Content';

  @override
  String get networkModeAdultSubtitle => 'Uses 1.1.1.3';

  @override
  String get networkModeAdultDescription =>
      'Uses AvarionX’s offline malware database and adds adult content filtering. Cloud-based malware intelligence is disabled in this mode.';

  @override
  String get networkInfoTitle => 'What is Network Protection?';

  @override
  String get networkInfoBody =>
      'Some threats work by connecting to malicious servers or redirecting internet traffic.\nNetwork Protection blocks known dangerous domains and common ads by using a local VPN.\n\nAVarionX Security does not collect any data.';

  @override
  String get linkCheckerTitle => 'Link Checker';

  @override
  String get linkCheckerTabAnalyse => 'Analyse';

  @override
  String get linkCheckerTabView => 'View';

  @override
  String get linkCheckerTabHistory => 'History';

  @override
  String get linkCheckerAnalyseSubtitle =>
      'Check page for malware or suspicious content';

  @override
  String get linkCheckerUrlLabel => 'URL';

  @override
  String get linkCheckerUrlHint => 'https://example.com';

  @override
  String get linkCheckerButtonAnalyse => 'Analyse';

  @override
  String get linkCheckerButtonChecking => 'Checking';

  @override
  String get linkCheckerEngineNotReadySnack => 'Engine not ready';

  @override
  String get linkCheckerStatusVerifyingLink => 'Verifying link…';

  @override
  String get linkCheckerStatusScanningPage => 'Scanning page…';

  @override
  String get linkCheckerBlockedNavigation => 'Navigation blocked';

  @override
  String get linkCheckerBlockedUnsupportedType => 'Unsupported link type';

  @override
  String get linkCheckerBlockedInvalidDestination => 'Invalid destination';

  @override
  String get linkCheckerBlockedUnableResolve => 'Unable to resolve destination';

  @override
  String get linkCheckerBlockedUnableVerify => 'Unable to verify destination';

  @override
  String get linkCheckerAnalyseCardTitleDefault =>
      'Check page for suspicious content';

  @override
  String get linkCheckerAnalyseCardDetailDefault =>
      'Paste a URL and run an analysis.';

  @override
  String get linkCheckerAnalyseCardTitleEngineNotReady => 'Engine not ready';

  @override
  String get linkCheckerAnalyseCardDetailEngineNotReady => 'error 1001.';

  @override
  String get linkCheckerAnalyseCardTitleChecking => 'Checking';

  @override
  String get linkCheckerVerdictClean => 'Clean';

  @override
  String get linkCheckerVerdictCleanDetail => 'This page appears to be safe.';

  @override
  String get linkCheckerVerdictSuspicious => 'Suspicious';

  @override
  String get linkCheckerVerdictSuspiciousDetail =>
      'This page contains suspicious content.';

  @override
  String get linkCheckerViewLockedBody =>
      'Run an analysis first to enable viewing.';

  @override
  String get linkCheckerViewSubtitle => 'View the webpage safely';

  @override
  String get linkCheckerViewPage => 'View page';

  @override
  String get linkCheckerClose => 'Close';

  @override
  String get linkCheckerBlockedBody =>
      'This page was stopped before it could load.';

  @override
  String get linkCheckerSuspiciousBanner =>
      'Suspicious link, may not render if it requires blocked content.';

  @override
  String get linkCheckerHistorySubtitle => 'Tap an entry to copy the link.';

  @override
  String get linkCheckerHistoryEmpty => 'No checks yet.';

  @override
  String get linkCheckerCopied => 'Copied';

  @override
  String get settingsSectionAppearance => 'Appearance';

  @override
  String get settingsTheme => 'Theme';

  @override
  String settingsThemeCurrent(Object theme) {
    return 'Current: $theme';
  }

  @override
  String get settingsLanguage => 'Language';

  @override
  String settingsLanguageCurrent(Object language) {
    return 'Current: $language';
  }

  @override
  String get settingsChooseLanguage => 'Choose Language';

  @override
  String get settingsLanguageApplied => 'Language applied';

  @override
  String get settingsSystemDefault => 'System default';

  @override
  String get settingsSectionCommunity => 'Join the community!';

  @override
  String get settingsDiscord => 'Discord';

  @override
  String get settingsDiscordSubtitle => 'Chat, updates and feedback';

  @override
  String get settingsDiscordOpenFail => 'Unable to open Discord link';

  @override
  String get settingsSectionPro => 'PRO Features';

  @override
  String get settingsProCustomization => 'PRO Customization';

  @override
  String get settingsProSubtitle =>
      'Go ad free, unlock unlimited DNS, themes and icons';

  @override
  String get settingsUnlockPro => 'Unlock Premium';

  @override
  String get settingsProUnlocked => 'PRO mode unlocked';

  @override
  String get settingsPurchaseNotConfirmed => 'Purchase not confirmed';

  @override
  String settingsPurchaseFailed(Object error) {
    return 'Purchase failed: $error';
  }

  @override
  String get homeUpgrade => 'Upgrade';

  @override
  String get homeFeatureSecureVpnTitle => 'AvarionX Secure VPN';

  @override
  String get homeFeatureSecureVpnDesc => 'Hide your IP and block unwanted ads';

  @override
  String get proActivated => 'PRO activated';

  @override
  String get proDeactivated => 'PRO deactivated';

  @override
  String get settingsProReset => 'PRO reset (debug only)';

  @override
  String get settingsProSheetTitle => 'PRO Customization';

  @override
  String get settingsHideGoldHeader =>
      'Show gold header on Home Screen (dark themes)';

  @override
  String get settingsAppIcon => 'App Icon';

  @override
  String settingsIconSelected(Object icon) {
    return 'Icon selected: $icon';
  }

  @override
  String get vpnSignInRequiredTitle => 'Sign in required';

  @override
  String get vpnClose => 'Close';

  @override
  String get vpnSignInRequiredBody => 'Sign in to use Secure VPN.';

  @override
  String get vpnCancel => 'Cancel';

  @override
  String get vpnSignIn => 'Sign in';

  @override
  String get vpnUsageLoading => 'Loading usage...';

  @override
  String get vpnUsageNoLimits => 'No data limits';

  @override
  String get vpnUsageSyncing => 'Syncing';

  @override
  String vpnUsageUsedThisMonth(Object used) {
    return '$used used this month';
  }

  @override
  String get vpnUsageDataTitle => 'Data Usage';

  @override
  String get vpnUsageUnavailable => 'Usage unavailable';

  @override
  String get vpnStatusConnectingEllipsis => 'Connecting...';

  @override
  String vpnStatusConnectedTo(Object country) {
    return 'Connected to $country';
  }

  @override
  String get vpnTitleSecure => 'Secure VPN';

  @override
  String get vpnStatusConnected => 'Connected';

  @override
  String get vpnSubtitleEstablishingTunnel => 'Establishing tunnel...';

  @override
  String get vpnSubtitleFindingLocation => 'Finding location...';

  @override
  String get vpnStatusProtected => 'Protected';

  @override
  String get vpnStatusNotConnected => 'Not connected';

  @override
  String get vpnConnect => 'Connect';

  @override
  String get vpnDisconnect => 'Disconnect';

  @override
  String vpnIpLabel(Object ip) {
    return 'IP: $ip';
  }

  @override
  String vpnServerLoadLabel(Object current, Object max) {
    return '$current/$max';
  }

  @override
  String get vpnBlocklistsTitle => 'Secure VPN Blocklists';

  @override
  String get vpnSave => 'Save';

  @override
  String get settingsSave => 'Save';

  @override
  String get settingsPremium => 'Premium';

  @override
  String get settingsUltimateSecurity => 'Ultimate Security';

  @override
  String get settingsSwitchPlan => 'Switch plan';

  @override
  String get settingsBestValue => 'Best value';

  @override
  String get settingsOneTime => 'One time';

  @override
  String get settingsPlanPriceLoading => 'Price loading...';

  @override
  String get settingsMonthly => 'Monthly';

  @override
  String get settingsYearly => 'Yearly';

  @override
  String get settingsLifetime => 'Lifetime';

  @override
  String get settingsSubscribeMonthly => 'Subscribe monthly';

  @override
  String get settingsSubscribeYearly => 'Subscribe yearly';

  @override
  String get settingsUnlockLifetime => 'Unlock lifetime';

  @override
  String get settingsProBenefitsTitle => 'Benefits';

  @override
  String get settingsUnlimitedDnsTitle => 'Unlimited DNS queries';

  @override
  String get settingsUnlimitedDnsBody =>
      'Remove query limits and unlock full cloud filtering.';

  @override
  String get settingsThemesTitle => 'Themes';

  @override
  String get settingsThemesBody => 'Unlock premium themes and customization.';

  @override
  String get settingsIconCustomizationTitle => 'App icon customization';

  @override
  String get settingsIconCustomizationBody =>
      'Change the app icon to match your style.';

  @override
  String get settingsScheduledScansTitle => 'Scheduled scans';

  @override
  String get settingsScheduledScansBody =>
      'Unlock advanced scheduling and scan customization.';

  @override
  String get settingsProFinePrint =>
      'Subscriptions renew unless canceled. You can manage or cancel anytime in Google Play. Lifetime is a one time purchase.';

  @override
  String get settingsSectionShizuku => 'Advanced Protection (Shizuku)';

  @override
  String get settingsEnableShizuku => 'Enable Shizuku';

  @override
  String get settingsShizukuRequiresManager => 'Requires external manager';

  @override
  String get settingsShizukuNotRunning => 'Shizuku service not running';

  @override
  String get settingsShizukuPermissionRequired => 'Permission required';

  @override
  String get settingsShizukuAvailable => 'Advanced system access available';

  @override
  String get settingsAboutAdvancedProtection => 'About Advanced Protection';

  @override
  String get settingsAboutAdvancedProtectionSubtitle =>
      'Learn how advanced protection works';

  @override
  String get settingsAdvancedProtectionDialogTitle =>
      'Advanced system Protection';

  @override
  String get settingsAdvancedProtectionDialogBody =>
      'Shizuku access requires an external manager intended for advanced users.\n\nThis feature is optional and not recommended for casual protection.';

  @override
  String get settingsAboutShizukuTitle => 'About Shizuku';

  @override
  String get settingsAboutShizukuBody =>
      'AVarionX can integrate with Shizuku to access app processes at the system level.\n\nThis allows the app to:\n• Detect malware that hides from standard scanners\n• Inspect running app processes\n• Disable or contain most active malware\n\nShizuku however, does not grant root access\n\nThis feature is intended for advanced users and is not required for normal protection.\n\nDocumentation:\nhttps://shizuku.rikka.app';

  @override
  String get settingsSectionGeneral => 'General';

  @override
  String get settingsExclusions => 'Exclusions';

  @override
  String get settingsExclusionsSubtitle => 'Manage and add exclusions';

  @override
  String get settingsExcludeFolder => 'Exclude a Folder';

  @override
  String get settingsExcludeFile => 'Exclude a File';

  @override
  String get settingsManageExclusions => 'Manage Existing Exclusions';

  @override
  String get settingsManageExclusionsSubtitle => 'View or remove exclusions';

  @override
  String get settingsFolderExcluded => 'Folder excluded';

  @override
  String get settingsFileExcluded => 'File excluded';

  @override
  String get settingsPrivacyPolicy => 'Privacy Policy';

  @override
  String get settingsPrivacyPolicySubtitle => 'View how your data is handled';

  @override
  String get settingsPrivacyPolicyOpenFail => 'Unable to open privacy policy';

  @override
  String get settingsAboutApp => 'About AVarionX';

  @override
  String get settingsHowThisAppWorks => 'How This App Works';

  @override
  String get settingsHowThisAppWorksSubtitle => 'Learn about protection';

  @override
  String get settingsThemePickerTitle => 'Choose Theme';

  @override
  String get settingsThemeRequiresPro => 'That theme requires PRO mode';

  @override
  String get scheduledScansTitle => 'Scheduled Scans';

  @override
  String get scheduledScansInfoTitle => 'Scheduled Scans';

  @override
  String get scheduledScansInfoBody =>
      'While RTP focuses on downloaded malware, Scheduled Scans will automatically launch your chosen scan mode in the background.\nIt will only run while RTP is enabled.\n\nPRO users can customize scan mode and frequency.';

  @override
  String get scheduledScansHeader => 'Automatic background scans';

  @override
  String get scheduledScansSubheader =>
      'While RTP is active, the app will scan your device based on the selected scan mode and frequency.';

  @override
  String get proRequiredToCustomize => 'PRO required to customize';

  @override
  String get scheduledScansEnabledTitle => 'Enabled';

  @override
  String get scheduledScansEnabledSubtitle =>
      'When enabled, a scan runs automatically on your chosen schedule.';

  @override
  String get scheduledScansModeTitle => 'Scan mode';

  @override
  String scheduledScansModeHint(Object mode) {
    return 'Current mode: $mode';
  }

  @override
  String get scheduledScansFrequencyTitle => 'Frequency';

  @override
  String scheduledScansFrequencyHint(Object freq) {
    return 'Runs: $freq';
  }

  @override
  String get scheduledEveryDay => 'Every day';

  @override
  String get scheduledEvery3Days => 'Every 3 days';

  @override
  String get scheduledEveryWeek => 'Every week';

  @override
  String get scheduledEvery2Weeks => 'Every 2 weeks';

  @override
  String get scheduledEvery3Weeks => 'Every 3 weeks';

  @override
  String get scheduledMonthly => 'Monthly';

  @override
  String scheduledEveryDays(Object days) {
    return 'Every $days days';
  }

  @override
  String scheduledEveryHours(Object hours) {
    return 'Every $hours hours';
  }

  @override
  String get vpnSettingsPrivacySecurityTitle => 'Privacy & Security';

  @override
  String get vpnSettingsNoLogsPolicyTitle => 'No logs stored Policy';

  @override
  String get vpnSettingsNoLogsPolicyBody =>
      'No logs are stored. Connection activity, browsing activity, DNS queries, and traffic content are not recorded or retained.';

  @override
  String get vpnSettingsNoActivityLogsTitle => 'No activity logs';

  @override
  String get vpnSettingsNoActivityLogsBody =>
      'Your activity is not monitored or tracked while using Secure VPN.';

  @override
  String get vpnSettingsWireGuardTitle => 'VX-Link powered by WireGuard';

  @override
  String get vpnSettingsWireGuardBody =>
      'Secure VPN uses the WireGuard protocol through VX-Link to provide fast, modern encryption.';

  @override
  String get vpnSettingsMalwareProtectionTitle => 'Malware protection enabled';

  @override
  String get vpnSettingsMalwareProtectionBody =>
      'Malicious domains are blocked by default while connected.';

  @override
  String get vpnSettingsAdTrackerProtectionTitle =>
      'Optional ad and tracker protection';

  @override
  String get vpnSettingsAdTrackerProtectionBody =>
      'Enable additional blocking for ads and trackers in the Customisation tab.';

  @override
  String get vpnSettingsBrandFooter => 'Secured by VX-Link';

  @override
  String get vpnSettingsAccountTitle => 'Account';

  @override
  String get vpnSettingsSignInToContinue => 'Sign in to continue';

  @override
  String get vpnSettingsAccountSyncBody =>
      'Your plan and data usage sync to your account.';

  @override
  String get vpnSettingsSignedIn => 'Signed in';

  @override
  String get vpnSettingsPlanUnknown => 'Plan: unknown';

  @override
  String vpnSettingsPlanLabel(Object plan) {
    return 'Plan: $plan';
  }

  @override
  String get vpnSettingsRefresh => 'Refresh';

  @override
  String get vpnSettingsSignOut => 'Sign out';

  @override
  String get scheduledChargingOnlyTitle => 'Only when charging';

  @override
  String get scheduledChargingOnlySubtitle =>
      'Run the scheduled scan only while the device is plugged in.';

  @override
  String get scheduledPreferredTimeTitle => 'Preferred time';

  @override
  String get scheduledPreferredTimeSubtitle =>
      'AVarionX will aim to start around this time. Android may delay it to save battery.';

  @override
  String get scheduledPickTime => 'Pick time';

  @override
  String get cleanerTitle => 'Cleaner Pro';

  @override
  String get cleanerReadyToScan => 'Ready to Scan';

  @override
  String get cleanerScan => 'Scan';

  @override
  String get cleanerScanning => 'Scanning…';

  @override
  String get cleanerReady => 'Ready';

  @override
  String get cleanerStatusReady => 'Ready';

  @override
  String get cleanerStatusStarting => 'Starting…';

  @override
  String get cleanerStatusFilesScanned => 'Files scanned';

  @override
  String get cleanerStatusFindingUnusedApps => 'Finding unused apps…';

  @override
  String get cleanerStatusComplete => 'Complete';

  @override
  String get cleanerStatusScanError => 'Scan error';

  @override
  String get cleanerStatusScanningApps => 'Scanning apps…';

  @override
  String get cleanerGrantUsageAccessTitle => 'Grant Usage Access';

  @override
  String get cleanerGrantUsageAccessBody =>
      'To detect unused apps, this cleaner requires Usage Access permission. You’ll be redirected to system settings to enable it.';

  @override
  String get cleanerCancel => 'Cancel';

  @override
  String get cleanerContinue => 'Continue';

  @override
  String get cleanerDuplicates => 'Duplicates';

  @override
  String get cleanerDuplicatesNone => 'No duplicates found';

  @override
  String cleanerDuplicatesSubtitle(Object count, Object size) {
    return '$count items • reclaim $size';
  }

  @override
  String get cleanerOldPhotos => 'Old Photos';

  @override
  String cleanerOldPhotosNone(Object days) {
    return 'No photos older than $days days';
  }

  @override
  String cleanerOldPhotosSubtitle(Object count, Object size) {
    return '$count items • $size';
  }

  @override
  String get cleanerOldVideos => 'Old Videos';

  @override
  String cleanerOldVideosNone(Object days) {
    return 'No videos older than $days days';
  }

  @override
  String cleanerOldVideosSubtitle(Object count, Object size) {
    return '$count items • $size';
  }

  @override
  String get cleanerLargeFiles => 'Large Files';

  @override
  String cleanerLargeFilesNone(Object size) {
    return 'No files ≥ $size';
  }

  @override
  String cleanerLargeFilesSubtitle(Object count, Object sizeTotal) {
    return '$count items • $sizeTotal';
  }

  @override
  String get cleanerUnusedApps => 'Unused Apps';

  @override
  String cleanerUnusedAppsNone(Object days) {
    return 'No unused apps (last $days days)';
  }

  @override
  String cleanerUnusedAppsCount(Object count) {
    return '$count apps';
  }

  @override
  String get cleanerStageDuplicates => 'Scanning duplicates…';

  @override
  String get cleanerStageDuplicatesGrouping => 'Grouping duplicates…';

  @override
  String get cleanerStageOldPhotos => 'Scanning old photos…';

  @override
  String get cleanerStageOldVideos => 'Scanning old videos…';

  @override
  String get cleanerStageLargeFiles => 'Scanning large files…';

  @override
  String cleanerStageOldPhotosProgress(Object count, Object size) {
    return 'Old photos: $count • $size';
  }

  @override
  String get vpnAccountScreenTitle => 'Account';

  @override
  String get vpnAccountSignInRequiredTitle => 'Sign in required';

  @override
  String get vpnAccountSignInManageUsageBody =>
      'Sign in to manage your account and usage.';

  @override
  String get vpnAccountNotSignedIn => 'Not signed in';

  @override
  String get vpnAccountFree => 'Free';

  @override
  String get vpnAccountUnknown => 'Unknown';

  @override
  String get vpnAccountStatusSyncing => 'Syncing';

  @override
  String get vpnAccountStatusActive => 'Active';

  @override
  String get vpnAccountStatusConnected => 'Connected';

  @override
  String get vpnAccountStatusDisconnected => 'Disconnected';

  @override
  String get vpnAccountStatusUnavailable => 'Unavailable';

  @override
  String get vpnAccountStatusConnectedNow => 'Connected now';

  @override
  String get vpnAccountStatusRefreshToLoadServer =>
      'Refresh to load server status';

  @override
  String get vpnAccountUsageTitle => 'Usage';

  @override
  String get vpnAccountUsageLoading => 'Loading usage...';

  @override
  String get vpnAccountUsageSignInToSync => 'Sign in to sync usage';

  @override
  String get vpnAccountUsagePullToRefresh => 'Pull to refresh to sync usage';

  @override
  String get vpnAccountUsageUnlimited => 'Unlimited';

  @override
  String vpnAccountUsageUsedThisMonth(Object used) {
    return '$used used this month';
  }

  @override
  String vpnAccountUsageUsedThisMonthUnlimited(Object used) {
    return '$used used this month, unlimited';
  }

  @override
  String vpnAccountUsageUsedOfLimit(Object used, Object limit) {
    return '$used / $limit';
  }

  @override
  String get settingsSectionAccount => 'Account';

  @override
  String get settingsAccountTitle => 'Account';

  @override
  String get settingsAccountSubtitle =>
      'Sign in, plan, subscription, and account usage';

  @override
  String get exploreSecureVpnTitle => 'Secure VPN';

  @override
  String get exploreSecureVpnSubtitle =>
      'Hide your IP and block unwanted content';

  @override
  String get vpnAccountServerLoadTitle => 'Selected Server Load';

  @override
  String vpnAccountServerConnectedCount(Object connected, Object cap) {
    return '$connected/$cap';
  }

  @override
  String get networkDnsOffTitle => 'Switch to DNS filtering?';

  @override
  String get networkDnsOffInfoTitle => 'What is DNS filtering?';

  @override
  String get networkDnsOffInfoBody1 =>
      'DNS filtering is separate from Secure VPN. It can block known malware, ads across apps, trackers, and unwanted categories before they load.';

  @override
  String get networkDnsOffInfoBody2 =>
      'It does not encrypt your traffic or hide your IP.';

  @override
  String get networkDnsOffEnableButton => 'Enable DNS Filtering';

  @override
  String vpnAccountServerConnectedCountWithLabel(Object connected, Object cap) {
    return '$connected/$cap connected';
  }

  @override
  String get vpnAccountIdentityFallbackTitle => 'Account';

  @override
  String get vpnAccountMembershipLabel => 'Membership';

  @override
  String get vpnAccountMembershipFounderVpnPro => 'Founders · VPN Pro';

  @override
  String get vpnAccountMembershipFounder => 'Founder';

  @override
  String get vpnAccountMembershipPro => 'Pro';

  @override
  String get vpnAccountSectionAccountStatus => 'Account Status';

  @override
  String get vpnAccountSectionActions => 'Actions';

  @override
  String get vpnAccountKvStatus => 'Status';

  @override
  String get vpnAccountKvPlan => 'Plan';

  @override
  String get vpnAccountKvUsage => 'Usage';

  @override
  String get vpnAccountKvSelectedServer => 'Selected Server';

  @override
  String get vpnAccountKvConnectionState => 'Connection State';

  @override
  String get vpnAccountActionRefresh => 'Refresh';

  @override
  String get vpnAccountActionOpen => 'Open';

  @override
  String get vpnAccountFounderThanks => 'Thank you for supporting ColourSwift';

  @override
  String get vpnAccountFounderNote =>
      'I\'m just one guy, held by the greatest community.';

  @override
  String cleanerStageOldVideosProgress(Object count, Object size) {
    return 'Old videos: $count • $size';
  }

  @override
  String cleanerStageLargeFilesProgress(Object count, Object size) {
    return 'Large files: $count • $size';
  }

  @override
  String get unusedAppsTitle => 'Unused Apps';

  @override
  String unusedAppsEmpty(Object days) {
    return 'No unused apps in last $days days';
  }

  @override
  String get quarantineTitle => 'Removed';

  @override
  String get quarantineSelectAll => 'Select all';

  @override
  String get quarantineRefresh => 'Refresh';

  @override
  String get quarantineEmptyTitle => 'No removed files';

  @override
  String get quarantineEmptyBody => 'Anything you remove will show up here.';

  @override
  String get quarantineRestore => 'Restore';

  @override
  String get quarantineDelete => 'Delete';

  @override
  String get quarantineSnackRestored => 'Restored';

  @override
  String get quarantineSnackDeleted => 'Deleted';

  @override
  String get quarantineDeleteDialogTitle => 'Delete selected files?';

  @override
  String quarantineDeleteDialogBody(Object count, String plural) {
    return 'This will permanently delete $count item$plural.';
  }

  @override
  String get howThisAppWorksHowAvarionXWorks => 'How AvarionX Works';

  @override
  String get howThisAppWorksAvarionxIsAMobileSecurityAppThat =>
      'AvarionX is a mobile security app that combines on device antivirus scanning, network protection, and optional VPN features. ';

  @override
  String get howThisAppWorksTheAntivirusEngineIsPoweredByVX =>
      'The antivirus engine is powered by VX-Titanium.';

  @override
  String get howThisAppWorksIfYouUseNetworkProtectionOrVPN =>
      'If you use network protection or VPN features, the app connects to ColourSwift services to apply your settings, manage your account access, and route protected traffic.';

  @override
  String get howThisAppWorksKeyFeatures => 'Key Features';

  @override
  String get howThisAppWorksRealTimeProtectionForDownloadedThreats =>
      '• Real-time protection for downloaded threats';

  @override
  String get howThisAppWorksNetworkProtectionWithDNSFiltering =>
      '• Network protection with DNS filtering';

  @override
  String get howThisAppWorksOptionalSecureVPNMode =>
      '• Optional Secure VPN mode';

  @override
  String get howThisAppWorksBuiltInToolsSuchAsLinkChecker =>
      '• Built in tools such as Link Checker';

  @override
  String get howThisAppWorksNotes => 'Notes';

  @override
  String get howThisAppWorksSomeFeaturesMayRequireSignInAn =>
      'Some features may require sign in, an active plan, or device permissions to work properly.';

  @override
  String get apkAnalyserCopyCurrentReport => 'Copy Current Report';

  @override
  String get apkAnalyserReportCopiedToClipboard => 'Report copied to clipboard';

  @override
  String get apkAnalyserExportCurrentAsPDF => 'Export Current as PDF';

  @override
  String get apkAnalyserFailedToExportPDF => 'Failed to export PDF';

  @override
  String get apkAnalyserExportCurrentAsCSV => 'Export Current as CSV';

  @override
  String get apkAnalyserFailedToExportCSV => 'Failed to export CSV';

  @override
  String get apkAnalyserViewSavedReports => 'View Saved Reports';

  @override
  String get apkAnalyserClearHistory => 'Clear History';

  @override
  String get apkAnalyserReportHistoryCleared => 'Report history cleared';

  @override
  String get apkAnalyserSavedReports => 'Saved Reports';

  @override
  String get apkAnalyserNoSavedReportsFound => 'No saved reports found.';

  @override
  String get apkAnalyserChooseTarget => 'Choose Target';

  @override
  String get apkAnalyserSelectASourceToAnalyseWithVTTI =>
      'Select a source to analyse with VTTI Cloud.';

  @override
  String get apkAnalyserApkFile => 'APK File';

  @override
  String get apkAnalyserPickAnApkFromStorage => 'Pick an .apk from storage';

  @override
  String get apkAnalyserInstalledApp => 'Installed App';

  @override
  String get apkAnalyserChooseFromAppsOnThisDevice =>
      'Choose from apps on this device';

  @override
  String apkAnalyserAnalysingIn(Object countdown) {
    return 'Analysing in $countdown...';
  }

  @override
  String get apkAnalyserStartingAnalysis => 'Starting analysis...';

  @override
  String get apkAnalyserApkFileOrInstalledApp => 'APK file or installed app';

  @override
  String get apkAnalyserDeepAnalysisMode => 'Deep analysis mode';

  @override
  String get apkAnalyserAMoreComplexAnalysisUsingGlobalData =>
      'A more complex analysis using global data sources';

  @override
  String get apkAnalyserRequiresProToUnlockDeeperAnalysis =>
      'Requires Pro to unlock deeper analysis';

  @override
  String get apkAnalyserApkAnalyser => 'APK Analyser';

  @override
  String get apkAnalyserPleaseSignInViaSettingsToEnable =>
      'Please sign in via Settings to enable Cloud Analysis.';

  @override
  String get apkAnalyserAdvancedOPTIONS => 'ADVANCED OPTIONS';

  @override
  String apkAnalyserDailyLimit(Object remaining, Object limit) {
    return 'Daily Limit: $remaining / $limit';
  }

  @override
  String get apkAnalyserDailyLimitDataUnavailable =>
      'Daily Limit Data Unavailable';

  @override
  String get apkAnalyserPoweredByVTTICloud => 'Powered by VTTI Cloud';

  @override
  String get apkAnalyserSearchApps => 'Search apps...';

  @override
  String get apkAnalyserFailedToLoadApps => 'Failed to load apps.';

  @override
  String get apkAnalyserNoAppsFound => 'No apps found.';

  @override
  String get apkReportSummary => 'Summary';

  @override
  String get apkReportPermissions => 'Permissions';

  @override
  String get apkReportExtraFlags => 'Extra Flags';

  @override
  String get apkReportRiskSignals => 'Risk Signals';

  @override
  String get apkReportSources => 'Sources';

  @override
  String get apkReportMetadata => 'Metadata';

  @override
  String get apkReportCopyReport => 'Copy Report';

  @override
  String get apkReportReportCopiedToClipboard => 'Report copied to clipboard';

  @override
  String get apkReportExportAsPDF => 'Export as PDF';

  @override
  String get apkReportFailedToExportPDF => 'Failed to export PDF';

  @override
  String get apkReportExportAsCSV => 'Export as CSV';

  @override
  String get apkReportFailedToExportCSV => 'Failed to export CSV';

  @override
  String get apkReportAnalysisReport => 'Analysis Report';

  @override
  String get apkReportMalwareRisk => 'Malware Risk';

  @override
  String get apkReportNoSummaryGenerated => 'No summary generated.';

  @override
  String get apkReportNoRequestedPermissionsExtracted =>
      'No requested permissions extracted.';

  @override
  String get apkReportContributing => 'Contributing';

  @override
  String get apkReportDampening => 'Dampening';

  @override
  String get bootOptimisingYourProtection => 'Optimising your protection';

  @override
  String get exclusionsFolders => 'Folders';

  @override
  String get exclusionsNone => 'None';

  @override
  String get exclusionsFiles => 'Files';

  @override
  String get exploreApkAnalyser => 'APK Analyser';

  @override
  String get exploreCreateADetailedAnalysisOnAnyAPK =>
      'Create a detailed analysis on any APK';

  @override
  String get featuresComingSoon => 'Coming Soon';

  @override
  String get featuresWantToLearnMore => 'Want to learn more?';

  @override
  String get homeDrawerApkAnalyser => 'APK Analyser';

  @override
  String get homeDrawerAdvanced => 'Advanced';

  @override
  String get homeDrawerQuarantine => 'Quarantine';

  @override
  String get homeDrawerUpgradeToPro => 'Upgrade to Pro';

  @override
  String get homeDrawerAvarionxVPN => 'AvarionX VPN';

  @override
  String get homeDrawerProtectYourInternetWithOurUnlimitedVPN =>
      'Protect your internet with our unlimited VPN';

  @override
  String get deviceSecurityDeviceSecurity => 'Device Security';

  @override
  String get deviceSecurityDeviceHealthStatus => 'Device health status';

  @override
  String get deviceSecurityDeviceSecurityRecommendations =>
      'Device security recommendations';

  @override
  String get deviceSecurityStopIgnoring => 'Stop ignoring';

  @override
  String get deviceSecurityIgnoreCheck => 'Ignore check';

  @override
  String get deviceSecurityNoScreenLock => 'No Screen Lock';

  @override
  String get deviceSecurityAMissingSecureLockMakesLocalAccess =>
      'A missing secure lock makes local access easier.';

  @override
  String get deviceSecurityRootShizukuActive => 'Root/Shizuku Active';

  @override
  String get deviceSecurityRootOrShizukuCanGrantPowerfulDevice =>
      'Root or Shizuku can grant powerful device control.';

  @override
  String get deviceSecurityDisabledAppVerification =>
      'Disabled App Verification';

  @override
  String get deviceSecurityAppVerificationHelpsDetectHarmfulInstalls =>
      'App verification helps detect harmful installs.';

  @override
  String get deviceSecurityOldAndroidSecurityPatch =>
      'Old Android Security Patch';

  @override
  String get deviceSecurityOlderPatchLevelsMayLeaveKnownIssues =>
      'Older patch levels may leave known issues unpatched.';

  @override
  String get deviceSecurityDeveloperModeOn => 'Developer Mode On';

  @override
  String get deviceSecurityDeveloperOptionsExposeAdvancedDeviceControls =>
      'Developer options expose advanced device controls.';

  @override
  String get deviceSecurityUsbDebuggingOn => 'USB Debugging On';

  @override
  String get deviceSecurityUsbDebuggingAllowsADBControlFromTrusted =>
      'USB debugging allows ADB control from trusted computers.';

  @override
  String get deviceSecurityUnknownSourcesAllowed => 'Unknown Sources Allowed';

  @override
  String get deviceSecuritySideloadingCanBypassNormalAppStoreChecks =>
      'Sideloading can bypass normal app store checks.';

  @override
  String get deviceSecurityAccessibilityAbuseRisk => 'Accessibility Abuse Risk';

  @override
  String get deviceSecurityAccessibilityServicesCanReadAndControlScreen =>
      'Accessibility services can read and control screen actions.';

  @override
  String get homeHelpImproveDetectionsForEverybody =>
      'Help improve detections for everybody';

  @override
  String get homeApkSAndroidAppsFoundToBe =>
      'APK\'s (android apps) found to be malicious ';

  @override
  String get homeCanBeUploadedTo => 'can be uploaded to ';

  @override
  String get homeAndSharedWithTheCommunityThisIs =>
      ' and shared with the community. This is ';

  @override
  String get homeStrictlyLimitedToAPKFilesNOTYour =>
      'strictly limited to APK files, NOT your personal ';

  @override
  String get homeDocuments => 'documents.\n\n';

  @override
  String get homeThisWillImproveDetectionsForEveryoneThat =>
      'This will improve detections for everyone that ';

  @override
  String get homeUsesAvarionXNoPressureThough =>
      'uses AvarionX. No pressure though!\n\n';

  @override
  String get homeThanks => 'Thanks,\n';

  @override
  String get homeRyanfromcolourswift => 'RyanFromColourswift';

  @override
  String get homeSure => 'Sure!';

  @override
  String get homeNoThanks => 'No Thanks!';

  @override
  String get homePsstCustomiseItHere => 'Psst...customise it here';

  @override
  String get homeScanNow => 'Scan Now';

  @override
  String get homeManuallyCheckYourDeviceForMalware =>
      'Manually check your device for malware';

  @override
  String get homeDeviceSecurity => 'Device Security';

  @override
  String get homeScanModes => 'Scan Modes';

  @override
  String get homeCloudAssistedChecksEnabled => 'Cloud-assisted checks enabled';

  @override
  String get homeLocalScanEngineOnly => 'Local scan engine only';

  @override
  String get homeProtectedByVXTITANIUM => 'Protected by VX-TITANIUM';

  @override
  String get homeSecurityOverview => 'Security Overview';

  @override
  String get homeFilesChecked => 'Files checked';

  @override
  String get homeThreats => 'Threats';

  @override
  String get securityReportAvarionxSecurityReport => 'Avarionx Security Report';

  @override
  String get securityReportSecurityReport => 'Security Report';

  @override
  String get securityReportManualScans => 'Manual scans';

  @override
  String get securityReportRealtimeChecks => 'Realtime checks';

  @override
  String get securityReportTotalFilesScanned => 'Total files scanned';

  @override
  String get securityReportThreatsFound => 'Threats found';

  @override
  String get securityReportGenerateReport => 'Generate report';

  @override
  String get securityReportLiveReport => 'Live report';

  @override
  String get securityReportThisBoxUpdatesAsScanServicesWrite =>
      'This box updates as scan services write report data.';

  @override
  String get securityReportExportPDF => 'Export PDF';

  @override
  String get securityReportExportCSV => 'Export CSV';

  @override
  String get homeLegacyProActivated => 'Pro activated';

  @override
  String get homeLegacyProDeactivated => 'Pro deactivated';

  @override
  String get linkCheckPoweredByVTTICloud => 'Powered by VTTI Cloud';

  @override
  String get safeViewSafeView => 'Safe View';

  @override
  String get passwordSettingsChangingThisAltersAllPasswords =>
      'Changing this alters all passwords.\n';

  @override
  String get passwordSettingsUsingTheSameMetaPassRestoresThem =>
      'Using the same MetaPass restores them.';

  @override
  String get passwordSettingsPasswordsAreNeverStored =>
      'Passwords are never stored.\n\n';

  @override
  String get passwordSettingsTheRestoreCodeContainsOnlyStructureData =>
      'The restore code contains only structure data. ';

  @override
  String get passwordSettingsCombinedWithYourMetaPassItRebuildsYour =>
      'Combined with your MetaPass, it rebuilds your vault.';

  @override
  String get passwordManagerContinue => 'Continue';

  @override
  String passwordManagerFailedToLoadApps(Object e) {
    return 'Failed to load apps: $e';
  }

  @override
  String passwordManagerFailedToGeneratePassword(Object e) {
    return 'Failed to generate password: $e';
  }

  @override
  String get passwordManagerPasswordsAreNeverStored =>
      'Passwords are never stored.\n\n';

  @override
  String get passwordManagerEachEntryDerivesAPasswordFrom =>
      'Each entry derives a password from:\n';

  @override
  String get passwordManagerYourMetaPassword => '• Your meta password\n';

  @override
  String get passwordManagerTheLabelName => '• The label(name)\n';

  @override
  String get passwordManagerTheVersionAndLength =>
      '• The version and length\n\n';

  @override
  String get passwordManagerReinstallingTheAppWithTheSameMeta =>
      'Reinstalling the app with the same meta password and labels regenerates the same passwords.';

  @override
  String get permissionsIntroSetupIsNowCompleteTimeToSecure =>
      'Setup is now complete! Time to secure your data.';

  @override
  String get proScreenThankYou => 'Thank you';

  @override
  String get proScreenYourSubscriptionIsConfirmed =>
      'Your subscription is confirmed.';

  @override
  String get proScreenCurrent => 'Current';

  @override
  String get proScreenAdvancedStealthMode => 'Advanced Stealth+ Mode';

  @override
  String get proScreenUnlockStealthTransportModesForRestrictiveNetworks =>
      'Unlock stealth transport modes for restrictive networks.';

  @override
  String get proScreenGlobalServerAccess => 'Global Server Access';

  @override
  String get proScreenAccessEveryVPNServerLocationIncludingPremium =>
      'Access every VPN server location, including premium high-speed regions.';

  @override
  String get proScreenBilledMonthly => 'Billed monthly';

  @override
  String proScreenMo(Object monthlyInfo) {
    return '$monthlyInfo/mo';
  }

  @override
  String proScreenMo2(Object currencyCode) {
    return '$currencyCode/mo';
  }

  @override
  String get proScreenCurrentPlan => 'Current plan';

  @override
  String get quarantineScreenQuarantineDataCorruptedResetting =>
      'Quarantine data corrupted. Resetting.';

  @override
  String get quarantineScreenUninstallApp => 'Uninstall App';

  @override
  String quarantineScreenUninstall(Object appName) {
    return 'Uninstall $appName?';
  }

  @override
  String get quarantineScreenUninstall2 => 'Uninstall';

  @override
  String get quarantineScreenFailedToLaunchUninstall =>
      'Failed to launch uninstall';

  @override
  String get quarantineScreenFiles => 'Files';

  @override
  String get cleanerAppManagerShizukuNotAvailable => 'Shizuku not available';

  @override
  String get cleanerAppManagerWithoutShizukuEachAppRequiresASeparate =>
      'Without Shizuku each app requires a separate system confirmation. Continue?';

  @override
  String cleanerAppManagerAppsUninstalled(Object successCount) {
    return '$successCount apps uninstalled';
  }

  @override
  String cleanerAppManagerUninstalledFailed(
      Object successCount, Object failedCount) {
    return '$successCount uninstalled, $failedCount failed';
  }

  @override
  String cleanerAppManagerStopped(Object appName) {
    return '$appName stopped';
  }

  @override
  String get cleanerAppManagerForceStopFailed => 'Force stop failed';

  @override
  String get cleanerAppManagerClearAppData => 'Clear app data';

  @override
  String cleanerAppManagerResetThisClearsItsAccountsSettingsFiles(
      Object appName) {
    return 'Reset $appName? This clears its accounts, settings, files and cache.';
  }

  @override
  String get cleanerAppManagerClearData => 'Clear data';

  @override
  String cleanerAppManagerReset(Object appName) {
    return '$appName reset';
  }

  @override
  String get cleanerAppManagerClearDataFailed => 'Clear data failed';

  @override
  String get cleanerAppManagerOpenApp => 'Open app';

  @override
  String get cleanerAppManagerForceStop => 'Force stop';

  @override
  String get cleanerAppManagerUninstall => 'Uninstall';

  @override
  String cleanerAppManagerSelected(Object selectedCount) {
    return '$selectedCount selected';
  }

  @override
  String get cleanerAppManagerAppManager => 'App Manager';

  @override
  String get cleanerAppManagerDeselectAll => 'Deselect all';

  @override
  String cleanerAppManagerUninstalling(Object done, Object total) {
    return 'Uninstalling $done / $total…';
  }

  @override
  String cleanerAppManagerUninstall2(Object selectedCount) {
    return 'Uninstall $selectedCount';
  }

  @override
  String get cleanerProClearAppCaches => 'Clear app caches';

  @override
  String get cleanerProThisAsksAndroidToTrimAppCaches =>
      'This asks Android to trim app caches across the device. App data, accounts and settings are not cleared.';

  @override
  String get cleanerProClearCaches => 'Clear caches';

  @override
  String get cleanerProCacheTrimRequested => 'Cache trim requested';

  @override
  String get cleanerProCacheCleanerFailed => 'Cache cleaner failed';

  @override
  String get cleanerProLogFiles => 'Log files';

  @override
  String get cleanerProCacheCleaner => 'Cache Cleaner';

  @override
  String get cleanerProLogCleaner => 'Log Cleaner';

  @override
  String get cleanerProAppDataManager => 'App Data Manager';

  @override
  String get cleanerScreenCleaner => 'Cleaner';

  @override
  String get scanDetailDeleteFiles => 'Delete Files';

  @override
  String scanDetailDeleteFilesPermanently(Object selectedCount) {
    return 'Delete $selectedCount files permanently?';
  }

  @override
  String get scanDetailSelectedFilesDeleted => 'Selected files deleted';

  @override
  String get scanDetailDeleteAllFiles => 'Delete All Files';

  @override
  String scanDetailDeleteAllFilesPermanently(Object fileCount) {
    return 'Delete all $fileCount files permanently?';
  }

  @override
  String get scanDetailDeleteAll => 'Delete All';

  @override
  String get scanDetailAllFilesDeleted => 'All files deleted';

  @override
  String scanDetailSelected(Object selectedCount) {
    return '$selectedCount selected';
  }

  @override
  String get scanDetailDeselectAll => 'Deselect all';

  @override
  String get scanDetailNewestFirst => 'Newest first';

  @override
  String get scanDetailOldestFirst => 'Oldest first';

  @override
  String get scanDetailLargestFirst => 'Largest first';

  @override
  String get scanDetailSmallestFirst => 'Smallest first';

  @override
  String get scanDetailNoFilesFound => 'No files found';

  @override
  String get scanDetailDeleteAll2 => 'Delete all';

  @override
  String get scanInstalledAppsSearchApps => 'Search apps...';

  @override
  String get scanInstalledAppsNoAppsFound => 'No apps found.';

  @override
  String get scanUiScanComplete => 'Scan complete';

  @override
  String scanUiScannedItems(Object scanned) {
    return 'Scanned: $scanned items';
  }

  @override
  String scanUiProgress(Object pct, Object scanned, Object total) {
    return 'Progress: $pct ($scanned / $total)';
  }

  @override
  String get scanUiPreparingEngine => 'Preparing Engine...';

  @override
  String get scanUiLoadingTargetS => 'Loading target(s)';

  @override
  String get scanUiAvarionxVPN => 'AvarionX VPN';

  @override
  String get scanUiProtectYourInternetWithOurUnlimitedVPN =>
      'Protect your internet with our unlimited VPN';

  @override
  String get scanUiTapMe => 'Tap me!';

  @override
  String scanUiScanned(Object scanned) {
    return '$scanned scanned';
  }

  @override
  String get scanUiReturn => 'Return';

  @override
  String get scanLimitsSettingsUpdated => 'Settings updated';

  @override
  String get scanLimitsScanLimits => 'Scan limits';

  @override
  String get scanLimitsLimitHowMuchTheEngineUsesYour =>
      'Limit how much the engine uses your CPU. Threads: 0 means auto.';

  @override
  String get scanLimitsMaxScanThreads => 'Max scan threads';

  @override
  String scanLimits0AutoRange0ToCores(Object maxThreads, Object coreCount) {
    return '0 = auto. Range: 0 to $maxThreads (cores: $coreCount).';
  }

  @override
  String scanLegacyScanning(Object percent) {
    return 'Scanning... $percent%';
  }

  @override
  String scanLegacySuspicious(Object infectedCount) {
    return 'Suspicious: $infectedCount';
  }

  @override
  String scanLegacyClean(Object cleanCount) {
    return 'Clean: $cleanCount';
  }

  @override
  String get scanLegacyNoFilesToScan => 'No files to scan';

  @override
  String get settingsSponsorsUnlock => 'Sponsors unlock ❤️';

  @override
  String get settingsPickCertificate => 'Pick Certificate';

  @override
  String get settingsCertificateLoaded => 'Certificate loaded';

  @override
  String get settingsEnterCode => 'enter code';

  @override
  String get settingsSupportFileMissing => 'Support file missing';

  @override
  String get settingsInvalidSupportCode => 'Invalid support code';

  @override
  String get settingsAvarionxSecurity => 'AvarionX Security';

  @override
  String get settingsAvarionxIsAMobileSecuritySuiteCreated =>
      'AvarionX is a mobile security suite created by ColourSwift, based in Birmingham, UK.\n\n';

  @override
  String get settingsContact => 'Contact: ';

  @override
  String get settingsExperimentalFeatures => 'Experimental Features';

  @override
  String get settingsEnablingShizukuUnlocksExperimentalWorkInProgress =>
      'Enabling Shizuku unlocks experimental work-in-progress features:\n\n';

  @override
  String get settingsAdvancedRansomwareProtection =>
      '• Advanced Ransomware Protection\n';

  @override
  String get settingsCacheCleanerPlus => '• Cache Cleaner Plus\n\n';

  @override
  String get settingsExperimentalWarning => 'Experimental warning:\n';

  @override
  String get settingsTheseFeaturesUseAdvancedSystemAccessAnd =>
      'These features use advanced system access and may behave differently across devices, Android versions, and Shizuku setups. Some actions may affect running apps, files, or cache data more directly than normal scanning.\n\n';

  @override
  String get settingsOnlyEnableThisIfYouUnderstandShizuku =>
      'Only enable this if you understand Shizuku, accept that the feature is still being tested, and have backed up anything important.\n\n';

  @override
  String get settingsPleaseReadTheDocumentationBeforeEnabling =>
      'Please read the documentation before enabling.';

  @override
  String get settingsEnable => 'Enable';

  @override
  String get settingsSigningOut => 'Signing out...';

  @override
  String get settingsCheckingAccountStatus => 'Checking account status...';

  @override
  String get settingsManageSignInPremiumAndPurchases =>
      'Manage sign in, Premium, and purchases';

  @override
  String get settingsPremiumActive => 'Premium active';

  @override
  String get settingsManagePremiumOptionsAndRestorePurchases =>
      'Manage Premium options and restore purchases';

  @override
  String get settingsUnlockDeepAnalysisModeAndVPNFeatures =>
      'Unlock Deep analysis mode and VPN features';

  @override
  String get settingsAutoClearNotifications => 'Auto-clear notifications';

  @override
  String get settingsScanModes => 'Scan Modes';

  @override
  String get settingsAdvancedScanModes => 'Advanced scan modes';

  @override
  String get settingsDisableToUseTheDefaultScanningMode =>
      'Disable to use the default scanning mode';

  @override
  String get settingsToggleToEnableAllScanningModes =>
      'Toggle to enable all scanning modes';

  @override
  String get settingsApkSubmissions => 'APK Submissions';

  @override
  String get settingsShareMaliciousAPKs => 'Share malicious APKs';

  @override
  String get settingsHelpingImproveDetectionForEveryone =>
      'Helping improve detection for everyone';

  @override
  String get settingsOff => 'Off';

  @override
  String get settingsIncludeRealtimeProtectionCatches =>
      'Include Realtime Protection catches';

  @override
  String get settingsApksFlaggedByRealtimeProtectionAreIncluded =>
      'APKs flagged by Realtime Protection are included';

  @override
  String get settingsApksFlaggedByRealtimeProtectionAreExcluded =>
      'APKs flagged by Realtime Protection are excluded';

  @override
  String get settingsIncludeManualAndScheduledScans =>
      'Include manual and scheduled scans';

  @override
  String get settingsApksFlaggedByScansAreIncluded =>
      'APKs flagged by scans are included';

  @override
  String get settingsApksFlaggedByScansAreExcluded =>
      'APKs flagged by scans are excluded';

  @override
  String get settingsWiFiOnly => 'Wi-Fi only';

  @override
  String get settingsUploadsWaitForAWiFiConnection =>
      'Uploads wait for a Wi-Fi connection';

  @override
  String get settingsUploadsMayUseMobileData => 'Uploads may use mobile data';

  @override
  String get settingsChargingOnly => 'Charging only';

  @override
  String get settingsUploadsWaitUntilTheDeviceIsCharging =>
      'Uploads wait until the device is charging';

  @override
  String get settingsUploadsAreNotLimitedToCharging =>
      'Uploads are not limited to charging';

  @override
  String get settingsChooseWhichAppsUpload => 'Choose which apps upload';

  @override
  String get settingsReviewAndPickAppsEachTimeBefore =>
      'Review and pick apps each time before uploading';

  @override
  String get settingsFlaggedAppsUploadAutomatically =>
      'Flagged apps upload automatically';

  @override
  String get settingsEnableProDebug => 'Enable Pro (debug)';

  @override
  String get settingsLocalUnlockForUITesting => 'Local unlock for UI testing';

  @override
  String get settingsRestorePurchases => 'Restore purchases';

  @override
  String get settingsReCheckPlayBilling => 'Re-check Play Billing';

  @override
  String get settingsCheckingAccount => 'Checking account...';

  @override
  String get settingsAvarionxAccountConnected => 'AvarionX account connected';

  @override
  String settingsAccountID(Object accountId) {
    return 'Account ID: $accountId';
  }

  @override
  String get settingsSignInToManagePurchasesAndAccount =>
      'Sign in to manage purchases and account features.';

  @override
  String get settingsOpenTheAvarionXAccountPortal =>
      'Open the AvarionX account portal';

  @override
  String get settingsAccountDashboard => 'Account dashboard';

  @override
  String get settingsOpenBillingAndAccountSettings =>
      'Open billing and account settings';

  @override
  String get settingsRemoveThisAccountFromTheApp =>
      'Remove this account from the app';

  @override
  String get settingsPremiumFeaturesAreAvailableOnThisDevice =>
      'Premium features are available on this device';

  @override
  String get settingsViewOptionalPremiumFeatures =>
      'View optional Premium features';

  @override
  String get settingsReCheckPlayBillingEntitlement =>
      'Re-check Play Billing entitlement';

  @override
  String get settingsRtpNotificationAutoClearNotifications =>
      'Auto-clear notifications';

  @override
  String get settingsRtpNotificationNever => 'Never';

  @override
  String get settingsRtpNotification5Minutes => '5 minutes';

  @override
  String get settingsRtpNotification10Minutes => '10 minutes';

  @override
  String get settingsRtpNotification30Minutes => '30 minutes';

  @override
  String get settingsThemeBlack => 'Black';

  @override
  String get settingsThemeWhite => 'White';

  @override
  String get settingsThemeGrey => 'Grey';

  @override
  String get settingsThemeEmerald => 'Emerald';

  @override
  String get settingsThemePurple => 'Purple';

  @override
  String get settingsThemeRoyalBlue => 'Royal Blue';

  @override
  String get settingsAccountCardSyncPurchasesAndUnlockProAcrossApps =>
      'Sync purchases and unlock Pro across apps.';

  @override
  String get settingsAccountCardLoading => 'Loading...';

  @override
  String get settingsAccountCardDashboard => 'Dashboard';

  @override
  String get settingsProCardChangePlan => 'Change plan';

  @override
  String get advancedNetworkProtectionEnterYourOwnResolver =>
      'Enter your own resolver';

  @override
  String get advancedNetworkProtectionCloudProtectionMode =>
      'Cloud protection mode';

  @override
  String get advancedNetworkProtectionRoutesAllDNSQueriesToTheCloud =>
      'Routes all DNS queries to the cloud engine, enabling live blocklist updates, domain reputation checking, and more.';

  @override
  String get advancedNetworkProtectionRefreshProStatus => 'Refresh pro status';

  @override
  String get advancedNetworkProtectionProActive => 'Pro active';

  @override
  String get advancedNetworkProtectionFreePlan => 'Free plan';

  @override
  String get advancedNetworkProtectionChecksYourEntitlementAndSyncsItWith =>
      'Checks your entitlement and syncs it with cloud features. Pro unlocks system wide ad blocking.';

  @override
  String get advancedNetworkProtectionMalwareProtection => 'Malware protection';

  @override
  String get advancedNetworkProtectionBlocksKnownMaliciousDomains =>
      'Blocks known malicious domains';

  @override
  String get advancedNetworkProtectionTrackerProtection => 'Tracker protection';

  @override
  String get advancedNetworkProtectionReducesTrackingDomains =>
      'Reduces tracking domains';

  @override
  String get advancedNetworkProtectionAdProtection => 'Ad protection';

  @override
  String get advancedNetworkProtectionBlocksCommonAdDomains =>
      'Blocks common ad domains';

  @override
  String get advancedNetworkProtectionAdultFilter => 'Adult filter';

  @override
  String get advancedNetworkProtectionUses1113Upstream =>
      'Uses 1.1.1.3 upstream';

  @override
  String get advancedNetworkProtectionLockedUntilProIsActiveAndCloud =>
      'Locked until Pro is active and cloud mode is enabled.';

  @override
  String get advancedNetworkProtectionLiveDNSEventsFromTheVPNLayer =>
      'Live DNS events from the VPN layer.';

  @override
  String get advancedNetworkProtectionAdvanced => 'Advanced';

  @override
  String get advancedNetworkProtectionDns => 'DNS';

  @override
  String get advancedNetworkProtectionCloudDNSMode => 'Cloud DNS mode';

  @override
  String get networkProtectionEnterYourOwnResolver => 'Enter your own resolver';

  @override
  String get networkAppControlEnableVPNToggles => 'Enable VPN toggles';

  @override
  String get networkAppControlOpenSettings => 'Open settings';

  @override
  String get networkAppControlAppControl => 'App control';

  @override
  String get networkAppControlNoAppsFound => 'No apps found.';

  @override
  String get networkSpeedTestCountry => 'Country';

  @override
  String get networkSpeedTestRunning => 'Running';

  @override
  String get networkSpeedTestRunTest => 'Run test';

  @override
  String get networkSpeedTestNoResultsYet => 'No results yet.';

  @override
  String networkSpeedTestDnsTLS(Object dns, Object tls) {
    return 'DNS: $dns  •  TLS: $tls';
  }

  @override
  String get networkSpeedTestFail => 'Fail';

  @override
  String get dnsNetworkProtectionEnterYourOwnResolver =>
      'Enter your own resolver';

  @override
  String get dnsNetworkProtectionDnsFilteringIsSeperateFromTheSecure =>
      'DNS filtering is seperate from the Secure VPN. It can block known malware, ads (across all apps), trackers, and content from unwanted categories before they load.';

  @override
  String get fullVpnSignedIn => 'Signed in.';

  @override
  String get fullVpnSignInRequired => 'Sign in required';

  @override
  String get fullVpnClose => 'Close';

  @override
  String get fullVpnLoadingUsage => 'Loading usage...';

  @override
  String get fullVpnSyncing => 'Syncing';

  @override
  String fullVpnUsedThisMonth(Object usedBytes) {
    return '$usedBytes used this month';
  }

  @override
  String get blockedScreenUnsupportedEnvironment => 'Unsupported environment';

  @override
  String updateLogUpdateV(Object version) {
    return 'Update: v$version';
  }

  @override
  String get updateLogHiThereAvarionXHasBeenUpdatedBelow =>
      'Hi there! AvarionX has been updated, below are the changes:';

  @override
  String get updateLogNoUserFacingChangesInThisUpdate =>
      'No user-facing changes in this update.';

  @override
  String get updateLogContinue => 'Continue';

  @override
  String get featuresRealtimeProtectionBody =>
      'Monitors new and modified files in the background and blocks threats the moment they appear.';

  @override
  String get featuresTriLayerEngineTitle => 'Tri-Layer Engine';

  @override
  String get featuresTriLayerEngineBody =>
      'A three-stage detection core combining Bloom filtering, signature scanning, and APK-focused byte analysis for high accuracy and speed.';

  @override
  String get featuresMachineLearningTitle => 'Machine Learning';

  @override
  String get featuresMachineLearningBody =>
      'A lightweight on-device model trained to recognise malicious APK behaviour patterns.';

  @override
  String get featuresCleanerProTitle => 'Cleaner Pro';

  @override
  String get featuresCleanerProBody =>
      'An evolving cleaning module that identifies duplicates, cache, and unused apps to reclaim storage.';

  @override
  String get featuresWifiProtectionTitle => 'Wi-Fi Protection';

  @override
  String get featuresWifiProtectionBody =>
      'Detects unsafe or suspicious Wi-Fi networks using on-device analysis.';

  @override
  String get featuresRootLevelProtectionTitle => 'Root-Level Protection';

  @override
  String get featuresRootLevelProtectionBody =>
      'Deep system-level defense designed for rooted devices and advanced users.';

  @override
  String get featuresPcCompanionTitle => 'PC Companion';

  @override
  String get featuresPcCompanionBody =>
      'Upcoming desktop version for cross-platform antivirus integration.';

  @override
  String get deviceSecurityNoRisksFound => 'No device risks found';

  @override
  String get deviceSecurityOneCheckNeedsAttention =>
      '1 device check needs attention';

  @override
  String deviceSecurityChecksNeedAttention(Object count) {
    return '$count device checks need attention';
  }

  @override
  String get deviceSecurityHealthSectionBody =>
      'These settings directly affect your device posture.';

  @override
  String get deviceSecurityRecommendationsSectionBody =>
      'These settings are common security good practice.';

  @override
  String get deviceSecuritySignalUnavailable => 'Signal unavailable';

  @override
  String get deviceSecurityIgnoredByYou => 'Ignored by you';

  @override
  String get deviceSecurityScreenLockInactiveTitle => 'Screen Lock';

  @override
  String get deviceSecurityScreenLockActiveLabel =>
      'Unsafe, no secure screen lock is set';

  @override
  String get deviceSecurityScreenLockInactiveLabel => 'Screen lock is active';

  @override
  String get deviceSecurityScreenLockDetail =>
      'A secure screen lock protects your device if it is lost, stolen, or left unattended. Without a PIN, password, pattern, fingerprint, or face unlock backed by a secure lock method, anyone with physical access can open the device more easily.';

  @override
  String get deviceSecurityScreenLockHelp =>
      'Open Android security settings and set a secure screen lock.';

  @override
  String get deviceSecurityCheckSetting => 'Check setting';

  @override
  String get deviceSecurityPrivilegedInactiveTitle => 'No Privileged Access';

  @override
  String get deviceSecurityPrivilegedActiveLabel =>
      'Privileged access detected';

  @override
  String get deviceSecurityPrivilegedInactiveLabel =>
      'No privileged access detected';

  @override
  String get deviceSecurityPrivilegedDetail =>
      'Root and Shizuku can be useful for you, but it also increase the impact of a malicious app if access is abused. Apps with privileged access may be able to perform actions that normal Android apps cannot.';

  @override
  String get deviceSecurityPrivilegedHelp =>
      'Review your root, Magisk, or Shizuku settings manually.';

  @override
  String get deviceSecurityReviewSetting => 'Review setting';

  @override
  String get deviceSecurityAppVerificationInactiveTitle => 'App Verification';

  @override
  String get deviceSecurityAppVerificationActiveLabel =>
      'Unsafe, app verification appears disabled';

  @override
  String get deviceSecurityAppVerificationInactiveLabel =>
      'App verification appears enabled';

  @override
  String get deviceSecurityAppVerificationDetail =>
      'Android app verification helps check apps before or after installation. If this protection is disabled or unavailable, harmful apps may be less likely to be blocked before they run.';

  @override
  String get deviceSecurityAppVerificationHelp =>
      'Open Android security settings and review app verification.';

  @override
  String get deviceSecuritySecurityPatchInactiveTitle =>
      'Security Patch Current';

  @override
  String get deviceSecuritySecurityPatchActiveLabel =>
      'Security patch level is outdated';

  @override
  String get deviceSecuritySecurityPatchInactiveLabel =>
      'Security patch level is current';

  @override
  String get deviceSecuritySecurityPatchDetail =>
      'Android security patches fix known platform and vendor issues. If the patch level is old, the device may be exposed to vulnerabilities that have already been fixed on newer builds.';

  @override
  String get deviceSecuritySecurityPatchHelp =>
      'Open Android system update settings and check for updates.';

  @override
  String get deviceSecurityCheckUpdates => 'Check updates';

  @override
  String get deviceSecurityDeveloperModeInactiveTitle => 'Developer Mode';

  @override
  String get deviceSecurityDeveloperModeActiveLabel =>
      'Developer options are enabled';

  @override
  String get deviceSecurityDeveloperModeInactiveLabel =>
      'Developer options are disabled';

  @override
  String get deviceSecurityDeveloperModeDetail =>
      'Developer Mode is normal for developers and testers, but it exposes advanced settings that can reduce device security if changed accidentally or abused by someone with access to the device.';

  @override
  String get deviceSecurityDeveloperModeHelp =>
      'Open Developer Options and turn off settings you do not need.';

  @override
  String get deviceSecurityUsbDebuggingInactiveTitle => 'USB Debugging';

  @override
  String get deviceSecurityUsbDebuggingActiveLabel =>
      'Unsafe, USB debugging is turned on';

  @override
  String get deviceSecurityUsbDebuggingInactiveLabel =>
      'USB debugging is turned off';

  @override
  String get deviceSecurityUsbDebuggingDetail =>
      'USB debugging allows a connected computer to interact with your device through Android Debug Bridge. If left enabled, it increases the risk of unauthorised access when connected to an untrusted machine.';

  @override
  String get deviceSecurityUsbDebuggingHelp =>
      'Open Developer Options and turn USB debugging off.';

  @override
  String get deviceSecurityUnknownSourcesInactiveTitle => 'Unknown Sources';

  @override
  String get deviceSecurityUnknownSourcesActiveLabel =>
      'Installing unknown apps is allowed';

  @override
  String get deviceSecurityUnknownSourcesInactiveLabel =>
      'Installing unknown apps is restricted';

  @override
  String get deviceSecurityUnknownSourcesDetail =>
      'Allowing unknown app installs can be useful for trusted APKs, but it also increases the chance of installing apps from unsafe sources. Only allow this for apps and stores you trust.';

  @override
  String get deviceSecurityUnknownSourcesHelp =>
      'Open Android settings and review install unknown apps access.';

  @override
  String get deviceSecurityAccessibilityInactiveTitle =>
      'Accessibility Services';

  @override
  String get deviceSecurityAccessibilityActiveLabel =>
      'Third-party accessibility service enabled';

  @override
  String get deviceSecurityAccessibilityInactiveLabel =>
      'No risky accessibility services found';

  @override
  String get deviceSecurityAccessibilityDetail =>
      'Accessibility services are powerful because they can observe screen content and perform actions on behalf of the user. This is useful for legitimate tools, but it is also commonly abused by malicious apps.';

  @override
  String get deviceSecurityAccessibilityHelp =>
      'Open Accessibility settings and review enabled services.';

  @override
  String get deviceSecurityChecking => 'Checking device security';

  @override
  String get deviceSecurityReadingSignals =>
      'Reading device posture signals...';

  @override
  String get deviceSecurityOneCheckAttention => '1 check needs attention';

  @override
  String deviceSecurityChecksAttention(Object count) {
    return '$count checks need attention';
  }

  @override
  String get deviceSecurityTapSignal => 'Tap a signal below to learn more.';

  @override
  String deviceSecurityIgnoredChecks(Object count, String plural) {
    return '$count active check$plural ignored by you.';
  }

  @override
  String get deviceSecurityPostureNormal =>
      'Your device posture checks look normal.';

  @override
  String get timeJustNow => 'just now';

  @override
  String timeMinutesAgo(Object minutes) {
    return '${minutes}m ago';
  }

  @override
  String timeHoursAgo(Object hours) {
    return '${hours}h ago';
  }

  @override
  String timeDaysAgo(Object days) {
    return '${days}d ago';
  }

  @override
  String get securityNoReportDataYet => 'No report data yet';

  @override
  String securityLastActivity(Object relative) {
    return 'Last activity $relative';
  }

  @override
  String get securityReportSharePdfTitle => 'Avarionx Security Report';

  @override
  String get securityReportCsvField => 'Field';

  @override
  String get securityReportCsvValue => 'Value';

  @override
  String get securityReportGeneratedAt => 'Generated at';

  @override
  String get securityReportOverallStatus => 'Overall status';

  @override
  String get securityReportLastManualScan => 'Last manual scan';

  @override
  String get securityReportLastRealtimeEvent => 'Last realtime event';

  @override
  String get securityReportLastScheduledScan => 'Last scheduled scan';

  @override
  String get securityReportShareCsvTitle => 'Avarionx Security Report CSV';

  @override
  String get securityReportReviewRecommended => 'Review recommended';

  @override
  String get securityReportNoKnownThreatDetected => 'No known threat detected';

  @override
  String securityReportGeneratedLine(Object generatedAt) {
    return 'Generated: $generatedAt';
  }

  @override
  String securityReportStatusLine(Object status) {
    return 'Status: $status';
  }

  @override
  String securityReportLatestActivityLine(Object latest) {
    return 'Latest activity: $latest';
  }

  @override
  String securityReportManualScansLine(Object count) {
    return 'Manual scans: $count';
  }

  @override
  String securityReportRealtimeChecksLine(Object count) {
    return 'Realtime checks: $count';
  }

  @override
  String securityReportTotalFilesScannedLine(Object count) {
    return 'Total files scanned: $count';
  }

  @override
  String securityReportThreatsFoundLine(Object count) {
    return 'Threats found: $count';
  }

  @override
  String securityReportLastManualScanLine(Object value) {
    return 'Last manual scan: $value';
  }

  @override
  String securityReportLastRealtimeEventLine(Object value) {
    return 'Last realtime event: $value';
  }

  @override
  String securityReportLastScheduledScanLine(Object value) {
    return 'Last scheduled scan: $value';
  }

  @override
  String get securityReportNotRecorded => 'Not recorded';

  @override
  String get safeViewNavigationBlocked => 'Navigation blocked';

  @override
  String get safeViewInvalidDestination => 'Invalid destination';

  @override
  String get safeViewUnsupportedScheme => 'Unsupported scheme';

  @override
  String get safeViewUnableToResolveDestination =>
      'Unable to resolve destination';

  @override
  String get safeViewDestinationBlocked => 'Destination blocked';

  @override
  String get safeViewUnableToVerifyDestination =>
      'Unable to verify destination';

  @override
  String proScreenCurrentStatus(Object status) {
    return 'Current status: $status';
  }

  @override
  String proScreenBilledAnnuallyAt(Object price) {
    return 'Billed annually at $price';
  }

  @override
  String get quarantineUnknownApp => 'Unknown App';

  @override
  String get cleanerScanCancelled => 'Scan cancelled';

  @override
  String get cleanerProClearingCaches => 'Clearing caches…';

  @override
  String get cleanerProTrimAppCaches => 'Trim app caches across the device.';

  @override
  String get cleanerProEnableShizuku =>
      'Enable Shizuku in Settings to use this.';

  @override
  String get cleanerProScanningStorage => 'Scanning storage…';

  @override
  String get cleanerProFindLogFiles =>
      'Find .log, .trace, .crash and .dmp files.';

  @override
  String cleanerProLogFileCount(Object count, Object size) {
    return '$count files • $size';
  }

  @override
  String get cleanerProAppManagerReady =>
      'Force stop, clear data and batch uninstall apps.';

  @override
  String get cleanerProAppManagerLimited =>
      'Uninstall works normally. Force stop and clear data require Shizuku.';

  @override
  String get cleanerProCheckingShizuku => 'Checking Shizuku…';

  @override
  String get cleanerProShizukuNotRunning =>
      'Shizuku is not running. Enable it from Settings when needed.';

  @override
  String get cleanerProShizukuPermissionMissing =>
      'Shizuku permission is not granted. Enable it from Settings.';

  @override
  String get cleanerProShizukuNotBound =>
      'Shizuku service is not bound yet. Open Settings and refresh this screen after enabling it.';

  @override
  String get cleanerLiteTab => 'Lite';

  @override
  String get cleanerProTab => 'Pro';

  @override
  String get scanCancelled => 'Scan cancelled';

  @override
  String get scanPreparing => 'Preparing scan...';

  @override
  String scanSuspiciousItemsFound(Object count, String plural) {
    return '$count suspicious item$plural found';
  }

  @override
  String scanSuspiciousCount(Object count) {
    return '$count suspicious';
  }

  @override
  String scanCleanCount(Object count) {
    return '$count clean';
  }

  @override
  String scanNotificationFullItems(Object count) {
    return 'Scanned: $count items';
  }

  @override
  String scanNotificationCurrent(Object count, Object file) {
    return 'Scanned: $count • $file';
  }

  @override
  String scanNotificationProgress(Object scanned, Object total) {
    return '$scanned / $total';
  }

  @override
  String scanNotificationProgressCurrent(
      Object scanned, Object total, Object file) {
    return '$scanned / $total • $file';
  }

  @override
  String get settingsThemeRoyalBluePremium => 'Royal Blue (Premium)';

  @override
  String get settingsIconDefault => 'Default';

  @override
  String get settingsIconBird => 'Bird';

  @override
  String get settingsIconNeon => 'Neon';

  @override
  String get settingsIconOriginal => 'Original';

  @override
  String get homeRealtimeProtectionTitle => 'Real-Time Protection';

  @override
  String get networkCardStatusLocked => 'Locked';

  @override
  String get networkSectionConnection => 'Connection';

  @override
  String get networkSectionBlocklists => 'Blocklists';

  @override
  String get networkSectionResolver => 'Resolver';

  @override
  String get networkAppControlOtherVpnSetupInstructions =>
      'Another VPN is currently selected as Always-on.\\n\\nTo block apps reliably:\\n\\n1) Open Android VPN settings\\n2) Select AvarionX as the VPN\\n3) Enable Always-on VPN\\n4) Enable Block connections without VPN';

  @override
  String get networkAppControlSetupInstructions =>
      'To block apps reliably:\\n\\n1) Open Android VPN settings\\n2) Select AvarionX as the VPN\\n3) Enable Always-on VPN\\n4) Enable Block connections without VPN';

  @override
  String get networkAppControlBlockingActive => 'App blocking is active.';

  @override
  String get networkAppControlOtherVpnWarning =>
      'Another VPN is set as Always-on. Enable Always-on + Block without VPN for AvarionX.';

  @override
  String get networkAppControlSetupWarning =>
      'Enable Always-on + Block without VPN for AvarionX to make app blocking work.';

  @override
  String get countryUnitedKingdom => 'United Kingdom';

  @override
  String get countryUnitedStates => 'United States';

  @override
  String get countryCanada => 'Canada';

  @override
  String get countryIreland => 'Ireland';

  @override
  String get countryFrance => 'France';

  @override
  String get countryGermany => 'Germany';

  @override
  String get countryNetherlands => 'Netherlands';

  @override
  String get countrySpain => 'Spain';

  @override
  String get countryItaly => 'Italy';

  @override
  String get countrySweden => 'Sweden';

  @override
  String get countryNorway => 'Norway';

  @override
  String get countryDenmark => 'Denmark';

  @override
  String get countryPoland => 'Poland';

  @override
  String get countryTurkey => 'Turkey';

  @override
  String get countryGreece => 'Greece';

  @override
  String get countryRomania => 'Romania';

  @override
  String get countryUkraine => 'Ukraine';

  @override
  String get countryRussia => 'Russia';

  @override
  String get countryIndia => 'India';

  @override
  String get countryPakistan => 'Pakistan';

  @override
  String get countryBangladesh => 'Bangladesh';

  @override
  String get countrySriLanka => 'Sri Lanka';

  @override
  String get countryNepal => 'Nepal';

  @override
  String get countryJapan => 'Japan';

  @override
  String get countrySouthKorea => 'South Korea';

  @override
  String get countrySingapore => 'Singapore';

  @override
  String get countryMalaysia => 'Malaysia';

  @override
  String get countryThailand => 'Thailand';

  @override
  String get countryVietnam => 'Vietnam';

  @override
  String get countryPhilippines => 'Philippines';

  @override
  String get countryIndonesia => 'Indonesia';

  @override
  String get countryAustralia => 'Australia';

  @override
  String get countryNewZealand => 'New Zealand';

  @override
  String get countryBrazil => 'Brazil';

  @override
  String get countryArgentina => 'Argentina';

  @override
  String get countryChile => 'Chile';

  @override
  String get countryMexico => 'Mexico';

  @override
  String get countryColombia => 'Colombia';

  @override
  String get countryPeru => 'Peru';

  @override
  String get countrySouthAfrica => 'South Africa';

  @override
  String get countryNigeria => 'Nigeria';

  @override
  String get countryKenya => 'Kenya';

  @override
  String get countryEgypt => 'Egypt';

  @override
  String get countryUAE => 'UAE';

  @override
  String get countrySaudiArabia => 'Saudi Arabia';

  @override
  String get countryIsrael => 'Israel';

  @override
  String networkSpeedTestTesting(Object current, Object total, Object domain) {
    return 'Testing $current/$total • $domain';
  }

  @override
  String get networkSpeedTestDone => 'Done';

  @override
  String get vpnFooterCustomisation => 'Customisation';

  @override
  String get apkClipboardReportTitle => 'VTTI Cloud - APK Analysis Report';

  @override
  String apkClipboardAppName(Object name) {
    return 'App Name: $name';
  }

  @override
  String apkClipboardPackageId(Object packageId) {
    return 'Package ID: $packageId';
  }

  @override
  String apkClipboardVersion(Object version) {
    return 'Version: $version';
  }

  @override
  String apkClipboardFileSize(Object size) {
    return 'File Size: $size';
  }

  @override
  String apkClipboardMinSdk(Object sdk) {
    return 'Min SDK: $sdk';
  }

  @override
  String apkClipboardTargetSdk(Object sdk) {
    return 'Target SDK: $sdk';
  }

  @override
  String apkClipboardSignature(Object signature) {
    return 'Signature: $signature';
  }

  @override
  String apkClipboardMalwareRisk(Object risk) {
    return 'Malware Risk: $risk';
  }

  @override
  String apkClipboardRiskLabel(Object label) {
    return 'Risk Label: $label';
  }

  @override
  String apkClipboardHashVerdict(Object verdict) {
    return 'Hash Verdict: $verdict';
  }

  @override
  String apkClipboardRationale(Object rationale) {
    return 'Rationale: $rationale';
  }

  @override
  String get apkReportUnusualFlags => 'Unusual Flags';

  @override
  String get apkReportUnverifiedItems => 'Unverified Items';

  @override
  String get apkReportKnownMalware => 'Known Malware';

  @override
  String get apkReportSuspiciousHash => 'Suspicious Hash';

  @override
  String get apkReportCleanHash => 'Clean Hash';

  @override
  String get apkReportHashNotChecked => 'Hash Not Checked';

  @override
  String get apkReportHashUnknown => 'Hash Unknown';

  @override
  String get apkMetadataPackage => 'Package';

  @override
  String get apkMetadataPackageId => 'Package ID';

  @override
  String get apkMetadataEngine => 'Engine';

  @override
  String get apkMetadataSize => 'Size';

  @override
  String get apkMetadataMinSdk => 'Min SDK';

  @override
  String get apkMetadataTargetSdk => 'Target SDK';

  @override
  String get apkMetadataSignature => 'Signature';

  @override
  String get apkAnalyserStageDeconstructing => 'Deconstructing APK';

  @override
  String get apkAnalyserStageAnalysing => 'Analysing content';

  @override
  String get apkAnalyserSignInRequired =>
      'Please sign in via Settings to use Cloud Analysis.';

  @override
  String get apkAnalyserStageCheckingCloud => 'Checking VTTI Cloud';

  @override
  String apkAnalyserDailyLimitReached(Object limit) {
    return 'You have reached your daily limit of $limit analyses.';
  }

  @override
  String get apkAnalyserCloudAnalysisFailed => 'Cloud analysis failed';

  @override
  String get apkAnalyserStageGeneratingReport => 'Generating report';

  @override
  String get apkAnalyserAnalysisFailed => 'Failed to process APK analysis';

  @override
  String get genericError => 'Error';

  @override
  String get apkReportEngineVttiCloud => 'VTTI Cloud Engine';

  @override
  String get apkReportCertificateDetected => 'Certificate detected';

  @override
  String get apkReportNoCertificateData => 'No certificate data';

  @override
  String get apkExportOverview => 'Overview';

  @override
  String get apkExportMalwareAssessment => 'Malware Assessment';

  @override
  String get apkExportRiskScore => 'Risk Score';

  @override
  String get apkExportRiskLabel => 'Risk Label';

  @override
  String get apkExportHashVerdict => 'Hash Verdict';

  @override
  String get apkExportScoreRationale => 'Score Rationale';

  @override
  String get apkExportContributingSignals => 'Contributing Signals';

  @override
  String get apkExportDampeningFactors => 'Dampening Factors';

  @override
  String get apkExportPermissionsRequested => 'Permissions Requested';

  @override
  String get apkExportExtraFlagsUnusual => 'Extra Flags (Unusual)';

  @override
  String get apkExportExtraFlagsUnverified => 'Extra Flags (Unverified)';

  @override
  String get apkExportDiscoveredSources => 'Discovered Sources';

  @override
  String get apkExportRequestedPermissions => 'Requested Permissions';

  @override
  String get apkExportRationale => 'Rationale';

  @override
  String apkExportCsvShareText(Object name) {
    return 'APK Analysis CSV for $name';
  }

  @override
  String get apkExportPdfTitle => 'VTTI Cloud - APK Analysis';

  @override
  String apkExportPdfShareText(Object name) {
    return 'APK Analysis PDF for $name';
  }

  @override
  String get apkMetadataAppName => 'App Name';

  @override
  String get apkMetadataFileSize => 'File Size';

  @override
  String get vpnBackendFailedOpenBrowser => 'Failed to open browser.';

  @override
  String get vpnBackendSignedIn => 'Signed in.';

  @override
  String get vpnBackendSignedOut => 'Signed out.';

  @override
  String get vpnBackendSessionExpiredSignIn =>
      'Session expired. Sign in again.';

  @override
  String vpnBackendFailedLoadAccountStatus(Object status) {
    return 'Failed to load account ($status).';
  }

  @override
  String vpnBackendFailedLoadAccountError(Object error) {
    return 'Failed to load account ($error).';
  }

  @override
  String get vpnBackendSignInFirst => 'Sign in first.';

  @override
  String get vpnBackendConnecting => 'Connecting...';

  @override
  String get vpnBackendNotificationsPermissionRequired =>
      'Notifications permission required.';

  @override
  String get vpnBackendPermissionNotGranted => 'VPN permission not granted.';

  @override
  String get vpnBackendAnotherVpnActive =>
      'Another VPN is active. Disable it first.';

  @override
  String get vpnBackendProvisionIncomplete =>
      'Provision returned incomplete settings.';

  @override
  String get vpnBackendSecuringConnection => 'Securing connection...';

  @override
  String get vpnBackendConnected => 'Connected.';

  @override
  String vpnBackendWireGuardFailed(Object error) {
    return 'Failed to start WireGuard ($error).';
  }

  @override
  String get vpnBackendDisconnecting => 'Disconnecting...';

  @override
  String get vpnBackendDisconnected => 'Disconnected.';

  @override
  String vpnBackendSelectedServer(Object server) {
    return 'Selected $server';
  }

  @override
  String vpnBackendSwitchingServer(Object server) {
    return 'Switching to $server...';
  }

  @override
  String get vpnBackendKeyNotFound => 'VPN key not found.';

  @override
  String get vpnBackendDnsUpdated => 'DNS settings updated.';

  @override
  String get vpnBackendSessionExpired => 'Session expired.';

  @override
  String vpnBackendFailedStatus(Object status) {
    return 'Failed ($status).';
  }

  @override
  String get vpnBackendPlanNotAllowed =>
      'Your plan is not allowed to use Full VPN.';

  @override
  String vpnBackendProvisionFailed(Object status) {
    return 'Provision failed ($status).';
  }
}
