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
  String get engineReadyBanner => 'VX-TITANIUM-v8';

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
  String get onboardingAppName => 'AVarionX Security';

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
  String quarantineDeleteDialogBody(Object count, Object plural) {
    return 'Dadurch werden $count Element$plural dauerhaft gelöscht.';
  }
}
