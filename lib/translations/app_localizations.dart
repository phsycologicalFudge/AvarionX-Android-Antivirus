import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_de.dart';
import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_ja.dart';
import 'app_localizations_pl.dart';
import 'app_localizations_pt.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'translations/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('de'),
    Locale('en'),
    Locale('es'),
    Locale('ja'),
    Locale('pl'),
    Locale('pt')
  ];

  /// No description provided for @appName.
  ///
  /// In en, this message translates to:
  /// **'AvarionX'**
  String get appName;

  /// No description provided for @ok.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get ok;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @footerHome.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get footerHome;

  /// No description provided for @footerExplore.
  ///
  /// In en, this message translates to:
  /// **'Explore'**
  String get footerExplore;

  /// No description provided for @footerRemoved.
  ///
  /// In en, this message translates to:
  /// **'Removed'**
  String get footerRemoved;

  /// No description provided for @footerSettings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get footerSettings;

  /// No description provided for @proBadge.
  ///
  /// In en, this message translates to:
  /// **'Premium'**
  String get proBadge;

  /// No description provided for @updateDbTitle.
  ///
  /// In en, this message translates to:
  /// **'Updating Database'**
  String get updateDbTitle;

  /// No description provided for @updateDbVersionLabel.
  ///
  /// In en, this message translates to:
  /// **'Version {version}'**
  String updateDbVersionLabel(Object version);

  /// No description provided for @companionAppsSectionTitle.
  ///
  /// In en, this message translates to:
  /// **'More from AvarionX'**
  String get companionAppsSectionTitle;

  /// No description provided for @cleanerReclaimableLabel.
  ///
  /// In en, this message translates to:
  /// **'Can be freed'**
  String get cleanerReclaimableLabel;

  /// No description provided for @exploreMultiThreadingTitle.
  ///
  /// In en, this message translates to:
  /// **'Multi-Threading'**
  String get exploreMultiThreadingTitle;

  /// No description provided for @exploreMultiThreadingSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Experimental engine control'**
  String get exploreMultiThreadingSubtitle;

  /// No description provided for @updateDbAutoDownloadLabel.
  ///
  /// In en, this message translates to:
  /// **'Automatically download future updates'**
  String get updateDbAutoDownloadLabel;

  /// No description provided for @updateDbUpdatedAutoOn.
  ///
  /// In en, this message translates to:
  /// **'Database updated • Auto updates enabled'**
  String get updateDbUpdatedAutoOn;

  /// No description provided for @updateDbUpdatedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Database updated successfully'**
  String get updateDbUpdatedSuccess;

  /// No description provided for @updateDbUpdateFailed.
  ///
  /// In en, this message translates to:
  /// **'Database update failed'**
  String get updateDbUpdateFailed;

  /// No description provided for @engineReadyBanner.
  ///
  /// In en, this message translates to:
  /// **'VX-TITANIUM-v9'**
  String get engineReadyBanner;

  /// No description provided for @scanButton.
  ///
  /// In en, this message translates to:
  /// **'Scan'**
  String get scanButton;

  /// No description provided for @scanModeFullTitle.
  ///
  /// In en, this message translates to:
  /// **'Full Device Scan'**
  String get scanModeFullTitle;

  /// No description provided for @scanModeFullSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Scans all readable storage files.'**
  String get scanModeFullSubtitle;

  /// No description provided for @scanModeSmartTitle.
  ///
  /// In en, this message translates to:
  /// **'Smart Scan [Recommended]'**
  String get scanModeSmartTitle;

  /// No description provided for @scanModeSmartSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Scans files that could contain malware.'**
  String get scanModeSmartSubtitle;

  /// No description provided for @scanModeRapidTitle.
  ///
  /// In en, this message translates to:
  /// **'Rapid Scan'**
  String get scanModeRapidTitle;

  /// No description provided for @scanModeRapidSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Checks recent APKs in Downloads.'**
  String get scanModeRapidSubtitle;

  /// No description provided for @scanModeInstalledTitle.
  ///
  /// In en, this message translates to:
  /// **'Installed Apps'**
  String get scanModeInstalledTitle;

  /// No description provided for @scanModeInstalledSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Scans your installed apps for threats.'**
  String get scanModeInstalledSubtitle;

  /// No description provided for @scanModeSingleTitle.
  ///
  /// In en, this message translates to:
  /// **'File / App Scan'**
  String get scanModeSingleTitle;

  /// No description provided for @scanModeSingleSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Pick a file or app to scan.'**
  String get scanModeSingleSubtitle;

  /// No description provided for @useCloudAssistedScan.
  ///
  /// In en, this message translates to:
  /// **'Use cloud-assisted scan'**
  String get useCloudAssistedScan;

  /// No description provided for @protectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Protection'**
  String get protectionTitle;

  /// No description provided for @stateOffLine1.
  ///
  /// In en, this message translates to:
  /// **'Device protection is off'**
  String get stateOffLine1;

  /// No description provided for @stateOffLine2.
  ///
  /// In en, this message translates to:
  /// **'Tap to turn on'**
  String get stateOffLine2;

  /// No description provided for @stateAdvancedActiveLine1.
  ///
  /// In en, this message translates to:
  /// **'Advanced protection is active'**
  String get stateAdvancedActiveLine1;

  /// No description provided for @stateFileOnlyLine1.
  ///
  /// In en, this message translates to:
  /// **'File Protection active'**
  String get stateFileOnlyLine1;

  /// No description provided for @stateFileOnlyLine2.
  ///
  /// In en, this message translates to:
  /// **'Network protection disabled'**
  String get stateFileOnlyLine2;

  /// No description provided for @stateVpnConflictLine2.
  ///
  /// In en, this message translates to:
  /// **'Another VPN is active'**
  String get stateVpnConflictLine2;

  /// No description provided for @stateProtectedLine1.
  ///
  /// In en, this message translates to:
  /// **'Device Protected'**
  String get stateProtectedLine1;

  /// No description provided for @stateProtectedLine2.
  ///
  /// In en, this message translates to:
  /// **'Tap to turn off'**
  String get stateProtectedLine2;

  /// No description provided for @dbUpdating.
  ///
  /// In en, this message translates to:
  /// **'Database updating'**
  String get dbUpdating;

  /// No description provided for @dbVersionAutoUpdated.
  ///
  /// In en, this message translates to:
  /// **'Database v{version}'**
  String dbVersionAutoUpdated(Object version);

  /// No description provided for @rtpInfoTitle.
  ///
  /// In en, this message translates to:
  /// **'Realtime Protection'**
  String get rtpInfoTitle;

  /// No description provided for @rtpInfoBody.
  ///
  /// In en, this message translates to:
  /// **'Along with blocking suspicious files downloaded intentionally (or by malware), RTP uses a local VPN to block malicious domains system-wide.\n\nWhen enabled, network filtering remains active unless:\n• Disabled manually via Terminal\n• Replaced by another VPN\n\nFile protection continues regardless as long as RTP is enabled.'**
  String get rtpInfoBody;

  /// No description provided for @scanTitleDefault.
  ///
  /// In en, this message translates to:
  /// **'Scan'**
  String get scanTitleDefault;

  /// No description provided for @scanTitleSmart.
  ///
  /// In en, this message translates to:
  /// **'Smart Scan'**
  String get scanTitleSmart;

  /// No description provided for @scanTitleRapid.
  ///
  /// In en, this message translates to:
  /// **'Rapid Scan'**
  String get scanTitleRapid;

  /// No description provided for @scanTitleInstalled.
  ///
  /// In en, this message translates to:
  /// **'Scan Installed Apps'**
  String get scanTitleInstalled;

  /// No description provided for @scanTitleFull.
  ///
  /// In en, this message translates to:
  /// **'Full Device Scan'**
  String get scanTitleFull;

  /// No description provided for @scanTitleSingle.
  ///
  /// In en, this message translates to:
  /// **'Single Scan'**
  String get scanTitleSingle;

  /// No description provided for @cancellingScan.
  ///
  /// In en, this message translates to:
  /// **'Cancelling scan…'**
  String get cancellingScan;

  /// No description provided for @cancelScan.
  ///
  /// In en, this message translates to:
  /// **'Cancel Scan'**
  String get cancelScan;

  /// No description provided for @scanProgressZero.
  ///
  /// In en, this message translates to:
  /// **'Progress: 0%'**
  String get scanProgressZero;

  /// No description provided for @scanProgressWithPct.
  ///
  /// In en, this message translates to:
  /// **'Progress: {pct}% ({scanned} / {total})'**
  String scanProgressWithPct(Object pct, Object scanned, Object total);

  /// No description provided for @scanProgressFullItems.
  ///
  /// In en, this message translates to:
  /// **'Scanned: {count} items'**
  String scanProgressFullItems(Object count);

  /// No description provided for @initializing.
  ///
  /// In en, this message translates to:
  /// **'Initializing...'**
  String get initializing;

  /// No description provided for @scanningEllipsis.
  ///
  /// In en, this message translates to:
  /// **'Scanning...'**
  String get scanningEllipsis;

  /// No description provided for @fullScanInfoTitle.
  ///
  /// In en, this message translates to:
  /// **'Full Device Scan'**
  String get fullScanInfoTitle;

  /// No description provided for @fullScanInfoBody.
  ///
  /// In en, this message translates to:
  /// **'This mode scans every readable file in storage, unfiltered.\n\nCloud-assisted scanning and app scanning are not used in this mode.'**
  String get fullScanInfoBody;

  /// No description provided for @scanComplete.
  ///
  /// In en, this message translates to:
  /// **'Scan Complete'**
  String get scanComplete;

  /// No description provided for @pillSuspiciousCount.
  ///
  /// In en, this message translates to:
  /// **'Suspicious: {count}'**
  String pillSuspiciousCount(Object count);

  /// No description provided for @pillCleanCount.
  ///
  /// In en, this message translates to:
  /// **'Clean: {count}'**
  String pillCleanCount(Object count);

  /// No description provided for @pillScannedCount.
  ///
  /// In en, this message translates to:
  /// **'Scanned: {count}'**
  String pillScannedCount(Object count);

  /// No description provided for @resultNoThreatsTitle.
  ///
  /// In en, this message translates to:
  /// **'No threats detected'**
  String get resultNoThreatsTitle;

  /// No description provided for @resultNoThreatsBody.
  ///
  /// In en, this message translates to:
  /// **'No threats detected in scanned items.'**
  String get resultNoThreatsBody;

  /// No description provided for @resultSuspiciousAppsTitle.
  ///
  /// In en, this message translates to:
  /// **'Suspicious apps'**
  String get resultSuspiciousAppsTitle;

  /// No description provided for @resultSuspiciousItemsTitle.
  ///
  /// In en, this message translates to:
  /// **'Suspicious items'**
  String get resultSuspiciousItemsTitle;

  /// No description provided for @returnHome.
  ///
  /// In en, this message translates to:
  /// **'Return Home'**
  String get returnHome;

  /// No description provided for @emptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No vulnerable files to scan'**
  String get emptyTitle;

  /// No description provided for @emptyBody.
  ///
  /// In en, this message translates to:
  /// **'Your device did not contain any files matching the scan criteria.'**
  String get emptyBody;

  /// No description provided for @knownMalware.
  ///
  /// In en, this message translates to:
  /// **'Known malware'**
  String get knownMalware;

  /// No description provided for @suspiciousActivityDetected.
  ///
  /// In en, this message translates to:
  /// **'Suspicious activity detected'**
  String get suspiciousActivityDetected;

  /// No description provided for @maliciousActivityDetected.
  ///
  /// In en, this message translates to:
  /// **'Malicious activity detected'**
  String get maliciousActivityDetected;

  /// No description provided for @androidBankingTrojan.
  ///
  /// In en, this message translates to:
  /// **'Android banking trojan'**
  String get androidBankingTrojan;

  /// No description provided for @androidSpyware.
  ///
  /// In en, this message translates to:
  /// **'Android spyware'**
  String get androidSpyware;

  /// No description provided for @androidAdware.
  ///
  /// In en, this message translates to:
  /// **'Android adware'**
  String get androidAdware;

  /// No description provided for @androidSmsFraud.
  ///
  /// In en, this message translates to:
  /// **'Android SMS fraud'**
  String get androidSmsFraud;

  /// No description provided for @threatLevelConfirmed.
  ///
  /// In en, this message translates to:
  /// **'Confirmed'**
  String get threatLevelConfirmed;

  /// No description provided for @threatLevelHigh.
  ///
  /// In en, this message translates to:
  /// **'High'**
  String get threatLevelHigh;

  /// No description provided for @threatLevelMedium.
  ///
  /// In en, this message translates to:
  /// **'Medium'**
  String get threatLevelMedium;

  /// No description provided for @threatLevelLabel.
  ///
  /// In en, this message translates to:
  /// **'Threat level: {level}'**
  String threatLevelLabel(Object level);

  /// No description provided for @explainFoundInCloud.
  ///
  /// In en, this message translates to:
  /// **'This item is listed in the ColourSwift cloud threat database.'**
  String get explainFoundInCloud;

  /// No description provided for @explainFoundInOffline.
  ///
  /// In en, this message translates to:
  /// **'This item is listed in the offline malware database on your device.'**
  String get explainFoundInOffline;

  /// No description provided for @explainBanker.
  ///
  /// In en, this message translates to:
  /// **'Designed to steal financial credentials, often using overlays, keylogging, or traffic interception.'**
  String get explainBanker;

  /// No description provided for @explainSpyware.
  ///
  /// In en, this message translates to:
  /// **'Silently monitors activity or collects personal data such as messages, location, or device identifiers.'**
  String get explainSpyware;

  /// No description provided for @explainAdware.
  ///
  /// In en, this message translates to:
  /// **'Displays intrusive ads, performs redirects, or generates fraudulent ad traffic.'**
  String get explainAdware;

  /// No description provided for @explainSmsFraud.
  ///
  /// In en, this message translates to:
  /// **'Attempts to send or trigger SMS actions without consent, which can cause unexpected charges.'**
  String get explainSmsFraud;

  /// No description provided for @explainGenericMalware.
  ///
  /// In en, this message translates to:
  /// **'Strong indicators of malicious intent were detected, even though it does not match a named family.'**
  String get explainGenericMalware;

  /// No description provided for @explainSuspiciousDefault.
  ///
  /// In en, this message translates to:
  /// **'Indicators of suspicious behavior were detected. This can include abuse patterns seen in malware, but it may also be a false positive.'**
  String get explainSuspiciousDefault;

  /// No description provided for @singleChoiceScanFile.
  ///
  /// In en, this message translates to:
  /// **'Scan a file'**
  String get singleChoiceScanFile;

  /// No description provided for @singleChoiceScanInstalledApp.
  ///
  /// In en, this message translates to:
  /// **'Scan an installed app'**
  String get singleChoiceScanInstalledApp;

  /// No description provided for @singleChoiceManageExclusions.
  ///
  /// In en, this message translates to:
  /// **'Manage exclusions'**
  String get singleChoiceManageExclusions;

  /// No description provided for @labelKnownMalwareDb.
  ///
  /// In en, this message translates to:
  /// **'Found in malware database'**
  String get labelKnownMalwareDb;

  /// No description provided for @labelFoundInCloudDb.
  ///
  /// In en, this message translates to:
  /// **'Found in cloud database'**
  String get labelFoundInCloudDb;

  /// No description provided for @logEngineFullDeviceScan.
  ///
  /// In en, this message translates to:
  /// **'[ENGINE] Full device scan'**
  String get logEngineFullDeviceScan;

  /// No description provided for @logEngineTargetStorage.
  ///
  /// In en, this message translates to:
  /// **'[ENGINE] Target: /storage/emulated/0'**
  String get logEngineTargetStorage;

  /// No description provided for @logEngineNoFilesFound.
  ///
  /// In en, this message translates to:
  /// **'[ENGINE] No files found.'**
  String get logEngineNoFilesFound;

  /// No description provided for @logEngineFilesEnumerated.
  ///
  /// In en, this message translates to:
  /// **'[ENGINE] Files enumerated: {count}'**
  String logEngineFilesEnumerated(Object count);

  /// No description provided for @logEngineNoReadableFilesFound.
  ///
  /// In en, this message translates to:
  /// **'[ENGINE] No readable files found.'**
  String get logEngineNoReadableFilesFound;

  /// No description provided for @logEngineInstalledAppsFound.
  ///
  /// In en, this message translates to:
  /// **'[ENGINE] Installed apps found: {count}'**
  String logEngineInstalledAppsFound(Object count);

  /// No description provided for @logModeCloudAssisted.
  ///
  /// In en, this message translates to:
  /// **'[MODE] Cloud-assisted mode'**
  String get logModeCloudAssisted;

  /// No description provided for @logModeOffline.
  ///
  /// In en, this message translates to:
  /// **'[MODE] Offline mode'**
  String get logModeOffline;

  /// No description provided for @logStageHashing.
  ///
  /// In en, this message translates to:
  /// **'[STAGE 1] Getting file hashes (cached)...'**
  String get logStageHashing;

  /// No description provided for @logStageCloudLookup.
  ///
  /// In en, this message translates to:
  /// **'[STAGE 2] Cloud hash lookup...'**
  String get logStageCloudLookup;

  /// No description provided for @logStageLocalScanning.
  ///
  /// In en, this message translates to:
  /// **'[STAGE {stage}] Local scanning files...'**
  String logStageLocalScanning(Object stage);

  /// No description provided for @logCloudHashHits.
  ///
  /// In en, this message translates to:
  /// **'[CLOUD] {count} hash hits'**
  String logCloudHashHits(Object count);

  /// No description provided for @logSummary.
  ///
  /// In en, this message translates to:
  /// **'[SUMMARY] {suspicious} suspicious • {clean} clean'**
  String logSummary(Object suspicious, Object clean);

  /// No description provided for @logErrorPrefix.
  ///
  /// In en, this message translates to:
  /// **'[ERROR] {message}'**
  String logErrorPrefix(Object message);

  /// No description provided for @genericUnknownAppName.
  ///
  /// In en, this message translates to:
  /// **'Unknown'**
  String get genericUnknownAppName;

  /// No description provided for @genericUnknownFileName.
  ///
  /// In en, this message translates to:
  /// **'Unknown'**
  String get genericUnknownFileName;

  /// No description provided for @featuresDrawerTitle.
  ///
  /// In en, this message translates to:
  /// **'Features'**
  String get featuresDrawerTitle;

  /// No description provided for @recommendedSectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Recommended'**
  String get recommendedSectionTitle;

  /// No description provided for @featureNetworkProtection.
  ///
  /// In en, this message translates to:
  /// **'Network Protection'**
  String get featureNetworkProtection;

  /// No description provided for @featureLinkChecker.
  ///
  /// In en, this message translates to:
  /// **'Link Checker'**
  String get featureLinkChecker;

  /// No description provided for @featureMetaPass.
  ///
  /// In en, this message translates to:
  /// **'MetaPass'**
  String get featureMetaPass;

  /// No description provided for @featureCleanerPro.
  ///
  /// In en, this message translates to:
  /// **'Cleaner Pro'**
  String get featureCleanerPro;

  /// No description provided for @featureTerminal.
  ///
  /// In en, this message translates to:
  /// **'Terminal'**
  String get featureTerminal;

  /// No description provided for @featureScheduledScans.
  ///
  /// In en, this message translates to:
  /// **'Scheduled Scans'**
  String get featureScheduledScans;

  /// No description provided for @networkStatusDisconnected.
  ///
  /// In en, this message translates to:
  /// **'Disconnected'**
  String get networkStatusDisconnected;

  /// No description provided for @networkStatusConnecting.
  ///
  /// In en, this message translates to:
  /// **'Connecting'**
  String get networkStatusConnecting;

  /// No description provided for @networkStatusConnected.
  ///
  /// In en, this message translates to:
  /// **'Connected'**
  String get networkStatusConnected;

  /// No description provided for @networkUsageTitle.
  ///
  /// In en, this message translates to:
  /// **'Usage'**
  String get networkUsageTitle;

  /// No description provided for @networkUsageEnableVpnToView.
  ///
  /// In en, this message translates to:
  /// **'Enable VPN to view usage.'**
  String get networkUsageEnableVpnToView;

  /// No description provided for @networkUsageUnlimited.
  ///
  /// In en, this message translates to:
  /// **'Unlimited'**
  String get networkUsageUnlimited;

  /// No description provided for @networkUsageUsedOf.
  ///
  /// In en, this message translates to:
  /// **'{used} / {limit}'**
  String networkUsageUsedOf(Object used, Object limit);

  /// No description provided for @networkUsageResetsOn.
  ///
  /// In en, this message translates to:
  /// **'Resets on {y}-{m}-{d}'**
  String networkUsageResetsOn(Object y, Object m, Object d);

  /// No description provided for @networkUsageUpdatedAt.
  ///
  /// In en, this message translates to:
  /// **'Updated {hh}:{mm}'**
  String networkUsageUpdatedAt(Object hh, Object mm);

  /// No description provided for @networkCardStatusAvailable.
  ///
  /// In en, this message translates to:
  /// **'Available'**
  String get networkCardStatusAvailable;

  /// No description provided for @networkCardStatusDisabled.
  ///
  /// In en, this message translates to:
  /// **'Disabled'**
  String get networkCardStatusDisabled;

  /// No description provided for @networkCardStatusCustom.
  ///
  /// In en, this message translates to:
  /// **'Custom'**
  String get networkCardStatusCustom;

  /// No description provided for @networkCardStatusReady.
  ///
  /// In en, this message translates to:
  /// **'Ready'**
  String get networkCardStatusReady;

  /// No description provided for @networkCardStatusOpen.
  ///
  /// In en, this message translates to:
  /// **'Open'**
  String get networkCardStatusOpen;

  /// No description provided for @networkCardStatusComingSoon.
  ///
  /// In en, this message translates to:
  /// **'Coming soon'**
  String get networkCardStatusComingSoon;

  /// No description provided for @networkCardBlocklistsTitle.
  ///
  /// In en, this message translates to:
  /// **'Blocklists'**
  String get networkCardBlocklistsTitle;

  /// No description provided for @networkCardBlocklistsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Filtering controls'**
  String get networkCardBlocklistsSubtitle;

  /// No description provided for @networkCardUpstreamTitle.
  ///
  /// In en, this message translates to:
  /// **'Upstream'**
  String get networkCardUpstreamTitle;

  /// No description provided for @networkCardUpstreamSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Resolver selection'**
  String get networkCardUpstreamSubtitle;

  /// No description provided for @networkCardAppsTitle.
  ///
  /// In en, this message translates to:
  /// **'Apps'**
  String get networkCardAppsTitle;

  /// No description provided for @networkCardAppsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Block apps on WiFi'**
  String get networkCardAppsSubtitle;

  /// No description provided for @networkCardLogsTitle.
  ///
  /// In en, this message translates to:
  /// **'Logs'**
  String get networkCardLogsTitle;

  /// No description provided for @networkCardLogsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Live DNS events'**
  String get networkCardLogsSubtitle;

  /// No description provided for @networkCardSpeedTitle.
  ///
  /// In en, this message translates to:
  /// **'Speed'**
  String get networkCardSpeedTitle;

  /// No description provided for @networkCardSpeedSubtitle.
  ///
  /// In en, this message translates to:
  /// **'DNS test'**
  String get networkCardSpeedSubtitle;

  /// No description provided for @networkCardAboutTitle.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get networkCardAboutTitle;

  /// No description provided for @networkCardAboutSubtitle.
  ///
  /// In en, this message translates to:
  /// **'GitHub'**
  String get networkCardAboutSubtitle;

  /// No description provided for @networkLogsStatusNoActivity.
  ///
  /// In en, this message translates to:
  /// **'No activity'**
  String get networkLogsStatusNoActivity;

  /// No description provided for @networkLogsStatusRecent.
  ///
  /// In en, this message translates to:
  /// **'{count} recent'**
  String networkLogsStatusRecent(Object count);

  /// No description provided for @networkResolverTitle.
  ///
  /// In en, this message translates to:
  /// **'Resolver'**
  String get networkResolverTitle;

  /// No description provided for @networkResolverIpLabel.
  ///
  /// In en, this message translates to:
  /// **'Resolver IP'**
  String get networkResolverIpLabel;

  /// No description provided for @networkResolverIpHint.
  ///
  /// In en, this message translates to:
  /// **'Example: 1.1.1.1'**
  String get networkResolverIpHint;

  /// No description provided for @networkSpeedTestTitle.
  ///
  /// In en, this message translates to:
  /// **'Speed test'**
  String get networkSpeedTestTitle;

  /// No description provided for @networkSpeedTestBody.
  ///
  /// In en, this message translates to:
  /// **'Runs a DNS speed tester using your current settings.'**
  String get networkSpeedTestBody;

  /// No description provided for @networkSpeedTestRun.
  ///
  /// In en, this message translates to:
  /// **'Run speed test'**
  String get networkSpeedTestRun;

  /// No description provided for @networkBlocklistsRecommendedTitle.
  ///
  /// In en, this message translates to:
  /// **'Recommended'**
  String get networkBlocklistsRecommendedTitle;

  /// No description provided for @networkBlocklistsCsMalwareTitle.
  ///
  /// In en, this message translates to:
  /// **'ColourSwift Malware'**
  String get networkBlocklistsCsMalwareTitle;

  /// No description provided for @networkBlocklistsCsAdsTitle.
  ///
  /// In en, this message translates to:
  /// **'ColourSwift ads'**
  String get networkBlocklistsCsAdsTitle;

  /// No description provided for @networkBlocklistsSeeGithub.
  ///
  /// In en, this message translates to:
  /// **'See GitHub for details...'**
  String get networkBlocklistsSeeGithub;

  /// No description provided for @networkBlocklistsMalwareSection.
  ///
  /// In en, this message translates to:
  /// **'Malware'**
  String get networkBlocklistsMalwareSection;

  /// No description provided for @networkBlocklistsMalwareTitle.
  ///
  /// In en, this message translates to:
  /// **'Malware blocklist'**
  String get networkBlocklistsMalwareTitle;

  /// No description provided for @networkBlocklistsMalwareSources.
  ///
  /// In en, this message translates to:
  /// **'HaGeZi TIF • URLHaus • DigitalSide • Spam404'**
  String get networkBlocklistsMalwareSources;

  /// No description provided for @networkBlocklistsAdsSection.
  ///
  /// In en, this message translates to:
  /// **'Ads'**
  String get networkBlocklistsAdsSection;

  /// No description provided for @networkBlocklistsAdsTitle.
  ///
  /// In en, this message translates to:
  /// **'Ads blocklist'**
  String get networkBlocklistsAdsTitle;

  /// No description provided for @networkBlocklistsAdsSources.
  ///
  /// In en, this message translates to:
  /// **'OISD • AdAway • Yoyo • AnudeepND • Firebog AdGuard'**
  String get networkBlocklistsAdsSources;

  /// No description provided for @networkBlocklistsTrackersSection.
  ///
  /// In en, this message translates to:
  /// **'Trackers'**
  String get networkBlocklistsTrackersSection;

  /// No description provided for @networkBlocklistsTrackersTitle.
  ///
  /// In en, this message translates to:
  /// **'Trackers blocklist'**
  String get networkBlocklistsTrackersTitle;

  /// No description provided for @networkBlocklistsTrackersSources.
  ///
  /// In en, this message translates to:
  /// **'EasyPrivacy • Disconnect • Frogeye • Perflyst • WindowsSpyBlocker'**
  String get networkBlocklistsTrackersSources;

  /// No description provided for @networkBlocklistsGamblingSection.
  ///
  /// In en, this message translates to:
  /// **'Gambling'**
  String get networkBlocklistsGamblingSection;

  /// No description provided for @networkBlocklistsGamblingTitle.
  ///
  /// In en, this message translates to:
  /// **'Gambling blocklist'**
  String get networkBlocklistsGamblingTitle;

  /// No description provided for @networkBlocklistsGamblingSources.
  ///
  /// In en, this message translates to:
  /// **'HaGeZi Gambling'**
  String get networkBlocklistsGamblingSources;

  /// No description provided for @networkBlocklistsSocialSection.
  ///
  /// In en, this message translates to:
  /// **'Social media'**
  String get networkBlocklistsSocialSection;

  /// No description provided for @networkBlocklistsSocialTitle.
  ///
  /// In en, this message translates to:
  /// **'Social media blocklist'**
  String get networkBlocklistsSocialTitle;

  /// No description provided for @networkBlocklistsSocialSources.
  ///
  /// In en, this message translates to:
  /// **'HaGeZi Social'**
  String get networkBlocklistsSocialSources;

  /// No description provided for @networkBlocklistsAdultSection.
  ///
  /// In en, this message translates to:
  /// **'18+'**
  String get networkBlocklistsAdultSection;

  /// No description provided for @networkBlocklistsAdultTitle.
  ///
  /// In en, this message translates to:
  /// **'Adult blocklist'**
  String get networkBlocklistsAdultTitle;

  /// No description provided for @networkBlocklistsAdultSources.
  ///
  /// In en, this message translates to:
  /// **'StevenBlack 18+ • HaGeZi NSFW'**
  String get networkBlocklistsAdultSources;

  /// No description provided for @networkLiveLogsTitle.
  ///
  /// In en, this message translates to:
  /// **'Live logs'**
  String get networkLiveLogsTitle;

  /// No description provided for @networkLiveLogsEmpty.
  ///
  /// In en, this message translates to:
  /// **'No requests yet.'**
  String get networkLiveLogsEmpty;

  /// No description provided for @networkLiveLogsBlocked.
  ///
  /// In en, this message translates to:
  /// **'Blocked'**
  String get networkLiveLogsBlocked;

  /// No description provided for @networkLiveLogsAllowed.
  ///
  /// In en, this message translates to:
  /// **'Allowed'**
  String get networkLiveLogsAllowed;

  /// No description provided for @recommendedMetaPassDesc.
  ///
  /// In en, this message translates to:
  /// **'Generate secure offline passwords.'**
  String get recommendedMetaPassDesc;

  /// No description provided for @recommendedCleanerProDesc.
  ///
  /// In en, this message translates to:
  /// **'Find duplicates, old media, and unused apps to reclaim storage automatically.'**
  String get recommendedCleanerProDesc;

  /// No description provided for @recommendedLinkCheckerDesc.
  ///
  /// In en, this message translates to:
  /// **'Check suspicious links with the safe view feature, risk free.'**
  String get recommendedLinkCheckerDesc;

  /// No description provided for @recommendedNetworkProtectionDesc.
  ///
  /// In en, this message translates to:
  /// **'Keep your internet connection safe from malware.'**
  String get recommendedNetworkProtectionDesc;

  /// No description provided for @recommendedTerminalDesc.
  ///
  /// In en, this message translates to:
  /// **'An advanced feature for Shizuku'**
  String get recommendedTerminalDesc;

  /// No description provided for @recommendedScheduledScansDesc.
  ///
  /// In en, this message translates to:
  /// **'Automatic background scans.'**
  String get recommendedScheduledScansDesc;

  /// No description provided for @metaPassTitle.
  ///
  /// In en, this message translates to:
  /// **'MetaPass'**
  String get metaPassTitle;

  /// No description provided for @metaPassHowItWorks.
  ///
  /// In en, this message translates to:
  /// **'How MetaPass works'**
  String get metaPassHowItWorks;

  /// No description provided for @metaPassOk.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get metaPassOk;

  /// No description provided for @metaPassSettings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get metaPassSettings;

  /// No description provided for @metaPassPoweredBy.
  ///
  /// In en, this message translates to:
  /// **'powered by VX-TITANIUM'**
  String get metaPassPoweredBy;

  /// No description provided for @metaPassLoading.
  ///
  /// In en, this message translates to:
  /// **'Loading…'**
  String get metaPassLoading;

  /// No description provided for @metaPassEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No entries yet'**
  String get metaPassEmptyTitle;

  /// No description provided for @metaPassEmptyBody.
  ///
  /// In en, this message translates to:
  /// **'Add an app or website.\nPasswords are generated on-device from your secret meta password.'**
  String get metaPassEmptyBody;

  /// No description provided for @metaPassAddFirstEntry.
  ///
  /// In en, this message translates to:
  /// **'Add first entry'**
  String get metaPassAddFirstEntry;

  /// No description provided for @metaPassTapToCopyHint.
  ///
  /// In en, this message translates to:
  /// **'Tap to copy. Long-press to remove.'**
  String get metaPassTapToCopyHint;

  /// No description provided for @metaPassCopyTooltip.
  ///
  /// In en, this message translates to:
  /// **'Copy password'**
  String get metaPassCopyTooltip;

  /// No description provided for @metaPassAdd.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get metaPassAdd;

  /// No description provided for @metaPassPickFromInstalledApps.
  ///
  /// In en, this message translates to:
  /// **'Pick from installed apps'**
  String get metaPassPickFromInstalledApps;

  /// No description provided for @metaPassAddWebsiteOrLabel.
  ///
  /// In en, this message translates to:
  /// **'Add website or custom label'**
  String get metaPassAddWebsiteOrLabel;

  /// No description provided for @metaPassSelectApp.
  ///
  /// In en, this message translates to:
  /// **'Select an app'**
  String get metaPassSelectApp;

  /// No description provided for @metaPassSearchApps.
  ///
  /// In en, this message translates to:
  /// **'Search apps'**
  String get metaPassSearchApps;

  /// No description provided for @metaPassCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get metaPassCancel;

  /// No description provided for @metaPassContinue.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get metaPassContinue;

  /// No description provided for @metaPassSave.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get metaPassSave;

  /// No description provided for @metaPassAddEntryTitle.
  ///
  /// In en, this message translates to:
  /// **'Add entry'**
  String get metaPassAddEntryTitle;

  /// No description provided for @metaPassNameOrUrl.
  ///
  /// In en, this message translates to:
  /// **'Name or URL'**
  String get metaPassNameOrUrl;

  /// No description provided for @metaPassNameOrUrlHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. nextcloud, steam, example.com'**
  String get metaPassNameOrUrlHint;

  /// No description provided for @metaPassVersion.
  ///
  /// In en, this message translates to:
  /// **'Version'**
  String get metaPassVersion;

  /// No description provided for @metaPassLength.
  ///
  /// In en, this message translates to:
  /// **'Length'**
  String get metaPassLength;

  /// No description provided for @metaPassSetMetaTitle.
  ///
  /// In en, this message translates to:
  /// **'Set Meta Password'**
  String get metaPassSetMetaTitle;

  /// No description provided for @metaPassSetMetaBody.
  ///
  /// In en, this message translates to:
  /// **'Enter your meta password. It never leaves this device. All vault passwords rely on it.'**
  String get metaPassSetMetaBody;

  /// No description provided for @metaPassMetaLabel.
  ///
  /// In en, this message translates to:
  /// **'Meta password'**
  String get metaPassMetaLabel;

  /// No description provided for @metaPassRememberThisDevice.
  ///
  /// In en, this message translates to:
  /// **'Remember for this device (stored securely)'**
  String get metaPassRememberThisDevice;

  /// No description provided for @metaPassChangingMetaWarning.
  ///
  /// In en, this message translates to:
  /// **'Changing this later changes all generated passwords. Using the same meta password restores them.'**
  String get metaPassChangingMetaWarning;

  /// No description provided for @metaPassRemoveEntryTitle.
  ///
  /// In en, this message translates to:
  /// **'Remove entry'**
  String get metaPassRemoveEntryTitle;

  /// No description provided for @metaPassRemoveEntryBody.
  ///
  /// In en, this message translates to:
  /// **'Remove \"{label}\" from your vault?'**
  String metaPassRemoveEntryBody(Object label);

  /// No description provided for @metaPassRemove.
  ///
  /// In en, this message translates to:
  /// **'Remove'**
  String get metaPassRemove;

  /// No description provided for @metaPassPasswordCopied.
  ///
  /// In en, this message translates to:
  /// **'Password copied for {label} (v{version}, {length} chars)'**
  String metaPassPasswordCopied(Object label, Object version, Object length);

  /// No description provided for @metaPassGenerateFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to generate password: {error}'**
  String metaPassGenerateFailed(Object error);

  /// No description provided for @metaPassLoadAppsFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to load apps: {error}'**
  String metaPassLoadAppsFailed(Object error);

  /// No description provided for @metaPassChars.
  ///
  /// In en, this message translates to:
  /// **'{length} chars'**
  String metaPassChars(Object length);

  /// No description provided for @metaPassVersionShort.
  ///
  /// In en, this message translates to:
  /// **'v{version}'**
  String metaPassVersionShort(Object version);

  /// No description provided for @metaPassInfoBody.
  ///
  /// In en, this message translates to:
  /// **'Passwords are never stored.\n\nEach entry derives a password from:\n• Your meta password\n• The label(name)\n• The version and length\n\nReinstalling the app with the same meta password and labels regenerates the same passwords.'**
  String get metaPassInfoBody;

  /// No description provided for @passwordSettingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Password settings'**
  String get passwordSettingsTitle;

  /// No description provided for @passwordSettingsSectionMetaPass.
  ///
  /// In en, this message translates to:
  /// **'MetaPass'**
  String get passwordSettingsSectionMetaPass;

  /// No description provided for @passwordSettingsMetaPasswordTitle.
  ///
  /// In en, this message translates to:
  /// **'Meta password'**
  String get passwordSettingsMetaPasswordTitle;

  /// No description provided for @passwordSettingsMetaNotSet.
  ///
  /// In en, this message translates to:
  /// **'Not set'**
  String get passwordSettingsMetaNotSet;

  /// No description provided for @passwordSettingsMetaStoredSecurely.
  ///
  /// In en, this message translates to:
  /// **'Stored securely on this device'**
  String get passwordSettingsMetaStoredSecurely;

  /// No description provided for @passwordSettingsChange.
  ///
  /// In en, this message translates to:
  /// **'Change'**
  String get passwordSettingsChange;

  /// No description provided for @passwordSettingsSetMetaPassTitle.
  ///
  /// In en, this message translates to:
  /// **'Set MetaPass'**
  String get passwordSettingsSetMetaPassTitle;

  /// No description provided for @passwordSettingsMetaPasswordLabel.
  ///
  /// In en, this message translates to:
  /// **'Meta password'**
  String get passwordSettingsMetaPasswordLabel;

  /// No description provided for @passwordSettingsChangingAltersAll.
  ///
  /// In en, this message translates to:
  /// **'Changing this alters all passwords.\nUsing the same MetaPass restores them.'**
  String get passwordSettingsChangingAltersAll;

  /// No description provided for @passwordSettingsCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get passwordSettingsCancel;

  /// No description provided for @passwordSettingsSave.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get passwordSettingsSave;

  /// No description provided for @passwordSettingsSectionRestoreCode.
  ///
  /// In en, this message translates to:
  /// **'Restore code'**
  String get passwordSettingsSectionRestoreCode;

  /// No description provided for @passwordSettingsGenerateRestoreCode.
  ///
  /// In en, this message translates to:
  /// **'Generate restore code'**
  String get passwordSettingsGenerateRestoreCode;

  /// No description provided for @passwordSettingsCopy.
  ///
  /// In en, this message translates to:
  /// **'Copy'**
  String get passwordSettingsCopy;

  /// No description provided for @passwordSettingsRestoreCodeCopied.
  ///
  /// In en, this message translates to:
  /// **'Restore code copied'**
  String get passwordSettingsRestoreCodeCopied;

  /// No description provided for @passwordSettingsSectionRestoreFromCode.
  ///
  /// In en, this message translates to:
  /// **'Restore from code'**
  String get passwordSettingsSectionRestoreFromCode;

  /// No description provided for @passwordSettingsRestoreCodeLabel.
  ///
  /// In en, this message translates to:
  /// **'Restore code'**
  String get passwordSettingsRestoreCodeLabel;

  /// No description provided for @passwordSettingsRestore.
  ///
  /// In en, this message translates to:
  /// **'Restore'**
  String get passwordSettingsRestore;

  /// No description provided for @passwordSettingsVaultRestored.
  ///
  /// In en, this message translates to:
  /// **'Vault restored'**
  String get passwordSettingsVaultRestored;

  /// No description provided for @passwordSettingsFooterInfo.
  ///
  /// In en, this message translates to:
  /// **'Passwords are never stored.\n\nThe restore code contains only structure data. Combined with your MetaPass, it rebuilds your vault.'**
  String get passwordSettingsFooterInfo;

  /// No description provided for @onboardingAppName.
  ///
  /// In en, this message translates to:
  /// **'AVarionx Security'**
  String get onboardingAppName;

  /// No description provided for @onboardingStorageTitle.
  ///
  /// In en, this message translates to:
  /// **'Storage access'**
  String get onboardingStorageTitle;

  /// No description provided for @onboardingStorageDesc.
  ///
  /// In en, this message translates to:
  /// **'This permission is required to scan files on your device. You can grant this now or later.'**
  String get onboardingStorageDesc;

  /// No description provided for @onboardingStorageFootnote.
  ///
  /// In en, this message translates to:
  /// **'You can skip this, but you will be asked again when you choose a scan mode.'**
  String get onboardingStorageFootnote;

  /// No description provided for @onboardingStorageSnack.
  ///
  /// In en, this message translates to:
  /// **'Storage permission is required for scanning.'**
  String get onboardingStorageSnack;

  /// No description provided for @onboardingNotificationsTitle.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get onboardingNotificationsTitle;

  /// No description provided for @onboardingNotificationsDesc.
  ///
  /// In en, this message translates to:
  /// **'Used for real time alerts, scan status, and quarantine updates.'**
  String get onboardingNotificationsDesc;

  /// No description provided for @onboardingNotificationsFootnote.
  ///
  /// In en, this message translates to:
  /// **'Required by Android for RealTime Protection.'**
  String get onboardingNotificationsFootnote;

  /// No description provided for @onboardingNetworkTitle.
  ///
  /// In en, this message translates to:
  /// **'Network protection'**
  String get onboardingNetworkTitle;

  /// No description provided for @onboardingNetworkDesc.
  ///
  /// In en, this message translates to:
  /// **'Enables Wi Fi protection using Androids VPN permission.'**
  String get onboardingNetworkDesc;

  /// No description provided for @onboardingNetworkFootnote.
  ///
  /// In en, this message translates to:
  /// **'This is optional but recommended.'**
  String get onboardingNetworkFootnote;

  /// No description provided for @onboardingGranted.
  ///
  /// In en, this message translates to:
  /// **'Granted'**
  String get onboardingGranted;

  /// No description provided for @onboardingNotGranted.
  ///
  /// In en, this message translates to:
  /// **'Not granted'**
  String get onboardingNotGranted;

  /// No description provided for @onboardingGrantAccess.
  ///
  /// In en, this message translates to:
  /// **'Grant access'**
  String get onboardingGrantAccess;

  /// No description provided for @onboardingAllowNotifications.
  ///
  /// In en, this message translates to:
  /// **'Allow notifications'**
  String get onboardingAllowNotifications;

  /// No description provided for @onboardingAllowVpnAccess.
  ///
  /// In en, this message translates to:
  /// **'Allow VPN access'**
  String get onboardingAllowVpnAccess;

  /// No description provided for @onboardingBack.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get onboardingBack;

  /// No description provided for @onboardingNext.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get onboardingNext;

  /// No description provided for @onboardingFinish.
  ///
  /// In en, this message translates to:
  /// **'Finish'**
  String get onboardingFinish;

  /// No description provided for @onboardingSetupCompleteTitle.
  ///
  /// In en, this message translates to:
  /// **'Setup complete'**
  String get onboardingSetupCompleteTitle;

  /// No description provided for @onboardingSetupCompleteDesc.
  ///
  /// In en, this message translates to:
  /// **'We reccomend running a Full Device Scan (this does not scan installed apps currently), or go straight to the home screen.'**
  String get onboardingSetupCompleteDesc;

  /// No description provided for @onboardingRunFullScan.
  ///
  /// In en, this message translates to:
  /// **'Run full device scan'**
  String get onboardingRunFullScan;

  /// No description provided for @onboardingGoHome.
  ///
  /// In en, this message translates to:
  /// **'Go to home'**
  String get onboardingGoHome;

  /// No description provided for @networkProtectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Network Protection'**
  String get networkProtectionTitle;

  /// No description provided for @networkStatusConnectedToDns.
  ///
  /// In en, this message translates to:
  /// **'Connected to {dns}'**
  String networkStatusConnectedToDns(Object dns);

  /// No description provided for @networkStatusVpnConflictDetail.
  ///
  /// In en, this message translates to:
  /// **'Another VPN is active'**
  String get networkStatusVpnConflictDetail;

  /// No description provided for @networkStatusOffDetail.
  ///
  /// In en, this message translates to:
  /// **'Network protection is off'**
  String get networkStatusOffDetail;

  /// No description provided for @networkModeMalwareTitle.
  ///
  /// In en, this message translates to:
  /// **'Malware Blocking Only'**
  String get networkModeMalwareTitle;

  /// No description provided for @networkModeMalwareSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Uses 1.1.1.2'**
  String get networkModeMalwareSubtitle;

  /// No description provided for @networkModeMalwareDescription.
  ///
  /// In en, this message translates to:
  /// **'Combines AvarionX’s local malware database with Cloudflare’s online threat intelligence for maximum malware protection.'**
  String get networkModeMalwareDescription;

  /// No description provided for @networkModeAdultTitle.
  ///
  /// In en, this message translates to:
  /// **'Malware & Adult Content'**
  String get networkModeAdultTitle;

  /// No description provided for @networkModeAdultSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Uses 1.1.1.3'**
  String get networkModeAdultSubtitle;

  /// No description provided for @networkModeAdultDescription.
  ///
  /// In en, this message translates to:
  /// **'Uses AvarionX’s offline malware database and adds adult content filtering. Cloud-based malware intelligence is disabled in this mode.'**
  String get networkModeAdultDescription;

  /// No description provided for @networkInfoTitle.
  ///
  /// In en, this message translates to:
  /// **'What is Network Protection?'**
  String get networkInfoTitle;

  /// No description provided for @networkInfoBody.
  ///
  /// In en, this message translates to:
  /// **'Some threats work by connecting to malicious servers or redirecting internet traffic.\nNetwork Protection blocks known dangerous domains and common ads by using a local VPN.\n\nAVarionX Security does not collect any data.'**
  String get networkInfoBody;

  /// No description provided for @linkCheckerTitle.
  ///
  /// In en, this message translates to:
  /// **'Link Checker'**
  String get linkCheckerTitle;

  /// No description provided for @linkCheckerTabAnalyse.
  ///
  /// In en, this message translates to:
  /// **'Analyse'**
  String get linkCheckerTabAnalyse;

  /// No description provided for @linkCheckerTabView.
  ///
  /// In en, this message translates to:
  /// **'View'**
  String get linkCheckerTabView;

  /// No description provided for @linkCheckerTabHistory.
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get linkCheckerTabHistory;

  /// No description provided for @linkCheckerAnalyseSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Check page for malware or suspicious content'**
  String get linkCheckerAnalyseSubtitle;

  /// No description provided for @linkCheckerUrlLabel.
  ///
  /// In en, this message translates to:
  /// **'URL'**
  String get linkCheckerUrlLabel;

  /// No description provided for @linkCheckerUrlHint.
  ///
  /// In en, this message translates to:
  /// **'https://example.com'**
  String get linkCheckerUrlHint;

  /// No description provided for @linkCheckerButtonAnalyse.
  ///
  /// In en, this message translates to:
  /// **'Analyse'**
  String get linkCheckerButtonAnalyse;

  /// No description provided for @linkCheckerButtonChecking.
  ///
  /// In en, this message translates to:
  /// **'Checking'**
  String get linkCheckerButtonChecking;

  /// No description provided for @linkCheckerEngineNotReadySnack.
  ///
  /// In en, this message translates to:
  /// **'Engine not ready'**
  String get linkCheckerEngineNotReadySnack;

  /// No description provided for @linkCheckerStatusVerifyingLink.
  ///
  /// In en, this message translates to:
  /// **'Verifying link…'**
  String get linkCheckerStatusVerifyingLink;

  /// No description provided for @linkCheckerStatusScanningPage.
  ///
  /// In en, this message translates to:
  /// **'Scanning page…'**
  String get linkCheckerStatusScanningPage;

  /// No description provided for @linkCheckerBlockedNavigation.
  ///
  /// In en, this message translates to:
  /// **'Navigation blocked'**
  String get linkCheckerBlockedNavigation;

  /// No description provided for @linkCheckerBlockedUnsupportedType.
  ///
  /// In en, this message translates to:
  /// **'Unsupported link type'**
  String get linkCheckerBlockedUnsupportedType;

  /// No description provided for @linkCheckerBlockedInvalidDestination.
  ///
  /// In en, this message translates to:
  /// **'Invalid destination'**
  String get linkCheckerBlockedInvalidDestination;

  /// No description provided for @linkCheckerBlockedUnableResolve.
  ///
  /// In en, this message translates to:
  /// **'Unable to resolve destination'**
  String get linkCheckerBlockedUnableResolve;

  /// No description provided for @linkCheckerBlockedUnableVerify.
  ///
  /// In en, this message translates to:
  /// **'Unable to verify destination'**
  String get linkCheckerBlockedUnableVerify;

  /// No description provided for @linkCheckerAnalyseCardTitleDefault.
  ///
  /// In en, this message translates to:
  /// **'Check page for suspicious content'**
  String get linkCheckerAnalyseCardTitleDefault;

  /// No description provided for @linkCheckerAnalyseCardDetailDefault.
  ///
  /// In en, this message translates to:
  /// **'Paste a URL and run an analysis.'**
  String get linkCheckerAnalyseCardDetailDefault;

  /// No description provided for @linkCheckerAnalyseCardTitleEngineNotReady.
  ///
  /// In en, this message translates to:
  /// **'Engine not ready'**
  String get linkCheckerAnalyseCardTitleEngineNotReady;

  /// No description provided for @linkCheckerAnalyseCardDetailEngineNotReady.
  ///
  /// In en, this message translates to:
  /// **'error 1001.'**
  String get linkCheckerAnalyseCardDetailEngineNotReady;

  /// No description provided for @linkCheckerAnalyseCardTitleChecking.
  ///
  /// In en, this message translates to:
  /// **'Checking'**
  String get linkCheckerAnalyseCardTitleChecking;

  /// No description provided for @linkCheckerVerdictClean.
  ///
  /// In en, this message translates to:
  /// **'Clean'**
  String get linkCheckerVerdictClean;

  /// No description provided for @linkCheckerVerdictCleanDetail.
  ///
  /// In en, this message translates to:
  /// **'This page appears to be safe.'**
  String get linkCheckerVerdictCleanDetail;

  /// No description provided for @linkCheckerVerdictSuspicious.
  ///
  /// In en, this message translates to:
  /// **'Suspicious'**
  String get linkCheckerVerdictSuspicious;

  /// No description provided for @linkCheckerVerdictSuspiciousDetail.
  ///
  /// In en, this message translates to:
  /// **'This page contains suspicious content.'**
  String get linkCheckerVerdictSuspiciousDetail;

  /// No description provided for @linkCheckerViewLockedBody.
  ///
  /// In en, this message translates to:
  /// **'Run an analysis first to enable viewing.'**
  String get linkCheckerViewLockedBody;

  /// No description provided for @linkCheckerViewSubtitle.
  ///
  /// In en, this message translates to:
  /// **'View the webpage safely'**
  String get linkCheckerViewSubtitle;

  /// No description provided for @linkCheckerViewPage.
  ///
  /// In en, this message translates to:
  /// **'View page'**
  String get linkCheckerViewPage;

  /// No description provided for @linkCheckerClose.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get linkCheckerClose;

  /// No description provided for @linkCheckerBlockedBody.
  ///
  /// In en, this message translates to:
  /// **'This page was stopped before it could load.'**
  String get linkCheckerBlockedBody;

  /// No description provided for @linkCheckerSuspiciousBanner.
  ///
  /// In en, this message translates to:
  /// **'Suspicious link, may not render if it requires blocked content.'**
  String get linkCheckerSuspiciousBanner;

  /// No description provided for @linkCheckerHistorySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Tap an entry to copy the link.'**
  String get linkCheckerHistorySubtitle;

  /// No description provided for @linkCheckerHistoryEmpty.
  ///
  /// In en, this message translates to:
  /// **'No checks yet.'**
  String get linkCheckerHistoryEmpty;

  /// No description provided for @linkCheckerCopied.
  ///
  /// In en, this message translates to:
  /// **'Copied'**
  String get linkCheckerCopied;

  /// No description provided for @settingsSectionAppearance.
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get settingsSectionAppearance;

  /// No description provided for @settingsTheme.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get settingsTheme;

  /// No description provided for @settingsThemeCurrent.
  ///
  /// In en, this message translates to:
  /// **'Current: {theme}'**
  String settingsThemeCurrent(Object theme);

  /// No description provided for @settingsLanguage.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get settingsLanguage;

  /// No description provided for @settingsLanguageCurrent.
  ///
  /// In en, this message translates to:
  /// **'Current: {language}'**
  String settingsLanguageCurrent(Object language);

  /// No description provided for @settingsChooseLanguage.
  ///
  /// In en, this message translates to:
  /// **'Choose Language'**
  String get settingsChooseLanguage;

  /// No description provided for @settingsLanguageApplied.
  ///
  /// In en, this message translates to:
  /// **'Language applied'**
  String get settingsLanguageApplied;

  /// No description provided for @settingsSystemDefault.
  ///
  /// In en, this message translates to:
  /// **'System default'**
  String get settingsSystemDefault;

  /// No description provided for @settingsSectionCommunity.
  ///
  /// In en, this message translates to:
  /// **'Join the community!'**
  String get settingsSectionCommunity;

  /// No description provided for @settingsDiscord.
  ///
  /// In en, this message translates to:
  /// **'Discord'**
  String get settingsDiscord;

  /// No description provided for @settingsDiscordSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Chat, updates and feedback'**
  String get settingsDiscordSubtitle;

  /// No description provided for @settingsDiscordOpenFail.
  ///
  /// In en, this message translates to:
  /// **'Unable to open Discord link'**
  String get settingsDiscordOpenFail;

  /// No description provided for @settingsSectionPro.
  ///
  /// In en, this message translates to:
  /// **'PRO Features'**
  String get settingsSectionPro;

  /// No description provided for @settingsProCustomization.
  ///
  /// In en, this message translates to:
  /// **'PRO Customization'**
  String get settingsProCustomization;

  /// No description provided for @settingsProSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Go ad free, unlock unlimited DNS, themes and icons'**
  String get settingsProSubtitle;

  /// No description provided for @settingsUnlockPro.
  ///
  /// In en, this message translates to:
  /// **'Unlock Premium'**
  String get settingsUnlockPro;

  /// No description provided for @settingsProUnlocked.
  ///
  /// In en, this message translates to:
  /// **'PRO mode unlocked'**
  String get settingsProUnlocked;

  /// No description provided for @settingsPurchaseNotConfirmed.
  ///
  /// In en, this message translates to:
  /// **'Purchase not confirmed'**
  String get settingsPurchaseNotConfirmed;

  /// No description provided for @settingsPurchaseFailed.
  ///
  /// In en, this message translates to:
  /// **'Purchase failed: {error}'**
  String settingsPurchaseFailed(Object error);

  /// No description provided for @homeUpgrade.
  ///
  /// In en, this message translates to:
  /// **'Upgrade'**
  String get homeUpgrade;

  /// No description provided for @homeFeatureSecureVpnTitle.
  ///
  /// In en, this message translates to:
  /// **'AvarionX Secure VPN'**
  String get homeFeatureSecureVpnTitle;

  /// No description provided for @homeFeatureSecureVpnDesc.
  ///
  /// In en, this message translates to:
  /// **'Hide your IP and block unwanted ads'**
  String get homeFeatureSecureVpnDesc;

  /// No description provided for @proActivated.
  ///
  /// In en, this message translates to:
  /// **'PRO activated'**
  String get proActivated;

  /// No description provided for @proDeactivated.
  ///
  /// In en, this message translates to:
  /// **'PRO deactivated'**
  String get proDeactivated;

  /// No description provided for @settingsProReset.
  ///
  /// In en, this message translates to:
  /// **'PRO reset (debug only)'**
  String get settingsProReset;

  /// No description provided for @settingsProSheetTitle.
  ///
  /// In en, this message translates to:
  /// **'PRO Customization'**
  String get settingsProSheetTitle;

  /// No description provided for @settingsHideGoldHeader.
  ///
  /// In en, this message translates to:
  /// **'Show gold header on Home Screen (dark themes)'**
  String get settingsHideGoldHeader;

  /// No description provided for @settingsAppIcon.
  ///
  /// In en, this message translates to:
  /// **'App Icon'**
  String get settingsAppIcon;

  /// No description provided for @settingsIconSelected.
  ///
  /// In en, this message translates to:
  /// **'Icon selected: {icon}'**
  String settingsIconSelected(Object icon);

  /// No description provided for @vpnSignInRequiredTitle.
  ///
  /// In en, this message translates to:
  /// **'Sign in required'**
  String get vpnSignInRequiredTitle;

  /// No description provided for @vpnClose.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get vpnClose;

  /// No description provided for @vpnSignInRequiredBody.
  ///
  /// In en, this message translates to:
  /// **'Sign in to use Secure VPN.'**
  String get vpnSignInRequiredBody;

  /// No description provided for @vpnCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get vpnCancel;

  /// No description provided for @vpnSignIn.
  ///
  /// In en, this message translates to:
  /// **'Sign in'**
  String get vpnSignIn;

  /// No description provided for @vpnUsageLoading.
  ///
  /// In en, this message translates to:
  /// **'Loading usage...'**
  String get vpnUsageLoading;

  /// No description provided for @vpnUsageNoLimits.
  ///
  /// In en, this message translates to:
  /// **'No data limits'**
  String get vpnUsageNoLimits;

  /// No description provided for @vpnUsageSyncing.
  ///
  /// In en, this message translates to:
  /// **'Syncing'**
  String get vpnUsageSyncing;

  /// No description provided for @vpnUsageUsedThisMonth.
  ///
  /// In en, this message translates to:
  /// **'{used} used this month'**
  String vpnUsageUsedThisMonth(Object used);

  /// No description provided for @vpnUsageDataTitle.
  ///
  /// In en, this message translates to:
  /// **'Data Usage'**
  String get vpnUsageDataTitle;

  /// No description provided for @vpnUsageUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Usage unavailable'**
  String get vpnUsageUnavailable;

  /// No description provided for @vpnStatusConnectingEllipsis.
  ///
  /// In en, this message translates to:
  /// **'Connecting...'**
  String get vpnStatusConnectingEllipsis;

  /// No description provided for @vpnStatusConnectedTo.
  ///
  /// In en, this message translates to:
  /// **'Connected to {country}'**
  String vpnStatusConnectedTo(Object country);

  /// No description provided for @vpnTitleSecure.
  ///
  /// In en, this message translates to:
  /// **'Secure VPN'**
  String get vpnTitleSecure;

  /// No description provided for @vpnStatusConnected.
  ///
  /// In en, this message translates to:
  /// **'Connected'**
  String get vpnStatusConnected;

  /// No description provided for @vpnSubtitleEstablishingTunnel.
  ///
  /// In en, this message translates to:
  /// **'Establishing tunnel...'**
  String get vpnSubtitleEstablishingTunnel;

  /// No description provided for @vpnSubtitleFindingLocation.
  ///
  /// In en, this message translates to:
  /// **'Finding location...'**
  String get vpnSubtitleFindingLocation;

  /// No description provided for @vpnStatusProtected.
  ///
  /// In en, this message translates to:
  /// **'Protected'**
  String get vpnStatusProtected;

  /// No description provided for @vpnStatusNotConnected.
  ///
  /// In en, this message translates to:
  /// **'Not connected'**
  String get vpnStatusNotConnected;

  /// No description provided for @vpnConnect.
  ///
  /// In en, this message translates to:
  /// **'Connect'**
  String get vpnConnect;

  /// No description provided for @vpnDisconnect.
  ///
  /// In en, this message translates to:
  /// **'Disconnect'**
  String get vpnDisconnect;

  /// No description provided for @vpnIpLabel.
  ///
  /// In en, this message translates to:
  /// **'IP: {ip}'**
  String vpnIpLabel(Object ip);

  /// No description provided for @vpnServerLoadLabel.
  ///
  /// In en, this message translates to:
  /// **'{current}/{max}'**
  String vpnServerLoadLabel(Object current, Object max);

  /// No description provided for @vpnBlocklistsTitle.
  ///
  /// In en, this message translates to:
  /// **'Secure VPN Blocklists'**
  String get vpnBlocklistsTitle;

  /// No description provided for @vpnSave.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get vpnSave;

  /// No description provided for @settingsSave.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get settingsSave;

  /// No description provided for @settingsPremium.
  ///
  /// In en, this message translates to:
  /// **'Premium'**
  String get settingsPremium;

  /// No description provided for @settingsUltimateSecurity.
  ///
  /// In en, this message translates to:
  /// **'Ultimate Security'**
  String get settingsUltimateSecurity;

  /// No description provided for @settingsSwitchPlan.
  ///
  /// In en, this message translates to:
  /// **'Switch plan'**
  String get settingsSwitchPlan;

  /// No description provided for @settingsBestValue.
  ///
  /// In en, this message translates to:
  /// **'Best value'**
  String get settingsBestValue;

  /// No description provided for @settingsOneTime.
  ///
  /// In en, this message translates to:
  /// **'One time'**
  String get settingsOneTime;

  /// No description provided for @settingsPlanPriceLoading.
  ///
  /// In en, this message translates to:
  /// **'Price loading...'**
  String get settingsPlanPriceLoading;

  /// No description provided for @settingsMonthly.
  ///
  /// In en, this message translates to:
  /// **'Monthly'**
  String get settingsMonthly;

  /// No description provided for @settingsYearly.
  ///
  /// In en, this message translates to:
  /// **'Yearly'**
  String get settingsYearly;

  /// No description provided for @settingsLifetime.
  ///
  /// In en, this message translates to:
  /// **'Lifetime'**
  String get settingsLifetime;

  /// No description provided for @settingsSubscribeMonthly.
  ///
  /// In en, this message translates to:
  /// **'Subscribe monthly'**
  String get settingsSubscribeMonthly;

  /// No description provided for @settingsSubscribeYearly.
  ///
  /// In en, this message translates to:
  /// **'Subscribe yearly'**
  String get settingsSubscribeYearly;

  /// No description provided for @settingsUnlockLifetime.
  ///
  /// In en, this message translates to:
  /// **'Unlock lifetime'**
  String get settingsUnlockLifetime;

  /// No description provided for @settingsProBenefitsTitle.
  ///
  /// In en, this message translates to:
  /// **'Benefits'**
  String get settingsProBenefitsTitle;

  /// No description provided for @settingsUnlimitedDnsTitle.
  ///
  /// In en, this message translates to:
  /// **'Unlimited DNS queries'**
  String get settingsUnlimitedDnsTitle;

  /// No description provided for @settingsUnlimitedDnsBody.
  ///
  /// In en, this message translates to:
  /// **'Remove query limits and unlock full cloud filtering.'**
  String get settingsUnlimitedDnsBody;

  /// No description provided for @settingsThemesTitle.
  ///
  /// In en, this message translates to:
  /// **'Themes'**
  String get settingsThemesTitle;

  /// No description provided for @settingsThemesBody.
  ///
  /// In en, this message translates to:
  /// **'Unlock premium themes and customization.'**
  String get settingsThemesBody;

  /// No description provided for @settingsIconCustomizationTitle.
  ///
  /// In en, this message translates to:
  /// **'App icon customization'**
  String get settingsIconCustomizationTitle;

  /// No description provided for @settingsIconCustomizationBody.
  ///
  /// In en, this message translates to:
  /// **'Change the app icon to match your style.'**
  String get settingsIconCustomizationBody;

  /// No description provided for @settingsScheduledScansTitle.
  ///
  /// In en, this message translates to:
  /// **'Scheduled scans'**
  String get settingsScheduledScansTitle;

  /// No description provided for @settingsScheduledScansBody.
  ///
  /// In en, this message translates to:
  /// **'Unlock advanced scheduling and scan customization.'**
  String get settingsScheduledScansBody;

  /// No description provided for @settingsProFinePrint.
  ///
  /// In en, this message translates to:
  /// **'Subscriptions renew unless canceled. You can manage or cancel anytime in Google Play. Lifetime is a one time purchase.'**
  String get settingsProFinePrint;

  /// No description provided for @settingsSectionShizuku.
  ///
  /// In en, this message translates to:
  /// **'Advanced Protection (Shizuku)'**
  String get settingsSectionShizuku;

  /// No description provided for @settingsEnableShizuku.
  ///
  /// In en, this message translates to:
  /// **'Enable Shizuku'**
  String get settingsEnableShizuku;

  /// No description provided for @settingsShizukuRequiresManager.
  ///
  /// In en, this message translates to:
  /// **'Requires external manager'**
  String get settingsShizukuRequiresManager;

  /// No description provided for @settingsShizukuNotRunning.
  ///
  /// In en, this message translates to:
  /// **'Shizuku service not running'**
  String get settingsShizukuNotRunning;

  /// No description provided for @settingsShizukuPermissionRequired.
  ///
  /// In en, this message translates to:
  /// **'Permission required'**
  String get settingsShizukuPermissionRequired;

  /// No description provided for @settingsShizukuAvailable.
  ///
  /// In en, this message translates to:
  /// **'Advanced system access available'**
  String get settingsShizukuAvailable;

  /// No description provided for @settingsAboutAdvancedProtection.
  ///
  /// In en, this message translates to:
  /// **'About Advanced Protection'**
  String get settingsAboutAdvancedProtection;

  /// No description provided for @settingsAboutAdvancedProtectionSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Learn how advanced protection works'**
  String get settingsAboutAdvancedProtectionSubtitle;

  /// No description provided for @settingsAdvancedProtectionDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'Advanced system Protection'**
  String get settingsAdvancedProtectionDialogTitle;

  /// No description provided for @settingsAdvancedProtectionDialogBody.
  ///
  /// In en, this message translates to:
  /// **'Shizuku access requires an external manager intended for advanced users.\n\nThis feature is optional and not recommended for casual protection.'**
  String get settingsAdvancedProtectionDialogBody;

  /// No description provided for @settingsAboutShizukuTitle.
  ///
  /// In en, this message translates to:
  /// **'About Shizuku'**
  String get settingsAboutShizukuTitle;

  /// No description provided for @settingsAboutShizukuBody.
  ///
  /// In en, this message translates to:
  /// **'AVarionX can integrate with Shizuku to access app processes at the system level.\n\nThis allows the app to:\n• Detect malware that hides from standard scanners\n• Inspect running app processes\n• Disable or contain most active malware\n\nShizuku however, does not grant root access\n\nThis feature is intended for advanced users and is not required for normal protection.\n\nDocumentation:\nhttps://shizuku.rikka.app'**
  String get settingsAboutShizukuBody;

  /// No description provided for @settingsSectionGeneral.
  ///
  /// In en, this message translates to:
  /// **'General'**
  String get settingsSectionGeneral;

  /// No description provided for @settingsExclusions.
  ///
  /// In en, this message translates to:
  /// **'Exclusions'**
  String get settingsExclusions;

  /// No description provided for @settingsExclusionsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Manage and add exclusions'**
  String get settingsExclusionsSubtitle;

  /// No description provided for @settingsExcludeFolder.
  ///
  /// In en, this message translates to:
  /// **'Exclude a Folder'**
  String get settingsExcludeFolder;

  /// No description provided for @settingsExcludeFile.
  ///
  /// In en, this message translates to:
  /// **'Exclude a File'**
  String get settingsExcludeFile;

  /// No description provided for @settingsManageExclusions.
  ///
  /// In en, this message translates to:
  /// **'Manage Existing Exclusions'**
  String get settingsManageExclusions;

  /// No description provided for @settingsManageExclusionsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'View or remove exclusions'**
  String get settingsManageExclusionsSubtitle;

  /// No description provided for @settingsFolderExcluded.
  ///
  /// In en, this message translates to:
  /// **'Folder excluded'**
  String get settingsFolderExcluded;

  /// No description provided for @settingsFileExcluded.
  ///
  /// In en, this message translates to:
  /// **'File excluded'**
  String get settingsFileExcluded;

  /// No description provided for @settingsPrivacyPolicy.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get settingsPrivacyPolicy;

  /// No description provided for @settingsPrivacyPolicySubtitle.
  ///
  /// In en, this message translates to:
  /// **'View how your data is handled'**
  String get settingsPrivacyPolicySubtitle;

  /// No description provided for @settingsPrivacyPolicyOpenFail.
  ///
  /// In en, this message translates to:
  /// **'Unable to open privacy policy'**
  String get settingsPrivacyPolicyOpenFail;

  /// No description provided for @settingsAboutApp.
  ///
  /// In en, this message translates to:
  /// **'About AVarionX'**
  String get settingsAboutApp;

  /// No description provided for @settingsHowThisAppWorks.
  ///
  /// In en, this message translates to:
  /// **'How This App Works'**
  String get settingsHowThisAppWorks;

  /// No description provided for @settingsHowThisAppWorksSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Learn about protection'**
  String get settingsHowThisAppWorksSubtitle;

  /// No description provided for @settingsThemePickerTitle.
  ///
  /// In en, this message translates to:
  /// **'Choose Theme'**
  String get settingsThemePickerTitle;

  /// No description provided for @settingsThemeRequiresPro.
  ///
  /// In en, this message translates to:
  /// **'That theme requires PRO mode'**
  String get settingsThemeRequiresPro;

  /// No description provided for @scheduledScansTitle.
  ///
  /// In en, this message translates to:
  /// **'Scheduled Scans'**
  String get scheduledScansTitle;

  /// No description provided for @scheduledScansInfoTitle.
  ///
  /// In en, this message translates to:
  /// **'Scheduled Scans'**
  String get scheduledScansInfoTitle;

  /// No description provided for @scheduledScansInfoBody.
  ///
  /// In en, this message translates to:
  /// **'While RTP focuses on downloaded malware, Scheduled Scans will automatically launch your chosen scan mode in the background.\nIt will only run while RTP is enabled.\n\nPRO users can customize scan mode and frequency.'**
  String get scheduledScansInfoBody;

  /// No description provided for @scheduledScansHeader.
  ///
  /// In en, this message translates to:
  /// **'Automatic background scans'**
  String get scheduledScansHeader;

  /// No description provided for @scheduledScansSubheader.
  ///
  /// In en, this message translates to:
  /// **'While RTP is active, the app will scan your device based on the selected scan mode and frequency.'**
  String get scheduledScansSubheader;

  /// No description provided for @proRequiredToCustomize.
  ///
  /// In en, this message translates to:
  /// **'PRO required to customize'**
  String get proRequiredToCustomize;

  /// No description provided for @scheduledScansEnabledTitle.
  ///
  /// In en, this message translates to:
  /// **'Enabled'**
  String get scheduledScansEnabledTitle;

  /// No description provided for @scheduledScansEnabledSubtitle.
  ///
  /// In en, this message translates to:
  /// **'When enabled, a scan runs automatically on your chosen schedule.'**
  String get scheduledScansEnabledSubtitle;

  /// No description provided for @scheduledScansModeTitle.
  ///
  /// In en, this message translates to:
  /// **'Scan mode'**
  String get scheduledScansModeTitle;

  /// No description provided for @scheduledScansModeHint.
  ///
  /// In en, this message translates to:
  /// **'Current mode: {mode}'**
  String scheduledScansModeHint(Object mode);

  /// No description provided for @scheduledScansFrequencyTitle.
  ///
  /// In en, this message translates to:
  /// **'Frequency'**
  String get scheduledScansFrequencyTitle;

  /// No description provided for @scheduledScansFrequencyHint.
  ///
  /// In en, this message translates to:
  /// **'Runs: {freq}'**
  String scheduledScansFrequencyHint(Object freq);

  /// No description provided for @scheduledEveryDay.
  ///
  /// In en, this message translates to:
  /// **'Every day'**
  String get scheduledEveryDay;

  /// No description provided for @scheduledEvery3Days.
  ///
  /// In en, this message translates to:
  /// **'Every 3 days'**
  String get scheduledEvery3Days;

  /// No description provided for @scheduledEveryWeek.
  ///
  /// In en, this message translates to:
  /// **'Every week'**
  String get scheduledEveryWeek;

  /// No description provided for @scheduledEvery2Weeks.
  ///
  /// In en, this message translates to:
  /// **'Every 2 weeks'**
  String get scheduledEvery2Weeks;

  /// No description provided for @scheduledEvery3Weeks.
  ///
  /// In en, this message translates to:
  /// **'Every 3 weeks'**
  String get scheduledEvery3Weeks;

  /// No description provided for @scheduledMonthly.
  ///
  /// In en, this message translates to:
  /// **'Monthly'**
  String get scheduledMonthly;

  /// No description provided for @scheduledEveryDays.
  ///
  /// In en, this message translates to:
  /// **'Every {days} days'**
  String scheduledEveryDays(Object days);

  /// No description provided for @scheduledEveryHours.
  ///
  /// In en, this message translates to:
  /// **'Every {hours} hours'**
  String scheduledEveryHours(Object hours);

  /// No description provided for @vpnSettingsPrivacySecurityTitle.
  ///
  /// In en, this message translates to:
  /// **'Privacy & Security'**
  String get vpnSettingsPrivacySecurityTitle;

  /// No description provided for @vpnSettingsNoLogsPolicyTitle.
  ///
  /// In en, this message translates to:
  /// **'No logs stored Policy'**
  String get vpnSettingsNoLogsPolicyTitle;

  /// No description provided for @vpnSettingsNoLogsPolicyBody.
  ///
  /// In en, this message translates to:
  /// **'No logs are stored. Connection activity, browsing activity, DNS queries, and traffic content are not recorded or retained.'**
  String get vpnSettingsNoLogsPolicyBody;

  /// No description provided for @vpnSettingsNoActivityLogsTitle.
  ///
  /// In en, this message translates to:
  /// **'No activity logs'**
  String get vpnSettingsNoActivityLogsTitle;

  /// No description provided for @vpnSettingsNoActivityLogsBody.
  ///
  /// In en, this message translates to:
  /// **'Your activity is not monitored or tracked while using Secure VPN.'**
  String get vpnSettingsNoActivityLogsBody;

  /// No description provided for @vpnSettingsWireGuardTitle.
  ///
  /// In en, this message translates to:
  /// **'VX-Link powered by WireGuard'**
  String get vpnSettingsWireGuardTitle;

  /// No description provided for @vpnSettingsWireGuardBody.
  ///
  /// In en, this message translates to:
  /// **'Secure VPN uses the WireGuard protocol through VX-Link to provide fast, modern encryption.'**
  String get vpnSettingsWireGuardBody;

  /// No description provided for @vpnSettingsMalwareProtectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Malware protection enabled'**
  String get vpnSettingsMalwareProtectionTitle;

  /// No description provided for @vpnSettingsMalwareProtectionBody.
  ///
  /// In en, this message translates to:
  /// **'Malicious domains are blocked by default while connected.'**
  String get vpnSettingsMalwareProtectionBody;

  /// No description provided for @vpnSettingsAdTrackerProtectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Optional ad and tracker protection'**
  String get vpnSettingsAdTrackerProtectionTitle;

  /// No description provided for @vpnSettingsAdTrackerProtectionBody.
  ///
  /// In en, this message translates to:
  /// **'Enable additional blocking for ads and trackers in the Customisation tab.'**
  String get vpnSettingsAdTrackerProtectionBody;

  /// No description provided for @vpnSettingsBrandFooter.
  ///
  /// In en, this message translates to:
  /// **'Secured by VX-Link'**
  String get vpnSettingsBrandFooter;

  /// No description provided for @vpnSettingsAccountTitle.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get vpnSettingsAccountTitle;

  /// No description provided for @vpnSettingsSignInToContinue.
  ///
  /// In en, this message translates to:
  /// **'Sign in to continue'**
  String get vpnSettingsSignInToContinue;

  /// No description provided for @vpnSettingsAccountSyncBody.
  ///
  /// In en, this message translates to:
  /// **'Your plan and data usage sync to your account.'**
  String get vpnSettingsAccountSyncBody;

  /// No description provided for @vpnSettingsSignedIn.
  ///
  /// In en, this message translates to:
  /// **'Signed in'**
  String get vpnSettingsSignedIn;

  /// No description provided for @vpnSettingsPlanUnknown.
  ///
  /// In en, this message translates to:
  /// **'Plan: unknown'**
  String get vpnSettingsPlanUnknown;

  /// No description provided for @vpnSettingsPlanLabel.
  ///
  /// In en, this message translates to:
  /// **'Plan: {plan}'**
  String vpnSettingsPlanLabel(Object plan);

  /// No description provided for @vpnSettingsRefresh.
  ///
  /// In en, this message translates to:
  /// **'Refresh'**
  String get vpnSettingsRefresh;

  /// No description provided for @vpnSettingsSignOut.
  ///
  /// In en, this message translates to:
  /// **'Sign out'**
  String get vpnSettingsSignOut;

  /// No description provided for @scheduledChargingOnlyTitle.
  ///
  /// In en, this message translates to:
  /// **'Only when charging'**
  String get scheduledChargingOnlyTitle;

  /// No description provided for @scheduledChargingOnlySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Run the scheduled scan only while the device is plugged in.'**
  String get scheduledChargingOnlySubtitle;

  /// No description provided for @scheduledPreferredTimeTitle.
  ///
  /// In en, this message translates to:
  /// **'Preferred time'**
  String get scheduledPreferredTimeTitle;

  /// No description provided for @scheduledPreferredTimeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'AVarionX will aim to start around this time. Android may delay it to save battery.'**
  String get scheduledPreferredTimeSubtitle;

  /// No description provided for @scheduledPickTime.
  ///
  /// In en, this message translates to:
  /// **'Pick time'**
  String get scheduledPickTime;

  /// No description provided for @cleanerTitle.
  ///
  /// In en, this message translates to:
  /// **'Cleaner Pro'**
  String get cleanerTitle;

  /// No description provided for @cleanerReadyToScan.
  ///
  /// In en, this message translates to:
  /// **'Ready to Scan'**
  String get cleanerReadyToScan;

  /// No description provided for @cleanerScan.
  ///
  /// In en, this message translates to:
  /// **'Scan'**
  String get cleanerScan;

  /// No description provided for @cleanerScanning.
  ///
  /// In en, this message translates to:
  /// **'Scanning…'**
  String get cleanerScanning;

  /// No description provided for @cleanerReady.
  ///
  /// In en, this message translates to:
  /// **'Ready'**
  String get cleanerReady;

  /// No description provided for @cleanerStatusReady.
  ///
  /// In en, this message translates to:
  /// **'Ready'**
  String get cleanerStatusReady;

  /// No description provided for @cleanerStatusStarting.
  ///
  /// In en, this message translates to:
  /// **'Starting…'**
  String get cleanerStatusStarting;

  /// No description provided for @cleanerStatusFilesScanned.
  ///
  /// In en, this message translates to:
  /// **'Files scanned'**
  String get cleanerStatusFilesScanned;

  /// No description provided for @cleanerStatusFindingUnusedApps.
  ///
  /// In en, this message translates to:
  /// **'Finding unused apps…'**
  String get cleanerStatusFindingUnusedApps;

  /// No description provided for @cleanerStatusComplete.
  ///
  /// In en, this message translates to:
  /// **'Complete'**
  String get cleanerStatusComplete;

  /// No description provided for @cleanerStatusScanError.
  ///
  /// In en, this message translates to:
  /// **'Scan error'**
  String get cleanerStatusScanError;

  /// No description provided for @cleanerStatusScanningApps.
  ///
  /// In en, this message translates to:
  /// **'Scanning apps…'**
  String get cleanerStatusScanningApps;

  /// No description provided for @cleanerGrantUsageAccessTitle.
  ///
  /// In en, this message translates to:
  /// **'Grant Usage Access'**
  String get cleanerGrantUsageAccessTitle;

  /// No description provided for @cleanerGrantUsageAccessBody.
  ///
  /// In en, this message translates to:
  /// **'To detect unused apps, this cleaner requires Usage Access permission. You’ll be redirected to system settings to enable it.'**
  String get cleanerGrantUsageAccessBody;

  /// No description provided for @cleanerCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cleanerCancel;

  /// No description provided for @cleanerContinue.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get cleanerContinue;

  /// No description provided for @cleanerDuplicates.
  ///
  /// In en, this message translates to:
  /// **'Duplicates'**
  String get cleanerDuplicates;

  /// No description provided for @cleanerDuplicatesNone.
  ///
  /// In en, this message translates to:
  /// **'No duplicates found'**
  String get cleanerDuplicatesNone;

  /// No description provided for @cleanerDuplicatesSubtitle.
  ///
  /// In en, this message translates to:
  /// **'{count} items • reclaim {size}'**
  String cleanerDuplicatesSubtitle(Object count, Object size);

  /// No description provided for @cleanerOldPhotos.
  ///
  /// In en, this message translates to:
  /// **'Old Photos'**
  String get cleanerOldPhotos;

  /// No description provided for @cleanerOldPhotosNone.
  ///
  /// In en, this message translates to:
  /// **'No photos older than {days} days'**
  String cleanerOldPhotosNone(Object days);

  /// No description provided for @cleanerOldPhotosSubtitle.
  ///
  /// In en, this message translates to:
  /// **'{count} items • {size}'**
  String cleanerOldPhotosSubtitle(Object count, Object size);

  /// No description provided for @cleanerOldVideos.
  ///
  /// In en, this message translates to:
  /// **'Old Videos'**
  String get cleanerOldVideos;

  /// No description provided for @cleanerOldVideosNone.
  ///
  /// In en, this message translates to:
  /// **'No videos older than {days} days'**
  String cleanerOldVideosNone(Object days);

  /// No description provided for @cleanerOldVideosSubtitle.
  ///
  /// In en, this message translates to:
  /// **'{count} items • {size}'**
  String cleanerOldVideosSubtitle(Object count, Object size);

  /// No description provided for @cleanerLargeFiles.
  ///
  /// In en, this message translates to:
  /// **'Large Files'**
  String get cleanerLargeFiles;

  /// No description provided for @cleanerLargeFilesNone.
  ///
  /// In en, this message translates to:
  /// **'No files ≥ {size}'**
  String cleanerLargeFilesNone(Object size);

  /// No description provided for @cleanerLargeFilesSubtitle.
  ///
  /// In en, this message translates to:
  /// **'{count} items • {sizeTotal}'**
  String cleanerLargeFilesSubtitle(Object count, Object sizeTotal);

  /// No description provided for @cleanerUnusedApps.
  ///
  /// In en, this message translates to:
  /// **'Unused Apps'**
  String get cleanerUnusedApps;

  /// No description provided for @cleanerUnusedAppsNone.
  ///
  /// In en, this message translates to:
  /// **'No unused apps (last {days} days)'**
  String cleanerUnusedAppsNone(Object days);

  /// No description provided for @cleanerUnusedAppsCount.
  ///
  /// In en, this message translates to:
  /// **'{count} apps'**
  String cleanerUnusedAppsCount(Object count);

  /// No description provided for @cleanerStageDuplicates.
  ///
  /// In en, this message translates to:
  /// **'Scanning duplicates…'**
  String get cleanerStageDuplicates;

  /// No description provided for @cleanerStageDuplicatesGrouping.
  ///
  /// In en, this message translates to:
  /// **'Grouping duplicates…'**
  String get cleanerStageDuplicatesGrouping;

  /// No description provided for @cleanerStageOldPhotos.
  ///
  /// In en, this message translates to:
  /// **'Scanning old photos…'**
  String get cleanerStageOldPhotos;

  /// No description provided for @cleanerStageOldVideos.
  ///
  /// In en, this message translates to:
  /// **'Scanning old videos…'**
  String get cleanerStageOldVideos;

  /// No description provided for @cleanerStageLargeFiles.
  ///
  /// In en, this message translates to:
  /// **'Scanning large files…'**
  String get cleanerStageLargeFiles;

  /// No description provided for @cleanerStageOldPhotosProgress.
  ///
  /// In en, this message translates to:
  /// **'Old photos: {count} • {size}'**
  String cleanerStageOldPhotosProgress(Object count, Object size);

  /// No description provided for @vpnAccountScreenTitle.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get vpnAccountScreenTitle;

  /// No description provided for @vpnAccountSignInRequiredTitle.
  ///
  /// In en, this message translates to:
  /// **'Sign in required'**
  String get vpnAccountSignInRequiredTitle;

  /// No description provided for @vpnAccountSignInManageUsageBody.
  ///
  /// In en, this message translates to:
  /// **'Sign in to manage your account and usage.'**
  String get vpnAccountSignInManageUsageBody;

  /// No description provided for @vpnAccountNotSignedIn.
  ///
  /// In en, this message translates to:
  /// **'Not signed in'**
  String get vpnAccountNotSignedIn;

  /// No description provided for @vpnAccountFree.
  ///
  /// In en, this message translates to:
  /// **'Free'**
  String get vpnAccountFree;

  /// No description provided for @vpnAccountUnknown.
  ///
  /// In en, this message translates to:
  /// **'Unknown'**
  String get vpnAccountUnknown;

  /// No description provided for @vpnAccountStatusSyncing.
  ///
  /// In en, this message translates to:
  /// **'Syncing'**
  String get vpnAccountStatusSyncing;

  /// No description provided for @vpnAccountStatusActive.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get vpnAccountStatusActive;

  /// No description provided for @vpnAccountStatusConnected.
  ///
  /// In en, this message translates to:
  /// **'Connected'**
  String get vpnAccountStatusConnected;

  /// No description provided for @vpnAccountStatusDisconnected.
  ///
  /// In en, this message translates to:
  /// **'Disconnected'**
  String get vpnAccountStatusDisconnected;

  /// No description provided for @vpnAccountStatusUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Unavailable'**
  String get vpnAccountStatusUnavailable;

  /// No description provided for @vpnAccountStatusConnectedNow.
  ///
  /// In en, this message translates to:
  /// **'Connected now'**
  String get vpnAccountStatusConnectedNow;

  /// No description provided for @vpnAccountStatusRefreshToLoadServer.
  ///
  /// In en, this message translates to:
  /// **'Refresh to load server status'**
  String get vpnAccountStatusRefreshToLoadServer;

  /// No description provided for @vpnAccountUsageTitle.
  ///
  /// In en, this message translates to:
  /// **'Usage'**
  String get vpnAccountUsageTitle;

  /// No description provided for @vpnAccountUsageLoading.
  ///
  /// In en, this message translates to:
  /// **'Loading usage...'**
  String get vpnAccountUsageLoading;

  /// No description provided for @vpnAccountUsageSignInToSync.
  ///
  /// In en, this message translates to:
  /// **'Sign in to sync usage'**
  String get vpnAccountUsageSignInToSync;

  /// No description provided for @vpnAccountUsagePullToRefresh.
  ///
  /// In en, this message translates to:
  /// **'Pull to refresh to sync usage'**
  String get vpnAccountUsagePullToRefresh;

  /// No description provided for @vpnAccountUsageUnlimited.
  ///
  /// In en, this message translates to:
  /// **'Unlimited'**
  String get vpnAccountUsageUnlimited;

  /// No description provided for @vpnAccountUsageUsedThisMonth.
  ///
  /// In en, this message translates to:
  /// **'{used} used this month'**
  String vpnAccountUsageUsedThisMonth(Object used);

  /// No description provided for @vpnAccountUsageUsedThisMonthUnlimited.
  ///
  /// In en, this message translates to:
  /// **'{used} used this month, unlimited'**
  String vpnAccountUsageUsedThisMonthUnlimited(Object used);

  /// No description provided for @vpnAccountUsageUsedOfLimit.
  ///
  /// In en, this message translates to:
  /// **'{used} / {limit}'**
  String vpnAccountUsageUsedOfLimit(Object used, Object limit);

  /// No description provided for @settingsSectionAccount.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get settingsSectionAccount;

  /// No description provided for @settingsAccountTitle.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get settingsAccountTitle;

  /// No description provided for @settingsAccountSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Sign in, plan, subscription, and account usage'**
  String get settingsAccountSubtitle;

  /// No description provided for @exploreSecureVpnTitle.
  ///
  /// In en, this message translates to:
  /// **'Secure VPN'**
  String get exploreSecureVpnTitle;

  /// No description provided for @exploreSecureVpnSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Hide your IP and block unwanted content'**
  String get exploreSecureVpnSubtitle;

  /// No description provided for @vpnAccountServerLoadTitle.
  ///
  /// In en, this message translates to:
  /// **'Selected Server Load'**
  String get vpnAccountServerLoadTitle;

  /// No description provided for @vpnAccountServerConnectedCount.
  ///
  /// In en, this message translates to:
  /// **'{connected}/{cap}'**
  String vpnAccountServerConnectedCount(Object connected, Object cap);

  /// No description provided for @networkDnsOffTitle.
  ///
  /// In en, this message translates to:
  /// **'Switch to DNS filtering?'**
  String get networkDnsOffTitle;

  /// No description provided for @networkDnsOffInfoTitle.
  ///
  /// In en, this message translates to:
  /// **'What is DNS filtering?'**
  String get networkDnsOffInfoTitle;

  /// No description provided for @networkDnsOffInfoBody1.
  ///
  /// In en, this message translates to:
  /// **'DNS filtering is separate from Secure VPN. It can block known malware, ads across apps, trackers, and unwanted categories before they load.'**
  String get networkDnsOffInfoBody1;

  /// No description provided for @networkDnsOffInfoBody2.
  ///
  /// In en, this message translates to:
  /// **'It does not encrypt your traffic or hide your IP.'**
  String get networkDnsOffInfoBody2;

  /// No description provided for @networkDnsOffEnableButton.
  ///
  /// In en, this message translates to:
  /// **'Enable DNS Filtering'**
  String get networkDnsOffEnableButton;

  /// No description provided for @vpnAccountServerConnectedCountWithLabel.
  ///
  /// In en, this message translates to:
  /// **'{connected}/{cap} connected'**
  String vpnAccountServerConnectedCountWithLabel(Object connected, Object cap);

  /// No description provided for @vpnAccountIdentityFallbackTitle.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get vpnAccountIdentityFallbackTitle;

  /// No description provided for @vpnAccountMembershipLabel.
  ///
  /// In en, this message translates to:
  /// **'Membership'**
  String get vpnAccountMembershipLabel;

  /// No description provided for @vpnAccountMembershipFounderVpnPro.
  ///
  /// In en, this message translates to:
  /// **'Founders · VPN Pro'**
  String get vpnAccountMembershipFounderVpnPro;

  /// No description provided for @vpnAccountMembershipFounder.
  ///
  /// In en, this message translates to:
  /// **'Founder'**
  String get vpnAccountMembershipFounder;

  /// No description provided for @vpnAccountMembershipPro.
  ///
  /// In en, this message translates to:
  /// **'Pro'**
  String get vpnAccountMembershipPro;

  /// No description provided for @vpnAccountSectionAccountStatus.
  ///
  /// In en, this message translates to:
  /// **'Account Status'**
  String get vpnAccountSectionAccountStatus;

  /// No description provided for @vpnAccountSectionActions.
  ///
  /// In en, this message translates to:
  /// **'Actions'**
  String get vpnAccountSectionActions;

  /// No description provided for @vpnAccountKvStatus.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get vpnAccountKvStatus;

  /// No description provided for @vpnAccountKvPlan.
  ///
  /// In en, this message translates to:
  /// **'Plan'**
  String get vpnAccountKvPlan;

  /// No description provided for @vpnAccountKvUsage.
  ///
  /// In en, this message translates to:
  /// **'Usage'**
  String get vpnAccountKvUsage;

  /// No description provided for @vpnAccountKvSelectedServer.
  ///
  /// In en, this message translates to:
  /// **'Selected Server'**
  String get vpnAccountKvSelectedServer;

  /// No description provided for @vpnAccountKvConnectionState.
  ///
  /// In en, this message translates to:
  /// **'Connection State'**
  String get vpnAccountKvConnectionState;

  /// No description provided for @vpnAccountActionRefresh.
  ///
  /// In en, this message translates to:
  /// **'Refresh'**
  String get vpnAccountActionRefresh;

  /// No description provided for @vpnAccountActionOpen.
  ///
  /// In en, this message translates to:
  /// **'Open'**
  String get vpnAccountActionOpen;

  /// No description provided for @vpnAccountFounderThanks.
  ///
  /// In en, this message translates to:
  /// **'Thank you for supporting ColourSwift'**
  String get vpnAccountFounderThanks;

  /// No description provided for @vpnAccountFounderNote.
  ///
  /// In en, this message translates to:
  /// **'I\'m just one guy, held by the greatest community.'**
  String get vpnAccountFounderNote;

  /// No description provided for @cleanerStageOldVideosProgress.
  ///
  /// In en, this message translates to:
  /// **'Old videos: {count} • {size}'**
  String cleanerStageOldVideosProgress(Object count, Object size);

  /// No description provided for @cleanerStageLargeFilesProgress.
  ///
  /// In en, this message translates to:
  /// **'Large files: {count} • {size}'**
  String cleanerStageLargeFilesProgress(Object count, Object size);

  /// No description provided for @unusedAppsTitle.
  ///
  /// In en, this message translates to:
  /// **'Unused Apps'**
  String get unusedAppsTitle;

  /// No description provided for @unusedAppsEmpty.
  ///
  /// In en, this message translates to:
  /// **'No unused apps in last {days} days'**
  String unusedAppsEmpty(Object days);

  /// No description provided for @quarantineTitle.
  ///
  /// In en, this message translates to:
  /// **'Removed'**
  String get quarantineTitle;

  /// No description provided for @quarantineSelectAll.
  ///
  /// In en, this message translates to:
  /// **'Select all'**
  String get quarantineSelectAll;

  /// No description provided for @quarantineRefresh.
  ///
  /// In en, this message translates to:
  /// **'Refresh'**
  String get quarantineRefresh;

  /// No description provided for @quarantineEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No removed files'**
  String get quarantineEmptyTitle;

  /// No description provided for @quarantineEmptyBody.
  ///
  /// In en, this message translates to:
  /// **'Anything you remove will show up here.'**
  String get quarantineEmptyBody;

  /// No description provided for @quarantineRestore.
  ///
  /// In en, this message translates to:
  /// **'Restore'**
  String get quarantineRestore;

  /// No description provided for @quarantineDelete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get quarantineDelete;

  /// No description provided for @quarantineSnackRestored.
  ///
  /// In en, this message translates to:
  /// **'Restored'**
  String get quarantineSnackRestored;

  /// No description provided for @quarantineSnackDeleted.
  ///
  /// In en, this message translates to:
  /// **'Deleted'**
  String get quarantineSnackDeleted;

  /// No description provided for @quarantineDeleteDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete selected files?'**
  String get quarantineDeleteDialogTitle;

  /// No description provided for @quarantineDeleteDialogBody.
  ///
  /// In en, this message translates to:
  /// **'This will permanently delete {count} item{plural}.'**
  String quarantineDeleteDialogBody(Object count, String plural);

  /// No description provided for @howThisAppWorksHowAvarionXWorks.
  ///
  /// In en, this message translates to:
  /// **'How AvarionX Works'**
  String get howThisAppWorksHowAvarionXWorks;

  /// No description provided for @howThisAppWorksAvarionxIsAMobileSecurityAppThat.
  ///
  /// In en, this message translates to:
  /// **'AvarionX is a mobile security app that combines on device antivirus scanning, network protection, and optional VPN features. '**
  String get howThisAppWorksAvarionxIsAMobileSecurityAppThat;

  /// No description provided for @howThisAppWorksTheAntivirusEngineIsPoweredByVX.
  ///
  /// In en, this message translates to:
  /// **'The antivirus engine is powered by VX-Titanium.'**
  String get howThisAppWorksTheAntivirusEngineIsPoweredByVX;

  /// No description provided for @howThisAppWorksIfYouUseNetworkProtectionOrVPN.
  ///
  /// In en, this message translates to:
  /// **'If you use network protection or VPN features, the app connects to ColourSwift services to apply your settings, manage your account access, and route protected traffic.'**
  String get howThisAppWorksIfYouUseNetworkProtectionOrVPN;

  /// No description provided for @howThisAppWorksKeyFeatures.
  ///
  /// In en, this message translates to:
  /// **'Key Features'**
  String get howThisAppWorksKeyFeatures;

  /// No description provided for @howThisAppWorksRealTimeProtectionForDownloadedThreats.
  ///
  /// In en, this message translates to:
  /// **'• Real-time protection for downloaded threats'**
  String get howThisAppWorksRealTimeProtectionForDownloadedThreats;

  /// No description provided for @howThisAppWorksNetworkProtectionWithDNSFiltering.
  ///
  /// In en, this message translates to:
  /// **'• Network protection with DNS filtering'**
  String get howThisAppWorksNetworkProtectionWithDNSFiltering;

  /// No description provided for @howThisAppWorksOptionalSecureVPNMode.
  ///
  /// In en, this message translates to:
  /// **'• Optional Secure VPN mode'**
  String get howThisAppWorksOptionalSecureVPNMode;

  /// No description provided for @howThisAppWorksBuiltInToolsSuchAsLinkChecker.
  ///
  /// In en, this message translates to:
  /// **'• Built in tools such as Link Checker'**
  String get howThisAppWorksBuiltInToolsSuchAsLinkChecker;

  /// No description provided for @howThisAppWorksNotes.
  ///
  /// In en, this message translates to:
  /// **'Notes'**
  String get howThisAppWorksNotes;

  /// No description provided for @howThisAppWorksSomeFeaturesMayRequireSignInAn.
  ///
  /// In en, this message translates to:
  /// **'Some features may require sign in, an active plan, or device permissions to work properly.'**
  String get howThisAppWorksSomeFeaturesMayRequireSignInAn;

  /// No description provided for @apkAnalyserCopyCurrentReport.
  ///
  /// In en, this message translates to:
  /// **'Copy Current Report'**
  String get apkAnalyserCopyCurrentReport;

  /// No description provided for @apkAnalyserReportCopiedToClipboard.
  ///
  /// In en, this message translates to:
  /// **'Report copied to clipboard'**
  String get apkAnalyserReportCopiedToClipboard;

  /// No description provided for @apkAnalyserExportCurrentAsPDF.
  ///
  /// In en, this message translates to:
  /// **'Export Current as PDF'**
  String get apkAnalyserExportCurrentAsPDF;

  /// No description provided for @apkAnalyserFailedToExportPDF.
  ///
  /// In en, this message translates to:
  /// **'Failed to export PDF'**
  String get apkAnalyserFailedToExportPDF;

  /// No description provided for @apkAnalyserExportCurrentAsCSV.
  ///
  /// In en, this message translates to:
  /// **'Export Current as CSV'**
  String get apkAnalyserExportCurrentAsCSV;

  /// No description provided for @apkAnalyserFailedToExportCSV.
  ///
  /// In en, this message translates to:
  /// **'Failed to export CSV'**
  String get apkAnalyserFailedToExportCSV;

  /// No description provided for @apkAnalyserViewSavedReports.
  ///
  /// In en, this message translates to:
  /// **'View Saved Reports'**
  String get apkAnalyserViewSavedReports;

  /// No description provided for @apkAnalyserClearHistory.
  ///
  /// In en, this message translates to:
  /// **'Clear History'**
  String get apkAnalyserClearHistory;

  /// No description provided for @apkAnalyserReportHistoryCleared.
  ///
  /// In en, this message translates to:
  /// **'Report history cleared'**
  String get apkAnalyserReportHistoryCleared;

  /// No description provided for @apkAnalyserSavedReports.
  ///
  /// In en, this message translates to:
  /// **'Saved Reports'**
  String get apkAnalyserSavedReports;

  /// No description provided for @apkAnalyserNoSavedReportsFound.
  ///
  /// In en, this message translates to:
  /// **'No saved reports found.'**
  String get apkAnalyserNoSavedReportsFound;

  /// No description provided for @apkAnalyserChooseTarget.
  ///
  /// In en, this message translates to:
  /// **'Choose Target'**
  String get apkAnalyserChooseTarget;

  /// No description provided for @apkAnalyserSelectASourceToAnalyseWithVTTI.
  ///
  /// In en, this message translates to:
  /// **'Select a source to analyse with VTTI Cloud.'**
  String get apkAnalyserSelectASourceToAnalyseWithVTTI;

  /// No description provided for @apkAnalyserApkFile.
  ///
  /// In en, this message translates to:
  /// **'APK File'**
  String get apkAnalyserApkFile;

  /// No description provided for @apkAnalyserPickAnApkFromStorage.
  ///
  /// In en, this message translates to:
  /// **'Pick an .apk from storage'**
  String get apkAnalyserPickAnApkFromStorage;

  /// No description provided for @apkAnalyserInstalledApp.
  ///
  /// In en, this message translates to:
  /// **'Installed App'**
  String get apkAnalyserInstalledApp;

  /// No description provided for @apkAnalyserChooseFromAppsOnThisDevice.
  ///
  /// In en, this message translates to:
  /// **'Choose from apps on this device'**
  String get apkAnalyserChooseFromAppsOnThisDevice;

  /// No description provided for @apkAnalyserAnalysingIn.
  ///
  /// In en, this message translates to:
  /// **'Analysing in {countdown}...'**
  String apkAnalyserAnalysingIn(Object countdown);

  /// No description provided for @apkAnalyserStartingAnalysis.
  ///
  /// In en, this message translates to:
  /// **'Starting analysis...'**
  String get apkAnalyserStartingAnalysis;

  /// No description provided for @apkAnalyserApkFileOrInstalledApp.
  ///
  /// In en, this message translates to:
  /// **'APK file or installed app'**
  String get apkAnalyserApkFileOrInstalledApp;

  /// No description provided for @apkAnalyserDeepAnalysisMode.
  ///
  /// In en, this message translates to:
  /// **'Deep analysis mode'**
  String get apkAnalyserDeepAnalysisMode;

  /// No description provided for @apkAnalyserAMoreComplexAnalysisUsingGlobalData.
  ///
  /// In en, this message translates to:
  /// **'A more complex analysis using global data sources'**
  String get apkAnalyserAMoreComplexAnalysisUsingGlobalData;

  /// No description provided for @apkAnalyserRequiresProToUnlockDeeperAnalysis.
  ///
  /// In en, this message translates to:
  /// **'Requires Pro to unlock deeper analysis'**
  String get apkAnalyserRequiresProToUnlockDeeperAnalysis;

  /// No description provided for @apkAnalyserApkAnalyser.
  ///
  /// In en, this message translates to:
  /// **'APK Analyser'**
  String get apkAnalyserApkAnalyser;

  /// No description provided for @apkAnalyserPleaseSignInViaSettingsToEnable.
  ///
  /// In en, this message translates to:
  /// **'Please sign in via Settings to enable Cloud Analysis.'**
  String get apkAnalyserPleaseSignInViaSettingsToEnable;

  /// No description provided for @apkAnalyserAdvancedOPTIONS.
  ///
  /// In en, this message translates to:
  /// **'ADVANCED OPTIONS'**
  String get apkAnalyserAdvancedOPTIONS;

  /// No description provided for @apkAnalyserDailyLimit.
  ///
  /// In en, this message translates to:
  /// **'Daily Limit: {remaining} / {limit}'**
  String apkAnalyserDailyLimit(Object remaining, Object limit);

  /// No description provided for @apkAnalyserDailyLimitDataUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Daily Limit Data Unavailable'**
  String get apkAnalyserDailyLimitDataUnavailable;

  /// No description provided for @apkAnalyserPoweredByVTTICloud.
  ///
  /// In en, this message translates to:
  /// **'Powered by VTTI Cloud'**
  String get apkAnalyserPoweredByVTTICloud;

  /// No description provided for @apkAnalyserSearchApps.
  ///
  /// In en, this message translates to:
  /// **'Search apps...'**
  String get apkAnalyserSearchApps;

  /// No description provided for @apkAnalyserFailedToLoadApps.
  ///
  /// In en, this message translates to:
  /// **'Failed to load apps.'**
  String get apkAnalyserFailedToLoadApps;

  /// No description provided for @apkAnalyserNoAppsFound.
  ///
  /// In en, this message translates to:
  /// **'No apps found.'**
  String get apkAnalyserNoAppsFound;

  /// No description provided for @apkReportSummary.
  ///
  /// In en, this message translates to:
  /// **'Summary'**
  String get apkReportSummary;

  /// No description provided for @apkReportPermissions.
  ///
  /// In en, this message translates to:
  /// **'Permissions'**
  String get apkReportPermissions;

  /// No description provided for @apkReportExtraFlags.
  ///
  /// In en, this message translates to:
  /// **'Extra Flags'**
  String get apkReportExtraFlags;

  /// No description provided for @apkReportRiskSignals.
  ///
  /// In en, this message translates to:
  /// **'Risk Signals'**
  String get apkReportRiskSignals;

  /// No description provided for @apkReportSources.
  ///
  /// In en, this message translates to:
  /// **'Sources'**
  String get apkReportSources;

  /// No description provided for @apkReportMetadata.
  ///
  /// In en, this message translates to:
  /// **'Metadata'**
  String get apkReportMetadata;

  /// No description provided for @apkReportCopyReport.
  ///
  /// In en, this message translates to:
  /// **'Copy Report'**
  String get apkReportCopyReport;

  /// No description provided for @apkReportReportCopiedToClipboard.
  ///
  /// In en, this message translates to:
  /// **'Report copied to clipboard'**
  String get apkReportReportCopiedToClipboard;

  /// No description provided for @apkReportExportAsPDF.
  ///
  /// In en, this message translates to:
  /// **'Export as PDF'**
  String get apkReportExportAsPDF;

  /// No description provided for @apkReportFailedToExportPDF.
  ///
  /// In en, this message translates to:
  /// **'Failed to export PDF'**
  String get apkReportFailedToExportPDF;

  /// No description provided for @apkReportExportAsCSV.
  ///
  /// In en, this message translates to:
  /// **'Export as CSV'**
  String get apkReportExportAsCSV;

  /// No description provided for @apkReportFailedToExportCSV.
  ///
  /// In en, this message translates to:
  /// **'Failed to export CSV'**
  String get apkReportFailedToExportCSV;

  /// No description provided for @apkReportAnalysisReport.
  ///
  /// In en, this message translates to:
  /// **'Analysis Report'**
  String get apkReportAnalysisReport;

  /// No description provided for @apkReportMalwareRisk.
  ///
  /// In en, this message translates to:
  /// **'Malware Risk'**
  String get apkReportMalwareRisk;

  /// No description provided for @apkReportNoSummaryGenerated.
  ///
  /// In en, this message translates to:
  /// **'No summary generated.'**
  String get apkReportNoSummaryGenerated;

  /// No description provided for @apkReportNoRequestedPermissionsExtracted.
  ///
  /// In en, this message translates to:
  /// **'No requested permissions extracted.'**
  String get apkReportNoRequestedPermissionsExtracted;

  /// No description provided for @apkReportContributing.
  ///
  /// In en, this message translates to:
  /// **'Contributing'**
  String get apkReportContributing;

  /// No description provided for @apkReportDampening.
  ///
  /// In en, this message translates to:
  /// **'Dampening'**
  String get apkReportDampening;

  /// No description provided for @bootOptimisingYourProtection.
  ///
  /// In en, this message translates to:
  /// **'Optimising your protection'**
  String get bootOptimisingYourProtection;

  /// No description provided for @exclusionsFolders.
  ///
  /// In en, this message translates to:
  /// **'Folders'**
  String get exclusionsFolders;

  /// No description provided for @exclusionsNone.
  ///
  /// In en, this message translates to:
  /// **'None'**
  String get exclusionsNone;

  /// No description provided for @exclusionsFiles.
  ///
  /// In en, this message translates to:
  /// **'Files'**
  String get exclusionsFiles;

  /// No description provided for @exploreApkAnalyser.
  ///
  /// In en, this message translates to:
  /// **'APK Analyser'**
  String get exploreApkAnalyser;

  /// No description provided for @exploreCreateADetailedAnalysisOnAnyAPK.
  ///
  /// In en, this message translates to:
  /// **'Create a detailed analysis on any APK'**
  String get exploreCreateADetailedAnalysisOnAnyAPK;

  /// No description provided for @featuresComingSoon.
  ///
  /// In en, this message translates to:
  /// **'Coming Soon'**
  String get featuresComingSoon;

  /// No description provided for @featuresWantToLearnMore.
  ///
  /// In en, this message translates to:
  /// **'Want to learn more?'**
  String get featuresWantToLearnMore;

  /// No description provided for @homeDrawerApkAnalyser.
  ///
  /// In en, this message translates to:
  /// **'APK Analyser'**
  String get homeDrawerApkAnalyser;

  /// No description provided for @homeDrawerAdvanced.
  ///
  /// In en, this message translates to:
  /// **'Advanced'**
  String get homeDrawerAdvanced;

  /// No description provided for @homeDrawerQuarantine.
  ///
  /// In en, this message translates to:
  /// **'Quarantine'**
  String get homeDrawerQuarantine;

  /// No description provided for @homeDrawerUpgradeToPro.
  ///
  /// In en, this message translates to:
  /// **'Upgrade to Pro'**
  String get homeDrawerUpgradeToPro;

  /// No description provided for @homeDrawerAvarionxVPN.
  ///
  /// In en, this message translates to:
  /// **'AvarionX VPN'**
  String get homeDrawerAvarionxVPN;

  /// No description provided for @homeDrawerProtectYourInternetWithOurUnlimitedVPN.
  ///
  /// In en, this message translates to:
  /// **'Protect your internet with our unlimited VPN'**
  String get homeDrawerProtectYourInternetWithOurUnlimitedVPN;

  /// No description provided for @deviceSecurityDeviceSecurity.
  ///
  /// In en, this message translates to:
  /// **'Device Security'**
  String get deviceSecurityDeviceSecurity;

  /// No description provided for @deviceSecurityDeviceHealthStatus.
  ///
  /// In en, this message translates to:
  /// **'Device health status'**
  String get deviceSecurityDeviceHealthStatus;

  /// No description provided for @deviceSecurityDeviceSecurityRecommendations.
  ///
  /// In en, this message translates to:
  /// **'Device security recommendations'**
  String get deviceSecurityDeviceSecurityRecommendations;

  /// No description provided for @deviceSecurityStopIgnoring.
  ///
  /// In en, this message translates to:
  /// **'Stop ignoring'**
  String get deviceSecurityStopIgnoring;

  /// No description provided for @deviceSecurityIgnoreCheck.
  ///
  /// In en, this message translates to:
  /// **'Ignore check'**
  String get deviceSecurityIgnoreCheck;

  /// No description provided for @deviceSecurityNoScreenLock.
  ///
  /// In en, this message translates to:
  /// **'No Screen Lock'**
  String get deviceSecurityNoScreenLock;

  /// No description provided for @deviceSecurityAMissingSecureLockMakesLocalAccess.
  ///
  /// In en, this message translates to:
  /// **'A missing secure lock makes local access easier.'**
  String get deviceSecurityAMissingSecureLockMakesLocalAccess;

  /// No description provided for @deviceSecurityRootShizukuActive.
  ///
  /// In en, this message translates to:
  /// **'Root/Shizuku Active'**
  String get deviceSecurityRootShizukuActive;

  /// No description provided for @deviceSecurityRootOrShizukuCanGrantPowerfulDevice.
  ///
  /// In en, this message translates to:
  /// **'Root or Shizuku can grant powerful device control.'**
  String get deviceSecurityRootOrShizukuCanGrantPowerfulDevice;

  /// No description provided for @deviceSecurityDisabledAppVerification.
  ///
  /// In en, this message translates to:
  /// **'Disabled App Verification'**
  String get deviceSecurityDisabledAppVerification;

  /// No description provided for @deviceSecurityAppVerificationHelpsDetectHarmfulInstalls.
  ///
  /// In en, this message translates to:
  /// **'App verification helps detect harmful installs.'**
  String get deviceSecurityAppVerificationHelpsDetectHarmfulInstalls;

  /// No description provided for @deviceSecurityOldAndroidSecurityPatch.
  ///
  /// In en, this message translates to:
  /// **'Old Android Security Patch'**
  String get deviceSecurityOldAndroidSecurityPatch;

  /// No description provided for @deviceSecurityOlderPatchLevelsMayLeaveKnownIssues.
  ///
  /// In en, this message translates to:
  /// **'Older patch levels may leave known issues unpatched.'**
  String get deviceSecurityOlderPatchLevelsMayLeaveKnownIssues;

  /// No description provided for @deviceSecurityDeveloperModeOn.
  ///
  /// In en, this message translates to:
  /// **'Developer Mode On'**
  String get deviceSecurityDeveloperModeOn;

  /// No description provided for @deviceSecurityDeveloperOptionsExposeAdvancedDeviceControls.
  ///
  /// In en, this message translates to:
  /// **'Developer options expose advanced device controls.'**
  String get deviceSecurityDeveloperOptionsExposeAdvancedDeviceControls;

  /// No description provided for @deviceSecurityUsbDebuggingOn.
  ///
  /// In en, this message translates to:
  /// **'USB Debugging On'**
  String get deviceSecurityUsbDebuggingOn;

  /// No description provided for @deviceSecurityUsbDebuggingAllowsADBControlFromTrusted.
  ///
  /// In en, this message translates to:
  /// **'USB debugging allows ADB control from trusted computers.'**
  String get deviceSecurityUsbDebuggingAllowsADBControlFromTrusted;

  /// No description provided for @deviceSecurityUnknownSourcesAllowed.
  ///
  /// In en, this message translates to:
  /// **'Unknown Sources Allowed'**
  String get deviceSecurityUnknownSourcesAllowed;

  /// No description provided for @deviceSecuritySideloadingCanBypassNormalAppStoreChecks.
  ///
  /// In en, this message translates to:
  /// **'Sideloading can bypass normal app store checks.'**
  String get deviceSecuritySideloadingCanBypassNormalAppStoreChecks;

  /// No description provided for @deviceSecurityAccessibilityAbuseRisk.
  ///
  /// In en, this message translates to:
  /// **'Accessibility Abuse Risk'**
  String get deviceSecurityAccessibilityAbuseRisk;

  /// No description provided for @deviceSecurityAccessibilityServicesCanReadAndControlScreen.
  ///
  /// In en, this message translates to:
  /// **'Accessibility services can read and control screen actions.'**
  String get deviceSecurityAccessibilityServicesCanReadAndControlScreen;

  /// No description provided for @homeHelpImproveDetectionsForEverybody.
  ///
  /// In en, this message translates to:
  /// **'Help improve detections for everybody'**
  String get homeHelpImproveDetectionsForEverybody;

  /// No description provided for @homeApkSAndroidAppsFoundToBe.
  ///
  /// In en, this message translates to:
  /// **'APK\'s (android apps) found to be malicious '**
  String get homeApkSAndroidAppsFoundToBe;

  /// No description provided for @homeCanBeUploadedTo.
  ///
  /// In en, this message translates to:
  /// **'can be uploaded to '**
  String get homeCanBeUploadedTo;

  /// No description provided for @homeAndSharedWithTheCommunityThisIs.
  ///
  /// In en, this message translates to:
  /// **' and shared with the community. This is '**
  String get homeAndSharedWithTheCommunityThisIs;

  /// No description provided for @homeStrictlyLimitedToAPKFilesNOTYour.
  ///
  /// In en, this message translates to:
  /// **'strictly limited to APK files, NOT your personal '**
  String get homeStrictlyLimitedToAPKFilesNOTYour;

  /// No description provided for @homeDocuments.
  ///
  /// In en, this message translates to:
  /// **'documents.\n\n'**
  String get homeDocuments;

  /// No description provided for @homeThisWillImproveDetectionsForEveryoneThat.
  ///
  /// In en, this message translates to:
  /// **'This will improve detections for everyone that '**
  String get homeThisWillImproveDetectionsForEveryoneThat;

  /// No description provided for @homeUsesAvarionXNoPressureThough.
  ///
  /// In en, this message translates to:
  /// **'uses AvarionX. No pressure though!\n\n'**
  String get homeUsesAvarionXNoPressureThough;

  /// No description provided for @homeThanks.
  ///
  /// In en, this message translates to:
  /// **'Thanks,\n'**
  String get homeThanks;

  /// No description provided for @homeRyanfromcolourswift.
  ///
  /// In en, this message translates to:
  /// **'RyanFromColourswift'**
  String get homeRyanfromcolourswift;

  /// No description provided for @homeSure.
  ///
  /// In en, this message translates to:
  /// **'Sure!'**
  String get homeSure;

  /// No description provided for @homeNoThanks.
  ///
  /// In en, this message translates to:
  /// **'No Thanks!'**
  String get homeNoThanks;

  /// No description provided for @homePsstCustomiseItHere.
  ///
  /// In en, this message translates to:
  /// **'Psst...customise it here'**
  String get homePsstCustomiseItHere;

  /// No description provided for @homeScanNow.
  ///
  /// In en, this message translates to:
  /// **'Scan Now'**
  String get homeScanNow;

  /// No description provided for @homeManuallyCheckYourDeviceForMalware.
  ///
  /// In en, this message translates to:
  /// **'Manually check your device for malware'**
  String get homeManuallyCheckYourDeviceForMalware;

  /// No description provided for @homeDeviceSecurity.
  ///
  /// In en, this message translates to:
  /// **'Device Security'**
  String get homeDeviceSecurity;

  /// No description provided for @homeScanModes.
  ///
  /// In en, this message translates to:
  /// **'Scan Modes'**
  String get homeScanModes;

  /// No description provided for @homeCloudAssistedChecksEnabled.
  ///
  /// In en, this message translates to:
  /// **'Cloud-assisted checks enabled'**
  String get homeCloudAssistedChecksEnabled;

  /// No description provided for @homeLocalScanEngineOnly.
  ///
  /// In en, this message translates to:
  /// **'Local scan engine only'**
  String get homeLocalScanEngineOnly;

  /// No description provided for @homeProtectedByVXTITANIUM.
  ///
  /// In en, this message translates to:
  /// **'Protected by VX-TITANIUM'**
  String get homeProtectedByVXTITANIUM;

  /// No description provided for @homeSecurityOverview.
  ///
  /// In en, this message translates to:
  /// **'Security Overview'**
  String get homeSecurityOverview;

  /// No description provided for @homeFilesChecked.
  ///
  /// In en, this message translates to:
  /// **'Files checked'**
  String get homeFilesChecked;

  /// No description provided for @homeThreats.
  ///
  /// In en, this message translates to:
  /// **'Threats'**
  String get homeThreats;

  /// No description provided for @securityReportAvarionxSecurityReport.
  ///
  /// In en, this message translates to:
  /// **'Avarionx Security Report'**
  String get securityReportAvarionxSecurityReport;

  /// No description provided for @securityReportSecurityReport.
  ///
  /// In en, this message translates to:
  /// **'Security Report'**
  String get securityReportSecurityReport;

  /// No description provided for @securityReportManualScans.
  ///
  /// In en, this message translates to:
  /// **'Manual scans'**
  String get securityReportManualScans;

  /// No description provided for @securityReportRealtimeChecks.
  ///
  /// In en, this message translates to:
  /// **'Realtime checks'**
  String get securityReportRealtimeChecks;

  /// No description provided for @securityReportTotalFilesScanned.
  ///
  /// In en, this message translates to:
  /// **'Total files scanned'**
  String get securityReportTotalFilesScanned;

  /// No description provided for @securityReportThreatsFound.
  ///
  /// In en, this message translates to:
  /// **'Threats found'**
  String get securityReportThreatsFound;

  /// No description provided for @securityReportGenerateReport.
  ///
  /// In en, this message translates to:
  /// **'Generate report'**
  String get securityReportGenerateReport;

  /// No description provided for @securityReportLiveReport.
  ///
  /// In en, this message translates to:
  /// **'Live report'**
  String get securityReportLiveReport;

  /// No description provided for @securityReportThisBoxUpdatesAsScanServicesWrite.
  ///
  /// In en, this message translates to:
  /// **'This box updates as scan services write report data.'**
  String get securityReportThisBoxUpdatesAsScanServicesWrite;

  /// No description provided for @securityReportExportPDF.
  ///
  /// In en, this message translates to:
  /// **'Export PDF'**
  String get securityReportExportPDF;

  /// No description provided for @securityReportExportCSV.
  ///
  /// In en, this message translates to:
  /// **'Export CSV'**
  String get securityReportExportCSV;

  /// No description provided for @homeLegacyProActivated.
  ///
  /// In en, this message translates to:
  /// **'Pro activated'**
  String get homeLegacyProActivated;

  /// No description provided for @homeLegacyProDeactivated.
  ///
  /// In en, this message translates to:
  /// **'Pro deactivated'**
  String get homeLegacyProDeactivated;

  /// No description provided for @linkCheckPoweredByVTTICloud.
  ///
  /// In en, this message translates to:
  /// **'Powered by VTTI Cloud'**
  String get linkCheckPoweredByVTTICloud;

  /// No description provided for @safeViewSafeView.
  ///
  /// In en, this message translates to:
  /// **'Safe View'**
  String get safeViewSafeView;

  /// No description provided for @passwordSettingsChangingThisAltersAllPasswords.
  ///
  /// In en, this message translates to:
  /// **'Changing this alters all passwords.\n'**
  String get passwordSettingsChangingThisAltersAllPasswords;

  /// No description provided for @passwordSettingsUsingTheSameMetaPassRestoresThem.
  ///
  /// In en, this message translates to:
  /// **'Using the same MetaPass restores them.'**
  String get passwordSettingsUsingTheSameMetaPassRestoresThem;

  /// No description provided for @passwordSettingsPasswordsAreNeverStored.
  ///
  /// In en, this message translates to:
  /// **'Passwords are never stored.\n\n'**
  String get passwordSettingsPasswordsAreNeverStored;

  /// No description provided for @passwordSettingsTheRestoreCodeContainsOnlyStructureData.
  ///
  /// In en, this message translates to:
  /// **'The restore code contains only structure data. '**
  String get passwordSettingsTheRestoreCodeContainsOnlyStructureData;

  /// No description provided for @passwordSettingsCombinedWithYourMetaPassItRebuildsYour.
  ///
  /// In en, this message translates to:
  /// **'Combined with your MetaPass, it rebuilds your vault.'**
  String get passwordSettingsCombinedWithYourMetaPassItRebuildsYour;

  /// No description provided for @passwordManagerContinue.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get passwordManagerContinue;

  /// No description provided for @passwordManagerFailedToLoadApps.
  ///
  /// In en, this message translates to:
  /// **'Failed to load apps: {e}'**
  String passwordManagerFailedToLoadApps(Object e);

  /// No description provided for @passwordManagerFailedToGeneratePassword.
  ///
  /// In en, this message translates to:
  /// **'Failed to generate password: {e}'**
  String passwordManagerFailedToGeneratePassword(Object e);

  /// No description provided for @passwordManagerPasswordsAreNeverStored.
  ///
  /// In en, this message translates to:
  /// **'Passwords are never stored.\n\n'**
  String get passwordManagerPasswordsAreNeverStored;

  /// No description provided for @passwordManagerEachEntryDerivesAPasswordFrom.
  ///
  /// In en, this message translates to:
  /// **'Each entry derives a password from:\n'**
  String get passwordManagerEachEntryDerivesAPasswordFrom;

  /// No description provided for @passwordManagerYourMetaPassword.
  ///
  /// In en, this message translates to:
  /// **'• Your meta password\n'**
  String get passwordManagerYourMetaPassword;

  /// No description provided for @passwordManagerTheLabelName.
  ///
  /// In en, this message translates to:
  /// **'• The label(name)\n'**
  String get passwordManagerTheLabelName;

  /// No description provided for @passwordManagerTheVersionAndLength.
  ///
  /// In en, this message translates to:
  /// **'• The version and length\n\n'**
  String get passwordManagerTheVersionAndLength;

  /// No description provided for @passwordManagerReinstallingTheAppWithTheSameMeta.
  ///
  /// In en, this message translates to:
  /// **'Reinstalling the app with the same meta password and labels regenerates the same passwords.'**
  String get passwordManagerReinstallingTheAppWithTheSameMeta;

  /// No description provided for @permissionsIntroSetupIsNowCompleteTimeToSecure.
  ///
  /// In en, this message translates to:
  /// **'Setup is now complete! Time to secure your data.'**
  String get permissionsIntroSetupIsNowCompleteTimeToSecure;

  /// No description provided for @proScreenThankYou.
  ///
  /// In en, this message translates to:
  /// **'Thank you'**
  String get proScreenThankYou;

  /// No description provided for @proScreenYourSubscriptionIsConfirmed.
  ///
  /// In en, this message translates to:
  /// **'Your subscription is confirmed.'**
  String get proScreenYourSubscriptionIsConfirmed;

  /// No description provided for @proScreenCurrent.
  ///
  /// In en, this message translates to:
  /// **'Current'**
  String get proScreenCurrent;

  /// No description provided for @proScreenAdvancedStealthMode.
  ///
  /// In en, this message translates to:
  /// **'Advanced Stealth+ Mode'**
  String get proScreenAdvancedStealthMode;

  /// No description provided for @proScreenUnlockStealthTransportModesForRestrictiveNetworks.
  ///
  /// In en, this message translates to:
  /// **'Unlock stealth transport modes for restrictive networks.'**
  String get proScreenUnlockStealthTransportModesForRestrictiveNetworks;

  /// No description provided for @proScreenGlobalServerAccess.
  ///
  /// In en, this message translates to:
  /// **'Global Server Access'**
  String get proScreenGlobalServerAccess;

  /// No description provided for @proScreenAccessEveryVPNServerLocationIncludingPremium.
  ///
  /// In en, this message translates to:
  /// **'Access every VPN server location, including premium high-speed regions.'**
  String get proScreenAccessEveryVPNServerLocationIncludingPremium;

  /// No description provided for @proScreenBilledMonthly.
  ///
  /// In en, this message translates to:
  /// **'Billed monthly'**
  String get proScreenBilledMonthly;

  /// No description provided for @proScreenMo.
  ///
  /// In en, this message translates to:
  /// **'{monthlyInfo}/mo'**
  String proScreenMo(Object monthlyInfo);

  /// No description provided for @proScreenMo2.
  ///
  /// In en, this message translates to:
  /// **'{currencyCode}/mo'**
  String proScreenMo2(Object currencyCode);

  /// No description provided for @proScreenCurrentPlan.
  ///
  /// In en, this message translates to:
  /// **'Current plan'**
  String get proScreenCurrentPlan;

  /// No description provided for @quarantineScreenQuarantineDataCorruptedResetting.
  ///
  /// In en, this message translates to:
  /// **'Quarantine data corrupted. Resetting.'**
  String get quarantineScreenQuarantineDataCorruptedResetting;

  /// No description provided for @quarantineScreenUninstallApp.
  ///
  /// In en, this message translates to:
  /// **'Uninstall App'**
  String get quarantineScreenUninstallApp;

  /// No description provided for @quarantineScreenUninstall.
  ///
  /// In en, this message translates to:
  /// **'Uninstall {appName}?'**
  String quarantineScreenUninstall(Object appName);

  /// No description provided for @quarantineScreenUninstall2.
  ///
  /// In en, this message translates to:
  /// **'Uninstall'**
  String get quarantineScreenUninstall2;

  /// No description provided for @quarantineScreenFailedToLaunchUninstall.
  ///
  /// In en, this message translates to:
  /// **'Failed to launch uninstall'**
  String get quarantineScreenFailedToLaunchUninstall;

  /// No description provided for @quarantineScreenFiles.
  ///
  /// In en, this message translates to:
  /// **'Files'**
  String get quarantineScreenFiles;

  /// No description provided for @cleanerAppManagerShizukuNotAvailable.
  ///
  /// In en, this message translates to:
  /// **'Shizuku not available'**
  String get cleanerAppManagerShizukuNotAvailable;

  /// No description provided for @cleanerAppManagerWithoutShizukuEachAppRequiresASeparate.
  ///
  /// In en, this message translates to:
  /// **'Without Shizuku each app requires a separate system confirmation. Continue?'**
  String get cleanerAppManagerWithoutShizukuEachAppRequiresASeparate;

  /// No description provided for @cleanerAppManagerAppsUninstalled.
  ///
  /// In en, this message translates to:
  /// **'{successCount} apps uninstalled'**
  String cleanerAppManagerAppsUninstalled(Object successCount);

  /// No description provided for @cleanerAppManagerUninstalledFailed.
  ///
  /// In en, this message translates to:
  /// **'{successCount} uninstalled, {failedCount} failed'**
  String cleanerAppManagerUninstalledFailed(
      Object successCount, Object failedCount);

  /// No description provided for @cleanerAppManagerStopped.
  ///
  /// In en, this message translates to:
  /// **'{appName} stopped'**
  String cleanerAppManagerStopped(Object appName);

  /// No description provided for @cleanerAppManagerForceStopFailed.
  ///
  /// In en, this message translates to:
  /// **'Force stop failed'**
  String get cleanerAppManagerForceStopFailed;

  /// No description provided for @cleanerAppManagerClearAppData.
  ///
  /// In en, this message translates to:
  /// **'Clear app data'**
  String get cleanerAppManagerClearAppData;

  /// No description provided for @cleanerAppManagerResetThisClearsItsAccountsSettingsFiles.
  ///
  /// In en, this message translates to:
  /// **'Reset {appName}? This clears its accounts, settings, files and cache.'**
  String cleanerAppManagerResetThisClearsItsAccountsSettingsFiles(
      Object appName);

  /// No description provided for @cleanerAppManagerClearData.
  ///
  /// In en, this message translates to:
  /// **'Clear data'**
  String get cleanerAppManagerClearData;

  /// No description provided for @cleanerAppManagerReset.
  ///
  /// In en, this message translates to:
  /// **'{appName} reset'**
  String cleanerAppManagerReset(Object appName);

  /// No description provided for @cleanerAppManagerClearDataFailed.
  ///
  /// In en, this message translates to:
  /// **'Clear data failed'**
  String get cleanerAppManagerClearDataFailed;

  /// No description provided for @cleanerAppManagerOpenApp.
  ///
  /// In en, this message translates to:
  /// **'Open app'**
  String get cleanerAppManagerOpenApp;

  /// No description provided for @cleanerAppManagerForceStop.
  ///
  /// In en, this message translates to:
  /// **'Force stop'**
  String get cleanerAppManagerForceStop;

  /// No description provided for @cleanerAppManagerUninstall.
  ///
  /// In en, this message translates to:
  /// **'Uninstall'**
  String get cleanerAppManagerUninstall;

  /// No description provided for @cleanerAppManagerSelected.
  ///
  /// In en, this message translates to:
  /// **'{selectedCount} selected'**
  String cleanerAppManagerSelected(Object selectedCount);

  /// No description provided for @cleanerAppManagerAppManager.
  ///
  /// In en, this message translates to:
  /// **'App Manager'**
  String get cleanerAppManagerAppManager;

  /// No description provided for @cleanerAppManagerDeselectAll.
  ///
  /// In en, this message translates to:
  /// **'Deselect all'**
  String get cleanerAppManagerDeselectAll;

  /// No description provided for @cleanerAppManagerUninstalling.
  ///
  /// In en, this message translates to:
  /// **'Uninstalling {done} / {total}…'**
  String cleanerAppManagerUninstalling(Object done, Object total);

  /// No description provided for @cleanerAppManagerUninstall2.
  ///
  /// In en, this message translates to:
  /// **'Uninstall {selectedCount}'**
  String cleanerAppManagerUninstall2(Object selectedCount);

  /// No description provided for @cleanerProClearAppCaches.
  ///
  /// In en, this message translates to:
  /// **'Clear app caches'**
  String get cleanerProClearAppCaches;

  /// No description provided for @cleanerProThisAsksAndroidToTrimAppCaches.
  ///
  /// In en, this message translates to:
  /// **'This asks Android to trim app caches across the device. App data, accounts and settings are not cleared.'**
  String get cleanerProThisAsksAndroidToTrimAppCaches;

  /// No description provided for @cleanerProClearCaches.
  ///
  /// In en, this message translates to:
  /// **'Clear caches'**
  String get cleanerProClearCaches;

  /// No description provided for @cleanerProCacheTrimRequested.
  ///
  /// In en, this message translates to:
  /// **'Cache trim requested'**
  String get cleanerProCacheTrimRequested;

  /// No description provided for @cleanerProCacheCleanerFailed.
  ///
  /// In en, this message translates to:
  /// **'Cache cleaner failed'**
  String get cleanerProCacheCleanerFailed;

  /// No description provided for @cleanerProLogFiles.
  ///
  /// In en, this message translates to:
  /// **'Log files'**
  String get cleanerProLogFiles;

  /// No description provided for @cleanerProCacheCleaner.
  ///
  /// In en, this message translates to:
  /// **'Cache Cleaner'**
  String get cleanerProCacheCleaner;

  /// No description provided for @cleanerProLogCleaner.
  ///
  /// In en, this message translates to:
  /// **'Log Cleaner'**
  String get cleanerProLogCleaner;

  /// No description provided for @cleanerProAppDataManager.
  ///
  /// In en, this message translates to:
  /// **'App Data Manager'**
  String get cleanerProAppDataManager;

  /// No description provided for @cleanerScreenCleaner.
  ///
  /// In en, this message translates to:
  /// **'Cleaner'**
  String get cleanerScreenCleaner;

  /// No description provided for @scanDetailDeleteFiles.
  ///
  /// In en, this message translates to:
  /// **'Delete Files'**
  String get scanDetailDeleteFiles;

  /// No description provided for @scanDetailDeleteFilesPermanently.
  ///
  /// In en, this message translates to:
  /// **'Delete {selectedCount} files permanently?'**
  String scanDetailDeleteFilesPermanently(Object selectedCount);

  /// No description provided for @scanDetailSelectedFilesDeleted.
  ///
  /// In en, this message translates to:
  /// **'Selected files deleted'**
  String get scanDetailSelectedFilesDeleted;

  /// No description provided for @scanDetailDeleteAllFiles.
  ///
  /// In en, this message translates to:
  /// **'Delete All Files'**
  String get scanDetailDeleteAllFiles;

  /// No description provided for @scanDetailDeleteAllFilesPermanently.
  ///
  /// In en, this message translates to:
  /// **'Delete all {fileCount} files permanently?'**
  String scanDetailDeleteAllFilesPermanently(Object fileCount);

  /// No description provided for @scanDetailDeleteAll.
  ///
  /// In en, this message translates to:
  /// **'Delete All'**
  String get scanDetailDeleteAll;

  /// No description provided for @scanDetailAllFilesDeleted.
  ///
  /// In en, this message translates to:
  /// **'All files deleted'**
  String get scanDetailAllFilesDeleted;

  /// No description provided for @scanDetailSelected.
  ///
  /// In en, this message translates to:
  /// **'{selectedCount} selected'**
  String scanDetailSelected(Object selectedCount);

  /// No description provided for @scanDetailDeselectAll.
  ///
  /// In en, this message translates to:
  /// **'Deselect all'**
  String get scanDetailDeselectAll;

  /// No description provided for @scanDetailNewestFirst.
  ///
  /// In en, this message translates to:
  /// **'Newest first'**
  String get scanDetailNewestFirst;

  /// No description provided for @scanDetailOldestFirst.
  ///
  /// In en, this message translates to:
  /// **'Oldest first'**
  String get scanDetailOldestFirst;

  /// No description provided for @scanDetailLargestFirst.
  ///
  /// In en, this message translates to:
  /// **'Largest first'**
  String get scanDetailLargestFirst;

  /// No description provided for @scanDetailSmallestFirst.
  ///
  /// In en, this message translates to:
  /// **'Smallest first'**
  String get scanDetailSmallestFirst;

  /// No description provided for @scanDetailNoFilesFound.
  ///
  /// In en, this message translates to:
  /// **'No files found'**
  String get scanDetailNoFilesFound;

  /// No description provided for @scanDetailDeleteAll2.
  ///
  /// In en, this message translates to:
  /// **'Delete all'**
  String get scanDetailDeleteAll2;

  /// No description provided for @scanInstalledAppsSearchApps.
  ///
  /// In en, this message translates to:
  /// **'Search apps...'**
  String get scanInstalledAppsSearchApps;

  /// No description provided for @scanInstalledAppsNoAppsFound.
  ///
  /// In en, this message translates to:
  /// **'No apps found.'**
  String get scanInstalledAppsNoAppsFound;

  /// No description provided for @scanUiScanComplete.
  ///
  /// In en, this message translates to:
  /// **'Scan complete'**
  String get scanUiScanComplete;

  /// No description provided for @scanUiScannedItems.
  ///
  /// In en, this message translates to:
  /// **'Scanned: {scanned} items'**
  String scanUiScannedItems(Object scanned);

  /// No description provided for @scanUiProgress.
  ///
  /// In en, this message translates to:
  /// **'Progress: {pct} ({scanned} / {total})'**
  String scanUiProgress(Object pct, Object scanned, Object total);

  /// No description provided for @scanUiPreparingEngine.
  ///
  /// In en, this message translates to:
  /// **'Preparing Engine...'**
  String get scanUiPreparingEngine;

  /// No description provided for @scanUiLoadingTargetS.
  ///
  /// In en, this message translates to:
  /// **'Loading target(s)'**
  String get scanUiLoadingTargetS;

  /// No description provided for @scanUiAvarionxVPN.
  ///
  /// In en, this message translates to:
  /// **'AvarionX VPN'**
  String get scanUiAvarionxVPN;

  /// No description provided for @scanUiProtectYourInternetWithOurUnlimitedVPN.
  ///
  /// In en, this message translates to:
  /// **'Protect your internet with our unlimited VPN'**
  String get scanUiProtectYourInternetWithOurUnlimitedVPN;

  /// No description provided for @scanUiTapMe.
  ///
  /// In en, this message translates to:
  /// **'Tap me!'**
  String get scanUiTapMe;

  /// No description provided for @scanUiScanned.
  ///
  /// In en, this message translates to:
  /// **'{scanned} scanned'**
  String scanUiScanned(Object scanned);

  /// No description provided for @scanUiReturn.
  ///
  /// In en, this message translates to:
  /// **'Return'**
  String get scanUiReturn;

  /// No description provided for @scanLimitsSettingsUpdated.
  ///
  /// In en, this message translates to:
  /// **'Settings updated'**
  String get scanLimitsSettingsUpdated;

  /// No description provided for @scanLimitsScanLimits.
  ///
  /// In en, this message translates to:
  /// **'Scan limits'**
  String get scanLimitsScanLimits;

  /// No description provided for @scanLimitsLimitHowMuchTheEngineUsesYour.
  ///
  /// In en, this message translates to:
  /// **'Limit how much the engine uses your CPU. Threads: 0 means auto.'**
  String get scanLimitsLimitHowMuchTheEngineUsesYour;

  /// No description provided for @scanLimitsMaxScanThreads.
  ///
  /// In en, this message translates to:
  /// **'Max scan threads'**
  String get scanLimitsMaxScanThreads;

  /// No description provided for @scanLimits0AutoRange0ToCores.
  ///
  /// In en, this message translates to:
  /// **'0 = auto. Range: 0 to {maxThreads} (cores: {coreCount}).'**
  String scanLimits0AutoRange0ToCores(Object maxThreads, Object coreCount);

  /// No description provided for @scanLegacyScanning.
  ///
  /// In en, this message translates to:
  /// **'Scanning... {percent}%'**
  String scanLegacyScanning(Object percent);

  /// No description provided for @scanLegacySuspicious.
  ///
  /// In en, this message translates to:
  /// **'Suspicious: {infectedCount}'**
  String scanLegacySuspicious(Object infectedCount);

  /// No description provided for @scanLegacyClean.
  ///
  /// In en, this message translates to:
  /// **'Clean: {cleanCount}'**
  String scanLegacyClean(Object cleanCount);

  /// No description provided for @scanLegacyNoFilesToScan.
  ///
  /// In en, this message translates to:
  /// **'No files to scan'**
  String get scanLegacyNoFilesToScan;

  /// No description provided for @settingsSponsorsUnlock.
  ///
  /// In en, this message translates to:
  /// **'Sponsors unlock ❤️'**
  String get settingsSponsorsUnlock;

  /// No description provided for @settingsPickCertificate.
  ///
  /// In en, this message translates to:
  /// **'Pick Certificate'**
  String get settingsPickCertificate;

  /// No description provided for @settingsCertificateLoaded.
  ///
  /// In en, this message translates to:
  /// **'Certificate loaded'**
  String get settingsCertificateLoaded;

  /// No description provided for @settingsEnterCode.
  ///
  /// In en, this message translates to:
  /// **'enter code'**
  String get settingsEnterCode;

  /// No description provided for @settingsSupportFileMissing.
  ///
  /// In en, this message translates to:
  /// **'Support file missing'**
  String get settingsSupportFileMissing;

  /// No description provided for @settingsInvalidSupportCode.
  ///
  /// In en, this message translates to:
  /// **'Invalid support code'**
  String get settingsInvalidSupportCode;

  /// No description provided for @settingsAvarionxSecurity.
  ///
  /// In en, this message translates to:
  /// **'AvarionX Security'**
  String get settingsAvarionxSecurity;

  /// No description provided for @settingsAvarionxIsAMobileSecuritySuiteCreated.
  ///
  /// In en, this message translates to:
  /// **'AvarionX is a mobile security suite created by ColourSwift, based in Birmingham, UK.\n\n'**
  String get settingsAvarionxIsAMobileSecuritySuiteCreated;

  /// No description provided for @settingsContact.
  ///
  /// In en, this message translates to:
  /// **'Contact: '**
  String get settingsContact;

  /// No description provided for @settingsExperimentalFeatures.
  ///
  /// In en, this message translates to:
  /// **'Experimental Features'**
  String get settingsExperimentalFeatures;

  /// No description provided for @settingsEnablingShizukuUnlocksExperimentalWorkInProgress.
  ///
  /// In en, this message translates to:
  /// **'Enabling Shizuku unlocks experimental work-in-progress features:\n\n'**
  String get settingsEnablingShizukuUnlocksExperimentalWorkInProgress;

  /// No description provided for @settingsAdvancedRansomwareProtection.
  ///
  /// In en, this message translates to:
  /// **'• Advanced Ransomware Protection\n'**
  String get settingsAdvancedRansomwareProtection;

  /// No description provided for @settingsCacheCleanerPlus.
  ///
  /// In en, this message translates to:
  /// **'• Cache Cleaner Plus\n\n'**
  String get settingsCacheCleanerPlus;

  /// No description provided for @settingsExperimentalWarning.
  ///
  /// In en, this message translates to:
  /// **'Experimental warning:\n'**
  String get settingsExperimentalWarning;

  /// No description provided for @settingsTheseFeaturesUseAdvancedSystemAccessAnd.
  ///
  /// In en, this message translates to:
  /// **'These features use advanced system access and may behave differently across devices, Android versions, and Shizuku setups. Some actions may affect running apps, files, or cache data more directly than normal scanning.\n\n'**
  String get settingsTheseFeaturesUseAdvancedSystemAccessAnd;

  /// No description provided for @settingsOnlyEnableThisIfYouUnderstandShizuku.
  ///
  /// In en, this message translates to:
  /// **'Only enable this if you understand Shizuku, accept that the feature is still being tested, and have backed up anything important.\n\n'**
  String get settingsOnlyEnableThisIfYouUnderstandShizuku;

  /// No description provided for @settingsPleaseReadTheDocumentationBeforeEnabling.
  ///
  /// In en, this message translates to:
  /// **'Please read the documentation before enabling.'**
  String get settingsPleaseReadTheDocumentationBeforeEnabling;

  /// No description provided for @settingsEnable.
  ///
  /// In en, this message translates to:
  /// **'Enable'**
  String get settingsEnable;

  /// No description provided for @settingsSigningOut.
  ///
  /// In en, this message translates to:
  /// **'Signing out...'**
  String get settingsSigningOut;

  /// No description provided for @settingsCheckingAccountStatus.
  ///
  /// In en, this message translates to:
  /// **'Checking account status...'**
  String get settingsCheckingAccountStatus;

  /// No description provided for @settingsManageSignInPremiumAndPurchases.
  ///
  /// In en, this message translates to:
  /// **'Manage sign in, Premium, and purchases'**
  String get settingsManageSignInPremiumAndPurchases;

  /// No description provided for @settingsPremiumActive.
  ///
  /// In en, this message translates to:
  /// **'Premium active'**
  String get settingsPremiumActive;

  /// No description provided for @settingsManagePremiumOptionsAndRestorePurchases.
  ///
  /// In en, this message translates to:
  /// **'Manage Premium options and restore purchases'**
  String get settingsManagePremiumOptionsAndRestorePurchases;

  /// No description provided for @settingsUnlockDeepAnalysisModeAndVPNFeatures.
  ///
  /// In en, this message translates to:
  /// **'Unlock Deep analysis mode and VPN features'**
  String get settingsUnlockDeepAnalysisModeAndVPNFeatures;

  /// No description provided for @settingsAutoClearNotifications.
  ///
  /// In en, this message translates to:
  /// **'Auto-clear notifications'**
  String get settingsAutoClearNotifications;

  /// No description provided for @settingsScanModes.
  ///
  /// In en, this message translates to:
  /// **'Scan Modes'**
  String get settingsScanModes;

  /// No description provided for @settingsAdvancedScanModes.
  ///
  /// In en, this message translates to:
  /// **'Advanced scan modes'**
  String get settingsAdvancedScanModes;

  /// No description provided for @settingsDisableToUseTheDefaultScanningMode.
  ///
  /// In en, this message translates to:
  /// **'Disable to use the default scanning mode'**
  String get settingsDisableToUseTheDefaultScanningMode;

  /// No description provided for @settingsToggleToEnableAllScanningModes.
  ///
  /// In en, this message translates to:
  /// **'Toggle to enable all scanning modes'**
  String get settingsToggleToEnableAllScanningModes;

  /// No description provided for @settingsApkSubmissions.
  ///
  /// In en, this message translates to:
  /// **'APK Submissions'**
  String get settingsApkSubmissions;

  /// No description provided for @settingsShareMaliciousAPKs.
  ///
  /// In en, this message translates to:
  /// **'Share malicious APKs'**
  String get settingsShareMaliciousAPKs;

  /// No description provided for @settingsHelpingImproveDetectionForEveryone.
  ///
  /// In en, this message translates to:
  /// **'Helping improve detection for everyone'**
  String get settingsHelpingImproveDetectionForEveryone;

  /// No description provided for @settingsOff.
  ///
  /// In en, this message translates to:
  /// **'Off'**
  String get settingsOff;

  /// No description provided for @settingsIncludeRealtimeProtectionCatches.
  ///
  /// In en, this message translates to:
  /// **'Include Realtime Protection catches'**
  String get settingsIncludeRealtimeProtectionCatches;

  /// No description provided for @settingsApksFlaggedByRealtimeProtectionAreIncluded.
  ///
  /// In en, this message translates to:
  /// **'APKs flagged by Realtime Protection are included'**
  String get settingsApksFlaggedByRealtimeProtectionAreIncluded;

  /// No description provided for @settingsApksFlaggedByRealtimeProtectionAreExcluded.
  ///
  /// In en, this message translates to:
  /// **'APKs flagged by Realtime Protection are excluded'**
  String get settingsApksFlaggedByRealtimeProtectionAreExcluded;

  /// No description provided for @settingsIncludeManualAndScheduledScans.
  ///
  /// In en, this message translates to:
  /// **'Include manual and scheduled scans'**
  String get settingsIncludeManualAndScheduledScans;

  /// No description provided for @settingsApksFlaggedByScansAreIncluded.
  ///
  /// In en, this message translates to:
  /// **'APKs flagged by scans are included'**
  String get settingsApksFlaggedByScansAreIncluded;

  /// No description provided for @settingsApksFlaggedByScansAreExcluded.
  ///
  /// In en, this message translates to:
  /// **'APKs flagged by scans are excluded'**
  String get settingsApksFlaggedByScansAreExcluded;

  /// No description provided for @settingsWiFiOnly.
  ///
  /// In en, this message translates to:
  /// **'Wi-Fi only'**
  String get settingsWiFiOnly;

  /// No description provided for @settingsUploadsWaitForAWiFiConnection.
  ///
  /// In en, this message translates to:
  /// **'Uploads wait for a Wi-Fi connection'**
  String get settingsUploadsWaitForAWiFiConnection;

  /// No description provided for @settingsUploadsMayUseMobileData.
  ///
  /// In en, this message translates to:
  /// **'Uploads may use mobile data'**
  String get settingsUploadsMayUseMobileData;

  /// No description provided for @settingsChargingOnly.
  ///
  /// In en, this message translates to:
  /// **'Charging only'**
  String get settingsChargingOnly;

  /// No description provided for @settingsUploadsWaitUntilTheDeviceIsCharging.
  ///
  /// In en, this message translates to:
  /// **'Uploads wait until the device is charging'**
  String get settingsUploadsWaitUntilTheDeviceIsCharging;

  /// No description provided for @settingsUploadsAreNotLimitedToCharging.
  ///
  /// In en, this message translates to:
  /// **'Uploads are not limited to charging'**
  String get settingsUploadsAreNotLimitedToCharging;

  /// No description provided for @settingsChooseWhichAppsUpload.
  ///
  /// In en, this message translates to:
  /// **'Choose which apps upload'**
  String get settingsChooseWhichAppsUpload;

  /// No description provided for @settingsReviewAndPickAppsEachTimeBefore.
  ///
  /// In en, this message translates to:
  /// **'Review and pick apps each time before uploading'**
  String get settingsReviewAndPickAppsEachTimeBefore;

  /// No description provided for @settingsFlaggedAppsUploadAutomatically.
  ///
  /// In en, this message translates to:
  /// **'Flagged apps upload automatically'**
  String get settingsFlaggedAppsUploadAutomatically;

  /// No description provided for @settingsEnableProDebug.
  ///
  /// In en, this message translates to:
  /// **'Enable Pro (debug)'**
  String get settingsEnableProDebug;

  /// No description provided for @settingsLocalUnlockForUITesting.
  ///
  /// In en, this message translates to:
  /// **'Local unlock for UI testing'**
  String get settingsLocalUnlockForUITesting;

  /// No description provided for @settingsRestorePurchases.
  ///
  /// In en, this message translates to:
  /// **'Restore purchases'**
  String get settingsRestorePurchases;

  /// No description provided for @settingsReCheckPlayBilling.
  ///
  /// In en, this message translates to:
  /// **'Re-check Play Billing'**
  String get settingsReCheckPlayBilling;

  /// No description provided for @settingsCheckingAccount.
  ///
  /// In en, this message translates to:
  /// **'Checking account...'**
  String get settingsCheckingAccount;

  /// No description provided for @settingsAvarionxAccountConnected.
  ///
  /// In en, this message translates to:
  /// **'AvarionX account connected'**
  String get settingsAvarionxAccountConnected;

  /// No description provided for @settingsAccountID.
  ///
  /// In en, this message translates to:
  /// **'Account ID: {accountId}'**
  String settingsAccountID(Object accountId);

  /// No description provided for @settingsSignInToManagePurchasesAndAccount.
  ///
  /// In en, this message translates to:
  /// **'Sign in to manage purchases and account features.'**
  String get settingsSignInToManagePurchasesAndAccount;

  /// No description provided for @settingsOpenTheAvarionXAccountPortal.
  ///
  /// In en, this message translates to:
  /// **'Open the AvarionX account portal'**
  String get settingsOpenTheAvarionXAccountPortal;

  /// No description provided for @settingsAccountDashboard.
  ///
  /// In en, this message translates to:
  /// **'Account dashboard'**
  String get settingsAccountDashboard;

  /// No description provided for @settingsOpenBillingAndAccountSettings.
  ///
  /// In en, this message translates to:
  /// **'Open billing and account settings'**
  String get settingsOpenBillingAndAccountSettings;

  /// No description provided for @settingsRemoveThisAccountFromTheApp.
  ///
  /// In en, this message translates to:
  /// **'Remove this account from the app'**
  String get settingsRemoveThisAccountFromTheApp;

  /// No description provided for @settingsPremiumFeaturesAreAvailableOnThisDevice.
  ///
  /// In en, this message translates to:
  /// **'Premium features are available on this device'**
  String get settingsPremiumFeaturesAreAvailableOnThisDevice;

  /// No description provided for @settingsViewOptionalPremiumFeatures.
  ///
  /// In en, this message translates to:
  /// **'View optional Premium features'**
  String get settingsViewOptionalPremiumFeatures;

  /// No description provided for @settingsReCheckPlayBillingEntitlement.
  ///
  /// In en, this message translates to:
  /// **'Re-check Play Billing entitlement'**
  String get settingsReCheckPlayBillingEntitlement;

  /// No description provided for @settingsRtpNotificationAutoClearNotifications.
  ///
  /// In en, this message translates to:
  /// **'Auto-clear notifications'**
  String get settingsRtpNotificationAutoClearNotifications;

  /// No description provided for @settingsRtpNotificationNever.
  ///
  /// In en, this message translates to:
  /// **'Never'**
  String get settingsRtpNotificationNever;

  /// No description provided for @settingsRtpNotification5Minutes.
  ///
  /// In en, this message translates to:
  /// **'5 minutes'**
  String get settingsRtpNotification5Minutes;

  /// No description provided for @settingsRtpNotification10Minutes.
  ///
  /// In en, this message translates to:
  /// **'10 minutes'**
  String get settingsRtpNotification10Minutes;

  /// No description provided for @settingsRtpNotification30Minutes.
  ///
  /// In en, this message translates to:
  /// **'30 minutes'**
  String get settingsRtpNotification30Minutes;

  /// No description provided for @settingsThemeBlack.
  ///
  /// In en, this message translates to:
  /// **'Black'**
  String get settingsThemeBlack;

  /// No description provided for @settingsThemeWhite.
  ///
  /// In en, this message translates to:
  /// **'White'**
  String get settingsThemeWhite;

  /// No description provided for @settingsThemeGrey.
  ///
  /// In en, this message translates to:
  /// **'Grey'**
  String get settingsThemeGrey;

  /// No description provided for @settingsThemeEmerald.
  ///
  /// In en, this message translates to:
  /// **'Emerald'**
  String get settingsThemeEmerald;

  /// No description provided for @settingsThemePurple.
  ///
  /// In en, this message translates to:
  /// **'Purple'**
  String get settingsThemePurple;

  /// No description provided for @settingsThemeRoyalBlue.
  ///
  /// In en, this message translates to:
  /// **'Royal Blue'**
  String get settingsThemeRoyalBlue;

  /// No description provided for @settingsAccountCardSyncPurchasesAndUnlockProAcrossApps.
  ///
  /// In en, this message translates to:
  /// **'Sync purchases and unlock Pro across apps.'**
  String get settingsAccountCardSyncPurchasesAndUnlockProAcrossApps;

  /// No description provided for @settingsAccountCardLoading.
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get settingsAccountCardLoading;

  /// No description provided for @settingsAccountCardDashboard.
  ///
  /// In en, this message translates to:
  /// **'Dashboard'**
  String get settingsAccountCardDashboard;

  /// No description provided for @settingsProCardChangePlan.
  ///
  /// In en, this message translates to:
  /// **'Change plan'**
  String get settingsProCardChangePlan;

  /// No description provided for @advancedNetworkProtectionEnterYourOwnResolver.
  ///
  /// In en, this message translates to:
  /// **'Enter your own resolver'**
  String get advancedNetworkProtectionEnterYourOwnResolver;

  /// No description provided for @advancedNetworkProtectionCloudProtectionMode.
  ///
  /// In en, this message translates to:
  /// **'Cloud protection mode'**
  String get advancedNetworkProtectionCloudProtectionMode;

  /// No description provided for @advancedNetworkProtectionRoutesAllDNSQueriesToTheCloud.
  ///
  /// In en, this message translates to:
  /// **'Routes all DNS queries to the cloud engine, enabling live blocklist updates, domain reputation checking, and more.'**
  String get advancedNetworkProtectionRoutesAllDNSQueriesToTheCloud;

  /// No description provided for @advancedNetworkProtectionRefreshProStatus.
  ///
  /// In en, this message translates to:
  /// **'Refresh pro status'**
  String get advancedNetworkProtectionRefreshProStatus;

  /// No description provided for @advancedNetworkProtectionProActive.
  ///
  /// In en, this message translates to:
  /// **'Pro active'**
  String get advancedNetworkProtectionProActive;

  /// No description provided for @advancedNetworkProtectionFreePlan.
  ///
  /// In en, this message translates to:
  /// **'Free plan'**
  String get advancedNetworkProtectionFreePlan;

  /// No description provided for @advancedNetworkProtectionChecksYourEntitlementAndSyncsItWith.
  ///
  /// In en, this message translates to:
  /// **'Checks your entitlement and syncs it with cloud features. Pro unlocks system wide ad blocking.'**
  String get advancedNetworkProtectionChecksYourEntitlementAndSyncsItWith;

  /// No description provided for @advancedNetworkProtectionMalwareProtection.
  ///
  /// In en, this message translates to:
  /// **'Malware protection'**
  String get advancedNetworkProtectionMalwareProtection;

  /// No description provided for @advancedNetworkProtectionBlocksKnownMaliciousDomains.
  ///
  /// In en, this message translates to:
  /// **'Blocks known malicious domains'**
  String get advancedNetworkProtectionBlocksKnownMaliciousDomains;

  /// No description provided for @advancedNetworkProtectionTrackerProtection.
  ///
  /// In en, this message translates to:
  /// **'Tracker protection'**
  String get advancedNetworkProtectionTrackerProtection;

  /// No description provided for @advancedNetworkProtectionReducesTrackingDomains.
  ///
  /// In en, this message translates to:
  /// **'Reduces tracking domains'**
  String get advancedNetworkProtectionReducesTrackingDomains;

  /// No description provided for @advancedNetworkProtectionAdProtection.
  ///
  /// In en, this message translates to:
  /// **'Ad protection'**
  String get advancedNetworkProtectionAdProtection;

  /// No description provided for @advancedNetworkProtectionBlocksCommonAdDomains.
  ///
  /// In en, this message translates to:
  /// **'Blocks common ad domains'**
  String get advancedNetworkProtectionBlocksCommonAdDomains;

  /// No description provided for @advancedNetworkProtectionAdultFilter.
  ///
  /// In en, this message translates to:
  /// **'Adult filter'**
  String get advancedNetworkProtectionAdultFilter;

  /// No description provided for @advancedNetworkProtectionUses1113Upstream.
  ///
  /// In en, this message translates to:
  /// **'Uses 1.1.1.3 upstream'**
  String get advancedNetworkProtectionUses1113Upstream;

  /// No description provided for @advancedNetworkProtectionLockedUntilProIsActiveAndCloud.
  ///
  /// In en, this message translates to:
  /// **'Locked until Pro is active and cloud mode is enabled.'**
  String get advancedNetworkProtectionLockedUntilProIsActiveAndCloud;

  /// No description provided for @advancedNetworkProtectionLiveDNSEventsFromTheVPNLayer.
  ///
  /// In en, this message translates to:
  /// **'Live DNS events from the VPN layer.'**
  String get advancedNetworkProtectionLiveDNSEventsFromTheVPNLayer;

  /// No description provided for @advancedNetworkProtectionAdvanced.
  ///
  /// In en, this message translates to:
  /// **'Advanced'**
  String get advancedNetworkProtectionAdvanced;

  /// No description provided for @advancedNetworkProtectionDns.
  ///
  /// In en, this message translates to:
  /// **'DNS'**
  String get advancedNetworkProtectionDns;

  /// No description provided for @advancedNetworkProtectionCloudDNSMode.
  ///
  /// In en, this message translates to:
  /// **'Cloud DNS mode'**
  String get advancedNetworkProtectionCloudDNSMode;

  /// No description provided for @networkProtectionEnterYourOwnResolver.
  ///
  /// In en, this message translates to:
  /// **'Enter your own resolver'**
  String get networkProtectionEnterYourOwnResolver;

  /// No description provided for @networkAppControlEnableVPNToggles.
  ///
  /// In en, this message translates to:
  /// **'Enable VPN toggles'**
  String get networkAppControlEnableVPNToggles;

  /// No description provided for @networkAppControlOpenSettings.
  ///
  /// In en, this message translates to:
  /// **'Open settings'**
  String get networkAppControlOpenSettings;

  /// No description provided for @networkAppControlAppControl.
  ///
  /// In en, this message translates to:
  /// **'App control'**
  String get networkAppControlAppControl;

  /// No description provided for @networkAppControlNoAppsFound.
  ///
  /// In en, this message translates to:
  /// **'No apps found.'**
  String get networkAppControlNoAppsFound;

  /// No description provided for @networkSpeedTestCountry.
  ///
  /// In en, this message translates to:
  /// **'Country'**
  String get networkSpeedTestCountry;

  /// No description provided for @networkSpeedTestRunning.
  ///
  /// In en, this message translates to:
  /// **'Running'**
  String get networkSpeedTestRunning;

  /// No description provided for @networkSpeedTestRunTest.
  ///
  /// In en, this message translates to:
  /// **'Run test'**
  String get networkSpeedTestRunTest;

  /// No description provided for @networkSpeedTestNoResultsYet.
  ///
  /// In en, this message translates to:
  /// **'No results yet.'**
  String get networkSpeedTestNoResultsYet;

  /// No description provided for @networkSpeedTestDnsTLS.
  ///
  /// In en, this message translates to:
  /// **'DNS: {dns}  •  TLS: {tls}'**
  String networkSpeedTestDnsTLS(Object dns, Object tls);

  /// No description provided for @networkSpeedTestFail.
  ///
  /// In en, this message translates to:
  /// **'Fail'**
  String get networkSpeedTestFail;

  /// No description provided for @dnsNetworkProtectionEnterYourOwnResolver.
  ///
  /// In en, this message translates to:
  /// **'Enter your own resolver'**
  String get dnsNetworkProtectionEnterYourOwnResolver;

  /// No description provided for @dnsNetworkProtectionDnsFilteringIsSeperateFromTheSecure.
  ///
  /// In en, this message translates to:
  /// **'DNS filtering is seperate from the Secure VPN. It can block known malware, ads (across all apps), trackers, and content from unwanted categories before they load.'**
  String get dnsNetworkProtectionDnsFilteringIsSeperateFromTheSecure;

  /// No description provided for @fullVpnSignedIn.
  ///
  /// In en, this message translates to:
  /// **'Signed in.'**
  String get fullVpnSignedIn;

  /// No description provided for @fullVpnSignInRequired.
  ///
  /// In en, this message translates to:
  /// **'Sign in required'**
  String get fullVpnSignInRequired;

  /// No description provided for @fullVpnClose.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get fullVpnClose;

  /// No description provided for @fullVpnLoadingUsage.
  ///
  /// In en, this message translates to:
  /// **'Loading usage...'**
  String get fullVpnLoadingUsage;

  /// No description provided for @fullVpnSyncing.
  ///
  /// In en, this message translates to:
  /// **'Syncing'**
  String get fullVpnSyncing;

  /// No description provided for @fullVpnUsedThisMonth.
  ///
  /// In en, this message translates to:
  /// **'{usedBytes} used this month'**
  String fullVpnUsedThisMonth(Object usedBytes);

  /// No description provided for @blockedScreenUnsupportedEnvironment.
  ///
  /// In en, this message translates to:
  /// **'Unsupported environment'**
  String get blockedScreenUnsupportedEnvironment;

  /// No description provided for @updateLogUpdateV.
  ///
  /// In en, this message translates to:
  /// **'Update: v{version}'**
  String updateLogUpdateV(Object version);

  /// No description provided for @updateLogHiThereAvarionXHasBeenUpdatedBelow.
  ///
  /// In en, this message translates to:
  /// **'Hi there! AvarionX has been updated, below are the changes:'**
  String get updateLogHiThereAvarionXHasBeenUpdatedBelow;

  /// No description provided for @updateLogNoUserFacingChangesInThisUpdate.
  ///
  /// In en, this message translates to:
  /// **'No user-facing changes in this update.'**
  String get updateLogNoUserFacingChangesInThisUpdate;

  /// No description provided for @updateLogContinue.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get updateLogContinue;

  /// No description provided for @featuresRealtimeProtectionBody.
  ///
  /// In en, this message translates to:
  /// **'Monitors new and modified files in the background and blocks threats the moment they appear.'**
  String get featuresRealtimeProtectionBody;

  /// No description provided for @featuresTriLayerEngineTitle.
  ///
  /// In en, this message translates to:
  /// **'Tri-Layer Engine'**
  String get featuresTriLayerEngineTitle;

  /// No description provided for @featuresTriLayerEngineBody.
  ///
  /// In en, this message translates to:
  /// **'A three-stage detection core combining Bloom filtering, signature scanning, and APK-focused byte analysis for high accuracy and speed.'**
  String get featuresTriLayerEngineBody;

  /// No description provided for @featuresMachineLearningTitle.
  ///
  /// In en, this message translates to:
  /// **'Machine Learning'**
  String get featuresMachineLearningTitle;

  /// No description provided for @featuresMachineLearningBody.
  ///
  /// In en, this message translates to:
  /// **'A lightweight on-device model trained to recognise malicious APK behaviour patterns.'**
  String get featuresMachineLearningBody;

  /// No description provided for @featuresCleanerProTitle.
  ///
  /// In en, this message translates to:
  /// **'Cleaner Pro'**
  String get featuresCleanerProTitle;

  /// No description provided for @featuresCleanerProBody.
  ///
  /// In en, this message translates to:
  /// **'An evolving cleaning module that identifies duplicates, cache, and unused apps to reclaim storage.'**
  String get featuresCleanerProBody;

  /// No description provided for @featuresWifiProtectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Wi-Fi Protection'**
  String get featuresWifiProtectionTitle;

  /// No description provided for @featuresWifiProtectionBody.
  ///
  /// In en, this message translates to:
  /// **'Detects unsafe or suspicious Wi-Fi networks using on-device analysis.'**
  String get featuresWifiProtectionBody;

  /// No description provided for @featuresRootLevelProtectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Root-Level Protection'**
  String get featuresRootLevelProtectionTitle;

  /// No description provided for @featuresRootLevelProtectionBody.
  ///
  /// In en, this message translates to:
  /// **'Deep system-level defense designed for rooted devices and advanced users.'**
  String get featuresRootLevelProtectionBody;

  /// No description provided for @featuresPcCompanionTitle.
  ///
  /// In en, this message translates to:
  /// **'PC Companion'**
  String get featuresPcCompanionTitle;

  /// No description provided for @featuresPcCompanionBody.
  ///
  /// In en, this message translates to:
  /// **'Upcoming desktop version for cross-platform antivirus integration.'**
  String get featuresPcCompanionBody;

  /// No description provided for @deviceSecurityNoRisksFound.
  ///
  /// In en, this message translates to:
  /// **'No device risks found'**
  String get deviceSecurityNoRisksFound;

  /// No description provided for @deviceSecurityOneCheckNeedsAttention.
  ///
  /// In en, this message translates to:
  /// **'1 device check needs attention'**
  String get deviceSecurityOneCheckNeedsAttention;

  /// No description provided for @deviceSecurityChecksNeedAttention.
  ///
  /// In en, this message translates to:
  /// **'{count} device checks need attention'**
  String deviceSecurityChecksNeedAttention(Object count);

  /// No description provided for @deviceSecurityHealthSectionBody.
  ///
  /// In en, this message translates to:
  /// **'These settings directly affect your device posture.'**
  String get deviceSecurityHealthSectionBody;

  /// No description provided for @deviceSecurityRecommendationsSectionBody.
  ///
  /// In en, this message translates to:
  /// **'These settings are common security good practice.'**
  String get deviceSecurityRecommendationsSectionBody;

  /// No description provided for @deviceSecuritySignalUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Signal unavailable'**
  String get deviceSecuritySignalUnavailable;

  /// No description provided for @deviceSecurityIgnoredByYou.
  ///
  /// In en, this message translates to:
  /// **'Ignored by you'**
  String get deviceSecurityIgnoredByYou;

  /// No description provided for @deviceSecurityScreenLockInactiveTitle.
  ///
  /// In en, this message translates to:
  /// **'Screen Lock'**
  String get deviceSecurityScreenLockInactiveTitle;

  /// No description provided for @deviceSecurityScreenLockActiveLabel.
  ///
  /// In en, this message translates to:
  /// **'Unsafe, no secure screen lock is set'**
  String get deviceSecurityScreenLockActiveLabel;

  /// No description provided for @deviceSecurityScreenLockInactiveLabel.
  ///
  /// In en, this message translates to:
  /// **'Screen lock is active'**
  String get deviceSecurityScreenLockInactiveLabel;

  /// No description provided for @deviceSecurityScreenLockDetail.
  ///
  /// In en, this message translates to:
  /// **'A secure screen lock protects your device if it is lost, stolen, or left unattended. Without a PIN, password, pattern, fingerprint, or face unlock backed by a secure lock method, anyone with physical access can open the device more easily.'**
  String get deviceSecurityScreenLockDetail;

  /// No description provided for @deviceSecurityScreenLockHelp.
  ///
  /// In en, this message translates to:
  /// **'Open Android security settings and set a secure screen lock.'**
  String get deviceSecurityScreenLockHelp;

  /// No description provided for @deviceSecurityCheckSetting.
  ///
  /// In en, this message translates to:
  /// **'Check setting'**
  String get deviceSecurityCheckSetting;

  /// No description provided for @deviceSecurityPrivilegedInactiveTitle.
  ///
  /// In en, this message translates to:
  /// **'No Privileged Access'**
  String get deviceSecurityPrivilegedInactiveTitle;

  /// No description provided for @deviceSecurityPrivilegedActiveLabel.
  ///
  /// In en, this message translates to:
  /// **'Privileged access detected'**
  String get deviceSecurityPrivilegedActiveLabel;

  /// No description provided for @deviceSecurityPrivilegedInactiveLabel.
  ///
  /// In en, this message translates to:
  /// **'No privileged access detected'**
  String get deviceSecurityPrivilegedInactiveLabel;

  /// No description provided for @deviceSecurityPrivilegedDetail.
  ///
  /// In en, this message translates to:
  /// **'Root and Shizuku can be useful for you, but it also increase the impact of a malicious app if access is abused. Apps with privileged access may be able to perform actions that normal Android apps cannot.'**
  String get deviceSecurityPrivilegedDetail;

  /// No description provided for @deviceSecurityPrivilegedHelp.
  ///
  /// In en, this message translates to:
  /// **'Review your root, Magisk, or Shizuku settings manually.'**
  String get deviceSecurityPrivilegedHelp;

  /// No description provided for @deviceSecurityReviewSetting.
  ///
  /// In en, this message translates to:
  /// **'Review setting'**
  String get deviceSecurityReviewSetting;

  /// No description provided for @deviceSecurityAppVerificationInactiveTitle.
  ///
  /// In en, this message translates to:
  /// **'App Verification'**
  String get deviceSecurityAppVerificationInactiveTitle;

  /// No description provided for @deviceSecurityAppVerificationActiveLabel.
  ///
  /// In en, this message translates to:
  /// **'Unsafe, app verification appears disabled'**
  String get deviceSecurityAppVerificationActiveLabel;

  /// No description provided for @deviceSecurityAppVerificationInactiveLabel.
  ///
  /// In en, this message translates to:
  /// **'App verification appears enabled'**
  String get deviceSecurityAppVerificationInactiveLabel;

  /// No description provided for @deviceSecurityAppVerificationDetail.
  ///
  /// In en, this message translates to:
  /// **'Android app verification helps check apps before or after installation. If this protection is disabled or unavailable, harmful apps may be less likely to be blocked before they run.'**
  String get deviceSecurityAppVerificationDetail;

  /// No description provided for @deviceSecurityAppVerificationHelp.
  ///
  /// In en, this message translates to:
  /// **'Open Android security settings and review app verification.'**
  String get deviceSecurityAppVerificationHelp;

  /// No description provided for @deviceSecuritySecurityPatchInactiveTitle.
  ///
  /// In en, this message translates to:
  /// **'Security Patch Current'**
  String get deviceSecuritySecurityPatchInactiveTitle;

  /// No description provided for @deviceSecuritySecurityPatchActiveLabel.
  ///
  /// In en, this message translates to:
  /// **'Security patch level is outdated'**
  String get deviceSecuritySecurityPatchActiveLabel;

  /// No description provided for @deviceSecuritySecurityPatchInactiveLabel.
  ///
  /// In en, this message translates to:
  /// **'Security patch level is current'**
  String get deviceSecuritySecurityPatchInactiveLabel;

  /// No description provided for @deviceSecuritySecurityPatchDetail.
  ///
  /// In en, this message translates to:
  /// **'Android security patches fix known platform and vendor issues. If the patch level is old, the device may be exposed to vulnerabilities that have already been fixed on newer builds.'**
  String get deviceSecuritySecurityPatchDetail;

  /// No description provided for @deviceSecuritySecurityPatchHelp.
  ///
  /// In en, this message translates to:
  /// **'Open Android system update settings and check for updates.'**
  String get deviceSecuritySecurityPatchHelp;

  /// No description provided for @deviceSecurityCheckUpdates.
  ///
  /// In en, this message translates to:
  /// **'Check updates'**
  String get deviceSecurityCheckUpdates;

  /// No description provided for @deviceSecurityDeveloperModeInactiveTitle.
  ///
  /// In en, this message translates to:
  /// **'Developer Mode'**
  String get deviceSecurityDeveloperModeInactiveTitle;

  /// No description provided for @deviceSecurityDeveloperModeActiveLabel.
  ///
  /// In en, this message translates to:
  /// **'Developer options are enabled'**
  String get deviceSecurityDeveloperModeActiveLabel;

  /// No description provided for @deviceSecurityDeveloperModeInactiveLabel.
  ///
  /// In en, this message translates to:
  /// **'Developer options are disabled'**
  String get deviceSecurityDeveloperModeInactiveLabel;

  /// No description provided for @deviceSecurityDeveloperModeDetail.
  ///
  /// In en, this message translates to:
  /// **'Developer Mode is normal for developers and testers, but it exposes advanced settings that can reduce device security if changed accidentally or abused by someone with access to the device.'**
  String get deviceSecurityDeveloperModeDetail;

  /// No description provided for @deviceSecurityDeveloperModeHelp.
  ///
  /// In en, this message translates to:
  /// **'Open Developer Options and turn off settings you do not need.'**
  String get deviceSecurityDeveloperModeHelp;

  /// No description provided for @deviceSecurityUsbDebuggingInactiveTitle.
  ///
  /// In en, this message translates to:
  /// **'USB Debugging'**
  String get deviceSecurityUsbDebuggingInactiveTitle;

  /// No description provided for @deviceSecurityUsbDebuggingActiveLabel.
  ///
  /// In en, this message translates to:
  /// **'Unsafe, USB debugging is turned on'**
  String get deviceSecurityUsbDebuggingActiveLabel;

  /// No description provided for @deviceSecurityUsbDebuggingInactiveLabel.
  ///
  /// In en, this message translates to:
  /// **'USB debugging is turned off'**
  String get deviceSecurityUsbDebuggingInactiveLabel;

  /// No description provided for @deviceSecurityUsbDebuggingDetail.
  ///
  /// In en, this message translates to:
  /// **'USB debugging allows a connected computer to interact with your device through Android Debug Bridge. If left enabled, it increases the risk of unauthorised access when connected to an untrusted machine.'**
  String get deviceSecurityUsbDebuggingDetail;

  /// No description provided for @deviceSecurityUsbDebuggingHelp.
  ///
  /// In en, this message translates to:
  /// **'Open Developer Options and turn USB debugging off.'**
  String get deviceSecurityUsbDebuggingHelp;

  /// No description provided for @deviceSecurityUnknownSourcesInactiveTitle.
  ///
  /// In en, this message translates to:
  /// **'Unknown Sources'**
  String get deviceSecurityUnknownSourcesInactiveTitle;

  /// No description provided for @deviceSecurityUnknownSourcesActiveLabel.
  ///
  /// In en, this message translates to:
  /// **'Installing unknown apps is allowed'**
  String get deviceSecurityUnknownSourcesActiveLabel;

  /// No description provided for @deviceSecurityUnknownSourcesInactiveLabel.
  ///
  /// In en, this message translates to:
  /// **'Installing unknown apps is restricted'**
  String get deviceSecurityUnknownSourcesInactiveLabel;

  /// No description provided for @deviceSecurityUnknownSourcesDetail.
  ///
  /// In en, this message translates to:
  /// **'Allowing unknown app installs can be useful for trusted APKs, but it also increases the chance of installing apps from unsafe sources. Only allow this for apps and stores you trust.'**
  String get deviceSecurityUnknownSourcesDetail;

  /// No description provided for @deviceSecurityUnknownSourcesHelp.
  ///
  /// In en, this message translates to:
  /// **'Open Android settings and review install unknown apps access.'**
  String get deviceSecurityUnknownSourcesHelp;

  /// No description provided for @deviceSecurityAccessibilityInactiveTitle.
  ///
  /// In en, this message translates to:
  /// **'Accessibility Services'**
  String get deviceSecurityAccessibilityInactiveTitle;

  /// No description provided for @deviceSecurityAccessibilityActiveLabel.
  ///
  /// In en, this message translates to:
  /// **'Third-party accessibility service enabled'**
  String get deviceSecurityAccessibilityActiveLabel;

  /// No description provided for @deviceSecurityAccessibilityInactiveLabel.
  ///
  /// In en, this message translates to:
  /// **'No risky accessibility services found'**
  String get deviceSecurityAccessibilityInactiveLabel;

  /// No description provided for @deviceSecurityAccessibilityDetail.
  ///
  /// In en, this message translates to:
  /// **'Accessibility services are powerful because they can observe screen content and perform actions on behalf of the user. This is useful for legitimate tools, but it is also commonly abused by malicious apps.'**
  String get deviceSecurityAccessibilityDetail;

  /// No description provided for @deviceSecurityAccessibilityHelp.
  ///
  /// In en, this message translates to:
  /// **'Open Accessibility settings and review enabled services.'**
  String get deviceSecurityAccessibilityHelp;

  /// No description provided for @deviceSecurityChecking.
  ///
  /// In en, this message translates to:
  /// **'Checking device security'**
  String get deviceSecurityChecking;

  /// No description provided for @deviceSecurityReadingSignals.
  ///
  /// In en, this message translates to:
  /// **'Reading device posture signals...'**
  String get deviceSecurityReadingSignals;

  /// No description provided for @deviceSecurityOneCheckAttention.
  ///
  /// In en, this message translates to:
  /// **'1 check needs attention'**
  String get deviceSecurityOneCheckAttention;

  /// No description provided for @deviceSecurityChecksAttention.
  ///
  /// In en, this message translates to:
  /// **'{count} checks need attention'**
  String deviceSecurityChecksAttention(Object count);

  /// No description provided for @deviceSecurityTapSignal.
  ///
  /// In en, this message translates to:
  /// **'Tap a signal below to learn more.'**
  String get deviceSecurityTapSignal;

  /// No description provided for @deviceSecurityIgnoredChecks.
  ///
  /// In en, this message translates to:
  /// **'{count} active check{plural} ignored by you.'**
  String deviceSecurityIgnoredChecks(Object count, String plural);

  /// No description provided for @deviceSecurityPostureNormal.
  ///
  /// In en, this message translates to:
  /// **'Your device posture checks look normal.'**
  String get deviceSecurityPostureNormal;

  /// No description provided for @timeJustNow.
  ///
  /// In en, this message translates to:
  /// **'just now'**
  String get timeJustNow;

  /// No description provided for @timeMinutesAgo.
  ///
  /// In en, this message translates to:
  /// **'{minutes}m ago'**
  String timeMinutesAgo(Object minutes);

  /// No description provided for @timeHoursAgo.
  ///
  /// In en, this message translates to:
  /// **'{hours}h ago'**
  String timeHoursAgo(Object hours);

  /// No description provided for @timeDaysAgo.
  ///
  /// In en, this message translates to:
  /// **'{days}d ago'**
  String timeDaysAgo(Object days);

  /// No description provided for @securityNoReportDataYet.
  ///
  /// In en, this message translates to:
  /// **'No report data yet'**
  String get securityNoReportDataYet;

  /// No description provided for @securityLastActivity.
  ///
  /// In en, this message translates to:
  /// **'Last activity {relative}'**
  String securityLastActivity(Object relative);

  /// No description provided for @securityReportSharePdfTitle.
  ///
  /// In en, this message translates to:
  /// **'Avarionx Security Report'**
  String get securityReportSharePdfTitle;

  /// No description provided for @securityReportCsvField.
  ///
  /// In en, this message translates to:
  /// **'Field'**
  String get securityReportCsvField;

  /// No description provided for @securityReportCsvValue.
  ///
  /// In en, this message translates to:
  /// **'Value'**
  String get securityReportCsvValue;

  /// No description provided for @securityReportGeneratedAt.
  ///
  /// In en, this message translates to:
  /// **'Generated at'**
  String get securityReportGeneratedAt;

  /// No description provided for @securityReportOverallStatus.
  ///
  /// In en, this message translates to:
  /// **'Overall status'**
  String get securityReportOverallStatus;

  /// No description provided for @securityReportLastManualScan.
  ///
  /// In en, this message translates to:
  /// **'Last manual scan'**
  String get securityReportLastManualScan;

  /// No description provided for @securityReportLastRealtimeEvent.
  ///
  /// In en, this message translates to:
  /// **'Last realtime event'**
  String get securityReportLastRealtimeEvent;

  /// No description provided for @securityReportLastScheduledScan.
  ///
  /// In en, this message translates to:
  /// **'Last scheduled scan'**
  String get securityReportLastScheduledScan;

  /// No description provided for @securityReportShareCsvTitle.
  ///
  /// In en, this message translates to:
  /// **'Avarionx Security Report CSV'**
  String get securityReportShareCsvTitle;

  /// No description provided for @securityReportReviewRecommended.
  ///
  /// In en, this message translates to:
  /// **'Review recommended'**
  String get securityReportReviewRecommended;

  /// No description provided for @securityReportNoKnownThreatDetected.
  ///
  /// In en, this message translates to:
  /// **'No known threat detected'**
  String get securityReportNoKnownThreatDetected;

  /// No description provided for @securityReportGeneratedLine.
  ///
  /// In en, this message translates to:
  /// **'Generated: {generatedAt}'**
  String securityReportGeneratedLine(Object generatedAt);

  /// No description provided for @securityReportStatusLine.
  ///
  /// In en, this message translates to:
  /// **'Status: {status}'**
  String securityReportStatusLine(Object status);

  /// No description provided for @securityReportLatestActivityLine.
  ///
  /// In en, this message translates to:
  /// **'Latest activity: {latest}'**
  String securityReportLatestActivityLine(Object latest);

  /// No description provided for @securityReportManualScansLine.
  ///
  /// In en, this message translates to:
  /// **'Manual scans: {count}'**
  String securityReportManualScansLine(Object count);

  /// No description provided for @securityReportRealtimeChecksLine.
  ///
  /// In en, this message translates to:
  /// **'Realtime checks: {count}'**
  String securityReportRealtimeChecksLine(Object count);

  /// No description provided for @securityReportTotalFilesScannedLine.
  ///
  /// In en, this message translates to:
  /// **'Total files scanned: {count}'**
  String securityReportTotalFilesScannedLine(Object count);

  /// No description provided for @securityReportThreatsFoundLine.
  ///
  /// In en, this message translates to:
  /// **'Threats found: {count}'**
  String securityReportThreatsFoundLine(Object count);

  /// No description provided for @securityReportLastManualScanLine.
  ///
  /// In en, this message translates to:
  /// **'Last manual scan: {value}'**
  String securityReportLastManualScanLine(Object value);

  /// No description provided for @securityReportLastRealtimeEventLine.
  ///
  /// In en, this message translates to:
  /// **'Last realtime event: {value}'**
  String securityReportLastRealtimeEventLine(Object value);

  /// No description provided for @securityReportLastScheduledScanLine.
  ///
  /// In en, this message translates to:
  /// **'Last scheduled scan: {value}'**
  String securityReportLastScheduledScanLine(Object value);

  /// No description provided for @securityReportNotRecorded.
  ///
  /// In en, this message translates to:
  /// **'Not recorded'**
  String get securityReportNotRecorded;

  /// No description provided for @safeViewNavigationBlocked.
  ///
  /// In en, this message translates to:
  /// **'Navigation blocked'**
  String get safeViewNavigationBlocked;

  /// No description provided for @safeViewInvalidDestination.
  ///
  /// In en, this message translates to:
  /// **'Invalid destination'**
  String get safeViewInvalidDestination;

  /// No description provided for @safeViewUnsupportedScheme.
  ///
  /// In en, this message translates to:
  /// **'Unsupported scheme'**
  String get safeViewUnsupportedScheme;

  /// No description provided for @safeViewUnableToResolveDestination.
  ///
  /// In en, this message translates to:
  /// **'Unable to resolve destination'**
  String get safeViewUnableToResolveDestination;

  /// No description provided for @safeViewDestinationBlocked.
  ///
  /// In en, this message translates to:
  /// **'Destination blocked'**
  String get safeViewDestinationBlocked;

  /// No description provided for @safeViewUnableToVerifyDestination.
  ///
  /// In en, this message translates to:
  /// **'Unable to verify destination'**
  String get safeViewUnableToVerifyDestination;

  /// No description provided for @proScreenCurrentStatus.
  ///
  /// In en, this message translates to:
  /// **'Current status: {status}'**
  String proScreenCurrentStatus(Object status);

  /// No description provided for @proScreenBilledAnnuallyAt.
  ///
  /// In en, this message translates to:
  /// **'Billed annually at {price}'**
  String proScreenBilledAnnuallyAt(Object price);

  /// No description provided for @quarantineUnknownApp.
  ///
  /// In en, this message translates to:
  /// **'Unknown App'**
  String get quarantineUnknownApp;

  /// No description provided for @cleanerScanCancelled.
  ///
  /// In en, this message translates to:
  /// **'Scan cancelled'**
  String get cleanerScanCancelled;

  /// No description provided for @cleanerProClearingCaches.
  ///
  /// In en, this message translates to:
  /// **'Clearing caches…'**
  String get cleanerProClearingCaches;

  /// No description provided for @cleanerProTrimAppCaches.
  ///
  /// In en, this message translates to:
  /// **'Trim app caches across the device.'**
  String get cleanerProTrimAppCaches;

  /// No description provided for @cleanerProEnableShizuku.
  ///
  /// In en, this message translates to:
  /// **'Enable Shizuku in Settings to use this.'**
  String get cleanerProEnableShizuku;

  /// No description provided for @cleanerProScanningStorage.
  ///
  /// In en, this message translates to:
  /// **'Scanning storage…'**
  String get cleanerProScanningStorage;

  /// No description provided for @cleanerProFindLogFiles.
  ///
  /// In en, this message translates to:
  /// **'Find .log, .trace, .crash and .dmp files.'**
  String get cleanerProFindLogFiles;

  /// No description provided for @cleanerProLogFileCount.
  ///
  /// In en, this message translates to:
  /// **'{count} files • {size}'**
  String cleanerProLogFileCount(Object count, Object size);

  /// No description provided for @cleanerProAppManagerReady.
  ///
  /// In en, this message translates to:
  /// **'Force stop, clear data and batch uninstall apps.'**
  String get cleanerProAppManagerReady;

  /// No description provided for @cleanerProAppManagerLimited.
  ///
  /// In en, this message translates to:
  /// **'Uninstall works normally. Force stop and clear data require Shizuku.'**
  String get cleanerProAppManagerLimited;

  /// No description provided for @cleanerProCheckingShizuku.
  ///
  /// In en, this message translates to:
  /// **'Checking Shizuku…'**
  String get cleanerProCheckingShizuku;

  /// No description provided for @cleanerProShizukuNotRunning.
  ///
  /// In en, this message translates to:
  /// **'Shizuku is not running. Enable it from Settings when needed.'**
  String get cleanerProShizukuNotRunning;

  /// No description provided for @cleanerProShizukuPermissionMissing.
  ///
  /// In en, this message translates to:
  /// **'Shizuku permission is not granted. Enable it from Settings.'**
  String get cleanerProShizukuPermissionMissing;

  /// No description provided for @cleanerProShizukuNotBound.
  ///
  /// In en, this message translates to:
  /// **'Shizuku service is not bound yet. Open Settings and refresh this screen after enabling it.'**
  String get cleanerProShizukuNotBound;

  /// No description provided for @cleanerLiteTab.
  ///
  /// In en, this message translates to:
  /// **'Lite'**
  String get cleanerLiteTab;

  /// No description provided for @cleanerProTab.
  ///
  /// In en, this message translates to:
  /// **'Pro'**
  String get cleanerProTab;

  /// No description provided for @scanCancelled.
  ///
  /// In en, this message translates to:
  /// **'Scan cancelled'**
  String get scanCancelled;

  /// No description provided for @scanPreparing.
  ///
  /// In en, this message translates to:
  /// **'Preparing scan...'**
  String get scanPreparing;

  /// No description provided for @scanSuspiciousItemsFound.
  ///
  /// In en, this message translates to:
  /// **'{count} suspicious item{plural} found'**
  String scanSuspiciousItemsFound(Object count, String plural);

  /// No description provided for @scanSuspiciousCount.
  ///
  /// In en, this message translates to:
  /// **'{count} suspicious'**
  String scanSuspiciousCount(Object count);

  /// No description provided for @scanCleanCount.
  ///
  /// In en, this message translates to:
  /// **'{count} clean'**
  String scanCleanCount(Object count);

  /// No description provided for @scanNotificationFullItems.
  ///
  /// In en, this message translates to:
  /// **'Scanned: {count} items'**
  String scanNotificationFullItems(Object count);

  /// No description provided for @scanNotificationCurrent.
  ///
  /// In en, this message translates to:
  /// **'Scanned: {count} • {file}'**
  String scanNotificationCurrent(Object count, Object file);

  /// No description provided for @scanNotificationProgress.
  ///
  /// In en, this message translates to:
  /// **'{scanned} / {total}'**
  String scanNotificationProgress(Object scanned, Object total);

  /// No description provided for @scanNotificationProgressCurrent.
  ///
  /// In en, this message translates to:
  /// **'{scanned} / {total} • {file}'**
  String scanNotificationProgressCurrent(
      Object scanned, Object total, Object file);

  /// No description provided for @settingsThemeRoyalBluePremium.
  ///
  /// In en, this message translates to:
  /// **'Royal Blue (Premium)'**
  String get settingsThemeRoyalBluePremium;

  /// No description provided for @settingsIconDefault.
  ///
  /// In en, this message translates to:
  /// **'Default'**
  String get settingsIconDefault;

  /// No description provided for @settingsIconBird.
  ///
  /// In en, this message translates to:
  /// **'Bird'**
  String get settingsIconBird;

  /// No description provided for @settingsIconNeon.
  ///
  /// In en, this message translates to:
  /// **'Neon'**
  String get settingsIconNeon;

  /// No description provided for @settingsIconOriginal.
  ///
  /// In en, this message translates to:
  /// **'Original'**
  String get settingsIconOriginal;

  /// No description provided for @homeRealtimeProtectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Real-Time Protection'**
  String get homeRealtimeProtectionTitle;

  /// No description provided for @networkCardStatusLocked.
  ///
  /// In en, this message translates to:
  /// **'Locked'**
  String get networkCardStatusLocked;

  /// No description provided for @networkSectionConnection.
  ///
  /// In en, this message translates to:
  /// **'Connection'**
  String get networkSectionConnection;

  /// No description provided for @networkSectionBlocklists.
  ///
  /// In en, this message translates to:
  /// **'Blocklists'**
  String get networkSectionBlocklists;

  /// No description provided for @networkSectionResolver.
  ///
  /// In en, this message translates to:
  /// **'Resolver'**
  String get networkSectionResolver;

  /// No description provided for @networkAppControlOtherVpnSetupInstructions.
  ///
  /// In en, this message translates to:
  /// **'Another VPN is currently selected as Always-on.\\n\\nTo block apps reliably:\\n\\n1) Open Android VPN settings\\n2) Select AvarionX as the VPN\\n3) Enable Always-on VPN\\n4) Enable Block connections without VPN'**
  String get networkAppControlOtherVpnSetupInstructions;

  /// No description provided for @networkAppControlSetupInstructions.
  ///
  /// In en, this message translates to:
  /// **'To block apps reliably:\\n\\n1) Open Android VPN settings\\n2) Select AvarionX as the VPN\\n3) Enable Always-on VPN\\n4) Enable Block connections without VPN'**
  String get networkAppControlSetupInstructions;

  /// No description provided for @networkAppControlBlockingActive.
  ///
  /// In en, this message translates to:
  /// **'App blocking is active.'**
  String get networkAppControlBlockingActive;

  /// No description provided for @networkAppControlOtherVpnWarning.
  ///
  /// In en, this message translates to:
  /// **'Another VPN is set as Always-on. Enable Always-on + Block without VPN for AvarionX.'**
  String get networkAppControlOtherVpnWarning;

  /// No description provided for @networkAppControlSetupWarning.
  ///
  /// In en, this message translates to:
  /// **'Enable Always-on + Block without VPN for AvarionX to make app blocking work.'**
  String get networkAppControlSetupWarning;

  /// No description provided for @countryUnitedKingdom.
  ///
  /// In en, this message translates to:
  /// **'United Kingdom'**
  String get countryUnitedKingdom;

  /// No description provided for @countryUnitedStates.
  ///
  /// In en, this message translates to:
  /// **'United States'**
  String get countryUnitedStates;

  /// No description provided for @countryCanada.
  ///
  /// In en, this message translates to:
  /// **'Canada'**
  String get countryCanada;

  /// No description provided for @countryIreland.
  ///
  /// In en, this message translates to:
  /// **'Ireland'**
  String get countryIreland;

  /// No description provided for @countryFrance.
  ///
  /// In en, this message translates to:
  /// **'France'**
  String get countryFrance;

  /// No description provided for @countryGermany.
  ///
  /// In en, this message translates to:
  /// **'Germany'**
  String get countryGermany;

  /// No description provided for @countryNetherlands.
  ///
  /// In en, this message translates to:
  /// **'Netherlands'**
  String get countryNetherlands;

  /// No description provided for @countrySpain.
  ///
  /// In en, this message translates to:
  /// **'Spain'**
  String get countrySpain;

  /// No description provided for @countryItaly.
  ///
  /// In en, this message translates to:
  /// **'Italy'**
  String get countryItaly;

  /// No description provided for @countrySweden.
  ///
  /// In en, this message translates to:
  /// **'Sweden'**
  String get countrySweden;

  /// No description provided for @countryNorway.
  ///
  /// In en, this message translates to:
  /// **'Norway'**
  String get countryNorway;

  /// No description provided for @countryDenmark.
  ///
  /// In en, this message translates to:
  /// **'Denmark'**
  String get countryDenmark;

  /// No description provided for @countryPoland.
  ///
  /// In en, this message translates to:
  /// **'Poland'**
  String get countryPoland;

  /// No description provided for @countryTurkey.
  ///
  /// In en, this message translates to:
  /// **'Turkey'**
  String get countryTurkey;

  /// No description provided for @countryGreece.
  ///
  /// In en, this message translates to:
  /// **'Greece'**
  String get countryGreece;

  /// No description provided for @countryRomania.
  ///
  /// In en, this message translates to:
  /// **'Romania'**
  String get countryRomania;

  /// No description provided for @countryUkraine.
  ///
  /// In en, this message translates to:
  /// **'Ukraine'**
  String get countryUkraine;

  /// No description provided for @countryRussia.
  ///
  /// In en, this message translates to:
  /// **'Russia'**
  String get countryRussia;

  /// No description provided for @countryIndia.
  ///
  /// In en, this message translates to:
  /// **'India'**
  String get countryIndia;

  /// No description provided for @countryPakistan.
  ///
  /// In en, this message translates to:
  /// **'Pakistan'**
  String get countryPakistan;

  /// No description provided for @countryBangladesh.
  ///
  /// In en, this message translates to:
  /// **'Bangladesh'**
  String get countryBangladesh;

  /// No description provided for @countrySriLanka.
  ///
  /// In en, this message translates to:
  /// **'Sri Lanka'**
  String get countrySriLanka;

  /// No description provided for @countryNepal.
  ///
  /// In en, this message translates to:
  /// **'Nepal'**
  String get countryNepal;

  /// No description provided for @countryJapan.
  ///
  /// In en, this message translates to:
  /// **'Japan'**
  String get countryJapan;

  /// No description provided for @countrySouthKorea.
  ///
  /// In en, this message translates to:
  /// **'South Korea'**
  String get countrySouthKorea;

  /// No description provided for @countrySingapore.
  ///
  /// In en, this message translates to:
  /// **'Singapore'**
  String get countrySingapore;

  /// No description provided for @countryMalaysia.
  ///
  /// In en, this message translates to:
  /// **'Malaysia'**
  String get countryMalaysia;

  /// No description provided for @countryThailand.
  ///
  /// In en, this message translates to:
  /// **'Thailand'**
  String get countryThailand;

  /// No description provided for @countryVietnam.
  ///
  /// In en, this message translates to:
  /// **'Vietnam'**
  String get countryVietnam;

  /// No description provided for @countryPhilippines.
  ///
  /// In en, this message translates to:
  /// **'Philippines'**
  String get countryPhilippines;

  /// No description provided for @countryIndonesia.
  ///
  /// In en, this message translates to:
  /// **'Indonesia'**
  String get countryIndonesia;

  /// No description provided for @countryAustralia.
  ///
  /// In en, this message translates to:
  /// **'Australia'**
  String get countryAustralia;

  /// No description provided for @countryNewZealand.
  ///
  /// In en, this message translates to:
  /// **'New Zealand'**
  String get countryNewZealand;

  /// No description provided for @countryBrazil.
  ///
  /// In en, this message translates to:
  /// **'Brazil'**
  String get countryBrazil;

  /// No description provided for @countryArgentina.
  ///
  /// In en, this message translates to:
  /// **'Argentina'**
  String get countryArgentina;

  /// No description provided for @countryChile.
  ///
  /// In en, this message translates to:
  /// **'Chile'**
  String get countryChile;

  /// No description provided for @countryMexico.
  ///
  /// In en, this message translates to:
  /// **'Mexico'**
  String get countryMexico;

  /// No description provided for @countryColombia.
  ///
  /// In en, this message translates to:
  /// **'Colombia'**
  String get countryColombia;

  /// No description provided for @countryPeru.
  ///
  /// In en, this message translates to:
  /// **'Peru'**
  String get countryPeru;

  /// No description provided for @countrySouthAfrica.
  ///
  /// In en, this message translates to:
  /// **'South Africa'**
  String get countrySouthAfrica;

  /// No description provided for @countryNigeria.
  ///
  /// In en, this message translates to:
  /// **'Nigeria'**
  String get countryNigeria;

  /// No description provided for @countryKenya.
  ///
  /// In en, this message translates to:
  /// **'Kenya'**
  String get countryKenya;

  /// No description provided for @countryEgypt.
  ///
  /// In en, this message translates to:
  /// **'Egypt'**
  String get countryEgypt;

  /// No description provided for @countryUAE.
  ///
  /// In en, this message translates to:
  /// **'UAE'**
  String get countryUAE;

  /// No description provided for @countrySaudiArabia.
  ///
  /// In en, this message translates to:
  /// **'Saudi Arabia'**
  String get countrySaudiArabia;

  /// No description provided for @countryIsrael.
  ///
  /// In en, this message translates to:
  /// **'Israel'**
  String get countryIsrael;

  /// No description provided for @networkSpeedTestTesting.
  ///
  /// In en, this message translates to:
  /// **'Testing {current}/{total} • {domain}'**
  String networkSpeedTestTesting(Object current, Object total, Object domain);

  /// No description provided for @networkSpeedTestDone.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get networkSpeedTestDone;

  /// No description provided for @vpnFooterCustomisation.
  ///
  /// In en, this message translates to:
  /// **'Customisation'**
  String get vpnFooterCustomisation;

  /// No description provided for @apkClipboardReportTitle.
  ///
  /// In en, this message translates to:
  /// **'VTTI Cloud - APK Analysis Report'**
  String get apkClipboardReportTitle;

  /// No description provided for @apkClipboardAppName.
  ///
  /// In en, this message translates to:
  /// **'App Name: {name}'**
  String apkClipboardAppName(Object name);

  /// No description provided for @apkClipboardPackageId.
  ///
  /// In en, this message translates to:
  /// **'Package ID: {packageId}'**
  String apkClipboardPackageId(Object packageId);

  /// No description provided for @apkClipboardVersion.
  ///
  /// In en, this message translates to:
  /// **'Version: {version}'**
  String apkClipboardVersion(Object version);

  /// No description provided for @apkClipboardFileSize.
  ///
  /// In en, this message translates to:
  /// **'File Size: {size}'**
  String apkClipboardFileSize(Object size);

  /// No description provided for @apkClipboardMinSdk.
  ///
  /// In en, this message translates to:
  /// **'Min SDK: {sdk}'**
  String apkClipboardMinSdk(Object sdk);

  /// No description provided for @apkClipboardTargetSdk.
  ///
  /// In en, this message translates to:
  /// **'Target SDK: {sdk}'**
  String apkClipboardTargetSdk(Object sdk);

  /// No description provided for @apkClipboardSignature.
  ///
  /// In en, this message translates to:
  /// **'Signature: {signature}'**
  String apkClipboardSignature(Object signature);

  /// No description provided for @apkClipboardMalwareRisk.
  ///
  /// In en, this message translates to:
  /// **'Malware Risk: {risk}'**
  String apkClipboardMalwareRisk(Object risk);

  /// No description provided for @apkClipboardRiskLabel.
  ///
  /// In en, this message translates to:
  /// **'Risk Label: {label}'**
  String apkClipboardRiskLabel(Object label);

  /// No description provided for @apkClipboardHashVerdict.
  ///
  /// In en, this message translates to:
  /// **'Hash Verdict: {verdict}'**
  String apkClipboardHashVerdict(Object verdict);

  /// No description provided for @apkClipboardRationale.
  ///
  /// In en, this message translates to:
  /// **'Rationale: {rationale}'**
  String apkClipboardRationale(Object rationale);

  /// No description provided for @apkReportUnusualFlags.
  ///
  /// In en, this message translates to:
  /// **'Unusual Flags'**
  String get apkReportUnusualFlags;

  /// No description provided for @apkReportUnverifiedItems.
  ///
  /// In en, this message translates to:
  /// **'Unverified Items'**
  String get apkReportUnverifiedItems;

  /// No description provided for @apkReportKnownMalware.
  ///
  /// In en, this message translates to:
  /// **'Known Malware'**
  String get apkReportKnownMalware;

  /// No description provided for @apkReportSuspiciousHash.
  ///
  /// In en, this message translates to:
  /// **'Suspicious Hash'**
  String get apkReportSuspiciousHash;

  /// No description provided for @apkReportCleanHash.
  ///
  /// In en, this message translates to:
  /// **'Clean Hash'**
  String get apkReportCleanHash;

  /// No description provided for @apkReportHashNotChecked.
  ///
  /// In en, this message translates to:
  /// **'Hash Not Checked'**
  String get apkReportHashNotChecked;

  /// No description provided for @apkReportHashUnknown.
  ///
  /// In en, this message translates to:
  /// **'Hash Unknown'**
  String get apkReportHashUnknown;

  /// No description provided for @apkMetadataPackage.
  ///
  /// In en, this message translates to:
  /// **'Package'**
  String get apkMetadataPackage;

  /// No description provided for @apkMetadataPackageId.
  ///
  /// In en, this message translates to:
  /// **'Package ID'**
  String get apkMetadataPackageId;

  /// No description provided for @apkMetadataEngine.
  ///
  /// In en, this message translates to:
  /// **'Engine'**
  String get apkMetadataEngine;

  /// No description provided for @apkMetadataSize.
  ///
  /// In en, this message translates to:
  /// **'Size'**
  String get apkMetadataSize;

  /// No description provided for @apkMetadataMinSdk.
  ///
  /// In en, this message translates to:
  /// **'Min SDK'**
  String get apkMetadataMinSdk;

  /// No description provided for @apkMetadataTargetSdk.
  ///
  /// In en, this message translates to:
  /// **'Target SDK'**
  String get apkMetadataTargetSdk;

  /// No description provided for @apkMetadataSignature.
  ///
  /// In en, this message translates to:
  /// **'Signature'**
  String get apkMetadataSignature;

  /// No description provided for @apkAnalyserStageDeconstructing.
  ///
  /// In en, this message translates to:
  /// **'Deconstructing APK'**
  String get apkAnalyserStageDeconstructing;

  /// No description provided for @apkAnalyserStageAnalysing.
  ///
  /// In en, this message translates to:
  /// **'Analysing content'**
  String get apkAnalyserStageAnalysing;

  /// No description provided for @apkAnalyserSignInRequired.
  ///
  /// In en, this message translates to:
  /// **'Please sign in via Settings to use Cloud Analysis.'**
  String get apkAnalyserSignInRequired;

  /// No description provided for @apkAnalyserStageCheckingCloud.
  ///
  /// In en, this message translates to:
  /// **'Checking VTTI Cloud'**
  String get apkAnalyserStageCheckingCloud;

  /// No description provided for @apkAnalyserDailyLimitReached.
  ///
  /// In en, this message translates to:
  /// **'You have reached your daily limit of {limit} analyses.'**
  String apkAnalyserDailyLimitReached(Object limit);

  /// No description provided for @apkAnalyserCloudAnalysisFailed.
  ///
  /// In en, this message translates to:
  /// **'Cloud analysis failed'**
  String get apkAnalyserCloudAnalysisFailed;

  /// No description provided for @apkAnalyserStageGeneratingReport.
  ///
  /// In en, this message translates to:
  /// **'Generating report'**
  String get apkAnalyserStageGeneratingReport;

  /// No description provided for @apkAnalyserAnalysisFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to process APK analysis'**
  String get apkAnalyserAnalysisFailed;

  /// No description provided for @genericError.
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get genericError;

  /// No description provided for @apkReportEngineVttiCloud.
  ///
  /// In en, this message translates to:
  /// **'VTTI Cloud Engine'**
  String get apkReportEngineVttiCloud;

  /// No description provided for @apkReportCertificateDetected.
  ///
  /// In en, this message translates to:
  /// **'Certificate detected'**
  String get apkReportCertificateDetected;

  /// No description provided for @apkReportNoCertificateData.
  ///
  /// In en, this message translates to:
  /// **'No certificate data'**
  String get apkReportNoCertificateData;

  /// No description provided for @apkExportOverview.
  ///
  /// In en, this message translates to:
  /// **'Overview'**
  String get apkExportOverview;

  /// No description provided for @apkExportMalwareAssessment.
  ///
  /// In en, this message translates to:
  /// **'Malware Assessment'**
  String get apkExportMalwareAssessment;

  /// No description provided for @apkExportRiskScore.
  ///
  /// In en, this message translates to:
  /// **'Risk Score'**
  String get apkExportRiskScore;

  /// No description provided for @apkExportRiskLabel.
  ///
  /// In en, this message translates to:
  /// **'Risk Label'**
  String get apkExportRiskLabel;

  /// No description provided for @apkExportHashVerdict.
  ///
  /// In en, this message translates to:
  /// **'Hash Verdict'**
  String get apkExportHashVerdict;

  /// No description provided for @apkExportScoreRationale.
  ///
  /// In en, this message translates to:
  /// **'Score Rationale'**
  String get apkExportScoreRationale;

  /// No description provided for @apkExportContributingSignals.
  ///
  /// In en, this message translates to:
  /// **'Contributing Signals'**
  String get apkExportContributingSignals;

  /// No description provided for @apkExportDampeningFactors.
  ///
  /// In en, this message translates to:
  /// **'Dampening Factors'**
  String get apkExportDampeningFactors;

  /// No description provided for @apkExportPermissionsRequested.
  ///
  /// In en, this message translates to:
  /// **'Permissions Requested'**
  String get apkExportPermissionsRequested;

  /// No description provided for @apkExportExtraFlagsUnusual.
  ///
  /// In en, this message translates to:
  /// **'Extra Flags (Unusual)'**
  String get apkExportExtraFlagsUnusual;

  /// No description provided for @apkExportExtraFlagsUnverified.
  ///
  /// In en, this message translates to:
  /// **'Extra Flags (Unverified)'**
  String get apkExportExtraFlagsUnverified;

  /// No description provided for @apkExportDiscoveredSources.
  ///
  /// In en, this message translates to:
  /// **'Discovered Sources'**
  String get apkExportDiscoveredSources;

  /// No description provided for @apkExportRequestedPermissions.
  ///
  /// In en, this message translates to:
  /// **'Requested Permissions'**
  String get apkExportRequestedPermissions;

  /// No description provided for @apkExportRationale.
  ///
  /// In en, this message translates to:
  /// **'Rationale'**
  String get apkExportRationale;

  /// No description provided for @apkExportCsvShareText.
  ///
  /// In en, this message translates to:
  /// **'APK Analysis CSV for {name}'**
  String apkExportCsvShareText(Object name);

  /// No description provided for @apkExportPdfTitle.
  ///
  /// In en, this message translates to:
  /// **'VTTI Cloud - APK Analysis'**
  String get apkExportPdfTitle;

  /// No description provided for @apkExportPdfShareText.
  ///
  /// In en, this message translates to:
  /// **'APK Analysis PDF for {name}'**
  String apkExportPdfShareText(Object name);

  /// No description provided for @apkMetadataAppName.
  ///
  /// In en, this message translates to:
  /// **'App Name'**
  String get apkMetadataAppName;

  /// No description provided for @apkMetadataFileSize.
  ///
  /// In en, this message translates to:
  /// **'File Size'**
  String get apkMetadataFileSize;

  /// No description provided for @vpnBackendFailedOpenBrowser.
  ///
  /// In en, this message translates to:
  /// **'Failed to open browser.'**
  String get vpnBackendFailedOpenBrowser;

  /// No description provided for @vpnBackendSignedIn.
  ///
  /// In en, this message translates to:
  /// **'Signed in.'**
  String get vpnBackendSignedIn;

  /// No description provided for @vpnBackendSignedOut.
  ///
  /// In en, this message translates to:
  /// **'Signed out.'**
  String get vpnBackendSignedOut;

  /// No description provided for @vpnBackendSessionExpiredSignIn.
  ///
  /// In en, this message translates to:
  /// **'Session expired. Sign in again.'**
  String get vpnBackendSessionExpiredSignIn;

  /// No description provided for @vpnBackendFailedLoadAccountStatus.
  ///
  /// In en, this message translates to:
  /// **'Failed to load account ({status}).'**
  String vpnBackendFailedLoadAccountStatus(Object status);

  /// No description provided for @vpnBackendFailedLoadAccountError.
  ///
  /// In en, this message translates to:
  /// **'Failed to load account ({error}).'**
  String vpnBackendFailedLoadAccountError(Object error);

  /// No description provided for @vpnBackendSignInFirst.
  ///
  /// In en, this message translates to:
  /// **'Sign in first.'**
  String get vpnBackendSignInFirst;

  /// No description provided for @vpnBackendConnecting.
  ///
  /// In en, this message translates to:
  /// **'Connecting...'**
  String get vpnBackendConnecting;

  /// No description provided for @vpnBackendNotificationsPermissionRequired.
  ///
  /// In en, this message translates to:
  /// **'Notifications permission required.'**
  String get vpnBackendNotificationsPermissionRequired;

  /// No description provided for @vpnBackendPermissionNotGranted.
  ///
  /// In en, this message translates to:
  /// **'VPN permission not granted.'**
  String get vpnBackendPermissionNotGranted;

  /// No description provided for @vpnBackendAnotherVpnActive.
  ///
  /// In en, this message translates to:
  /// **'Another VPN is active. Disable it first.'**
  String get vpnBackendAnotherVpnActive;

  /// No description provided for @vpnBackendProvisionIncomplete.
  ///
  /// In en, this message translates to:
  /// **'Provision returned incomplete settings.'**
  String get vpnBackendProvisionIncomplete;

  /// No description provided for @vpnBackendSecuringConnection.
  ///
  /// In en, this message translates to:
  /// **'Securing connection...'**
  String get vpnBackendSecuringConnection;

  /// No description provided for @vpnBackendConnected.
  ///
  /// In en, this message translates to:
  /// **'Connected.'**
  String get vpnBackendConnected;

  /// No description provided for @vpnBackendWireGuardFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to start WireGuard ({error}).'**
  String vpnBackendWireGuardFailed(Object error);

  /// No description provided for @vpnBackendDisconnecting.
  ///
  /// In en, this message translates to:
  /// **'Disconnecting...'**
  String get vpnBackendDisconnecting;

  /// No description provided for @vpnBackendDisconnected.
  ///
  /// In en, this message translates to:
  /// **'Disconnected.'**
  String get vpnBackendDisconnected;

  /// No description provided for @vpnBackendSelectedServer.
  ///
  /// In en, this message translates to:
  /// **'Selected {server}'**
  String vpnBackendSelectedServer(Object server);

  /// No description provided for @vpnBackendSwitchingServer.
  ///
  /// In en, this message translates to:
  /// **'Switching to {server}...'**
  String vpnBackendSwitchingServer(Object server);

  /// No description provided for @vpnBackendKeyNotFound.
  ///
  /// In en, this message translates to:
  /// **'VPN key not found.'**
  String get vpnBackendKeyNotFound;

  /// No description provided for @vpnBackendDnsUpdated.
  ///
  /// In en, this message translates to:
  /// **'DNS settings updated.'**
  String get vpnBackendDnsUpdated;

  /// No description provided for @vpnBackendSessionExpired.
  ///
  /// In en, this message translates to:
  /// **'Session expired.'**
  String get vpnBackendSessionExpired;

  /// No description provided for @vpnBackendFailedStatus.
  ///
  /// In en, this message translates to:
  /// **'Failed ({status}).'**
  String vpnBackendFailedStatus(Object status);

  /// No description provided for @vpnBackendPlanNotAllowed.
  ///
  /// In en, this message translates to:
  /// **'Your plan is not allowed to use Full VPN.'**
  String get vpnBackendPlanNotAllowed;

  /// No description provided for @vpnBackendProvisionFailed.
  ///
  /// In en, this message translates to:
  /// **'Provision failed ({status}).'**
  String vpnBackendProvisionFailed(Object status);
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>[
        'ar',
        'de',
        'en',
        'es',
        'ja',
        'pl',
        'pt'
      ].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'de':
      return AppLocalizationsDe();
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'ja':
      return AppLocalizationsJa();
    case 'pl':
      return AppLocalizationsPl();
    case 'pt':
      return AppLocalizationsPt();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
