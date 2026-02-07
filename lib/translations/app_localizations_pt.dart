// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Portuguese (`pt`).
class AppLocalizationsPt extends AppLocalizations {
  AppLocalizationsPt([String locale = 'pt']) : super(locale);

  @override
  String get appName => 'AVarionX Security';

  @override
  String get ok => 'OK';

  @override
  String get cancel => 'Cancelar';

  @override
  String get footerHome => 'Início';

  @override
  String get footerExplore => 'Explorar';

  @override
  String get footerRemoved => 'Removidos';

  @override
  String get footerSettings => 'Definições';

  @override
  String get proBadge => 'PRO';

  @override
  String get updateDbTitle => 'A atualizar a base de dados';

  @override
  String updateDbVersionLabel(Object version) {
    return 'Versão $version';
  }

  @override
  String get updateDbAutoDownloadLabel =>
      'Transferir automaticamente futuras atualizações';

  @override
  String get updateDbUpdatedAutoOn =>
      'Base de dados atualizada • Atualizações automáticas ativadas';

  @override
  String get updateDbUpdatedSuccess => 'Base de dados atualizada com sucesso';

  @override
  String get updateDbUpdateFailed => 'Falha ao atualizar a base de dados';

  @override
  String get engineReadyBanner => 'MOTOR PRONTO • VX-TITANIUM-v7';

  @override
  String get scanButton => 'Analisar';

  @override
  String get scanModeFullTitle => 'Análise completa do dispositivo';

  @override
  String get scanModeFullSubtitle =>
      'Analisa todos os ficheiros legíveis no armazenamento.';

  @override
  String get scanModeSmartTitle => 'Análise inteligente [Recomendado]';

  @override
  String get scanModeSmartSubtitle =>
      'Analisa ficheiros que podem conter malware.';

  @override
  String get scanModeRapidTitle => 'Análise rápida';

  @override
  String get scanModeRapidSubtitle =>
      'Verifica APKs recentes em Transferências.';

  @override
  String get scanModeInstalledTitle => 'Aplicações instaladas';

  @override
  String get scanModeInstalledSubtitle =>
      'Analisa as suas aplicações instaladas à procura de ameaças.';

  @override
  String get scanModeSingleTitle => 'Análise de ficheiro / app';

  @override
  String get scanModeSingleSubtitle =>
      'Escolha um ficheiro ou aplicação para analisar.';

  @override
  String get useCloudAssistedScan => 'Usar análise assistida pela cloud';

  @override
  String get protectionTitle => 'Proteção';

  @override
  String get stateOffLine1 => 'A proteção do dispositivo está desativada';

  @override
  String get stateOffLine2 => 'Toque para ativar';

  @override
  String get stateAdvancedActiveLine1 => 'A proteção avançada está ativa';

  @override
  String get stateFileOnlyLine1 => 'Apenas proteção de ficheiros';

  @override
  String get stateFileOnlyLine2 => 'Proteção de rede desativada';

  @override
  String get stateVpnConflictLine2 => 'Outra VPN está ativa';

  @override
  String get stateProtectedLine1 => 'Dispositivo protegido';

  @override
  String get stateProtectedLine2 => 'Toque para desativar';

  @override
  String get dbUpdating => 'A atualizar a base de dados';

  @override
  String dbVersionAutoUpdated(Object version) {
    return 'Base de dados v$version • Atualizada automaticamente';
  }

  @override
  String get rtpInfoTitle => 'Proteção em tempo real';

  @override
  String get rtpInfoBody =>
      'Além de bloquear ficheiros suspeitos transferidos intencionalmente (ou por malware), a RTP usa uma VPN local para bloquear domínios maliciosos em todo o sistema.\n\nQuando ativada, a filtragem de rede mantém-se ativa, exceto se:\n• For desativada manualmente via Terminal\n• For substituída por outra VPN\n\nA proteção de ficheiros continua independentemente, desde que a RTP esteja ativada.';

  @override
  String get scanTitleDefault => 'Analisar';

  @override
  String get scanTitleSmart => 'Análise inteligente';

  @override
  String get scanTitleRapid => 'Análise rápida';

  @override
  String get scanTitleInstalled => 'Analisar aplicações instaladas';

  @override
  String get scanTitleFull => 'Análise completa do dispositivo';

  @override
  String get scanTitleSingle => 'Análise única';

  @override
  String get cancellingScan => 'A cancelar a análise…';

  @override
  String get cancelScan => 'Cancelar análise';

  @override
  String get scanProgressZero => 'Progresso: 0%';

  @override
  String scanProgressWithPct(Object pct, Object scanned, Object total) {
    return 'Progresso: $pct% ($scanned / $total)';
  }

  @override
  String scanProgressFullItems(Object count) {
    return 'Analisados: $count itens';
  }

  @override
  String get initializing => 'A iniciar...';

  @override
  String get scanningEllipsis => 'A analisar...';

  @override
  String get fullScanInfoTitle => 'Análise completa do dispositivo';

  @override
  String get fullScanInfoBody =>
      'Este modo analisa todos os ficheiros legíveis no armazenamento, sem filtros.\n\nA análise assistida pela cloud e a análise de aplicações não são utilizadas neste modo.';

  @override
  String get scanComplete => 'Análise concluída';

  @override
  String pillSuspiciousCount(Object count) {
    return 'Suspeitos: $count';
  }

  @override
  String pillCleanCount(Object count) {
    return 'Limpos: $count';
  }

  @override
  String pillScannedCount(Object count) {
    return 'Analisados: $count';
  }

  @override
  String get resultNoThreatsTitle => 'Nenhuma ameaça detetada';

  @override
  String get resultNoThreatsBody =>
      'Não foram detetadas ameaças nos itens analisados.';

  @override
  String get resultSuspiciousAppsTitle => 'Aplicações suspeitas';

  @override
  String get resultSuspiciousItemsTitle => 'Itens suspeitos';

  @override
  String get returnHome => 'Voltar ao início';

  @override
  String get emptyTitle => 'Sem ficheiros vulneráveis para analisar';

  @override
  String get emptyBody =>
      'O seu dispositivo não continha quaisquer ficheiros que correspondam aos critérios de análise.';

  @override
  String get knownMalware => 'Malware conhecido';

  @override
  String get suspiciousActivityDetected => 'Atividade suspeita detetada';

  @override
  String get maliciousActivityDetected => 'Atividade maliciosa detetada';

  @override
  String get androidBankingTrojan => 'Trojan bancário Android';

  @override
  String get androidSpyware => 'Spyware Android';

  @override
  String get androidAdware => 'Adware Android';

  @override
  String get androidSmsFraud => 'Fraude por SMS no Android';

  @override
  String get threatLevelConfirmed => 'Confirmado';

  @override
  String get threatLevelHigh => 'Elevado';

  @override
  String get threatLevelMedium => 'Médio';

  @override
  String threatLevelLabel(Object level) {
    return 'Nível de ameaça: $level';
  }

  @override
  String get explainFoundInCloud =>
      'Este item está listado na base de dados de ameaças na cloud da ColourSwift.';

  @override
  String get explainFoundInOffline =>
      'Este item está listado na base de dados de malware offline no seu dispositivo.';

  @override
  String get explainBanker =>
      'Concebido para roubar credenciais financeiras, muitas vezes usando sobreposições, keylogging ou interceção de tráfego.';

  @override
  String get explainSpyware =>
      'Monitoriza silenciosamente a atividade ou recolhe dados pessoais, como mensagens, localização ou identificadores do dispositivo.';

  @override
  String get explainAdware =>
      'Exibe anúncios intrusivos, faz redirecionamentos ou gera tráfego publicitário fraudulento.';

  @override
  String get explainSmsFraud =>
      'Tenta enviar ou acionar ações por SMS sem consentimento, o que pode causar cobranças inesperadas.';

  @override
  String get explainGenericMalware =>
      'Foram detetados fortes indicadores de intenção maliciosa, mesmo não correspondendo a uma família com nome.';

  @override
  String get explainSuspiciousDefault =>
      'Foram detetados indicadores de comportamento suspeito. Isto pode incluir padrões de abuso vistos em malware, mas também pode ser um falso positivo.';

  @override
  String get singleChoiceScanFile => 'Analisar um ficheiro';

  @override
  String get singleChoiceScanInstalledApp => 'Analisar uma aplicação instalada';

  @override
  String get singleChoiceManageExclusions => 'Gerir exclusões';

  @override
  String get labelKnownMalwareDb => 'Encontrado na base de dados de malware';

  @override
  String get labelFoundInCloudDb => 'Encontrado na base de dados na cloud';

  @override
  String get logEngineFullDeviceScan =>
      '[MOTOR] Análise completa do dispositivo';

  @override
  String get logEngineTargetStorage => '[MOTOR] Alvo: /storage/emulated/0';

  @override
  String get logEngineNoFilesFound => '[MOTOR] Nenhum ficheiro encontrado.';

  @override
  String logEngineFilesEnumerated(Object count) {
    return '[MOTOR] Ficheiros enumerados: $count';
  }

  @override
  String get logEngineNoReadableFilesFound =>
      '[MOTOR] Nenhum ficheiro legível encontrado.';

  @override
  String logEngineInstalledAppsFound(Object count) {
    return '[MOTOR] Aplicações instaladas encontradas: $count';
  }

  @override
  String get logModeCloudAssisted => '[MODO] Modo assistido pela cloud';

  @override
  String get logModeOffline => '[MODO] Modo offline';

  @override
  String get logStageHashing =>
      '[ETAPA 1] A obter hashes dos ficheiros (em cache)...';

  @override
  String get logStageCloudLookup => '[ETAPA 2] Pesquisa de hashes na cloud...';

  @override
  String logStageLocalScanning(Object stage) {
    return '[ETAPA $stage] A analisar ficheiros localmente...';
  }

  @override
  String logCloudHashHits(Object count) {
    return '[CLOUD] $count correspondências de hash';
  }

  @override
  String logSummary(Object suspicious, Object clean) {
    return '[RESUMO] $suspicious suspeitos • $clean limpos';
  }

  @override
  String logErrorPrefix(Object message) {
    return '[ERRO] $message';
  }

  @override
  String get genericUnknownAppName => 'Desconhecido';

  @override
  String get genericUnknownFileName => 'Desconhecido';

  @override
  String get featuresDrawerTitle => 'Funcionalidades';

  @override
  String get recommendedSectionTitle => 'Recomendado';

  @override
  String get featureNetworkProtection => 'Proteção de rede';

  @override
  String get featureLinkChecker => 'Verificador de links';

  @override
  String get featureMetaPass => 'MetaPass';

  @override
  String get featureCleanerPro => 'Cleaner Pro';

  @override
  String get featureTerminal => 'Terminal';

  @override
  String get featureScheduledScans => 'Análises agendadas';

  @override
  String get recommendedMetaPassDesc => 'Gerar palavras-passe seguras offline.';

  @override
  String get recommendedCleanerProDesc =>
      'Encontrar duplicados, media antigo e apps não usadas para recuperar armazenamento automaticamente.';

  @override
  String get recommendedLinkCheckerDesc =>
      'Verifique links suspeitos com a funcionalidade de vista segura, sem risco.';

  @override
  String get recommendedNetworkProtectionDesc =>
      'Mantenha a sua ligação à internet segura contra malware.';

  @override
  String get recommendedTerminalDesc =>
      'Uma funcionalidade avançada para Shizuku';

  @override
  String get recommendedScheduledScansDesc =>
      'Análises automáticas em segundo plano.';

  @override
  String get metaPassTitle => 'MetaPass';

  @override
  String get metaPassHowItWorks => 'Como o MetaPass funciona';

  @override
  String get metaPassOk => 'OK';

  @override
  String get metaPassSettings => 'Definições';

  @override
  String get metaPassPoweredBy => 'alimentado por VX-TITANIUM';

  @override
  String get metaPassLoading => 'A carregar…';

  @override
  String get metaPassEmptyTitle => 'Ainda sem entradas';

  @override
  String get metaPassEmptyBody =>
      'Adicione uma aplicação ou website.\nAs palavras-passe são geradas no dispositivo a partir da sua meta palavra-passe secreta.';

  @override
  String get metaPassAddFirstEntry => 'Adicionar primeira entrada';

  @override
  String get metaPassTapToCopyHint =>
      'Toque para copiar. Prima longamente para remover.';

  @override
  String get metaPassCopyTooltip => 'Copiar palavra-passe';

  @override
  String get metaPassAdd => 'Adicionar';

  @override
  String get metaPassPickFromInstalledApps =>
      'Escolher entre aplicações instaladas';

  @override
  String get metaPassAddWebsiteOrLabel =>
      'Adicionar website ou etiqueta personalizada';

  @override
  String get metaPassSelectApp => 'Selecionar uma aplicação';

  @override
  String get metaPassSearchApps => 'Pesquisar aplicações';

  @override
  String get metaPassCancel => 'Cancelar';

  @override
  String get metaPassContinue => 'Continuar';

  @override
  String get metaPassSave => 'Guardar';

  @override
  String get metaPassAddEntryTitle => 'Adicionar entrada';

  @override
  String get metaPassNameOrUrl => 'Nome ou URL';

  @override
  String get metaPassNameOrUrlHint => 'ex.: nextcloud, steam, exemplo.com';

  @override
  String get metaPassVersion => 'Versão';

  @override
  String get metaPassLength => 'Comprimento';

  @override
  String get metaPassSetMetaTitle => 'Definir Meta Password';

  @override
  String get metaPassSetMetaBody =>
      'Introduza a sua meta palavra-passe. Ela nunca sai deste dispositivo. Todas as palavras-passe do cofre dependem dela.';

  @override
  String get metaPassMetaLabel => 'Meta palavra-passe';

  @override
  String get metaPassRememberThisDevice =>
      'Memorizar neste dispositivo (armazenado de forma segura)';

  @override
  String get metaPassChangingMetaWarning =>
      'Alterar isto mais tarde altera todas as palavras-passe geradas. Usar a mesma meta palavra-passe restaura-as.';

  @override
  String get metaPassRemoveEntryTitle => 'Remover entrada';

  @override
  String metaPassRemoveEntryBody(Object label) {
    return 'Remover \"$label\" do seu cofre?';
  }

  @override
  String get metaPassRemove => 'Remover';

  @override
  String metaPassPasswordCopied(Object label, Object version, Object length) {
    return 'Palavra-passe copiada para $label (v$version, $length caracteres)';
  }

  @override
  String metaPassGenerateFailed(Object error) {
    return 'Falha ao gerar palavra-passe: $error';
  }

  @override
  String metaPassLoadAppsFailed(Object error) {
    return 'Falha ao carregar aplicações: $error';
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
      'As palavras-passe nunca são armazenadas.\n\nCada entrada deriva uma palavra-passe a partir de:\n• A sua meta palavra-passe\n• A etiqueta (nome)\n• A versão e o comprimento\n\nReinstalar a app com a mesma meta palavra-passe e etiquetas regenera as mesmas palavras-passe.';

  @override
  String get passwordSettingsTitle => 'Definições de palavras-passe';

  @override
  String get passwordSettingsSectionMetaPass => 'MetaPass';

  @override
  String get passwordSettingsMetaPasswordTitle => 'Meta palavra-passe';

  @override
  String get passwordSettingsMetaNotSet => 'Não definida';

  @override
  String get passwordSettingsMetaStoredSecurely =>
      'Armazenada de forma segura neste dispositivo';

  @override
  String get passwordSettingsChange => 'Alterar';

  @override
  String get passwordSettingsSetMetaPassTitle => 'Definir MetaPass';

  @override
  String get passwordSettingsMetaPasswordLabel => 'Meta palavra-passe';

  @override
  String get passwordSettingsChangingAltersAll =>
      'Alterar isto muda todas as palavras-passe.\nUsar a mesma MetaPass restaura-as.';

  @override
  String get passwordSettingsCancel => 'Cancelar';

  @override
  String get passwordSettingsSave => 'Guardar';

  @override
  String get passwordSettingsSectionRestoreCode => 'Código de restauro';

  @override
  String get passwordSettingsGenerateRestoreCode => 'Gerar código de restauro';

  @override
  String get passwordSettingsCopy => 'Copiar';

  @override
  String get passwordSettingsRestoreCodeCopied => 'Código de restauro copiado';

  @override
  String get passwordSettingsSectionRestoreFromCode =>
      'Restaurar a partir de código';

  @override
  String get passwordSettingsRestoreCodeLabel => 'Código de restauro';

  @override
  String get passwordSettingsRestore => 'Restaurar';

  @override
  String get passwordSettingsVaultRestored => 'Cofre restaurado';

  @override
  String get passwordSettingsFooterInfo =>
      'As palavras-passe nunca são armazenadas.\n\nO código de restauro contém apenas dados de estrutura. Combinado com a sua MetaPass, reconstrói o seu cofre.';

  @override
  String get onboardingAppName => 'AVarionX Security';

  @override
  String get onboardingStorageTitle => 'Acesso ao armazenamento';

  @override
  String get onboardingStorageDesc =>
      'Esta permissão é necessária para analisar ficheiros no seu dispositivo. Pode concedê-la agora ou mais tarde.';

  @override
  String get onboardingStorageFootnote =>
      'Pode ignorar isto, mas será novamente pedido quando escolher um modo de análise.';

  @override
  String get onboardingStorageSnack =>
      'A permissão de armazenamento é necessária para analisar.';

  @override
  String get onboardingNotificationsTitle => 'Notificações';

  @override
  String get onboardingNotificationsDesc =>
      'Usadas para alertas em tempo real, estado de análises e atualizações de quarentena.';

  @override
  String get onboardingNotificationsFootnote =>
      'Obrigatório pelo Android para Proteção em Tempo Real.';

  @override
  String get onboardingNetworkTitle => 'Proteção de rede';

  @override
  String get onboardingNetworkDesc =>
      'Ativa a proteção Wi Fi usando a permissão de VPN do Android.';

  @override
  String get onboardingNetworkFootnote => 'Isto é opcional mas recomendado.';

  @override
  String get onboardingGranted => 'Concedida';

  @override
  String get onboardingNotGranted => 'Não concedida';

  @override
  String get onboardingGrantAccess => 'Conceder acesso';

  @override
  String get onboardingAllowNotifications => 'Permitir notificações';

  @override
  String get onboardingAllowVpnAccess => 'Permitir acesso VPN';

  @override
  String get onboardingBack => 'Voltar';

  @override
  String get onboardingNext => 'Seguinte';

  @override
  String get onboardingFinish => 'Concluir';

  @override
  String get onboardingSetupCompleteTitle => 'Configuração concluída';

  @override
  String get onboardingSetupCompleteDesc =>
      'Recomendamos executar uma Análise completa do dispositivo (isto não analisa aplicações instaladas atualmente), ou ir diretamente para o ecrã inicial.';

  @override
  String get onboardingRunFullScan =>
      'Executar análise completa do dispositivo';

  @override
  String get onboardingGoHome => 'Ir para o início';

  @override
  String get networkProtectionTitle => 'Proteção de rede';

  @override
  String networkStatusConnected(Object dns) {
    return 'Ligado a $dns';
  }

  @override
  String get networkStatusVpnConflict => 'Outra VPN está ativa';

  @override
  String get networkStatusOff => 'A proteção de rede está desativada';

  @override
  String get networkModeMalwareTitle => 'Apenas bloqueio de malware';

  @override
  String get networkModeMalwareSubtitle => 'Usa 1.1.1.2';

  @override
  String get networkModeMalwareDescription =>
      'Combina a base de dados local de malware da AvarionX com a inteligência de ameaças online da Cloudflare para máxima proteção contra malware.';

  @override
  String get networkModeAdultTitle => 'Malware e conteúdo adulto';

  @override
  String get networkModeAdultSubtitle => 'Usa 1.1.1.3';

  @override
  String get networkModeAdultDescription =>
      'Usa a base de dados offline de malware da AvarionX e adiciona filtragem de conteúdo adulto. A inteligência de malware baseada na cloud é desativada neste modo.';

  @override
  String get networkInfoTitle => 'O que é a Proteção de rede?';

  @override
  String get networkInfoBody =>
      'Algumas ameaças funcionam ao ligar-se a servidores maliciosos ou ao redirecionar tráfego de internet.\nA Proteção de rede bloqueia domínios perigosos conhecidos e anúncios comuns usando uma VPN local.\n\nAVarionX Security não recolhe quaisquer dados.';

  @override
  String get linkCheckerTitle => 'Verificador de links';

  @override
  String get linkCheckerTabAnalyse => 'Analisar';

  @override
  String get linkCheckerTabView => 'Ver';

  @override
  String get linkCheckerTabHistory => 'Histórico';

  @override
  String get linkCheckerAnalyseSubtitle =>
      'Verificar a página por malware ou conteúdo suspeito';

  @override
  String get linkCheckerUrlLabel => 'URL';

  @override
  String get linkCheckerUrlHint => 'https://exemplo.com';

  @override
  String get linkCheckerButtonAnalyse => 'Analisar';

  @override
  String get linkCheckerButtonChecking => 'A verificar';

  @override
  String get linkCheckerEngineNotReadySnack => 'Motor não está pronto';

  @override
  String get linkCheckerStatusVerifyingLink => 'A verificar link…';

  @override
  String get linkCheckerStatusScanningPage => 'A analisar a página…';

  @override
  String get linkCheckerBlockedNavigation => 'Navegação bloqueada';

  @override
  String get linkCheckerBlockedUnsupportedType => 'Tipo de link não suportado';

  @override
  String get linkCheckerBlockedInvalidDestination => 'Destino inválido';

  @override
  String get linkCheckerBlockedUnableResolve =>
      'Não foi possível resolver o destino';

  @override
  String get linkCheckerBlockedUnableVerify =>
      'Não foi possível verificar o destino';

  @override
  String get linkCheckerAnalyseCardTitleDefault =>
      'Verificar a página por conteúdo suspeito';

  @override
  String get linkCheckerAnalyseCardDetailDefault =>
      'Cole um URL e execute uma análise.';

  @override
  String get linkCheckerAnalyseCardTitleEngineNotReady =>
      'Motor não está pronto';

  @override
  String get linkCheckerAnalyseCardDetailEngineNotReady => 'erro 1001.';

  @override
  String get linkCheckerAnalyseCardTitleChecking => 'A verificar';

  @override
  String get linkCheckerVerdictClean => 'Limpo';

  @override
  String get linkCheckerVerdictCleanDetail => 'Esta página parece ser segura.';

  @override
  String get linkCheckerVerdictSuspicious => 'Suspeito';

  @override
  String get linkCheckerVerdictSuspiciousDetail =>
      'Esta página contém conteúdo suspeito.';

  @override
  String get linkCheckerViewLockedBody =>
      'Execute uma análise primeiro para ativar a visualização.';

  @override
  String get linkCheckerViewSubtitle => 'Ver a página web em segurança';

  @override
  String get linkCheckerViewPage => 'Ver página';

  @override
  String get linkCheckerClose => 'Fechar';

  @override
  String get linkCheckerBlockedBody =>
      'Esta página foi interrompida antes de poder carregar.';

  @override
  String get linkCheckerSuspiciousBanner =>
      'Link suspeito, pode não renderizar se exigir conteúdo bloqueado.';

  @override
  String get linkCheckerHistorySubtitle =>
      'Toque numa entrada para copiar o link.';

  @override
  String get linkCheckerHistoryEmpty => 'Ainda não há verificações.';

  @override
  String get linkCheckerCopied => 'Copiado';

  @override
  String get settingsSectionAppearance => 'Aparência';

  @override
  String get settingsTheme => 'Tema';

  @override
  String settingsThemeCurrent(Object theme) {
    return 'Atual: $theme';
  }

  @override
  String get settingsLanguage => 'Idioma';

  @override
  String settingsLanguageCurrent(Object language) {
    return 'Atual: $language';
  }

  @override
  String get settingsChooseLanguage => 'Escolher idioma';

  @override
  String get settingsLanguageApplied => 'Idioma aplicado';

  @override
  String get settingsSystemDefault => 'Predefinição do sistema';

  @override
  String get settingsSectionCommunity => 'Junte-se à comunidade!';

  @override
  String get settingsDiscord => 'Discord';

  @override
  String get settingsDiscordSubtitle => 'Chat, atualizações e feedback';

  @override
  String get settingsDiscordOpenFail =>
      'Não foi possível abrir o link do Discord';

  @override
  String get settingsSectionPro => 'Funcionalidades PRO';

  @override
  String get settingsProCustomization => 'Personalização PRO';

  @override
  String get settingsProSubtitle =>
      'Remover anúncios e desbloquear temas e ícones';

  @override
  String get settingsUnlockPro => 'Desbloquear PRO';

  @override
  String get settingsProUnlocked => 'Modo PRO desbloqueado';

  @override
  String get settingsPurchaseNotConfirmed => 'Compra não confirmada';

  @override
  String settingsPurchaseFailed(Object error) {
    return 'Falha na compra: $error';
  }

  @override
  String get settingsProReset => 'Reposição de PRO (apenas debug)';

  @override
  String get settingsProSheetTitle => 'Personalização PRO';

  @override
  String get settingsHideGoldHeader =>
      'Ocultar cabeçalho dourado no ecrã inicial';

  @override
  String get settingsAppIcon => 'Ícone da app';

  @override
  String settingsIconSelected(Object icon) {
    return 'Ícone selecionado: $icon';
  }

  @override
  String get settingsSave => 'Guardar';

  @override
  String get settingsSectionShizuku => 'Proteção avançada (Shizuku)';

  @override
  String get settingsEnableShizuku => 'Ativar Shizuku';

  @override
  String get settingsShizukuRequiresManager => 'Requer gestor externo';

  @override
  String get settingsShizukuNotRunning => 'Serviço Shizuku não está a correr';

  @override
  String get settingsShizukuPermissionRequired => 'Permissão necessária';

  @override
  String get settingsShizukuAvailable =>
      'Acesso avançado ao sistema disponível';

  @override
  String get settingsAboutAdvancedProtection => 'Sobre a Proteção avançada';

  @override
  String get settingsAboutAdvancedProtectionSubtitle =>
      'Saiba como a proteção avançada funciona';

  @override
  String get settingsAdvancedProtectionDialogTitle =>
      'Proteção avançada do sistema';

  @override
  String get settingsAdvancedProtectionDialogBody =>
      'O acesso Shizuku requer um gestor externo destinado a utilizadores avançados.\n\nEsta funcionalidade é opcional e não é recomendada para proteção casual.';

  @override
  String get settingsAboutShizukuTitle => 'Sobre Shizuku';

  @override
  String get settingsAboutShizukuBody =>
      'O AVarionX pode integrar-se com o Shizuku para aceder a processos de aplicações ao nível do sistema.\n\nIsto permite que a app:\n• Detete malware que se esconde de scanners padrão\n• Inspecione processos de apps em execução\n• Desative ou contenha a maioria do malware ativo\n\nO Shizuku, no entanto, não concede acesso root\n\nEsta funcionalidade é destinada a utilizadores avançados e não é necessária para proteção normal.\n\nDocumentação:\nhttps://shizuku.rikka.app';

  @override
  String get settingsSectionGeneral => 'Geral';

  @override
  String get settingsExclusions => 'Exclusões';

  @override
  String get settingsExclusionsSubtitle => 'Gerir e adicionar exclusões';

  @override
  String get settingsExcludeFolder => 'Excluir uma pasta';

  @override
  String get settingsExcludeFile => 'Excluir um ficheiro';

  @override
  String get settingsManageExclusions => 'Gerir exclusões existentes';

  @override
  String get settingsManageExclusionsSubtitle => 'Ver ou remover exclusões';

  @override
  String get settingsFolderExcluded => 'Pasta excluída';

  @override
  String get settingsFileExcluded => 'Ficheiro excluído';

  @override
  String get settingsPrivacyPolicy => 'Política de privacidade';

  @override
  String get settingsPrivacyPolicySubtitle =>
      'Ver como os seus dados são tratados';

  @override
  String get settingsPrivacyPolicyOpenFail =>
      'Não foi possível abrir a política de privacidade';

  @override
  String get settingsAboutApp => 'Sobre o AVarionX';

  @override
  String get settingsHowThisAppWorks => 'Como esta app funciona';

  @override
  String get settingsHowThisAppWorksSubtitle => 'Saiba mais sobre a proteção';

  @override
  String get settingsThemePickerTitle => 'Escolher tema';

  @override
  String get settingsThemeRequiresPro => 'Esse tema requer modo PRO';

  @override
  String get scheduledScansTitle => 'Análises agendadas';

  @override
  String get scheduledScansInfoTitle => 'Análises agendadas';

  @override
  String get scheduledScansInfoBody =>
      'Enquanto a RTP se foca em malware transferido, as Análises agendadas irão iniciar automaticamente o modo de análise escolhido em segundo plano.\nSó será executado enquanto a RTP estiver ativada.\n\nUtilizadores PRO podem personalizar o modo de análise e a frequência.';

  @override
  String get scheduledScansHeader => 'Análises automáticas em segundo plano';

  @override
  String get scheduledScansSubheader =>
      'Enquanto a RTP estiver ativa, a app irá analisar o seu dispositivo com base no modo e na frequência selecionados.';

  @override
  String get proRequiredToCustomize => 'PRO necessário para personalizar';

  @override
  String get scheduledScansEnabledTitle => 'Ativado';

  @override
  String get scheduledScansEnabledSubtitle =>
      'Quando ativado, uma análise é executada automaticamente no seu agendamento.';

  @override
  String get scheduledScansModeTitle => 'Modo de análise';

  @override
  String scheduledScansModeHint(Object mode) {
    return 'Modo atual: $mode';
  }

  @override
  String get scheduledScansFrequencyTitle => 'Frequência';

  @override
  String scheduledScansFrequencyHint(Object freq) {
    return 'Executa: $freq';
  }

  @override
  String get scheduledEveryDay => 'Todos os dias';

  @override
  String get scheduledEvery3Days => 'A cada 3 dias';

  @override
  String get scheduledEveryWeek => 'Todas as semanas';

  @override
  String get scheduledEvery2Weeks => 'A cada 2 semanas';

  @override
  String get scheduledEvery3Weeks => 'A cada 3 semanas';

  @override
  String get scheduledMonthly => 'Mensalmente';

  @override
  String scheduledEveryDays(Object days) {
    return 'A cada $days dias';
  }

  @override
  String scheduledEveryHours(Object hours) {
    return 'A cada $hours horas';
  }

  @override
  String get scheduledChargingOnlyTitle => 'Apenas ao carregar';

  @override
  String get scheduledChargingOnlySubtitle =>
      'Executar a análise agendada apenas enquanto o dispositivo estiver ligado à corrente.';

  @override
  String get scheduledPreferredTimeTitle => 'Hora preferida';

  @override
  String get scheduledPreferredTimeSubtitle =>
      'O AVarionX tentará iniciar por volta desta hora. O Android pode atrasar para poupar bateria.';

  @override
  String get scheduledPickTime => 'Escolher hora';

  @override
  String get cleanerTitle => 'Cleaner Pro';

  @override
  String get cleanerReadyToScan => 'Pronto para analisar';

  @override
  String get cleanerScan => 'Analisar';

  @override
  String get cleanerScanning => 'A analisar…';

  @override
  String get cleanerReady => 'Pronto';

  @override
  String get cleanerStatusReady => 'Pronto';

  @override
  String get cleanerStatusStarting => 'A iniciar…';

  @override
  String get cleanerStatusFilesScanned => 'Ficheiros analisados';

  @override
  String get cleanerStatusFindingUnusedApps => 'A procurar apps não usadas…';

  @override
  String get cleanerStatusComplete => 'Concluído';

  @override
  String get cleanerStatusScanError => 'Erro de análise';

  @override
  String get cleanerStatusScanningApps => 'A analisar apps…';

  @override
  String get cleanerGrantUsageAccessTitle => 'Conceder acesso de utilização';

  @override
  String get cleanerGrantUsageAccessBody =>
      'Para detetar apps não usadas, este cleaner requer a permissão de Acesso de utilização. Será redirecionado para as definições do sistema para a ativar.';

  @override
  String get cleanerCancel => 'Cancelar';

  @override
  String get cleanerContinue => 'Continuar';

  @override
  String get cleanerDuplicates => 'Duplicados';

  @override
  String get cleanerDuplicatesNone => 'Nenhum duplicado encontrado';

  @override
  String cleanerDuplicatesSubtitle(Object count, Object size) {
    return '$count itens • recuperar $size';
  }

  @override
  String get cleanerOldPhotos => 'Fotos antigas';

  @override
  String cleanerOldPhotosNone(Object days) {
    return 'Nenhuma foto com mais de $days dias';
  }

  @override
  String cleanerOldPhotosSubtitle(Object count, Object size) {
    return '$count itens • $size';
  }

  @override
  String get cleanerOldVideos => 'Vídeos antigos';

  @override
  String cleanerOldVideosNone(Object days) {
    return 'Nenhum vídeo com mais de $days dias';
  }

  @override
  String cleanerOldVideosSubtitle(Object count, Object size) {
    return '$count itens • $size';
  }

  @override
  String get cleanerLargeFiles => 'Ficheiros grandes';

  @override
  String cleanerLargeFilesNone(Object size) {
    return 'Nenhum ficheiro ≥ $size';
  }

  @override
  String cleanerLargeFilesSubtitle(Object count, Object sizeTotal) {
    return '$count itens • $sizeTotal';
  }

  @override
  String get cleanerUnusedApps => 'Apps não usadas';

  @override
  String cleanerUnusedAppsNone(Object days) {
    return 'Nenhuma app não usada (últimos $days dias)';
  }

  @override
  String cleanerUnusedAppsCount(Object count) {
    return '$count apps';
  }

  @override
  String get cleanerStageDuplicates => 'A analisar duplicados…';

  @override
  String get cleanerStageDuplicatesGrouping => 'A agrupar duplicados…';

  @override
  String get cleanerStageOldPhotos => 'A analisar fotos antigas…';

  @override
  String get cleanerStageOldVideos => 'A analisar vídeos antigos…';

  @override
  String get cleanerStageLargeFiles => 'A analisar ficheiros grandes…';

  @override
  String cleanerStageOldPhotosProgress(Object count, Object size) {
    return 'Fotos antigas: $count • $size';
  }

  @override
  String cleanerStageOldVideosProgress(Object count, Object size) {
    return 'Vídeos antigos: $count • $size';
  }

  @override
  String cleanerStageLargeFilesProgress(Object count, Object size) {
    return 'Ficheiros grandes: $count • $size';
  }

  @override
  String get unusedAppsTitle => 'Apps não usadas';

  @override
  String unusedAppsEmpty(Object days) {
    return 'Nenhuma app não usada nos últimos $days dias';
  }

  @override
  String get quarantineTitle => 'Removidos';

  @override
  String get quarantineSelectAll => 'Selecionar tudo';

  @override
  String get quarantineRefresh => 'Atualizar';

  @override
  String get quarantineEmptyTitle => 'Sem ficheiros removidos';

  @override
  String get quarantineEmptyBody => 'Tudo o que remover aparecerá aqui.';

  @override
  String get quarantineRestore => 'Restaurar';

  @override
  String get quarantineDelete => 'Eliminar';

  @override
  String get quarantineSnackRestored => 'Restaurado';

  @override
  String get quarantineSnackDeleted => 'Eliminado';

  @override
  String get quarantineDeleteDialogTitle => 'Eliminar ficheiros selecionados?';

  @override
  String quarantineDeleteDialogBody(Object count, Object plural) {
    return 'Isto irá eliminar permanentemente $count item$plural.';
  }
}
