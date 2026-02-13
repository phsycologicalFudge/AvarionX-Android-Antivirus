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
  String get footerSettings => 'Configurações';

  @override
  String get proBadge => 'PRO';

  @override
  String get updateDbTitle => 'Atualizando banco de dados';

  @override
  String updateDbVersionLabel(Object version) {
    return 'Versão $version';
  }

  @override
  String get exploreMultiThreadingTitle => 'Multi-threading';

  @override
  String get exploreMultiThreadingSubtitle => 'Controle experimental do motor';

  @override
  String get updateDbAutoDownloadLabel =>
      'Baixar automaticamente atualizações futuras';

  @override
  String get updateDbUpdatedAutoOn =>
      'Banco de dados atualizado • Atualizações automáticas ativadas';

  @override
  String get updateDbUpdatedSuccess => 'Banco de dados atualizado com sucesso';

  @override
  String get updateDbUpdateFailed => 'Falha ao atualizar o banco de dados';

  @override
  String get engineReadyBanner => 'MOTOR PRONTO • VX-TITANIUM-v7';

  @override
  String get scanButton => 'Escanear';

  @override
  String get scanModeFullTitle => 'Varredura completa do dispositivo';

  @override
  String get scanModeFullSubtitle =>
      'Escaneia todos os arquivos legíveis do armazenamento.';

  @override
  String get scanModeSmartTitle => 'Varredura inteligente [Recomendado]';

  @override
  String get scanModeSmartSubtitle =>
      'Escaneia arquivos que podem conter malware.';

  @override
  String get scanModeRapidTitle => 'Varredura rápida';

  @override
  String get scanModeRapidSubtitle => 'Verifica APKs recentes em Downloads.';

  @override
  String get scanModeInstalledTitle => 'Apps instalados';

  @override
  String get scanModeInstalledSubtitle =>
      'Escaneia seus apps instalados em busca de ameaças.';

  @override
  String get scanModeSingleTitle => 'Escanear arquivo / app';

  @override
  String get scanModeSingleSubtitle =>
      'Escolha um arquivo ou app para escanear.';

  @override
  String get useCloudAssistedScan => 'Usar varredura assistida pela nuvem';

  @override
  String get protectionTitle => 'Proteção';

  @override
  String get stateOffLine1 => 'A proteção do dispositivo está desligada';

  @override
  String get stateOffLine2 => 'Toque para ligar';

  @override
  String get stateAdvancedActiveLine1 => 'A proteção avançada está ativa';

  @override
  String get stateFileOnlyLine1 => 'Apenas proteção de arquivos';

  @override
  String get stateFileOnlyLine2 => 'Proteção de rede desativada';

  @override
  String get stateVpnConflictLine2 => 'Outro VPN está ativo';

  @override
  String get stateProtectedLine1 => 'Dispositivo protegido';

  @override
  String get stateProtectedLine2 => 'Toque para desligar';

  @override
  String get dbUpdating => 'Atualizando banco de dados';

  @override
  String dbVersionAutoUpdated(Object version) {
    return 'Banco de dados v$version • Atualizado automaticamente';
  }

  @override
  String get rtpInfoTitle => 'Proteção em tempo real';

  @override
  String get rtpInfoBody =>
      'Além de bloquear arquivos suspeitos baixados intencionalmente (ou por malware), o RTP usa um VPN local para bloquear domínios maliciosos no sistema inteiro.\n\nQuando ativado, a filtragem de rede permanece ativa, a menos que:\n• Seja desativada manualmente via Terminal\n• Seja substituída por outro VPN\n\nA proteção de arquivos continua enquanto o RTP estiver ativado.';

  @override
  String get scanTitleDefault => 'Escanear';

  @override
  String get scanTitleSmart => 'Varredura inteligente';

  @override
  String get scanTitleRapid => 'Varredura rápida';

  @override
  String get scanTitleInstalled => 'Escanear apps instalados';

  @override
  String get scanTitleFull => 'Varredura completa do dispositivo';

  @override
  String get scanTitleSingle => 'Varredura única';

  @override
  String get cancellingScan => 'Cancelando varredura…';

  @override
  String get cancelScan => 'Cancelar varredura';

  @override
  String get scanProgressZero => 'Progresso: 0%';

  @override
  String scanProgressWithPct(Object pct, Object scanned, Object total) {
    return 'Progresso: $pct% ($scanned / $total)';
  }

  @override
  String scanProgressFullItems(Object count) {
    return 'Escaneados: $count itens';
  }

  @override
  String get initializing => 'Inicializando...';

  @override
  String get scanningEllipsis => 'Escaneando...';

  @override
  String get fullScanInfoTitle => 'Varredura completa do dispositivo';

  @override
  String get fullScanInfoBody =>
      'Este modo escaneia todos os arquivos legíveis no armazenamento, sem filtro.\n\nVarredura assistida pela nuvem e varredura de apps não são usadas neste modo.';

  @override
  String get scanComplete => 'Varredura concluída';

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
    return 'Escaneados: $count';
  }

  @override
  String get resultNoThreatsTitle => 'Nenhuma ameaça detectada';

  @override
  String get resultNoThreatsBody =>
      'Nenhuma ameaça foi detectada nos itens escaneados.';

  @override
  String get resultSuspiciousAppsTitle => 'Apps suspeitos';

  @override
  String get resultSuspiciousItemsTitle => 'Itens suspeitos';

  @override
  String get returnHome => 'Voltar ao início';

  @override
  String get emptyTitle => 'Nenhum arquivo vulnerável para escanear';

  @override
  String get emptyBody =>
      'Seu dispositivo não continha arquivos que correspondam aos critérios de varredura.';

  @override
  String get knownMalware => 'Malware conhecido';

  @override
  String get suspiciousActivityDetected => 'Atividade suspeita detectada';

  @override
  String get maliciousActivityDetected => 'Atividade maliciosa detectada';

  @override
  String get androidBankingTrojan => 'Trojan bancário do Android';

  @override
  String get androidSpyware => 'Spyware do Android';

  @override
  String get androidAdware => 'Adware do Android';

  @override
  String get androidSmsFraud => 'Fraude por SMS no Android';

  @override
  String get threatLevelConfirmed => 'Confirmado';

  @override
  String get threatLevelHigh => 'Alto';

  @override
  String get threatLevelMedium => 'Médio';

  @override
  String threatLevelLabel(Object level) {
    return 'Nível de ameaça: $level';
  }

  @override
  String get explainFoundInCloud =>
      'Este item está listado no banco de dados de ameaças na nuvem do ColourSwift.';

  @override
  String get explainFoundInOffline =>
      'Este item está listado no banco de dados offline de malware no seu dispositivo.';

  @override
  String get explainBanker =>
      'Projetado para roubar credenciais financeiras, geralmente usando sobreposições, keylogging ou interceptação de tráfego.';

  @override
  String get explainSpyware =>
      'Monitora atividades silenciosamente ou coleta dados pessoais como mensagens, localização ou identificadores do dispositivo.';

  @override
  String get explainAdware =>
      'Exibe anúncios intrusivos, faz redirecionamentos ou gera tráfego de anúncios fraudulento.';

  @override
  String get explainSmsFraud =>
      'Tenta enviar ou acionar ações por SMS sem consentimento, o que pode causar cobranças inesperadas.';

  @override
  String get explainGenericMalware =>
      'Fortes indicadores de intenção maliciosa foram detectados, mesmo sem corresponder a uma família nomeada.';

  @override
  String get explainSuspiciousDefault =>
      'Indicadores de comportamento suspeito foram detectados. Isso pode incluir padrões vistos em malware, mas também pode ser um falso positivo.';

  @override
  String get singleChoiceScanFile => 'Escanear um arquivo';

  @override
  String get singleChoiceScanInstalledApp => 'Escanear um app instalado';

  @override
  String get singleChoiceManageExclusions => 'Gerenciar exclusões';

  @override
  String get labelKnownMalwareDb => 'Encontrado no banco de dados de malware';

  @override
  String get labelFoundInCloudDb => 'Encontrado no banco de dados na nuvem';

  @override
  String get logEngineFullDeviceScan =>
      '[ENGINE] Varredura completa do dispositivo';

  @override
  String get logEngineTargetStorage => '[ENGINE] Alvo: /storage/emulated/0';

  @override
  String get logEngineNoFilesFound => '[ENGINE] Nenhum arquivo encontrado.';

  @override
  String logEngineFilesEnumerated(Object count) {
    return '[ENGINE] Arquivos enumerados: $count';
  }

  @override
  String get logEngineNoReadableFilesFound =>
      '[ENGINE] Nenhum arquivo legível encontrado.';

  @override
  String logEngineInstalledAppsFound(Object count) {
    return '[ENGINE] Apps instalados encontrados: $count';
  }

  @override
  String get logModeCloudAssisted => '[MODE] Modo assistido pela nuvem';

  @override
  String get logModeOffline => '[MODE] Modo offline';

  @override
  String get logStageHashing => '[STAGE 1] Obtendo hashes (cacheados)...';

  @override
  String get logStageCloudLookup => '[STAGE 2] Consulta de hash na nuvem...';

  @override
  String logStageLocalScanning(Object stage) {
    return '[STAGE $stage] Varredura local de arquivos...';
  }

  @override
  String logCloudHashHits(Object count) {
    return '[CLOUD] $count correspondências de hash';
  }

  @override
  String logSummary(Object suspicious, Object clean) {
    return '[SUMMARY] $suspicious suspeitos • $clean limpos';
  }

  @override
  String logErrorPrefix(Object message) {
    return '[ERROR] $message';
  }

  @override
  String get genericUnknownAppName => 'Desconhecido';

  @override
  String get genericUnknownFileName => 'Desconhecido';

  @override
  String get featuresDrawerTitle => 'Recursos';

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
  String get featureScheduledScans => 'Varreduras agendadas';

  @override
  String get networkStatusDisconnected => 'Desconectado';

  @override
  String get networkStatusConnecting => 'Conectando';

  @override
  String get networkStatusConnected => 'Conectado';

  @override
  String get networkUsageTitle => 'Uso';

  @override
  String get networkUsageEnableVpnToView => 'Ative o VPN para ver o uso.';

  @override
  String get networkUsageUnlimited => 'Ilimitado';

  @override
  String networkUsageUsedOf(Object used, Object limit) {
    return '$used / $limit';
  }

  @override
  String networkUsageResetsOn(Object y, Object m, Object d) {
    return 'Reinicia em $y-$m-$d';
  }

  @override
  String networkUsageUpdatedAt(Object hh, Object mm) {
    return 'Atualizado $hh:$mm';
  }

  @override
  String get networkCardStatusAvailable => 'Disponível';

  @override
  String get networkCardStatusDisabled => 'Desativado';

  @override
  String get networkCardStatusCustom => 'Personalizado';

  @override
  String get networkCardStatusReady => 'Pronto';

  @override
  String get networkCardStatusOpen => 'Abrir';

  @override
  String get networkCardStatusComingSoon => 'Em breve';

  @override
  String get networkCardBlocklistsTitle => 'Listas de bloqueio';

  @override
  String get networkCardBlocklistsSubtitle => 'Controles de filtragem';

  @override
  String get networkCardUpstreamTitle => 'Upstream';

  @override
  String get networkCardUpstreamSubtitle => 'Seleção de resolvedor';

  @override
  String get networkCardAppsTitle => 'Apps';

  @override
  String get networkCardAppsSubtitle => 'Bloquear apps no Wi-Fi';

  @override
  String get networkCardLogsTitle => 'Logs';

  @override
  String get networkCardLogsSubtitle => 'Eventos DNS ao vivo';

  @override
  String get networkCardSpeedTitle => 'Velocidade';

  @override
  String get networkCardSpeedSubtitle => 'Teste de DNS';

  @override
  String get networkCardAboutTitle => 'Sobre';

  @override
  String get networkCardAboutSubtitle => 'GitHub';

  @override
  String get networkLogsStatusNoActivity => 'Sem atividade';

  @override
  String networkLogsStatusRecent(Object count) {
    return '$count recentes';
  }

  @override
  String get networkResolverTitle => 'Resolvedor';

  @override
  String get networkResolverIpLabel => 'IP do resolvedor';

  @override
  String get networkResolverIpHint => 'Exemplo: 1.1.1.1';

  @override
  String get networkSpeedTestTitle => 'Teste de velocidade';

  @override
  String get networkSpeedTestBody =>
      'Executa um testador de velocidade de DNS usando suas configurações atuais.';

  @override
  String get networkSpeedTestRun => 'Executar teste de velocidade';

  @override
  String get networkBlocklistsRecommendedTitle => 'Recomendado';

  @override
  String get networkBlocklistsCsMalwareTitle => 'ColourSwift Malware';

  @override
  String get networkBlocklistsCsAdsTitle => 'ColourSwift ads';

  @override
  String get networkBlocklistsSeeGithub => 'Veja o GitHub para detalhes...';

  @override
  String get networkBlocklistsMalwareSection => 'Malware';

  @override
  String get networkBlocklistsMalwareTitle => 'Lista de bloqueio de malware';

  @override
  String get networkBlocklistsMalwareSources =>
      'HaGeZi TIF • URLHaus • DigitalSide • Spam404';

  @override
  String get networkBlocklistsAdsSection => 'Anúncios';

  @override
  String get networkBlocklistsAdsTitle => 'Lista de bloqueio de anúncios';

  @override
  String get networkBlocklistsAdsSources =>
      'OISD • AdAway • Yoyo • AnudeepND • Firebog AdGuard';

  @override
  String get networkBlocklistsTrackersSection => 'Rastreadores';

  @override
  String get networkBlocklistsTrackersTitle =>
      'Lista de bloqueio de rastreadores';

  @override
  String get networkBlocklistsTrackersSources =>
      'EasyPrivacy • Disconnect • Frogeye • Perflyst • WindowsSpyBlocker';

  @override
  String get networkBlocklistsGamblingSection => 'Apostas';

  @override
  String get networkBlocklistsGamblingTitle => 'Lista de bloqueio de apostas';

  @override
  String get networkBlocklistsGamblingSources => 'HaGeZi Gambling';

  @override
  String get networkBlocklistsSocialSection => 'Redes sociais';

  @override
  String get networkBlocklistsSocialTitle =>
      'Lista de bloqueio de redes sociais';

  @override
  String get networkBlocklistsSocialSources => 'HaGeZi Social';

  @override
  String get networkBlocklistsAdultSection => '18+';

  @override
  String get networkBlocklistsAdultTitle => 'Lista de bloqueio adulta';

  @override
  String get networkBlocklistsAdultSources => 'StevenBlack 18+ • HaGeZi NSFW';

  @override
  String get networkLiveLogsTitle => 'Logs ao vivo';

  @override
  String get networkLiveLogsEmpty => 'Ainda não há requisições.';

  @override
  String get networkLiveLogsBlocked => 'Bloqueado';

  @override
  String get networkLiveLogsAllowed => 'Permitido';

  @override
  String get recommendedMetaPassDesc => 'Gere senhas offline seguras.';

  @override
  String get recommendedCleanerProDesc =>
      'Encontre duplicados, mídias antigas e apps não usados para recuperar espaço automaticamente.';

  @override
  String get recommendedLinkCheckerDesc =>
      'Verifique links suspeitos com o modo de visualização segura, sem risco.';

  @override
  String get recommendedNetworkProtectionDesc =>
      'Mantenha sua conexão protegida contra malware.';

  @override
  String get recommendedTerminalDesc => 'Um recurso avançado para Shizuku';

  @override
  String get recommendedScheduledScansDesc =>
      'Varreduras automáticas em segundo plano.';

  @override
  String get metaPassTitle => 'MetaPass';

  @override
  String get metaPassHowItWorks => 'Como o MetaPass funciona';

  @override
  String get metaPassOk => 'OK';

  @override
  String get metaPassSettings => 'Configurações';

  @override
  String get metaPassPoweredBy => 'powered by VX-TITANIUM';

  @override
  String get metaPassLoading => 'Carregando…';

  @override
  String get metaPassEmptyTitle => 'Nenhuma entrada ainda';

  @override
  String get metaPassEmptyBody =>
      'Adicione um app ou site.\nAs senhas são geradas no dispositivo a partir da sua meta senha secreta.';

  @override
  String get metaPassAddFirstEntry => 'Adicionar primeira entrada';

  @override
  String get metaPassTapToCopyHint =>
      'Toque para copiar. Pressione e segure para remover.';

  @override
  String get metaPassCopyTooltip => 'Copiar senha';

  @override
  String get metaPassAdd => 'Adicionar';

  @override
  String get metaPassPickFromInstalledApps => 'Escolher entre apps instalados';

  @override
  String get metaPassAddWebsiteOrLabel =>
      'Adicionar site ou rótulo personalizado';

  @override
  String get metaPassSelectApp => 'Selecionar um app';

  @override
  String get metaPassSearchApps => 'Pesquisar apps';

  @override
  String get metaPassCancel => 'Cancelar';

  @override
  String get metaPassContinue => 'Continuar';

  @override
  String get metaPassSave => 'Salvar';

  @override
  String get metaPassAddEntryTitle => 'Adicionar entrada';

  @override
  String get metaPassNameOrUrl => 'Nome ou URL';

  @override
  String get metaPassNameOrUrlHint => 'ex.: nextcloud, steam, example.com';

  @override
  String get metaPassVersion => 'Versão';

  @override
  String get metaPassLength => 'Tamanho';

  @override
  String get metaPassSetMetaTitle => 'Definir Meta Password';

  @override
  String get metaPassSetMetaBody =>
      'Digite sua meta senha. Ela nunca sai deste dispositivo. Todas as senhas do cofre dependem dela.';

  @override
  String get metaPassMetaLabel => 'Meta senha';

  @override
  String get metaPassRememberThisDevice =>
      'Lembrar neste dispositivo (armazenado com segurança)';

  @override
  String get metaPassChangingMetaWarning =>
      'Alterar isso depois muda todas as senhas geradas. Usar a mesma meta senha restaura elas.';

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
    return 'Senha copiada para $label (v$version, $length chars)';
  }

  @override
  String metaPassGenerateFailed(Object error) {
    return 'Falha ao gerar senha: $error';
  }

  @override
  String metaPassLoadAppsFailed(Object error) {
    return 'Falha ao carregar apps: $error';
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
      'Senhas nunca são armazenadas.\n\nCada entrada deriva uma senha de:\n• Sua meta senha\n• O rótulo (nome)\n• A versão e o tamanho\n\nReinstalar o app com a mesma meta senha e rótulos regenera as mesmas senhas.';

  @override
  String get passwordSettingsTitle => 'Configurações de senha';

  @override
  String get passwordSettingsSectionMetaPass => 'MetaPass';

  @override
  String get passwordSettingsMetaPasswordTitle => 'Meta senha';

  @override
  String get passwordSettingsMetaNotSet => 'Não definida';

  @override
  String get passwordSettingsMetaStoredSecurely =>
      'Armazenada com segurança neste dispositivo';

  @override
  String get passwordSettingsChange => 'Alterar';

  @override
  String get passwordSettingsSetMetaPassTitle => 'Definir MetaPass';

  @override
  String get passwordSettingsMetaPasswordLabel => 'Meta senha';

  @override
  String get passwordSettingsChangingAltersAll =>
      'Alterar isso muda todas as senhas.\nUsar a mesma MetaPass restaura elas.';

  @override
  String get passwordSettingsCancel => 'Cancelar';

  @override
  String get passwordSettingsSave => 'Salvar';

  @override
  String get passwordSettingsSectionRestoreCode => 'Código de restauração';

  @override
  String get passwordSettingsGenerateRestoreCode =>
      'Gerar código de restauração';

  @override
  String get passwordSettingsCopy => 'Copiar';

  @override
  String get passwordSettingsRestoreCodeCopied =>
      'Código de restauração copiado';

  @override
  String get passwordSettingsSectionRestoreFromCode => 'Restaurar por código';

  @override
  String get passwordSettingsRestoreCodeLabel => 'Código de restauração';

  @override
  String get passwordSettingsRestore => 'Restaurar';

  @override
  String get passwordSettingsVaultRestored => 'Cofre restaurado';

  @override
  String get passwordSettingsFooterInfo =>
      'Senhas nunca são armazenadas.\n\nO código de restauração contém apenas dados de estrutura. Junto com sua MetaPass, ele reconstrói seu cofre.';

  @override
  String get onboardingAppName => 'AVarionX Security';

  @override
  String get onboardingStorageTitle => 'Acesso ao armazenamento';

  @override
  String get onboardingStorageDesc =>
      'Esta permissão é necessária para escanear arquivos no seu dispositivo. Você pode conceder agora ou depois.';

  @override
  String get onboardingStorageFootnote =>
      'Você pode pular, mas será solicitado novamente ao escolher um modo de varredura.';

  @override
  String get onboardingStorageSnack =>
      'A permissão de armazenamento é necessária para escanear.';

  @override
  String get onboardingNotificationsTitle => 'Notificações';

  @override
  String get onboardingNotificationsDesc =>
      'Usadas para alertas em tempo real, status de varredura e atualizações de quarentena.';

  @override
  String get onboardingNotificationsFootnote =>
      'Obrigatório no Android para Proteção em tempo real.';

  @override
  String get onboardingNetworkTitle => 'Proteção de rede';

  @override
  String get onboardingNetworkDesc =>
      'Ativa proteção Wi-Fi usando a permissão de VPN do Android.';

  @override
  String get onboardingNetworkFootnote => 'Isso é opcional, mas recomendado.';

  @override
  String get onboardingGranted => 'Concedido';

  @override
  String get onboardingNotGranted => 'Não concedido';

  @override
  String get onboardingGrantAccess => 'Conceder acesso';

  @override
  String get onboardingAllowNotifications => 'Permitir notificações';

  @override
  String get onboardingAllowVpnAccess => 'Permitir acesso VPN';

  @override
  String get onboardingBack => 'Voltar';

  @override
  String get onboardingNext => 'Avançar';

  @override
  String get onboardingFinish => 'Finalizar';

  @override
  String get onboardingSetupCompleteTitle => 'Configuração concluída';

  @override
  String get onboardingSetupCompleteDesc =>
      'Recomendamos executar uma varredura completa do dispositivo (isso não escaneia apps instalados no momento) ou ir direto para a tela inicial.';

  @override
  String get onboardingRunFullScan => 'Executar varredura completa';

  @override
  String get onboardingGoHome => 'Ir para início';

  @override
  String get networkProtectionTitle => 'Proteção de rede';

  @override
  String networkStatusConnectedToDns(Object dns) {
    return 'Conectado a $dns';
  }

  @override
  String get networkStatusVpnConflictDetail => 'Outro VPN está ativo';

  @override
  String get networkStatusOffDetail => 'A proteção de rede está desligada';

  @override
  String get networkModeMalwareTitle => 'Apenas bloqueio de malware';

  @override
  String get networkModeMalwareSubtitle => 'Usa 1.1.1.2';

  @override
  String get networkModeMalwareDescription =>
      'Combina o banco de dados local de malware da AvarionX com a inteligência online de ameaças da Cloudflare para máxima proteção contra malware.';

  @override
  String get networkModeAdultTitle => 'Malware e conteúdo adulto';

  @override
  String get networkModeAdultSubtitle => 'Usa 1.1.1.3';

  @override
  String get networkModeAdultDescription =>
      'Usa o banco de dados offline de malware da AvarionX e adiciona filtragem de conteúdo adulto. A inteligência de malware baseada em nuvem é desativada neste modo.';

  @override
  String get networkInfoTitle => 'O que é Proteção de rede?';

  @override
  String get networkInfoBody =>
      'Algumas ameaças funcionam conectando-se a servidores maliciosos ou redirecionando o tráfego da internet.\nA Proteção de rede bloqueia domínios perigosos conhecidos e anúncios comuns usando um VPN local.\n\nAVarionX Security não coleta nenhum dado.';

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
      'Verifique a página em busca de malware ou conteúdo suspeito';

  @override
  String get linkCheckerUrlLabel => 'URL';

  @override
  String get linkCheckerUrlHint => 'https://example.com';

  @override
  String get linkCheckerButtonAnalyse => 'Analisar';

  @override
  String get linkCheckerButtonChecking => 'Verificando';

  @override
  String get linkCheckerEngineNotReadySnack => 'Motor não está pronto';

  @override
  String get linkCheckerStatusVerifyingLink => 'Verificando link…';

  @override
  String get linkCheckerStatusScanningPage => 'Escaneando página…';

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
  String get linkCheckerBlockedUnableVerify => 'Não foi possível verificar';

  @override
  String get linkCheckerAnalyseCardTitleDefault =>
      'Verifique a página em busca de conteúdo suspeito';

  @override
  String get linkCheckerAnalyseCardDetailDefault =>
      'Cole uma URL e execute uma análise.';

  @override
  String get linkCheckerAnalyseCardTitleEngineNotReady =>
      'Motor não está pronto';

  @override
  String get linkCheckerAnalyseCardDetailEngineNotReady => 'erro 1001.';

  @override
  String get linkCheckerAnalyseCardTitleChecking => 'Verificando';

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
      'Execute uma análise primeiro para habilitar a visualização.';

  @override
  String get linkCheckerViewSubtitle => 'Veja a página com segurança';

  @override
  String get linkCheckerViewPage => 'Ver página';

  @override
  String get linkCheckerClose => 'Fechar';

  @override
  String get linkCheckerBlockedBody =>
      'Esta página foi interrompida antes de carregar.';

  @override
  String get linkCheckerSuspiciousBanner =>
      'Link suspeito, pode não renderizar se exigir conteúdo bloqueado.';

  @override
  String get linkCheckerHistorySubtitle =>
      'Toque em uma entrada para copiar o link.';

  @override
  String get linkCheckerHistoryEmpty => 'Nenhuma verificação ainda.';

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
  String get settingsSystemDefault => 'Padrão do sistema';

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
  String get settingsSectionPro => 'Recursos PRO';

  @override
  String get settingsProCustomization => 'Personalização PRO';

  @override
  String get settingsProSubtitle =>
      'Remova anúncios e desbloqueie temas e ícones';

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
  String get proActivated => 'PRO ativado';

  @override
  String get proDeactivated => 'PRO desativado';

  @override
  String get settingsProReset => 'Reset PRO (somente debug)';

  @override
  String get settingsProSheetTitle => 'Personalização PRO';

  @override
  String get settingsHideGoldHeader =>
      'Ocultar cabeçalho dourado na tela inicial';

  @override
  String get settingsAppIcon => 'Ícone do app';

  @override
  String settingsIconSelected(Object icon) {
    return 'Ícone selecionado: $icon';
  }

  @override
  String get settingsSave => 'Salvar';

  @override
  String get settingsSectionShizuku => 'Proteção avançada (Shizuku)';

  @override
  String get settingsEnableShizuku => 'Ativar Shizuku';

  @override
  String get settingsShizukuRequiresManager => 'Requer gerenciador externo';

  @override
  String get settingsShizukuNotRunning =>
      'Serviço Shizuku não está em execução';

  @override
  String get settingsShizukuPermissionRequired => 'Permissão necessária';

  @override
  String get settingsShizukuAvailable =>
      'Acesso avançado ao sistema disponível';

  @override
  String get settingsAboutAdvancedProtection => 'Sobre a proteção avançada';

  @override
  String get settingsAboutAdvancedProtectionSubtitle =>
      'Saiba como a proteção avançada funciona';

  @override
  String get settingsAdvancedProtectionDialogTitle =>
      'Proteção avançada do sistema';

  @override
  String get settingsAdvancedProtectionDialogBody =>
      'O acesso Shizuku requer um gerenciador externo, destinado a usuários avançados.\n\nEste recurso é opcional e não é recomendado para proteção casual.';

  @override
  String get settingsAboutShizukuTitle => 'Sobre o Shizuku';

  @override
  String get settingsAboutShizukuBody =>
      'AVarionX pode integrar com Shizuku para acessar processos de apps no nível do sistema.\n\nIsso permite ao app:\n• Detectar malware que se esconde de scanners padrão\n• Inspecionar processos de apps em execução\n• Desativar ou conter a maioria dos malwares ativos\n\nO Shizuku, porém, não concede acesso root\n\nEste recurso é destinado a usuários avançados e não é necessário para proteção normal.\n\nDocumentação:\nhttps://shizuku.rikka.app';

  @override
  String get settingsSectionGeneral => 'Geral';

  @override
  String get settingsExclusions => 'Exclusões';

  @override
  String get settingsExclusionsSubtitle => 'Gerencie e adicione exclusões';

  @override
  String get settingsExcludeFolder => 'Excluir uma pasta';

  @override
  String get settingsExcludeFile => 'Excluir um arquivo';

  @override
  String get settingsManageExclusions => 'Gerenciar exclusões existentes';

  @override
  String get settingsManageExclusionsSubtitle => 'Ver ou remover exclusões';

  @override
  String get settingsFolderExcluded => 'Pasta excluída';

  @override
  String get settingsFileExcluded => 'Arquivo excluído';

  @override
  String get settingsPrivacyPolicy => 'Política de privacidade';

  @override
  String get settingsPrivacyPolicySubtitle =>
      'Veja como seus dados são tratados';

  @override
  String get settingsPrivacyPolicyOpenFail =>
      'Não foi possível abrir a política de privacidade';

  @override
  String get settingsAboutApp => 'Sobre o AVarionX';

  @override
  String get settingsHowThisAppWorks => 'Como este app funciona';

  @override
  String get settingsHowThisAppWorksSubtitle => 'Saiba mais sobre a proteção';

  @override
  String get settingsThemePickerTitle => 'Escolher tema';

  @override
  String get settingsThemeRequiresPro => 'Esse tema requer modo PRO';

  @override
  String get scheduledScansTitle => 'Varreduras agendadas';

  @override
  String get scheduledScansInfoTitle => 'Varreduras agendadas';

  @override
  String get scheduledScansInfoBody =>
      'Enquanto o RTP foca em malware baixado, as Varreduras agendadas iniciarão automaticamente o modo escolhido em segundo plano.\nEle só será executado enquanto o RTP estiver ativado.\n\nUsuários PRO podem personalizar o modo e a frequência.';

  @override
  String get scheduledScansHeader => 'Varreduras automáticas em segundo plano';

  @override
  String get scheduledScansSubheader =>
      'Enquanto o RTP estiver ativo, o app escaneará seu dispositivo com base no modo e na frequência selecionados.';

  @override
  String get proRequiredToCustomize => 'PRO necessário para personalizar';

  @override
  String get scheduledScansEnabledTitle => 'Ativado';

  @override
  String get scheduledScansEnabledSubtitle =>
      'Quando ativado, uma varredura é executada automaticamente no seu agendamento.';

  @override
  String get scheduledScansModeTitle => 'Modo de varredura';

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
  String get scheduledEveryWeek => 'Toda semana';

  @override
  String get scheduledEvery2Weeks => 'A cada 2 semanas';

  @override
  String get scheduledEvery3Weeks => 'A cada 3 semanas';

  @override
  String get scheduledMonthly => 'Mensal';

  @override
  String scheduledEveryDays(Object days) {
    return 'A cada $days dias';
  }

  @override
  String scheduledEveryHours(Object hours) {
    return 'A cada $hours horas';
  }

  @override
  String get scheduledChargingOnlyTitle => 'Apenas carregando';

  @override
  String get scheduledChargingOnlySubtitle =>
      'Execute a varredura agendada apenas enquanto o dispositivo estiver conectado à energia.';

  @override
  String get scheduledPreferredTimeTitle => 'Horário preferido';

  @override
  String get scheduledPreferredTimeSubtitle =>
      'AVarionX tentará iniciar por volta deste horário. O Android pode atrasar para economizar bateria.';

  @override
  String get scheduledPickTime => 'Escolher horário';

  @override
  String get cleanerTitle => 'Cleaner Pro';

  @override
  String get cleanerReadyToScan => 'Pronto para escanear';

  @override
  String get cleanerScan => 'Escanear';

  @override
  String get cleanerScanning => 'Escaneando…';

  @override
  String get cleanerReady => 'Pronto';

  @override
  String get cleanerStatusReady => 'Pronto';

  @override
  String get cleanerStatusStarting => 'Iniciando…';

  @override
  String get cleanerStatusFilesScanned => 'Arquivos escaneados';

  @override
  String get cleanerStatusFindingUnusedApps => 'Encontrando apps não usados…';

  @override
  String get cleanerStatusComplete => 'Concluído';

  @override
  String get cleanerStatusScanError => 'Erro de varredura';

  @override
  String get cleanerStatusScanningApps => 'Escaneando apps…';

  @override
  String get cleanerGrantUsageAccessTitle => 'Conceder acesso de uso';

  @override
  String get cleanerGrantUsageAccessBody =>
      'Para detectar apps não usados, este cleaner requer permissão de Acesso de uso. Você será redirecionado para as configurações do sistema para ativar.';

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
  String get cleanerLargeFiles => 'Arquivos grandes';

  @override
  String cleanerLargeFilesNone(Object size) {
    return 'Nenhum arquivo ≥ $size';
  }

  @override
  String cleanerLargeFilesSubtitle(Object count, Object sizeTotal) {
    return '$count itens • $sizeTotal';
  }

  @override
  String get cleanerUnusedApps => 'Apps não usados';

  @override
  String cleanerUnusedAppsNone(Object days) {
    return 'Nenhum app não usado (últimos $days dias)';
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
  String get cleanerStageOldPhotos => 'Escaneando fotos antigas…';

  @override
  String get cleanerStageOldVideos => 'Escaneando vídeos antigos…';

  @override
  String get cleanerStageLargeFiles => 'Escaneando arquivos grandes…';

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
    return 'Arquivos grandes: $count • $size';
  }

  @override
  String get unusedAppsTitle => 'Apps não usados';

  @override
  String unusedAppsEmpty(Object days) {
    return 'Nenhum app não usado nos últimos $days dias';
  }

  @override
  String get quarantineTitle => 'Removidos';

  @override
  String get quarantineSelectAll => 'Selecionar tudo';

  @override
  String get quarantineRefresh => 'Atualizar';

  @override
  String get quarantineEmptyTitle => 'Nenhum arquivo removido';

  @override
  String get quarantineEmptyBody => 'Tudo o que você remover aparecerá aqui.';

  @override
  String get quarantineRestore => 'Restaurar';

  @override
  String get quarantineDelete => 'Excluir';

  @override
  String get quarantineSnackRestored => 'Restaurado';

  @override
  String get quarantineSnackDeleted => 'Excluído';

  @override
  String get quarantineDeleteDialogTitle => 'Excluir arquivos selecionados?';

  @override
  String quarantineDeleteDialogBody(Object count, Object plural) {
    return 'Isso excluirá permanentemente $count item$plural.';
  }
}
