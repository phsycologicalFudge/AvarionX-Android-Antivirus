import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
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
    Locale('en'),
    Locale('es'),
    Locale('pl'),
    Locale('pt')
  ];

  /// No description provided for @appName.
  ///
  /// In en, this message translates to:
  /// **'AVarionX Security'**
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
  /// **'PRO'**
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
  /// **'ENGINE READY • VX-TITANIUM-v7'**
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
  /// **'File Protection Only'**
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
  /// **'Database v{version} • Auto updated'**
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
  /// **'AVarionX Security'**
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

  /// No description provided for @networkStatusConnected.
  ///
  /// In en, this message translates to:
  /// **'Connected to {dns}'**
  String networkStatusConnected(Object dns);

  /// No description provided for @networkStatusVpnConflict.
  ///
  /// In en, this message translates to:
  /// **'Another VPN is active'**
  String get networkStatusVpnConflict;

  /// No description provided for @networkStatusOff.
  ///
  /// In en, this message translates to:
  /// **'Network protection is off'**
  String get networkStatusOff;

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
  /// **'Remove ads and unlock themes and icons'**
  String get settingsProSubtitle;

  /// No description provided for @settingsUnlockPro.
  ///
  /// In en, this message translates to:
  /// **'Unlock PRO'**
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
  /// **'Hide gold header on Home Screen'**
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

  /// No description provided for @settingsSave.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get settingsSave;

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
  String quarantineDeleteDialogBody(Object count, Object plural);
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ar', 'en', 'es', 'pl', 'pt'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
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
