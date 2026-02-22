// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Polish (`pl`).
class AppLocalizationsPl extends AppLocalizations {
  AppLocalizationsPl([String locale = 'pl']) : super(locale);

  @override
  String get appName => 'AVarionX Security';

  @override
  String get ok => 'OK';

  @override
  String get cancel => 'Anuluj';

  @override
  String get footerHome => 'Główna';

  @override
  String get footerExplore => 'Eksploruj';

  @override
  String get footerRemoved => 'Usunięte';

  @override
  String get footerSettings => 'Ustawienia';

  @override
  String get proBadge => 'PRO';

  @override
  String get updateDbTitle => 'Aktualizowanie bazy danych';

  @override
  String updateDbVersionLabel(Object version) {
    return 'Wersja $version';
  }

  @override
  String get exploreMultiThreadingTitle => 'Multi-Threading';

  @override
  String get exploreMultiThreadingSubtitle => 'Experimental engine control';

  @override
  String get updateDbAutoDownloadLabel =>
      'Automatycznie pobieraj przyszłe aktualizacje';

  @override
  String get updateDbUpdatedAutoOn =>
      'Baza zaktualizowana • Auto-aktualizacje włączone';

  @override
  String get updateDbUpdatedSuccess => 'Baza danych zaktualizowana pomyślnie';

  @override
  String get updateDbUpdateFailed =>
      'Aktualizacja bazy danych nie powiodła się';

  @override
  String get engineReadyBanner => 'SILNIK GOTOWY • VX-TITANIUM-v7';

  @override
  String get scanButton => 'Skanuj';

  @override
  String get scanModeFullTitle => 'Pełny skan urządzenia';

  @override
  String get scanModeFullSubtitle =>
      'Skanuje wszystkie czytelne pliki w pamięci.';

  @override
  String get scanModeSmartTitle => 'Inteligentny skan [Zalecane]';

  @override
  String get scanModeSmartSubtitle =>
      'Skanuje pliki, które mogą zawierać malware.';

  @override
  String get scanModeRapidTitle => 'Szybki skan';

  @override
  String get scanModeRapidSubtitle =>
      'Sprawdza ostatnie pliki APK w Pobranych.';

  @override
  String get scanModeInstalledTitle => 'Zainstalowane aplikacje';

  @override
  String get scanModeInstalledSubtitle =>
      'Skanuje aplikacje pod kątem zagrożeń.';

  @override
  String get scanModeSingleTitle => 'Skanowanie pliku / aplikacji';

  @override
  String get scanModeSingleSubtitle =>
      'Wybierz plik lub aplikację do skanowania.';

  @override
  String get useCloudAssistedScan => 'Używaj skanowania wspomaganego chmurą';

  @override
  String get protectionTitle => 'Ochrona';

  @override
  String get stateOffLine1 => 'Ochrona urządzenia jest wyłączona';

  @override
  String get stateOffLine2 => 'Dotknij, aby włączyć';

  @override
  String get stateAdvancedActiveLine1 => 'Zaawansowana ochrona jest aktywna';

  @override
  String get stateFileOnlyLine1 => 'Tylko ochrona plików';

  @override
  String get stateFileOnlyLine2 => 'Ochrona sieci wyłączona';

  @override
  String get stateVpnConflictLine2 => 'Inny VPN jest aktywny';

  @override
  String get stateProtectedLine1 => 'Urządzenie chronione';

  @override
  String get stateProtectedLine2 => 'Dotknij, aby wyłączyć';

  @override
  String get dbUpdating => 'Aktualizowanie bazy...';

  @override
  String dbVersionAutoUpdated(Object version) {
    return 'Baza v$version • Auto-aktualizacja';
  }

  @override
  String get rtpInfoTitle => 'Ochrona w czasie rzeczywistym';

  @override
  String get rtpInfoBody =>
      'Oprócz blokowania podejrzanych plików pobranych celowo (lub przez malware), ochrona RTP używa lokalnego VPN do blokowania złośliwych domen w całym systemie.\n\nPo włączeniu filtrowanie sieci pozostaje aktywne, chyba że:\n• Zostanie wyłączone ręcznie w Terminalu\n• Zostanie zastąpione przez inny VPN\n\nOchrona plików kontynuuje działanie, dopóki RTP jest włączone.';

  @override
  String get scanTitleDefault => 'Skanuj';

  @override
  String get scanTitleSmart => 'Inteligentny skan';

  @override
  String get scanTitleRapid => 'Szybki skan';

  @override
  String get scanTitleInstalled => 'Skanuj zainstalowane aplikacje';

  @override
  String get scanTitleFull => 'Pełny skan urządzenia';

  @override
  String get scanTitleSingle => 'Pojedynczy skan';

  @override
  String get cancellingScan => 'Anulowanie skanowania…';

  @override
  String get cancelScan => 'Anuluj skanowanie';

  @override
  String get scanProgressZero => 'Postęp: 0%';

  @override
  String scanProgressWithPct(Object pct, Object scanned, Object total) {
    return 'Postęp: $pct% ($scanned / $total)';
  }

  @override
  String scanProgressFullItems(Object count) {
    return 'Przeskanowano: $count elementów';
  }

  @override
  String get initializing => 'Inicjowanie...';

  @override
  String get scanningEllipsis => 'Skanowanie...';

  @override
  String get fullScanInfoTitle => 'Pełny skan urządzenia';

  @override
  String get fullScanInfoBody =>
      'Ten tryb skanuje każdy czytelny plik w pamięci, bez filtrowania.\n\nSkanowanie wspomagane chmurą oraz skanowanie aplikacji nie są używane w tym trybie.';

  @override
  String get scanComplete => 'Skanowanie zakończone';

  @override
  String pillSuspiciousCount(Object count) {
    return 'Podejrzane: $count';
  }

  @override
  String pillCleanCount(Object count) {
    return 'Czyste: $count';
  }

  @override
  String pillScannedCount(Object count) {
    return 'Przeskanowano: $count';
  }

  @override
  String get resultNoThreatsTitle => 'Nie wykryto zagrożeń';

  @override
  String get resultNoThreatsBody =>
      'Nie wykryto zagrożeń w skanowanych elementach.';

  @override
  String get resultSuspiciousAppsTitle => 'Podejrzane aplikacje';

  @override
  String get resultSuspiciousItemsTitle => 'Podejrzane elementy';

  @override
  String get returnHome => 'Wróć do ekranu głównego';

  @override
  String get emptyTitle => 'Brak plików do skanowania';

  @override
  String get emptyBody =>
      'Twoje urządzenie nie zawiera plików spełniających kryteria skanowania.';

  @override
  String get knownMalware => 'Znane malware';

  @override
  String get suspiciousActivityDetected => 'Wykryto podejrzaną aktywność';

  @override
  String get maliciousActivityDetected => 'Wykryto złośliwą aktywność';

  @override
  String get androidBankingTrojan => 'Trojan bankowy (Android)';

  @override
  String get androidSpyware => 'Spyware (Android)';

  @override
  String get androidAdware => 'Adware (Android)';

  @override
  String get androidSmsFraud => 'Oszustwo SMS (Android)';

  @override
  String get threatLevelConfirmed => 'Potwierdzone';

  @override
  String get threatLevelHigh => 'Wysokie';

  @override
  String get threatLevelMedium => 'Średnie';

  @override
  String threatLevelLabel(Object level) {
    return 'Poziom zagrożenia: $level';
  }

  @override
  String get explainFoundInCloud =>
      'Ten element znajduje się w chmurowej bazie zagrożeń ColourSwift.';

  @override
  String get explainFoundInOffline =>
      'Ten element znajduje się w lokalnej bazie złośliwego oprogramowania na urządzeniu.';

  @override
  String get explainBanker =>
      'Zaprojektowany do kradzieży danych finansowych, często przy użyciu nakładek, rejestrowania klawiszy lub przechwytywania ruchu.';

  @override
  String get explainSpyware =>
      'Dyskretnie monitoruje aktywność lub zbiera dane osobowe, takie jak wiadomości, lokalizacja czy identyfikatory urządzenia.';

  @override
  String get explainAdware =>
      'Wyświetla natrętne reklamy, wykonuje przekierowania lub generuje nieuczciwy ruch reklamowy.';

  @override
  String get explainSmsFraud =>
      'Próbuje wysyłać lub wyzwalać działania SMS bez zgody użytkownika, co może powodować nieoczekiwane opłaty.';

  @override
  String get explainGenericMalware =>
      'Wykryto silne wskaźniki złośliwego działania, mimo że element nie pasuje do żadnej nazwanej rodziny.';

  @override
  String get explainSuspiciousDefault =>
      'Wykryto wskaźniki podejrzanego zachowania. Może to obejmować wzorce spotykane w malware, ale może to być również fałszywy alarm (false positive).';

  @override
  String get singleChoiceScanFile => 'Skanuj plik';

  @override
  String get singleChoiceScanInstalledApp => 'Skanuj zainstalowaną aplikację';

  @override
  String get singleChoiceManageExclusions => 'Zarządzaj wykluczeniami';

  @override
  String get labelKnownMalwareDb => 'Znaleziono w bazie malware';

  @override
  String get labelFoundInCloudDb => 'Znaleziono w bazie chmurowej';

  @override
  String get logEngineFullDeviceScan => '[ENGINE] Pełny skan urządzenia';

  @override
  String get logEngineTargetStorage => '[ENGINE] Cel: /storage/emulated/0';

  @override
  String get logEngineNoFilesFound => '[ENGINE] Nie znaleziono plików.';

  @override
  String logEngineFilesEnumerated(Object count) {
    return '[ENGINE] Wyliczone pliki: $count';
  }

  @override
  String get logEngineNoReadableFilesFound =>
      '[ENGINE] Nie znaleziono czytelnych plików.';

  @override
  String logEngineInstalledAppsFound(Object count) {
    return '[ENGINE] Znalezione zainstalowane aplikacje: $count';
  }

  @override
  String get logModeCloudAssisted => '[TRYB] Wspomagany chmurą';

  @override
  String get logModeOffline => '[TRYB] Offline';

  @override
  String get logStageHashing =>
      '[ETAP 1] Pobieranie skrótów plików (z bufora)...';

  @override
  String get logStageCloudLookup => '[ETAP 2] Sprawdzanie skrótów w chmurze...';

  @override
  String logStageLocalScanning(Object stage) {
    return '[ETAP $stage] Lokalne skanowanie plików...';
  }

  @override
  String logCloudHashHits(Object count) {
    return '[CHMURA] $count trafień skrótów';
  }

  @override
  String logSummary(Object suspicious, Object clean) {
    return '[PODSUMOWANIE] $suspicious podejrzane • $clean czyste';
  }

  @override
  String logErrorPrefix(Object message) {
    return '[BŁĄD] $message';
  }

  @override
  String get genericUnknownAppName => 'Nieznana';

  @override
  String get genericUnknownFileName => 'Nieznany';

  @override
  String get featuresDrawerTitle => 'Funkcje';

  @override
  String get recommendedSectionTitle => 'Zalecane';

  @override
  String get featureNetworkProtection => 'Ochrona sieci';

  @override
  String get featureLinkChecker => 'Skaner linków';

  @override
  String get featureMetaPass => 'MetaPass';

  @override
  String get featureCleanerPro => 'Cleaner Pro';

  @override
  String get featureTerminal => 'Terminal';

  @override
  String get featureScheduledScans => 'Planowane skanowania';

  @override
  String get networkStatusDisconnected => 'Disconnected';

  @override
  String get networkStatusConnecting => 'Connecting';

  @override
  String get networkStatusConnected => 'Połączono z null';

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
  String get recommendedMetaPassDesc => 'Generuj bezpieczne hasła offline.';

  @override
  String get recommendedCleanerProDesc =>
      'Znajdź duplikaty, stare media i nieużywane aplikacje, aby automatycznie odzyskać miejsce.';

  @override
  String get recommendedLinkCheckerDesc =>
      'Sprawdzaj podejrzane linki dzięki funkcji bezpiecznego widoku, bez ryzyka.';

  @override
  String get recommendedNetworkProtectionDesc =>
      'Chroń swoje połączenie internetowe przed złośliwym oprogramowaniem.';

  @override
  String get recommendedTerminalDesc => 'Zaawansowana funkcja dla Shizuku';

  @override
  String get recommendedScheduledScansDesc => 'Automatyczne skanowania w tle.';

  @override
  String get metaPassTitle => 'MetaPass';

  @override
  String get metaPassHowItWorks => 'Jak działa MetaPass';

  @override
  String get metaPassOk => 'OK';

  @override
  String get metaPassSettings => 'Ustawienia';

  @override
  String get metaPassPoweredBy => 'napędzane przez VX-TITANIUM';

  @override
  String get metaPassLoading => 'Ładowanie…';

  @override
  String get metaPassEmptyTitle => 'Brak wpisów';

  @override
  String get metaPassEmptyBody =>
      'Dodaj aplikację lub stronę.\nHasła są generowane na urządzeniu na podstawie Twojego hasła meta.';

  @override
  String get metaPassAddFirstEntry => 'Dodaj pierwszy wpis';

  @override
  String get metaPassTapToCopyHint =>
      'Dotknij, aby skopiować. Przytrzymaj, aby usunąć.';

  @override
  String get metaPassCopyTooltip => 'Kopiuj hasło';

  @override
  String get metaPassAdd => 'Dodaj';

  @override
  String get metaPassPickFromInstalledApps =>
      'Wybierz z zainstalowanych aplikacji';

  @override
  String get metaPassAddWebsiteOrLabel => 'Dodaj stronę lub własną etykietę';

  @override
  String get metaPassSelectApp => 'Wybierz aplikację';

  @override
  String get metaPassSearchApps => 'Szukaj aplikacji';

  @override
  String get metaPassCancel => 'Anuluj';

  @override
  String get metaPassContinue => 'Kontynuuj';

  @override
  String get metaPassSave => 'Zapisz';

  @override
  String get metaPassAddEntryTitle => 'Dodaj wpis';

  @override
  String get metaPassNameOrUrl => 'Nazwa lub URL';

  @override
  String get metaPassNameOrUrlHint => 'np. nextcloud, steam, przykład.pl';

  @override
  String get metaPassVersion => 'Wersja';

  @override
  String get metaPassLength => 'Długość';

  @override
  String get metaPassSetMetaTitle => 'Ustaw hasło Meta';

  @override
  String get metaPassSetMetaBody =>
      'Wprowadź swoje hasło meta. Nigdy nie opuszcza ono tego urządzenia. Wszystkie hasła w sejfie od niego zależą.';

  @override
  String get metaPassMetaLabel => 'Hasło meta';

  @override
  String get metaPassRememberThisDevice =>
      'Zapamiętaj na tym urządzeniu (bezpieczny zapis)';

  @override
  String get metaPassChangingMetaWarning =>
      'Zmiana hasła meta w przyszłości spowoduje zmianę wszystkich haseł. Użycie tego samego hasła przywróci je.';

  @override
  String get metaPassRemoveEntryTitle => 'Usuń wpis';

  @override
  String metaPassRemoveEntryBody(Object label) {
    return 'Usunąć „$label” z sejfu?';
  }

  @override
  String get metaPassRemove => 'Usuń';

  @override
  String metaPassPasswordCopied(Object label, Object version, Object length) {
    return 'Skopiowano hasło dla $label (v$version, $length znaków)';
  }

  @override
  String metaPassGenerateFailed(Object error) {
    return 'Nie udało się wygenerować hasła: $error';
  }

  @override
  String metaPassLoadAppsFailed(Object error) {
    return 'Nie udało się załadować aplikacji: $error';
  }

  @override
  String metaPassChars(Object length) {
    return '$length zn.';
  }

  @override
  String metaPassVersionShort(Object version) {
    return 'v$version';
  }

  @override
  String get metaPassInfoBody =>
      'Hasła nie są nigdzie przechowywane.\n\nKażdy wpis generuje hasło na podstawie:\n• Twojego hasła meta\n• Etykiety (nazwy)\n• Wersji i długości\n\nPonowna instalacja aplikacji z tym samym hasłem meta i tymi samymi etykietami wygeneruje identyczne hasła.';

  @override
  String get passwordSettingsTitle => 'Ustawienia haseł';

  @override
  String get passwordSettingsSectionMetaPass => 'MetaPass';

  @override
  String get passwordSettingsMetaPasswordTitle => 'Hasło meta';

  @override
  String get passwordSettingsMetaNotSet => 'Nie ustawiono';

  @override
  String get passwordSettingsMetaStoredSecurely =>
      'Zapisane bezpiecznie na urządzeniu';

  @override
  String get passwordSettingsChange => 'Zmień';

  @override
  String get passwordSettingsSetMetaPassTitle => 'Ustaw MetaPass';

  @override
  String get passwordSettingsMetaPasswordLabel => 'Hasło meta';

  @override
  String get passwordSettingsChangingAltersAll =>
      'Zmiana tego hasła zmienia wszystkie hasła wyjściowe.\nUżycie pierwotnego MetaPass przywróci je.';

  @override
  String get passwordSettingsCancel => 'Anuluj';

  @override
  String get passwordSettingsSave => 'Zapisz';

  @override
  String get passwordSettingsSectionRestoreCode => 'Kod odzyskiwania';

  @override
  String get passwordSettingsGenerateRestoreCode => 'Generuj kod odzyskiwania';

  @override
  String get passwordSettingsCopy => 'Kopiuj';

  @override
  String get passwordSettingsRestoreCodeCopied => 'Kod odzyskiwania skopiowany';

  @override
  String get passwordSettingsSectionRestoreFromCode => 'Przywróć z kodu';

  @override
  String get passwordSettingsRestoreCodeLabel => 'Kod odzyskiwania';

  @override
  String get passwordSettingsRestore => 'Przywróć';

  @override
  String get passwordSettingsVaultRestored => 'Sejf przywrócony';

  @override
  String get passwordSettingsFooterInfo =>
      'Hasła nigdy nie są przechowywane.\n\nKod odzyskiwania zawiera tylko strukturę danych. W połączeniu z hasłem MetaPass pozwala odbudować Twój sejf.';

  @override
  String get onboardingAppName => 'AVarionX Security';

  @override
  String get onboardingStorageTitle => 'Dostęp do plików';

  @override
  String get onboardingStorageDesc =>
      'To uprawnienie jest wymagane do skanowania plików na Twoim urządzeniu. Możesz je nadać teraz lub później.';

  @override
  String get onboardingStorageFootnote =>
      'Możesz to pominąć, ale zostaniesz o to zapytany ponownie przy wyborze trybu skanowania.';

  @override
  String get onboardingStorageSnack =>
      'Uprawnienie do plików jest wymagane do skanowania.';

  @override
  String get onboardingNotificationsTitle => 'Powiadomienia';

  @override
  String get onboardingNotificationsDesc =>
      'Używane do alertów w czasie rzeczywistym, statusu skanowania i powiadomień o kwarantannie.';

  @override
  String get onboardingNotificationsFootnote =>
      'Wymagane przez system Android dla poprawnego działania RTP.';

  @override
  String get onboardingNetworkTitle => 'Ochrona sieci';

  @override
  String get onboardingNetworkDesc =>
      'Umożliwia ochronę Wi-Fi za pomocą uprawnienia VPN systemu Android.';

  @override
  String get onboardingNetworkFootnote =>
      'To działanie jest opcjonalne, ale zalecane.';

  @override
  String get onboardingGranted => 'Przyznano';

  @override
  String get onboardingNotGranted => 'Nie przyznano';

  @override
  String get onboardingGrantAccess => 'Przyznaj dostęp';

  @override
  String get onboardingAllowNotifications => 'Zezwól na powiadomienia';

  @override
  String get onboardingAllowVpnAccess => 'Zezwól na dostęp VPN';

  @override
  String get onboardingBack => 'Wstecz';

  @override
  String get onboardingNext => 'Dalej';

  @override
  String get onboardingFinish => 'Zakończ';

  @override
  String get onboardingSetupCompleteTitle => 'Konfiguracja zakończona';

  @override
  String get onboardingSetupCompleteDesc =>
      'Zalecamy uruchomienie Pełnego skanu urządzenia (obecnie nie obejmuje skanowania zainstalowanych aplikacji) lub przejście prosto do ekranu głównego.';

  @override
  String get onboardingRunFullScan => 'Uruchom pełny skan';

  @override
  String get onboardingGoHome => 'Przejdź do strony głównej';

  @override
  String get networkProtectionTitle => 'Ochrona sieci';

  @override
  String networkStatusConnectedToDns(Object dns) {
    return 'Connected to $dns';
  }

  @override
  String get networkStatusVpnConflictDetail => 'Another VPN is active';

  @override
  String get networkStatusOffDetail => 'Network protection is off';

  @override
  String get networkModeMalwareTitle => 'Tylko blokowanie malware';

  @override
  String get networkModeMalwareSubtitle => 'Używa 1.1.1.2';

  @override
  String get networkModeMalwareDescription =>
      'Łączy lokalną bazę malware AVarionX z chmurową inteligencją Cloudflare dla maksymalnej ochrony przed zagrożeniami.';

  @override
  String get networkModeAdultTitle => 'Malware i treści dla dorosłych';

  @override
  String get networkModeAdultSubtitle => 'Używa 1.1.1.3';

  @override
  String get networkModeAdultDescription =>
      'Używa lokalnej bazy malware AVarionX i dodaje filtrowanie treści dla dorosłych. Inteligencja chmurowa jest wyłączona w tym trybie.';

  @override
  String get networkInfoTitle => 'Czym jest Ochrona sieci?';

  @override
  String get networkInfoBody =>
      'Niektóre zagrożenia działają poprzez łączenie się ze złośliwymi serwerami lub przekierowywanie ruchu internetowego.\nOchrona sieci blokuje znane niebezpieczne domeny i typowe reklamy przy użyciu lokalnego połączenia VPN.\n\nAVarionX Security nie gromadzi żadnych danych.';

  @override
  String get linkCheckerTitle => 'Skaner linków';

  @override
  String get linkCheckerTabAnalyse => 'Analizuj';

  @override
  String get linkCheckerTabView => 'Widok';

  @override
  String get linkCheckerTabHistory => 'Historia';

  @override
  String get linkCheckerAnalyseSubtitle =>
      'Sprawdź stronę pod kątem malware lub podejrzanych treści';

  @override
  String get linkCheckerUrlLabel => 'URL';

  @override
  String get linkCheckerUrlHint => 'https://przykład.pl';

  @override
  String get linkCheckerButtonAnalyse => 'Analizuj';

  @override
  String get linkCheckerButtonChecking => 'Sprawdzanie';

  @override
  String get linkCheckerEngineNotReadySnack => 'Silnik niegotowy';

  @override
  String get linkCheckerStatusVerifyingLink => 'Weryfikowanie linku…';

  @override
  String get linkCheckerStatusScanningPage => 'Skanowanie strony…';

  @override
  String get linkCheckerBlockedNavigation => 'Nawigacja zablokowana';

  @override
  String get linkCheckerBlockedUnsupportedType => 'Nieobsługiwany typ linku';

  @override
  String get linkCheckerBlockedInvalidDestination => 'Nieprawidłowy cel';

  @override
  String get linkCheckerBlockedUnableResolve => 'Nie można rozwiązać celu';

  @override
  String get linkCheckerBlockedUnableVerify => 'Nie można zweryfikować celu';

  @override
  String get linkCheckerAnalyseCardTitleDefault =>
      'Sprawdź stronę pod kątem podejrzanych treści';

  @override
  String get linkCheckerAnalyseCardDetailDefault =>
      'Wklej adres URL i uruchom analizę.';

  @override
  String get linkCheckerAnalyseCardTitleEngineNotReady => 'Silnik niegotowy';

  @override
  String get linkCheckerAnalyseCardDetailEngineNotReady => 'błąd 1001.';

  @override
  String get linkCheckerAnalyseCardTitleChecking => 'Sprawdzanie';

  @override
  String get linkCheckerVerdictClean => 'Bezpieczny';

  @override
  String get linkCheckerVerdictCleanDetail =>
      'Ta strona wydaje się być bezpieczna.';

  @override
  String get linkCheckerVerdictSuspicious => 'Podejrzany';

  @override
  String get linkCheckerVerdictSuspiciousDetail =>
      'Ta strona zawiera podejrzane treści.';

  @override
  String get linkCheckerViewLockedBody =>
      'Najpierw przeprowadź analizę, aby umożliwić podgląd.';

  @override
  String get linkCheckerViewSubtitle => 'Wyświetl stronę bezpiecznie';

  @override
  String get linkCheckerViewPage => 'Wyświetl stronę';

  @override
  String get linkCheckerClose => 'Zamknij';

  @override
  String get linkCheckerBlockedBody =>
      'Ta strona została zatrzymana przed załadowaniem.';

  @override
  String get linkCheckerSuspiciousBanner =>
      'Podejrzany link, strona może nie renderować się poprawnie ze względu na blokadę treści.';

  @override
  String get linkCheckerHistorySubtitle => 'Dotknij wpisu, aby skopiować link.';

  @override
  String get linkCheckerHistoryEmpty => 'Brak historii sprawdzeń.';

  @override
  String get linkCheckerCopied => 'Skopiowano';

  @override
  String get settingsSectionAppearance => 'Wygląd';

  @override
  String get settingsTheme => 'Motyw';

  @override
  String settingsThemeCurrent(Object theme) {
    return 'Aktualny: $theme';
  }

  @override
  String get settingsLanguage => 'Język';

  @override
  String settingsLanguageCurrent(Object language) {
    return 'Aktualny: $language';
  }

  @override
  String get settingsChooseLanguage => 'Wybierz język';

  @override
  String get settingsLanguageApplied => 'Język został zmieniony';

  @override
  String get settingsSystemDefault => 'Systemowy';

  @override
  String get settingsSectionCommunity => 'Dołącz do społeczności!';

  @override
  String get settingsDiscord => 'Discord';

  @override
  String get settingsDiscordSubtitle => 'Czat, aktualizacje i opinie';

  @override
  String get settingsDiscordOpenFail => 'Nie można otworzyć linku Discord';

  @override
  String get settingsSectionPro => 'Funkcje PRO';

  @override
  String get settingsProCustomization => 'Personalizacja PRO';

  @override
  String get settingsProSubtitle => 'Usuń reklamy i odblokuj motywy oraz ikony';

  @override
  String get settingsUnlockPro => 'Odblokuj PRO';

  @override
  String get settingsProUnlocked => 'Tryb PRO odblokowany';

  @override
  String get settingsPurchaseNotConfirmed => 'Zakup nie został potwierdzony';

  @override
  String settingsPurchaseFailed(Object error) {
    return 'Zakup nie powiódł się: $error';
  }

  @override
  String get proActivated => 'PRO activated';

  @override
  String get proDeactivated => 'PRO deactivated';

  @override
  String get settingsProReset => 'Reset PRO (tylko debug)';

  @override
  String get settingsProSheetTitle => 'Personalizacja PRO';

  @override
  String get settingsHideGoldHeader =>
      'Ukryj złoty nagłówek na ekranie głównym';

  @override
  String get settingsAppIcon => 'Ikona aplikacji';

  @override
  String settingsIconSelected(Object icon) {
    return 'Wybrana ikona: $icon';
  }

  @override
  String get settingsSave => 'Zapisz';

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
  String get settingsSectionShizuku => 'Zaawansowana ochrona (Shizuku)';

  @override
  String get settingsEnableShizuku => 'Włącz Shizuku';

  @override
  String get settingsShizukuRequiresManager => 'Wymaga zewnętrznego menedżera';

  @override
  String get settingsShizukuNotRunning => 'Usługa Shizuku nie jest uruchomiona';

  @override
  String get settingsShizukuPermissionRequired => 'Wymagane uprawnienie';

  @override
  String get settingsShizukuAvailable =>
      'Zaawansowany dostęp systemowy dostępny';

  @override
  String get settingsAboutAdvancedProtection => 'O zaawansowanej ochronie';

  @override
  String get settingsAboutAdvancedProtectionSubtitle =>
      'Dowiedz się, jak działa zaawansowana ochrona';

  @override
  String get settingsAdvancedProtectionDialogTitle =>
      'Zaawansowana ochrona systemu';

  @override
  String get settingsAdvancedProtectionDialogBody =>
      'Dostęp Shizuku wymaga zewnętrznego menedżera i jest przeznaczony dla zaawansowanych użytkowników.\n\nTa funkcja jest opcjonalna i nie jest zalecana do standardowej ochrony.';

  @override
  String get settingsAboutShizukuTitle => 'O Shizuku';

  @override
  String get settingsAboutShizukuBody =>
      'AVarionX może zintegrować się z Shizuku, aby uzyskać dostęp do procesów aplikacji na poziomie systemowym.\n\nPozwala to aplikacji na:\n• Wykrywanie malware ukrywającego się przed standardowymi skanerami\n• Inspekcję uruchomionych procesów aplikacji\n• Wyłączanie lub izolowanie aktywnego malware\n\nShizuku nie nadaje jednak pełnego dostępu Root.\n\nTa funkcja jest przeznaczona dla zaawansowanych użytkowników i nie jest wymagana do normalnej ochrony.\n\nDokumentacja:\nhttps://shizuku.rikka.app';

  @override
  String get settingsSectionGeneral => 'Ogólne';

  @override
  String get settingsExclusions => 'Wykluczenia';

  @override
  String get settingsExclusionsSubtitle =>
      'Zarządzaj wykluczeniami i dodawaj nowe';

  @override
  String get settingsExcludeFolder => 'Wyklucz folder';

  @override
  String get settingsExcludeFile => 'Wyklucz plik';

  @override
  String get settingsManageExclusions => 'Zarządzaj istniejącymi wykluczeniami';

  @override
  String get settingsManageExclusionsSubtitle =>
      'Wyświetl lub usuń wykluczenia';

  @override
  String get settingsFolderExcluded => 'Folder wykluczony';

  @override
  String get settingsFileExcluded => 'Plik wykluczony';

  @override
  String get settingsPrivacyPolicy => 'Polityka prywatności';

  @override
  String get settingsPrivacyPolicySubtitle =>
      'Zobacz, jak przetwarzane są Twoje dane';

  @override
  String get settingsPrivacyPolicyOpenFail =>
      'Nie można otworzyć polityki prywatności';

  @override
  String get settingsAboutApp => 'O aplikacji AVarionX';

  @override
  String get settingsHowThisAppWorks => 'Jak działa ta aplikacja';

  @override
  String get settingsHowThisAppWorksSubtitle =>
      'Dowiedz się więcej o mechanizmach ochrony';

  @override
  String get settingsThemePickerTitle => 'Wybierz motyw';

  @override
  String get settingsThemeRequiresPro => 'Ten motyw wymaga trybu PRO';

  @override
  String get scheduledScansTitle => 'Planowane skanowania';

  @override
  String get scheduledScansInfoTitle => 'Planowane skanowania';

  @override
  String get scheduledScansInfoBody =>
      'Podczas gdy RTP skupia się na nowo pobranym malware, planowane skanowania automatycznie uruchomią wybrany tryb skanowania w tle.\nFunkcja działa tylko wtedy, gdy RTP jest włączone.\n\nUżytkownicy PRO mogą dostosować tryb i częstotliwość skanowania.';

  @override
  String get scheduledScansHeader => 'Automatyczne skanowania w tle';

  @override
  String get scheduledScansSubheader =>
      'Gdy ochrona RTP jest aktywna, aplikacja będzie skanować urządzenie zgodnie z wybranym trybem i harmonogramem.';

  @override
  String get proRequiredToCustomize => 'Wymagane PRO do personalizacji';

  @override
  String get scheduledScansEnabledTitle => 'Włączone';

  @override
  String get scheduledScansEnabledSubtitle =>
      'Gdy włączone, skanowanie odbywa się automatycznie zgodnie z harmonogramem.';

  @override
  String get scheduledScansModeTitle => 'Tryb skanowania';

  @override
  String scheduledScansModeHint(Object mode) {
    return 'Aktualny tryb: $mode';
  }

  @override
  String get scheduledScansFrequencyTitle => 'Częstotliwość';

  @override
  String scheduledScansFrequencyHint(Object freq) {
    return 'Uruchamia się: $freq';
  }

  @override
  String get scheduledEveryDay => 'Codziennie';

  @override
  String get scheduledEvery3Days => 'Co 3 dni';

  @override
  String get scheduledEveryWeek => 'Co tydzień';

  @override
  String get scheduledEvery2Weeks => 'Co 2 tygodnie';

  @override
  String get scheduledEvery3Weeks => 'Co 3 tygodnie';

  @override
  String get scheduledMonthly => 'Raz w miesiącu';

  @override
  String scheduledEveryDays(Object days) {
    return 'Co $days dni';
  }

  @override
  String scheduledEveryHours(Object hours) {
    return 'Co $hours godz.';
  }

  @override
  String get scheduledChargingOnlyTitle => 'Tylko podczas ładowania';

  @override
  String get scheduledChargingOnlySubtitle =>
      'Uruchamiaj planowane skanowanie tylko wtedy, gdy urządzenie jest podłączone do zasilania.';

  @override
  String get scheduledPreferredTimeTitle => 'Preferowany czas';

  @override
  String get scheduledPreferredTimeSubtitle =>
      'AVarionX spróbuje uruchomić skanowanie o tej porze. System Android może opóźnić start, aby oszczędzać baterię.';

  @override
  String get scheduledPickTime => 'Wybierz czas';

  @override
  String get cleanerTitle => 'Cleaner Pro';

  @override
  String get cleanerReadyToScan => 'Gotowy do skanowania';

  @override
  String get cleanerScan => 'Skanuj';

  @override
  String get cleanerScanning => 'Skanowanie…';

  @override
  String get cleanerReady => 'Gotowe';

  @override
  String get cleanerStatusReady => 'Gotowy';

  @override
  String get cleanerStatusStarting => 'Uruchamianie…';

  @override
  String get cleanerStatusFilesScanned => 'Pliki przeskanowane';

  @override
  String get cleanerStatusFindingUnusedApps =>
      'Szukanie nieużywanych aplikacji…';

  @override
  String get cleanerStatusComplete => 'Zakończono';

  @override
  String get cleanerStatusScanError => 'Błąd skanowania';

  @override
  String get cleanerStatusScanningApps => 'Skanowanie aplikacji…';

  @override
  String get cleanerGrantUsageAccessTitle => 'Nadaj dostęp do użycia';

  @override
  String get cleanerGrantUsageAccessBody =>
      'Aby wykryć nieużywane aplikacje, Cleaner wymaga uprawnienia „Dostęp do danych o użyciu”. Zostaniesz przekierowany do ustawień systemowych, aby je włączyć.';

  @override
  String get cleanerCancel => 'Anuluj';

  @override
  String get cleanerContinue => 'Kontynuuj';

  @override
  String get cleanerDuplicates => 'Duplikaty';

  @override
  String get cleanerDuplicatesNone => 'Nie znaleziono duplikatów';

  @override
  String cleanerDuplicatesSubtitle(Object count, Object size) {
    return '$count elementów • odzyskaj $size';
  }

  @override
  String get cleanerOldPhotos => 'Stare zdjęcia';

  @override
  String cleanerOldPhotosNone(Object days) {
    return 'Brak zdjęć starszych niż $days dni';
  }

  @override
  String cleanerOldPhotosSubtitle(Object count, Object size) {
    return '$count elementów • $size';
  }

  @override
  String get cleanerOldVideos => 'Stare filmy';

  @override
  String cleanerOldVideosNone(Object days) {
    return 'Brak filmów starszych niż $days dni';
  }

  @override
  String cleanerOldVideosSubtitle(Object count, Object size) {
    return '$count elementów • $size';
  }

  @override
  String get cleanerLargeFiles => 'Duże pliki';

  @override
  String cleanerLargeFilesNone(Object size) {
    return 'Brak plików ≥ $size';
  }

  @override
  String cleanerLargeFilesSubtitle(Object count, Object sizeTotal) {
    return '$count elementów • $sizeTotal';
  }

  @override
  String get cleanerUnusedApps => 'Nieużywane aplikacje';

  @override
  String cleanerUnusedAppsNone(Object days) {
    return 'Brak nieużywanych aplikacji (ostatnie $days dni)';
  }

  @override
  String cleanerUnusedAppsCount(Object count) {
    return '$count aplikacji';
  }

  @override
  String get cleanerStageDuplicates => 'Skanowanie duplikatów…';

  @override
  String get cleanerStageDuplicatesGrouping => 'Grupowanie duplikatów…';

  @override
  String get cleanerStageOldPhotos => 'Skanowanie starych zdjęć…';

  @override
  String get cleanerStageOldVideos => 'Skanowanie starych filmów…';

  @override
  String get cleanerStageLargeFiles => 'Skanowanie dużych plików…';

  @override
  String cleanerStageOldPhotosProgress(Object count, Object size) {
    return 'Stare zdjęcia: $count • $size';
  }

  @override
  String cleanerStageOldVideosProgress(Object count, Object size) {
    return 'Stare filmy: $count • $size';
  }

  @override
  String cleanerStageLargeFilesProgress(Object count, Object size) {
    return 'Duże pliki: $count • $size';
  }

  @override
  String get unusedAppsTitle => 'Nieużywane aplikacje';

  @override
  String unusedAppsEmpty(Object days) {
    return 'Brak nieużywanych aplikacji w ciągu ostatnich $days dni';
  }

  @override
  String get quarantineTitle => 'Usunięte';

  @override
  String get quarantineSelectAll => 'Zaznacz wszystko';

  @override
  String get quarantineRefresh => 'Odśwież';

  @override
  String get quarantineEmptyTitle => 'Brak usuniętych plików';

  @override
  String get quarantineEmptyBody =>
      'Wszystkie pliki, które usuniesz, pojawią się tutaj.';

  @override
  String get quarantineRestore => 'Przywróć';

  @override
  String get quarantineDelete => 'Usuń';

  @override
  String get quarantineSnackRestored => 'Przywrócono';

  @override
  String get quarantineSnackDeleted => 'Usunięto';

  @override
  String get quarantineDeleteDialogTitle => 'Usunąć zaznaczone pliki?';

  @override
  String quarantineDeleteDialogBody(Object count, Object plural) {
    return 'To trwale usunie $count element$plural.';
  }
}
