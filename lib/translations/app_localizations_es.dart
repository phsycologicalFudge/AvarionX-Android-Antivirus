// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appName => 'AVarionX Security';

  @override
  String get ok => 'OK';

  @override
  String get cancel => 'Cancelar';

  @override
  String get footerHome => 'Inicio';

  @override
  String get footerExplore => 'Explorar';

  @override
  String get footerRemoved => 'Eliminados';

  @override
  String get footerSettings => 'Ajustes';

  @override
  String get proBadge => 'PRO';

  @override
  String get updateDbTitle => 'Actualizando base de datos';

  @override
  String updateDbVersionLabel(Object version) {
    return 'Versión $version';
  }

  @override
  String get exploreMultiThreadingTitle => 'Multihilo';

  @override
  String get exploreMultiThreadingSubtitle => 'Control experimental del motor';

  @override
  String get updateDbAutoDownloadLabel =>
      'Descargar automáticamente futuras actualizaciones';

  @override
  String get updateDbUpdatedAutoOn =>
      'Base de datos actualizada • Actualizaciones automáticas activadas';

  @override
  String get updateDbUpdatedSuccess =>
      'Base de datos actualizada correctamente';

  @override
  String get updateDbUpdateFailed => 'Error al actualizar la base de datos';

  @override
  String get engineReadyBanner => 'MOTOR LISTO • VX-TITANIUM-v7';

  @override
  String get scanButton => 'Escanear';

  @override
  String get scanModeFullTitle => 'Escaneo completo del dispositivo';

  @override
  String get scanModeFullSubtitle =>
      'Escanea todos los archivos legibles del almacenamiento.';

  @override
  String get scanModeSmartTitle => 'Escaneo inteligente [Recomendado]';

  @override
  String get scanModeSmartSubtitle =>
      'Escanea archivos que podrían contener malware.';

  @override
  String get scanModeRapidTitle => 'Escaneo rápido';

  @override
  String get scanModeRapidSubtitle => 'Revisa APK recientes en Descargas.';

  @override
  String get scanModeInstalledTitle => 'Apps instaladas';

  @override
  String get scanModeInstalledSubtitle =>
      'Escanea tus apps instaladas en busca de amenazas.';

  @override
  String get scanModeSingleTitle => 'Escaneo de archivo / app';

  @override
  String get scanModeSingleSubtitle => 'Elige un archivo o app para escanear.';

  @override
  String get useCloudAssistedScan => 'Usar escaneo asistido en la nube';

  @override
  String get protectionTitle => 'Protección';

  @override
  String get stateOffLine1 => 'La protección del dispositivo está desactivada';

  @override
  String get stateOffLine2 => 'Toca para activar';

  @override
  String get stateAdvancedActiveLine1 => 'La protección avanzada está activa';

  @override
  String get stateFileOnlyLine1 => 'Solo protección de archivos';

  @override
  String get stateFileOnlyLine2 => 'Protección de red desactivada';

  @override
  String get stateVpnConflictLine2 => 'Otro VPN está activo';

  @override
  String get stateProtectedLine1 => 'Dispositivo protegido';

  @override
  String get stateProtectedLine2 => 'Toca para desactivar';

  @override
  String get dbUpdating => 'Actualizando base de datos';

  @override
  String dbVersionAutoUpdated(Object version) {
    return 'Base de datos v$version • Actualizada automáticamente';
  }

  @override
  String get rtpInfoTitle => 'Protección en tiempo real';

  @override
  String get rtpInfoBody =>
      'Además de bloquear archivos sospechosos descargados intencionalmente (o por malware), RTP usa un VPN local para bloquear dominios maliciosos en todo el sistema.\n\nCuando está activado, el filtrado de red permanece activo a menos que:\n• Se desactive manualmente mediante Terminal\n• Sea reemplazado por otro VPN\n\nLa protección de archivos continúa mientras RTP esté activado.';

  @override
  String get scanTitleDefault => 'Escanear';

  @override
  String get scanTitleSmart => 'Escaneo inteligente';

  @override
  String get scanTitleRapid => 'Escaneo rápido';

  @override
  String get scanTitleInstalled => 'Escanear apps instaladas';

  @override
  String get scanTitleFull => 'Escaneo completo del dispositivo';

  @override
  String get scanTitleSingle => 'Escaneo único';

  @override
  String get cancellingScan => 'Cancelando escaneo…';

  @override
  String get cancelScan => 'Cancelar escaneo';

  @override
  String get scanProgressZero => 'Progreso: 0%';

  @override
  String scanProgressWithPct(Object pct, Object scanned, Object total) {
    return 'Progreso: $pct% ($scanned / $total)';
  }

  @override
  String scanProgressFullItems(Object count) {
    return 'Escaneados: $count elementos';
  }

  @override
  String get initializing => 'Inicializando...';

  @override
  String get scanningEllipsis => 'Escaneando...';

  @override
  String get fullScanInfoTitle => 'Escaneo completo del dispositivo';

  @override
  String get fullScanInfoBody =>
      'Este modo escanea cada archivo legible del almacenamiento, sin filtros.\n\nEl escaneo asistido en la nube y el escaneo de apps no se usan en este modo.';

  @override
  String get scanComplete => 'Escaneo completo';

  @override
  String pillSuspiciousCount(Object count) {
    return 'Sospechosos: $count';
  }

  @override
  String pillCleanCount(Object count) {
    return 'Limpios: $count';
  }

  @override
  String pillScannedCount(Object count) {
    return 'Escaneados: $count';
  }

  @override
  String get resultNoThreatsTitle => 'No se detectaron amenazas';

  @override
  String get resultNoThreatsBody =>
      'No se detectaron amenazas en los elementos escaneados.';

  @override
  String get resultSuspiciousAppsTitle => 'Apps sospechosas';

  @override
  String get resultSuspiciousItemsTitle => 'Elementos sospechosos';

  @override
  String get returnHome => 'Volver al inicio';

  @override
  String get emptyTitle => 'No hay archivos vulnerables para escanear';

  @override
  String get emptyBody =>
      'Tu dispositivo no contenía archivos que coincidan con los criterios de escaneo.';

  @override
  String get knownMalware => 'Malware conocido';

  @override
  String get suspiciousActivityDetected => 'Actividad sospechosa detectada';

  @override
  String get maliciousActivityDetected => 'Actividad maliciosa detectada';

  @override
  String get androidBankingTrojan => 'Troyano bancario de Android';

  @override
  String get androidSpyware => 'Spyware de Android';

  @override
  String get androidAdware => 'Adware de Android';

  @override
  String get androidSmsFraud => 'Fraude por SMS en Android';

  @override
  String get threatLevelConfirmed => 'Confirmado';

  @override
  String get threatLevelHigh => 'Alto';

  @override
  String get threatLevelMedium => 'Medio';

  @override
  String threatLevelLabel(Object level) {
    return 'Nivel de amenaza: $level';
  }

  @override
  String get explainFoundInCloud =>
      'Este elemento está listado en la base de datos de amenazas en la nube de ColourSwift.';

  @override
  String get explainFoundInOffline =>
      'Este elemento está listado en la base de datos de malware offline de tu dispositivo.';

  @override
  String get explainBanker =>
      'Diseñado para robar credenciales financieras, a menudo usando superposiciones, keylogging o interceptación de tráfico.';

  @override
  String get explainSpyware =>
      'Monitorea la actividad en silencio o recopila datos personales como mensajes, ubicación o identificadores del dispositivo.';

  @override
  String get explainAdware =>
      'Muestra anuncios intrusivos, realiza redirecciones o genera tráfico publicitario fraudulento.';

  @override
  String get explainSmsFraud =>
      'Intenta enviar o activar acciones por SMS sin consentimiento, lo que puede causar cargos inesperados.';

  @override
  String get explainGenericMalware =>
      'Se detectaron fuertes indicadores de intención maliciosa, aunque no coincida con una familia conocida.';

  @override
  String get explainSuspiciousDefault =>
      'Se detectaron indicadores de comportamiento sospechoso. Esto puede incluir patrones vistos en malware, pero también podría ser un falso positivo.';

  @override
  String get singleChoiceScanFile => 'Escanear un archivo';

  @override
  String get singleChoiceScanInstalledApp => 'Escanear una app instalada';

  @override
  String get singleChoiceManageExclusions => 'Gestionar exclusiones';

  @override
  String get labelKnownMalwareDb => 'Encontrado en la base de datos de malware';

  @override
  String get labelFoundInCloudDb => 'Encontrado en la base de datos en la nube';

  @override
  String get logEngineFullDeviceScan =>
      '[ENGINE] Escaneo completo del dispositivo';

  @override
  String get logEngineTargetStorage => '[ENGINE] Objetivo: /storage/emulated/0';

  @override
  String get logEngineNoFilesFound => '[ENGINE] No se encontraron archivos.';

  @override
  String logEngineFilesEnumerated(Object count) {
    return '[ENGINE] Archivos enumerados: $count';
  }

  @override
  String get logEngineNoReadableFilesFound =>
      '[ENGINE] No se encontraron archivos legibles.';

  @override
  String logEngineInstalledAppsFound(Object count) {
    return '[ENGINE] Apps instaladas encontradas: $count';
  }

  @override
  String get logModeCloudAssisted => '[MODE] Modo asistido en la nube';

  @override
  String get logModeOffline => '[MODE] Modo offline';

  @override
  String get logStageHashing =>
      '[STAGE 1] Obteniendo hashes de archivos (en caché)...';

  @override
  String get logStageCloudLookup => '[STAGE 2] Búsqueda de hash en la nube...';

  @override
  String logStageLocalScanning(Object stage) {
    return '[STAGE $stage] Escaneo local de archivos...';
  }

  @override
  String logCloudHashHits(Object count) {
    return '[CLOUD] $count coincidencias de hash';
  }

  @override
  String logSummary(Object suspicious, Object clean) {
    return '[SUMMARY] $suspicious sospechosos • $clean limpios';
  }

  @override
  String logErrorPrefix(Object message) {
    return '[ERROR] $message';
  }

  @override
  String get genericUnknownAppName => 'Desconocido';

  @override
  String get genericUnknownFileName => 'Desconocido';

  @override
  String get featuresDrawerTitle => 'Funciones';

  @override
  String get recommendedSectionTitle => 'Recomendado';

  @override
  String get featureNetworkProtection => 'Protección de red';

  @override
  String get featureLinkChecker => 'Comprobador de enlaces';

  @override
  String get featureMetaPass => 'MetaPass';

  @override
  String get featureCleanerPro => 'Cleaner Pro';

  @override
  String get featureTerminal => 'Terminal';

  @override
  String get featureScheduledScans => 'Escaneos programados';

  @override
  String get networkStatusDisconnected => 'Desconectado';

  @override
  String get networkStatusConnecting => 'Conectando';

  @override
  String get networkStatusConnected => 'Conectado';

  @override
  String get networkUsageTitle => 'Uso';

  @override
  String get networkUsageEnableVpnToView => 'Activa el VPN para ver el uso.';

  @override
  String get networkUsageUnlimited => 'Ilimitado';

  @override
  String networkUsageUsedOf(Object used, Object limit) {
    return '$used / $limit';
  }

  @override
  String networkUsageResetsOn(Object y, Object m, Object d) {
    return 'Se restablece el $y-$m-$d';
  }

  @override
  String networkUsageUpdatedAt(Object hh, Object mm) {
    return 'Actualizado $hh:$mm';
  }

  @override
  String get networkCardStatusAvailable => 'Disponible';

  @override
  String get networkCardStatusDisabled => 'Desactivado';

  @override
  String get networkCardStatusCustom => 'Personalizado';

  @override
  String get networkCardStatusReady => 'Listo';

  @override
  String get networkCardStatusOpen => 'Abrir';

  @override
  String get networkCardStatusComingSoon => 'Próximamente';

  @override
  String get networkCardBlocklistsTitle => 'Listas de bloqueo';

  @override
  String get networkCardBlocklistsSubtitle => 'Controles de filtrado';

  @override
  String get networkCardUpstreamTitle => 'Upstream';

  @override
  String get networkCardUpstreamSubtitle => 'Selección de resolvedor';

  @override
  String get networkCardAppsTitle => 'Apps';

  @override
  String get networkCardAppsSubtitle => 'Bloquear apps en Wi-Fi';

  @override
  String get networkCardLogsTitle => 'Registros';

  @override
  String get networkCardLogsSubtitle => 'Eventos DNS en vivo';

  @override
  String get networkCardSpeedTitle => 'Velocidad';

  @override
  String get networkCardSpeedSubtitle => 'Prueba DNS';

  @override
  String get networkCardAboutTitle => 'Acerca de';

  @override
  String get networkCardAboutSubtitle => 'GitHub';

  @override
  String get networkLogsStatusNoActivity => 'Sin actividad';

  @override
  String networkLogsStatusRecent(Object count) {
    return '$count recientes';
  }

  @override
  String get networkResolverTitle => 'Resolvedor';

  @override
  String get networkResolverIpLabel => 'IP del resolvedor';

  @override
  String get networkResolverIpHint => 'Ejemplo: 1.1.1.1';

  @override
  String get networkSpeedTestTitle => 'Prueba de velocidad';

  @override
  String get networkSpeedTestBody =>
      'Ejecuta un probador de velocidad DNS usando tu configuración actual.';

  @override
  String get networkSpeedTestRun => 'Ejecutar prueba de velocidad';

  @override
  String get networkBlocklistsRecommendedTitle => 'Recomendado';

  @override
  String get networkBlocklistsCsMalwareTitle => 'ColourSwift Malware';

  @override
  String get networkBlocklistsCsAdsTitle => 'ColourSwift ads';

  @override
  String get networkBlocklistsSeeGithub => 'Ver GitHub para más detalles...';

  @override
  String get networkBlocklistsMalwareSection => 'Malware';

  @override
  String get networkBlocklistsMalwareTitle => 'Lista de bloqueo de malware';

  @override
  String get networkBlocklistsMalwareSources =>
      'HaGeZi TIF • URLHaus • DigitalSide • Spam404';

  @override
  String get networkBlocklistsAdsSection => 'Anuncios';

  @override
  String get networkBlocklistsAdsTitle => 'Lista de bloqueo de anuncios';

  @override
  String get networkBlocklistsAdsSources =>
      'OISD • AdAway • Yoyo • AnudeepND • Firebog AdGuard';

  @override
  String get networkBlocklistsTrackersSection => 'Rastreadores';

  @override
  String get networkBlocklistsTrackersTitle =>
      'Lista de bloqueo de rastreadores';

  @override
  String get networkBlocklistsTrackersSources =>
      'EasyPrivacy • Disconnect • Frogeye • Perflyst • WindowsSpyBlocker';

  @override
  String get networkBlocklistsGamblingSection => 'Apuestas';

  @override
  String get networkBlocklistsGamblingTitle => 'Lista de bloqueo de apuestas';

  @override
  String get networkBlocklistsGamblingSources => 'HaGeZi Gambling';

  @override
  String get networkBlocklistsSocialSection => 'Redes sociales';

  @override
  String get networkBlocklistsSocialTitle =>
      'Lista de bloqueo de redes sociales';

  @override
  String get networkBlocklistsSocialSources => 'HaGeZi Social';

  @override
  String get networkBlocklistsAdultSection => '18+';

  @override
  String get networkBlocklistsAdultTitle =>
      'Lista de bloqueo de contenido adulto';

  @override
  String get networkBlocklistsAdultSources => 'StevenBlack 18+ • HaGeZi NSFW';

  @override
  String get networkLiveLogsTitle => 'Registros en vivo';

  @override
  String get networkLiveLogsEmpty => 'Aún no hay solicitudes.';

  @override
  String get networkLiveLogsBlocked => 'Bloqueado';

  @override
  String get networkLiveLogsAllowed => 'Permitido';

  @override
  String get recommendedMetaPassDesc => 'Genera contraseñas offline seguras.';

  @override
  String get recommendedCleanerProDesc =>
      'Encuentra duplicados, medios antiguos y apps sin usar para recuperar almacenamiento automáticamente.';

  @override
  String get recommendedLinkCheckerDesc =>
      'Comprueba enlaces sospechosos con el modo de vista segura, sin riesgo.';

  @override
  String get recommendedNetworkProtectionDesc =>
      'Mantén tu conexión segura frente a malware.';

  @override
  String get recommendedTerminalDesc => 'Una función avanzada para Shizuku';

  @override
  String get recommendedScheduledScansDesc =>
      'Escaneos automáticos en segundo plano.';

  @override
  String get metaPassTitle => 'MetaPass';

  @override
  String get metaPassHowItWorks => 'Cómo funciona MetaPass';

  @override
  String get metaPassOk => 'OK';

  @override
  String get metaPassSettings => 'Ajustes';

  @override
  String get metaPassPoweredBy => 'powered by VX-TITANIUM';

  @override
  String get metaPassLoading => 'Cargando…';

  @override
  String get metaPassEmptyTitle => 'Aún no hay entradas';

  @override
  String get metaPassEmptyBody =>
      'Añade una app o sitio web.\nLas contraseñas se generan en el dispositivo a partir de tu meta contraseña secreta.';

  @override
  String get metaPassAddFirstEntry => 'Añadir primera entrada';

  @override
  String get metaPassTapToCopyHint =>
      'Toca para copiar. Mantén pulsado para eliminar.';

  @override
  String get metaPassCopyTooltip => 'Copiar contraseña';

  @override
  String get metaPassAdd => 'Añadir';

  @override
  String get metaPassPickFromInstalledApps => 'Elegir de apps instaladas';

  @override
  String get metaPassAddWebsiteOrLabel =>
      'Añadir sitio web o etiqueta personalizada';

  @override
  String get metaPassSelectApp => 'Seleccionar app';

  @override
  String get metaPassSearchApps => 'Buscar apps';

  @override
  String get metaPassCancel => 'Cancelar';

  @override
  String get metaPassContinue => 'Continuar';

  @override
  String get metaPassSave => 'Guardar';

  @override
  String get metaPassAddEntryTitle => 'Añadir entrada';

  @override
  String get metaPassNameOrUrl => 'Nombre o URL';

  @override
  String get metaPassNameOrUrlHint => 'p. ej., nextcloud, steam, example.com';

  @override
  String get metaPassVersion => 'Versión';

  @override
  String get metaPassLength => 'Longitud';

  @override
  String get metaPassSetMetaTitle => 'Establecer Meta Password';

  @override
  String get metaPassSetMetaBody =>
      'Introduce tu meta contraseña. Nunca sale de este dispositivo. Todas las contraseñas del almacén dependen de ella.';

  @override
  String get metaPassMetaLabel => 'Meta contraseña';

  @override
  String get metaPassRememberThisDevice =>
      'Recordar en este dispositivo (almacenado de forma segura)';

  @override
  String get metaPassChangingMetaWarning =>
      'Cambiar esto más tarde cambia todas las contraseñas generadas. Usar la misma meta contraseña las restaura.';

  @override
  String get metaPassRemoveEntryTitle => 'Eliminar entrada';

  @override
  String metaPassRemoveEntryBody(Object label) {
    return '¿Eliminar \"$label\" de tu almacén?';
  }

  @override
  String get metaPassRemove => 'Eliminar';

  @override
  String metaPassPasswordCopied(Object label, Object version, Object length) {
    return 'Contraseña copiada para $label (v$version, $length chars)';
  }

  @override
  String metaPassGenerateFailed(Object error) {
    return 'Error al generar la contraseña: $error';
  }

  @override
  String metaPassLoadAppsFailed(Object error) {
    return 'Error al cargar apps: $error';
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
      'Las contraseñas nunca se almacenan.\n\nCada entrada deriva una contraseña de:\n• Tu meta contraseña\n• La etiqueta (nombre)\n• La versión y la longitud\n\nReinstalar la app con la misma meta contraseña y etiquetas regenera las mismas contraseñas.';

  @override
  String get passwordSettingsTitle => 'Ajustes de contraseña';

  @override
  String get passwordSettingsSectionMetaPass => 'MetaPass';

  @override
  String get passwordSettingsMetaPasswordTitle => 'Meta contraseña';

  @override
  String get passwordSettingsMetaNotSet => 'No establecida';

  @override
  String get passwordSettingsMetaStoredSecurely =>
      'Almacenada de forma segura en este dispositivo';

  @override
  String get passwordSettingsChange => 'Cambiar';

  @override
  String get passwordSettingsSetMetaPassTitle => 'Establecer MetaPass';

  @override
  String get passwordSettingsMetaPasswordLabel => 'Meta contraseña';

  @override
  String get passwordSettingsChangingAltersAll =>
      'Cambiar esto altera todas las contraseñas.\nUsar la misma MetaPass las restaura.';

  @override
  String get passwordSettingsCancel => 'Cancelar';

  @override
  String get passwordSettingsSave => 'Guardar';

  @override
  String get passwordSettingsSectionRestoreCode => 'Código de restauración';

  @override
  String get passwordSettingsGenerateRestoreCode =>
      'Generar código de restauración';

  @override
  String get passwordSettingsCopy => 'Copiar';

  @override
  String get passwordSettingsRestoreCodeCopied =>
      'Código de restauración copiado';

  @override
  String get passwordSettingsSectionRestoreFromCode => 'Restaurar desde código';

  @override
  String get passwordSettingsRestoreCodeLabel => 'Código de restauración';

  @override
  String get passwordSettingsRestore => 'Restaurar';

  @override
  String get passwordSettingsVaultRestored => 'Almacén restaurado';

  @override
  String get passwordSettingsFooterInfo =>
      'Las contraseñas nunca se almacenan.\n\nEl código de restauración solo contiene datos de estructura. Combinado con tu MetaPass, reconstruye tu almacén.';

  @override
  String get onboardingAppName => 'AVarionX Security';

  @override
  String get onboardingStorageTitle => 'Acceso al almacenamiento';

  @override
  String get onboardingStorageDesc =>
      'Este permiso es necesario para escanear archivos en tu dispositivo. Puedes concederlo ahora o más tarde.';

  @override
  String get onboardingStorageFootnote =>
      'Puedes omitirlo, pero se te pedirá de nuevo cuando elijas un modo de escaneo.';

  @override
  String get onboardingStorageSnack =>
      'Se requiere permiso de almacenamiento para escanear.';

  @override
  String get onboardingNotificationsTitle => 'Notificaciones';

  @override
  String get onboardingNotificationsDesc =>
      'Se usan para alertas en tiempo real, estado del escaneo y actualizaciones de cuarentena.';

  @override
  String get onboardingNotificationsFootnote =>
      'Requerido por Android para la protección en tiempo real.';

  @override
  String get onboardingNetworkTitle => 'Protección de red';

  @override
  String get onboardingNetworkDesc =>
      'Activa protección Wi-Fi usando el permiso de VPN de Android.';

  @override
  String get onboardingNetworkFootnote => 'Es opcional pero recomendado.';

  @override
  String get onboardingGranted => 'Concedido';

  @override
  String get onboardingNotGranted => 'No concedido';

  @override
  String get onboardingGrantAccess => 'Conceder acceso';

  @override
  String get onboardingAllowNotifications => 'Permitir notificaciones';

  @override
  String get onboardingAllowVpnAccess => 'Permitir acceso VPN';

  @override
  String get onboardingBack => 'Atrás';

  @override
  String get onboardingNext => 'Siguiente';

  @override
  String get onboardingFinish => 'Finalizar';

  @override
  String get onboardingSetupCompleteTitle => 'Configuración completa';

  @override
  String get onboardingSetupCompleteDesc =>
      'Recomendamos ejecutar un escaneo completo del dispositivo (esto no escanea apps instaladas actualmente) o ir directamente a la pantalla de inicio.';

  @override
  String get onboardingRunFullScan => 'Ejecutar escaneo completo';

  @override
  String get onboardingGoHome => 'Ir a inicio';

  @override
  String get networkProtectionTitle => 'Protección de red';

  @override
  String networkStatusConnectedToDns(Object dns) {
    return 'Conectado a $dns';
  }

  @override
  String get networkStatusVpnConflictDetail => 'Otro VPN está activo';

  @override
  String get networkStatusOffDetail => 'La protección de red está desactivada';

  @override
  String get networkModeMalwareTitle => 'Solo bloqueo de malware';

  @override
  String get networkModeMalwareSubtitle => 'Usa 1.1.1.2';

  @override
  String get networkModeMalwareDescription =>
      'Combina la base de datos local de malware de AvarionX con la inteligencia de amenazas online de Cloudflare para máxima protección contra malware.';

  @override
  String get networkModeAdultTitle => 'Malware y contenido adulto';

  @override
  String get networkModeAdultSubtitle => 'Usa 1.1.1.3';

  @override
  String get networkModeAdultDescription =>
      'Usa la base de datos offline de malware de AvarionX y añade filtrado de contenido adulto. La inteligencia de malware en la nube se desactiva en este modo.';

  @override
  String get networkInfoTitle => '¿Qué es la Protección de red?';

  @override
  String get networkInfoBody =>
      'Algunas amenazas funcionan conectándose a servidores maliciosos o redirigiendo el tráfico de internet.\nLa Protección de red bloquea dominios peligrosos conocidos y anuncios comunes usando un VPN local.\n\nAVarionX Security no recopila ningún dato.';

  @override
  String get linkCheckerTitle => 'Comprobador de enlaces';

  @override
  String get linkCheckerTabAnalyse => 'Analizar';

  @override
  String get linkCheckerTabView => 'Ver';

  @override
  String get linkCheckerTabHistory => 'Historial';

  @override
  String get linkCheckerAnalyseSubtitle =>
      'Comprueba la página en busca de malware o contenido sospechoso';

  @override
  String get linkCheckerUrlLabel => 'URL';

  @override
  String get linkCheckerUrlHint => 'https://example.com';

  @override
  String get linkCheckerButtonAnalyse => 'Analizar';

  @override
  String get linkCheckerButtonChecking => 'Comprobando';

  @override
  String get linkCheckerEngineNotReadySnack => 'Motor no listo';

  @override
  String get linkCheckerStatusVerifyingLink => 'Verificando enlace…';

  @override
  String get linkCheckerStatusScanningPage => 'Escaneando página…';

  @override
  String get linkCheckerBlockedNavigation => 'Navegación bloqueada';

  @override
  String get linkCheckerBlockedUnsupportedType =>
      'Tipo de enlace no compatible';

  @override
  String get linkCheckerBlockedInvalidDestination => 'Destino inválido';

  @override
  String get linkCheckerBlockedUnableResolve =>
      'No se pudo resolver el destino';

  @override
  String get linkCheckerBlockedUnableVerify => 'No se pudo verificar';

  @override
  String get linkCheckerAnalyseCardTitleDefault =>
      'Comprueba la página en busca de contenido sospechoso';

  @override
  String get linkCheckerAnalyseCardDetailDefault =>
      'Pega una URL y ejecuta un análisis.';

  @override
  String get linkCheckerAnalyseCardTitleEngineNotReady => 'Motor no listo';

  @override
  String get linkCheckerAnalyseCardDetailEngineNotReady => 'error 1001.';

  @override
  String get linkCheckerAnalyseCardTitleChecking => 'Comprobando';

  @override
  String get linkCheckerVerdictClean => 'Limpio';

  @override
  String get linkCheckerVerdictCleanDetail => 'Esta página parece ser segura.';

  @override
  String get linkCheckerVerdictSuspicious => 'Sospechoso';

  @override
  String get linkCheckerVerdictSuspiciousDetail =>
      'Esta página contiene contenido sospechoso.';

  @override
  String get linkCheckerViewLockedBody =>
      'Ejecuta un análisis primero para habilitar la vista.';

  @override
  String get linkCheckerViewSubtitle => 'Ver la página de forma segura';

  @override
  String get linkCheckerViewPage => 'Ver página';

  @override
  String get linkCheckerClose => 'Cerrar';

  @override
  String get linkCheckerBlockedBody =>
      'Esta página se detuvo antes de que pudiera cargar.';

  @override
  String get linkCheckerSuspiciousBanner =>
      'Enlace sospechoso, puede que no renderice si requiere contenido bloqueado.';

  @override
  String get linkCheckerHistorySubtitle =>
      'Toca una entrada para copiar el enlace.';

  @override
  String get linkCheckerHistoryEmpty => 'Aún no hay comprobaciones.';

  @override
  String get linkCheckerCopied => 'Copiado';

  @override
  String get settingsSectionAppearance => 'Apariencia';

  @override
  String get settingsTheme => 'Tema';

  @override
  String settingsThemeCurrent(Object theme) {
    return 'Actual: $theme';
  }

  @override
  String get settingsLanguage => 'Idioma';

  @override
  String settingsLanguageCurrent(Object language) {
    return 'Actual: $language';
  }

  @override
  String get settingsChooseLanguage => 'Elegir idioma';

  @override
  String get settingsLanguageApplied => 'Idioma aplicado';

  @override
  String get settingsSystemDefault => 'Predeterminado del sistema';

  @override
  String get settingsSectionCommunity => '¡Únete a la comunidad!';

  @override
  String get settingsDiscord => 'Discord';

  @override
  String get settingsDiscordSubtitle => 'Chat, actualizaciones y feedback';

  @override
  String get settingsDiscordOpenFail => 'No se pudo abrir el enlace de Discord';

  @override
  String get settingsSectionPro => 'Funciones PRO';

  @override
  String get settingsProCustomization => 'Personalización PRO';

  @override
  String get settingsProSubtitle =>
      'Quita anuncios y desbloquea temas e iconos';

  @override
  String get settingsUnlockPro => 'Desbloquear PRO';

  @override
  String get settingsProUnlocked => 'Modo PRO desbloqueado';

  @override
  String get settingsPurchaseNotConfirmed => 'Compra no confirmada';

  @override
  String settingsPurchaseFailed(Object error) {
    return 'Error de compra: $error';
  }

  @override
  String get proActivated => 'PRO activado';

  @override
  String get proDeactivated => 'PRO desactivado';

  @override
  String get settingsProReset => 'Reset PRO (solo debug)';

  @override
  String get settingsProSheetTitle => 'Personalización PRO';

  @override
  String get settingsHideGoldHeader =>
      'Ocultar cabecera dorada en la pantalla de inicio';

  @override
  String get settingsAppIcon => 'Icono de la app';

  @override
  String settingsIconSelected(Object icon) {
    return 'Icono seleccionado: $icon';
  }

  @override
  String get settingsSave => 'Guardar';

  @override
  String get settingsSectionShizuku => 'Protección avanzada (Shizuku)';

  @override
  String get settingsEnableShizuku => 'Activar Shizuku';

  @override
  String get settingsShizukuRequiresManager => 'Requiere gestor externo';

  @override
  String get settingsShizukuNotRunning =>
      'Servicio Shizuku no está en ejecución';

  @override
  String get settingsShizukuPermissionRequired => 'Permiso requerido';

  @override
  String get settingsShizukuAvailable =>
      'Acceso avanzado al sistema disponible';

  @override
  String get settingsAboutAdvancedProtection =>
      'Acerca de la protección avanzada';

  @override
  String get settingsAboutAdvancedProtectionSubtitle =>
      'Aprende cómo funciona la protección avanzada';

  @override
  String get settingsAdvancedProtectionDialogTitle =>
      'Protección avanzada del sistema';

  @override
  String get settingsAdvancedProtectionDialogBody =>
      'El acceso Shizuku requiere un gestor externo destinado a usuarios avanzados.\n\nEsta función es opcional y no se recomienda para protección casual.';

  @override
  String get settingsAboutShizukuTitle => 'Acerca de Shizuku';

  @override
  String get settingsAboutShizukuBody =>
      'AVarionX puede integrar Shizuku para acceder a procesos de apps a nivel del sistema.\n\nEsto permite a la app:\n• Detectar malware que se oculta de escáneres estándar\n• Inspeccionar procesos de apps en ejecución\n• Desactivar o contener la mayoría del malware activo\n\nShizuku, sin embargo, no concede acceso root\n\nEsta función está pensada para usuarios avanzados y no es necesaria para protección normal.\n\nDocumentación:\nhttps://shizuku.rikka.app';

  @override
  String get settingsSectionGeneral => 'General';

  @override
  String get settingsExclusions => 'Exclusiones';

  @override
  String get settingsExclusionsSubtitle => 'Gestiona y añade exclusiones';

  @override
  String get settingsExcludeFolder => 'Excluir una carpeta';

  @override
  String get settingsExcludeFile => 'Excluir un archivo';

  @override
  String get settingsManageExclusions => 'Gestionar exclusiones existentes';

  @override
  String get settingsManageExclusionsSubtitle => 'Ver o eliminar exclusiones';

  @override
  String get settingsFolderExcluded => 'Carpeta excluida';

  @override
  String get settingsFileExcluded => 'Archivo excluido';

  @override
  String get settingsPrivacyPolicy => 'Política de privacidad';

  @override
  String get settingsPrivacyPolicySubtitle => 'Ver cómo se gestionan tus datos';

  @override
  String get settingsPrivacyPolicyOpenFail =>
      'No se pudo abrir la política de privacidad';

  @override
  String get settingsAboutApp => 'Acerca de AVarionX';

  @override
  String get settingsHowThisAppWorks => 'Cómo funciona esta app';

  @override
  String get settingsHowThisAppWorksSubtitle => 'Aprende sobre la protección';

  @override
  String get settingsThemePickerTitle => 'Elegir tema';

  @override
  String get settingsThemeRequiresPro => 'Ese tema requiere modo PRO';

  @override
  String get scheduledScansTitle => 'Escaneos programados';

  @override
  String get scheduledScansInfoTitle => 'Escaneos programados';

  @override
  String get scheduledScansInfoBody =>
      'Mientras RTP se centra en malware descargado, los Escaneos programados iniciarán automáticamente el modo de escaneo elegido en segundo plano.\nSolo se ejecutará mientras RTP esté activado.\n\nLos usuarios PRO pueden personalizar el modo y la frecuencia.';

  @override
  String get scheduledScansHeader => 'Escaneos automáticos en segundo plano';

  @override
  String get scheduledScansSubheader =>
      'Mientras RTP esté activo, la app escaneará tu dispositivo según el modo y la frecuencia seleccionados.';

  @override
  String get proRequiredToCustomize => 'Se requiere PRO para personalizar';

  @override
  String get scheduledScansEnabledTitle => 'Activado';

  @override
  String get scheduledScansEnabledSubtitle =>
      'Cuando está activado, un escaneo se ejecuta automáticamente según tu programación.';

  @override
  String get scheduledScansModeTitle => 'Modo de escaneo';

  @override
  String scheduledScansModeHint(Object mode) {
    return 'Modo actual: $mode';
  }

  @override
  String get scheduledScansFrequencyTitle => 'Frecuencia';

  @override
  String scheduledScansFrequencyHint(Object freq) {
    return 'Ejecuta: $freq';
  }

  @override
  String get scheduledEveryDay => 'Cada día';

  @override
  String get scheduledEvery3Days => 'Cada 3 días';

  @override
  String get scheduledEveryWeek => 'Cada semana';

  @override
  String get scheduledEvery2Weeks => 'Cada 2 semanas';

  @override
  String get scheduledEvery3Weeks => 'Cada 3 semanas';

  @override
  String get scheduledMonthly => 'Mensual';

  @override
  String scheduledEveryDays(Object days) {
    return 'Cada $days días';
  }

  @override
  String scheduledEveryHours(Object hours) {
    return 'Cada $hours horas';
  }

  @override
  String get scheduledChargingOnlyTitle => 'Solo al cargar';

  @override
  String get scheduledChargingOnlySubtitle =>
      'Ejecuta el escaneo programado solo mientras el dispositivo esté conectado.';

  @override
  String get scheduledPreferredTimeTitle => 'Hora preferida';

  @override
  String get scheduledPreferredTimeSubtitle =>
      'AVarionX intentará iniciar alrededor de esta hora. Android puede retrasarlo para ahorrar batería.';

  @override
  String get scheduledPickTime => 'Elegir hora';

  @override
  String get cleanerTitle => 'Cleaner Pro';

  @override
  String get cleanerReadyToScan => 'Listo para escanear';

  @override
  String get cleanerScan => 'Escanear';

  @override
  String get cleanerScanning => 'Escaneando…';

  @override
  String get cleanerReady => 'Listo';

  @override
  String get cleanerStatusReady => 'Listo';

  @override
  String get cleanerStatusStarting => 'Iniciando…';

  @override
  String get cleanerStatusFilesScanned => 'Archivos escaneados';

  @override
  String get cleanerStatusFindingUnusedApps => 'Buscando apps sin usar…';

  @override
  String get cleanerStatusComplete => 'Completo';

  @override
  String get cleanerStatusScanError => 'Error de escaneo';

  @override
  String get cleanerStatusScanningApps => 'Escaneando apps…';

  @override
  String get cleanerGrantUsageAccessTitle => 'Conceder acceso de uso';

  @override
  String get cleanerGrantUsageAccessBody =>
      'Para detectar apps sin usar, este cleaner requiere permiso de Acceso de uso. Serás redirigido a los ajustes del sistema para activarlo.';

  @override
  String get cleanerCancel => 'Cancelar';

  @override
  String get cleanerContinue => 'Continuar';

  @override
  String get cleanerDuplicates => 'Duplicados';

  @override
  String get cleanerDuplicatesNone => 'No se encontraron duplicados';

  @override
  String cleanerDuplicatesSubtitle(Object count, Object size) {
    return '$count elementos • recuperar $size';
  }

  @override
  String get cleanerOldPhotos => 'Fotos antiguas';

  @override
  String cleanerOldPhotosNone(Object days) {
    return 'No hay fotos de más de $days días';
  }

  @override
  String cleanerOldPhotosSubtitle(Object count, Object size) {
    return '$count elementos • $size';
  }

  @override
  String get cleanerOldVideos => 'Vídeos antiguos';

  @override
  String cleanerOldVideosNone(Object days) {
    return 'No hay vídeos de más de $days días';
  }

  @override
  String cleanerOldVideosSubtitle(Object count, Object size) {
    return '$count elementos • $size';
  }

  @override
  String get cleanerLargeFiles => 'Archivos grandes';

  @override
  String cleanerLargeFilesNone(Object size) {
    return 'No hay archivos ≥ $size';
  }

  @override
  String cleanerLargeFilesSubtitle(Object count, Object sizeTotal) {
    return '$count elementos • $sizeTotal';
  }

  @override
  String get cleanerUnusedApps => 'Apps sin usar';

  @override
  String cleanerUnusedAppsNone(Object days) {
    return 'No hay apps sin usar (últimos $days días)';
  }

  @override
  String cleanerUnusedAppsCount(Object count) {
    return '$count apps';
  }

  @override
  String get cleanerStageDuplicates => 'Escaneando duplicados…';

  @override
  String get cleanerStageDuplicatesGrouping => 'Agrupando duplicados…';

  @override
  String get cleanerStageOldPhotos => 'Escaneando fotos antiguas…';

  @override
  String get cleanerStageOldVideos => 'Escaneando vídeos antiguos…';

  @override
  String get cleanerStageLargeFiles => 'Escaneando archivos grandes…';

  @override
  String cleanerStageOldPhotosProgress(Object count, Object size) {
    return 'Fotos antiguas: $count • $size';
  }

  @override
  String cleanerStageOldVideosProgress(Object count, Object size) {
    return 'Vídeos antiguos: $count • $size';
  }

  @override
  String cleanerStageLargeFilesProgress(Object count, Object size) {
    return 'Archivos grandes: $count • $size';
  }

  @override
  String get unusedAppsTitle => 'Apps sin usar';

  @override
  String unusedAppsEmpty(Object days) {
    return 'No hay apps sin usar en los últimos $days días';
  }

  @override
  String get quarantineTitle => 'Eliminados';

  @override
  String get quarantineSelectAll => 'Seleccionar todo';

  @override
  String get quarantineRefresh => 'Actualizar';

  @override
  String get quarantineEmptyTitle => 'No hay archivos eliminados';

  @override
  String get quarantineEmptyBody => 'Todo lo que elimines aparecerá aquí.';

  @override
  String get quarantineRestore => 'Restaurar';

  @override
  String get quarantineDelete => 'Eliminar';

  @override
  String get quarantineSnackRestored => 'Restaurado';

  @override
  String get quarantineSnackDeleted => 'Eliminado';

  @override
  String get quarantineDeleteDialogTitle => '¿Eliminar archivos seleccionados?';

  @override
  String quarantineDeleteDialogBody(Object count, Object plural) {
    return 'Esto eliminará permanentemente $count elemento$plural.';
  }
}
