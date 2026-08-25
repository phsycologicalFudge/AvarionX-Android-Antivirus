// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get appName => 'AvarionX';

  @override
  String get ok => 'OK';

  @override
  String get cancel => 'Abbrechen';

  @override
  String get footerHome => 'Start';

  @override
  String get footerExplore => 'Entdecken';

  @override
  String get footerRemoved => 'Entfernt';

  @override
  String get footerSettings => 'Einstellungen';

  @override
  String get proBadge => 'Premium';

  @override
  String get updateDbTitle => 'Datenbank wird aktualisiert';

  @override
  String updateDbVersionLabel(Object version) {
    return 'Version $version';
  }

  @override
  String get companionAppsSectionTitle => 'Mehr von AvarionX';

  @override
  String get cleanerReclaimableLabel => 'Kann freigegeben werden';

  @override
  String get exploreMultiThreadingTitle => 'Multi-Threading';

  @override
  String get exploreMultiThreadingSubtitle => 'Experimentelle Engine-Steuerung';

  @override
  String get updateDbAutoDownloadLabel =>
      'Zukünftige Updates automatisch herunterladen';

  @override
  String get updateDbUpdatedAutoOn =>
      'Datenbank aktualisiert • Auto-Updates aktiviert';

  @override
  String get updateDbUpdatedSuccess => 'Datenbank erfolgreich aktualisiert';

  @override
  String get updateDbUpdateFailed => 'Datenbank-Update fehlgeschlagen';

  @override
  String get engineReadyBanner => 'VX-TITANIUM-v9';

  @override
  String get scanButton => 'Scannen';

  @override
  String get scanModeFullTitle => 'Vollständiger Gerätescan';

  @override
  String get scanModeFullSubtitle => 'Scannt alle lesbaren Speicherdateien.';

  @override
  String get scanModeSmartTitle => 'Smart Scan [Empfohlen]';

  @override
  String get scanModeSmartSubtitle =>
      'Scannt Dateien, die Malware enthalten könnten.';

  @override
  String get scanModeRapidTitle => 'Schnellscan';

  @override
  String get scanModeRapidSubtitle => 'Prüft neue APKs im Download-Ordner.';

  @override
  String get scanModeInstalledTitle => 'Installierte Apps';

  @override
  String get scanModeInstalledSubtitle =>
      'Scannt deine installierten Apps auf Bedrohungen.';

  @override
  String get scanModeSingleTitle => 'Datei- / App-Scan';

  @override
  String get scanModeSingleSubtitle =>
      'Wähle eine Datei oder App zum Scannen aus.';

  @override
  String get useCloudAssistedScan => 'Cloud-unterstützten Scan verwenden';

  @override
  String get protectionTitle => 'Schutz';

  @override
  String get stateOffLine1 => 'Geräteschutz ist deaktiviert';

  @override
  String get stateOffLine2 => 'Zum Einschalten tippen';

  @override
  String get stateAdvancedActiveLine1 => 'Erweiterter Schutz ist aktiv';

  @override
  String get stateFileOnlyLine1 => 'Dateischutz aktiv';

  @override
  String get stateFileOnlyLine2 => 'Netzwerkschutz deaktiviert';

  @override
  String get stateVpnConflictLine2 => 'Ein anderes VPN ist aktiv';

  @override
  String get stateProtectedLine1 => 'Gerät geschützt';

  @override
  String get stateProtectedLine2 => 'Zum Ausschalten tippen';

  @override
  String get dbUpdating => 'Datenbank wird aktualisiert';

  @override
  String dbVersionAutoUpdated(Object version) {
    return 'Datenbank v$version • Automatisch aktualisiert';
  }

  @override
  String get rtpInfoTitle => 'Echtzeitschutz';

  @override
  String get rtpInfoBody =>
      'Neben dem Blockieren verdächtiger Dateien, die absichtlich oder durch Malware heruntergeladen wurden, verwendet RTP ein lokales VPN, um bösartige Domains systemweit zu blockieren.\n\nWenn aktiviert, bleibt die Netzwerkfilterung aktiv, außer sie wird:\n• manuell über das Terminal deaktiviert\n• durch ein anderes VPN ersetzt\n\nDer Dateischutz läuft weiter, solange RTP aktiviert ist.';

  @override
  String get scanTitleDefault => 'Scannen';

  @override
  String get scanTitleSmart => 'Smart Scan';

  @override
  String get scanTitleRapid => 'Schnellscan';

  @override
  String get scanTitleInstalled => 'Installierte Apps scannen';

  @override
  String get scanTitleFull => 'Vollständiger Gerätescan';

  @override
  String get scanTitleSingle => 'Einzelscan';

  @override
  String get cancellingScan => 'Scan wird abgebrochen…';

  @override
  String get cancelScan => 'Scan abbrechen';

  @override
  String get scanProgressZero => 'Fortschritt: 0%';

  @override
  String scanProgressWithPct(Object pct, Object scanned, Object total) {
    return 'Fortschritt: $pct% ($scanned / $total)';
  }

  @override
  String scanProgressFullItems(Object count) {
    return 'Gescannt: $count Elemente';
  }

  @override
  String get initializing => 'Initialisierung...';

  @override
  String get scanningEllipsis => 'Scannt...';

  @override
  String get fullScanInfoTitle => 'Vollständiger Gerätescan';

  @override
  String get fullScanInfoBody =>
      'Dieser Modus scannt jede lesbare Datei im Speicher, ungefiltert.\n\nCloud-unterstütztes Scannen und App-Scannen werden in diesem Modus nicht verwendet.';

  @override
  String get scanComplete => 'Scan abgeschlossen';

  @override
  String pillSuspiciousCount(Object count) {
    return 'Verdächtig: $count';
  }

  @override
  String pillCleanCount(Object count) {
    return 'Sauber: $count';
  }

  @override
  String pillScannedCount(Object count) {
    return 'Gescannt: $count';
  }

  @override
  String get resultNoThreatsTitle => 'Keine Bedrohungen erkannt';

  @override
  String get resultNoThreatsBody =>
      'In den gescannten Elementen wurden keine Bedrohungen erkannt.';

  @override
  String get resultSuspiciousAppsTitle => 'Verdächtige Apps';

  @override
  String get resultSuspiciousItemsTitle => 'Verdächtige Elemente';

  @override
  String get returnHome => 'Zurück zur Startseite';

  @override
  String get emptyTitle => 'Keine anfälligen Dateien zum Scannen';

  @override
  String get emptyBody =>
      'Dein Gerät enthielt keine Dateien, die den Scan-Kriterien entsprechen.';

  @override
  String get knownMalware => 'Bekannte Malware';

  @override
  String get suspiciousActivityDetected => 'Verdächtige Aktivität erkannt';

  @override
  String get maliciousActivityDetected => 'Bösartige Aktivität erkannt';

  @override
  String get androidBankingTrojan => 'Android-Banking-Trojaner';

  @override
  String get androidSpyware => 'Android-Spyware';

  @override
  String get androidAdware => 'Android-Adware';

  @override
  String get androidSmsFraud => 'Android-SMS-Betrug';

  @override
  String get threatLevelConfirmed => 'Bestätigt';

  @override
  String get threatLevelHigh => 'Hoch';

  @override
  String get threatLevelMedium => 'Mittel';

  @override
  String threatLevelLabel(Object level) {
    return 'Bedrohungsstufe: $level';
  }

  @override
  String get explainFoundInCloud =>
      'Dieses Element ist in der ColourSwift-Cloud-Bedrohungsdatenbank aufgeführt.';

  @override
  String get explainFoundInOffline =>
      'Dieses Element ist in der Offline-Malware-Datenbank auf deinem Gerät aufgeführt.';

  @override
  String get explainBanker =>
      'Entwickelt, um Finanzzugangsdaten zu stehlen, oft durch Overlays, Keylogging oder Traffic-Abfangen.';

  @override
  String get explainSpyware =>
      'Überwacht Aktivitäten heimlich oder sammelt personenbezogene Daten wie Nachrichten, Standort oder Gerätekennungen.';

  @override
  String get explainAdware =>
      'Zeigt aufdringliche Werbung an, leitet um oder erzeugt betrügerischen Werbeverkehr.';

  @override
  String get explainSmsFraud =>
      'Versucht ohne Zustimmung SMS-Aktionen zu senden oder auszulösen, was unerwartete Kosten verursachen kann.';

  @override
  String get explainGenericMalware =>
      'Es wurden starke Hinweise auf bösartige Absicht erkannt, auch wenn keine benannte Familie passt.';

  @override
  String get explainSuspiciousDefault =>
      'Es wurden Hinweise auf verdächtiges Verhalten erkannt. Das kann Missbrauchsmuster aus Malware umfassen, aber auch ein Fehlalarm sein.';

  @override
  String get singleChoiceScanFile => 'Eine Datei scannen';

  @override
  String get singleChoiceScanInstalledApp => 'Eine installierte App scannen';

  @override
  String get singleChoiceManageExclusions => 'Ausschlüsse verwalten';

  @override
  String get labelKnownMalwareDb => 'In Malware-Datenbank gefunden';

  @override
  String get labelFoundInCloudDb => 'In Cloud-Datenbank gefunden';

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
  String get genericUnknownAppName => 'Unbekannt';

  @override
  String get genericUnknownFileName => 'Unbekannt';

  @override
  String get featuresDrawerTitle => 'Funktionen';

  @override
  String get recommendedSectionTitle => 'Empfohlen';

  @override
  String get featureNetworkProtection => 'Netzwerkschutz';

  @override
  String get featureLinkChecker => 'Link-Prüfer';

  @override
  String get featureMetaPass => 'MetaPass';

  @override
  String get featureCleanerPro => 'Cleaner Pro';

  @override
  String get featureTerminal => 'Terminal';

  @override
  String get featureScheduledScans => 'Geplante Scans';

  @override
  String get networkStatusDisconnected => 'Getrennt';

  @override
  String get networkStatusConnecting => 'Verbindet';

  @override
  String get networkStatusConnected => 'Verbunden';

  @override
  String get networkUsageTitle => 'Nutzung';

  @override
  String get networkUsageEnableVpnToView =>
      'VPN aktivieren, um die Nutzung anzuzeigen.';

  @override
  String get networkUsageUnlimited => 'Unbegrenzt';

  @override
  String networkUsageUsedOf(Object used, Object limit) {
    return '$used / $limit';
  }

  @override
  String networkUsageResetsOn(Object y, Object m, Object d) {
    return 'Wird am $y-$m-$d zurückgesetzt';
  }

  @override
  String networkUsageUpdatedAt(Object hh, Object mm) {
    return 'Aktualisiert $hh:$mm';
  }

  @override
  String get networkCardStatusAvailable => 'Verfügbar';

  @override
  String get networkCardStatusDisabled => 'Deaktiviert';

  @override
  String get networkCardStatusCustom => 'Benutzerdefiniert';

  @override
  String get networkCardStatusReady => 'Bereit';

  @override
  String get networkCardStatusOpen => 'Öffnen';

  @override
  String get networkCardStatusComingSoon => 'Demnächst';

  @override
  String get networkCardBlocklistsTitle => 'Blocklisten';

  @override
  String get networkCardBlocklistsSubtitle => 'Filtersteuerung';

  @override
  String get networkCardUpstreamTitle => 'Upstream';

  @override
  String get networkCardUpstreamSubtitle => 'Resolver-Auswahl';

  @override
  String get networkCardAppsTitle => 'Apps';

  @override
  String get networkCardAppsSubtitle => 'Apps im WLAN blockieren';

  @override
  String get networkCardLogsTitle => 'Protokolle';

  @override
  String get networkCardLogsSubtitle => 'Live-DNS-Ereignisse';

  @override
  String get networkCardSpeedTitle => 'Geschwindigkeit';

  @override
  String get networkCardSpeedSubtitle => 'DNS-Test';

  @override
  String get networkCardAboutTitle => 'Info';

  @override
  String get networkCardAboutSubtitle => 'GitHub';

  @override
  String get networkLogsStatusNoActivity => 'Keine Aktivität';

  @override
  String networkLogsStatusRecent(Object count) {
    return '$count aktuell';
  }

  @override
  String get networkResolverTitle => 'Resolver';

  @override
  String get networkResolverIpLabel => 'Resolver-IP';

  @override
  String get networkResolverIpHint => 'Beispiel: 1.1.1.1';

  @override
  String get networkSpeedTestTitle => 'Geschwindigkeitstest';

  @override
  String get networkSpeedTestBody =>
      'Führt einen DNS-Geschwindigkeitstest mit deinen aktuellen Einstellungen aus.';

  @override
  String get networkSpeedTestRun => 'Geschwindigkeitstest starten';

  @override
  String get networkBlocklistsRecommendedTitle => 'Empfohlen';

  @override
  String get networkBlocklistsCsMalwareTitle => 'ColourSwift Malware';

  @override
  String get networkBlocklistsCsAdsTitle => 'ColourSwift Werbung';

  @override
  String get networkBlocklistsSeeGithub => 'Details auf GitHub ansehen...';

  @override
  String get networkBlocklistsMalwareSection => 'Malware';

  @override
  String get networkBlocklistsMalwareTitle => 'Malware-Blockliste';

  @override
  String get networkBlocklistsMalwareSources =>
      'HaGeZi TIF • URLHaus • DigitalSide • Spam404';

  @override
  String get networkBlocklistsAdsSection => 'Werbung';

  @override
  String get networkBlocklistsAdsTitle => 'Werbe-Blockliste';

  @override
  String get networkBlocklistsAdsSources =>
      'OISD • AdAway • Yoyo • AnudeepND • Firebog AdGuard';

  @override
  String get networkBlocklistsTrackersSection => 'Tracker';

  @override
  String get networkBlocklistsTrackersTitle => 'Tracker-Blockliste';

  @override
  String get networkBlocklistsTrackersSources =>
      'EasyPrivacy • Disconnect • Frogeye • Perflyst • WindowsSpyBlocker';

  @override
  String get networkBlocklistsGamblingSection => 'Glücksspiel';

  @override
  String get networkBlocklistsGamblingTitle => 'Glücksspiel-Blockliste';

  @override
  String get networkBlocklistsGamblingSources => 'HaGeZi Gambling';

  @override
  String get networkBlocklistsSocialSection => 'Soziale Medien';

  @override
  String get networkBlocklistsSocialTitle => 'Social-Media-Blockliste';

  @override
  String get networkBlocklistsSocialSources => 'HaGeZi Social';

  @override
  String get networkBlocklistsAdultSection => '18+';

  @override
  String get networkBlocklistsAdultTitle => 'Erwachsenen-Blockliste';

  @override
  String get networkBlocklistsAdultSources => 'StevenBlack 18+ • HaGeZi NSFW';

  @override
  String get networkLiveLogsTitle => 'Live-Protokolle';

  @override
  String get networkLiveLogsEmpty => 'Noch keine Anfragen.';

  @override
  String get networkLiveLogsBlocked => 'Blockiert';

  @override
  String get networkLiveLogsAllowed => 'Erlaubt';

  @override
  String get recommendedMetaPassDesc =>
      'Sichere Offline-Passwörter generieren.';

  @override
  String get recommendedCleanerProDesc =>
      'Findet Duplikate, alte Medien und ungenutzte Apps, um automatisch Speicher freizugeben.';

  @override
  String get recommendedLinkCheckerDesc =>
      'Prüfe verdächtige Links risikofrei mit der sicheren Ansicht.';

  @override
  String get recommendedNetworkProtectionDesc =>
      'Schütze deine Internetverbindung vor Malware.';

  @override
  String get recommendedTerminalDesc => 'Eine erweiterte Funktion für Shizuku';

  @override
  String get recommendedScheduledScansDesc => 'Automatische Hintergrundscans.';

  @override
  String get metaPassTitle => 'MetaPass';

  @override
  String get metaPassHowItWorks => 'So funktioniert MetaPass';

  @override
  String get metaPassOk => 'OK';

  @override
  String get metaPassSettings => 'Einstellungen';

  @override
  String get metaPassPoweredBy => 'unterstützt von VX-TITANIUM';

  @override
  String get metaPassLoading => 'Lädt…';

  @override
  String get metaPassEmptyTitle => 'Noch keine Einträge';

  @override
  String get metaPassEmptyBody =>
      'Füge eine App oder Website hinzu.\nPasswörter werden auf dem Gerät aus deinem geheimen Meta-Passwort generiert.';

  @override
  String get metaPassAddFirstEntry => 'Ersten Eintrag hinzufügen';

  @override
  String get metaPassTapToCopyHint =>
      'Zum Kopieren tippen. Zum Entfernen lange drücken.';

  @override
  String get metaPassCopyTooltip => 'Passwort kopieren';

  @override
  String get metaPassAdd => 'Hinzufügen';

  @override
  String get metaPassPickFromInstalledApps =>
      'Aus installierten Apps auswählen';

  @override
  String get metaPassAddWebsiteOrLabel =>
      'Website oder eigenes Label hinzufügen';

  @override
  String get metaPassSelectApp => 'App auswählen';

  @override
  String get metaPassSearchApps => 'Apps suchen';

  @override
  String get metaPassCancel => 'Abbrechen';

  @override
  String get metaPassContinue => 'Weiter';

  @override
  String get metaPassSave => 'Speichern';

  @override
  String get metaPassAddEntryTitle => 'Eintrag hinzufügen';

  @override
  String get metaPassNameOrUrl => 'Name oder URL';

  @override
  String get metaPassNameOrUrlHint => 'z. B. nextcloud, steam, example.com';

  @override
  String get metaPassVersion => 'Version';

  @override
  String get metaPassLength => 'Länge';

  @override
  String get metaPassSetMetaTitle => 'Meta-Passwort festlegen';

  @override
  String get metaPassSetMetaBody =>
      'Gib dein Meta-Passwort ein. Es verlässt dieses Gerät nie. Alle Tresor-Passwörter hängen davon ab.';

  @override
  String get metaPassMetaLabel => 'Meta-Passwort';

  @override
  String get metaPassRememberThisDevice =>
      'Für dieses Gerät merken, sicher gespeichert';

  @override
  String get metaPassChangingMetaWarning =>
      'Wenn du dies später änderst, ändern sich alle generierten Passwörter. Dasselbe Meta-Passwort stellt sie wieder her.';

  @override
  String get metaPassRemoveEntryTitle => 'Eintrag entfernen';

  @override
  String metaPassRemoveEntryBody(Object label) {
    return '\"$label\" aus deinem Tresor entfernen?';
  }

  @override
  String get metaPassRemove => 'Entfernen';

  @override
  String metaPassPasswordCopied(Object label, Object version, Object length) {
    return 'Passwort für $label kopiert (v$version, $length Zeichen)';
  }

  @override
  String metaPassGenerateFailed(Object error) {
    return 'Passwort konnte nicht generiert werden: $error';
  }

  @override
  String metaPassLoadAppsFailed(Object error) {
    return 'Apps konnten nicht geladen werden: $error';
  }

  @override
  String metaPassChars(Object length) {
    return '$length Zeichen';
  }

  @override
  String metaPassVersionShort(Object version) {
    return 'v$version';
  }

  @override
  String get metaPassInfoBody =>
      'Passwörter werden nie gespeichert.\n\nJeder Eintrag leitet ein Passwort ab aus:\n• deinem Meta-Passwort\n• dem Labelnamen\n• Version und Länge\n\nWenn du die App mit demselben Meta-Passwort und denselben Labels neu installierst, werden dieselben Passwörter wieder erzeugt.';

  @override
  String get passwordSettingsTitle => 'Passworteinstellungen';

  @override
  String get passwordSettingsSectionMetaPass => 'MetaPass';

  @override
  String get passwordSettingsMetaPasswordTitle => 'Meta-Passwort';

  @override
  String get passwordSettingsMetaNotSet => 'Nicht festgelegt';

  @override
  String get passwordSettingsMetaStoredSecurely =>
      'Sicher auf diesem Gerät gespeichert';

  @override
  String get passwordSettingsChange => 'Ändern';

  @override
  String get passwordSettingsSetMetaPassTitle => 'MetaPass festlegen';

  @override
  String get passwordSettingsMetaPasswordLabel => 'Meta-Passwort';

  @override
  String get passwordSettingsChangingAltersAll =>
      'Dies zu ändern verändert alle Passwörter.\nDerselbe MetaPass stellt sie wieder her.';

  @override
  String get passwordSettingsCancel => 'Abbrechen';

  @override
  String get passwordSettingsSave => 'Speichern';

  @override
  String get passwordSettingsSectionRestoreCode => 'Wiederherstellungscode';

  @override
  String get passwordSettingsGenerateRestoreCode =>
      'Wiederherstellungscode generieren';

  @override
  String get passwordSettingsCopy => 'Kopieren';

  @override
  String get passwordSettingsRestoreCodeCopied =>
      'Wiederherstellungscode kopiert';

  @override
  String get passwordSettingsSectionRestoreFromCode =>
      'Aus Code wiederherstellen';

  @override
  String get passwordSettingsRestoreCodeLabel => 'Wiederherstellungscode';

  @override
  String get passwordSettingsRestore => 'Wiederherstellen';

  @override
  String get passwordSettingsVaultRestored => 'Tresor wiederhergestellt';

  @override
  String get passwordSettingsFooterInfo =>
      'Passwörter werden nie gespeichert.\n\nDer Wiederherstellungscode enthält nur Strukturdaten. Zusammen mit deinem MetaPass baut er deinen Tresor neu auf.';

  @override
  String get onboardingAppName => 'AvarionX Security';

  @override
  String get onboardingStorageTitle => 'Speicherzugriff';

  @override
  String get onboardingStorageDesc =>
      'Diese Berechtigung ist erforderlich, um Dateien auf deinem Gerät zu scannen. Du kannst sie jetzt oder später erteilen.';

  @override
  String get onboardingStorageFootnote =>
      'Du kannst dies überspringen, wirst aber erneut gefragt, wenn du einen Scanmodus auswählst.';

  @override
  String get onboardingStorageSnack =>
      'Speicherberechtigung ist zum Scannen erforderlich.';

  @override
  String get onboardingNotificationsTitle => 'Benachrichtigungen';

  @override
  String get onboardingNotificationsDesc =>
      'Wird für Echtzeitwarnungen, Scanstatus und Quarantäne-Updates verwendet.';

  @override
  String get onboardingNotificationsFootnote =>
      'Von Android für Echtzeitschutz erforderlich.';

  @override
  String get onboardingNetworkTitle => 'Netzwerkschutz';

  @override
  String get onboardingNetworkDesc =>
      'Aktiviert WLAN-Schutz über die VPN-Berechtigung von Android.';

  @override
  String get onboardingNetworkFootnote => 'Dies ist optional, aber empfohlen.';

  @override
  String get onboardingGranted => 'Erteilt';

  @override
  String get onboardingNotGranted => 'Nicht erteilt';

  @override
  String get onboardingGrantAccess => 'Zugriff erlauben';

  @override
  String get onboardingAllowNotifications => 'Benachrichtigungen erlauben';

  @override
  String get onboardingAllowVpnAccess => 'VPN-Zugriff erlauben';

  @override
  String get onboardingBack => 'Zurück';

  @override
  String get onboardingNext => 'Weiter';

  @override
  String get onboardingFinish => 'Fertig';

  @override
  String get onboardingSetupCompleteTitle => 'Einrichtung abgeschlossen';

  @override
  String get onboardingSetupCompleteDesc =>
      'Wir empfehlen einen vollständigen Gerätescan (installierte Apps werden derzeit nicht gescannt) oder direkt zur Startseite zu gehen.';

  @override
  String get onboardingRunFullScan => 'Vollständigen Gerätescan starten';

  @override
  String get onboardingGoHome => 'Zur Startseite';

  @override
  String get networkProtectionTitle => 'Netzwerkschutz';

  @override
  String networkStatusConnectedToDns(Object dns) {
    return 'Verbunden mit $dns';
  }

  @override
  String get networkStatusVpnConflictDetail => 'Ein anderes VPN ist aktiv';

  @override
  String get networkStatusOffDetail => 'Netzwerkschutz ist deaktiviert';

  @override
  String get networkModeMalwareTitle => 'Nur Malware-Blockierung';

  @override
  String get networkModeMalwareSubtitle => 'Verwendet 1.1.1.2';

  @override
  String get networkModeMalwareDescription =>
      'Kombiniert die lokale Malware-Datenbank von AvarionX mit der Online-Bedrohungsintelligenz von Cloudflare für maximalen Malware-Schutz.';

  @override
  String get networkModeAdultTitle => 'Malware und Erwachseneninhalte';

  @override
  String get networkModeAdultSubtitle => 'Verwendet 1.1.1.3';

  @override
  String get networkModeAdultDescription =>
      'Verwendet die Offline-Malware-Datenbank von AvarionX und ergänzt Filterung für Erwachseneninhalte. Cloud-basierte Malware-Intelligenz ist in diesem Modus deaktiviert.';

  @override
  String get networkInfoTitle => 'Was ist Netzwerkschutz?';

  @override
  String get networkInfoBody =>
      'Einige Bedrohungen funktionieren, indem sie sich mit bösartigen Servern verbinden oder Internetverkehr umleiten.\nNetzwerkschutz blockiert bekannte gefährliche Domains und gängige Werbung über ein lokales VPN.\n\nAVarionX Security sammelt keine Daten.';

  @override
  String get linkCheckerTitle => 'Link-Prüfer';

  @override
  String get linkCheckerTabAnalyse => 'Analysieren';

  @override
  String get linkCheckerTabView => 'Anzeigen';

  @override
  String get linkCheckerTabHistory => 'Verlauf';

  @override
  String get linkCheckerAnalyseSubtitle =>
      'Seite auf Malware oder verdächtige Inhalte prüfen';

  @override
  String get linkCheckerUrlLabel => 'URL';

  @override
  String get linkCheckerUrlHint => 'https://example.com';

  @override
  String get linkCheckerButtonAnalyse => 'Analysieren';

  @override
  String get linkCheckerButtonChecking => 'Prüft';

  @override
  String get linkCheckerEngineNotReadySnack => 'Engine nicht bereit';

  @override
  String get linkCheckerStatusVerifyingLink => 'Link wird überprüft…';

  @override
  String get linkCheckerStatusScanningPage => 'Seite wird gescannt…';

  @override
  String get linkCheckerBlockedNavigation => 'Navigation blockiert';

  @override
  String get linkCheckerBlockedUnsupportedType => 'Nicht unterstützter Linktyp';

  @override
  String get linkCheckerBlockedInvalidDestination => 'Ungültiges Ziel';

  @override
  String get linkCheckerBlockedUnableResolve =>
      'Ziel kann nicht aufgelöst werden';

  @override
  String get linkCheckerBlockedUnableVerify =>
      'Ziel kann nicht überprüft werden';

  @override
  String get linkCheckerAnalyseCardTitleDefault =>
      'Seite auf verdächtige Inhalte prüfen';

  @override
  String get linkCheckerAnalyseCardDetailDefault =>
      'Füge eine URL ein und starte eine Analyse.';

  @override
  String get linkCheckerAnalyseCardTitleEngineNotReady => 'Engine nicht bereit';

  @override
  String get linkCheckerAnalyseCardDetailEngineNotReady => 'Fehler 1001.';

  @override
  String get linkCheckerAnalyseCardTitleChecking => 'Prüft';

  @override
  String get linkCheckerVerdictClean => 'Sauber';

  @override
  String get linkCheckerVerdictCleanDetail =>
      'Diese Seite scheint sicher zu sein.';

  @override
  String get linkCheckerVerdictSuspicious => 'Verdächtig';

  @override
  String get linkCheckerVerdictSuspiciousDetail =>
      'Diese Seite enthält verdächtige Inhalte.';

  @override
  String get linkCheckerViewLockedBody =>
      'Führe zuerst eine Analyse aus, um die Ansicht zu aktivieren.';

  @override
  String get linkCheckerViewSubtitle => 'Webseite sicher anzeigen';

  @override
  String get linkCheckerViewPage => 'Seite anzeigen';

  @override
  String get linkCheckerClose => 'Schließen';

  @override
  String get linkCheckerBlockedBody =>
      'Diese Seite wurde gestoppt, bevor sie geladen werden konnte.';

  @override
  String get linkCheckerSuspiciousBanner =>
      'Verdächtiger Link, wird möglicherweise nicht angezeigt, wenn blockierte Inhalte erforderlich sind.';

  @override
  String get linkCheckerHistorySubtitle =>
      'Tippe auf einen Eintrag, um den Link zu kopieren.';

  @override
  String get linkCheckerHistoryEmpty => 'Noch keine Prüfungen.';

  @override
  String get linkCheckerCopied => 'Kopiert';

  @override
  String get settingsSectionAppearance => 'Darstellung';

  @override
  String get settingsTheme => 'Design';

  @override
  String settingsThemeCurrent(Object theme) {
    return 'Aktuell: $theme';
  }

  @override
  String get settingsLanguage => 'Sprache';

  @override
  String settingsLanguageCurrent(Object language) {
    return 'Aktuell: $language';
  }

  @override
  String get settingsChooseLanguage => 'Sprache auswählen';

  @override
  String get settingsLanguageApplied => 'Sprache angewendet';

  @override
  String get settingsSystemDefault => 'Systemstandard';

  @override
  String get settingsSectionCommunity => 'Tritt der Community bei!';

  @override
  String get settingsDiscord => 'Discord';

  @override
  String get settingsDiscordSubtitle => 'Chat, Updates und Feedback';

  @override
  String get settingsDiscordOpenFail =>
      'Discord-Link konnte nicht geöffnet werden';

  @override
  String get settingsSectionPro => 'PRO-Funktionen';

  @override
  String get settingsProCustomization => 'PRO-Anpassung';

  @override
  String get settingsProSubtitle =>
      'Werbefrei nutzen, unbegrenztes DNS, Designs und Symbole freischalten';

  @override
  String get settingsUnlockPro => 'Premium freischalten';

  @override
  String get settingsProUnlocked => 'PRO-Modus freigeschaltet';

  @override
  String get settingsPurchaseNotConfirmed => 'Kauf nicht bestätigt';

  @override
  String settingsPurchaseFailed(Object error) {
    return 'Kauf fehlgeschlagen: $error';
  }

  @override
  String get homeUpgrade => 'Upgrade';

  @override
  String get homeFeatureSecureVpnTitle => 'AvarionX Secure VPN';

  @override
  String get homeFeatureSecureVpnDesc =>
      'Verbirg deine IP und blockiere unerwünschte Werbung';

  @override
  String get proActivated => 'PRO aktiviert';

  @override
  String get proDeactivated => 'PRO deaktiviert';

  @override
  String get settingsProReset => 'PRO zurückgesetzt (nur Debug)';

  @override
  String get settingsProSheetTitle => 'PRO-Anpassung';

  @override
  String get settingsHideGoldHeader =>
      'Goldenen Header auf der Startseite anzeigen (dunkle Designs)';

  @override
  String get settingsAppIcon => 'App-Symbol';

  @override
  String settingsIconSelected(Object icon) {
    return 'Symbol ausgewählt: $icon';
  }

  @override
  String get vpnSignInRequiredTitle => 'Anmeldung erforderlich';

  @override
  String get vpnClose => 'Schließen';

  @override
  String get vpnSignInRequiredBody =>
      'Melde dich an, um Secure VPN zu verwenden.';

  @override
  String get vpnCancel => 'Abbrechen';

  @override
  String get vpnSignIn => 'Anmelden';

  @override
  String get vpnUsageLoading => 'Nutzung wird geladen...';

  @override
  String get vpnUsageNoLimits => 'Keine Datenlimits';

  @override
  String get vpnUsageSyncing => 'Synchronisiert';

  @override
  String vpnUsageUsedThisMonth(Object used) {
    return '$used diesen Monat verwendet';
  }

  @override
  String get vpnUsageDataTitle => 'Datennutzung';

  @override
  String get vpnUsageUnavailable => 'Nutzung nicht verfügbar';

  @override
  String get vpnStatusConnectingEllipsis => 'Verbindet...';

  @override
  String vpnStatusConnectedTo(Object country) {
    return 'Verbunden mit $country';
  }

  @override
  String get vpnTitleSecure => 'Secure VPN';

  @override
  String get vpnStatusConnected => 'Verbunden';

  @override
  String get vpnSubtitleEstablishingTunnel => 'Tunnel wird aufgebaut...';

  @override
  String get vpnSubtitleFindingLocation => 'Standort wird gesucht...';

  @override
  String get vpnStatusProtected => 'Geschützt';

  @override
  String get vpnStatusNotConnected => 'Nicht verbunden';

  @override
  String get vpnConnect => 'Verbinden';

  @override
  String get vpnDisconnect => 'Trennen';

  @override
  String vpnIpLabel(Object ip) {
    return 'IP: $ip';
  }

  @override
  String vpnServerLoadLabel(Object current, Object max) {
    return '$current/$max';
  }

  @override
  String get vpnBlocklistsTitle => 'Secure VPN Blocklisten';

  @override
  String get vpnSave => 'Speichern';

  @override
  String get settingsSave => 'Speichern';

  @override
  String get settingsPremium => 'Premium';

  @override
  String get settingsUltimateSecurity => 'Ultimativer Schutz';

  @override
  String get settingsSwitchPlan => 'Plan wechseln';

  @override
  String get settingsBestValue => 'Bester Wert';

  @override
  String get settingsOneTime => 'Einmalig';

  @override
  String get settingsPlanPriceLoading => 'Preis wird geladen...';

  @override
  String get settingsMonthly => 'Monatlich';

  @override
  String get settingsYearly => 'Jährlich';

  @override
  String get settingsLifetime => 'Lebenslang';

  @override
  String get settingsSubscribeMonthly => 'Monatlich abonnieren';

  @override
  String get settingsSubscribeYearly => 'Jährlich abonnieren';

  @override
  String get settingsUnlockLifetime => 'Lebenslang freischalten';

  @override
  String get settingsProBenefitsTitle => 'Vorteile';

  @override
  String get settingsUnlimitedDnsTitle => 'Unbegrenzte DNS-Abfragen';

  @override
  String get settingsUnlimitedDnsBody =>
      'Entfernt Abfragelimits und schaltet vollständige Cloud-Filterung frei.';

  @override
  String get settingsThemesTitle => 'Designs';

  @override
  String get settingsThemesBody =>
      'Premium-Designs und Anpassung freischalten.';

  @override
  String get settingsIconCustomizationTitle => 'App-Symbol-Anpassung';

  @override
  String get settingsIconCustomizationBody =>
      'Ändere das App-Symbol passend zu deinem Stil.';

  @override
  String get settingsScheduledScansTitle => 'Geplante Scans';

  @override
  String get settingsScheduledScansBody =>
      'Erweiterte Planung und Scan-Anpassung freischalten.';

  @override
  String get settingsProFinePrint =>
      'Abonnements verlängern sich, sofern sie nicht gekündigt werden. Du kannst sie jederzeit in Google Play verwalten oder kündigen. Lifetime ist ein einmaliger Kauf.';

  @override
  String get settingsSectionShizuku => 'Erweiterter Schutz (Shizuku)';

  @override
  String get settingsEnableShizuku => 'Shizuku aktivieren';

  @override
  String get settingsShizukuRequiresManager => 'Externer Manager erforderlich';

  @override
  String get settingsShizukuNotRunning => 'Shizuku-Dienst läuft nicht';

  @override
  String get settingsShizukuPermissionRequired => 'Berechtigung erforderlich';

  @override
  String get settingsShizukuAvailable => 'Erweiterter Systemzugriff verfügbar';

  @override
  String get settingsAboutAdvancedProtection => 'Über erweiterten Schutz';

  @override
  String get settingsAboutAdvancedProtectionSubtitle =>
      'Erfahre, wie erweiterter Schutz funktioniert';

  @override
  String get settingsAdvancedProtectionDialogTitle =>
      'Erweiterter Systemschutz';

  @override
  String get settingsAdvancedProtectionDialogBody =>
      'Shizuku-Zugriff erfordert einen externen Manager für fortgeschrittene Nutzer.\n\nDiese Funktion ist optional und für normalen Schutz nicht empfohlen.';

  @override
  String get settingsAboutShizukuTitle => 'Über Shizuku';

  @override
  String get settingsAboutShizukuBody =>
      'AVarionX kann sich mit Shizuku integrieren, um auf App-Prozesse auf Systemebene zuzugreifen.\n\nDadurch kann die App:\n• Malware erkennen, die sich vor normalen Scannern versteckt\n• laufende App-Prozesse prüfen\n• die meiste aktive Malware deaktivieren oder eindämmen\n\nShizuku gewährt jedoch keinen Root-Zugriff.\n\nDiese Funktion ist für fortgeschrittene Nutzer gedacht und für normalen Schutz nicht erforderlich.\n\nDokumentation:\nhttps://shizuku.rikka.app';

  @override
  String get settingsSectionGeneral => 'Allgemein';

  @override
  String get settingsExclusions => 'Ausschlüsse';

  @override
  String get settingsExclusionsSubtitle =>
      'Ausschlüsse verwalten und hinzufügen';

  @override
  String get settingsExcludeFolder => 'Ordner ausschließen';

  @override
  String get settingsExcludeFile => 'Datei ausschließen';

  @override
  String get settingsManageExclusions => 'Bestehende Ausschlüsse verwalten';

  @override
  String get settingsManageExclusionsSubtitle =>
      'Ausschlüsse anzeigen oder entfernen';

  @override
  String get settingsFolderExcluded => 'Ordner ausgeschlossen';

  @override
  String get settingsFileExcluded => 'Datei ausgeschlossen';

  @override
  String get settingsPrivacyPolicy => 'Datenschutzerklärung';

  @override
  String get settingsPrivacyPolicySubtitle =>
      'Ansehen, wie deine Daten verarbeitet werden';

  @override
  String get settingsPrivacyPolicyOpenFail =>
      'Datenschutzerklärung konnte nicht geöffnet werden';

  @override
  String get settingsAboutApp => 'Über AVarionX';

  @override
  String get settingsHowThisAppWorks => 'Wie diese App funktioniert';

  @override
  String get settingsHowThisAppWorksSubtitle => 'Mehr über Schutz erfahren';

  @override
  String get settingsThemePickerTitle => 'Design auswählen';

  @override
  String get settingsThemeRequiresPro =>
      'Dieses Design erfordert den PRO-Modus';

  @override
  String get scheduledScansTitle => 'Geplante Scans';

  @override
  String get scheduledScansInfoTitle => 'Geplante Scans';

  @override
  String get scheduledScansInfoBody =>
      'Während RTP sich auf heruntergeladene Malware konzentriert, starten geplante Scans automatisch deinen gewählten Scanmodus im Hintergrund.\nDies läuft nur, während RTP aktiviert ist.\n\nPRO-Nutzer können Scanmodus und Häufigkeit anpassen.';

  @override
  String get scheduledScansHeader => 'Automatische Hintergrundscans';

  @override
  String get scheduledScansSubheader =>
      'Während RTP aktiv ist, scannt die App dein Gerät basierend auf dem ausgewählten Scanmodus und der Häufigkeit.';

  @override
  String get proRequiredToCustomize => 'PRO zum Anpassen erforderlich';

  @override
  String get scheduledScansEnabledTitle => 'Aktiviert';

  @override
  String get scheduledScansEnabledSubtitle =>
      'Wenn aktiviert, läuft ein Scan automatisch nach deinem gewählten Zeitplan.';

  @override
  String get scheduledScansModeTitle => 'Scanmodus';

  @override
  String scheduledScansModeHint(Object mode) {
    return 'Aktueller Modus: $mode';
  }

  @override
  String get scheduledScansFrequencyTitle => 'Häufigkeit';

  @override
  String scheduledScansFrequencyHint(Object freq) {
    return 'Läuft: $freq';
  }

  @override
  String get scheduledEveryDay => 'Jeden Tag';

  @override
  String get scheduledEvery3Days => 'Alle 3 Tage';

  @override
  String get scheduledEveryWeek => 'Jede Woche';

  @override
  String get scheduledEvery2Weeks => 'Alle 2 Wochen';

  @override
  String get scheduledEvery3Weeks => 'Alle 3 Wochen';

  @override
  String get scheduledMonthly => 'Monatlich';

  @override
  String scheduledEveryDays(Object days) {
    return 'Alle $days Tage';
  }

  @override
  String scheduledEveryHours(Object hours) {
    return 'Alle $hours Stunden';
  }

  @override
  String get vpnSettingsPrivacySecurityTitle => 'Datenschutz und Sicherheit';

  @override
  String get vpnSettingsNoLogsPolicyTitle =>
      'Richtlinie ohne gespeicherte Protokolle';

  @override
  String get vpnSettingsNoLogsPolicyBody =>
      'Es werden keine Protokolle gespeichert. Verbindungsaktivität, Surfaktivität, DNS-Abfragen und Traffic-Inhalte werden nicht aufgezeichnet oder gespeichert.';

  @override
  String get vpnSettingsNoActivityLogsTitle => 'Keine Aktivitätsprotokolle';

  @override
  String get vpnSettingsNoActivityLogsBody =>
      'Deine Aktivität wird bei der Nutzung von Secure VPN nicht überwacht oder verfolgt.';

  @override
  String get vpnSettingsWireGuardTitle => 'VX-Link powered by WireGuard';

  @override
  String get vpnSettingsWireGuardBody =>
      'Secure VPN verwendet das WireGuard-Protokoll über VX-Link für schnelle, moderne Verschlüsselung.';

  @override
  String get vpnSettingsMalwareProtectionTitle => 'Malware-Schutz aktiviert';

  @override
  String get vpnSettingsMalwareProtectionBody =>
      'Bösartige Domains werden während der Verbindung standardmäßig blockiert.';

  @override
  String get vpnSettingsAdTrackerProtectionTitle =>
      'Optionaler Werbe- und Trackerschutz';

  @override
  String get vpnSettingsAdTrackerProtectionBody =>
      'Aktiviere zusätzliche Blockierung für Werbung und Tracker im Anpassungs-Tab.';

  @override
  String get vpnSettingsBrandFooter => 'Gesichert durch VX-Link';

  @override
  String get vpnSettingsAccountTitle => 'Konto';

  @override
  String get vpnSettingsSignInToContinue => 'Zum Fortfahren anmelden';

  @override
  String get vpnSettingsAccountSyncBody =>
      'Dein Plan und deine Datennutzung werden mit deinem Konto synchronisiert.';

  @override
  String get vpnSettingsSignedIn => 'Angemeldet';

  @override
  String get vpnSettingsPlanUnknown => 'Plan: unbekannt';

  @override
  String vpnSettingsPlanLabel(Object plan) {
    return 'Plan: $plan';
  }

  @override
  String get vpnSettingsRefresh => 'Aktualisieren';

  @override
  String get vpnSettingsSignOut => 'Abmelden';

  @override
  String get scheduledChargingOnlyTitle => 'Nur beim Laden';

  @override
  String get scheduledChargingOnlySubtitle =>
      'Geplanten Scan nur ausführen, wenn das Gerät angeschlossen ist.';

  @override
  String get scheduledPreferredTimeTitle => 'Bevorzugte Zeit';

  @override
  String get scheduledPreferredTimeSubtitle =>
      'AVarionX versucht, ungefähr zu dieser Zeit zu starten. Android kann es zum Akkusparen verzögern.';

  @override
  String get scheduledPickTime => 'Zeit auswählen';

  @override
  String get cleanerTitle => 'Cleaner Pro';

  @override
  String get cleanerReadyToScan => 'Bereit zum Scannen';

  @override
  String get cleanerScan => 'Scannen';

  @override
  String get cleanerScanning => 'Scannt…';

  @override
  String get cleanerReady => 'Bereit';

  @override
  String get cleanerStatusReady => 'Bereit';

  @override
  String get cleanerStatusStarting => 'Startet…';

  @override
  String get cleanerStatusFilesScanned => 'Dateien gescannt';

  @override
  String get cleanerStatusFindingUnusedApps => 'Sucht ungenutzte Apps…';

  @override
  String get cleanerStatusComplete => 'Abgeschlossen';

  @override
  String get cleanerStatusScanError => 'Scanfehler';

  @override
  String get cleanerStatusScanningApps => 'Apps werden gescannt…';

  @override
  String get cleanerGrantUsageAccessTitle => 'Nutzungszugriff gewähren';

  @override
  String get cleanerGrantUsageAccessBody =>
      'Um ungenutzte Apps zu erkennen, benötigt dieser Cleaner die Berechtigung Nutzungszugriff. Du wirst zu den Systemeinstellungen weitergeleitet, um sie zu aktivieren.';

  @override
  String get cleanerCancel => 'Abbrechen';

  @override
  String get cleanerContinue => 'Weiter';

  @override
  String get cleanerDuplicates => 'Duplikate';

  @override
  String get cleanerDuplicatesNone => 'Keine Duplikate gefunden';

  @override
  String cleanerDuplicatesSubtitle(Object count, Object size) {
    return '$count Elemente • $size freigeben';
  }

  @override
  String get cleanerOldPhotos => 'Alte Fotos';

  @override
  String cleanerOldPhotosNone(Object days) {
    return 'Keine Fotos älter als $days Tage';
  }

  @override
  String cleanerOldPhotosSubtitle(Object count, Object size) {
    return '$count Elemente • $size';
  }

  @override
  String get cleanerOldVideos => 'Alte Videos';

  @override
  String cleanerOldVideosNone(Object days) {
    return 'Keine Videos älter als $days Tage';
  }

  @override
  String cleanerOldVideosSubtitle(Object count, Object size) {
    return '$count Elemente • $size';
  }

  @override
  String get cleanerLargeFiles => 'Große Dateien';

  @override
  String cleanerLargeFilesNone(Object size) {
    return 'Keine Dateien ≥ $size';
  }

  @override
  String cleanerLargeFilesSubtitle(Object count, Object sizeTotal) {
    return '$count Elemente • $sizeTotal';
  }

  @override
  String get cleanerUnusedApps => 'Ungenutzte Apps';

  @override
  String cleanerUnusedAppsNone(Object days) {
    return 'Keine ungenutzten Apps (letzte $days Tage)';
  }

  @override
  String cleanerUnusedAppsCount(Object count) {
    return '$count Apps';
  }

  @override
  String get cleanerStageDuplicates => 'Duplikate werden gescannt…';

  @override
  String get cleanerStageDuplicatesGrouping => 'Duplikate werden gruppiert…';

  @override
  String get cleanerStageOldPhotos => 'Alte Fotos werden gescannt…';

  @override
  String get cleanerStageOldVideos => 'Alte Videos werden gescannt…';

  @override
  String get cleanerStageLargeFiles => 'Große Dateien werden gescannt…';

  @override
  String cleanerStageOldPhotosProgress(Object count, Object size) {
    return 'Alte Fotos: $count • $size';
  }

  @override
  String get vpnAccountScreenTitle => 'Konto';

  @override
  String get vpnAccountSignInRequiredTitle => 'Anmeldung erforderlich';

  @override
  String get vpnAccountSignInManageUsageBody =>
      'Melde dich an, um dein Konto und deine Nutzung zu verwalten.';

  @override
  String get vpnAccountNotSignedIn => 'Nicht angemeldet';

  @override
  String get vpnAccountFree => 'Kostenlos';

  @override
  String get vpnAccountUnknown => 'Unbekannt';

  @override
  String get vpnAccountStatusSyncing => 'Synchronisiert';

  @override
  String get vpnAccountStatusActive => 'Aktiv';

  @override
  String get vpnAccountStatusConnected => 'Verbunden';

  @override
  String get vpnAccountStatusDisconnected => 'Getrennt';

  @override
  String get vpnAccountStatusUnavailable => 'Nicht verfügbar';

  @override
  String get vpnAccountStatusConnectedNow => 'Jetzt verbunden';

  @override
  String get vpnAccountStatusRefreshToLoadServer =>
      'Aktualisieren, um Serverstatus zu laden';

  @override
  String get vpnAccountUsageTitle => 'Nutzung';

  @override
  String get vpnAccountUsageLoading => 'Nutzung wird geladen...';

  @override
  String get vpnAccountUsageSignInToSync =>
      'Anmelden, um Nutzung zu synchronisieren';

  @override
  String get vpnAccountUsagePullToRefresh =>
      'Zum Aktualisieren ziehen, um Nutzung zu synchronisieren';

  @override
  String get vpnAccountUsageUnlimited => 'Unbegrenzt';

  @override
  String vpnAccountUsageUsedThisMonth(Object used) {
    return '$used diesen Monat verwendet';
  }

  @override
  String vpnAccountUsageUsedThisMonthUnlimited(Object used) {
    return '$used diesen Monat verwendet, unbegrenzt';
  }

  @override
  String vpnAccountUsageUsedOfLimit(Object used, Object limit) {
    return '$used / $limit';
  }

  @override
  String get settingsSectionAccount => 'Konto';

  @override
  String get settingsAccountTitle => 'Konto';

  @override
  String get settingsAccountSubtitle =>
      'Anmeldung, Plan, Abonnement und Kontonutzung';

  @override
  String get exploreSecureVpnTitle => 'Secure VPN';

  @override
  String get exploreSecureVpnSubtitle =>
      'Verbirg deine IP und blockiere unerwünschte Inhalte';

  @override
  String get vpnAccountServerLoadTitle => 'Auslastung des ausgewählten Servers';

  @override
  String vpnAccountServerConnectedCount(Object connected, Object cap) {
    return '$connected/$cap';
  }

  @override
  String get networkDnsOffTitle => 'Zu DNS-Filterung wechseln?';

  @override
  String get networkDnsOffInfoTitle => 'Was ist DNS-Filterung?';

  @override
  String get networkDnsOffInfoBody1 =>
      'DNS-Filterung ist getrennt von Secure VPN. Sie kann bekannte Malware, Werbung in Apps, Tracker und unerwünschte Kategorien blockieren, bevor sie geladen werden.';

  @override
  String get networkDnsOffInfoBody2 =>
      'Sie verschlüsselt deinen Traffic nicht und verbirgt deine IP nicht.';

  @override
  String get networkDnsOffEnableButton => 'DNS-Filterung aktivieren';

  @override
  String vpnAccountServerConnectedCountWithLabel(Object connected, Object cap) {
    return '$connected/$cap verbunden';
  }

  @override
  String get vpnAccountIdentityFallbackTitle => 'Konto';

  @override
  String get vpnAccountMembershipLabel => 'Mitgliedschaft';

  @override
  String get vpnAccountMembershipFounderVpnPro => 'Founders · VPN Pro';

  @override
  String get vpnAccountMembershipFounder => 'Founder';

  @override
  String get vpnAccountMembershipPro => 'Pro';

  @override
  String get vpnAccountSectionAccountStatus => 'Kontostatus';

  @override
  String get vpnAccountSectionActions => 'Aktionen';

  @override
  String get vpnAccountKvStatus => 'Status';

  @override
  String get vpnAccountKvPlan => 'Plan';

  @override
  String get vpnAccountKvUsage => 'Nutzung';

  @override
  String get vpnAccountKvSelectedServer => 'Ausgewählter Server';

  @override
  String get vpnAccountKvConnectionState => 'Verbindungsstatus';

  @override
  String get vpnAccountActionRefresh => 'Aktualisieren';

  @override
  String get vpnAccountActionOpen => 'Öffnen';

  @override
  String get vpnAccountFounderThanks =>
      'Danke für deine Unterstützung von ColourSwift';

  @override
  String get vpnAccountFounderNote =>
      'Ich bin nur ein einzelner Entwickler, getragen von der besten Community.';

  @override
  String cleanerStageOldVideosProgress(Object count, Object size) {
    return 'Alte Videos: $count • $size';
  }

  @override
  String cleanerStageLargeFilesProgress(Object count, Object size) {
    return 'Große Dateien: $count • $size';
  }

  @override
  String get unusedAppsTitle => 'Ungenutzte Apps';

  @override
  String unusedAppsEmpty(Object days) {
    return 'Keine ungenutzten Apps in den letzten $days Tagen';
  }

  @override
  String get quarantineTitle => 'Entfernt';

  @override
  String get quarantineSelectAll => 'Alle auswählen';

  @override
  String get quarantineRefresh => 'Aktualisieren';

  @override
  String get quarantineEmptyTitle => 'Keine entfernten Dateien';

  @override
  String get quarantineEmptyBody =>
      'Alles, was du entfernst, wird hier angezeigt.';

  @override
  String get quarantineRestore => 'Wiederherstellen';

  @override
  String get quarantineDelete => 'Löschen';

  @override
  String get quarantineSnackRestored => 'Wiederhergestellt';

  @override
  String get quarantineSnackDeleted => 'Gelöscht';

  @override
  String get quarantineDeleteDialogTitle => 'Ausgewählte Dateien löschen?';

  @override
  String quarantineDeleteDialogBody(Object count, String plural) {
    String _temp0 = intl.Intl.selectLogic(
      plural,
      {
        's': '',
        'other': '',
      },
    );
    return 'Dauerhaft zu löschende Elemente: $count.$_temp0';
  }

  @override
  String get howThisAppWorksHowAvarionXWorks => 'So funktioniert AvarionX';

  @override
  String get howThisAppWorksAvarionxIsAMobileSecurityAppThat =>
      'AvarionX ist eine mobile Sicherheits-App, die Virenscans auf dem Gerät, Netzwerkschutz und optionale VPN-Funktionen kombiniert. ';

  @override
  String get howThisAppWorksTheAntivirusEngineIsPoweredByVX =>
      'Die Antivirus-Engine wird von VX-Titanium betrieben.';

  @override
  String get howThisAppWorksIfYouUseNetworkProtectionOrVPN =>
      'Wenn du Netzwerkschutz- oder VPN-Funktionen verwendest, verbindet sich die App mit ColourSwift-Diensten, um deine Einstellungen anzuwenden, deinen Kontozugriff zu verwalten und geschützten Datenverkehr zu leiten.';

  @override
  String get howThisAppWorksKeyFeatures => 'Hauptfunktionen';

  @override
  String get howThisAppWorksRealTimeProtectionForDownloadedThreats =>
      '• Echtzeitschutz vor heruntergeladenen Bedrohungen';

  @override
  String get howThisAppWorksNetworkProtectionWithDNSFiltering =>
      '• Netzwerkschutz mit DNS-Filterung';

  @override
  String get howThisAppWorksOptionalSecureVPNMode =>
      '• Optionaler Secure-VPN-Modus';

  @override
  String get howThisAppWorksBuiltInToolsSuchAsLinkChecker =>
      '• Integrierte Tools wie Link Checker';

  @override
  String get howThisAppWorksNotes => 'Hinweise';

  @override
  String get howThisAppWorksSomeFeaturesMayRequireSignInAn =>
      'Einige Funktionen erfordern möglicherweise eine Anmeldung, einen aktiven Tarif oder Geräteberechtigungen, um ordnungsgemäß zu funktionieren.';

  @override
  String get apkAnalyserCopyCurrentReport => 'Aktuellen Bericht kopieren';

  @override
  String get apkAnalyserReportCopiedToClipboard =>
      'Bericht in die Zwischenablage kopiert';

  @override
  String get apkAnalyserExportCurrentAsPDF =>
      'Aktuellen Bericht als PDF exportieren';

  @override
  String get apkAnalyserFailedToExportPDF =>
      'PDF konnte nicht exportiert werden';

  @override
  String get apkAnalyserExportCurrentAsCSV =>
      'Aktuellen Bericht als CSV exportieren';

  @override
  String get apkAnalyserFailedToExportCSV =>
      'CSV konnte nicht exportiert werden';

  @override
  String get apkAnalyserViewSavedReports => 'Gespeicherte Berichte anzeigen';

  @override
  String get apkAnalyserClearHistory => 'Verlauf löschen';

  @override
  String get apkAnalyserReportHistoryCleared => 'Berichtsverlauf gelöscht';

  @override
  String get apkAnalyserSavedReports => 'Gespeicherte Berichte';

  @override
  String get apkAnalyserNoSavedReportsFound =>
      'Keine gespeicherten Berichte gefunden.';

  @override
  String get apkAnalyserChooseTarget => 'Ziel auswählen';

  @override
  String get apkAnalyserSelectASourceToAnalyseWithVTTI =>
      'Wähle eine Quelle zur Analyse mit VTTI Cloud aus.';

  @override
  String get apkAnalyserApkFile => 'APK-Datei';

  @override
  String get apkAnalyserPickAnApkFromStorage =>
      'Eine .apk-Datei aus dem Speicher auswählen';

  @override
  String get apkAnalyserInstalledApp => 'Installierte App';

  @override
  String get apkAnalyserChooseFromAppsOnThisDevice =>
      'Aus den Apps auf diesem Gerät auswählen';

  @override
  String apkAnalyserAnalysingIn(Object countdown) {
    return 'Analyse in $countdown...';
  }

  @override
  String get apkAnalyserStartingAnalysis => 'Analyse wird gestartet...';

  @override
  String get apkAnalyserApkFileOrInstalledApp =>
      'APK-Datei oder installierte App';

  @override
  String get apkAnalyserDeepAnalysisMode => 'Tiefenanalyse-Modus';

  @override
  String get apkAnalyserAMoreComplexAnalysisUsingGlobalData =>
      'Eine komplexere Analyse mit globalen Datenquellen';

  @override
  String get apkAnalyserRequiresProToUnlockDeeperAnalysis =>
      'Pro ist erforderlich, um die tiefere Analyse freizuschalten';

  @override
  String get apkAnalyserApkAnalyser => 'APK-Analyse';

  @override
  String get apkAnalyserPleaseSignInViaSettingsToEnable =>
      'Bitte melde dich über die Einstellungen an, um Cloud Analysis zu aktivieren.';

  @override
  String get apkAnalyserAdvancedOPTIONS => 'ERWEITERTE OPTIONEN';

  @override
  String apkAnalyserDailyLimit(Object remaining, Object limit) {
    return 'Tageslimit: $remaining / $limit';
  }

  @override
  String get apkAnalyserDailyLimitDataUnavailable =>
      'Daten zum Tageslimit nicht verfügbar';

  @override
  String get apkAnalyserPoweredByVTTICloud => 'Unterstützt von VTTI Cloud';

  @override
  String get apkAnalyserSearchApps => 'Apps suchen...';

  @override
  String get apkAnalyserFailedToLoadApps =>
      'Apps konnten nicht geladen werden.';

  @override
  String get apkAnalyserNoAppsFound => 'Keine Apps gefunden.';

  @override
  String get apkReportSummary => 'Zusammenfassung';

  @override
  String get apkReportPermissions => 'Berechtigungen';

  @override
  String get apkReportExtraFlags => 'Zusätzliche Flags';

  @override
  String get apkReportRiskSignals => 'Risikosignale';

  @override
  String get apkReportSources => 'Quellen';

  @override
  String get apkReportMetadata => 'Metadaten';

  @override
  String get apkReportCopyReport => 'Bericht kopieren';

  @override
  String get apkReportReportCopiedToClipboard =>
      'Bericht in die Zwischenablage kopiert';

  @override
  String get apkReportExportAsPDF => 'Als PDF exportieren';

  @override
  String get apkReportFailedToExportPDF => 'PDF konnte nicht exportiert werden';

  @override
  String get apkReportExportAsCSV => 'Als CSV exportieren';

  @override
  String get apkReportFailedToExportCSV => 'CSV konnte nicht exportiert werden';

  @override
  String get apkReportAnalysisReport => 'Analysebericht';

  @override
  String get apkReportMalwareRisk => 'Malware-Risiko';

  @override
  String get apkReportNoSummaryGenerated => 'Keine Zusammenfassung erstellt.';

  @override
  String get apkReportNoRequestedPermissionsExtracted =>
      'Keine angeforderten Berechtigungen extrahiert.';

  @override
  String get apkReportContributing => 'Verstärkend';

  @override
  String get apkReportDampening => 'Abschwächend';

  @override
  String get bootOptimisingYourProtection => 'Schutz wird optimiert';

  @override
  String get exclusionsFolders => 'Ordner';

  @override
  String get exclusionsNone => 'Keine';

  @override
  String get exclusionsFiles => 'Dateien';

  @override
  String get exploreApkAnalyser => 'APK-Analyse';

  @override
  String get exploreCreateADetailedAnalysisOnAnyAPK =>
      'Erstelle eine detaillierte Analyse für jede APK';

  @override
  String get featuresComingSoon => 'Demnächst';

  @override
  String get featuresWantToLearnMore => 'Möchtest du mehr erfahren?';

  @override
  String get homeDrawerApkAnalyser => 'APK-Analyse';

  @override
  String get homeDrawerAdvanced => 'Erweitert';

  @override
  String get homeDrawerQuarantine => 'Quarantäne';

  @override
  String get homeDrawerUpgradeToPro => 'Auf Pro upgraden';

  @override
  String get homeDrawerAvarionxVPN => 'AvarionX VPN';

  @override
  String get homeDrawerProtectYourInternetWithOurUnlimitedVPN =>
      'Schütze deine Internetverbindung mit unserem unbegrenzten VPN';

  @override
  String get deviceSecurityDeviceSecurity => 'Gerätesicherheit';

  @override
  String get deviceSecurityDeviceHealthStatus => 'Gerätesicherheitsstatus';

  @override
  String get deviceSecurityDeviceSecurityRecommendations =>
      'Empfehlungen zur Gerätesicherheit';

  @override
  String get deviceSecurityStopIgnoring => 'Nicht mehr ignorieren';

  @override
  String get deviceSecurityIgnoreCheck => 'Prüfung ignorieren';

  @override
  String get deviceSecurityNoScreenLock => 'Keine Displaysperre';

  @override
  String get deviceSecurityAMissingSecureLockMakesLocalAccess =>
      'Ohne sichere Sperre ist der lokale Zugriff auf das Gerät einfacher.';

  @override
  String get deviceSecurityRootShizukuActive => 'Root/Shizuku aktiv';

  @override
  String get deviceSecurityRootOrShizukuCanGrantPowerfulDevice =>
      'Root oder Shizuku kann weitreichende Kontrolle über das Gerät ermöglichen.';

  @override
  String get deviceSecurityDisabledAppVerification =>
      'App-Überprüfung deaktiviert';

  @override
  String get deviceSecurityAppVerificationHelpsDetectHarmfulInstalls =>
      'Die App-Überprüfung hilft, schädliche Installationen zu erkennen.';

  @override
  String get deviceSecurityOldAndroidSecurityPatch =>
      'Veralteter Android-Sicherheitspatch';

  @override
  String get deviceSecurityOlderPatchLevelsMayLeaveKnownIssues =>
      'Ältere Patch-Stände können bekannte Probleme ungepatcht lassen.';

  @override
  String get deviceSecurityDeveloperModeOn => 'Entwicklermodus aktiviert';

  @override
  String get deviceSecurityDeveloperOptionsExposeAdvancedDeviceControls =>
      'Entwickleroptionen stellen erweiterte Gerätesteuerungen bereit.';

  @override
  String get deviceSecurityUsbDebuggingOn => 'USB-Debugging aktiviert';

  @override
  String get deviceSecurityUsbDebuggingAllowsADBControlFromTrusted =>
      'USB-Debugging ermöglicht ADB-Steuerung von vertrauenswürdigen Computern.';

  @override
  String get deviceSecurityUnknownSourcesAllowed =>
      'Unbekannte Quellen erlaubt';

  @override
  String get deviceSecuritySideloadingCanBypassNormalAppStoreChecks =>
      'Sideloading kann die üblichen Prüfungen des App-Stores umgehen.';

  @override
  String get deviceSecurityAccessibilityAbuseRisk =>
      'Risiko durch Missbrauch von Bedienungshilfen';

  @override
  String get deviceSecurityAccessibilityServicesCanReadAndControlScreen =>
      'Bedienungshilfen können Bildschirminhalte lesen und Aktionen steuern.';

  @override
  String get homeHelpImproveDetectionsForEverybody =>
      'Hilf mit, die Erkennung für alle zu verbessern';

  @override
  String get homeApkSAndroidAppsFoundToBe =>
      'APKs (Android-Apps), die als schädlich erkannt wurden, ';

  @override
  String get homeCanBeUploadedTo => 'können hochgeladen werden zu ';

  @override
  String get homeAndSharedWithTheCommunityThisIs =>
      ' und mit der Community geteilt werden. Dies ist ';

  @override
  String get homeStrictlyLimitedToAPKFilesNOTYour =>
      'streng auf APK-Dateien beschränkt, NICHT auf deine persönlichen ';

  @override
  String get homeDocuments => 'Dokumente.\n\n';

  @override
  String get homeThisWillImproveDetectionsForEveryoneThat =>
      'Dadurch wird die Erkennung für alle verbessert, die ';

  @override
  String get homeUsesAvarionXNoPressureThough =>
      'AvarionX verwenden. Aber kein Druck!\n\n';

  @override
  String get homeThanks => 'Danke,\n';

  @override
  String get homeRyanfromcolourswift => 'RyanFromColourswift';

  @override
  String get homeSure => 'Klar!';

  @override
  String get homeNoThanks => 'Nein, danke!';

  @override
  String get homePsstCustomiseItHere => 'Psst... hier anpassen';

  @override
  String get homeScanNow => 'Jetzt scannen';

  @override
  String get homeManuallyCheckYourDeviceForMalware =>
      'Prüfe dein Gerät manuell auf Malware';

  @override
  String get homeDeviceSecurity => 'Gerätesicherheit';

  @override
  String get homeScanModes => 'Scan-Modi';

  @override
  String get homeCloudAssistedChecksEnabled =>
      'Cloud-unterstützte Prüfungen aktiviert';

  @override
  String get homeLocalScanEngineOnly => 'Nur lokale Scan-Engine';

  @override
  String get homeProtectedByVXTITANIUM => 'Geschützt durch VX-TITANIUM';

  @override
  String get homeSecurityOverview => 'Sicherheitsübersicht';

  @override
  String get homeFilesChecked => 'Geprüfte Dateien';

  @override
  String get homeThreats => 'Bedrohungen';

  @override
  String get securityReportAvarionxSecurityReport =>
      'Avarionx-Sicherheitsbericht';

  @override
  String get securityReportSecurityReport => 'Sicherheitsbericht';

  @override
  String get securityReportManualScans => 'Manuelle Scans';

  @override
  String get securityReportRealtimeChecks => 'Echtzeitprüfungen';

  @override
  String get securityReportTotalFilesScanned => 'Insgesamt gescannte Dateien';

  @override
  String get securityReportThreatsFound => 'Gefundene Bedrohungen';

  @override
  String get securityReportGenerateReport => 'Bericht erstellen';

  @override
  String get securityReportLiveReport => 'Live-Bericht';

  @override
  String get securityReportThisBoxUpdatesAsScanServicesWrite =>
      'Dieses Feld wird aktualisiert, sobald Scan-Dienste Berichtsdaten schreiben.';

  @override
  String get securityReportExportPDF => 'PDF exportieren';

  @override
  String get securityReportExportCSV => 'CSV exportieren';

  @override
  String get homeLegacyProActivated => 'Pro aktiviert';

  @override
  String get homeLegacyProDeactivated => 'Pro deaktiviert';

  @override
  String get linkCheckPoweredByVTTICloud => 'Unterstützt von VTTI Cloud';

  @override
  String get safeViewSafeView => 'Safe View';

  @override
  String get passwordSettingsChangingThisAltersAllPasswords =>
      'Wenn du dies änderst, ändern sich alle Passwörter.\n';

  @override
  String get passwordSettingsUsingTheSameMetaPassRestoresThem =>
      'Mit demselben MetaPass können sie wiederhergestellt werden.';

  @override
  String get passwordSettingsPasswordsAreNeverStored =>
      'Passwörter werden niemals gespeichert.\n\n';

  @override
  String get passwordSettingsTheRestoreCodeContainsOnlyStructureData =>
      'Der Wiederherstellungscode enthält nur Strukturdaten. ';

  @override
  String get passwordSettingsCombinedWithYourMetaPassItRebuildsYour =>
      'Zusammen mit deinem MetaPass stellt er deinen Tresor wieder her.';

  @override
  String get passwordManagerContinue => 'Weiter';

  @override
  String passwordManagerFailedToLoadApps(Object e) {
    return 'Apps konnten nicht geladen werden: $e';
  }

  @override
  String passwordManagerFailedToGeneratePassword(Object e) {
    return 'Passwort konnte nicht generiert werden: $e';
  }

  @override
  String get passwordManagerPasswordsAreNeverStored =>
      'Passwörter werden niemals gespeichert.\n\n';

  @override
  String get passwordManagerEachEntryDerivesAPasswordFrom =>
      'Für jeden Eintrag wird ein Passwort abgeleitet aus:\n';

  @override
  String get passwordManagerYourMetaPassword => '• Deinem Meta-Passwort\n';

  @override
  String get passwordManagerTheLabelName => '• Dem Labelnamen\n';

  @override
  String get passwordManagerTheVersionAndLength =>
      '• Der Version und Länge\n\n';

  @override
  String get passwordManagerReinstallingTheAppWithTheSameMeta =>
      'Wenn du die App mit demselben Meta-Passwort und denselben Labels neu installierst, werden dieselben Passwörter erneut erzeugt.';

  @override
  String get permissionsIntroSetupIsNowCompleteTimeToSecure =>
      'Die Einrichtung ist abgeschlossen! Zeit, deine Daten zu schützen.';

  @override
  String get proScreenThankYou => 'Vielen Dank';

  @override
  String get proScreenYourSubscriptionIsConfirmed =>
      'Dein Abonnement wurde bestätigt.';

  @override
  String get proScreenCurrent => 'Aktuell';

  @override
  String get proScreenAdvancedStealthMode => 'Erweiterter Stealth+-Modus';

  @override
  String get proScreenUnlockStealthTransportModesForRestrictiveNetworks =>
      'Schalte verdeckte Transportmodi für restriktive Netzwerke frei.';

  @override
  String get proScreenGlobalServerAccess => 'Globaler Serverzugriff';

  @override
  String get proScreenAccessEveryVPNServerLocationIncludingPremium =>
      'Greife auf jeden VPN-Serverstandort zu, einschließlich schneller Premium-Regionen.';

  @override
  String get proScreenBilledMonthly => 'Monatliche Abrechnung';

  @override
  String proScreenMo(Object monthlyInfo) {
    return '$monthlyInfo/Monat';
  }

  @override
  String proScreenMo2(Object currencyCode) {
    return '$currencyCode/Monat';
  }

  @override
  String get proScreenCurrentPlan => 'Aktueller Tarif';

  @override
  String get quarantineScreenQuarantineDataCorruptedResetting =>
      'Quarantänedaten beschädigt. Wird zurückgesetzt.';

  @override
  String get quarantineScreenUninstallApp => 'App deinstallieren';

  @override
  String quarantineScreenUninstall(Object appName) {
    return '$appName deinstallieren?';
  }

  @override
  String get quarantineScreenUninstall2 => 'Deinstallieren';

  @override
  String get quarantineScreenFailedToLaunchUninstall =>
      'Deinstallation konnte nicht gestartet werden';

  @override
  String get quarantineScreenFiles => 'Dateien';

  @override
  String get cleanerAppManagerShizukuNotAvailable => 'Shizuku nicht verfügbar';

  @override
  String get cleanerAppManagerWithoutShizukuEachAppRequiresASeparate =>
      'Ohne Shizuku erfordert jede App eine separate Systembestätigung. Fortfahren?';

  @override
  String cleanerAppManagerAppsUninstalled(Object successCount) {
    return '$successCount Apps deinstalliert';
  }

  @override
  String cleanerAppManagerUninstalledFailed(
      Object successCount, Object failedCount) {
    return '$successCount deinstalliert, $failedCount fehlgeschlagen';
  }

  @override
  String cleanerAppManagerStopped(Object appName) {
    return '$appName gestoppt';
  }

  @override
  String get cleanerAppManagerForceStopFailed =>
      'Beenden erzwingen fehlgeschlagen';

  @override
  String get cleanerAppManagerClearAppData => 'App-Daten löschen';

  @override
  String cleanerAppManagerResetThisClearsItsAccountsSettingsFiles(
      Object appName) {
    return '$appName zurücksetzen? Dadurch werden Konten, Einstellungen, Dateien und Cache der App gelöscht.';
  }

  @override
  String get cleanerAppManagerClearData => 'Daten löschen';

  @override
  String cleanerAppManagerReset(Object appName) {
    return '$appName zurückgesetzt';
  }

  @override
  String get cleanerAppManagerClearDataFailed =>
      'Daten konnten nicht gelöscht werden';

  @override
  String get cleanerAppManagerOpenApp => 'App öffnen';

  @override
  String get cleanerAppManagerForceStop => 'Beenden erzwingen';

  @override
  String get cleanerAppManagerUninstall => 'Deinstallieren';

  @override
  String cleanerAppManagerSelected(Object selectedCount) {
    return '$selectedCount ausgewählt';
  }

  @override
  String get cleanerAppManagerAppManager => 'App-Manager';

  @override
  String get cleanerAppManagerDeselectAll => 'Auswahl aufheben';

  @override
  String cleanerAppManagerUninstalling(Object done, Object total) {
    return 'Deinstallation $done / $total…';
  }

  @override
  String cleanerAppManagerUninstall2(Object selectedCount) {
    return '$selectedCount deinstallieren';
  }

  @override
  String get cleanerProClearAppCaches => 'App-Caches leeren';

  @override
  String get cleanerProThisAsksAndroidToTrimAppCaches =>
      'Android wird angewiesen, App-Caches auf dem gesamten Gerät zu verkleinern. App-Daten, Konten und Einstellungen werden nicht gelöscht.';

  @override
  String get cleanerProClearCaches => 'Caches leeren';

  @override
  String get cleanerProCacheTrimRequested => 'Cache-Bereinigung angefordert';

  @override
  String get cleanerProCacheCleanerFailed => 'Cache-Bereinigung fehlgeschlagen';

  @override
  String get cleanerProLogFiles => 'Protokolldateien';

  @override
  String get cleanerProCacheCleaner => 'Cache Cleaner';

  @override
  String get cleanerProLogCleaner => 'Log Cleaner';

  @override
  String get cleanerProAppDataManager => 'App-Daten-Manager';

  @override
  String get cleanerScreenCleaner => 'Cleaner';

  @override
  String get scanDetailDeleteFiles => 'Dateien löschen';

  @override
  String scanDetailDeleteFilesPermanently(Object selectedCount) {
    return '$selectedCount Dateien dauerhaft löschen?';
  }

  @override
  String get scanDetailSelectedFilesDeleted => 'Ausgewählte Dateien gelöscht';

  @override
  String get scanDetailDeleteAllFiles => 'Alle Dateien löschen';

  @override
  String scanDetailDeleteAllFilesPermanently(Object fileCount) {
    return 'Alle $fileCount Dateien dauerhaft löschen?';
  }

  @override
  String get scanDetailDeleteAll => 'Alle löschen';

  @override
  String get scanDetailAllFilesDeleted => 'Alle Dateien gelöscht';

  @override
  String scanDetailSelected(Object selectedCount) {
    return '$selectedCount ausgewählt';
  }

  @override
  String get scanDetailDeselectAll => 'Auswahl aufheben';

  @override
  String get scanDetailNewestFirst => 'Neueste zuerst';

  @override
  String get scanDetailOldestFirst => 'Älteste zuerst';

  @override
  String get scanDetailLargestFirst => 'Größte zuerst';

  @override
  String get scanDetailSmallestFirst => 'Kleinste zuerst';

  @override
  String get scanDetailNoFilesFound => 'Keine Dateien gefunden';

  @override
  String get scanDetailDeleteAll2 => 'Alle löschen';

  @override
  String get scanInstalledAppsSearchApps => 'Apps suchen...';

  @override
  String get scanInstalledAppsNoAppsFound => 'Keine Apps gefunden.';

  @override
  String get scanUiScanComplete => 'Scan abgeschlossen';

  @override
  String scanUiScannedItems(Object scanned) {
    return 'Gescannt: $scanned Elemente';
  }

  @override
  String scanUiProgress(Object pct, Object scanned, Object total) {
    return 'Fortschritt: $pct ($scanned / $total)';
  }

  @override
  String get scanUiPreparingEngine => 'Engine wird vorbereitet...';

  @override
  String get scanUiLoadingTargetS => 'Ziel(e) werden geladen';

  @override
  String get scanUiAvarionxVPN => 'AvarionX VPN';

  @override
  String get scanUiProtectYourInternetWithOurUnlimitedVPN =>
      'Schütze deine Internetverbindung mit unserem unbegrenzten VPN';

  @override
  String get scanUiTapMe => 'Antippen!';

  @override
  String scanUiScanned(Object scanned) {
    return '$scanned gescannt';
  }

  @override
  String get scanUiReturn => 'Zurück';

  @override
  String get scanLimitsSettingsUpdated => 'Einstellungen aktualisiert';

  @override
  String get scanLimitsScanLimits => 'Scan-Limits';

  @override
  String get scanLimitsLimitHowMuchTheEngineUsesYour =>
      'Begrenze, wie stark die Engine deine CPU nutzt. Threads: 0 bedeutet automatisch.';

  @override
  String get scanLimitsMaxScanThreads => 'Maximale Scan-Threads';

  @override
  String scanLimits0AutoRange0ToCores(Object maxThreads, Object coreCount) {
    return '0 = automatisch. Bereich: 0 bis $maxThreads (Kerne: $coreCount).';
  }

  @override
  String scanLegacyScanning(Object percent) {
    return 'Scan läuft... $percent%';
  }

  @override
  String scanLegacySuspicious(Object infectedCount) {
    return 'Verdächtig: $infectedCount';
  }

  @override
  String scanLegacyClean(Object cleanCount) {
    return 'Sauber: $cleanCount';
  }

  @override
  String get scanLegacyNoFilesToScan => 'Keine Dateien zum Scannen';

  @override
  String get settingsSponsorsUnlock => 'Sponsoren schalten frei ❤️';

  @override
  String get settingsPickCertificate => 'Zertifikat auswählen';

  @override
  String get settingsCertificateLoaded => 'Zertifikat geladen';

  @override
  String get settingsEnterCode => 'Code eingeben';

  @override
  String get settingsSupportFileMissing => 'Supportdatei fehlt';

  @override
  String get settingsInvalidSupportCode => 'Ungültiger Supportcode';

  @override
  String get settingsAvarionxSecurity => 'AvarionX Security';

  @override
  String get settingsAvarionxIsAMobileSecuritySuiteCreated =>
      'AvarionX ist eine mobile Sicherheitssuite von ColourSwift mit Sitz in Birmingham, Großbritannien.\n\n';

  @override
  String get settingsContact => 'Kontakt: ';

  @override
  String get settingsExperimentalFeatures => 'Experimentelle Funktionen';

  @override
  String get settingsEnablingShizukuUnlocksExperimentalWorkInProgress =>
      'Durch Aktivieren von Shizuku werden experimentelle Funktionen freigeschaltet, die sich noch in Entwicklung befinden:\n\n';

  @override
  String get settingsAdvancedRansomwareProtection =>
      '• Erweiterter Ransomware-Schutz\n';

  @override
  String get settingsCacheCleanerPlus => '• Cache Cleaner Plus\n\n';

  @override
  String get settingsExperimentalWarning =>
      'Hinweis zu experimentellen Funktionen:\n';

  @override
  String get settingsTheseFeaturesUseAdvancedSystemAccessAnd =>
      'Diese Funktionen nutzen erweiterten Systemzugriff und können sich je nach Gerät, Android-Version und Shizuku-Konfiguration unterschiedlich verhalten. Einige Aktionen können laufende Apps, Dateien oder Cache-Daten direkter beeinflussen als ein normaler Scan.\n\n';

  @override
  String get settingsOnlyEnableThisIfYouUnderstandShizuku =>
      'Aktiviere dies nur, wenn du Shizuku verstehst, akzeptierst, dass die Funktion noch getestet wird, und wichtige Daten gesichert hast.\n\n';

  @override
  String get settingsPleaseReadTheDocumentationBeforeEnabling =>
      'Bitte lies vor dem Aktivieren die Dokumentation.';

  @override
  String get settingsEnable => 'Aktivieren';

  @override
  String get settingsSigningOut => 'Abmeldung läuft...';

  @override
  String get settingsCheckingAccountStatus => 'Kontostatus wird geprüft...';

  @override
  String get settingsManageSignInPremiumAndPurchases =>
      'Anmeldung, Premium und Käufe verwalten';

  @override
  String get settingsPremiumActive => 'Premium aktiv';

  @override
  String get settingsManagePremiumOptionsAndRestorePurchases =>
      'Premium-Optionen verwalten und Käufe wiederherstellen';

  @override
  String get settingsUnlockDeepAnalysisModeAndVPNFeatures =>
      'Tiefenanalyse-Modus und VPN-Funktionen freischalten';

  @override
  String get settingsAutoClearNotifications =>
      'Benachrichtigungen automatisch löschen';

  @override
  String get settingsScanModes => 'Scan-Modi';

  @override
  String get settingsAdvancedScanModes => 'Erweiterte Scan-Modi';

  @override
  String get settingsDisableToUseTheDefaultScanningMode =>
      'Deaktivieren, um den Standard-Scanmodus zu verwenden';

  @override
  String get settingsToggleToEnableAllScanningModes =>
      'Aktivieren, um alle Scan-Modi freizuschalten';

  @override
  String get settingsApkSubmissions => 'APK-Übermittlungen';

  @override
  String get settingsShareMaliciousAPKs => 'Schädliche APKs teilen';

  @override
  String get settingsHelpingImproveDetectionForEveryone =>
      'Hilft, die Erkennung für alle zu verbessern';

  @override
  String get settingsOff => 'Aus';

  @override
  String get settingsIncludeRealtimeProtectionCatches =>
      'Treffer des Echtzeitschutzes einschließen';

  @override
  String get settingsApksFlaggedByRealtimeProtectionAreIncluded =>
      'Vom Echtzeitschutz markierte APKs werden eingeschlossen';

  @override
  String get settingsApksFlaggedByRealtimeProtectionAreExcluded =>
      'Vom Echtzeitschutz markierte APKs werden ausgeschlossen';

  @override
  String get settingsIncludeManualAndScheduledScans =>
      'Manuelle und geplante Scans einschließen';

  @override
  String get settingsApksFlaggedByScansAreIncluded =>
      'Durch Scans markierte APKs werden eingeschlossen';

  @override
  String get settingsApksFlaggedByScansAreExcluded =>
      'Durch Scans markierte APKs werden ausgeschlossen';

  @override
  String get settingsWiFiOnly => 'Nur Wi-Fi';

  @override
  String get settingsUploadsWaitForAWiFiConnection =>
      'Uploads warten auf eine Wi-Fi-Verbindung';

  @override
  String get settingsUploadsMayUseMobileData =>
      'Uploads können mobile Daten verwenden';

  @override
  String get settingsChargingOnly => 'Nur beim Laden';

  @override
  String get settingsUploadsWaitUntilTheDeviceIsCharging =>
      'Uploads warten, bis das Gerät geladen wird';

  @override
  String get settingsUploadsAreNotLimitedToCharging =>
      'Uploads sind nicht auf den Ladevorgang beschränkt';

  @override
  String get settingsChooseWhichAppsUpload =>
      'Auswählen, welche Apps hochgeladen werden';

  @override
  String get settingsReviewAndPickAppsEachTimeBefore =>
      'Apps vor jedem Upload prüfen und auswählen';

  @override
  String get settingsFlaggedAppsUploadAutomatically =>
      'Markierte Apps werden automatisch hochgeladen';

  @override
  String get settingsEnableProDebug => 'Pro aktivieren (Debug)';

  @override
  String get settingsLocalUnlockForUITesting =>
      'Lokale Freischaltung für UI-Tests';

  @override
  String get settingsRestorePurchases => 'Käufe wiederherstellen';

  @override
  String get settingsReCheckPlayBilling => 'Play Billing erneut prüfen';

  @override
  String get settingsCheckingAccount => 'Konto wird geprüft...';

  @override
  String get settingsAvarionxAccountConnected => 'AvarionX-Konto verbunden';

  @override
  String settingsAccountID(Object accountId) {
    return 'Konto-ID: $accountId';
  }

  @override
  String get settingsSignInToManagePurchasesAndAccount =>
      'Melde dich an, um Käufe und Kontofunktionen zu verwalten.';

  @override
  String get settingsOpenTheAvarionXAccountPortal =>
      'AvarionX-Kontoportal öffnen';

  @override
  String get settingsAccountDashboard => 'Konto-Dashboard';

  @override
  String get settingsOpenBillingAndAccountSettings =>
      'Abrechnungs- und Kontoeinstellungen öffnen';

  @override
  String get settingsRemoveThisAccountFromTheApp =>
      'Dieses Konto aus der App entfernen';

  @override
  String get settingsPremiumFeaturesAreAvailableOnThisDevice =>
      'Premium-Funktionen sind auf diesem Gerät verfügbar';

  @override
  String get settingsViewOptionalPremiumFeatures =>
      'Optionale Premium-Funktionen anzeigen';

  @override
  String get settingsReCheckPlayBillingEntitlement =>
      'Play-Billing-Berechtigung erneut prüfen';

  @override
  String get settingsRtpNotificationAutoClearNotifications =>
      'Benachrichtigungen automatisch löschen';

  @override
  String get settingsRtpNotificationNever => 'Nie';

  @override
  String get settingsRtpNotification5Minutes => '5 Minuten';

  @override
  String get settingsRtpNotification10Minutes => '10 Minuten';

  @override
  String get settingsRtpNotification30Minutes => '30 Minuten';

  @override
  String get settingsThemeBlack => 'Schwarz';

  @override
  String get settingsThemeWhite => 'Weiß';

  @override
  String get settingsThemeGrey => 'Grau';

  @override
  String get settingsThemeEmerald => 'Smaragdgrün';

  @override
  String get settingsThemePurple => 'Lila';

  @override
  String get settingsThemeRoyalBlue => 'Königsblau';

  @override
  String get settingsAccountCardSyncPurchasesAndUnlockProAcrossApps =>
      'Käufe synchronisieren und Pro appübergreifend freischalten.';

  @override
  String get settingsAccountCardLoading => 'Wird geladen...';

  @override
  String get settingsAccountCardDashboard => 'Dashboard';

  @override
  String get settingsProCardChangePlan => 'Tarif ändern';

  @override
  String get advancedNetworkProtectionEnterYourOwnResolver =>
      'Eigenen Resolver eingeben';

  @override
  String get advancedNetworkProtectionCloudProtectionMode =>
      'Cloud-Schutzmodus';

  @override
  String get advancedNetworkProtectionRoutesAllDNSQueriesToTheCloud =>
      'Leitet alle DNS-Anfragen an die Cloud-Engine weiter und ermöglicht so Live-Updates der Blocklisten, Prüfungen der Domain-Reputation und mehr.';

  @override
  String get advancedNetworkProtectionRefreshProStatus =>
      'Pro-Status aktualisieren';

  @override
  String get advancedNetworkProtectionProActive => 'Pro aktiv';

  @override
  String get advancedNetworkProtectionFreePlan => 'Kostenloser Tarif';

  @override
  String get advancedNetworkProtectionChecksYourEntitlementAndSyncsItWith =>
      'Prüft deine Berechtigung und synchronisiert sie mit Cloud-Funktionen. Pro schaltet systemweite Werbeblockierung frei.';

  @override
  String get advancedNetworkProtectionMalwareProtection => 'Malware-Schutz';

  @override
  String get advancedNetworkProtectionBlocksKnownMaliciousDomains =>
      'Blockiert bekannte schädliche Domains';

  @override
  String get advancedNetworkProtectionTrackerProtection => 'Tracker-Schutz';

  @override
  String get advancedNetworkProtectionReducesTrackingDomains =>
      'Reduziert Tracking-Domains';

  @override
  String get advancedNetworkProtectionAdProtection => 'Werbeschutz';

  @override
  String get advancedNetworkProtectionBlocksCommonAdDomains =>
      'Blockiert gängige Werbe-Domains';

  @override
  String get advancedNetworkProtectionAdultFilter =>
      'Filter für nicht jugendfreie Inhalte';

  @override
  String get advancedNetworkProtectionUses1113Upstream =>
      'Verwendet 1.1.1.3 als Upstream';

  @override
  String get advancedNetworkProtectionLockedUntilProIsActiveAndCloud =>
      'Gesperrt, bis Pro aktiv und der Cloud-Modus aktiviert ist.';

  @override
  String get advancedNetworkProtectionLiveDNSEventsFromTheVPNLayer =>
      'Live-DNS-Ereignisse aus der VPN-Schicht.';

  @override
  String get advancedNetworkProtectionAdvanced => 'Erweitert';

  @override
  String get advancedNetworkProtectionDns => 'DNS';

  @override
  String get advancedNetworkProtectionCloudDNSMode => 'Cloud-DNS-Modus';

  @override
  String get networkProtectionEnterYourOwnResolver =>
      'Eigenen Resolver eingeben';

  @override
  String get networkAppControlEnableVPNToggles => 'VPN-Schalter aktivieren';

  @override
  String get networkAppControlOpenSettings => 'Einstellungen öffnen';

  @override
  String get networkAppControlAppControl => 'App-Steuerung';

  @override
  String get networkAppControlNoAppsFound => 'Keine Apps gefunden.';

  @override
  String get networkSpeedTestCountry => 'Land';

  @override
  String get networkSpeedTestRunning => 'Läuft';

  @override
  String get networkSpeedTestRunTest => 'Test starten';

  @override
  String get networkSpeedTestNoResultsYet => 'Noch keine Ergebnisse.';

  @override
  String networkSpeedTestDnsTLS(Object dns, Object tls) {
    return 'DNS: $dns  •  TLS: $tls';
  }

  @override
  String get networkSpeedTestFail => 'Fehlgeschlagen';

  @override
  String get dnsNetworkProtectionEnterYourOwnResolver =>
      'Eigenen Resolver eingeben';

  @override
  String get dnsNetworkProtectionDnsFilteringIsSeperateFromTheSecure =>
      'DNS-Filterung ist vom Secure VPN getrennt. Sie kann bekannte Malware, Werbung (in allen Apps), Tracker und Inhalte unerwünschter Kategorien blockieren, bevor sie geladen werden.';

  @override
  String get fullVpnSignedIn => 'Angemeldet.';

  @override
  String get fullVpnSignInRequired => 'Anmeldung erforderlich';

  @override
  String get fullVpnClose => 'Schließen';

  @override
  String get fullVpnLoadingUsage => 'Nutzung wird geladen...';

  @override
  String get fullVpnSyncing => 'Wird synchronisiert';

  @override
  String fullVpnUsedThisMonth(Object usedBytes) {
    return 'Diesen Monat $usedBytes verwendet';
  }

  @override
  String get blockedScreenUnsupportedEnvironment =>
      'Nicht unterstützte Umgebung';

  @override
  String updateLogUpdateV(Object version) {
    return 'Update: v$version';
  }

  @override
  String get updateLogHiThereAvarionXHasBeenUpdatedBelow =>
      'Hallo! AvarionX wurde aktualisiert. Hier sind die Änderungen:';

  @override
  String get updateLogNoUserFacingChangesInThisUpdate =>
      'Dieses Update enthält keine sichtbaren Änderungen für Nutzer.';

  @override
  String get updateLogContinue => 'Weiter';

  @override
  String get featuresRealtimeProtectionBody =>
      'Überwacht neue und geänderte Dateien im Hintergrund und blockiert Bedrohungen, sobald sie auftreten.';

  @override
  String get featuresTriLayerEngineTitle => 'Dreischicht-Engine';

  @override
  String get featuresTriLayerEngineBody =>
      'Ein dreistufiger Erkennungskern, der Bloom-Filterung, Signatur-Scans und APK-spezifische Byte-Analyse für hohe Genauigkeit und Geschwindigkeit kombiniert.';

  @override
  String get featuresMachineLearningTitle => 'Maschinelles Lernen';

  @override
  String get featuresMachineLearningBody =>
      'Ein leichtgewichtiges On-Device-Modell, das darauf trainiert ist, schädliche Verhaltensmuster in APKs zu erkennen.';

  @override
  String get featuresCleanerProTitle => 'Cleaner Pro';

  @override
  String get featuresCleanerProBody =>
      'Ein stetig weiterentwickeltes Reinigungsmodul, das Duplikate, Cache und ungenutzte Apps erkennt, um Speicherplatz freizugeben.';

  @override
  String get featuresWifiProtectionTitle => 'Wi-Fi-Schutz';

  @override
  String get featuresWifiProtectionBody =>
      'Erkennt unsichere oder verdächtige Wi-Fi-Netzwerke durch Analyse auf dem Gerät.';

  @override
  String get featuresRootLevelProtectionTitle => 'Root-Level-Schutz';

  @override
  String get featuresRootLevelProtectionBody =>
      'Tiefgreifender Schutz auf Systemebene für gerootete Geräte und fortgeschrittene Nutzer.';

  @override
  String get featuresPcCompanionTitle => 'PC-Begleiter';

  @override
  String get featuresPcCompanionBody =>
      'Kommende Desktop-Version für plattformübergreifende Antivirus-Integration.';

  @override
  String get deviceSecurityNoRisksFound => 'Keine Geräterisiken gefunden';

  @override
  String get deviceSecurityOneCheckNeedsAttention =>
      '1 Geräteprüfung erfordert Aufmerksamkeit';

  @override
  String deviceSecurityChecksNeedAttention(Object count) {
    return '$count Geräteprüfungen erfordern Aufmerksamkeit';
  }

  @override
  String get deviceSecurityHealthSectionBody =>
      'Diese Einstellungen wirken sich direkt auf die Sicherheitslage deines Geräts aus.';

  @override
  String get deviceSecurityRecommendationsSectionBody =>
      'Diese Einstellungen entsprechen gängigen Empfehlungen für gute Sicherheit.';

  @override
  String get deviceSecuritySignalUnavailable => 'Signal nicht verfügbar';

  @override
  String get deviceSecurityIgnoredByYou => 'Von dir ignoriert';

  @override
  String get deviceSecurityScreenLockInactiveTitle => 'Displaysperre';

  @override
  String get deviceSecurityScreenLockActiveLabel =>
      'Unsicher, es ist keine sichere Displaysperre eingerichtet';

  @override
  String get deviceSecurityScreenLockInactiveLabel => 'Displaysperre ist aktiv';

  @override
  String get deviceSecurityScreenLockDetail =>
      'Eine sichere Displaysperre schützt dein Gerät, wenn es verloren geht, gestohlen wird oder unbeaufsichtigt bleibt. Ohne PIN, Passwort, Muster, Fingerabdruck oder Gesichtserkennung, die durch eine sichere Sperrmethode abgesichert ist, kann jemand mit physischem Zugriff das Gerät leichter öffnen.';

  @override
  String get deviceSecurityScreenLockHelp =>
      'Öffne die Android-Sicherheitseinstellungen und richte eine sichere Displaysperre ein.';

  @override
  String get deviceSecurityCheckSetting => 'Einstellung prüfen';

  @override
  String get deviceSecurityPrivilegedInactiveTitle =>
      'Kein privilegierter Zugriff';

  @override
  String get deviceSecurityPrivilegedActiveLabel =>
      'Privilegierter Zugriff erkannt';

  @override
  String get deviceSecurityPrivilegedInactiveLabel =>
      'Kein privilegierter Zugriff erkannt';

  @override
  String get deviceSecurityPrivilegedDetail =>
      'Root und Shizuku können nützlich sein, erhöhen aber auch die Auswirkungen einer schädlichen App, wenn der Zugriff missbraucht wird. Apps mit privilegiertem Zugriff können möglicherweise Aktionen ausführen, die normale Android-Apps nicht ausführen können.';

  @override
  String get deviceSecurityPrivilegedHelp =>
      'Prüfe deine Root-, Magisk- oder Shizuku-Einstellungen manuell.';

  @override
  String get deviceSecurityReviewSetting => 'Einstellung überprüfen';

  @override
  String get deviceSecurityAppVerificationInactiveTitle => 'App-Überprüfung';

  @override
  String get deviceSecurityAppVerificationActiveLabel =>
      'Unsicher, App-Überprüfung scheint deaktiviert zu sein';

  @override
  String get deviceSecurityAppVerificationInactiveLabel =>
      'App-Überprüfung scheint aktiviert zu sein';

  @override
  String get deviceSecurityAppVerificationDetail =>
      'Die Android-App-Überprüfung hilft dabei, Apps vor oder nach der Installation zu prüfen. Wenn dieser Schutz deaktiviert oder nicht verfügbar ist, werden schädliche Apps möglicherweise seltener blockiert, bevor sie ausgeführt werden.';

  @override
  String get deviceSecurityAppVerificationHelp =>
      'Öffne die Android-Sicherheitseinstellungen und überprüfe die App-Überprüfung.';

  @override
  String get deviceSecuritySecurityPatchInactiveTitle =>
      'Sicherheitspatch aktuell';

  @override
  String get deviceSecuritySecurityPatchActiveLabel =>
      'Sicherheitspatch-Level ist veraltet';

  @override
  String get deviceSecuritySecurityPatchInactiveLabel =>
      'Sicherheitspatch-Level ist aktuell';

  @override
  String get deviceSecuritySecurityPatchDetail =>
      'Android-Sicherheitspatches beheben bekannte Probleme der Plattform und der Hersteller. Wenn der Patch-Stand alt ist, kann das Gerät Schwachstellen ausgesetzt sein, die in neueren Builds bereits behoben wurden.';

  @override
  String get deviceSecuritySecurityPatchHelp =>
      'Öffne die Android-Systemupdate-Einstellungen und suche nach Updates.';

  @override
  String get deviceSecurityCheckUpdates => 'Nach Updates suchen';

  @override
  String get deviceSecurityDeveloperModeInactiveTitle => 'Entwicklermodus';

  @override
  String get deviceSecurityDeveloperModeActiveLabel =>
      'Entwickleroptionen sind aktiviert';

  @override
  String get deviceSecurityDeveloperModeInactiveLabel =>
      'Entwickleroptionen sind deaktiviert';

  @override
  String get deviceSecurityDeveloperModeDetail =>
      'Der Entwicklermodus ist für Entwickler und Tester normal, stellt aber erweiterte Einstellungen bereit, die die Gerätesicherheit verringern können, wenn sie versehentlich geändert oder von jemandem mit Gerätezugriff missbraucht werden.';

  @override
  String get deviceSecurityDeveloperModeHelp =>
      'Öffne die Entwickleroptionen und deaktiviere Einstellungen, die du nicht benötigst.';

  @override
  String get deviceSecurityUsbDebuggingInactiveTitle => 'USB-Debugging';

  @override
  String get deviceSecurityUsbDebuggingActiveLabel =>
      'Unsicher, USB-Debugging ist aktiviert';

  @override
  String get deviceSecurityUsbDebuggingInactiveLabel =>
      'USB-Debugging ist deaktiviert';

  @override
  String get deviceSecurityUsbDebuggingDetail =>
      'USB-Debugging ermöglicht einem verbundenen Computer, über Android Debug Bridge mit deinem Gerät zu interagieren. Bleibt es aktiviert, steigt das Risiko eines unbefugten Zugriffs bei Verbindung mit einem nicht vertrauenswürdigen Computer.';

  @override
  String get deviceSecurityUsbDebuggingHelp =>
      'Öffne die Entwickleroptionen und deaktiviere USB-Debugging.';

  @override
  String get deviceSecurityUnknownSourcesInactiveTitle => 'Unbekannte Quellen';

  @override
  String get deviceSecurityUnknownSourcesActiveLabel =>
      'Installation unbekannter Apps ist erlaubt';

  @override
  String get deviceSecurityUnknownSourcesInactiveLabel =>
      'Installation unbekannter Apps ist eingeschränkt';

  @override
  String get deviceSecurityUnknownSourcesDetail =>
      'Das Zulassen von App-Installationen aus unbekannten Quellen kann für vertrauenswürdige APKs nützlich sein, erhöht aber auch das Risiko, Apps aus unsicheren Quellen zu installieren. Erlaube dies nur für Apps und Stores, denen du vertraust.';

  @override
  String get deviceSecurityUnknownSourcesHelp =>
      'Öffne die Android-Einstellungen und überprüfe die Berechtigung zum Installieren unbekannter Apps.';

  @override
  String get deviceSecurityAccessibilityInactiveTitle => 'Bedienungshilfen';

  @override
  String get deviceSecurityAccessibilityActiveLabel =>
      'Bedienungshilfedienst eines Drittanbieters aktiviert';

  @override
  String get deviceSecurityAccessibilityInactiveLabel =>
      'Keine riskanten Bedienungshilfedienste gefunden';

  @override
  String get deviceSecurityAccessibilityDetail =>
      'Bedienungshilfen sind leistungsfähig, da sie Bildschirminhalte beobachten und Aktionen im Namen des Nutzers ausführen können. Das ist für legitime Tools nützlich, wird aber auch häufig von schädlichen Apps missbraucht.';

  @override
  String get deviceSecurityAccessibilityHelp =>
      'Öffne die Einstellungen für Bedienungshilfen und überprüfe die aktivierten Dienste.';

  @override
  String get deviceSecurityChecking => 'Gerätesicherheit wird geprüft';

  @override
  String get deviceSecurityReadingSignals =>
      'Signale zur Gerätesicherheitslage werden gelesen...';

  @override
  String get deviceSecurityOneCheckAttention =>
      '1 Prüfung erfordert Aufmerksamkeit';

  @override
  String deviceSecurityChecksAttention(Object count) {
    return '$count Prüfungen erfordern Aufmerksamkeit';
  }

  @override
  String get deviceSecurityTapSignal =>
      'Tippe unten auf ein Signal, um mehr zu erfahren.';

  @override
  String deviceSecurityIgnoredChecks(Object count, String plural) {
    String _temp0 = intl.Intl.selectLogic(
      plural,
      {
        's': '',
        'other': '',
      },
    );
    return 'Ignorierte aktive Prüfungen: $count.$_temp0';
  }

  @override
  String get deviceSecurityPostureNormal =>
      'Die Prüfungen der Sicherheitslage deines Geräts sehen normal aus.';

  @override
  String get timeJustNow => 'gerade eben';

  @override
  String timeMinutesAgo(Object minutes) {
    return 'vor $minutes Min.';
  }

  @override
  String timeHoursAgo(Object hours) {
    return 'vor $hours Std.';
  }

  @override
  String timeDaysAgo(Object days) {
    return 'vor $days T.';
  }

  @override
  String get securityNoReportDataYet => 'Noch keine Berichtsdaten';

  @override
  String securityLastActivity(Object relative) {
    return 'Letzte Aktivität $relative';
  }

  @override
  String get securityReportSharePdfTitle => 'Avarionx-Sicherheitsbericht';

  @override
  String get securityReportCsvField => 'Feld';

  @override
  String get securityReportCsvValue => 'Wert';

  @override
  String get securityReportGeneratedAt => 'Erstellt am';

  @override
  String get securityReportOverallStatus => 'Gesamtstatus';

  @override
  String get securityReportLastManualScan => 'Letzter manueller Scan';

  @override
  String get securityReportLastRealtimeEvent => 'Letztes Echtzeitereignis';

  @override
  String get securityReportLastScheduledScan => 'Letzter geplanter Scan';

  @override
  String get securityReportShareCsvTitle => 'Avarionx-Sicherheitsbericht CSV';

  @override
  String get securityReportReviewRecommended => 'Überprüfung empfohlen';

  @override
  String get securityReportNoKnownThreatDetected =>
      'Keine bekannte Bedrohung erkannt';

  @override
  String securityReportGeneratedLine(Object generatedAt) {
    return 'Erstellt: $generatedAt';
  }

  @override
  String securityReportStatusLine(Object status) {
    return 'Status: $status';
  }

  @override
  String securityReportLatestActivityLine(Object latest) {
    return 'Letzte Aktivität: $latest';
  }

  @override
  String securityReportManualScansLine(Object count) {
    return 'Manuelle Scans: $count';
  }

  @override
  String securityReportRealtimeChecksLine(Object count) {
    return 'Echtzeitprüfungen: $count';
  }

  @override
  String securityReportTotalFilesScannedLine(Object count) {
    return 'Insgesamt gescannte Dateien: $count';
  }

  @override
  String securityReportThreatsFoundLine(Object count) {
    return 'Gefundene Bedrohungen: $count';
  }

  @override
  String securityReportLastManualScanLine(Object value) {
    return 'Letzter manueller Scan: $value';
  }

  @override
  String securityReportLastRealtimeEventLine(Object value) {
    return 'Letztes Echtzeitereignis: $value';
  }

  @override
  String securityReportLastScheduledScanLine(Object value) {
    return 'Letzter geplanter Scan: $value';
  }

  @override
  String get securityReportNotRecorded => 'Nicht erfasst';

  @override
  String get safeViewNavigationBlocked => 'Navigation blockiert';

  @override
  String get safeViewInvalidDestination => 'Ungültiges Ziel';

  @override
  String get safeViewUnsupportedScheme => 'Nicht unterstütztes Schema';

  @override
  String get safeViewUnableToResolveDestination =>
      'Ziel konnte nicht aufgelöst werden';

  @override
  String get safeViewDestinationBlocked => 'Ziel blockiert';

  @override
  String get safeViewUnableToVerifyDestination =>
      'Ziel konnte nicht überprüft werden';

  @override
  String proScreenCurrentStatus(Object status) {
    return 'Aktueller Status: $status';
  }

  @override
  String proScreenBilledAnnuallyAt(Object price) {
    return 'Jährlich abgerechnet zu $price';
  }

  @override
  String get quarantineUnknownApp => 'Unbekannte App';

  @override
  String get cleanerScanCancelled => 'Scan abgebrochen';

  @override
  String get cleanerProClearingCaches => 'Caches werden geleert…';

  @override
  String get cleanerProTrimAppCaches =>
      'App-Caches auf dem gesamten Gerät verkleinern.';

  @override
  String get cleanerProEnableShizuku =>
      'Aktiviere Shizuku in den Einstellungen, um dies zu verwenden.';

  @override
  String get cleanerProScanningStorage => 'Speicher wird gescannt…';

  @override
  String get cleanerProFindLogFiles =>
      '.log-, .trace-, .crash- und .dmp-Dateien finden.';

  @override
  String cleanerProLogFileCount(Object count, Object size) {
    return '$count Dateien • $size';
  }

  @override
  String get cleanerProAppManagerReady =>
      'Apps erzwingen beenden, Daten löschen und mehrere Apps auf einmal deinstallieren.';

  @override
  String get cleanerProAppManagerLimited =>
      'Deinstallieren funktioniert normal. Beenden erzwingen und Daten löschen erfordern Shizuku.';

  @override
  String get cleanerProCheckingShizuku => 'Shizuku wird geprüft…';

  @override
  String get cleanerProShizukuNotRunning =>
      'Shizuku läuft nicht. Aktiviere es bei Bedarf in den Einstellungen.';

  @override
  String get cleanerProShizukuPermissionMissing =>
      'Die Shizuku-Berechtigung wurde nicht erteilt. Aktiviere sie in den Einstellungen.';

  @override
  String get cleanerProShizukuNotBound =>
      'Der Shizuku-Dienst ist noch nicht gebunden. Öffne die Einstellungen und aktualisiere diesen Bildschirm nach dem Aktivieren.';

  @override
  String get cleanerLiteTab => 'Lite';

  @override
  String get cleanerProTab => 'Pro';

  @override
  String get scanCancelled => 'Scan abgebrochen';

  @override
  String get scanPreparing => 'Scan wird vorbereitet...';

  @override
  String scanSuspiciousItemsFound(Object count, String plural) {
    String _temp0 = intl.Intl.selectLogic(
      plural,
      {
        's': '',
        'other': '',
      },
    );
    return 'Verdächtige Elemente gefunden: $count.$_temp0';
  }

  @override
  String scanSuspiciousCount(Object count) {
    return '$count verdächtig';
  }

  @override
  String scanCleanCount(Object count) {
    return '$count sauber';
  }

  @override
  String scanNotificationFullItems(Object count) {
    return 'Gescannt: $count Elemente';
  }

  @override
  String scanNotificationCurrent(Object count, Object file) {
    return 'Gescannt: $count • $file';
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
  String get settingsThemeRoyalBluePremium => 'Königsblau (Premium)';

  @override
  String get settingsIconDefault => 'Standard';

  @override
  String get settingsIconBird => 'Vogel';

  @override
  String get settingsIconNeon => 'Neon';

  @override
  String get settingsIconOriginal => 'Original';

  @override
  String get homeRealtimeProtectionTitle => 'Echtzeitschutz';

  @override
  String get networkCardStatusLocked => 'Gesperrt';

  @override
  String get networkSectionConnection => 'Verbindung';

  @override
  String get networkSectionBlocklists => 'Blocklisten';

  @override
  String get networkSectionResolver => 'Resolver';

  @override
  String get networkAppControlOtherVpnSetupInstructions =>
      'Ein anderes VPN ist derzeit als Always-on ausgewählt.\n\nSo blockierst du Apps zuverlässig:\n\n1) Öffne die Android-VPN-Einstellungen\n2) Wähle AvarionX als VPN aus\n3) Aktiviere Always-on VPN\n4) Aktiviere Verbindungen ohne VPN blockieren';

  @override
  String get networkAppControlSetupInstructions =>
      'So blockierst du Apps zuverlässig:\n\n1) Öffne die Android-VPN-Einstellungen\n2) Wähle AvarionX als VPN aus\n3) Aktiviere Always-on VPN\n4) Aktiviere Verbindungen ohne VPN blockieren';

  @override
  String get networkAppControlBlockingActive => 'App-Blockierung ist aktiv.';

  @override
  String get networkAppControlOtherVpnWarning =>
      'Ein anderes VPN ist als Always-on festgelegt. Aktiviere Always-on + Blockieren ohne VPN für AvarionX.';

  @override
  String get networkAppControlSetupWarning =>
      'Aktiviere Always-on + Blockieren ohne VPN für AvarionX, damit die App-Blockierung funktioniert.';

  @override
  String get countryUnitedKingdom => 'Vereinigtes Königreich';

  @override
  String get countryUnitedStates => 'Vereinigte Staaten';

  @override
  String get countryCanada => 'Kanada';

  @override
  String get countryIreland => 'Irland';

  @override
  String get countryFrance => 'Frankreich';

  @override
  String get countryGermany => 'Deutschland';

  @override
  String get countryNetherlands => 'Niederlande';

  @override
  String get countrySpain => 'Spanien';

  @override
  String get countryItaly => 'Italien';

  @override
  String get countrySweden => 'Schweden';

  @override
  String get countryNorway => 'Norwegen';

  @override
  String get countryDenmark => 'Dänemark';

  @override
  String get countryPoland => 'Polen';

  @override
  String get countryTurkey => 'Türkei';

  @override
  String get countryGreece => 'Griechenland';

  @override
  String get countryRomania => 'Rumänien';

  @override
  String get countryUkraine => 'Ukraine';

  @override
  String get countryRussia => 'Russland';

  @override
  String get countryIndia => 'Indien';

  @override
  String get countryPakistan => 'Pakistan';

  @override
  String get countryBangladesh => 'Bangladesch';

  @override
  String get countrySriLanka => 'Sri Lanka';

  @override
  String get countryNepal => 'Nepal';

  @override
  String get countryJapan => 'Japan';

  @override
  String get countrySouthKorea => 'Südkorea';

  @override
  String get countrySingapore => 'Singapur';

  @override
  String get countryMalaysia => 'Malaysia';

  @override
  String get countryThailand => 'Thailand';

  @override
  String get countryVietnam => 'Vietnam';

  @override
  String get countryPhilippines => 'Philippinen';

  @override
  String get countryIndonesia => 'Indonesien';

  @override
  String get countryAustralia => 'Australien';

  @override
  String get countryNewZealand => 'Neuseeland';

  @override
  String get countryBrazil => 'Brasilien';

  @override
  String get countryArgentina => 'Argentinien';

  @override
  String get countryChile => 'Chile';

  @override
  String get countryMexico => 'Mexiko';

  @override
  String get countryColombia => 'Kolumbien';

  @override
  String get countryPeru => 'Peru';

  @override
  String get countrySouthAfrica => 'Südafrika';

  @override
  String get countryNigeria => 'Nigeria';

  @override
  String get countryKenya => 'Kenia';

  @override
  String get countryEgypt => 'Ägypten';

  @override
  String get countryUAE => 'Vereinigte Arabische Emirate';

  @override
  String get countrySaudiArabia => 'Saudi-Arabien';

  @override
  String get countryIsrael => 'Israel';

  @override
  String networkSpeedTestTesting(Object current, Object total, Object domain) {
    return 'Test $current/$total • $domain';
  }

  @override
  String get networkSpeedTestDone => 'Fertig';

  @override
  String get vpnFooterCustomisation => 'Anpassung';

  @override
  String get apkClipboardReportTitle => 'VTTI Cloud – APK-Analysebericht';

  @override
  String apkClipboardAppName(Object name) {
    return 'App-Name: $name';
  }

  @override
  String apkClipboardPackageId(Object packageId) {
    return 'Paket-ID: $packageId';
  }

  @override
  String apkClipboardVersion(Object version) {
    return 'Version: $version';
  }

  @override
  String apkClipboardFileSize(Object size) {
    return 'Dateigröße: $size';
  }

  @override
  String apkClipboardMinSdk(Object sdk) {
    return 'Min. SDK: $sdk';
  }

  @override
  String apkClipboardTargetSdk(Object sdk) {
    return 'Ziel-SDK: $sdk';
  }

  @override
  String apkClipboardSignature(Object signature) {
    return 'Signatur: $signature';
  }

  @override
  String apkClipboardMalwareRisk(Object risk) {
    return 'Malware-Risiko: $risk';
  }

  @override
  String apkClipboardRiskLabel(Object label) {
    return 'Risikoeinstufung: $label';
  }

  @override
  String apkClipboardHashVerdict(Object verdict) {
    return 'Hash-Bewertung: $verdict';
  }

  @override
  String apkClipboardRationale(Object rationale) {
    return 'Begründung: $rationale';
  }

  @override
  String get apkReportUnusualFlags => 'Ungewöhnliche Flags';

  @override
  String get apkReportUnverifiedItems => 'Nicht verifizierte Elemente';

  @override
  String get apkReportKnownMalware => 'Bekannte Malware';

  @override
  String get apkReportSuspiciousHash => 'Verdächtiger Hash';

  @override
  String get apkReportCleanHash => 'Sauberer Hash';

  @override
  String get apkReportHashNotChecked => 'Hash nicht geprüft';

  @override
  String get apkReportHashUnknown => 'Hash unbekannt';

  @override
  String get apkMetadataPackage => 'Paket';

  @override
  String get apkMetadataPackageId => 'Paket-ID';

  @override
  String get apkMetadataEngine => 'Engine';

  @override
  String get apkMetadataSize => 'Größe';

  @override
  String get apkMetadataMinSdk => 'Min. SDK';

  @override
  String get apkMetadataTargetSdk => 'Ziel-SDK';

  @override
  String get apkMetadataSignature => 'Signatur';

  @override
  String get apkAnalyserStageDeconstructing => 'APK wird zerlegt';

  @override
  String get apkAnalyserStageAnalysing => 'Inhalt wird analysiert';

  @override
  String get apkAnalyserSignInRequired =>
      'Bitte melde dich über die Einstellungen an, um Cloud Analysis zu verwenden.';

  @override
  String get apkAnalyserStageCheckingCloud => 'VTTI Cloud wird geprüft';

  @override
  String apkAnalyserDailyLimitReached(Object limit) {
    return 'Du hast dein tägliches Limit von $limit Analysen erreicht.';
  }

  @override
  String get apkAnalyserCloudAnalysisFailed => 'Cloud-Analyse fehlgeschlagen';

  @override
  String get apkAnalyserStageGeneratingReport => 'Bericht wird erstellt';

  @override
  String get apkAnalyserAnalysisFailed =>
      'APK-Analyse konnte nicht verarbeitet werden';

  @override
  String get genericError => 'Fehler';

  @override
  String get apkReportEngineVttiCloud => 'VTTI Cloud Engine';

  @override
  String get apkReportCertificateDetected => 'Zertifikat erkannt';

  @override
  String get apkReportNoCertificateData => 'Keine Zertifikatsdaten';

  @override
  String get apkExportOverview => 'Übersicht';

  @override
  String get apkExportMalwareAssessment => 'Malware-Bewertung';

  @override
  String get apkExportRiskScore => 'Risikowert';

  @override
  String get apkExportRiskLabel => 'Risikoeinstufung';

  @override
  String get apkExportHashVerdict => 'Hash-Bewertung';

  @override
  String get apkExportScoreRationale => 'Begründung des Risikowerts';

  @override
  String get apkExportContributingSignals => 'Beitragende Signale';

  @override
  String get apkExportDampeningFactors => 'Abschwächende Faktoren';

  @override
  String get apkExportPermissionsRequested => 'Angeforderte Berechtigungen';

  @override
  String get apkExportExtraFlagsUnusual => 'Zusätzliche Flags (ungewöhnlich)';

  @override
  String get apkExportExtraFlagsUnverified =>
      'Zusätzliche Flags (nicht verifiziert)';

  @override
  String get apkExportDiscoveredSources => 'Gefundene Quellen';

  @override
  String get apkExportRequestedPermissions => 'Angeforderte Berechtigungen';

  @override
  String get apkExportRationale => 'Begründung';

  @override
  String apkExportCsvShareText(Object name) {
    return 'APK-Analyse-CSV für $name';
  }

  @override
  String get apkExportPdfTitle => 'VTTI Cloud – APK-Analyse';

  @override
  String apkExportPdfShareText(Object name) {
    return 'APK-Analyse-PDF für $name';
  }

  @override
  String get apkMetadataAppName => 'App-Name';

  @override
  String get apkMetadataFileSize => 'Dateigröße';

  @override
  String get vpnBackendFailedOpenBrowser =>
      'Browser konnte nicht geöffnet werden.';

  @override
  String get vpnBackendSignedIn => 'Angemeldet.';

  @override
  String get vpnBackendSignedOut => 'Abgemeldet.';

  @override
  String get vpnBackendSessionExpiredSignIn =>
      'Sitzung abgelaufen. Bitte erneut anmelden.';

  @override
  String vpnBackendFailedLoadAccountStatus(Object status) {
    return 'Konto konnte nicht geladen werden ($status).';
  }

  @override
  String vpnBackendFailedLoadAccountError(Object error) {
    return 'Konto konnte nicht geladen werden ($error).';
  }

  @override
  String get vpnBackendSignInFirst => 'Bitte zuerst anmelden.';

  @override
  String get vpnBackendConnecting => 'Verbindung wird hergestellt...';

  @override
  String get vpnBackendNotificationsPermissionRequired =>
      'Benachrichtigungsberechtigung erforderlich.';

  @override
  String get vpnBackendPermissionNotGranted =>
      'VPN-Berechtigung nicht erteilt.';

  @override
  String get vpnBackendAnotherVpnActive =>
      'Ein anderes VPN ist aktiv. Deaktiviere es zuerst.';

  @override
  String get vpnBackendProvisionIncomplete =>
      'Bereitstellung hat unvollständige Einstellungen zurückgegeben.';

  @override
  String get vpnBackendSecuringConnection => 'Verbindung wird abgesichert...';

  @override
  String get vpnBackendConnected => 'Verbunden.';

  @override
  String vpnBackendWireGuardFailed(Object error) {
    return 'WireGuard konnte nicht gestartet werden ($error).';
  }

  @override
  String get vpnBackendDisconnecting => 'Verbindung wird getrennt...';

  @override
  String get vpnBackendDisconnected => 'Getrennt.';

  @override
  String vpnBackendSelectedServer(Object server) {
    return '$server ausgewählt';
  }

  @override
  String vpnBackendSwitchingServer(Object server) {
    return 'Wechsel zu $server...';
  }

  @override
  String get vpnBackendKeyNotFound => 'VPN-Schlüssel nicht gefunden.';

  @override
  String get vpnBackendDnsUpdated => 'DNS-Einstellungen aktualisiert.';

  @override
  String get vpnBackendSessionExpired => 'Sitzung abgelaufen.';

  @override
  String vpnBackendFailedStatus(Object status) {
    return 'Fehlgeschlagen ($status).';
  }

  @override
  String get vpnBackendPlanNotAllowed =>
      'Dein Tarif erlaubt die Nutzung von Full VPN nicht.';

  @override
  String vpnBackendProvisionFailed(Object status) {
    return 'Bereitstellung fehlgeschlagen ($status).';
  }
}
