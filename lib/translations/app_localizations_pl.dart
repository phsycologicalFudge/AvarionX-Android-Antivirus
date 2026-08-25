// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Polish (`pl`).
class AppLocalizationsPl extends AppLocalizations {
  AppLocalizationsPl([String locale = 'pl']) : super(locale);

  @override
  String get appName => 'AvarionX';

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
  String get companionAppsSectionTitle => 'Więcej od AvarionX';

  @override
  String get cleanerReclaimableLabel => 'Można zwolnić';

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
  String get engineReadyBanner => 'VX-TITANIUM-v9';

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
  String quarantineDeleteDialogBody(Object count, String plural) {
    String _temp0 = intl.Intl.selectLogic(
      plural,
      {
        's': '',
        'other': '',
      },
    );
    return 'Liczba elementów do trwałego usunięcia: $count.$_temp0';
  }

  @override
  String get howThisAppWorksHowAvarionXWorks => 'Jak działa AvarionX';

  @override
  String get howThisAppWorksAvarionxIsAMobileSecurityAppThat =>
      'AvarionX to mobilna aplikacja zabezpieczająca, która łączy skanowanie antywirusowe na urządzeniu, ochronę sieci i opcjonalne funkcje VPN. ';

  @override
  String get howThisAppWorksTheAntivirusEngineIsPoweredByVX =>
      'Silnik antywirusowy jest oparty na VX-Titanium.';

  @override
  String get howThisAppWorksIfYouUseNetworkProtectionOrVPN =>
      'Jeśli korzystasz z ochrony sieci lub funkcji VPN, aplikacja łączy się z usługami ColourSwift, aby zastosować Twoje ustawienia, zarządzać dostępem do konta i kierować chroniony ruch.';

  @override
  String get howThisAppWorksKeyFeatures => 'Najważniejsze funkcje';

  @override
  String get howThisAppWorksRealTimeProtectionForDownloadedThreats =>
      '• Ochrona w czasie rzeczywistym przed pobranymi zagrożeniami';

  @override
  String get howThisAppWorksNetworkProtectionWithDNSFiltering =>
      '• Ochrona sieci z filtrowaniem DNS';

  @override
  String get howThisAppWorksOptionalSecureVPNMode =>
      '• Opcjonalny tryb Secure VPN';

  @override
  String get howThisAppWorksBuiltInToolsSuchAsLinkChecker =>
      '• Wbudowane narzędzia, takie jak Link Checker';

  @override
  String get howThisAppWorksNotes => 'Uwagi';

  @override
  String get howThisAppWorksSomeFeaturesMayRequireSignInAn =>
      'Niektóre funkcje mogą wymagać zalogowania, aktywnego planu lub uprawnień urządzenia, aby działać prawidłowo.';

  @override
  String get apkAnalyserCopyCurrentReport => 'Kopiuj bieżący raport';

  @override
  String get apkAnalyserReportCopiedToClipboard =>
      'Raport skopiowano do schowka';

  @override
  String get apkAnalyserExportCurrentAsPDF => 'Eksportuj bieżący jako PDF';

  @override
  String get apkAnalyserFailedToExportPDF => 'Nie udało się wyeksportować PDF';

  @override
  String get apkAnalyserExportCurrentAsCSV => 'Eksportuj bieżący jako CSV';

  @override
  String get apkAnalyserFailedToExportCSV => 'Nie udało się wyeksportować CSV';

  @override
  String get apkAnalyserViewSavedReports => 'Wyświetl zapisane raporty';

  @override
  String get apkAnalyserClearHistory => 'Wyczyść historię';

  @override
  String get apkAnalyserReportHistoryCleared =>
      'Historia raportów została wyczyszczona';

  @override
  String get apkAnalyserSavedReports => 'Zapisane raporty';

  @override
  String get apkAnalyserNoSavedReportsFound =>
      'Nie znaleziono zapisanych raportów.';

  @override
  String get apkAnalyserChooseTarget => 'Wybierz cel';

  @override
  String get apkAnalyserSelectASourceToAnalyseWithVTTI =>
      'Wybierz źródło do analizy za pomocą VTTI Cloud.';

  @override
  String get apkAnalyserApkFile => 'Plik APK';

  @override
  String get apkAnalyserPickAnApkFromStorage => 'Wybierz plik .apk z pamięci';

  @override
  String get apkAnalyserInstalledApp => 'Zainstalowana aplikacja';

  @override
  String get apkAnalyserChooseFromAppsOnThisDevice =>
      'Wybierz spośród aplikacji na tym urządzeniu';

  @override
  String apkAnalyserAnalysingIn(Object countdown) {
    return 'Analiza za $countdown...';
  }

  @override
  String get apkAnalyserStartingAnalysis => 'Rozpoczynanie analizy...';

  @override
  String get apkAnalyserApkFileOrInstalledApp =>
      'Plik APK lub zainstalowana aplikacja';

  @override
  String get apkAnalyserDeepAnalysisMode => 'Tryb głębokiej analizy';

  @override
  String get apkAnalyserAMoreComplexAnalysisUsingGlobalData =>
      'Bardziej złożona analiza wykorzystująca globalne źródła danych';

  @override
  String get apkAnalyserRequiresProToUnlockDeeperAnalysis =>
      'Wymaga Pro, aby odblokować głębszą analizę';

  @override
  String get apkAnalyserApkAnalyser => 'Analizator APK';

  @override
  String get apkAnalyserPleaseSignInViaSettingsToEnable =>
      'Zaloguj się w Ustawieniach, aby włączyć Cloud Analysis.';

  @override
  String get apkAnalyserAdvancedOPTIONS => 'OPCJE ZAAWANSOWANE';

  @override
  String apkAnalyserDailyLimit(Object remaining, Object limit) {
    return 'Limit dzienny: $remaining / $limit';
  }

  @override
  String get apkAnalyserDailyLimitDataUnavailable =>
      'Dane limitu dziennego są niedostępne';

  @override
  String get apkAnalyserPoweredByVTTICloud => 'Obsługiwane przez VTTI Cloud';

  @override
  String get apkAnalyserSearchApps => 'Szukaj aplikacji...';

  @override
  String get apkAnalyserFailedToLoadApps => 'Nie udało się wczytać aplikacji.';

  @override
  String get apkAnalyserNoAppsFound => 'Nie znaleziono aplikacji.';

  @override
  String get apkReportSummary => 'Podsumowanie';

  @override
  String get apkReportPermissions => 'Uprawnienia';

  @override
  String get apkReportExtraFlags => 'Dodatkowe flagi';

  @override
  String get apkReportRiskSignals => 'Sygnały ryzyka';

  @override
  String get apkReportSources => 'Źródła';

  @override
  String get apkReportMetadata => 'Metadane';

  @override
  String get apkReportCopyReport => 'Kopiuj raport';

  @override
  String get apkReportReportCopiedToClipboard => 'Raport skopiowano do schowka';

  @override
  String get apkReportExportAsPDF => 'Eksportuj jako PDF';

  @override
  String get apkReportFailedToExportPDF => 'Nie udało się wyeksportować PDF';

  @override
  String get apkReportExportAsCSV => 'Eksportuj jako CSV';

  @override
  String get apkReportFailedToExportCSV => 'Nie udało się wyeksportować CSV';

  @override
  String get apkReportAnalysisReport => 'Raport z analizy';

  @override
  String get apkReportMalwareRisk => 'Ryzyko złośliwego oprogramowania';

  @override
  String get apkReportNoSummaryGenerated => 'Nie wygenerowano podsumowania.';

  @override
  String get apkReportNoRequestedPermissionsExtracted =>
      'Nie wyodrębniono żadnych żądanych uprawnień.';

  @override
  String get apkReportContributing => 'Czynniki zwiększające';

  @override
  String get apkReportDampening => 'Czynniki łagodzące';

  @override
  String get bootOptimisingYourProtection => 'Optymalizowanie ochrony';

  @override
  String get exclusionsFolders => 'Foldery';

  @override
  String get exclusionsNone => 'Brak';

  @override
  String get exclusionsFiles => 'Pliki';

  @override
  String get exploreApkAnalyser => 'Analizator APK';

  @override
  String get exploreCreateADetailedAnalysisOnAnyAPK =>
      'Utwórz szczegółową analizę dowolnego APK';

  @override
  String get featuresComingSoon => 'Wkrótce';

  @override
  String get featuresWantToLearnMore => 'Chcesz dowiedzieć się więcej?';

  @override
  String get homeDrawerApkAnalyser => 'Analizator APK';

  @override
  String get homeDrawerAdvanced => 'Zaawansowane';

  @override
  String get homeDrawerQuarantine => 'Kwarantanna';

  @override
  String get homeDrawerUpgradeToPro => 'Przejdź na Pro';

  @override
  String get homeDrawerAvarionxVPN => 'AvarionX VPN';

  @override
  String get homeDrawerProtectYourInternetWithOurUnlimitedVPN =>
      'Chroń swoje połączenie internetowe dzięki naszemu nielimitowanemu VPN';

  @override
  String get deviceSecurityDeviceSecurity => 'Bezpieczeństwo urządzenia';

  @override
  String get deviceSecurityDeviceHealthStatus =>
      'Stan bezpieczeństwa urządzenia';

  @override
  String get deviceSecurityDeviceSecurityRecommendations =>
      'Zalecenia dotyczące bezpieczeństwa urządzenia';

  @override
  String get deviceSecurityStopIgnoring => 'Przestań ignorować';

  @override
  String get deviceSecurityIgnoreCheck => 'Ignoruj kontrolę';

  @override
  String get deviceSecurityNoScreenLock => 'Brak blokady ekranu';

  @override
  String get deviceSecurityAMissingSecureLockMakesLocalAccess =>
      'Brak bezpiecznej blokady ułatwia fizyczny dostęp do urządzenia.';

  @override
  String get deviceSecurityRootShizukuActive => 'Root/Shizuku aktywne';

  @override
  String get deviceSecurityRootOrShizukuCanGrantPowerfulDevice =>
      'Root lub Shizuku mogą zapewnić rozległą kontrolę nad urządzeniem.';

  @override
  String get deviceSecurityDisabledAppVerification =>
      'Weryfikacja aplikacji wyłączona';

  @override
  String get deviceSecurityAppVerificationHelpsDetectHarmfulInstalls =>
      'Weryfikacja aplikacji pomaga wykrywać szkodliwe instalacje.';

  @override
  String get deviceSecurityOldAndroidSecurityPatch =>
      'Stara poprawka zabezpieczeń Androida';

  @override
  String get deviceSecurityOlderPatchLevelsMayLeaveKnownIssues =>
      'Starsze poziomy poprawek mogą pozostawiać znane problemy bez naprawy.';

  @override
  String get deviceSecurityDeveloperModeOn => 'Tryb programisty włączony';

  @override
  String get deviceSecurityDeveloperOptionsExposeAdvancedDeviceControls =>
      'Opcje programisty udostępniają zaawansowane ustawienia urządzenia.';

  @override
  String get deviceSecurityUsbDebuggingOn => 'Debugowanie USB włączone';

  @override
  String get deviceSecurityUsbDebuggingAllowsADBControlFromTrusted =>
      'Debugowanie USB umożliwia sterowanie przez ADB z zaufanych komputerów.';

  @override
  String get deviceSecurityUnknownSourcesAllowed => 'Nieznane źródła dozwolone';

  @override
  String get deviceSecuritySideloadingCanBypassNormalAppStoreChecks =>
      'Instalowanie spoza sklepu może ominąć standardowe kontrole sklepu z aplikacjami.';

  @override
  String get deviceSecurityAccessibilityAbuseRisk =>
      'Ryzyko nadużycia ułatwień dostępu';

  @override
  String get deviceSecurityAccessibilityServicesCanReadAndControlScreen =>
      'Usługi ułatwień dostępu mogą odczytywać ekran i sterować działaniami na nim.';

  @override
  String get homeHelpImproveDetectionsForEverybody =>
      'Pomóż ulepszyć wykrywanie dla wszystkich';

  @override
  String get homeApkSAndroidAppsFoundToBe =>
      'Pliki APK (aplikacje Android) uznane za złośliwe ';

  @override
  String get homeCanBeUploadedTo => 'mogą zostać przesłane do ';

  @override
  String get homeAndSharedWithTheCommunityThisIs =>
      ' i udostępnione społeczności. Dotyczy to ';

  @override
  String get homeStrictlyLimitedToAPKFilesNOTYour =>
      'wyłącznie plików APK, a NIE Twoich osobistych ';

  @override
  String get homeDocuments => 'dokumentów.\n\n';

  @override
  String get homeThisWillImproveDetectionsForEveryoneThat =>
      'Pomoże to ulepszyć wykrywanie dla wszystkich, którzy ';

  @override
  String get homeUsesAvarionXNoPressureThough =>
      'korzystają z AvarionX. Bez żadnej presji!\n\n';

  @override
  String get homeThanks => 'Dzięki,\n';

  @override
  String get homeRyanfromcolourswift => 'RyanFromColourswift';

  @override
  String get homeSure => 'Jasne!';

  @override
  String get homeNoThanks => 'Nie, dzięki!';

  @override
  String get homePsstCustomiseItHere => 'Psst... dostosuj tutaj';

  @override
  String get homeScanNow => 'Skanuj teraz';

  @override
  String get homeManuallyCheckYourDeviceForMalware =>
      'Ręcznie sprawdź urządzenie pod kątem złośliwego oprogramowania';

  @override
  String get homeDeviceSecurity => 'Bezpieczeństwo urządzenia';

  @override
  String get homeScanModes => 'Tryby skanowania';

  @override
  String get homeCloudAssistedChecksEnabled =>
      'Kontrole wspomagane chmurą włączone';

  @override
  String get homeLocalScanEngineOnly => 'Tylko lokalny silnik skanowania';

  @override
  String get homeProtectedByVXTITANIUM => 'Chronione przez VX-TITANIUM';

  @override
  String get homeSecurityOverview => 'Przegląd bezpieczeństwa';

  @override
  String get homeFilesChecked => 'Sprawdzone pliki';

  @override
  String get homeThreats => 'Zagrożenia';

  @override
  String get securityReportAvarionxSecurityReport =>
      'Raport bezpieczeństwa Avarionx';

  @override
  String get securityReportSecurityReport => 'Raport bezpieczeństwa';

  @override
  String get securityReportManualScans => 'Skanowania ręczne';

  @override
  String get securityReportRealtimeChecks => 'Kontrole w czasie rzeczywistym';

  @override
  String get securityReportTotalFilesScanned =>
      'Łączna liczba przeskanowanych plików';

  @override
  String get securityReportThreatsFound => 'Znalezione zagrożenia';

  @override
  String get securityReportGenerateReport => 'Generuj raport';

  @override
  String get securityReportLiveReport => 'Raport na żywo';

  @override
  String get securityReportThisBoxUpdatesAsScanServicesWrite =>
      'To pole aktualizuje się, gdy usługi skanowania zapisują dane raportu.';

  @override
  String get securityReportExportPDF => 'Eksportuj PDF';

  @override
  String get securityReportExportCSV => 'Eksportuj CSV';

  @override
  String get homeLegacyProActivated => 'Pro aktywowane';

  @override
  String get homeLegacyProDeactivated => 'Pro dezaktywowane';

  @override
  String get linkCheckPoweredByVTTICloud => 'Obsługiwane przez VTTI Cloud';

  @override
  String get safeViewSafeView => 'Safe View';

  @override
  String get passwordSettingsChangingThisAltersAllPasswords =>
      'Zmiana tego ustawienia zmienia wszystkie hasła.\n';

  @override
  String get passwordSettingsUsingTheSameMetaPassRestoresThem =>
      'Użycie tego samego MetaPass przywraca je.';

  @override
  String get passwordSettingsPasswordsAreNeverStored =>
      'Hasła nigdy nie są przechowywane.\n\n';

  @override
  String get passwordSettingsTheRestoreCodeContainsOnlyStructureData =>
      'Kod przywracania zawiera wyłącznie dane struktury. ';

  @override
  String get passwordSettingsCombinedWithYourMetaPassItRebuildsYour =>
      'W połączeniu z MetaPass odtwarza Twój sejf.';

  @override
  String get passwordManagerContinue => 'Kontynuuj';

  @override
  String passwordManagerFailedToLoadApps(Object e) {
    return 'Nie udało się wczytać aplikacji: $e';
  }

  @override
  String passwordManagerFailedToGeneratePassword(Object e) {
    return 'Nie udało się wygenerować hasła: $e';
  }

  @override
  String get passwordManagerPasswordsAreNeverStored =>
      'Hasła nigdy nie są przechowywane.\n\n';

  @override
  String get passwordManagerEachEntryDerivesAPasswordFrom =>
      'Hasło dla każdego wpisu jest wyprowadzane z:\n';

  @override
  String get passwordManagerYourMetaPassword => '• Twojego hasła meta\n';

  @override
  String get passwordManagerTheLabelName => '• Nazwy etykiety\n';

  @override
  String get passwordManagerTheVersionAndLength => '• Wersji i długości\n\n';

  @override
  String get passwordManagerReinstallingTheAppWithTheSameMeta =>
      'Ponowna instalacja aplikacji z tym samym hasłem meta i etykietami wygeneruje te same hasła.';

  @override
  String get permissionsIntroSetupIsNowCompleteTimeToSecure =>
      'Konfiguracja została zakończona! Czas zabezpieczyć Twoje dane.';

  @override
  String get proScreenThankYou => 'Dziękujemy';

  @override
  String get proScreenYourSubscriptionIsConfirmed =>
      'Twoja subskrypcja została potwierdzona.';

  @override
  String get proScreenCurrent => 'Obecny';

  @override
  String get proScreenAdvancedStealthMode => 'Zaawansowany tryb Stealth+';

  @override
  String get proScreenUnlockStealthTransportModesForRestrictiveNetworks =>
      'Odblokuj ukryte tryby transportu dla restrykcyjnych sieci.';

  @override
  String get proScreenGlobalServerAccess => 'Globalny dostęp do serwerów';

  @override
  String get proScreenAccessEveryVPNServerLocationIncludingPremium =>
      'Uzyskaj dostęp do każdej lokalizacji serwera VPN, w tym szybkich regionów premium.';

  @override
  String get proScreenBilledMonthly => 'Rozliczane miesięcznie';

  @override
  String proScreenMo(Object monthlyInfo) {
    return '$monthlyInfo/mies.';
  }

  @override
  String proScreenMo2(Object currencyCode) {
    return '$currencyCode/mies.';
  }

  @override
  String get proScreenCurrentPlan => 'Obecny plan';

  @override
  String get quarantineScreenQuarantineDataCorruptedResetting =>
      'Dane kwarantanny są uszkodzone. Resetowanie.';

  @override
  String get quarantineScreenUninstallApp => 'Odinstaluj aplikację';

  @override
  String quarantineScreenUninstall(Object appName) {
    return 'Odinstalować $appName?';
  }

  @override
  String get quarantineScreenUninstall2 => 'Odinstaluj';

  @override
  String get quarantineScreenFailedToLaunchUninstall =>
      'Nie udało się uruchomić odinstalowywania';

  @override
  String get quarantineScreenFiles => 'Pliki';

  @override
  String get cleanerAppManagerShizukuNotAvailable => 'Shizuku niedostępne';

  @override
  String get cleanerAppManagerWithoutShizukuEachAppRequiresASeparate =>
      'Bez Shizuku każda aplikacja wymaga osobnego potwierdzenia systemowego. Kontynuować?';

  @override
  String cleanerAppManagerAppsUninstalled(Object successCount) {
    return 'Odinstalowano aplikacje: $successCount';
  }

  @override
  String cleanerAppManagerUninstalledFailed(
      Object successCount, Object failedCount) {
    return 'Odinstalowano: $successCount, niepowodzenia: $failedCount';
  }

  @override
  String cleanerAppManagerStopped(Object appName) {
    return 'Zatrzymano $appName';
  }

  @override
  String get cleanerAppManagerForceStopFailed =>
      'Wymuszenie zatrzymania nie powiodło się';

  @override
  String get cleanerAppManagerClearAppData => 'Wyczyść dane aplikacji';

  @override
  String cleanerAppManagerResetThisClearsItsAccountsSettingsFiles(
      Object appName) {
    return 'Zresetować $appName? Spowoduje to usunięcie jej kont, ustawień, plików i pamięci podręcznej.';
  }

  @override
  String get cleanerAppManagerClearData => 'Wyczyść dane';

  @override
  String cleanerAppManagerReset(Object appName) {
    return 'Zresetowano $appName';
  }

  @override
  String get cleanerAppManagerClearDataFailed =>
      'Nie udało się wyczyścić danych';

  @override
  String get cleanerAppManagerOpenApp => 'Otwórz aplikację';

  @override
  String get cleanerAppManagerForceStop => 'Wymuś zatrzymanie';

  @override
  String get cleanerAppManagerUninstall => 'Odinstaluj';

  @override
  String cleanerAppManagerSelected(Object selectedCount) {
    return 'Wybrano: $selectedCount';
  }

  @override
  String get cleanerAppManagerAppManager => 'Menedżer aplikacji';

  @override
  String get cleanerAppManagerDeselectAll => 'Odznacz wszystko';

  @override
  String cleanerAppManagerUninstalling(Object done, Object total) {
    return 'Odinstalowywanie $done / $total…';
  }

  @override
  String cleanerAppManagerUninstall2(Object selectedCount) {
    return 'Odinstaluj $selectedCount';
  }

  @override
  String get cleanerProClearAppCaches => 'Wyczyść pamięć podręczną aplikacji';

  @override
  String get cleanerProThisAsksAndroidToTrimAppCaches =>
      'Prosi Androida o ograniczenie pamięci podręcznej aplikacji na całym urządzeniu. Dane aplikacji, konta i ustawienia nie zostaną usunięte.';

  @override
  String get cleanerProClearCaches => 'Wyczyść pamięć podręczną';

  @override
  String get cleanerProCacheTrimRequested =>
      'Zażądano ograniczenia pamięci podręcznej';

  @override
  String get cleanerProCacheCleanerFailed =>
      'Czyszczenie pamięci podręcznej nie powiodło się';

  @override
  String get cleanerProLogFiles => 'Pliki dziennika';

  @override
  String get cleanerProCacheCleaner => 'Czyszczenie pamięci podręcznej';

  @override
  String get cleanerProLogCleaner => 'Czyszczenie dzienników';

  @override
  String get cleanerProAppDataManager => 'Menedżer danych aplikacji';

  @override
  String get cleanerScreenCleaner => 'Czyszczenie';

  @override
  String get scanDetailDeleteFiles => 'Usuń pliki';

  @override
  String scanDetailDeleteFilesPermanently(Object selectedCount) {
    return 'Trwale usunąć $selectedCount plików?';
  }

  @override
  String get scanDetailSelectedFilesDeleted => 'Wybrane pliki zostały usunięte';

  @override
  String get scanDetailDeleteAllFiles => 'Usuń wszystkie pliki';

  @override
  String scanDetailDeleteAllFilesPermanently(Object fileCount) {
    return 'Trwale usunąć wszystkie pliki ($fileCount)?';
  }

  @override
  String get scanDetailDeleteAll => 'Usuń wszystko';

  @override
  String get scanDetailAllFilesDeleted => 'Wszystkie pliki zostały usunięte';

  @override
  String scanDetailSelected(Object selectedCount) {
    return 'Wybrano: $selectedCount';
  }

  @override
  String get scanDetailDeselectAll => 'Odznacz wszystko';

  @override
  String get scanDetailNewestFirst => 'Najnowsze najpierw';

  @override
  String get scanDetailOldestFirst => 'Najstarsze najpierw';

  @override
  String get scanDetailLargestFirst => 'Największe najpierw';

  @override
  String get scanDetailSmallestFirst => 'Najmniejsze najpierw';

  @override
  String get scanDetailNoFilesFound => 'Nie znaleziono plików';

  @override
  String get scanDetailDeleteAll2 => 'Usuń wszystko';

  @override
  String get scanInstalledAppsSearchApps => 'Szukaj aplikacji...';

  @override
  String get scanInstalledAppsNoAppsFound => 'Nie znaleziono aplikacji.';

  @override
  String get scanUiScanComplete => 'Skanowanie zakończone';

  @override
  String scanUiScannedItems(Object scanned) {
    return 'Przeskanowano: $scanned elementów';
  }

  @override
  String scanUiProgress(Object pct, Object scanned, Object total) {
    return 'Postęp: $pct ($scanned / $total)';
  }

  @override
  String get scanUiPreparingEngine => 'Przygotowywanie silnika...';

  @override
  String get scanUiLoadingTargetS => 'Wczytywanie celów';

  @override
  String get scanUiAvarionxVPN => 'AvarionX VPN';

  @override
  String get scanUiProtectYourInternetWithOurUnlimitedVPN =>
      'Chroń swoje połączenie internetowe dzięki naszemu nielimitowanemu VPN';

  @override
  String get scanUiTapMe => 'Dotknij mnie!';

  @override
  String scanUiScanned(Object scanned) {
    return 'Przeskanowano: $scanned';
  }

  @override
  String get scanUiReturn => 'Powrót';

  @override
  String get scanLimitsSettingsUpdated => 'Ustawienia zaktualizowane';

  @override
  String get scanLimitsScanLimits => 'Limity skanowania';

  @override
  String get scanLimitsLimitHowMuchTheEngineUsesYour =>
      'Ogranicz wykorzystanie procesora przez silnik. Wątki: 0 oznacza automatycznie.';

  @override
  String get scanLimitsMaxScanThreads => 'Maksymalna liczba wątków skanowania';

  @override
  String scanLimits0AutoRange0ToCores(Object maxThreads, Object coreCount) {
    return '0 = automatycznie. Zakres: od 0 do $maxThreads (rdzenie: $coreCount).';
  }

  @override
  String scanLegacyScanning(Object percent) {
    return 'Skanowanie... $percent%';
  }

  @override
  String scanLegacySuspicious(Object infectedCount) {
    return 'Podejrzane: $infectedCount';
  }

  @override
  String scanLegacyClean(Object cleanCount) {
    return 'Czyste: $cleanCount';
  }

  @override
  String get scanLegacyNoFilesToScan => 'Brak plików do skanowania';

  @override
  String get settingsSponsorsUnlock => 'Sponsorzy odblokowują ❤️';

  @override
  String get settingsPickCertificate => 'Wybierz certyfikat';

  @override
  String get settingsCertificateLoaded => 'Certyfikat wczytany';

  @override
  String get settingsEnterCode => 'wprowadź kod';

  @override
  String get settingsSupportFileMissing => 'Brak pliku wsparcia';

  @override
  String get settingsInvalidSupportCode => 'Nieprawidłowy kod wsparcia';

  @override
  String get settingsAvarionxSecurity => 'AvarionX Security';

  @override
  String get settingsAvarionxIsAMobileSecuritySuiteCreated =>
      'AvarionX to mobilny pakiet bezpieczeństwa stworzony przez ColourSwift z siedzibą w Birmingham w Wielkiej Brytanii.\n\n';

  @override
  String get settingsContact => 'Kontakt: ';

  @override
  String get settingsExperimentalFeatures => 'Funkcje eksperymentalne';

  @override
  String get settingsEnablingShizukuUnlocksExperimentalWorkInProgress =>
      'Włączenie Shizuku odblokowuje eksperymentalne funkcje będące jeszcze w trakcie rozwoju:\n\n';

  @override
  String get settingsAdvancedRansomwareProtection =>
      '• Zaawansowana ochrona przed ransomware\n';

  @override
  String get settingsCacheCleanerPlus => '• Cache Cleaner Plus\n\n';

  @override
  String get settingsExperimentalWarning =>
      'Ostrzeżenie dotyczące funkcji eksperymentalnych:\n';

  @override
  String get settingsTheseFeaturesUseAdvancedSystemAccessAnd =>
      'Te funkcje korzystają z zaawansowanego dostępu do systemu i mogą zachowywać się różnie w zależności od urządzenia, wersji Androida i konfiguracji Shizuku. Niektóre działania mogą wpływać na uruchomione aplikacje, pliki lub dane pamięci podręcznej bardziej bezpośrednio niż zwykłe skanowanie.\n\n';

  @override
  String get settingsOnlyEnableThisIfYouUnderstandShizuku =>
      'Włącz tę opcję tylko wtedy, gdy rozumiesz działanie Shizuku, akceptujesz, że funkcja jest nadal testowana, i masz kopię zapasową ważnych danych.\n\n';

  @override
  String get settingsPleaseReadTheDocumentationBeforeEnabling =>
      'Przed włączeniem przeczytaj dokumentację.';

  @override
  String get settingsEnable => 'Włącz';

  @override
  String get settingsSigningOut => 'Wylogowywanie...';

  @override
  String get settingsCheckingAccountStatus => 'Sprawdzanie stanu konta...';

  @override
  String get settingsManageSignInPremiumAndPurchases =>
      'Zarządzaj logowaniem, Premium i zakupami';

  @override
  String get settingsPremiumActive => 'Premium aktywne';

  @override
  String get settingsManagePremiumOptionsAndRestorePurchases =>
      'Zarządzaj opcjami Premium i przywróć zakupy';

  @override
  String get settingsUnlockDeepAnalysisModeAndVPNFeatures =>
      'Odblokuj tryb głębokiej analizy i funkcje VPN';

  @override
  String get settingsAutoClearNotifications =>
      'Automatycznie usuwaj powiadomienia';

  @override
  String get settingsScanModes => 'Tryby skanowania';

  @override
  String get settingsAdvancedScanModes => 'Zaawansowane tryby skanowania';

  @override
  String get settingsDisableToUseTheDefaultScanningMode =>
      'Wyłącz, aby używać domyślnego trybu skanowania';

  @override
  String get settingsToggleToEnableAllScanningModes =>
      'Włącz, aby udostępnić wszystkie tryby skanowania';

  @override
  String get settingsApkSubmissions => 'Przesyłanie APK';

  @override
  String get settingsShareMaliciousAPKs => 'Udostępniaj złośliwe APK';

  @override
  String get settingsHelpingImproveDetectionForEveryone =>
      'Pomaga ulepszać wykrywanie dla wszystkich';

  @override
  String get settingsOff => 'Wyłączone';

  @override
  String get settingsIncludeRealtimeProtectionCatches =>
      'Uwzględniaj wykrycia ochrony w czasie rzeczywistym';

  @override
  String get settingsApksFlaggedByRealtimeProtectionAreIncluded =>
      'APK oznaczone przez ochronę w czasie rzeczywistym są uwzględniane';

  @override
  String get settingsApksFlaggedByRealtimeProtectionAreExcluded =>
      'APK oznaczone przez ochronę w czasie rzeczywistym są wykluczane';

  @override
  String get settingsIncludeManualAndScheduledScans =>
      'Uwzględniaj skanowania ręczne i zaplanowane';

  @override
  String get settingsApksFlaggedByScansAreIncluded =>
      'APK oznaczone podczas skanowania są uwzględniane';

  @override
  String get settingsApksFlaggedByScansAreExcluded =>
      'APK oznaczone podczas skanowania są wykluczane';

  @override
  String get settingsWiFiOnly => 'Tylko Wi-Fi';

  @override
  String get settingsUploadsWaitForAWiFiConnection =>
      'Przesyłanie czeka na połączenie Wi-Fi';

  @override
  String get settingsUploadsMayUseMobileData =>
      'Przesyłanie może używać danych komórkowych';

  @override
  String get settingsChargingOnly => 'Tylko podczas ładowania';

  @override
  String get settingsUploadsWaitUntilTheDeviceIsCharging =>
      'Przesyłanie czeka, aż urządzenie będzie ładowane';

  @override
  String get settingsUploadsAreNotLimitedToCharging =>
      'Przesyłanie nie jest ograniczone do czasu ładowania';

  @override
  String get settingsChooseWhichAppsUpload => 'Wybierz aplikacje do przesłania';

  @override
  String get settingsReviewAndPickAppsEachTimeBefore =>
      'Przeglądaj i wybieraj aplikacje za każdym razem przed przesłaniem';

  @override
  String get settingsFlaggedAppsUploadAutomatically =>
      'Oznaczone aplikacje są przesyłane automatycznie';

  @override
  String get settingsEnableProDebug => 'Włącz Pro (debugowanie)';

  @override
  String get settingsLocalUnlockForUITesting =>
      'Lokalne odblokowanie do testowania interfejsu';

  @override
  String get settingsRestorePurchases => 'Przywróć zakupy';

  @override
  String get settingsReCheckPlayBilling => 'Sprawdź ponownie Play Billing';

  @override
  String get settingsCheckingAccount => 'Sprawdzanie konta...';

  @override
  String get settingsAvarionxAccountConnected => 'Konto AvarionX połączone';

  @override
  String settingsAccountID(Object accountId) {
    return 'ID konta: $accountId';
  }

  @override
  String get settingsSignInToManagePurchasesAndAccount =>
      'Zaloguj się, aby zarządzać zakupami i funkcjami konta.';

  @override
  String get settingsOpenTheAvarionXAccountPortal =>
      'Otwórz portal konta AvarionX';

  @override
  String get settingsAccountDashboard => 'Panel konta';

  @override
  String get settingsOpenBillingAndAccountSettings =>
      'Otwórz ustawienia rozliczeń i konta';

  @override
  String get settingsRemoveThisAccountFromTheApp => 'Usuń to konto z aplikacji';

  @override
  String get settingsPremiumFeaturesAreAvailableOnThisDevice =>
      'Funkcje Premium są dostępne na tym urządzeniu';

  @override
  String get settingsViewOptionalPremiumFeatures =>
      'Wyświetl opcjonalne funkcje Premium';

  @override
  String get settingsReCheckPlayBillingEntitlement =>
      'Sprawdź ponownie uprawnienie Play Billing';

  @override
  String get settingsRtpNotificationAutoClearNotifications =>
      'Automatycznie usuwaj powiadomienia';

  @override
  String get settingsRtpNotificationNever => 'Nigdy';

  @override
  String get settingsRtpNotification5Minutes => '5 minut';

  @override
  String get settingsRtpNotification10Minutes => '10 minut';

  @override
  String get settingsRtpNotification30Minutes => '30 minut';

  @override
  String get settingsThemeBlack => 'Czarny';

  @override
  String get settingsThemeWhite => 'Biały';

  @override
  String get settingsThemeGrey => 'Szary';

  @override
  String get settingsThemeEmerald => 'Szmaragdowy';

  @override
  String get settingsThemePurple => 'Fioletowy';

  @override
  String get settingsThemeRoyalBlue => 'Królewski niebieski';

  @override
  String get settingsAccountCardSyncPurchasesAndUnlockProAcrossApps =>
      'Synchronizuj zakupy i odblokuj Pro we wszystkich aplikacjach.';

  @override
  String get settingsAccountCardLoading => 'Ładowanie...';

  @override
  String get settingsAccountCardDashboard => 'Panel';

  @override
  String get settingsProCardChangePlan => 'Zmień plan';

  @override
  String get advancedNetworkProtectionEnterYourOwnResolver =>
      'Wprowadź własny resolver';

  @override
  String get advancedNetworkProtectionCloudProtectionMode =>
      'Tryb ochrony w chmurze';

  @override
  String get advancedNetworkProtectionRoutesAllDNSQueriesToTheCloud =>
      'Kieruje wszystkie zapytania DNS do silnika w chmurze, umożliwiając aktualizacje list blokowania na żywo, sprawdzanie reputacji domen i więcej.';

  @override
  String get advancedNetworkProtectionRefreshProStatus => 'Odśwież status Pro';

  @override
  String get advancedNetworkProtectionProActive => 'Pro aktywne';

  @override
  String get advancedNetworkProtectionFreePlan => 'Plan bezpłatny';

  @override
  String get advancedNetworkProtectionChecksYourEntitlementAndSyncsItWith =>
      'Sprawdza Twoje uprawnienie i synchronizuje je z funkcjami chmurowymi. Pro odblokowuje blokowanie reklam w całym systemie.';

  @override
  String get advancedNetworkProtectionMalwareProtection =>
      'Ochrona przed złośliwym oprogramowaniem';

  @override
  String get advancedNetworkProtectionBlocksKnownMaliciousDomains =>
      'Blokuje znane złośliwe domeny';

  @override
  String get advancedNetworkProtectionTrackerProtection =>
      'Ochrona przed modułami śledzącymi';

  @override
  String get advancedNetworkProtectionReducesTrackingDomains =>
      'Ogranicza domeny śledzące';

  @override
  String get advancedNetworkProtectionAdProtection => 'Ochrona przed reklamami';

  @override
  String get advancedNetworkProtectionBlocksCommonAdDomains =>
      'Blokuje typowe domeny reklamowe';

  @override
  String get advancedNetworkProtectionAdultFilter =>
      'Filtr treści dla dorosłych';

  @override
  String get advancedNetworkProtectionUses1113Upstream =>
      'Używa 1.1.1.3 jako serwera nadrzędnego';

  @override
  String get advancedNetworkProtectionLockedUntilProIsActiveAndCloud =>
      'Zablokowane do czasu aktywacji Pro i włączenia trybu chmurowego.';

  @override
  String get advancedNetworkProtectionLiveDNSEventsFromTheVPNLayer =>
      'Zdarzenia DNS na żywo z warstwy VPN.';

  @override
  String get advancedNetworkProtectionAdvanced => 'Zaawansowane';

  @override
  String get advancedNetworkProtectionDns => 'DNS';

  @override
  String get advancedNetworkProtectionCloudDNSMode => 'Tryb DNS w chmurze';

  @override
  String get networkProtectionEnterYourOwnResolver =>
      'Wprowadź własny resolver';

  @override
  String get networkAppControlEnableVPNToggles => 'Włącz przełączniki VPN';

  @override
  String get networkAppControlOpenSettings => 'Otwórz ustawienia';

  @override
  String get networkAppControlAppControl => 'Kontrola aplikacji';

  @override
  String get networkAppControlNoAppsFound => 'Nie znaleziono aplikacji.';

  @override
  String get networkSpeedTestCountry => 'Kraj';

  @override
  String get networkSpeedTestRunning => 'W toku';

  @override
  String get networkSpeedTestRunTest => 'Uruchom test';

  @override
  String get networkSpeedTestNoResultsYet => 'Brak wyników.';

  @override
  String networkSpeedTestDnsTLS(Object dns, Object tls) {
    return 'DNS: $dns  •  TLS: $tls';
  }

  @override
  String get networkSpeedTestFail => 'Niepowodzenie';

  @override
  String get dnsNetworkProtectionEnterYourOwnResolver =>
      'Wprowadź własny resolver';

  @override
  String get dnsNetworkProtectionDnsFilteringIsSeperateFromTheSecure =>
      'Filtrowanie DNS jest niezależne od Secure VPN. Może blokować znane złośliwe oprogramowanie, reklamy (we wszystkich aplikacjach), moduły śledzące i treści z niepożądanych kategorii, zanim zostaną załadowane.';

  @override
  String get fullVpnSignedIn => 'Zalogowano.';

  @override
  String get fullVpnSignInRequired => 'Wymagane logowanie';

  @override
  String get fullVpnClose => 'Zamknij';

  @override
  String get fullVpnLoadingUsage => 'Ładowanie użycia...';

  @override
  String get fullVpnSyncing => 'Synchronizowanie';

  @override
  String fullVpnUsedThisMonth(Object usedBytes) {
    return 'W tym miesiącu użyto $usedBytes';
  }

  @override
  String get blockedScreenUnsupportedEnvironment => 'Nieobsługiwane środowisko';

  @override
  String updateLogUpdateV(Object version) {
    return 'Aktualizacja: v$version';
  }

  @override
  String get updateLogHiThereAvarionXHasBeenUpdatedBelow =>
      'Cześć! AvarionX został zaktualizowany. Poniżej znajdziesz zmiany:';

  @override
  String get updateLogNoUserFacingChangesInThisUpdate =>
      'Ta aktualizacja nie zawiera zmian widocznych dla użytkownika.';

  @override
  String get updateLogContinue => 'Kontynuuj';

  @override
  String get featuresRealtimeProtectionBody =>
      'Monitoruje nowe i zmodyfikowane pliki w tle oraz blokuje zagrożenia w chwili ich pojawienia się.';

  @override
  String get featuresTriLayerEngineTitle => 'Silnik trójwarstwowy';

  @override
  String get featuresTriLayerEngineBody =>
      'Trzystopniowy rdzeń wykrywania łączący filtrowanie Bloom, skanowanie sygnatur i analizę bajtową ukierunkowaną na APK, zapewniając wysoką dokładność i szybkość.';

  @override
  String get featuresMachineLearningTitle => 'Uczenie maszynowe';

  @override
  String get featuresMachineLearningBody =>
      'Lekki model działający na urządzeniu, wytrenowany do rozpoznawania wzorców zachowania złośliwych APK.';

  @override
  String get featuresCleanerProTitle => 'Cleaner Pro';

  @override
  String get featuresCleanerProBody =>
      'Rozwijany moduł czyszczenia, który wykrywa duplikaty, pamięć podręczną i nieużywane aplikacje, aby odzyskać miejsce.';

  @override
  String get featuresWifiProtectionTitle => 'Ochrona Wi-Fi';

  @override
  String get featuresWifiProtectionBody =>
      'Wykrywa niebezpieczne lub podejrzane sieci Wi-Fi za pomocą analizy na urządzeniu.';

  @override
  String get featuresRootLevelProtectionTitle => 'Ochrona na poziomie root';

  @override
  String get featuresRootLevelProtectionBody =>
      'Głęboka ochrona na poziomie systemu zaprojektowana dla zrootowanych urządzeń i zaawansowanych użytkowników.';

  @override
  String get featuresPcCompanionTitle => 'Towarzysz PC';

  @override
  String get featuresPcCompanionBody =>
      'Nadchodząca wersja desktopowa do wieloplatformowej integracji antywirusa.';

  @override
  String get deviceSecurityNoRisksFound =>
      'Nie znaleziono zagrożeń dla urządzenia';

  @override
  String get deviceSecurityOneCheckNeedsAttention =>
      '1 kontrola urządzenia wymaga uwagi';

  @override
  String deviceSecurityChecksNeedAttention(Object count) {
    return '$count kontroli urządzenia wymaga uwagi';
  }

  @override
  String get deviceSecurityHealthSectionBody =>
      'Te ustawienia bezpośrednio wpływają na stan bezpieczeństwa urządzenia.';

  @override
  String get deviceSecurityRecommendationsSectionBody =>
      'Te ustawienia są powszechnie zalecanymi dobrymi praktykami bezpieczeństwa.';

  @override
  String get deviceSecuritySignalUnavailable => 'Sygnał niedostępny';

  @override
  String get deviceSecurityIgnoredByYou => 'Zignorowane przez Ciebie';

  @override
  String get deviceSecurityScreenLockInactiveTitle => 'Blokada ekranu';

  @override
  String get deviceSecurityScreenLockActiveLabel =>
      'Niebezpieczne: nie ustawiono bezpiecznej blokady ekranu';

  @override
  String get deviceSecurityScreenLockInactiveLabel =>
      'Blokada ekranu jest aktywna';

  @override
  String get deviceSecurityScreenLockDetail =>
      'Bezpieczna blokada ekranu chroni urządzenie, jeśli zostanie zgubione, skradzione lub pozostawione bez nadzoru. Bez kodu PIN, hasła, wzoru, odcisku palca lub rozpoznawania twarzy zabezpieczonego bezpieczną metodą blokady osoba mająca fizyczny dostęp może łatwiej otworzyć urządzenie.';

  @override
  String get deviceSecurityScreenLockHelp =>
      'Otwórz ustawienia zabezpieczeń Androida i ustaw bezpieczną blokadę ekranu.';

  @override
  String get deviceSecurityCheckSetting => 'Sprawdź ustawienie';

  @override
  String get deviceSecurityPrivilegedInactiveTitle =>
      'Brak uprzywilejowanego dostępu';

  @override
  String get deviceSecurityPrivilegedActiveLabel =>
      'Wykryto uprzywilejowany dostęp';

  @override
  String get deviceSecurityPrivilegedInactiveLabel =>
      'Nie wykryto uprzywilejowanego dostępu';

  @override
  String get deviceSecurityPrivilegedDetail =>
      'Root i Shizuku mogą być przydatne, ale zwiększają też skutki działania złośliwej aplikacji, jeśli dostęp zostanie nadużyty. Aplikacje z uprzywilejowanym dostępem mogą wykonywać czynności niedostępne dla zwykłych aplikacji Androida.';

  @override
  String get deviceSecurityPrivilegedHelp =>
      'Ręcznie sprawdź ustawienia root, Magisk lub Shizuku.';

  @override
  String get deviceSecurityReviewSetting => 'Przejrzyj ustawienie';

  @override
  String get deviceSecurityAppVerificationInactiveTitle =>
      'Weryfikacja aplikacji';

  @override
  String get deviceSecurityAppVerificationActiveLabel =>
      'Niebezpieczne: weryfikacja aplikacji wygląda na wyłączoną';

  @override
  String get deviceSecurityAppVerificationInactiveLabel =>
      'Weryfikacja aplikacji wygląda na włączoną';

  @override
  String get deviceSecurityAppVerificationDetail =>
      'Weryfikacja aplikacji w Androidzie pomaga sprawdzać aplikacje przed lub po instalacji. Jeśli ta ochrona jest wyłączona lub niedostępna, szkodliwe aplikacje mogą rzadziej być blokowane przed uruchomieniem.';

  @override
  String get deviceSecurityAppVerificationHelp =>
      'Otwórz ustawienia zabezpieczeń Androida i sprawdź weryfikację aplikacji.';

  @override
  String get deviceSecuritySecurityPatchInactiveTitle =>
      'Aktualna poprawka zabezpieczeń';

  @override
  String get deviceSecuritySecurityPatchActiveLabel =>
      'Poziom poprawek zabezpieczeń jest nieaktualny';

  @override
  String get deviceSecuritySecurityPatchInactiveLabel =>
      'Poziom poprawek zabezpieczeń jest aktualny';

  @override
  String get deviceSecuritySecurityPatchDetail =>
      'Poprawki zabezpieczeń Androida naprawiają znane problemy platformy i producentów. Jeśli poziom poprawek jest stary, urządzenie może być narażone na luki, które zostały już naprawione w nowszych kompilacjach.';

  @override
  String get deviceSecuritySecurityPatchHelp =>
      'Otwórz ustawienia aktualizacji systemu Android i sprawdź dostępność aktualizacji.';

  @override
  String get deviceSecurityCheckUpdates => 'Sprawdź aktualizacje';

  @override
  String get deviceSecurityDeveloperModeInactiveTitle => 'Tryb programisty';

  @override
  String get deviceSecurityDeveloperModeActiveLabel =>
      'Opcje programisty są włączone';

  @override
  String get deviceSecurityDeveloperModeInactiveLabel =>
      'Opcje programisty są wyłączone';

  @override
  String get deviceSecurityDeveloperModeDetail =>
      'Tryb programisty jest normalny dla programistów i testerów, ale udostępnia zaawansowane ustawienia, które mogą obniżyć bezpieczeństwo urządzenia, jeśli zostaną zmienione przypadkowo lub wykorzystane przez osobę mającą dostęp do urządzenia.';

  @override
  String get deviceSecurityDeveloperModeHelp =>
      'Otwórz Opcje programisty i wyłącz ustawienia, których nie potrzebujesz.';

  @override
  String get deviceSecurityUsbDebuggingInactiveTitle => 'Debugowanie USB';

  @override
  String get deviceSecurityUsbDebuggingActiveLabel =>
      'Niebezpieczne: debugowanie USB jest włączone';

  @override
  String get deviceSecurityUsbDebuggingInactiveLabel =>
      'Debugowanie USB jest wyłączone';

  @override
  String get deviceSecurityUsbDebuggingDetail =>
      'Debugowanie USB pozwala podłączonemu komputerowi komunikować się z urządzeniem przez Android Debug Bridge. Pozostawienie go włączonego zwiększa ryzyko nieautoryzowanego dostępu po podłączeniu do niezaufanego komputera.';

  @override
  String get deviceSecurityUsbDebuggingHelp =>
      'Otwórz Opcje programisty i wyłącz debugowanie USB.';

  @override
  String get deviceSecurityUnknownSourcesInactiveTitle => 'Nieznane źródła';

  @override
  String get deviceSecurityUnknownSourcesActiveLabel =>
      'Instalowanie nieznanych aplikacji jest dozwolone';

  @override
  String get deviceSecurityUnknownSourcesInactiveLabel =>
      'Instalowanie nieznanych aplikacji jest ograniczone';

  @override
  String get deviceSecurityUnknownSourcesDetail =>
      'Zezwalanie na instalowanie nieznanych aplikacji może być przydatne w przypadku zaufanych APK, ale zwiększa też ryzyko instalacji aplikacji z niebezpiecznych źródeł. Zezwalaj na to tylko aplikacjom i sklepom, którym ufasz.';

  @override
  String get deviceSecurityUnknownSourcesHelp =>
      'Otwórz ustawienia Androida i sprawdź dostęp do instalowania nieznanych aplikacji.';

  @override
  String get deviceSecurityAccessibilityInactiveTitle =>
      'Usługi ułatwień dostępu';

  @override
  String get deviceSecurityAccessibilityActiveLabel =>
      'Włączona usługa ułatwień dostępu innej firmy';

  @override
  String get deviceSecurityAccessibilityInactiveLabel =>
      'Nie znaleziono ryzykownych usług ułatwień dostępu';

  @override
  String get deviceSecurityAccessibilityDetail =>
      'Usługi ułatwień dostępu mają szerokie możliwości, ponieważ mogą obserwować zawartość ekranu i wykonywać działania w imieniu użytkownika. Jest to przydatne dla legalnych narzędzi, ale funkcja ta jest też często nadużywana przez złośliwe aplikacje.';

  @override
  String get deviceSecurityAccessibilityHelp =>
      'Otwórz ustawienia Ułatwień dostępu i sprawdź włączone usługi.';

  @override
  String get deviceSecurityChecking => 'Sprawdzanie bezpieczeństwa urządzenia';

  @override
  String get deviceSecurityReadingSignals =>
      'Odczytywanie sygnałów stanu urządzenia...';

  @override
  String get deviceSecurityOneCheckAttention => '1 kontrola wymaga uwagi';

  @override
  String deviceSecurityChecksAttention(Object count) {
    return '$count kontroli wymaga uwagi';
  }

  @override
  String get deviceSecurityTapSignal =>
      'Dotknij sygnału poniżej, aby dowiedzieć się więcej.';

  @override
  String deviceSecurityIgnoredChecks(Object count, String plural) {
    String _temp0 = intl.Intl.selectLogic(
      plural,
      {
        's': '',
        'other': '',
      },
    );
    return 'Zignorowane aktywne kontrole: $count.$_temp0';
  }

  @override
  String get deviceSecurityPostureNormal =>
      'Kontrole stanu bezpieczeństwa urządzenia wyglądają prawidłowo.';

  @override
  String get timeJustNow => 'przed chwilą';

  @override
  String timeMinutesAgo(Object minutes) {
    return '$minutes min temu';
  }

  @override
  String timeHoursAgo(Object hours) {
    return '$hours godz. temu';
  }

  @override
  String timeDaysAgo(Object days) {
    return '$days dni temu';
  }

  @override
  String get securityNoReportDataYet => 'Brak danych raportu';

  @override
  String securityLastActivity(Object relative) {
    return 'Ostatnia aktywność $relative';
  }

  @override
  String get securityReportSharePdfTitle => 'Raport bezpieczeństwa Avarionx';

  @override
  String get securityReportCsvField => 'Pole';

  @override
  String get securityReportCsvValue => 'Wartość';

  @override
  String get securityReportGeneratedAt => 'Wygenerowano';

  @override
  String get securityReportOverallStatus => 'Stan ogólny';

  @override
  String get securityReportLastManualScan => 'Ostatnie skanowanie ręczne';

  @override
  String get securityReportLastRealtimeEvent =>
      'Ostatnie zdarzenie w czasie rzeczywistym';

  @override
  String get securityReportLastScheduledScan =>
      'Ostatnie zaplanowane skanowanie';

  @override
  String get securityReportShareCsvTitle =>
      'Raport bezpieczeństwa Avarionx CSV';

  @override
  String get securityReportReviewRecommended => 'Zalecany przegląd';

  @override
  String get securityReportNoKnownThreatDetected =>
      'Nie wykryto znanego zagrożenia';

  @override
  String securityReportGeneratedLine(Object generatedAt) {
    return 'Wygenerowano: $generatedAt';
  }

  @override
  String securityReportStatusLine(Object status) {
    return 'Stan: $status';
  }

  @override
  String securityReportLatestActivityLine(Object latest) {
    return 'Ostatnia aktywność: $latest';
  }

  @override
  String securityReportManualScansLine(Object count) {
    return 'Skanowania ręczne: $count';
  }

  @override
  String securityReportRealtimeChecksLine(Object count) {
    return 'Kontrole w czasie rzeczywistym: $count';
  }

  @override
  String securityReportTotalFilesScannedLine(Object count) {
    return 'Łącznie przeskanowanych plików: $count';
  }

  @override
  String securityReportThreatsFoundLine(Object count) {
    return 'Znalezione zagrożenia: $count';
  }

  @override
  String securityReportLastManualScanLine(Object value) {
    return 'Ostatnie skanowanie ręczne: $value';
  }

  @override
  String securityReportLastRealtimeEventLine(Object value) {
    return 'Ostatnie zdarzenie w czasie rzeczywistym: $value';
  }

  @override
  String securityReportLastScheduledScanLine(Object value) {
    return 'Ostatnie zaplanowane skanowanie: $value';
  }

  @override
  String get securityReportNotRecorded => 'Nie zarejestrowano';

  @override
  String get safeViewNavigationBlocked => 'Nawigacja zablokowana';

  @override
  String get safeViewInvalidDestination => 'Nieprawidłowy cel';

  @override
  String get safeViewUnsupportedScheme => 'Nieobsługiwany schemat';

  @override
  String get safeViewUnableToResolveDestination => 'Nie można rozpoznać celu';

  @override
  String get safeViewDestinationBlocked => 'Cel zablokowany';

  @override
  String get safeViewUnableToVerifyDestination => 'Nie można zweryfikować celu';

  @override
  String proScreenCurrentStatus(Object status) {
    return 'Bieżący stan: $status';
  }

  @override
  String proScreenBilledAnnuallyAt(Object price) {
    return 'Rozliczane rocznie w cenie $price';
  }

  @override
  String get quarantineUnknownApp => 'Nieznana aplikacja';

  @override
  String get cleanerScanCancelled => 'Skanowanie anulowane';

  @override
  String get cleanerProClearingCaches => 'Czyszczenie pamięci podręcznej…';

  @override
  String get cleanerProTrimAppCaches =>
      'Ogranicz pamięć podręczną aplikacji na całym urządzeniu.';

  @override
  String get cleanerProEnableShizuku =>
      'Włącz Shizuku w Ustawieniach, aby użyć tej funkcji.';

  @override
  String get cleanerProScanningStorage => 'Skanowanie pamięci…';

  @override
  String get cleanerProFindLogFiles =>
      'Znajdź pliki .log, .trace, .crash i .dmp.';

  @override
  String cleanerProLogFileCount(Object count, Object size) {
    return '$count plików • $size';
  }

  @override
  String get cleanerProAppManagerReady =>
      'Wymuszaj zatrzymanie, czyść dane i grupowo odinstalowuj aplikacje.';

  @override
  String get cleanerProAppManagerLimited =>
      'Odinstalowywanie działa normalnie. Wymuszenie zatrzymania i czyszczenie danych wymagają Shizuku.';

  @override
  String get cleanerProCheckingShizuku => 'Sprawdzanie Shizuku…';

  @override
  String get cleanerProShizukuNotRunning =>
      'Shizuku nie działa. Włącz je w Ustawieniach, gdy będzie potrzebne.';

  @override
  String get cleanerProShizukuPermissionMissing =>
      'Nie przyznano uprawnienia Shizuku. Włącz je w Ustawieniach.';

  @override
  String get cleanerProShizukuNotBound =>
      'Usługa Shizuku nie jest jeszcze powiązana. Otwórz Ustawienia i odśwież ten ekran po jej włączeniu.';

  @override
  String get cleanerLiteTab => 'Lite';

  @override
  String get cleanerProTab => 'Pro';

  @override
  String get scanCancelled => 'Skanowanie anulowane';

  @override
  String get scanPreparing => 'Przygotowywanie skanowania...';

  @override
  String scanSuspiciousItemsFound(Object count, String plural) {
    String _temp0 = intl.Intl.selectLogic(
      plural,
      {
        's': '',
        'other': '',
      },
    );
    return 'Znalezione podejrzane elementy: $count.$_temp0';
  }

  @override
  String scanSuspiciousCount(Object count) {
    return 'Podejrzane: $count';
  }

  @override
  String scanCleanCount(Object count) {
    return 'Czyste: $count';
  }

  @override
  String scanNotificationFullItems(Object count) {
    return 'Przeskanowano: $count elementów';
  }

  @override
  String scanNotificationCurrent(Object count, Object file) {
    return 'Przeskanowano: $count • $file';
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
  String get settingsThemeRoyalBluePremium => 'Królewski niebieski (Premium)';

  @override
  String get settingsIconDefault => 'Domyślna';

  @override
  String get settingsIconBird => 'Ptak';

  @override
  String get settingsIconNeon => 'Neon';

  @override
  String get settingsIconOriginal => 'Oryginalna';

  @override
  String get homeRealtimeProtectionTitle => 'Ochrona w czasie rzeczywistym';

  @override
  String get networkCardStatusLocked => 'Zablokowane';

  @override
  String get networkSectionConnection => 'Połączenie';

  @override
  String get networkSectionBlocklists => 'Listy blokowania';

  @override
  String get networkSectionResolver => 'Resolver';

  @override
  String get networkAppControlOtherVpnSetupInstructions =>
      'Inna sieć VPN jest obecnie wybrana jako Zawsze aktywna.\n\nAby niezawodnie blokować aplikacje:\n\n1) Otwórz ustawienia VPN Androida\n2) Wybierz AvarionX jako VPN\n3) Włącz Zawsze aktywną sieć VPN\n4) Włącz Blokuj połączenia bez VPN';

  @override
  String get networkAppControlSetupInstructions =>
      'Aby niezawodnie blokować aplikacje:\n\n1) Otwórz ustawienia VPN Androida\n2) Wybierz AvarionX jako VPN\n3) Włącz Zawsze aktywną sieć VPN\n4) Włącz Blokuj połączenia bez VPN';

  @override
  String get networkAppControlBlockingActive =>
      'Blokowanie aplikacji jest aktywne.';

  @override
  String get networkAppControlOtherVpnWarning =>
      'Inna sieć VPN jest ustawiona jako Zawsze aktywna. Włącz Zawsze aktywna + Blokuj bez VPN dla AvarionX.';

  @override
  String get networkAppControlSetupWarning =>
      'Włącz Zawsze aktywna + Blokuj bez VPN dla AvarionX, aby blokowanie aplikacji działało.';

  @override
  String get countryUnitedKingdom => 'Wielka Brytania';

  @override
  String get countryUnitedStates => 'Stany Zjednoczone';

  @override
  String get countryCanada => 'Kanada';

  @override
  String get countryIreland => 'Irlandia';

  @override
  String get countryFrance => 'Francja';

  @override
  String get countryGermany => 'Niemcy';

  @override
  String get countryNetherlands => 'Holandia';

  @override
  String get countrySpain => 'Hiszpania';

  @override
  String get countryItaly => 'Włochy';

  @override
  String get countrySweden => 'Szwecja';

  @override
  String get countryNorway => 'Norwegia';

  @override
  String get countryDenmark => 'Dania';

  @override
  String get countryPoland => 'Polska';

  @override
  String get countryTurkey => 'Turcja';

  @override
  String get countryGreece => 'Grecja';

  @override
  String get countryRomania => 'Rumunia';

  @override
  String get countryUkraine => 'Ukraina';

  @override
  String get countryRussia => 'Rosja';

  @override
  String get countryIndia => 'Indie';

  @override
  String get countryPakistan => 'Pakistan';

  @override
  String get countryBangladesh => 'Bangladesz';

  @override
  String get countrySriLanka => 'Sri Lanka';

  @override
  String get countryNepal => 'Nepal';

  @override
  String get countryJapan => 'Japonia';

  @override
  String get countrySouthKorea => 'Korea Południowa';

  @override
  String get countrySingapore => 'Singapur';

  @override
  String get countryMalaysia => 'Malezja';

  @override
  String get countryThailand => 'Tajlandia';

  @override
  String get countryVietnam => 'Wietnam';

  @override
  String get countryPhilippines => 'Filipiny';

  @override
  String get countryIndonesia => 'Indonezja';

  @override
  String get countryAustralia => 'Australia';

  @override
  String get countryNewZealand => 'Nowa Zelandia';

  @override
  String get countryBrazil => 'Brazylia';

  @override
  String get countryArgentina => 'Argentyna';

  @override
  String get countryChile => 'Chile';

  @override
  String get countryMexico => 'Meksyk';

  @override
  String get countryColombia => 'Kolumbia';

  @override
  String get countryPeru => 'Peru';

  @override
  String get countrySouthAfrica => 'Republika Południowej Afryki';

  @override
  String get countryNigeria => 'Nigeria';

  @override
  String get countryKenya => 'Kenia';

  @override
  String get countryEgypt => 'Egipt';

  @override
  String get countryUAE => 'Zjednoczone Emiraty Arabskie';

  @override
  String get countrySaudiArabia => 'Arabia Saudyjska';

  @override
  String get countryIsrael => 'Izrael';

  @override
  String networkSpeedTestTesting(Object current, Object total, Object domain) {
    return 'Testowanie $current/$total • $domain';
  }

  @override
  String get networkSpeedTestDone => 'Gotowe';

  @override
  String get vpnFooterCustomisation => 'Personalizacja';

  @override
  String get apkClipboardReportTitle => 'VTTI Cloud - Raport analizy APK';

  @override
  String apkClipboardAppName(Object name) {
    return 'Nazwa aplikacji: $name';
  }

  @override
  String apkClipboardPackageId(Object packageId) {
    return 'ID pakietu: $packageId';
  }

  @override
  String apkClipboardVersion(Object version) {
    return 'Wersja: $version';
  }

  @override
  String apkClipboardFileSize(Object size) {
    return 'Rozmiar pliku: $size';
  }

  @override
  String apkClipboardMinSdk(Object sdk) {
    return 'Min. SDK: $sdk';
  }

  @override
  String apkClipboardTargetSdk(Object sdk) {
    return 'Docelowe SDK: $sdk';
  }

  @override
  String apkClipboardSignature(Object signature) {
    return 'Podpis: $signature';
  }

  @override
  String apkClipboardMalwareRisk(Object risk) {
    return 'Ryzyko złośliwego oprogramowania: $risk';
  }

  @override
  String apkClipboardRiskLabel(Object label) {
    return 'Etykieta ryzyka: $label';
  }

  @override
  String apkClipboardHashVerdict(Object verdict) {
    return 'Werdykt skrótu: $verdict';
  }

  @override
  String apkClipboardRationale(Object rationale) {
    return 'Uzasadnienie: $rationale';
  }

  @override
  String get apkReportUnusualFlags => 'Nietypowe flagi';

  @override
  String get apkReportUnverifiedItems => 'Niezweryfikowane elementy';

  @override
  String get apkReportKnownMalware => 'Znane złośliwe oprogramowanie';

  @override
  String get apkReportSuspiciousHash => 'Podejrzany skrót';

  @override
  String get apkReportCleanHash => 'Czysty skrót';

  @override
  String get apkReportHashNotChecked => 'Skrót niesprawdzony';

  @override
  String get apkReportHashUnknown => 'Nieznany skrót';

  @override
  String get apkMetadataPackage => 'Pakiet';

  @override
  String get apkMetadataPackageId => 'ID pakietu';

  @override
  String get apkMetadataEngine => 'Silnik';

  @override
  String get apkMetadataSize => 'Rozmiar';

  @override
  String get apkMetadataMinSdk => 'Min. SDK';

  @override
  String get apkMetadataTargetSdk => 'Docelowe SDK';

  @override
  String get apkMetadataSignature => 'Podpis';

  @override
  String get apkAnalyserStageDeconstructing => 'Rozkładanie APK';

  @override
  String get apkAnalyserStageAnalysing => 'Analizowanie zawartości';

  @override
  String get apkAnalyserSignInRequired =>
      'Zaloguj się w Ustawieniach, aby użyć Cloud Analysis.';

  @override
  String get apkAnalyserStageCheckingCloud => 'Sprawdzanie VTTI Cloud';

  @override
  String apkAnalyserDailyLimitReached(Object limit) {
    return 'Osiągnięto dzienny limit $limit analiz.';
  }

  @override
  String get apkAnalyserCloudAnalysisFailed =>
      'Analiza w chmurze nie powiodła się';

  @override
  String get apkAnalyserStageGeneratingReport => 'Generowanie raportu';

  @override
  String get apkAnalyserAnalysisFailed =>
      'Nie udało się przetworzyć analizy APK';

  @override
  String get genericError => 'Błąd';

  @override
  String get apkReportEngineVttiCloud => 'Silnik VTTI Cloud';

  @override
  String get apkReportCertificateDetected => 'Wykryto certyfikat';

  @override
  String get apkReportNoCertificateData => 'Brak danych certyfikatu';

  @override
  String get apkExportOverview => 'Przegląd';

  @override
  String get apkExportMalwareAssessment => 'Ocena złośliwego oprogramowania';

  @override
  String get apkExportRiskScore => 'Wynik ryzyka';

  @override
  String get apkExportRiskLabel => 'Etykieta ryzyka';

  @override
  String get apkExportHashVerdict => 'Werdykt skrótu';

  @override
  String get apkExportScoreRationale => 'Uzasadnienie wyniku';

  @override
  String get apkExportContributingSignals => 'Sygnały wpływające';

  @override
  String get apkExportDampeningFactors => 'Czynniki łagodzące';

  @override
  String get apkExportPermissionsRequested => 'Żądane uprawnienia';

  @override
  String get apkExportExtraFlagsUnusual => 'Dodatkowe flagi (nietypowe)';

  @override
  String get apkExportExtraFlagsUnverified =>
      'Dodatkowe flagi (niezweryfikowane)';

  @override
  String get apkExportDiscoveredSources => 'Wykryte źródła';

  @override
  String get apkExportRequestedPermissions => 'Żądane uprawnienia';

  @override
  String get apkExportRationale => 'Uzasadnienie';

  @override
  String apkExportCsvShareText(Object name) {
    return 'CSV analizy APK dla $name';
  }

  @override
  String get apkExportPdfTitle => 'VTTI Cloud - Analiza APK';

  @override
  String apkExportPdfShareText(Object name) {
    return 'PDF analizy APK dla $name';
  }

  @override
  String get apkMetadataAppName => 'Nazwa aplikacji';

  @override
  String get apkMetadataFileSize => 'Rozmiar pliku';

  @override
  String get vpnBackendFailedOpenBrowser =>
      'Nie udało się otworzyć przeglądarki.';

  @override
  String get vpnBackendSignedIn => 'Zalogowano.';

  @override
  String get vpnBackendSignedOut => 'Wylogowano.';

  @override
  String get vpnBackendSessionExpiredSignIn =>
      'Sesja wygasła. Zaloguj się ponownie.';

  @override
  String vpnBackendFailedLoadAccountStatus(Object status) {
    return 'Nie udało się wczytać konta ($status).';
  }

  @override
  String vpnBackendFailedLoadAccountError(Object error) {
    return 'Nie udało się wczytać konta ($error).';
  }

  @override
  String get vpnBackendSignInFirst => 'Najpierw się zaloguj.';

  @override
  String get vpnBackendConnecting => 'Łączenie...';

  @override
  String get vpnBackendNotificationsPermissionRequired =>
      'Wymagane jest uprawnienie do powiadomień.';

  @override
  String get vpnBackendPermissionNotGranted => 'Nie przyznano uprawnienia VPN.';

  @override
  String get vpnBackendAnotherVpnActive =>
      'Inna sieć VPN jest aktywna. Najpierw ją wyłącz.';

  @override
  String get vpnBackendProvisionIncomplete =>
      'Obsługa konfiguracji zwróciła niekompletne ustawienia.';

  @override
  String get vpnBackendSecuringConnection => 'Zabezpieczanie połączenia...';

  @override
  String get vpnBackendConnected => 'Połączono.';

  @override
  String vpnBackendWireGuardFailed(Object error) {
    return 'Nie udało się uruchomić WireGuard ($error).';
  }

  @override
  String get vpnBackendDisconnecting => 'Rozłączanie...';

  @override
  String get vpnBackendDisconnected => 'Rozłączono.';

  @override
  String vpnBackendSelectedServer(Object server) {
    return 'Wybrano $server';
  }

  @override
  String vpnBackendSwitchingServer(Object server) {
    return 'Przełączanie na $server...';
  }

  @override
  String get vpnBackendKeyNotFound => 'Nie znaleziono klucza VPN.';

  @override
  String get vpnBackendDnsUpdated => 'Ustawienia DNS zaktualizowane.';

  @override
  String get vpnBackendSessionExpired => 'Sesja wygasła.';

  @override
  String vpnBackendFailedStatus(Object status) {
    return 'Niepowodzenie ($status).';
  }

  @override
  String get vpnBackendPlanNotAllowed =>
      'Twój plan nie pozwala korzystać z Full VPN.';

  @override
  String vpnBackendProvisionFailed(Object status) {
    return 'Konfiguracja nie powiodła się ($status).';
  }
}
