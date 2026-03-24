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
  String get proBadge => 'Premium';

  @override
  String get updateDbTitle => 'Aktualizowanie bazy danych';

  @override
  String updateDbVersionLabel(Object version) {
    return 'Wersja $version';
  }

  @override
  String get exploreMultiThreadingTitle => 'Wielowątkowość';

  @override
  String get exploreMultiThreadingSubtitle =>
      'Eksperymentalna kontrola silnika';

  @override
  String get updateDbAutoDownloadLabel =>
      'Automatycznie pobieraj przyszłe aktualizacje';

  @override
  String get updateDbUpdatedAutoOn =>
      'Baza zaktualizowana • Automatyczne aktualizacje włączone';

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
      'Skanuje zainstalowane aplikacje pod kątem zagrożeń.';

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
  String get dbUpdating => 'Aktualizowanie bazy danych';

  @override
  String dbVersionAutoUpdated(Object version) {
    return 'Baza v$version • Zaktualizowano automatycznie';
  }

  @override
  String get rtpInfoTitle => 'Ochrona w czasie rzeczywistym';

  @override
  String get rtpInfoBody =>
      'Oprócz blokowania podejrzanych plików pobranych celowo (lub przez malware), RTP używa lokalnego VPN do blokowania złośliwych domen w całym systemie.\n\nPo włączeniu filtrowanie sieci pozostaje aktywne, chyba że:\n• Zostanie wyłączone ręcznie w Terminalu\n• Zostanie zastąpione przez inny VPN\n\nOchrona plików działa nadal, o ile RTP jest włączone.';

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
      'Ten tryb skanuje każdy czytelny plik w pamięci, bez filtrowania.\n\nSkanowanie wspomagane chmurą i skanowanie aplikacji nie są używane w tym trybie.';

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
      'Nie wykryto zagrożeń w przeskanowanych elementach.';

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
  String get androidBankingTrojan => 'Trojan bankowy Android';

  @override
  String get androidSpyware => 'Spyware Android';

  @override
  String get androidAdware => 'Adware Android';

  @override
  String get androidSmsFraud => 'Oszustwo SMS Android';

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
      'Ten element znajduje się w lokalnej bazie malware na urządzeniu.';

  @override
  String get explainBanker =>
      'Zaprojektowany do kradzieży danych finansowych, często przy użyciu nakładek, keyloggera lub przechwytywania ruchu.';

  @override
  String get explainSpyware =>
      'Po cichu monitoruje aktywność lub zbiera dane osobowe, takie jak wiadomości, lokalizacja lub identyfikatory urządzenia.';

  @override
  String get explainAdware =>
      'Wyświetla natrętne reklamy, wykonuje przekierowania lub generuje fałszywy ruch reklamowy.';

  @override
  String get explainSmsFraud =>
      'Próbuje wysyłać lub wyzwalać działania SMS bez zgody użytkownika, co może powodować nieoczekiwane opłaty.';

  @override
  String get explainGenericMalware =>
      'Wykryto silne wskaźniki złośliwego działania, mimo że element nie pasuje do nazwanej rodziny.';

  @override
  String get explainSuspiciousDefault =>
      'Wykryto wskaźniki podejrzanego zachowania. Może to obejmować wzorce spotykane w malware, ale może to być też fałszywy alarm.';

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
      '[ETAP 1] Pobieranie skrótów plików (z cache)...';

  @override
  String get logStageCloudLookup =>
      '[ETAP 2] Wyszukiwanie skrótów w chmurze...';

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
  String get networkStatusDisconnected => 'Rozłączono';

  @override
  String get networkStatusConnecting => 'Łączenie';

  @override
  String get networkStatusConnected => 'Połączono';

  @override
  String get networkUsageTitle => 'Użycie';

  @override
  String get networkUsageEnableVpnToView => 'Włącz VPN, aby zobaczyć użycie.';

  @override
  String get networkUsageUnlimited => 'Bez limitu';

  @override
  String networkUsageUsedOf(Object used, Object limit) {
    return '$used / $limit';
  }

  @override
  String networkUsageResetsOn(Object y, Object m, Object d) {
    return 'Reset dnia $y-$m-$d';
  }

  @override
  String networkUsageUpdatedAt(Object hh, Object mm) {
    return 'Zaktualizowano $hh:$mm';
  }

  @override
  String get networkCardStatusAvailable => 'Dostępne';

  @override
  String get networkCardStatusDisabled => 'Wyłączone';

  @override
  String get networkCardStatusCustom => 'Własne';

  @override
  String get networkCardStatusReady => 'Gotowe';

  @override
  String get networkCardStatusOpen => 'Otwórz';

  @override
  String get networkCardStatusComingSoon => 'Wkrótce';

  @override
  String get networkCardBlocklistsTitle => 'Listy blokowania';

  @override
  String get networkCardBlocklistsSubtitle => 'Kontrola filtrowania';

  @override
  String get networkCardUpstreamTitle => 'Upstream';

  @override
  String get networkCardUpstreamSubtitle => 'Wybór resolvera';

  @override
  String get networkCardAppsTitle => 'Aplikacje';

  @override
  String get networkCardAppsSubtitle => 'Blokuj aplikacje w WiFi';

  @override
  String get networkCardLogsTitle => 'Logi';

  @override
  String get networkCardLogsSubtitle => 'Zdarzenia DNS na żywo';

  @override
  String get networkCardSpeedTitle => 'Prędkość';

  @override
  String get networkCardSpeedSubtitle => 'Test DNS';

  @override
  String get networkCardAboutTitle => 'O projekcie';

  @override
  String get networkCardAboutSubtitle => 'GitHub';

  @override
  String get networkLogsStatusNoActivity => 'Brak aktywności';

  @override
  String networkLogsStatusRecent(Object count) {
    return '$count ostatnich';
  }

  @override
  String get networkResolverTitle => 'Resolver';

  @override
  String get networkResolverIpLabel => 'IP resolvera';

  @override
  String get networkResolverIpHint => 'Przykład: 1.1.1.1';

  @override
  String get networkSpeedTestTitle => 'Test prędkości';

  @override
  String get networkSpeedTestBody =>
      'Uruchamia tester prędkości DNS z bieżącymi ustawieniami.';

  @override
  String get networkSpeedTestRun => 'Uruchom test prędkości';

  @override
  String get networkBlocklistsRecommendedTitle => 'Zalecane';

  @override
  String get networkBlocklistsCsMalwareTitle => 'ColourSwift Malware';

  @override
  String get networkBlocklistsCsAdsTitle => 'Reklamy ColourSwift';

  @override
  String get networkBlocklistsSeeGithub => 'Zobacz szczegóły na GitHub...';

  @override
  String get networkBlocklistsMalwareSection => 'Malware';

  @override
  String get networkBlocklistsMalwareTitle => 'Lista blokowania malware';

  @override
  String get networkBlocklistsMalwareSources =>
      'HaGeZi TIF • URLHaus • DigitalSide • Spam404';

  @override
  String get networkBlocklistsAdsSection => 'Reklamy';

  @override
  String get networkBlocklistsAdsTitle => 'Lista blokowania reklam';

  @override
  String get networkBlocklistsAdsSources =>
      'OISD • AdAway • Yoyo • AnudeepND • Firebog AdGuard';

  @override
  String get networkBlocklistsTrackersSection => 'Trackery';

  @override
  String get networkBlocklistsTrackersTitle => 'Lista blokowania trackerów';

  @override
  String get networkBlocklistsTrackersSources =>
      'EasyPrivacy • Disconnect • Frogeye • Perflyst • WindowsSpyBlocker';

  @override
  String get networkBlocklistsGamblingSection => 'Hazard';

  @override
  String get networkBlocklistsGamblingTitle => 'Lista blokowania hazardu';

  @override
  String get networkBlocklistsGamblingSources => 'HaGeZi Gambling';

  @override
  String get networkBlocklistsSocialSection => 'Media społecznościowe';

  @override
  String get networkBlocklistsSocialTitle =>
      'Lista blokowania mediów społecznościowych';

  @override
  String get networkBlocklistsSocialSources => 'HaGeZi Social';

  @override
  String get networkBlocklistsAdultSection => '18+';

  @override
  String get networkBlocklistsAdultTitle =>
      'Lista blokowania treści dla dorosłych';

  @override
  String get networkBlocklistsAdultSources => 'StevenBlack 18+ • HaGeZi NSFW';

  @override
  String get networkLiveLogsTitle => 'Logi na żywo';

  @override
  String get networkLiveLogsEmpty => 'Brak żądań.';

  @override
  String get networkLiveLogsBlocked => 'Zablokowano';

  @override
  String get networkLiveLogsAllowed => 'Dozwolone';

  @override
  String get recommendedMetaPassDesc => 'Generuj bezpieczne hasła offline.';

  @override
  String get recommendedCleanerProDesc =>
      'Znajdź duplikaty, stare media i nieużywane aplikacje, aby automatycznie odzyskać miejsce.';

  @override
  String get recommendedLinkCheckerDesc =>
      'Sprawdzaj podejrzane linki dzięki bezpiecznemu widokowi, bez ryzyka.';

  @override
  String get recommendedNetworkProtectionDesc =>
      'Chroń swoje połączenie internetowe przed malware.';

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
      'Zmiana tego później zmieni wszystkie generowane hasła. Użycie tego samego hasła meta przywróci je.';

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
      'Hasła nigdy nie są przechowywane.\n\nKażdy wpis generuje hasło na podstawie:\n• Twojego hasła meta\n• Etykiety (nazwy)\n• Wersji i długości\n\nPonowna instalacja aplikacji z tym samym hasłem meta i tymi samymi etykietami wygeneruje identyczne hasła.';

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
      'Zmiana tego zmienia wszystkie hasła.\nUżycie tego samego MetaPass przywróci je.';

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
      'Hasła nigdy nie są przechowywane.\n\nKod odzyskiwania zawiera tylko dane struktury. W połączeniu z Twoim MetaPass odtworzy sejf.';

  @override
  String get onboardingAppName => 'AVarionX Security';

  @override
  String get onboardingStorageTitle => 'Dostęp do pamięci';

  @override
  String get onboardingStorageDesc =>
      'To uprawnienie jest wymagane do skanowania plików na urządzeniu. Możesz je nadać teraz lub później.';

  @override
  String get onboardingStorageFootnote =>
      'Możesz to pominąć, ale zostaniesz o to poproszony ponownie przy wyborze trybu skanowania.';

  @override
  String get onboardingStorageSnack =>
      'Uprawnienie do pamięci jest wymagane do skanowania.';

  @override
  String get onboardingNotificationsTitle => 'Powiadomienia';

  @override
  String get onboardingNotificationsDesc =>
      'Używane do alertów w czasie rzeczywistym, statusu skanowania i aktualizacji kwarantanny.';

  @override
  String get onboardingNotificationsFootnote =>
      'Wymagane przez Androida dla ochrony w czasie rzeczywistym.';

  @override
  String get onboardingNetworkTitle => 'Ochrona sieci';

  @override
  String get onboardingNetworkDesc =>
      'Włącza ochronę Wi Fi przy użyciu uprawnienia VPN Androida.';

  @override
  String get onboardingNetworkFootnote => 'To opcjonalne, ale zalecane.';

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
      'Zalecamy uruchomienie pełnego skanu urządzenia (obecnie nie skanuje zainstalowanych aplikacji) albo przejście od razu do ekranu głównego.';

  @override
  String get onboardingRunFullScan => 'Uruchom pełny skan urządzenia';

  @override
  String get onboardingGoHome => 'Przejdź do ekranu głównego';

  @override
  String get networkProtectionTitle => 'Ochrona sieci';

  @override
  String networkStatusConnectedToDns(Object dns) {
    return 'Połączono z $dns';
  }

  @override
  String get networkStatusVpnConflictDetail => 'Inny VPN jest aktywny';

  @override
  String get networkStatusOffDetail => 'Ochrona sieci jest wyłączona';

  @override
  String get networkModeMalwareTitle => 'Tylko blokowanie malware';

  @override
  String get networkModeMalwareSubtitle => 'Używa 1.1.1.2';

  @override
  String get networkModeMalwareDescription =>
      'Łączy lokalną bazę malware AvarionX z chmurową analizą zagrożeń Cloudflare dla maksymalnej ochrony przed malware.';

  @override
  String get networkModeAdultTitle => 'Malware i treści dla dorosłych';

  @override
  String get networkModeAdultSubtitle => 'Używa 1.1.1.3';

  @override
  String get networkModeAdultDescription =>
      'Używa lokalnej bazy malware AvarionX i dodaje filtrowanie treści dla dorosłych. Chmurowa analiza malware jest wyłączona w tym trybie.';

  @override
  String get networkInfoTitle => 'Czym jest Ochrona sieci?';

  @override
  String get networkInfoBody =>
      'Niektóre zagrożenia działają przez łączenie się ze złośliwymi serwerami lub przekierowywanie ruchu internetowego.\nOchrona sieci blokuje znane niebezpieczne domeny i typowe reklamy przy użyciu lokalnego VPN.\n\nAVarionX Security nie zbiera żadnych danych.';

  @override
  String get linkCheckerTitle => 'Skaner linków';

  @override
  String get linkCheckerTabAnalyse => 'Analiza';

  @override
  String get linkCheckerTabView => 'Widok';

  @override
  String get linkCheckerTabHistory => 'Historia';

  @override
  String get linkCheckerAnalyseSubtitle =>
      'Sprawdź stronę pod kątem malware lub podejrzanej treści';

  @override
  String get linkCheckerUrlLabel => 'URL';

  @override
  String get linkCheckerUrlHint => 'https://przyklad.pl';

  @override
  String get linkCheckerButtonAnalyse => 'Analizuj';

  @override
  String get linkCheckerButtonChecking => 'Sprawdzanie';

  @override
  String get linkCheckerEngineNotReadySnack => 'Silnik nie jest gotowy';

  @override
  String get linkCheckerStatusVerifyingLink => 'Weryfikowanie linku…';

  @override
  String get linkCheckerStatusScanningPage => 'Skanowanie strony…';

  @override
  String get linkCheckerBlockedNavigation => 'Nawigacja zablokowana';

  @override
  String get linkCheckerBlockedUnsupportedType => 'Nieobsługiwany typ linku';

  @override
  String get linkCheckerBlockedInvalidDestination =>
      'Nieprawidłowy adres docelowy';

  @override
  String get linkCheckerBlockedUnableResolve =>
      'Nie można rozwiązać adresu docelowego';

  @override
  String get linkCheckerBlockedUnableVerify =>
      'Nie można zweryfikować adresu docelowego';

  @override
  String get linkCheckerAnalyseCardTitleDefault =>
      'Sprawdź stronę pod kątem podejrzanej treści';

  @override
  String get linkCheckerAnalyseCardDetailDefault =>
      'Wklej URL i uruchom analizę.';

  @override
  String get linkCheckerAnalyseCardTitleEngineNotReady =>
      'Silnik nie jest gotowy';

  @override
  String get linkCheckerAnalyseCardDetailEngineNotReady => 'błąd 1001.';

  @override
  String get linkCheckerAnalyseCardTitleChecking => 'Sprawdzanie';

  @override
  String get linkCheckerVerdictClean => 'Czysta';

  @override
  String get linkCheckerVerdictCleanDetail =>
      'Ta strona wygląda na bezpieczną.';

  @override
  String get linkCheckerVerdictSuspicious => 'Podejrzana';

  @override
  String get linkCheckerVerdictSuspiciousDetail =>
      'Ta strona zawiera podejrzaną treść.';

  @override
  String get linkCheckerViewLockedBody =>
      'Najpierw uruchom analizę, aby włączyć podgląd.';

  @override
  String get linkCheckerViewSubtitle => 'Przeglądaj stronę bezpiecznie';

  @override
  String get linkCheckerViewPage => 'Otwórz stronę';

  @override
  String get linkCheckerClose => 'Zamknij';

  @override
  String get linkCheckerBlockedBody =>
      'Ta strona została zatrzymana przed załadowaniem.';

  @override
  String get linkCheckerSuspiciousBanner =>
      'Podejrzany link, strona może nie renderować się poprawnie, jeśli wymaga zablokowanej treści.';

  @override
  String get linkCheckerHistorySubtitle => 'Dotknij wpisu, aby skopiować link.';

  @override
  String get linkCheckerHistoryEmpty => 'Brak sprawdzeń.';

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
  String get settingsLanguageApplied => 'Zastosowano język';

  @override
  String get settingsSystemDefault => 'Domyślny systemowy';

  @override
  String get settingsSectionCommunity => 'Dołącz do społeczności!';

  @override
  String get settingsDiscord => 'Discord';

  @override
  String get settingsDiscordSubtitle => 'Czat, aktualizacje i opinie';

  @override
  String get settingsDiscordOpenFail => 'Nie można otworzyć linku Discord';

  @override
  String get settingsSectionPro => 'Funkcje Premium';

  @override
  String get settingsProCustomization => 'Personalizacja Premium';

  @override
  String get settingsProSubtitle =>
      'Usuń reklamy, odblokuj nielimitowany DNS, motywy i ikony';

  @override
  String get settingsUnlockPro => 'Odblokuj Premium';

  @override
  String get settingsProUnlocked => 'Tryb Premium odblokowany';

  @override
  String get settingsPurchaseNotConfirmed => 'Zakup nie został potwierdzony';

  @override
  String settingsPurchaseFailed(Object error) {
    return 'Zakup nie powiódł się: $error';
  }

  @override
  String get homeUpgrade => 'Ulepsz';

  @override
  String get homeFeatureSecureVpnTitle => 'AvarionX VPN';

  @override
  String get homeFeatureSecureVpnDesc =>
      'Ukryj swój IP i blokuj niechciane treści';

  @override
  String get proActivated => 'Premium aktywowane';

  @override
  String get proDeactivated => 'Premium wyłączone';

  @override
  String get settingsProReset => 'Reset Premium (tylko debug)';

  @override
  String get settingsProSheetTitle => 'Personalizacja Premium';

  @override
  String get settingsHideGoldHeader =>
      'Pokaż złoty nagłówek na ekranie głównym (ciemne motywy)';

  @override
  String get settingsAppIcon => 'Ikona aplikacji';

  @override
  String settingsIconSelected(Object icon) {
    return 'Wybrana ikona: $icon';
  }

  @override
  String get vpnSignInRequiredTitle => 'Wymagane logowanie';

  @override
  String get vpnClose => 'Zamknij';

  @override
  String get vpnSignInRequiredBody =>
      'Zaloguj się, aby korzystać z Bezpiecznego VPN.';

  @override
  String get vpnCancel => 'Anuluj';

  @override
  String get vpnSignIn => 'Zaloguj się';

  @override
  String get vpnUsageLoading => 'Ładowanie użycia...';

  @override
  String get vpnUsageNoLimits => 'Brak limitów danych';

  @override
  String get vpnUsageSyncing => 'Synchronizacja';

  @override
  String vpnUsageUsedThisMonth(Object used) {
    return '$used użyto w tym miesiącu';
  }

  @override
  String get vpnUsageDataTitle => 'Użycie danych';

  @override
  String get vpnUsageUnavailable => 'Użycie niedostępne';

  @override
  String get vpnStatusConnectingEllipsis => 'Łączenie...';

  @override
  String vpnStatusConnectedTo(Object country) {
    return 'Połączono z $country';
  }

  @override
  String get vpnTitleSecure => 'Bezpieczny VPN';

  @override
  String get vpnStatusConnected => 'Połączono';

  @override
  String get vpnSubtitleEstablishingTunnel => 'Tworzenie tunelu...';

  @override
  String get vpnSubtitleFindingLocation => 'Wyszukiwanie lokalizacji...';

  @override
  String get vpnStatusProtected => 'Chronione';

  @override
  String get vpnStatusNotConnected => 'Niepołączono';

  @override
  String get vpnConnect => 'Połącz';

  @override
  String get vpnDisconnect => 'Rozłącz';

  @override
  String vpnIpLabel(Object ip) {
    return 'IP: $ip';
  }

  @override
  String vpnServerLoadLabel(Object current, Object max) {
    return '$current/$max';
  }

  @override
  String get vpnBlocklistsTitle => 'Listy blokowania Bezpiecznego VPN';

  @override
  String get vpnSave => 'Zapisz';

  @override
  String get settingsSave => 'Zapisz';

  @override
  String get settingsPremium => 'Premium';

  @override
  String get settingsUltimateSecurity => 'Najwyższa ochrona';

  @override
  String get settingsSwitchPlan => 'Zmień plan';

  @override
  String get settingsBestValue => 'Najlepsza oferta';

  @override
  String get settingsOneTime => 'Jednorazowo';

  @override
  String get settingsPlanPriceLoading => 'Ładowanie ceny...';

  @override
  String get settingsMonthly => 'Miesięcznie';

  @override
  String get settingsYearly => 'Rocznie';

  @override
  String get settingsLifetime => 'Dożywotnio';

  @override
  String get settingsSubscribeMonthly => 'Subskrybuj miesięcznie';

  @override
  String get settingsSubscribeYearly => 'Subskrybuj rocznie';

  @override
  String get settingsUnlockLifetime => 'Odblokuj dożywotnio';

  @override
  String get settingsProBenefitsTitle => 'Korzyści';

  @override
  String get settingsUnlimitedDnsTitle => 'Nielimitowane zapytania DNS';

  @override
  String get settingsUnlimitedDnsBody =>
      'Usuń limity zapytań i odblokuj pełne filtrowanie chmurowe.';

  @override
  String get settingsThemesTitle => 'Motywy';

  @override
  String get settingsThemesBody => 'Odblokuj motywy premium i personalizację.';

  @override
  String get settingsIconCustomizationTitle => 'Personalizacja ikony aplikacji';

  @override
  String get settingsIconCustomizationBody =>
      'Zmień ikonę aplikacji, aby pasowała do Twojego stylu.';

  @override
  String get settingsScheduledScansTitle => 'Planowane skanowania';

  @override
  String get settingsScheduledScansBody =>
      'Odblokuj zaawansowane harmonogramy i personalizację skanowania.';

  @override
  String get settingsProFinePrint =>
      'Subskrypcje odnawiają się automatycznie, jeśli nie zostaną anulowane. Możesz nimi zarządzać lub anulować je w Google Play. Wersja dożywotnia to zakup jednorazowy.';

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
      'Dostęp Shizuku wymaga zewnętrznego menedżera przeznaczonego dla zaawansowanych użytkowników.\n\nTa funkcja jest opcjonalna i nie jest zalecana do codziennej ochrony.';

  @override
  String get settingsAboutShizukuTitle => 'O Shizuku';

  @override
  String get settingsAboutShizukuBody =>
      'AVarionX może integrować się z Shizuku, aby uzyskać dostęp do procesów aplikacji na poziomie systemowym.\n\nPozwala to aplikacji:\n• Wykrywać malware ukrywające się przed standardowymi skanerami\n• Analizować uruchomione procesy aplikacji\n• Wyłączać lub izolować większość aktywnego malware\n\nShizuku nie daje jednak dostępu root\n\nTa funkcja jest przeznaczona dla zaawansowanych użytkowników i nie jest wymagana do normalnej ochrony.\n\nDokumentacja:\nhttps://shizuku.rikka.app';

  @override
  String get settingsSectionGeneral => 'Ogólne';

  @override
  String get settingsExclusions => 'Wykluczenia';

  @override
  String get settingsExclusionsSubtitle => 'Zarządzaj i dodawaj wykluczenia';

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
  String get settingsAboutApp => 'O AVarionX';

  @override
  String get settingsHowThisAppWorks => 'Jak działa ta aplikacja';

  @override
  String get settingsHowThisAppWorksSubtitle => 'Dowiedz się o ochronie';

  @override
  String get settingsThemePickerTitle => 'Wybierz motyw';

  @override
  String get settingsThemeRequiresPro => 'Ten motyw wymaga trybu Premium';

  @override
  String get scheduledScansTitle => 'Planowane skanowania';

  @override
  String get scheduledScansInfoTitle => 'Planowane skanowania';

  @override
  String get scheduledScansInfoBody =>
      'Podczas gdy RTP skupia się na pobranym malware, planowane skanowania automatycznie uruchomią wybrany tryb skanowania w tle.\nZadziałają tylko wtedy, gdy RTP jest włączone.\n\nUżytkownicy Premium mogą dostosować tryb i częstotliwość skanowania.';

  @override
  String get scheduledScansHeader => 'Automatyczne skanowania w tle';

  @override
  String get scheduledScansSubheader =>
      'Gdy RTP jest aktywne, aplikacja będzie skanować urządzenie zgodnie z wybranym trybem i częstotliwością.';

  @override
  String get proRequiredToCustomize => 'Wymagane Premium do personalizacji';

  @override
  String get scheduledScansEnabledTitle => 'Włączone';

  @override
  String get scheduledScansEnabledSubtitle =>
      'Gdy włączone, skanowanie uruchamia się automatycznie według harmonogramu.';

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
  String get scheduledMonthly => 'Co miesiąc';

  @override
  String scheduledEveryDays(Object days) {
    return 'Co $days dni';
  }

  @override
  String scheduledEveryHours(Object hours) {
    return 'Co $hours godzin';
  }

  @override
  String get vpnSettingsPrivacySecurityTitle => 'Prywatność i bezpieczeństwo';

  @override
  String get vpnSettingsNoLogsPolicyTitle => 'Polityka braku logów';

  @override
  String get vpnSettingsNoLogsPolicyBody =>
      'Nie są przechowywane żadne logi. Aktywność połączeń, przeglądania, zapytań DNS i treść ruchu nie są rejestrowane ani zatrzymywane.';

  @override
  String get vpnSettingsNoActivityLogsTitle => 'Brak logów aktywności';

  @override
  String get vpnSettingsNoActivityLogsBody =>
      'Twoja aktywność nie jest monitorowana ani śledzona podczas korzystania z Bezpiecznego VPN.';

  @override
  String get vpnSettingsWireGuardTitle => 'VX-Link oparty na WireGuard';

  @override
  String get vpnSettingsWireGuardBody =>
      'Bezpieczny VPN używa protokołu WireGuard przez VX-Link, aby zapewnić szybkie, nowoczesne szyfrowanie.';

  @override
  String get vpnSettingsMalwareProtectionTitle =>
      'Ochrona przed malware włączona';

  @override
  String get vpnSettingsMalwareProtectionBody =>
      'Złośliwe domeny są domyślnie blokowane podczas połączenia.';

  @override
  String get vpnSettingsAdTrackerProtectionTitle =>
      'Opcjonalna ochrona reklam i trackerów';

  @override
  String get vpnSettingsAdTrackerProtectionBody =>
      'Włącz dodatkowe blokowanie reklam i trackerów w karcie Personalizacja.';

  @override
  String get vpnSettingsBrandFooter => 'Zabezpieczone przez VX-Link';

  @override
  String get vpnSettingsAccountTitle => 'Konto';

  @override
  String get vpnSettingsSignInToContinue => 'Zaloguj się, aby kontynuować';

  @override
  String get vpnSettingsAccountSyncBody =>
      'Twój plan i użycie danych synchronizują się z kontem.';

  @override
  String get vpnSettingsSignedIn => 'Zalogowano';

  @override
  String get vpnSettingsPlanUnknown => 'Plan: nieznany';

  @override
  String vpnSettingsPlanLabel(Object plan) {
    return 'Plan: $plan';
  }

  @override
  String get vpnSettingsRefresh => 'Odśwież';

  @override
  String get vpnSettingsSignOut => 'Wyloguj';

  @override
  String get scheduledChargingOnlyTitle => 'Tylko podczas ładowania';

  @override
  String get scheduledChargingOnlySubtitle =>
      'Uruchamiaj planowane skanowanie tylko wtedy, gdy urządzenie jest podłączone do zasilania.';

  @override
  String get scheduledPreferredTimeTitle => 'Preferowany czas';

  @override
  String get scheduledPreferredTimeSubtitle =>
      'AVarionX spróbuje uruchomić skanowanie około tej godziny. Android może opóźnić start, aby oszczędzać baterię.';

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
  String get cleanerGrantUsageAccessTitle => 'Przyznaj dostęp do użycia';

  @override
  String get cleanerGrantUsageAccessBody =>
      'Aby wykrywać nieużywane aplikacje, ten cleaner wymaga uprawnienia Dostęp do użycia. Zostaniesz przekierowany do ustawień systemowych, aby je włączyć.';

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
  String get vpnAccountScreenTitle => 'Konto';

  @override
  String get vpnAccountSignInRequiredTitle => 'Wymagane logowanie';

  @override
  String get vpnAccountSignInManageUsageBody =>
      'Zaloguj się, aby zarządzać kontem i użyciem.';

  @override
  String get vpnAccountNotSignedIn => 'Niezalogowano';

  @override
  String get vpnAccountFree => 'Darmowy';

  @override
  String get vpnAccountUnknown => 'Nieznany';

  @override
  String get vpnAccountStatusSyncing => 'Synchronizacja';

  @override
  String get vpnAccountStatusActive => 'Aktywny';

  @override
  String get vpnAccountStatusConnected => 'Połączono';

  @override
  String get vpnAccountStatusDisconnected => 'Rozłączono';

  @override
  String get vpnAccountStatusUnavailable => 'Niedostępne';

  @override
  String get vpnAccountStatusConnectedNow => 'Połączono teraz';

  @override
  String get vpnAccountStatusRefreshToLoadServer =>
      'Odśwież, aby wczytać status serwera';

  @override
  String get vpnAccountUsageTitle => 'Użycie';

  @override
  String get vpnAccountUsageLoading => 'Ładowanie użycia...';

  @override
  String get vpnAccountUsageSignInToSync =>
      'Zaloguj się, aby zsynchronizować użycie';

  @override
  String get vpnAccountUsagePullToRefresh =>
      'Przeciągnij, aby odświeżyć i zsynchronizować użycie';

  @override
  String get vpnAccountUsageUnlimited => 'Bez limitu';

  @override
  String vpnAccountUsageUsedThisMonth(Object used) {
    return '$used użyto w tym miesiącu';
  }

  @override
  String vpnAccountUsageUsedThisMonthUnlimited(Object used) {
    return '$used użyto w tym miesiącu, bez limitu';
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
      'Logowanie, plan, subskrypcja i użycie konta';

  @override
  String get exploreSecureVpnTitle => 'Bezpieczny VPN';

  @override
  String get exploreSecureVpnSubtitle =>
      'Ukryj swój IP i blokuj niechciane treści';

  @override
  String get vpnAccountServerLoadTitle => 'Obciążenie wybranego serwera';

  @override
  String vpnAccountServerConnectedCount(Object connected, Object cap) {
    return '$connected/$cap';
  }

  @override
  String get networkDnsOffTitle => 'Przełączyć na filtrowanie DNS?';

  @override
  String get networkDnsOffInfoTitle => 'Czym jest filtrowanie DNS?';

  @override
  String get networkDnsOffInfoBody1 =>
      'Filtrowanie DNS działa niezależnie od Bezpiecznego VPN. Może blokować znane malware, reklamy w aplikacjach, trackery i niechciane kategorie zanim się załadują.';

  @override
  String get networkDnsOffInfoBody2 =>
      'Nie szyfruje ruchu i nie ukrywa Twojego IP.';

  @override
  String get networkDnsOffEnableButton => 'Włącz filtrowanie DNS';

  @override
  String vpnAccountServerConnectedCountWithLabel(Object connected, Object cap) {
    return '$connected/$cap połączonych';
  }

  @override
  String get vpnAccountIdentityFallbackTitle => 'Konto';

  @override
  String get vpnAccountMembershipLabel => 'Członkostwo';

  @override
  String get vpnAccountMembershipFounderVpnPro => 'Founders · VPN Pro';

  @override
  String get vpnAccountMembershipFounder => 'Founder';

  @override
  String get vpnAccountMembershipPro => 'Pro';

  @override
  String get vpnAccountSectionAccountStatus => 'Status konta';

  @override
  String get vpnAccountSectionActions => 'Akcje';

  @override
  String get vpnAccountKvStatus => 'Status';

  @override
  String get vpnAccountKvPlan => 'Plan';

  @override
  String get vpnAccountKvUsage => 'Użycie';

  @override
  String get vpnAccountKvSelectedServer => 'Wybrany serwer';

  @override
  String get vpnAccountKvConnectionState => 'Stan połączenia';

  @override
  String get vpnAccountActionRefresh => 'Odśwież';

  @override
  String get vpnAccountActionOpen => 'Otwórz';

  @override
  String get vpnAccountFounderThanks => 'Dziękuję za wspieranie ColourSwift';

  @override
  String get vpnAccountFounderNote =>
      'Jestem tylko jedną osobą, wspieraną przez najlepszą społeczność.';

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
    return 'Brak nieużywanych aplikacji w ostatnich $days dniach';
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
  String get quarantineEmptyBody => 'Wszystko, co usuniesz, pojawi się tutaj.';

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
