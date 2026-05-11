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
  String get engineReadyBanner => 'VX-TITANIUM-v8';

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
    return 'Database v$version • Auto updated';
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
  String quarantineDeleteDialogBody(Object count, Object plural) {
    return 'This will permanently delete $count item$plural.';
  }
}
