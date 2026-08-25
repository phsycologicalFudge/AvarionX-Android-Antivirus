// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appName => 'AvarionX';

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
  String get proBadge => 'Premium';

  @override
  String get updateDbTitle => 'Actualizando base de datos';

  @override
  String updateDbVersionLabel(Object version) {
    return 'Versión $version';
  }

  @override
  String get companionAppsSectionTitle => 'Más de AvarionX';

  @override
  String get cleanerReclaimableLabel => 'Se puede liberar';

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
  String get engineReadyBanner => 'VX-TITANIUM-v9';

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
  String get onboardingAppName => 'AVarionx Security';

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
      'Activa protección Wi Fi usando el permiso de VPN de Android.';

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
  String get linkCheckerBlockedUnableVerify =>
      'No se pudo verificar el destino';

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
      'Enlace sospechoso, puede que no se renderice si requiere contenido bloqueado.';

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
      'Quita anuncios y desbloquea DNS ilimitado, temas e iconos';

  @override
  String get settingsUnlockPro => 'Desbloquear Premium';

  @override
  String get settingsProUnlocked => 'Modo PRO desbloqueado';

  @override
  String get settingsPurchaseNotConfirmed => 'Compra no confirmada';

  @override
  String settingsPurchaseFailed(Object error) {
    return 'Error de compra: $error';
  }

  @override
  String get homeUpgrade => 'Mejorar';

  @override
  String get homeFeatureSecureVpnTitle => 'AvarionX VPN';

  @override
  String get homeFeatureSecureVpnDesc =>
      'Oculta tu IP y bloquea contenido no deseado';

  @override
  String get proActivated => 'PRO activado';

  @override
  String get proDeactivated => 'PRO desactivado';

  @override
  String get settingsProReset => 'Restablecer PRO (solo depuración)';

  @override
  String get settingsProSheetTitle => 'Personalización PRO';

  @override
  String get settingsHideGoldHeader =>
      'Mostrar cabecera dorada en la pantalla de inicio (temas oscuros)';

  @override
  String get settingsAppIcon => 'Icono de la app';

  @override
  String settingsIconSelected(Object icon) {
    return 'Icono seleccionado: $icon';
  }

  @override
  String get vpnSignInRequiredTitle => 'Inicio de sesión requerido';

  @override
  String get vpnClose => 'Cerrar';

  @override
  String get vpnSignInRequiredBody => 'Inicia sesión para usar Secure VPN.';

  @override
  String get vpnCancel => 'Cancelar';

  @override
  String get vpnSignIn => 'Iniciar sesión';

  @override
  String get vpnUsageLoading => 'Cargando uso...';

  @override
  String get vpnUsageNoLimits => 'Sin límites de datos';

  @override
  String get vpnUsageSyncing => 'Sincronizando';

  @override
  String vpnUsageUsedThisMonth(Object used) {
    return '$used usados este mes';
  }

  @override
  String get vpnUsageDataTitle => 'Uso de datos';

  @override
  String get vpnUsageUnavailable => 'Uso no disponible';

  @override
  String get vpnStatusConnectingEllipsis => 'Conectando...';

  @override
  String vpnStatusConnectedTo(Object country) {
    return 'Conectado a $country';
  }

  @override
  String get vpnTitleSecure => 'Secure VPN';

  @override
  String get vpnStatusConnected => 'Conectado';

  @override
  String get vpnSubtitleEstablishingTunnel => 'Estableciendo túnel...';

  @override
  String get vpnSubtitleFindingLocation => 'Buscando ubicación...';

  @override
  String get vpnStatusProtected => 'Protegido';

  @override
  String get vpnStatusNotConnected => 'No conectado';

  @override
  String get vpnConnect => 'Conectar';

  @override
  String get vpnDisconnect => 'Desconectar';

  @override
  String vpnIpLabel(Object ip) {
    return 'IP: $ip';
  }

  @override
  String vpnServerLoadLabel(Object current, Object max) {
    return '$current/$max';
  }

  @override
  String get vpnBlocklistsTitle => 'Listas de bloqueo de Secure VPN';

  @override
  String get vpnSave => 'Guardar';

  @override
  String get settingsSave => 'Guardar';

  @override
  String get settingsPremium => 'Premium';

  @override
  String get settingsUltimateSecurity => 'Seguridad definitiva';

  @override
  String get settingsSwitchPlan => 'Cambiar plan';

  @override
  String get settingsBestValue => 'Mejor valor';

  @override
  String get settingsOneTime => 'Pago único';

  @override
  String get settingsPlanPriceLoading => 'Cargando precio...';

  @override
  String get settingsMonthly => 'Mensual';

  @override
  String get settingsYearly => 'Anual';

  @override
  String get settingsLifetime => 'De por vida';

  @override
  String get settingsSubscribeMonthly => 'Suscribirse mensual';

  @override
  String get settingsSubscribeYearly => 'Suscribirse anual';

  @override
  String get settingsUnlockLifetime => 'Desbloquear de por vida';

  @override
  String get settingsProBenefitsTitle => 'Beneficios';

  @override
  String get settingsUnlimitedDnsTitle => 'Consultas DNS ilimitadas';

  @override
  String get settingsUnlimitedDnsBody =>
      'Elimina los límites de consultas y desbloquea el filtrado completo en la nube.';

  @override
  String get settingsThemesTitle => 'Temas';

  @override
  String get settingsThemesBody =>
      'Desbloquea temas premium y personalización.';

  @override
  String get settingsIconCustomizationTitle => 'Personalización del icono';

  @override
  String get settingsIconCustomizationBody =>
      'Cambia el icono de la app para que combine con tu estilo.';

  @override
  String get settingsScheduledScansTitle => 'Escaneos programados';

  @override
  String get settingsScheduledScansBody =>
      'Desbloquea programación avanzada y personalización del escaneo.';

  @override
  String get settingsProFinePrint =>
      'Las suscripciones se renuevan salvo cancelación. Puedes gestionarlas o cancelarlas en cualquier momento en Google Play. La opción de por vida es un pago único.';

  @override
  String get settingsSectionShizuku => 'Protección avanzada (Shizuku)';

  @override
  String get settingsEnableShizuku => 'Activar Shizuku';

  @override
  String get settingsShizukuRequiresManager => 'Requiere gestor externo';

  @override
  String get settingsShizukuNotRunning =>
      'El servicio Shizuku no está en ejecución';

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
  String get vpnSettingsPrivacySecurityTitle => 'Privacidad y seguridad';

  @override
  String get vpnSettingsNoLogsPolicyTitle =>
      'Política de no almacenamiento de registros';

  @override
  String get vpnSettingsNoLogsPolicyBody =>
      'No se almacenan registros. La actividad de conexión, la actividad de navegación, las consultas DNS y el contenido del tráfico no se registran ni se conservan.';

  @override
  String get vpnSettingsNoActivityLogsTitle => 'Sin registros de actividad';

  @override
  String get vpnSettingsNoActivityLogsBody =>
      'Tu actividad no se supervisa ni se rastrea mientras usas Secure VPN.';

  @override
  String get vpnSettingsWireGuardTitle => 'VX-Link con tecnología WireGuard';

  @override
  String get vpnSettingsWireGuardBody =>
      'Secure VPN usa el protocolo WireGuard a través de VX-Link para ofrecer cifrado rápido y moderno.';

  @override
  String get vpnSettingsMalwareProtectionTitle =>
      'Protección contra malware activada';

  @override
  String get vpnSettingsMalwareProtectionBody =>
      'Los dominios maliciosos se bloquean por defecto mientras estás conectado.';

  @override
  String get vpnSettingsAdTrackerProtectionTitle =>
      'Protección opcional contra anuncios y rastreadores';

  @override
  String get vpnSettingsAdTrackerProtectionBody =>
      'Activa el bloqueo adicional de anuncios y rastreadores en la pestaña de Personalización.';

  @override
  String get vpnSettingsBrandFooter => 'Protegido por VX-Link';

  @override
  String get vpnSettingsAccountTitle => 'Cuenta';

  @override
  String get vpnSettingsSignInToContinue => 'Inicia sesión para continuar';

  @override
  String get vpnSettingsAccountSyncBody =>
      'Tu plan y uso de datos se sincronizan con tu cuenta.';

  @override
  String get vpnSettingsSignedIn => 'Sesión iniciada';

  @override
  String get vpnSettingsPlanUnknown => 'Plan: desconocido';

  @override
  String vpnSettingsPlanLabel(Object plan) {
    return 'Plan: $plan';
  }

  @override
  String get vpnSettingsRefresh => 'Actualizar';

  @override
  String get vpnSettingsSignOut => 'Cerrar sesión';

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
  String get vpnAccountScreenTitle => 'Cuenta';

  @override
  String get vpnAccountSignInRequiredTitle => 'Inicio de sesión requerido';

  @override
  String get vpnAccountSignInManageUsageBody =>
      'Inicia sesión para gestionar tu cuenta y uso.';

  @override
  String get vpnAccountNotSignedIn => 'Sesión no iniciada';

  @override
  String get vpnAccountFree => 'Gratis';

  @override
  String get vpnAccountUnknown => 'Desconocido';

  @override
  String get vpnAccountStatusSyncing => 'Sincronizando';

  @override
  String get vpnAccountStatusActive => 'Activo';

  @override
  String get vpnAccountStatusConnected => 'Conectado';

  @override
  String get vpnAccountStatusDisconnected => 'Desconectado';

  @override
  String get vpnAccountStatusUnavailable => 'No disponible';

  @override
  String get vpnAccountStatusConnectedNow => 'Conectado ahora';

  @override
  String get vpnAccountStatusRefreshToLoadServer =>
      'Actualiza para cargar el estado del servidor';

  @override
  String get vpnAccountUsageTitle => 'Uso';

  @override
  String get vpnAccountUsageLoading => 'Cargando uso...';

  @override
  String get vpnAccountUsageSignInToSync =>
      'Inicia sesión para sincronizar el uso';

  @override
  String get vpnAccountUsagePullToRefresh =>
      'Desliza para actualizar y sincronizar el uso';

  @override
  String get vpnAccountUsageUnlimited => 'Ilimitado';

  @override
  String vpnAccountUsageUsedThisMonth(Object used) {
    return '$used usados este mes';
  }

  @override
  String vpnAccountUsageUsedThisMonthUnlimited(Object used) {
    return '$used usados este mes, ilimitado';
  }

  @override
  String vpnAccountUsageUsedOfLimit(Object used, Object limit) {
    return '$used / $limit';
  }

  @override
  String get settingsSectionAccount => 'Cuenta';

  @override
  String get settingsAccountTitle => 'Cuenta';

  @override
  String get settingsAccountSubtitle =>
      'Inicio de sesión, plan, suscripción y uso de la cuenta';

  @override
  String get exploreSecureVpnTitle => 'Secure VPN';

  @override
  String get exploreSecureVpnSubtitle =>
      'Oculta tu IP y bloquea contenido no deseado';

  @override
  String get vpnAccountServerLoadTitle => 'Carga del servidor seleccionado';

  @override
  String vpnAccountServerConnectedCount(Object connected, Object cap) {
    return '$connected/$cap';
  }

  @override
  String get networkDnsOffTitle => '¿Cambiar a filtrado DNS?';

  @override
  String get networkDnsOffInfoTitle => '¿Qué es el filtrado DNS?';

  @override
  String get networkDnsOffInfoBody1 =>
      'El filtrado DNS es independiente de Secure VPN. Puede bloquear malware conocido, anuncios en apps, rastreadores y categorías no deseadas antes de que carguen.';

  @override
  String get networkDnsOffInfoBody2 => 'No cifra tu tráfico ni oculta tu IP.';

  @override
  String get networkDnsOffEnableButton => 'Activar filtrado DNS';

  @override
  String vpnAccountServerConnectedCountWithLabel(Object connected, Object cap) {
    return '$connected/$cap conectados';
  }

  @override
  String get vpnAccountIdentityFallbackTitle => 'Cuenta';

  @override
  String get vpnAccountMembershipLabel => 'Membresía';

  @override
  String get vpnAccountMembershipFounderVpnPro => 'Fundadores · VPN Pro';

  @override
  String get vpnAccountMembershipFounder => 'Fundador';

  @override
  String get vpnAccountMembershipPro => 'Pro';

  @override
  String get vpnAccountSectionAccountStatus => 'Estado de la cuenta';

  @override
  String get vpnAccountSectionActions => 'Acciones';

  @override
  String get vpnAccountKvStatus => 'Estado';

  @override
  String get vpnAccountKvPlan => 'Plan';

  @override
  String get vpnAccountKvUsage => 'Uso';

  @override
  String get vpnAccountKvSelectedServer => 'Servidor seleccionado';

  @override
  String get vpnAccountKvConnectionState => 'Estado de conexión';

  @override
  String get vpnAccountActionRefresh => 'Actualizar';

  @override
  String get vpnAccountActionOpen => 'Abrir';

  @override
  String get vpnAccountFounderThanks => 'Gracias por apoyar a ColourSwift';

  @override
  String get vpnAccountFounderNote =>
      'Soy solo una persona, apoyada por la mejor comunidad.';

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
  String quarantineDeleteDialogBody(Object count, String plural) {
    String _temp0 = intl.Intl.selectLogic(
      plural,
      {
        's': '',
        'other': '',
      },
    );
    return 'Elementos que se eliminarán permanentemente: $count.$_temp0';
  }

  @override
  String get howThisAppWorksHowAvarionXWorks => 'Cómo funciona AvarionX';

  @override
  String get howThisAppWorksAvarionxIsAMobileSecurityAppThat =>
      'AvarionX es una aplicación de seguridad móvil que combina análisis antivirus en el dispositivo, protección de red y funciones VPN opcionales. ';

  @override
  String get howThisAppWorksTheAntivirusEngineIsPoweredByVX =>
      'El motor antivirus funciona con VX-Titanium.';

  @override
  String get howThisAppWorksIfYouUseNetworkProtectionOrVPN =>
      'Si utilizas la protección de red o las funciones VPN, la aplicación se conecta a los servicios de ColourSwift para aplicar tus ajustes, gestionar el acceso a tu cuenta y enrutar el tráfico protegido.';

  @override
  String get howThisAppWorksKeyFeatures => 'Funciones principales';

  @override
  String get howThisAppWorksRealTimeProtectionForDownloadedThreats =>
      '• Protección en tiempo real frente a amenazas descargadas';

  @override
  String get howThisAppWorksNetworkProtectionWithDNSFiltering =>
      '• Protección de red con filtrado DNS';

  @override
  String get howThisAppWorksOptionalSecureVPNMode =>
      '• Modo Secure VPN opcional';

  @override
  String get howThisAppWorksBuiltInToolsSuchAsLinkChecker =>
      '• Herramientas integradas como Link Checker';

  @override
  String get howThisAppWorksNotes => 'Notas';

  @override
  String get howThisAppWorksSomeFeaturesMayRequireSignInAn =>
      'Es posible que algunas funciones requieran iniciar sesión, un plan activo o permisos del dispositivo para funcionar correctamente.';

  @override
  String get apkAnalyserCopyCurrentReport => 'Copiar informe actual';

  @override
  String get apkAnalyserReportCopiedToClipboard =>
      'Informe copiado al portapapeles';

  @override
  String get apkAnalyserExportCurrentAsPDF => 'Exportar actual como PDF';

  @override
  String get apkAnalyserFailedToExportPDF => 'No se pudo exportar el PDF';

  @override
  String get apkAnalyserExportCurrentAsCSV => 'Exportar actual como CSV';

  @override
  String get apkAnalyserFailedToExportCSV => 'No se pudo exportar el CSV';

  @override
  String get apkAnalyserViewSavedReports => 'Ver informes guardados';

  @override
  String get apkAnalyserClearHistory => 'Borrar historial';

  @override
  String get apkAnalyserReportHistoryCleared => 'Historial de informes borrado';

  @override
  String get apkAnalyserSavedReports => 'Informes guardados';

  @override
  String get apkAnalyserNoSavedReportsFound =>
      'No se encontraron informes guardados.';

  @override
  String get apkAnalyserChooseTarget => 'Elegir objetivo';

  @override
  String get apkAnalyserSelectASourceToAnalyseWithVTTI =>
      'Selecciona una fuente para analizarla con VTTI Cloud.';

  @override
  String get apkAnalyserApkFile => 'Archivo APK';

  @override
  String get apkAnalyserPickAnApkFromStorage =>
      'Elige un archivo .apk del almacenamiento';

  @override
  String get apkAnalyserInstalledApp => 'Aplicación instalada';

  @override
  String get apkAnalyserChooseFromAppsOnThisDevice =>
      'Elige entre las aplicaciones de este dispositivo';

  @override
  String apkAnalyserAnalysingIn(Object countdown) {
    return 'Analizando en $countdown...';
  }

  @override
  String get apkAnalyserStartingAnalysis => 'Iniciando análisis...';

  @override
  String get apkAnalyserApkFileOrInstalledApp =>
      'Archivo APK o aplicación instalada';

  @override
  String get apkAnalyserDeepAnalysisMode => 'Modo de análisis profundo';

  @override
  String get apkAnalyserAMoreComplexAnalysisUsingGlobalData =>
      'Un análisis más complejo que utiliza fuentes de datos globales';

  @override
  String get apkAnalyserRequiresProToUnlockDeeperAnalysis =>
      'Requiere Pro para desbloquear un análisis más profundo';

  @override
  String get apkAnalyserApkAnalyser => 'Analizador de APK';

  @override
  String get apkAnalyserPleaseSignInViaSettingsToEnable =>
      'Inicia sesión desde Ajustes para activar Cloud Analysis.';

  @override
  String get apkAnalyserAdvancedOPTIONS => 'OPCIONES AVANZADAS';

  @override
  String apkAnalyserDailyLimit(Object remaining, Object limit) {
    return 'Límite diario: $remaining / $limit';
  }

  @override
  String get apkAnalyserDailyLimitDataUnavailable =>
      'Datos del límite diario no disponibles';

  @override
  String get apkAnalyserPoweredByVTTICloud => 'Con tecnología de VTTI Cloud';

  @override
  String get apkAnalyserSearchApps => 'Buscar aplicaciones...';

  @override
  String get apkAnalyserFailedToLoadApps =>
      'No se pudieron cargar las aplicaciones.';

  @override
  String get apkAnalyserNoAppsFound => 'No se encontraron aplicaciones.';

  @override
  String get apkReportSummary => 'Resumen';

  @override
  String get apkReportPermissions => 'Permisos';

  @override
  String get apkReportExtraFlags => 'Indicadores adicionales';

  @override
  String get apkReportRiskSignals => 'Señales de riesgo';

  @override
  String get apkReportSources => 'Fuentes';

  @override
  String get apkReportMetadata => 'Metadatos';

  @override
  String get apkReportCopyReport => 'Copiar informe';

  @override
  String get apkReportReportCopiedToClipboard =>
      'Informe copiado al portapapeles';

  @override
  String get apkReportExportAsPDF => 'Exportar como PDF';

  @override
  String get apkReportFailedToExportPDF => 'No se pudo exportar el PDF';

  @override
  String get apkReportExportAsCSV => 'Exportar como CSV';

  @override
  String get apkReportFailedToExportCSV => 'No se pudo exportar el CSV';

  @override
  String get apkReportAnalysisReport => 'Informe de análisis';

  @override
  String get apkReportMalwareRisk => 'Riesgo de malware';

  @override
  String get apkReportNoSummaryGenerated => 'No se generó ningún resumen.';

  @override
  String get apkReportNoRequestedPermissionsExtracted =>
      'No se extrajeron permisos solicitados.';

  @override
  String get apkReportContributing => 'Contribuyentes';

  @override
  String get apkReportDampening => 'Atenuantes';

  @override
  String get bootOptimisingYourProtection => 'Optimizando tu protección';

  @override
  String get exclusionsFolders => 'Carpetas';

  @override
  String get exclusionsNone => 'Ninguno';

  @override
  String get exclusionsFiles => 'Archivos';

  @override
  String get exploreApkAnalyser => 'Analizador de APK';

  @override
  String get exploreCreateADetailedAnalysisOnAnyAPK =>
      'Crea un análisis detallado de cualquier APK';

  @override
  String get featuresComingSoon => 'Próximamente';

  @override
  String get featuresWantToLearnMore => '¿Quieres saber más?';

  @override
  String get homeDrawerApkAnalyser => 'Analizador de APK';

  @override
  String get homeDrawerAdvanced => 'Avanzado';

  @override
  String get homeDrawerQuarantine => 'Cuarentena';

  @override
  String get homeDrawerUpgradeToPro => 'Mejorar a Pro';

  @override
  String get homeDrawerAvarionxVPN => 'AvarionX VPN';

  @override
  String get homeDrawerProtectYourInternetWithOurUnlimitedVPN =>
      'Protege tu conexión a Internet con nuestra VPN ilimitada';

  @override
  String get deviceSecurityDeviceSecurity => 'Seguridad del dispositivo';

  @override
  String get deviceSecurityDeviceHealthStatus =>
      'Estado de seguridad del dispositivo';

  @override
  String get deviceSecurityDeviceSecurityRecommendations =>
      'Recomendaciones de seguridad del dispositivo';

  @override
  String get deviceSecurityStopIgnoring => 'Dejar de ignorar';

  @override
  String get deviceSecurityIgnoreCheck => 'Ignorar comprobación';

  @override
  String get deviceSecurityNoScreenLock => 'Sin bloqueo de pantalla';

  @override
  String get deviceSecurityAMissingSecureLockMakesLocalAccess =>
      'No tener un bloqueo seguro facilita el acceso físico al dispositivo.';

  @override
  String get deviceSecurityRootShizukuActive => 'Root/Shizuku activo';

  @override
  String get deviceSecurityRootOrShizukuCanGrantPowerfulDevice =>
      'Root o Shizuku pueden proporcionar un control avanzado del dispositivo.';

  @override
  String get deviceSecurityDisabledAppVerification =>
      'Verificación de aplicaciones desactivada';

  @override
  String get deviceSecurityAppVerificationHelpsDetectHarmfulInstalls =>
      'La verificación de aplicaciones ayuda a detectar instalaciones dañinas.';

  @override
  String get deviceSecurityOldAndroidSecurityPatch =>
      'Parche de seguridad de Android antiguo';

  @override
  String get deviceSecurityOlderPatchLevelsMayLeaveKnownIssues =>
      'Los niveles de parche antiguos pueden dejar sin corregir problemas conocidos.';

  @override
  String get deviceSecurityDeveloperModeOn => 'Modo desarrollador activado';

  @override
  String get deviceSecurityDeveloperOptionsExposeAdvancedDeviceControls =>
      'Las opciones de desarrollador permiten acceder a controles avanzados del dispositivo.';

  @override
  String get deviceSecurityUsbDebuggingOn => 'Depuración USB activada';

  @override
  String get deviceSecurityUsbDebuggingAllowsADBControlFromTrusted =>
      'La depuración USB permite el control mediante ADB desde ordenadores de confianza.';

  @override
  String get deviceSecurityUnknownSourcesAllowed =>
      'Fuentes desconocidas permitidas';

  @override
  String get deviceSecuritySideloadingCanBypassNormalAppStoreChecks =>
      'La instalación lateral puede eludir las comprobaciones habituales de la tienda de aplicaciones.';

  @override
  String get deviceSecurityAccessibilityAbuseRisk =>
      'Riesgo de abuso de accesibilidad';

  @override
  String get deviceSecurityAccessibilityServicesCanReadAndControlScreen =>
      'Los servicios de accesibilidad pueden leer y controlar las acciones de la pantalla.';

  @override
  String get homeHelpImproveDetectionsForEverybody =>
      'Ayuda a mejorar la detección para todos';

  @override
  String get homeApkSAndroidAppsFoundToBe =>
      'Los APK (aplicaciones Android) detectados como maliciosos ';

  @override
  String get homeCanBeUploadedTo => 'se pueden subir a ';

  @override
  String get homeAndSharedWithTheCommunityThisIs =>
      ' y compartir con la comunidad. Esto se limita ';

  @override
  String get homeStrictlyLimitedToAPKFilesNOTYour =>
      'estrictamente a archivos APK, NO a tus ';

  @override
  String get homeDocuments => 'documentos personales.\n\n';

  @override
  String get homeThisWillImproveDetectionsForEveryoneThat =>
      'Esto mejorará la detección para todos los que ';

  @override
  String get homeUsesAvarionXNoPressureThough =>
      'usen AvarionX. ¡Sin compromiso!\n\n';

  @override
  String get homeThanks => 'Gracias,\n';

  @override
  String get homeRyanfromcolourswift => 'RyanFromColourswift';

  @override
  String get homeSure => '¡Claro!';

  @override
  String get homeNoThanks => '¡No, gracias!';

  @override
  String get homePsstCustomiseItHere => 'Psst... personalízalo aquí';

  @override
  String get homeScanNow => 'Analizar ahora';

  @override
  String get homeManuallyCheckYourDeviceForMalware =>
      'Comprueba manualmente tu dispositivo en busca de malware';

  @override
  String get homeDeviceSecurity => 'Seguridad del dispositivo';

  @override
  String get homeScanModes => 'Modos de análisis';

  @override
  String get homeCloudAssistedChecksEnabled =>
      'Comprobaciones asistidas por la nube activadas';

  @override
  String get homeLocalScanEngineOnly => 'Solo motor de análisis local';

  @override
  String get homeProtectedByVXTITANIUM => 'Protegido por VX-TITANIUM';

  @override
  String get homeSecurityOverview => 'Resumen de seguridad';

  @override
  String get homeFilesChecked => 'Archivos comprobados';

  @override
  String get homeThreats => 'Amenazas';

  @override
  String get securityReportAvarionxSecurityReport =>
      'Informe de seguridad de Avarionx';

  @override
  String get securityReportSecurityReport => 'Informe de seguridad';

  @override
  String get securityReportManualScans => 'Análisis manuales';

  @override
  String get securityReportRealtimeChecks => 'Comprobaciones en tiempo real';

  @override
  String get securityReportTotalFilesScanned => 'Total de archivos analizados';

  @override
  String get securityReportThreatsFound => 'Amenazas encontradas';

  @override
  String get securityReportGenerateReport => 'Generar informe';

  @override
  String get securityReportLiveReport => 'Informe en directo';

  @override
  String get securityReportThisBoxUpdatesAsScanServicesWrite =>
      'Este cuadro se actualiza a medida que los servicios de análisis escriben datos del informe.';

  @override
  String get securityReportExportPDF => 'Exportar PDF';

  @override
  String get securityReportExportCSV => 'Exportar CSV';

  @override
  String get homeLegacyProActivated => 'Pro activado';

  @override
  String get homeLegacyProDeactivated => 'Pro desactivado';

  @override
  String get linkCheckPoweredByVTTICloud => 'Con tecnología de VTTI Cloud';

  @override
  String get safeViewSafeView => 'Safe View';

  @override
  String get passwordSettingsChangingThisAltersAllPasswords =>
      'Cambiar esto modifica todas las contraseñas.\n';

  @override
  String get passwordSettingsUsingTheSameMetaPassRestoresThem =>
      'Usar el mismo MetaPass las restaura.';

  @override
  String get passwordSettingsPasswordsAreNeverStored =>
      'Las contraseñas nunca se almacenan.\n\n';

  @override
  String get passwordSettingsTheRestoreCodeContainsOnlyStructureData =>
      'El código de restauración solo contiene datos de estructura. ';

  @override
  String get passwordSettingsCombinedWithYourMetaPassItRebuildsYour =>
      'Combinado con tu MetaPass, reconstruye tu bóveda.';

  @override
  String get passwordManagerContinue => 'Continuar';

  @override
  String passwordManagerFailedToLoadApps(Object e) {
    return 'No se pudieron cargar las aplicaciones: $e';
  }

  @override
  String passwordManagerFailedToGeneratePassword(Object e) {
    return 'No se pudo generar la contraseña: $e';
  }

  @override
  String get passwordManagerPasswordsAreNeverStored =>
      'Las contraseñas nunca se almacenan.\n\n';

  @override
  String get passwordManagerEachEntryDerivesAPasswordFrom =>
      'Cada entrada deriva una contraseña a partir de:\n';

  @override
  String get passwordManagerYourMetaPassword => '• Tu contraseña maestra\n';

  @override
  String get passwordManagerTheLabelName => '• El nombre de la etiqueta\n';

  @override
  String get passwordManagerTheVersionAndLength =>
      '• La versión y la longitud\n\n';

  @override
  String get passwordManagerReinstallingTheAppWithTheSameMeta =>
      'Si reinstalas la aplicación con la misma contraseña maestra y las mismas etiquetas, se vuelven a generar las mismas contraseñas.';

  @override
  String get permissionsIntroSetupIsNowCompleteTimeToSecure =>
      '¡La configuración ya está completa! Es hora de proteger tus datos.';

  @override
  String get proScreenThankYou => 'Gracias';

  @override
  String get proScreenYourSubscriptionIsConfirmed =>
      'Tu suscripción está confirmada.';

  @override
  String get proScreenCurrent => 'Actual';

  @override
  String get proScreenAdvancedStealthMode => 'Modo Stealth+ avanzado';

  @override
  String get proScreenUnlockStealthTransportModesForRestrictiveNetworks =>
      'Desbloquea modos de transporte ocultos para redes restrictivas.';

  @override
  String get proScreenGlobalServerAccess => 'Acceso global a servidores';

  @override
  String get proScreenAccessEveryVPNServerLocationIncludingPremium =>
      'Accede a todas las ubicaciones de servidores VPN, incluidas las regiones premium de alta velocidad.';

  @override
  String get proScreenBilledMonthly => 'Facturación mensual';

  @override
  String proScreenMo(Object monthlyInfo) {
    return '$monthlyInfo/mes';
  }

  @override
  String proScreenMo2(Object currencyCode) {
    return '$currencyCode/mes';
  }

  @override
  String get proScreenCurrentPlan => 'Plan actual';

  @override
  String get quarantineScreenQuarantineDataCorruptedResetting =>
      'Datos de cuarentena dañados. Restableciendo.';

  @override
  String get quarantineScreenUninstallApp => 'Desinstalar aplicación';

  @override
  String quarantineScreenUninstall(Object appName) {
    return '¿Desinstalar $appName?';
  }

  @override
  String get quarantineScreenUninstall2 => 'Desinstalar';

  @override
  String get quarantineScreenFailedToLaunchUninstall =>
      'No se pudo iniciar la desinstalación';

  @override
  String get quarantineScreenFiles => 'Archivos';

  @override
  String get cleanerAppManagerShizukuNotAvailable => 'Shizuku no disponible';

  @override
  String get cleanerAppManagerWithoutShizukuEachAppRequiresASeparate =>
      'Sin Shizuku, cada aplicación requiere una confirmación del sistema por separado. ¿Continuar?';

  @override
  String cleanerAppManagerAppsUninstalled(Object successCount) {
    return '$successCount aplicaciones desinstaladas';
  }

  @override
  String cleanerAppManagerUninstalledFailed(
      Object successCount, Object failedCount) {
    return '$successCount desinstaladas, $failedCount con error';
  }

  @override
  String cleanerAppManagerStopped(Object appName) {
    return '$appName detenida';
  }

  @override
  String get cleanerAppManagerForceStopFailed =>
      'No se pudo forzar la detención';

  @override
  String get cleanerAppManagerClearAppData => 'Borrar datos de la aplicación';

  @override
  String cleanerAppManagerResetThisClearsItsAccountsSettingsFiles(
      Object appName) {
    return '¿Restablecer $appName? Esto borrará sus cuentas, ajustes, archivos y caché.';
  }

  @override
  String get cleanerAppManagerClearData => 'Borrar datos';

  @override
  String cleanerAppManagerReset(Object appName) {
    return '$appName restablecida';
  }

  @override
  String get cleanerAppManagerClearDataFailed =>
      'No se pudieron borrar los datos';

  @override
  String get cleanerAppManagerOpenApp => 'Abrir aplicación';

  @override
  String get cleanerAppManagerForceStop => 'Forzar detención';

  @override
  String get cleanerAppManagerUninstall => 'Desinstalar';

  @override
  String cleanerAppManagerSelected(Object selectedCount) {
    return '$selectedCount seleccionados';
  }

  @override
  String get cleanerAppManagerAppManager => 'Gestor de aplicaciones';

  @override
  String get cleanerAppManagerDeselectAll => 'Deseleccionar todo';

  @override
  String cleanerAppManagerUninstalling(Object done, Object total) {
    return 'Desinstalando $done / $total…';
  }

  @override
  String cleanerAppManagerUninstall2(Object selectedCount) {
    return 'Desinstalar $selectedCount';
  }

  @override
  String get cleanerProClearAppCaches => 'Borrar cachés de aplicaciones';

  @override
  String get cleanerProThisAsksAndroidToTrimAppCaches =>
      'Esto pide a Android que reduzca las cachés de las aplicaciones en todo el dispositivo. No se borran los datos, las cuentas ni los ajustes de las aplicaciones.';

  @override
  String get cleanerProClearCaches => 'Borrar cachés';

  @override
  String get cleanerProCacheTrimRequested => 'Limpieza de caché solicitada';

  @override
  String get cleanerProCacheCleanerFailed => 'Falló la limpieza de caché';

  @override
  String get cleanerProLogFiles => 'Archivos de registro';

  @override
  String get cleanerProCacheCleaner => 'Limpiador de caché';

  @override
  String get cleanerProLogCleaner => 'Limpiador de registros';

  @override
  String get cleanerProAppDataManager => 'Gestor de datos de aplicaciones';

  @override
  String get cleanerScreenCleaner => 'Limpiador';

  @override
  String get scanDetailDeleteFiles => 'Eliminar archivos';

  @override
  String scanDetailDeleteFilesPermanently(Object selectedCount) {
    return '¿Eliminar permanentemente $selectedCount archivos?';
  }

  @override
  String get scanDetailSelectedFilesDeleted =>
      'Archivos seleccionados eliminados';

  @override
  String get scanDetailDeleteAllFiles => 'Eliminar todos los archivos';

  @override
  String scanDetailDeleteAllFilesPermanently(Object fileCount) {
    return '¿Eliminar permanentemente los $fileCount archivos?';
  }

  @override
  String get scanDetailDeleteAll => 'Eliminar todo';

  @override
  String get scanDetailAllFilesDeleted => 'Todos los archivos eliminados';

  @override
  String scanDetailSelected(Object selectedCount) {
    return '$selectedCount seleccionados';
  }

  @override
  String get scanDetailDeselectAll => 'Deseleccionar todo';

  @override
  String get scanDetailNewestFirst => 'Más recientes primero';

  @override
  String get scanDetailOldestFirst => 'Más antiguos primero';

  @override
  String get scanDetailLargestFirst => 'Más grandes primero';

  @override
  String get scanDetailSmallestFirst => 'Más pequeños primero';

  @override
  String get scanDetailNoFilesFound => 'No se encontraron archivos';

  @override
  String get scanDetailDeleteAll2 => 'Eliminar todo';

  @override
  String get scanInstalledAppsSearchApps => 'Buscar aplicaciones...';

  @override
  String get scanInstalledAppsNoAppsFound => 'No se encontraron aplicaciones.';

  @override
  String get scanUiScanComplete => 'Análisis completado';

  @override
  String scanUiScannedItems(Object scanned) {
    return 'Analizados: $scanned elementos';
  }

  @override
  String scanUiProgress(Object pct, Object scanned, Object total) {
    return 'Progreso: $pct ($scanned / $total)';
  }

  @override
  String get scanUiPreparingEngine => 'Preparando motor...';

  @override
  String get scanUiLoadingTargetS => 'Cargando objetivo(s)';

  @override
  String get scanUiAvarionxVPN => 'AvarionX VPN';

  @override
  String get scanUiProtectYourInternetWithOurUnlimitedVPN =>
      'Protege tu conexión a Internet con nuestra VPN ilimitada';

  @override
  String get scanUiTapMe => '¡Tócame!';

  @override
  String scanUiScanned(Object scanned) {
    return '$scanned analizados';
  }

  @override
  String get scanUiReturn => 'Volver';

  @override
  String get scanLimitsSettingsUpdated => 'Ajustes actualizados';

  @override
  String get scanLimitsScanLimits => 'Límites de análisis';

  @override
  String get scanLimitsLimitHowMuchTheEngineUsesYour =>
      'Limita cuánto usa el motor tu CPU. Hilos: 0 significa automático.';

  @override
  String get scanLimitsMaxScanThreads => 'Máximo de hilos de análisis';

  @override
  String scanLimits0AutoRange0ToCores(Object maxThreads, Object coreCount) {
    return '0 = automático. Intervalo: 0 a $maxThreads (núcleos: $coreCount).';
  }

  @override
  String scanLegacyScanning(Object percent) {
    return 'Analizando... $percent%';
  }

  @override
  String scanLegacySuspicious(Object infectedCount) {
    return 'Sospechosos: $infectedCount';
  }

  @override
  String scanLegacyClean(Object cleanCount) {
    return 'Limpios: $cleanCount';
  }

  @override
  String get scanLegacyNoFilesToScan => 'No hay archivos que analizar';

  @override
  String get settingsSponsorsUnlock => 'Los patrocinadores lo desbloquean ❤️';

  @override
  String get settingsPickCertificate => 'Elegir certificado';

  @override
  String get settingsCertificateLoaded => 'Certificado cargado';

  @override
  String get settingsEnterCode => 'introducir código';

  @override
  String get settingsSupportFileMissing => 'Falta el archivo de soporte';

  @override
  String get settingsInvalidSupportCode => 'Código de soporte no válido';

  @override
  String get settingsAvarionxSecurity => 'Seguridad de AvarionX';

  @override
  String get settingsAvarionxIsAMobileSecuritySuiteCreated =>
      'AvarionX es una suite de seguridad móvil creada por ColourSwift, con sede en Birmingham, Reino Unido.\n\n';

  @override
  String get settingsContact => 'Contacto: ';

  @override
  String get settingsExperimentalFeatures => 'Funciones experimentales';

  @override
  String get settingsEnablingShizukuUnlocksExperimentalWorkInProgress =>
      'Al activar Shizuku se desbloquean funciones experimentales todavía en desarrollo:\n\n';

  @override
  String get settingsAdvancedRansomwareProtection =>
      '• Protección avanzada contra ransomware\n';

  @override
  String get settingsCacheCleanerPlus => '• Cache Cleaner Plus\n\n';

  @override
  String get settingsExperimentalWarning => 'Advertencia experimental:\n';

  @override
  String get settingsTheseFeaturesUseAdvancedSystemAccessAnd =>
      'Estas funciones utilizan acceso avanzado al sistema y pueden comportarse de forma diferente según el dispositivo, la versión de Android y la configuración de Shizuku. Algunas acciones pueden afectar a aplicaciones en ejecución, archivos o datos de caché de forma más directa que un análisis normal.\n\n';

  @override
  String get settingsOnlyEnableThisIfYouUnderstandShizuku =>
      'Activa esto solo si entiendes Shizuku, aceptas que la función aún está en pruebas y has hecho una copia de seguridad de todo lo importante.\n\n';

  @override
  String get settingsPleaseReadTheDocumentationBeforeEnabling =>
      'Lee la documentación antes de activarlo.';

  @override
  String get settingsEnable => 'Activar';

  @override
  String get settingsSigningOut => 'Cerrando sesión...';

  @override
  String get settingsCheckingAccountStatus =>
      'Comprobando el estado de la cuenta...';

  @override
  String get settingsManageSignInPremiumAndPurchases =>
      'Gestionar inicio de sesión, Premium y compras';

  @override
  String get settingsPremiumActive => 'Premium activo';

  @override
  String get settingsManagePremiumOptionsAndRestorePurchases =>
      'Gestionar opciones Premium y restaurar compras';

  @override
  String get settingsUnlockDeepAnalysisModeAndVPNFeatures =>
      'Desbloquea el modo de análisis profundo y las funciones VPN';

  @override
  String get settingsAutoClearNotifications =>
      'Borrar notificaciones automáticamente';

  @override
  String get settingsScanModes => 'Modos de análisis';

  @override
  String get settingsAdvancedScanModes => 'Modos de análisis avanzados';

  @override
  String get settingsDisableToUseTheDefaultScanningMode =>
      'Desactiva para usar el modo de análisis predeterminado';

  @override
  String get settingsToggleToEnableAllScanningModes =>
      'Activa para habilitar todos los modos de análisis';

  @override
  String get settingsApkSubmissions => 'Envíos de APK';

  @override
  String get settingsShareMaliciousAPKs => 'Compartir APK maliciosos';

  @override
  String get settingsHelpingImproveDetectionForEveryone =>
      'Ayuda a mejorar la detección para todos';

  @override
  String get settingsOff => 'Desactivado';

  @override
  String get settingsIncludeRealtimeProtectionCatches =>
      'Incluir detecciones de Protección en tiempo real';

  @override
  String get settingsApksFlaggedByRealtimeProtectionAreIncluded =>
      'Se incluyen los APK marcados por Protección en tiempo real';

  @override
  String get settingsApksFlaggedByRealtimeProtectionAreExcluded =>
      'Se excluyen los APK marcados por Protección en tiempo real';

  @override
  String get settingsIncludeManualAndScheduledScans =>
      'Incluir análisis manuales y programados';

  @override
  String get settingsApksFlaggedByScansAreIncluded =>
      'Se incluyen los APK marcados por los análisis';

  @override
  String get settingsApksFlaggedByScansAreExcluded =>
      'Se excluyen los APK marcados por los análisis';

  @override
  String get settingsWiFiOnly => 'Solo Wi-Fi';

  @override
  String get settingsUploadsWaitForAWiFiConnection =>
      'Las subidas esperan a una conexión Wi-Fi';

  @override
  String get settingsUploadsMayUseMobileData =>
      'Las subidas pueden usar datos móviles';

  @override
  String get settingsChargingOnly => 'Solo mientras se carga';

  @override
  String get settingsUploadsWaitUntilTheDeviceIsCharging =>
      'Las subidas esperan hasta que el dispositivo esté cargando';

  @override
  String get settingsUploadsAreNotLimitedToCharging =>
      'Las subidas no se limitan al estado de carga';

  @override
  String get settingsChooseWhichAppsUpload =>
      'Elegir qué aplicaciones se suben';

  @override
  String get settingsReviewAndPickAppsEachTimeBefore =>
      'Revisar y elegir aplicaciones cada vez antes de subirlas';

  @override
  String get settingsFlaggedAppsUploadAutomatically =>
      'Las aplicaciones marcadas se suben automáticamente';

  @override
  String get settingsEnableProDebug => 'Activar Pro (depuración)';

  @override
  String get settingsLocalUnlockForUITesting =>
      'Desbloqueo local para pruebas de interfaz';

  @override
  String get settingsRestorePurchases => 'Restaurar compras';

  @override
  String get settingsReCheckPlayBilling => 'Volver a comprobar Play Billing';

  @override
  String get settingsCheckingAccount => 'Comprobando cuenta...';

  @override
  String get settingsAvarionxAccountConnected => 'Cuenta de AvarionX conectada';

  @override
  String settingsAccountID(Object accountId) {
    return 'ID de cuenta: $accountId';
  }

  @override
  String get settingsSignInToManagePurchasesAndAccount =>
      'Inicia sesión para gestionar las compras y las funciones de la cuenta.';

  @override
  String get settingsOpenTheAvarionXAccountPortal =>
      'Abrir el portal de cuenta de AvarionX';

  @override
  String get settingsAccountDashboard => 'Panel de la cuenta';

  @override
  String get settingsOpenBillingAndAccountSettings =>
      'Abrir ajustes de facturación y cuenta';

  @override
  String get settingsRemoveThisAccountFromTheApp =>
      'Eliminar esta cuenta de la aplicación';

  @override
  String get settingsPremiumFeaturesAreAvailableOnThisDevice =>
      'Las funciones Premium están disponibles en este dispositivo';

  @override
  String get settingsViewOptionalPremiumFeatures =>
      'Ver funciones Premium opcionales';

  @override
  String get settingsReCheckPlayBillingEntitlement =>
      'Volver a comprobar el derecho de Play Billing';

  @override
  String get settingsRtpNotificationAutoClearNotifications =>
      'Borrar notificaciones automáticamente';

  @override
  String get settingsRtpNotificationNever => 'Nunca';

  @override
  String get settingsRtpNotification5Minutes => '5 minutos';

  @override
  String get settingsRtpNotification10Minutes => '10 minutos';

  @override
  String get settingsRtpNotification30Minutes => '30 minutos';

  @override
  String get settingsThemeBlack => 'Negro';

  @override
  String get settingsThemeWhite => 'Blanco';

  @override
  String get settingsThemeGrey => 'Gris';

  @override
  String get settingsThemeEmerald => 'Esmeralda';

  @override
  String get settingsThemePurple => 'Morado';

  @override
  String get settingsThemeRoyalBlue => 'Azul real';

  @override
  String get settingsAccountCardSyncPurchasesAndUnlockProAcrossApps =>
      'Sincroniza las compras y desbloquea Pro en todas las aplicaciones.';

  @override
  String get settingsAccountCardLoading => 'Cargando...';

  @override
  String get settingsAccountCardDashboard => 'Panel';

  @override
  String get settingsProCardChangePlan => 'Cambiar plan';

  @override
  String get advancedNetworkProtectionEnterYourOwnResolver =>
      'Introduce tu propio resolvedor';

  @override
  String get advancedNetworkProtectionCloudProtectionMode =>
      'Modo de protección en la nube';

  @override
  String get advancedNetworkProtectionRoutesAllDNSQueriesToTheCloud =>
      'Enruta todas las consultas DNS al motor en la nube, lo que permite actualizaciones en directo de las listas de bloqueo, comprobaciones de reputación de dominios y mucho más.';

  @override
  String get advancedNetworkProtectionRefreshProStatus =>
      'Actualizar estado de Pro';

  @override
  String get advancedNetworkProtectionProActive => 'Pro activo';

  @override
  String get advancedNetworkProtectionFreePlan => 'Plan gratuito';

  @override
  String get advancedNetworkProtectionChecksYourEntitlementAndSyncsItWith =>
      'Comprueba tu derecho y lo sincroniza con las funciones en la nube. Pro desbloquea el bloqueo de anuncios en todo el sistema.';

  @override
  String get advancedNetworkProtectionMalwareProtection =>
      'Protección contra malware';

  @override
  String get advancedNetworkProtectionBlocksKnownMaliciousDomains =>
      'Bloquea dominios maliciosos conocidos';

  @override
  String get advancedNetworkProtectionTrackerProtection =>
      'Protección contra rastreadores';

  @override
  String get advancedNetworkProtectionReducesTrackingDomains =>
      'Reduce los dominios de seguimiento';

  @override
  String get advancedNetworkProtectionAdProtection =>
      'Protección contra anuncios';

  @override
  String get advancedNetworkProtectionBlocksCommonAdDomains =>
      'Bloquea dominios publicitarios comunes';

  @override
  String get advancedNetworkProtectionAdultFilter =>
      'Filtro de contenido para adultos';

  @override
  String get advancedNetworkProtectionUses1113Upstream =>
      'Usa 1.1.1.3 como servidor ascendente';

  @override
  String get advancedNetworkProtectionLockedUntilProIsActiveAndCloud =>
      'Bloqueado hasta que Pro esté activo y el modo en la nube esté habilitado.';

  @override
  String get advancedNetworkProtectionLiveDNSEventsFromTheVPNLayer =>
      'Eventos DNS en directo desde la capa VPN.';

  @override
  String get advancedNetworkProtectionAdvanced => 'Avanzado';

  @override
  String get advancedNetworkProtectionDns => 'DNS';

  @override
  String get advancedNetworkProtectionCloudDNSMode => 'Modo DNS en la nube';

  @override
  String get networkProtectionEnterYourOwnResolver =>
      'Introduce tu propio resolvedor';

  @override
  String get networkAppControlEnableVPNToggles => 'Activar controles de VPN';

  @override
  String get networkAppControlOpenSettings => 'Abrir ajustes';

  @override
  String get networkAppControlAppControl => 'Control de aplicaciones';

  @override
  String get networkAppControlNoAppsFound => 'No se encontraron aplicaciones.';

  @override
  String get networkSpeedTestCountry => 'País';

  @override
  String get networkSpeedTestRunning => 'En curso';

  @override
  String get networkSpeedTestRunTest => 'Ejecutar prueba';

  @override
  String get networkSpeedTestNoResultsYet => 'Aún no hay resultados.';

  @override
  String networkSpeedTestDnsTLS(Object dns, Object tls) {
    return 'DNS: $dns  •  TLS: $tls';
  }

  @override
  String get networkSpeedTestFail => 'Fallo';

  @override
  String get dnsNetworkProtectionEnterYourOwnResolver =>
      'Introduce tu propio resolvedor';

  @override
  String get dnsNetworkProtectionDnsFilteringIsSeperateFromTheSecure =>
      'El filtrado DNS es independiente de Secure VPN. Puede bloquear malware conocido, anuncios (en todas las aplicaciones), rastreadores y contenido de categorías no deseadas antes de que se carguen.';

  @override
  String get fullVpnSignedIn => 'Sesión iniciada.';

  @override
  String get fullVpnSignInRequired => 'Inicio de sesión necesario';

  @override
  String get fullVpnClose => 'Cerrar';

  @override
  String get fullVpnLoadingUsage => 'Cargando uso...';

  @override
  String get fullVpnSyncing => 'Sincronizando';

  @override
  String fullVpnUsedThisMonth(Object usedBytes) {
    return '$usedBytes usados este mes';
  }

  @override
  String get blockedScreenUnsupportedEnvironment => 'Entorno no compatible';

  @override
  String updateLogUpdateV(Object version) {
    return 'Actualización: v$version';
  }

  @override
  String get updateLogHiThereAvarionXHasBeenUpdatedBelow =>
      '¡Hola! AvarionX se ha actualizado. Estos son los cambios:';

  @override
  String get updateLogNoUserFacingChangesInThisUpdate =>
      'Esta actualización no incluye cambios visibles para el usuario.';

  @override
  String get updateLogContinue => 'Continuar';

  @override
  String get featuresRealtimeProtectionBody =>
      'Supervisa archivos nuevos y modificados en segundo plano y bloquea las amenazas en cuanto aparecen.';

  @override
  String get featuresTriLayerEngineTitle => 'Motor de tres capas';

  @override
  String get featuresTriLayerEngineBody =>
      'Un núcleo de detección de tres etapas que combina filtrado Bloom, análisis de firmas y análisis de bytes orientado a APK para ofrecer gran precisión y velocidad.';

  @override
  String get featuresMachineLearningTitle => 'Aprendizaje automático';

  @override
  String get featuresMachineLearningBody =>
      'Un modelo ligero en el dispositivo entrenado para reconocer patrones de comportamiento malicioso en APK.';

  @override
  String get featuresCleanerProTitle => 'Cleaner Pro';

  @override
  String get featuresCleanerProBody =>
      'Un módulo de limpieza en evolución que identifica duplicados, caché y aplicaciones sin usar para recuperar almacenamiento.';

  @override
  String get featuresWifiProtectionTitle => 'Protección Wi-Fi';

  @override
  String get featuresWifiProtectionBody =>
      'Detecta redes Wi-Fi inseguras o sospechosas mediante análisis en el dispositivo.';

  @override
  String get featuresRootLevelProtectionTitle => 'Protección a nivel root';

  @override
  String get featuresRootLevelProtectionBody =>
      'Defensa profunda a nivel del sistema diseñada para dispositivos rooteados y usuarios avanzados.';

  @override
  String get featuresPcCompanionTitle => 'Complemento para PC';

  @override
  String get featuresPcCompanionBody =>
      'Próxima versión de escritorio para integrar el antivirus entre plataformas.';

  @override
  String get deviceSecurityNoRisksFound =>
      'No se encontraron riesgos en el dispositivo';

  @override
  String get deviceSecurityOneCheckNeedsAttention =>
      '1 comprobación del dispositivo necesita atención';

  @override
  String deviceSecurityChecksNeedAttention(Object count) {
    return '$count comprobaciones del dispositivo necesitan atención';
  }

  @override
  String get deviceSecurityHealthSectionBody =>
      'Estos ajustes afectan directamente a la postura de seguridad de tu dispositivo.';

  @override
  String get deviceSecurityRecommendationsSectionBody =>
      'Estos ajustes forman parte de las buenas prácticas de seguridad habituales.';

  @override
  String get deviceSecuritySignalUnavailable => 'Señal no disponible';

  @override
  String get deviceSecurityIgnoredByYou => 'Ignorado por ti';

  @override
  String get deviceSecurityScreenLockInactiveTitle => 'Bloqueo de pantalla';

  @override
  String get deviceSecurityScreenLockActiveLabel =>
      'No seguro: no hay configurado un bloqueo de pantalla seguro';

  @override
  String get deviceSecurityScreenLockInactiveLabel =>
      'El bloqueo de pantalla está activo';

  @override
  String get deviceSecurityScreenLockDetail =>
      'Un bloqueo de pantalla seguro protege tu dispositivo si se pierde, lo roban o queda desatendido. Sin un PIN, contraseña, patrón, huella dactilar o desbloqueo facial respaldado por un método de bloqueo seguro, cualquiera que tenga acceso físico puede abrir el dispositivo con mayor facilidad.';

  @override
  String get deviceSecurityScreenLockHelp =>
      'Abre los ajustes de seguridad de Android y configura un bloqueo de pantalla seguro.';

  @override
  String get deviceSecurityCheckSetting => 'Comprobar ajuste';

  @override
  String get deviceSecurityPrivilegedInactiveTitle => 'Sin acceso privilegiado';

  @override
  String get deviceSecurityPrivilegedActiveLabel =>
      'Acceso privilegiado detectado';

  @override
  String get deviceSecurityPrivilegedInactiveLabel =>
      'No se detectó acceso privilegiado';

  @override
  String get deviceSecurityPrivilegedDetail =>
      'Root y Shizuku pueden ser útiles, pero también aumentan el impacto de una aplicación maliciosa si se abusa del acceso. Las aplicaciones con acceso privilegiado pueden realizar acciones que las aplicaciones normales de Android no pueden.';

  @override
  String get deviceSecurityPrivilegedHelp =>
      'Revisa manualmente los ajustes de root, Magisk o Shizuku.';

  @override
  String get deviceSecurityReviewSetting => 'Revisar ajuste';

  @override
  String get deviceSecurityAppVerificationInactiveTitle =>
      'Verificación de aplicaciones';

  @override
  String get deviceSecurityAppVerificationActiveLabel =>
      'No seguro: la verificación de aplicaciones parece estar desactivada';

  @override
  String get deviceSecurityAppVerificationInactiveLabel =>
      'La verificación de aplicaciones parece estar activada';

  @override
  String get deviceSecurityAppVerificationDetail =>
      'La verificación de aplicaciones de Android ayuda a comprobar las aplicaciones antes o después de instalarlas. Si esta protección está desactivada o no está disponible, es menos probable que las aplicaciones dañinas se bloqueen antes de ejecutarse.';

  @override
  String get deviceSecurityAppVerificationHelp =>
      'Abre los ajustes de seguridad de Android y revisa la verificación de aplicaciones.';

  @override
  String get deviceSecuritySecurityPatchInactiveTitle =>
      'Parche de seguridad actualizado';

  @override
  String get deviceSecuritySecurityPatchActiveLabel =>
      'El nivel del parche de seguridad está desactualizado';

  @override
  String get deviceSecuritySecurityPatchInactiveLabel =>
      'El nivel del parche de seguridad está actualizado';

  @override
  String get deviceSecuritySecurityPatchDetail =>
      'Los parches de seguridad de Android corrigen problemas conocidos de la plataforma y del fabricante. Si el nivel del parche es antiguo, el dispositivo puede estar expuesto a vulnerabilidades que ya se han corregido en versiones más recientes.';

  @override
  String get deviceSecuritySecurityPatchHelp =>
      'Abre los ajustes de actualización del sistema Android y busca actualizaciones.';

  @override
  String get deviceSecurityCheckUpdates => 'Buscar actualizaciones';

  @override
  String get deviceSecurityDeveloperModeInactiveTitle => 'Modo desarrollador';

  @override
  String get deviceSecurityDeveloperModeActiveLabel =>
      'Las opciones de desarrollador están activadas';

  @override
  String get deviceSecurityDeveloperModeInactiveLabel =>
      'Las opciones de desarrollador están desactivadas';

  @override
  String get deviceSecurityDeveloperModeDetail =>
      'El Modo desarrollador es normal para desarrolladores y probadores, pero expone ajustes avanzados que pueden reducir la seguridad del dispositivo si se cambian accidentalmente o los utiliza de forma indebida alguien con acceso al dispositivo.';

  @override
  String get deviceSecurityDeveloperModeHelp =>
      'Abre las Opciones de desarrollador y desactiva los ajustes que no necesites.';

  @override
  String get deviceSecurityUsbDebuggingInactiveTitle => 'Depuración USB';

  @override
  String get deviceSecurityUsbDebuggingActiveLabel =>
      'No seguro: la depuración USB está activada';

  @override
  String get deviceSecurityUsbDebuggingInactiveLabel =>
      'La depuración USB está desactivada';

  @override
  String get deviceSecurityUsbDebuggingDetail =>
      'La depuración USB permite que un ordenador conectado interactúe con tu dispositivo mediante Android Debug Bridge. Si se deja activada, aumenta el riesgo de acceso no autorizado al conectarse a un equipo que no sea de confianza.';

  @override
  String get deviceSecurityUsbDebuggingHelp =>
      'Abre las Opciones de desarrollador y desactiva la depuración USB.';

  @override
  String get deviceSecurityUnknownSourcesInactiveTitle =>
      'Fuentes desconocidas';

  @override
  String get deviceSecurityUnknownSourcesActiveLabel =>
      'Se permite instalar aplicaciones desconocidas';

  @override
  String get deviceSecurityUnknownSourcesInactiveLabel =>
      'La instalación de aplicaciones desconocidas está restringida';

  @override
  String get deviceSecurityUnknownSourcesDetail =>
      'Permitir instalaciones de aplicaciones desconocidas puede ser útil para APK de confianza, pero también aumenta la posibilidad de instalar aplicaciones de fuentes no seguras. Permítelo solo para aplicaciones y tiendas en las que confíes.';

  @override
  String get deviceSecurityUnknownSourcesHelp =>
      'Abre los ajustes de Android y revisa el acceso para instalar aplicaciones desconocidas.';

  @override
  String get deviceSecurityAccessibilityInactiveTitle =>
      'Servicios de accesibilidad';

  @override
  String get deviceSecurityAccessibilityActiveLabel =>
      'Servicio de accesibilidad de terceros activado';

  @override
  String get deviceSecurityAccessibilityInactiveLabel =>
      'No se encontraron servicios de accesibilidad de riesgo';

  @override
  String get deviceSecurityAccessibilityDetail =>
      'Los servicios de accesibilidad son potentes porque pueden observar el contenido de la pantalla y realizar acciones en nombre del usuario. Esto resulta útil para herramientas legítimas, pero también es una función que las aplicaciones maliciosas suelen utilizar de forma abusiva.';

  @override
  String get deviceSecurityAccessibilityHelp =>
      'Abre los ajustes de Accesibilidad y revisa los servicios activados.';

  @override
  String get deviceSecurityChecking =>
      'Comprobando la seguridad del dispositivo';

  @override
  String get deviceSecurityReadingSignals =>
      'Leyendo señales de postura del dispositivo...';

  @override
  String get deviceSecurityOneCheckAttention =>
      '1 comprobación necesita atención';

  @override
  String deviceSecurityChecksAttention(Object count) {
    return '$count comprobaciones necesitan atención';
  }

  @override
  String get deviceSecurityTapSignal =>
      'Toca una señal de abajo para obtener más información.';

  @override
  String deviceSecurityIgnoredChecks(Object count, String plural) {
    String _temp0 = intl.Intl.selectLogic(
      plural,
      {
        's': '',
        'other': '',
      },
    );
    return 'Comprobaciones activas ignoradas: $count.$_temp0';
  }

  @override
  String get deviceSecurityPostureNormal =>
      'Las comprobaciones de postura de seguridad de tu dispositivo parecen normales.';

  @override
  String get timeJustNow => 'ahora mismo';

  @override
  String timeMinutesAgo(Object minutes) {
    return 'hace $minutes min';
  }

  @override
  String timeHoursAgo(Object hours) {
    return 'hace $hours h';
  }

  @override
  String timeDaysAgo(Object days) {
    return 'hace $days d';
  }

  @override
  String get securityNoReportDataYet => 'Aún no hay datos del informe';

  @override
  String securityLastActivity(Object relative) {
    return 'Última actividad $relative';
  }

  @override
  String get securityReportSharePdfTitle => 'Informe de seguridad de Avarionx';

  @override
  String get securityReportCsvField => 'Campo';

  @override
  String get securityReportCsvValue => 'Valor';

  @override
  String get securityReportGeneratedAt => 'Generado el';

  @override
  String get securityReportOverallStatus => 'Estado general';

  @override
  String get securityReportLastManualScan => 'Último análisis manual';

  @override
  String get securityReportLastRealtimeEvent => 'Último evento en tiempo real';

  @override
  String get securityReportLastScheduledScan => 'Último análisis programado';

  @override
  String get securityReportShareCsvTitle =>
      'CSV del informe de seguridad de Avarionx';

  @override
  String get securityReportReviewRecommended => 'Se recomienda revisar';

  @override
  String get securityReportNoKnownThreatDetected =>
      'No se detectó ninguna amenaza conocida';

  @override
  String securityReportGeneratedLine(Object generatedAt) {
    return 'Generado: $generatedAt';
  }

  @override
  String securityReportStatusLine(Object status) {
    return 'Estado: $status';
  }

  @override
  String securityReportLatestActivityLine(Object latest) {
    return 'Última actividad: $latest';
  }

  @override
  String securityReportManualScansLine(Object count) {
    return 'Análisis manuales: $count';
  }

  @override
  String securityReportRealtimeChecksLine(Object count) {
    return 'Comprobaciones en tiempo real: $count';
  }

  @override
  String securityReportTotalFilesScannedLine(Object count) {
    return 'Total de archivos analizados: $count';
  }

  @override
  String securityReportThreatsFoundLine(Object count) {
    return 'Amenazas encontradas: $count';
  }

  @override
  String securityReportLastManualScanLine(Object value) {
    return 'Último análisis manual: $value';
  }

  @override
  String securityReportLastRealtimeEventLine(Object value) {
    return 'Último evento en tiempo real: $value';
  }

  @override
  String securityReportLastScheduledScanLine(Object value) {
    return 'Último análisis programado: $value';
  }

  @override
  String get securityReportNotRecorded => 'No registrado';

  @override
  String get safeViewNavigationBlocked => 'Navegación bloqueada';

  @override
  String get safeViewInvalidDestination => 'Destino no válido';

  @override
  String get safeViewUnsupportedScheme => 'Esquema no compatible';

  @override
  String get safeViewUnableToResolveDestination =>
      'No se pudo resolver el destino';

  @override
  String get safeViewDestinationBlocked => 'Destino bloqueado';

  @override
  String get safeViewUnableToVerifyDestination =>
      'No se pudo verificar el destino';

  @override
  String proScreenCurrentStatus(Object status) {
    return 'Estado actual: $status';
  }

  @override
  String proScreenBilledAnnuallyAt(Object price) {
    return 'Facturado anualmente a $price';
  }

  @override
  String get quarantineUnknownApp => 'Aplicación desconocida';

  @override
  String get cleanerScanCancelled => 'Análisis cancelado';

  @override
  String get cleanerProClearingCaches => 'Borrando cachés…';

  @override
  String get cleanerProTrimAppCaches =>
      'Reduce las cachés de aplicaciones en todo el dispositivo.';

  @override
  String get cleanerProEnableShizuku =>
      'Activa Shizuku en Ajustes para usar esta función.';

  @override
  String get cleanerProScanningStorage => 'Analizando almacenamiento…';

  @override
  String get cleanerProFindLogFiles =>
      'Busca archivos .log, .trace, .crash y .dmp.';

  @override
  String cleanerProLogFileCount(Object count, Object size) {
    return '$count archivos • $size';
  }

  @override
  String get cleanerProAppManagerReady =>
      'Fuerza la detención, borra datos y desinstala aplicaciones por lotes.';

  @override
  String get cleanerProAppManagerLimited =>
      'La desinstalación funciona con normalidad. Forzar detención y borrar datos requieren Shizuku.';

  @override
  String get cleanerProCheckingShizuku => 'Comprobando Shizuku…';

  @override
  String get cleanerProShizukuNotRunning =>
      'Shizuku no se está ejecutando. Actívalo desde Ajustes cuando lo necesites.';

  @override
  String get cleanerProShizukuPermissionMissing =>
      'No se ha concedido el permiso de Shizuku. Actívalo desde Ajustes.';

  @override
  String get cleanerProShizukuNotBound =>
      'El servicio Shizuku aún no está vinculado. Abre Ajustes y actualiza esta pantalla después de activarlo.';

  @override
  String get cleanerLiteTab => 'Lite';

  @override
  String get cleanerProTab => 'Pro';

  @override
  String get scanCancelled => 'Análisis cancelado';

  @override
  String get scanPreparing => 'Preparando análisis...';

  @override
  String scanSuspiciousItemsFound(Object count, String plural) {
    String _temp0 = intl.Intl.selectLogic(
      plural,
      {
        's': '',
        'other': '',
      },
    );
    return 'Elementos sospechosos encontrados: $count.$_temp0';
  }

  @override
  String scanSuspiciousCount(Object count) {
    return '$count sospechosos';
  }

  @override
  String scanCleanCount(Object count) {
    return '$count limpios';
  }

  @override
  String scanNotificationFullItems(Object count) {
    return 'Analizados: $count elementos';
  }

  @override
  String scanNotificationCurrent(Object count, Object file) {
    return 'Analizados: $count • $file';
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
  String get settingsThemeRoyalBluePremium => 'Azul real (Premium)';

  @override
  String get settingsIconDefault => 'Predeterminado';

  @override
  String get settingsIconBird => 'Pájaro';

  @override
  String get settingsIconNeon => 'Neón';

  @override
  String get settingsIconOriginal => 'Original';

  @override
  String get homeRealtimeProtectionTitle => 'Protección en tiempo real';

  @override
  String get networkCardStatusLocked => 'Bloqueado';

  @override
  String get networkSectionConnection => 'Conexión';

  @override
  String get networkSectionBlocklists => 'Listas de bloqueo';

  @override
  String get networkSectionResolver => 'Resolvedor';

  @override
  String get networkAppControlOtherVpnSetupInstructions =>
      'Actualmente hay otra VPN seleccionada como Siempre activa.\n\nPara bloquear aplicaciones de forma fiable:\n\n1) Abre los ajustes de VPN de Android\n2) Selecciona AvarionX como VPN\n3) Activa VPN siempre activa\n4) Activa Bloquear conexiones sin VPN';

  @override
  String get networkAppControlSetupInstructions =>
      'Para bloquear aplicaciones de forma fiable:\n\n1) Abre los ajustes de VPN de Android\n2) Selecciona AvarionX como VPN\n3) Activa VPN siempre activa\n4) Activa Bloquear conexiones sin VPN';

  @override
  String get networkAppControlBlockingActive =>
      'El bloqueo de aplicaciones está activo.';

  @override
  String get networkAppControlOtherVpnWarning =>
      'Hay otra VPN configurada como Siempre activa. Activa Siempre activa + Bloquear sin VPN para AvarionX.';

  @override
  String get networkAppControlSetupWarning =>
      'Activa Siempre activa + Bloquear sin VPN para AvarionX para que funcione el bloqueo de aplicaciones.';

  @override
  String get countryUnitedKingdom => 'Reino Unido';

  @override
  String get countryUnitedStates => 'Estados Unidos';

  @override
  String get countryCanada => 'Canadá';

  @override
  String get countryIreland => 'Irlanda';

  @override
  String get countryFrance => 'Francia';

  @override
  String get countryGermany => 'Alemania';

  @override
  String get countryNetherlands => 'Países Bajos';

  @override
  String get countrySpain => 'España';

  @override
  String get countryItaly => 'Italia';

  @override
  String get countrySweden => 'Suecia';

  @override
  String get countryNorway => 'Noruega';

  @override
  String get countryDenmark => 'Dinamarca';

  @override
  String get countryPoland => 'Polonia';

  @override
  String get countryTurkey => 'Turquía';

  @override
  String get countryGreece => 'Grecia';

  @override
  String get countryRomania => 'Rumanía';

  @override
  String get countryUkraine => 'Ucrania';

  @override
  String get countryRussia => 'Rusia';

  @override
  String get countryIndia => 'India';

  @override
  String get countryPakistan => 'Pakistán';

  @override
  String get countryBangladesh => 'Bangladés';

  @override
  String get countrySriLanka => 'Sri Lanka';

  @override
  String get countryNepal => 'Nepal';

  @override
  String get countryJapan => 'Japón';

  @override
  String get countrySouthKorea => 'Corea del Sur';

  @override
  String get countrySingapore => 'Singapur';

  @override
  String get countryMalaysia => 'Malasia';

  @override
  String get countryThailand => 'Tailandia';

  @override
  String get countryVietnam => 'Vietnam';

  @override
  String get countryPhilippines => 'Filipinas';

  @override
  String get countryIndonesia => 'Indonesia';

  @override
  String get countryAustralia => 'Australia';

  @override
  String get countryNewZealand => 'Nueva Zelanda';

  @override
  String get countryBrazil => 'Brasil';

  @override
  String get countryArgentina => 'Argentina';

  @override
  String get countryChile => 'Chile';

  @override
  String get countryMexico => 'México';

  @override
  String get countryColombia => 'Colombia';

  @override
  String get countryPeru => 'Perú';

  @override
  String get countrySouthAfrica => 'Sudáfrica';

  @override
  String get countryNigeria => 'Nigeria';

  @override
  String get countryKenya => 'Kenia';

  @override
  String get countryEgypt => 'Egipto';

  @override
  String get countryUAE => 'Emiratos Árabes Unidos';

  @override
  String get countrySaudiArabia => 'Arabia Saudí';

  @override
  String get countryIsrael => 'Israel';

  @override
  String networkSpeedTestTesting(Object current, Object total, Object domain) {
    return 'Probando $current/$total • $domain';
  }

  @override
  String get networkSpeedTestDone => 'Hecho';

  @override
  String get vpnFooterCustomisation => 'Personalización';

  @override
  String get apkClipboardReportTitle =>
      'VTTI Cloud - Informe de análisis de APK';

  @override
  String apkClipboardAppName(Object name) {
    return 'Nombre de la aplicación: $name';
  }

  @override
  String apkClipboardPackageId(Object packageId) {
    return 'ID del paquete: $packageId';
  }

  @override
  String apkClipboardVersion(Object version) {
    return 'Versión: $version';
  }

  @override
  String apkClipboardFileSize(Object size) {
    return 'Tamaño del archivo: $size';
  }

  @override
  String apkClipboardMinSdk(Object sdk) {
    return 'SDK mínimo: $sdk';
  }

  @override
  String apkClipboardTargetSdk(Object sdk) {
    return 'SDK de destino: $sdk';
  }

  @override
  String apkClipboardSignature(Object signature) {
    return 'Firma: $signature';
  }

  @override
  String apkClipboardMalwareRisk(Object risk) {
    return 'Riesgo de malware: $risk';
  }

  @override
  String apkClipboardRiskLabel(Object label) {
    return 'Etiqueta de riesgo: $label';
  }

  @override
  String apkClipboardHashVerdict(Object verdict) {
    return 'Veredicto del hash: $verdict';
  }

  @override
  String apkClipboardRationale(Object rationale) {
    return 'Justificación: $rationale';
  }

  @override
  String get apkReportUnusualFlags => 'Indicadores inusuales';

  @override
  String get apkReportUnverifiedItems => 'Elementos no verificados';

  @override
  String get apkReportKnownMalware => 'Malware conocido';

  @override
  String get apkReportSuspiciousHash => 'Hash sospechoso';

  @override
  String get apkReportCleanHash => 'Hash limpio';

  @override
  String get apkReportHashNotChecked => 'Hash no comprobado';

  @override
  String get apkReportHashUnknown => 'Hash desconocido';

  @override
  String get apkMetadataPackage => 'Paquete';

  @override
  String get apkMetadataPackageId => 'ID del paquete';

  @override
  String get apkMetadataEngine => 'Motor';

  @override
  String get apkMetadataSize => 'Tamaño';

  @override
  String get apkMetadataMinSdk => 'SDK mínimo';

  @override
  String get apkMetadataTargetSdk => 'SDK de destino';

  @override
  String get apkMetadataSignature => 'Firma';

  @override
  String get apkAnalyserStageDeconstructing => 'Desmontando APK';

  @override
  String get apkAnalyserStageAnalysing => 'Analizando contenido';

  @override
  String get apkAnalyserSignInRequired =>
      'Inicia sesión desde Ajustes para usar Cloud Analysis.';

  @override
  String get apkAnalyserStageCheckingCloud => 'Comprobando VTTI Cloud';

  @override
  String apkAnalyserDailyLimitReached(Object limit) {
    return 'Has alcanzado tu límite diario de $limit análisis.';
  }

  @override
  String get apkAnalyserCloudAnalysisFailed =>
      'El análisis en la nube ha fallado';

  @override
  String get apkAnalyserStageGeneratingReport => 'Generando informe';

  @override
  String get apkAnalyserAnalysisFailed =>
      'No se pudo procesar el análisis del APK';

  @override
  String get genericError => 'Error';

  @override
  String get apkReportEngineVttiCloud => 'Motor VTTI Cloud';

  @override
  String get apkReportCertificateDetected => 'Certificado detectado';

  @override
  String get apkReportNoCertificateData => 'No hay datos del certificado';

  @override
  String get apkExportOverview => 'Resumen';

  @override
  String get apkExportMalwareAssessment => 'Evaluación de malware';

  @override
  String get apkExportRiskScore => 'Puntuación de riesgo';

  @override
  String get apkExportRiskLabel => 'Etiqueta de riesgo';

  @override
  String get apkExportHashVerdict => 'Veredicto del hash';

  @override
  String get apkExportScoreRationale => 'Justificación de la puntuación';

  @override
  String get apkExportContributingSignals => 'Señales contribuyentes';

  @override
  String get apkExportDampeningFactors => 'Factores atenuantes';

  @override
  String get apkExportPermissionsRequested => 'Permisos solicitados';

  @override
  String get apkExportExtraFlagsUnusual =>
      'Indicadores adicionales (inusuales)';

  @override
  String get apkExportExtraFlagsUnverified =>
      'Indicadores adicionales (no verificados)';

  @override
  String get apkExportDiscoveredSources => 'Fuentes descubiertas';

  @override
  String get apkExportRequestedPermissions => 'Permisos solicitados';

  @override
  String get apkExportRationale => 'Justificación';

  @override
  String apkExportCsvShareText(Object name) {
    return 'CSV del análisis de APK de $name';
  }

  @override
  String get apkExportPdfTitle => 'VTTI Cloud - Análisis de APK';

  @override
  String apkExportPdfShareText(Object name) {
    return 'PDF del análisis de APK de $name';
  }

  @override
  String get apkMetadataAppName => 'Nombre de la aplicación';

  @override
  String get apkMetadataFileSize => 'Tamaño del archivo';

  @override
  String get vpnBackendFailedOpenBrowser => 'No se pudo abrir el navegador.';

  @override
  String get vpnBackendSignedIn => 'Sesión iniciada.';

  @override
  String get vpnBackendSignedOut => 'Sesión cerrada.';

  @override
  String get vpnBackendSessionExpiredSignIn =>
      'La sesión ha caducado. Inicia sesión de nuevo.';

  @override
  String vpnBackendFailedLoadAccountStatus(Object status) {
    return 'No se pudo cargar la cuenta ($status).';
  }

  @override
  String vpnBackendFailedLoadAccountError(Object error) {
    return 'No se pudo cargar la cuenta ($error).';
  }

  @override
  String get vpnBackendSignInFirst => 'Inicia sesión primero.';

  @override
  String get vpnBackendConnecting => 'Conectando...';

  @override
  String get vpnBackendNotificationsPermissionRequired =>
      'Se requiere permiso para las notificaciones.';

  @override
  String get vpnBackendPermissionNotGranted =>
      'No se concedió el permiso de VPN.';

  @override
  String get vpnBackendAnotherVpnActive =>
      'Hay otra VPN activa. Desactívala primero.';

  @override
  String get vpnBackendProvisionIncomplete =>
      'El aprovisionamiento devolvió ajustes incompletos.';

  @override
  String get vpnBackendSecuringConnection => 'Protegiendo la conexión...';

  @override
  String get vpnBackendConnected => 'Conectado.';

  @override
  String vpnBackendWireGuardFailed(Object error) {
    return 'No se pudo iniciar WireGuard ($error).';
  }

  @override
  String get vpnBackendDisconnecting => 'Desconectando...';

  @override
  String get vpnBackendDisconnected => 'Desconectado.';

  @override
  String vpnBackendSelectedServer(Object server) {
    return 'Seleccionado $server';
  }

  @override
  String vpnBackendSwitchingServer(Object server) {
    return 'Cambiando a $server...';
  }

  @override
  String get vpnBackendKeyNotFound => 'No se encontró la clave VPN.';

  @override
  String get vpnBackendDnsUpdated => 'Ajustes DNS actualizados.';

  @override
  String get vpnBackendSessionExpired => 'La sesión ha caducado.';

  @override
  String vpnBackendFailedStatus(Object status) {
    return 'Falló ($status).';
  }

  @override
  String get vpnBackendPlanNotAllowed => 'Tu plan no permite usar Full VPN.';

  @override
  String vpnBackendProvisionFailed(Object status) {
    return 'Falló el aprovisionamiento ($status).';
  }
}
