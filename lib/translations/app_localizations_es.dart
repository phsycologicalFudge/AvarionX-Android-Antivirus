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
  String get scanModeRapidSubtitle => 'Comprueba APK recientes en Descargas.';

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
  String get useCloudAssistedScan => 'Usar escaneo asistido por la nube';

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
  String get stateVpnConflictLine2 => 'Otra VPN está activa';

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
      'Además de bloquear archivos sospechosos descargados intencionalmente (o por malware), RTP usa una VPN local para bloquear dominios maliciosos en todo el sistema.\n\nCuando está activada, el filtrado de red se mantiene activo a menos que:\n• Se desactive manualmente desde Terminal\n• Sea reemplazado por otra VPN\n\nLa protección de archivos continúa igualmente mientras RTP esté activada.';

  @override
  String get scanTitleDefault => 'Escaneo';

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
  String get initializing => 'Iniciando...';

  @override
  String get scanningEllipsis => 'Escaneando...';

  @override
  String get fullScanInfoTitle => 'Escaneo completo del dispositivo';

  @override
  String get fullScanInfoBody =>
      'Este modo escanea todos los archivos legibles del almacenamiento, sin filtros.\n\nEl escaneo asistido por la nube y el escaneo de apps no se usan en este modo.';

  @override
  String get scanComplete => 'Escaneo completado';

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
  String get returnHome => 'Volver a inicio';

  @override
  String get emptyTitle => 'No hay archivos vulnerables para escanear';

  @override
  String get emptyBody =>
      'Tu dispositivo no contenía archivos que coincidan con los criterios del escaneo.';

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
      'Este elemento está listado en la base de datos de malware sin conexión de tu dispositivo.';

  @override
  String get explainBanker =>
      'Diseñado para robar credenciales financieras, a menudo usando superposiciones, keylogging o interceptación de tráfico.';

  @override
  String get explainSpyware =>
      'Supervisa silenciosamente la actividad o recopila datos personales como mensajes, ubicación o identificadores del dispositivo.';

  @override
  String get explainAdware =>
      'Muestra anuncios intrusivos, realiza redirecciones o genera tráfico publicitario fraudulento.';

  @override
  String get explainSmsFraud =>
      'Intenta enviar o activar acciones por SMS sin consentimiento, lo que puede causar cargos inesperados.';

  @override
  String get explainGenericMalware =>
      'Se detectaron fuertes indicios de intención maliciosa, aunque no coincida con una familia con nombre.';

  @override
  String get explainSuspiciousDefault =>
      'Se detectaron indicios de comportamiento sospechoso. Esto puede incluir patrones de abuso vistos en malware, pero también puede ser un falso positivo.';

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
      '[MOTOR] Escaneo completo del dispositivo';

  @override
  String get logEngineTargetStorage => '[MOTOR] Objetivo: /storage/emulated/0';

  @override
  String get logEngineNoFilesFound => '[MOTOR] No se encontraron archivos.';

  @override
  String logEngineFilesEnumerated(Object count) {
    return '[MOTOR] Archivos enumerados: $count';
  }

  @override
  String get logEngineNoReadableFilesFound =>
      '[MOTOR] No se encontraron archivos legibles.';

  @override
  String logEngineInstalledAppsFound(Object count) {
    return '[MOTOR] Apps instaladas encontradas: $count';
  }

  @override
  String get logModeCloudAssisted => '[MODO] Modo asistido por la nube';

  @override
  String get logModeOffline => '[MODO] Modo sin conexión';

  @override
  String get logStageHashing =>
      '[ETAPA 1] Obteniendo hashes de archivos (en caché)...';

  @override
  String get logStageCloudLookup =>
      '[ETAPA 2] Búsqueda de hashes en la nube...';

  @override
  String logStageLocalScanning(Object stage) {
    return '[ETAPA $stage] Escaneando archivos localmente...';
  }

  @override
  String logCloudHashHits(Object count) {
    return '[NUBE] $count coincidencias de hash';
  }

  @override
  String logSummary(Object suspicious, Object clean) {
    return '[RESUMEN] $suspicious sospechosos • $clean limpios';
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
  String get featureLinkChecker => 'Verificador de enlaces';

  @override
  String get featureMetaPass => 'MetaPass';

  @override
  String get featureCleanerPro => 'Cleaner Pro';

  @override
  String get featureTerminal => 'Terminal';

  @override
  String get featureScheduledScans => 'Escaneos programados';

  @override
  String get recommendedMetaPassDesc =>
      'Genera contraseñas seguras sin conexión.';

  @override
  String get recommendedCleanerProDesc =>
      'Encuentra duplicados, contenido antiguo y apps sin uso para recuperar almacenamiento automáticamente.';

  @override
  String get recommendedLinkCheckerDesc =>
      'Comprueba enlaces sospechosos con la vista segura, sin riesgo.';

  @override
  String get recommendedNetworkProtectionDesc =>
      'Mantén tu conexión a internet protegida contra malware.';

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
  String get metaPassPoweredBy => 'impulsado por VX-TITANIUM';

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
  String get metaPassSelectApp => 'Seleccionar una app';

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
  String get metaPassNameOrUrlHint => 'p. ej., nextcloud, steam, ejemplo.com';

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
    return 'Contraseña copiada para $label (v$version, $length caracteres)';
  }

  @override
  String metaPassGenerateFailed(Object error) {
    return 'Error al generar la contraseña: $error';
  }

  @override
  String metaPassLoadAppsFailed(Object error) {
    return 'Error al cargar las apps: $error';
  }

  @override
  String metaPassChars(Object length) {
    return '$length caracteres';
  }

  @override
  String metaPassVersionShort(Object version) {
    return 'v$version';
  }

  @override
  String get metaPassInfoBody =>
      'Las contraseñas nunca se almacenan.\n\nCada entrada deriva una contraseña a partir de:\n• Tu meta contraseña\n• La etiqueta (nombre)\n• La versión y la longitud\n\nReinstalar la app con la misma meta contraseña y etiquetas regenera las mismas contraseñas.';

  @override
  String get passwordSettingsTitle => 'Ajustes de contraseñas';

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
  String get passwordSettingsSetMetaPassTitle => 'Configurar MetaPass';

  @override
  String get passwordSettingsMetaPasswordLabel => 'Meta contraseña';

  @override
  String get passwordSettingsChangingAltersAll =>
      'Cambiar esto modifica todas las contraseñas.\nUsar la misma MetaPass las restaura.';

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
      'El permiso de almacenamiento es necesario para escanear.';

  @override
  String get onboardingNotificationsTitle => 'Notificaciones';

  @override
  String get onboardingNotificationsDesc =>
      'Se usan para alertas en tiempo real, estado de escaneos y actualizaciones de cuarentena.';

  @override
  String get onboardingNotificationsFootnote =>
      'Requerido por Android para la Protección en Tiempo Real.';

  @override
  String get onboardingNetworkTitle => 'Protección de red';

  @override
  String get onboardingNetworkDesc =>
      'Activa la protección Wi Fi usando el permiso de VPN de Android.';

  @override
  String get onboardingNetworkFootnote => 'Esto es opcional pero recomendado.';

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
      'Recomendamos ejecutar un Escaneo completo del dispositivo (actualmente no escanea apps instaladas), o ir directamente a la pantalla de inicio.';

  @override
  String get onboardingRunFullScan =>
      'Ejecutar escaneo completo del dispositivo';

  @override
  String get onboardingGoHome => 'Ir a inicio';

  @override
  String get networkProtectionTitle => 'Protección de red';

  @override
  String networkStatusConnected(Object dns) {
    return 'Conectado a $dns';
  }

  @override
  String get networkStatusVpnConflict => 'Otra VPN está activa';

  @override
  String get networkStatusOff => 'La protección de red está desactivada';

  @override
  String get networkModeMalwareTitle => 'Solo bloqueo de malware';

  @override
  String get networkModeMalwareSubtitle => 'Usa 1.1.1.2';

  @override
  String get networkModeMalwareDescription =>
      'Combina la base de datos local de malware de AvarionX con la inteligencia de amenazas online de Cloudflare para máxima protección contra malware.';

  @override
  String get networkModeAdultTitle => 'Malware y contenido para adultos';

  @override
  String get networkModeAdultSubtitle => 'Usa 1.1.1.3';

  @override
  String get networkModeAdultDescription =>
      'Usa la base de datos offline de malware de AvarionX y añade filtrado de contenido para adultos. La inteligencia de malware en la nube se desactiva en este modo.';

  @override
  String get networkInfoTitle => '¿Qué es la Protección de red?';

  @override
  String get networkInfoBody =>
      'Algunas amenazas funcionan conectándose a servidores maliciosos o redirigiendo el tráfico de internet.\nLa Protección de red bloquea dominios peligrosos conocidos y anuncios comunes usando una VPN local.\n\nAVarionX Security no recopila ningún dato.';

  @override
  String get linkCheckerTitle => 'Verificador de enlaces';

  @override
  String get linkCheckerTabAnalyse => 'Analizar';

  @override
  String get linkCheckerTabView => 'Ver';

  @override
  String get linkCheckerTabHistory => 'Historial';

  @override
  String get linkCheckerAnalyseSubtitle =>
      'Comprobar la página por malware o contenido sospechoso';

  @override
  String get linkCheckerUrlLabel => 'URL';

  @override
  String get linkCheckerUrlHint => 'https://ejemplo.com';

  @override
  String get linkCheckerButtonAnalyse => 'Analizar';

  @override
  String get linkCheckerButtonChecking => 'Comprobando';

  @override
  String get linkCheckerEngineNotReadySnack => 'El motor no está listo';

  @override
  String get linkCheckerStatusVerifyingLink => 'Verificando enlace…';

  @override
  String get linkCheckerStatusScanningPage => 'Escaneando la página…';

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
      'Comprobar la página por contenido sospechoso';

  @override
  String get linkCheckerAnalyseCardDetailDefault =>
      'Pega una URL y ejecuta un análisis.';

  @override
  String get linkCheckerAnalyseCardTitleEngineNotReady =>
      'El motor no está listo';

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
      'Ejecuta un análisis primero para habilitar la visualización.';

  @override
  String get linkCheckerViewSubtitle => 'Ver la página web de forma segura';

  @override
  String get linkCheckerViewPage => 'Ver página';

  @override
  String get linkCheckerClose => 'Cerrar';

  @override
  String get linkCheckerBlockedBody =>
      'Esta página se detuvo antes de que pudiera cargarse.';

  @override
  String get linkCheckerSuspiciousBanner =>
      'Enlace sospechoso, puede no renderizar si requiere contenido bloqueado.';

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
      'Eliminar anuncios y desbloquear temas e iconos';

  @override
  String get settingsUnlockPro => 'Desbloquear PRO';

  @override
  String get settingsProUnlocked => 'Modo PRO desbloqueado';

  @override
  String get settingsPurchaseNotConfirmed => 'Compra no confirmada';

  @override
  String settingsPurchaseFailed(Object error) {
    return 'Error en la compra: $error';
  }

  @override
  String get settingsProReset => 'Restablecer PRO (solo depuración)';

  @override
  String get settingsProSheetTitle => 'Personalización PRO';

  @override
  String get settingsHideGoldHeader =>
      'Ocultar encabezado dorado en la pantalla de inicio';

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
  String get settingsEnableShizuku => 'Habilitar Shizuku';

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
      'Acerca de la Protección avanzada';

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
      'AVarionX puede integrarse con Shizuku para acceder a procesos de apps a nivel de sistema.\n\nEsto permite que la app:\n• Detecte malware que se oculta de escáneres estándar\n• Inspeccione procesos de apps en ejecución\n• Desactive o contenga la mayoría del malware activo\n\nSin embargo, Shizuku no concede acceso root\n\nEsta función está destinada a usuarios avanzados y no es necesaria para protección normal.\n\nDocumentación:\nhttps://shizuku.rikka.app';

  @override
  String get settingsSectionGeneral => 'General';

  @override
  String get settingsExclusions => 'Exclusiones';

  @override
  String get settingsExclusionsSubtitle => 'Gestionar y añadir exclusiones';

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
      'Mientras RTP se centra en malware descargado, los Escaneos programados iniciarán automáticamente el modo de escaneo elegido en segundo plano.\nSolo se ejecutará mientras RTP esté habilitada.\n\nLos usuarios PRO pueden personalizar el modo de escaneo y la frecuencia.';

  @override
  String get scheduledScansHeader => 'Escaneos automáticos en segundo plano';

  @override
  String get scheduledScansSubheader =>
      'Mientras RTP esté activa, la app escaneará tu dispositivo según el modo y la frecuencia seleccionados.';

  @override
  String get proRequiredToCustomize => 'Se requiere PRO para personalizar';

  @override
  String get scheduledScansEnabledTitle => 'Habilitado';

  @override
  String get scheduledScansEnabledSubtitle =>
      'Cuando está habilitado, se ejecuta un escaneo automáticamente según tu programación.';

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
    return 'Se ejecuta: $freq';
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
  String get scheduledMonthly => 'Mensualmente';

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
      'Ejecutar el escaneo programado solo mientras el dispositivo esté conectado a la corriente.';

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
  String get cleanerStatusFindingUnusedApps => 'Buscando apps sin uso…';

  @override
  String get cleanerStatusComplete => 'Completado';

  @override
  String get cleanerStatusScanError => 'Error de escaneo';

  @override
  String get cleanerStatusScanningApps => 'Escaneando apps…';

  @override
  String get cleanerGrantUsageAccessTitle => 'Conceder acceso de uso';

  @override
  String get cleanerGrantUsageAccessBody =>
      'Para detectar apps sin uso, este cleaner requiere el permiso de Acceso de uso. Serás redirigido a los ajustes del sistema para habilitarlo.';

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
  String get cleanerUnusedApps => 'Apps sin uso';

  @override
  String cleanerUnusedAppsNone(Object days) {
    return 'No hay apps sin uso (últimos $days días)';
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
  String get unusedAppsTitle => 'Apps sin uso';

  @override
  String unusedAppsEmpty(Object days) {
    return 'No hay apps sin uso en los últimos $days días';
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
  String get quarantineDeleteDialogTitle =>
      '¿Eliminar los archivos seleccionados?';

  @override
  String quarantineDeleteDialogBody(Object count, Object plural) {
    return 'Esto eliminará permanentemente $count elemento$plural.';
  }
}
