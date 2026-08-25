// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Portuguese (`pt`).
class AppLocalizationsPt extends AppLocalizations {
  AppLocalizationsPt([String locale = 'pt']) : super(locale);

  @override
  String get appName => 'AvarionX';

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
  String get proBadge => 'Premium';

  @override
  String get updateDbTitle => 'Atualizando banco de dados';

  @override
  String updateDbVersionLabel(Object version) {
    return 'Versão $version';
  }

  @override
  String get companionAppsSectionTitle => 'Mais da AvarionX';

  @override
  String get cleanerReclaimableLabel => 'Pode ser liberado';

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
  String get engineReadyBanner => 'VX-TITANIUM-v9';

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
  String get settingsSectionPro => 'Recursos Premium';

  @override
  String get settingsProCustomization => 'Personalização Premium';

  @override
  String get settingsProSubtitle =>
      'Remova anúncios e desbloqueie temas e ícones';

  @override
  String get settingsUnlockPro => 'Desbloquear Premium';

  @override
  String get settingsProUnlocked => 'Modo Premium desbloqueado';

  @override
  String get settingsPurchaseNotConfirmed => 'Compra não confirmada';

  @override
  String settingsPurchaseFailed(Object error) {
    return 'Falha na compra: $error';
  }

  @override
  String get homeUpgrade => 'Fazer upgrade';

  @override
  String get homeFeatureSecureVpnTitle => 'AvarionX Secure VPN';

  @override
  String get homeFeatureSecureVpnDesc =>
      'Oculte seu IP e bloqueie anúncios indesejados';

  @override
  String get proActivated => 'Premium ativado';

  @override
  String get proDeactivated => 'Premium desativado';

  @override
  String get settingsProReset => 'Reset Premium (somente debug)';

  @override
  String get settingsProSheetTitle => 'Personalização Premium';

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
  String get vpnSignInRequiredTitle => 'Login necessário';

  @override
  String get vpnClose => 'Fechar';

  @override
  String get vpnSignInRequiredBody =>
      'Entre na sua conta para usar a Secure VPN.';

  @override
  String get vpnCancel => 'Cancelar';

  @override
  String get vpnSignIn => 'Entrar';

  @override
  String get vpnUsageLoading => 'Carregando uso...';

  @override
  String get vpnUsageNoLimits => 'Sem limites de dados';

  @override
  String get vpnUsageSyncing => 'Sincronizando';

  @override
  String vpnUsageUsedThisMonth(Object used) {
    return '$used usados este mês';
  }

  @override
  String get vpnUsageDataTitle => 'Uso de dados';

  @override
  String get vpnUsageUnavailable => 'Uso indisponível';

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
  String get vpnSubtitleEstablishingTunnel => 'Estabelecendo túnel...';

  @override
  String get vpnSubtitleFindingLocation => 'Localizando...';

  @override
  String get vpnStatusProtected => 'Protegido';

  @override
  String get vpnStatusNotConnected => 'Não conectado';

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
  String get vpnBlocklistsTitle => 'Listas de bloqueio da Secure VPN';

  @override
  String get vpnSave => 'Salvar';

  @override
  String get settingsSave => 'Salvar';

  @override
  String get settingsPremium => 'Premium';

  @override
  String get settingsUltimateSecurity => 'Segurança máxima';

  @override
  String get settingsSwitchPlan => 'Trocar de plano';

  @override
  String get settingsBestValue => 'Melhor custo-benefício';

  @override
  String get settingsOneTime => 'Pagamento único';

  @override
  String get settingsPlanPriceLoading => 'Carregando preço...';

  @override
  String get settingsMonthly => 'Mensal';

  @override
  String get settingsYearly => 'Anual';

  @override
  String get settingsLifetime => 'Vitalício';

  @override
  String get settingsSubscribeMonthly => 'Assinar mensalmente';

  @override
  String get settingsSubscribeYearly => 'Assinar anualmente';

  @override
  String get settingsUnlockLifetime => 'Desbloquear vitalício';

  @override
  String get settingsProBenefitsTitle => 'Benefícios';

  @override
  String get settingsUnlimitedDnsTitle => 'Consultas DNS ilimitadas';

  @override
  String get settingsUnlimitedDnsBody =>
      'Remova os limites de consultas e desbloqueie a filtragem completa na nuvem.';

  @override
  String get settingsThemesTitle => 'Temas';

  @override
  String get settingsThemesBody =>
      'Desbloqueie temas premium e opções de personalização.';

  @override
  String get settingsIconCustomizationTitle => 'Personalização do ícone do app';

  @override
  String get settingsIconCustomizationBody =>
      'Altere o ícone do app para combinar com seu estilo.';

  @override
  String get settingsScheduledScansTitle => 'Varreduras agendadas';

  @override
  String get settingsScheduledScansBody =>
      'Desbloqueie agendamento avançado e personalização de varreduras.';

  @override
  String get settingsProFinePrint =>
      'As assinaturas são renovadas a menos que sejam canceladas. Você pode gerenciar ou cancelar a qualquer momento no Google Play. O plano vitalício é uma compra única.';

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
  String get settingsThemeRequiresPro => 'Esse tema requer modo Premium';

  @override
  String get scheduledScansTitle => 'Varreduras agendadas';

  @override
  String get scheduledScansInfoTitle => 'Varreduras agendadas';

  @override
  String get scheduledScansInfoBody =>
      'Enquanto o RTP foca em malware baixado, as Varreduras agendadas iniciarão automaticamente o modo escolhido em segundo plano.\nEle só será executado enquanto o RTP estiver ativado.\n\nUsuários Premium podem personalizar o modo e a frequência.';

  @override
  String get scheduledScansHeader => 'Varreduras automáticas em segundo plano';

  @override
  String get scheduledScansSubheader =>
      'Enquanto o RTP estiver ativo, o app escaneará seu dispositivo com base no modo e na frequência selecionados.';

  @override
  String get proRequiredToCustomize => 'Premium necessário para personalizar';

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
  String get vpnSettingsPrivacySecurityTitle => 'Privacidade e segurança';

  @override
  String get vpnSettingsNoLogsPolicyTitle =>
      'Política de não armazenamento de registros';

  @override
  String get vpnSettingsNoLogsPolicyBody =>
      'Nenhum registro é armazenado. Atividade de conexão, atividade de navegação, consultas DNS e conteúdo do tráfego não são registrados nem retidos.';

  @override
  String get vpnSettingsNoActivityLogsTitle => 'Sem registros de atividade';

  @override
  String get vpnSettingsNoActivityLogsBody =>
      'Sua atividade não é monitorada nem rastreada durante o uso da Secure VPN.';

  @override
  String get vpnSettingsWireGuardTitle => 'VX-Link com tecnologia WireGuard';

  @override
  String get vpnSettingsWireGuardBody =>
      'A Secure VPN usa o protocolo WireGuard por meio do VX-Link para oferecer criptografia rápida e moderna.';

  @override
  String get vpnSettingsMalwareProtectionTitle =>
      'Proteção contra malware ativada';

  @override
  String get vpnSettingsMalwareProtectionBody =>
      'Domínios maliciosos são bloqueados por padrão enquanto você estiver conectado.';

  @override
  String get vpnSettingsAdTrackerProtectionTitle =>
      'Proteção opcional contra anúncios e rastreadores';

  @override
  String get vpnSettingsAdTrackerProtectionBody =>
      'Ative bloqueio adicional de anúncios e rastreadores na aba Personalização.';

  @override
  String get vpnSettingsBrandFooter => 'Protegido por VX-Link';

  @override
  String get vpnSettingsAccountTitle => 'Conta';

  @override
  String get vpnSettingsSignInToContinue => 'Entre para continuar';

  @override
  String get vpnSettingsAccountSyncBody =>
      'Seu plano e uso de dados são sincronizados com sua conta.';

  @override
  String get vpnSettingsSignedIn => 'Conectado à conta';

  @override
  String get vpnSettingsPlanUnknown => 'Plano: desconhecido';

  @override
  String vpnSettingsPlanLabel(Object plan) {
    return 'Plano: $plan';
  }

  @override
  String get vpnSettingsRefresh => 'Atualizar';

  @override
  String get vpnSettingsSignOut => 'Sair';

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
  String get vpnAccountScreenTitle => 'Conta';

  @override
  String get vpnAccountSignInRequiredTitle => 'Login necessário';

  @override
  String get vpnAccountSignInManageUsageBody =>
      'Entre para gerenciar sua conta e seu uso.';

  @override
  String get vpnAccountNotSignedIn => 'Não conectado à conta';

  @override
  String get vpnAccountFree => 'Grátis';

  @override
  String get vpnAccountUnknown => 'Desconhecido';

  @override
  String get vpnAccountStatusSyncing => 'Sincronizando';

  @override
  String get vpnAccountStatusActive => 'Ativo';

  @override
  String get vpnAccountStatusConnected => 'Conectado';

  @override
  String get vpnAccountStatusDisconnected => 'Desconectado';

  @override
  String get vpnAccountStatusUnavailable => 'Indisponível';

  @override
  String get vpnAccountStatusConnectedNow => 'Conectado agora';

  @override
  String get vpnAccountStatusRefreshToLoadServer =>
      'Atualize para carregar o status do servidor';

  @override
  String get vpnAccountUsageTitle => 'Uso';

  @override
  String get vpnAccountUsageLoading => 'Carregando uso...';

  @override
  String get vpnAccountUsageSignInToSync => 'Entre para sincronizar o uso';

  @override
  String get vpnAccountUsagePullToRefresh =>
      'Puxe para atualizar e sincronizar o uso';

  @override
  String get vpnAccountUsageUnlimited => 'Ilimitado';

  @override
  String vpnAccountUsageUsedThisMonth(Object used) {
    return '$used usados este mês';
  }

  @override
  String vpnAccountUsageUsedThisMonthUnlimited(Object used) {
    return '$used usados este mês, ilimitado';
  }

  @override
  String vpnAccountUsageUsedOfLimit(Object used, Object limit) {
    return '$used / $limit';
  }

  @override
  String get settingsSectionAccount => 'Conta';

  @override
  String get settingsAccountTitle => 'Conta';

  @override
  String get settingsAccountSubtitle =>
      'Login, plano, assinatura e uso da conta';

  @override
  String get exploreSecureVpnTitle => 'Secure VPN';

  @override
  String get exploreSecureVpnSubtitle =>
      'Oculte seu IP e bloqueie conteúdo indesejado';

  @override
  String get vpnAccountServerLoadTitle => 'Carga do servidor selecionado';

  @override
  String vpnAccountServerConnectedCount(Object connected, Object cap) {
    return '$connected/$cap';
  }

  @override
  String get networkDnsOffTitle => 'Mudar para filtragem DNS?';

  @override
  String get networkDnsOffInfoTitle => 'O que é filtragem DNS?';

  @override
  String get networkDnsOffInfoBody1 =>
      'A filtragem DNS é separada da Secure VPN. Ela pode bloquear malware conhecido, anúncios em todos os apps, rastreadores e categorias indesejadas antes que sejam carregados.';

  @override
  String get networkDnsOffInfoBody2 =>
      'Ela não criptografa seu tráfego nem oculta seu IP.';

  @override
  String get networkDnsOffEnableButton => 'Ativar filtragem DNS';

  @override
  String vpnAccountServerConnectedCountWithLabel(Object connected, Object cap) {
    return '$connected/$cap conectados';
  }

  @override
  String get vpnAccountIdentityFallbackTitle => 'Conta';

  @override
  String get vpnAccountMembershipLabel => 'Assinatura';

  @override
  String get vpnAccountMembershipFounderVpnPro => 'Fundadores · VPN Pro';

  @override
  String get vpnAccountMembershipFounder => 'Fundador';

  @override
  String get vpnAccountMembershipPro => 'Pro';

  @override
  String get vpnAccountSectionAccountStatus => 'Status da conta';

  @override
  String get vpnAccountSectionActions => 'Ações';

  @override
  String get vpnAccountKvStatus => 'Status';

  @override
  String get vpnAccountKvPlan => 'Plano';

  @override
  String get vpnAccountKvUsage => 'Uso';

  @override
  String get vpnAccountKvSelectedServer => 'Servidor selecionado';

  @override
  String get vpnAccountKvConnectionState => 'Estado da conexão';

  @override
  String get vpnAccountActionRefresh => 'Atualizar';

  @override
  String get vpnAccountActionOpen => 'Abrir';

  @override
  String get vpnAccountFounderThanks => 'Obrigado por apoiar a ColourSwift';

  @override
  String get vpnAccountFounderNote =>
      'Sou apenas um cara, amparado pela melhor comunidade.';

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
  String quarantineDeleteDialogBody(Object count, String plural) {
    String _temp0 = intl.Intl.selectLogic(
      plural,
      {
        's': '',
        'other': '',
      },
    );
    return 'Itens que serão excluídos permanentemente: $count.$_temp0';
  }

  @override
  String get howThisAppWorksHowAvarionXWorks => 'Como o AvarionX funciona';

  @override
  String get howThisAppWorksAvarionxIsAMobileSecurityAppThat =>
      'O AvarionX é um app de segurança móvel que combina varredura antivírus no dispositivo, proteção de rede e recursos opcionais de VPN. ';

  @override
  String get howThisAppWorksTheAntivirusEngineIsPoweredByVX =>
      'O mecanismo antivírus é equipado com VX-Titanium.';

  @override
  String get howThisAppWorksIfYouUseNetworkProtectionOrVPN =>
      'Se você usar a proteção de rede ou os recursos de VPN, o app se conecta aos serviços da ColourSwift para aplicar suas configurações, gerenciar o acesso à sua conta e rotear o tráfego protegido.';

  @override
  String get howThisAppWorksKeyFeatures => 'Principais recursos';

  @override
  String get howThisAppWorksRealTimeProtectionForDownloadedThreats =>
      '• Proteção em tempo real contra ameaças baixadas';

  @override
  String get howThisAppWorksNetworkProtectionWithDNSFiltering =>
      '• Proteção de rede com filtragem DNS';

  @override
  String get howThisAppWorksOptionalSecureVPNMode =>
      '• Modo Secure VPN opcional';

  @override
  String get howThisAppWorksBuiltInToolsSuchAsLinkChecker =>
      '• Ferramentas integradas, como Link Checker';

  @override
  String get howThisAppWorksNotes => 'Observações';

  @override
  String get howThisAppWorksSomeFeaturesMayRequireSignInAn =>
      'Alguns recursos podem exigir login, um plano ativo ou permissões do dispositivo para funcionar corretamente.';

  @override
  String get apkAnalyserCopyCurrentReport => 'Copiar relatório atual';

  @override
  String get apkAnalyserReportCopiedToClipboard =>
      'Relatório copiado para a área de transferência';

  @override
  String get apkAnalyserExportCurrentAsPDF => 'Exportar atual como PDF';

  @override
  String get apkAnalyserFailedToExportPDF => 'Falha ao exportar PDF';

  @override
  String get apkAnalyserExportCurrentAsCSV => 'Exportar atual como CSV';

  @override
  String get apkAnalyserFailedToExportCSV => 'Falha ao exportar CSV';

  @override
  String get apkAnalyserViewSavedReports => 'Ver relatórios salvos';

  @override
  String get apkAnalyserClearHistory => 'Limpar histórico';

  @override
  String get apkAnalyserReportHistoryCleared => 'Histórico de relatórios limpo';

  @override
  String get apkAnalyserSavedReports => 'Relatórios salvos';

  @override
  String get apkAnalyserNoSavedReportsFound =>
      'Nenhum relatório salvo encontrado.';

  @override
  String get apkAnalyserChooseTarget => 'Escolher alvo';

  @override
  String get apkAnalyserSelectASourceToAnalyseWithVTTI =>
      'Selecione uma fonte para analisar com o VTTI Cloud.';

  @override
  String get apkAnalyserApkFile => 'Arquivo APK';

  @override
  String get apkAnalyserPickAnApkFromStorage =>
      'Escolha um arquivo .apk do armazenamento';

  @override
  String get apkAnalyserInstalledApp => 'App instalado';

  @override
  String get apkAnalyserChooseFromAppsOnThisDevice =>
      'Escolha entre os apps deste dispositivo';

  @override
  String apkAnalyserAnalysingIn(Object countdown) {
    return 'Analisando em $countdown...';
  }

  @override
  String get apkAnalyserStartingAnalysis => 'Iniciando análise...';

  @override
  String get apkAnalyserApkFileOrInstalledApp => 'Arquivo APK ou app instalado';

  @override
  String get apkAnalyserDeepAnalysisMode => 'Modo de análise profunda';

  @override
  String get apkAnalyserAMoreComplexAnalysisUsingGlobalData =>
      'Uma análise mais complexa usando fontes de dados globais';

  @override
  String get apkAnalyserRequiresProToUnlockDeeperAnalysis =>
      'Requer Pro para desbloquear uma análise mais profunda';

  @override
  String get apkAnalyserApkAnalyser => 'Analisador de APK';

  @override
  String get apkAnalyserPleaseSignInViaSettingsToEnable =>
      'Entre pela tela de Configurações para ativar a Cloud Analysis.';

  @override
  String get apkAnalyserAdvancedOPTIONS => 'OPÇÕES AVANÇADAS';

  @override
  String apkAnalyserDailyLimit(Object remaining, Object limit) {
    return 'Limite diário: $remaining / $limit';
  }

  @override
  String get apkAnalyserDailyLimitDataUnavailable =>
      'Dados do limite diário indisponíveis';

  @override
  String get apkAnalyserPoweredByVTTICloud => 'Equipado com VTTI Cloud';

  @override
  String get apkAnalyserSearchApps => 'Pesquisar apps...';

  @override
  String get apkAnalyserFailedToLoadApps => 'Falha ao carregar apps.';

  @override
  String get apkAnalyserNoAppsFound => 'Nenhum app encontrado.';

  @override
  String get apkReportSummary => 'Resumo';

  @override
  String get apkReportPermissions => 'Permissões';

  @override
  String get apkReportExtraFlags => 'Sinalizadores extras';

  @override
  String get apkReportRiskSignals => 'Sinais de risco';

  @override
  String get apkReportSources => 'Fontes';

  @override
  String get apkReportMetadata => 'Metadados';

  @override
  String get apkReportCopyReport => 'Copiar relatório';

  @override
  String get apkReportReportCopiedToClipboard =>
      'Relatório copiado para a área de transferência';

  @override
  String get apkReportExportAsPDF => 'Exportar como PDF';

  @override
  String get apkReportFailedToExportPDF => 'Falha ao exportar PDF';

  @override
  String get apkReportExportAsCSV => 'Exportar como CSV';

  @override
  String get apkReportFailedToExportCSV => 'Falha ao exportar CSV';

  @override
  String get apkReportAnalysisReport => 'Relatório de análise';

  @override
  String get apkReportMalwareRisk => 'Risco de malware';

  @override
  String get apkReportNoSummaryGenerated => 'Nenhum resumo gerado.';

  @override
  String get apkReportNoRequestedPermissionsExtracted =>
      'Nenhuma permissão solicitada foi extraída.';

  @override
  String get apkReportContributing => 'Contribuintes';

  @override
  String get apkReportDampening => 'Atenuantes';

  @override
  String get bootOptimisingYourProtection => 'Otimizando sua proteção';

  @override
  String get exclusionsFolders => 'Pastas';

  @override
  String get exclusionsNone => 'Nenhum';

  @override
  String get exclusionsFiles => 'Arquivos';

  @override
  String get exploreApkAnalyser => 'Analisador de APK';

  @override
  String get exploreCreateADetailedAnalysisOnAnyAPK =>
      'Crie uma análise detalhada de qualquer APK';

  @override
  String get featuresComingSoon => 'Em breve';

  @override
  String get featuresWantToLearnMore => 'Quer saber mais?';

  @override
  String get homeDrawerApkAnalyser => 'Analisador de APK';

  @override
  String get homeDrawerAdvanced => 'Avançado';

  @override
  String get homeDrawerQuarantine => 'Quarentena';

  @override
  String get homeDrawerUpgradeToPro => 'Fazer upgrade para Pro';

  @override
  String get homeDrawerAvarionxVPN => 'AvarionX VPN';

  @override
  String get homeDrawerProtectYourInternetWithOurUnlimitedVPN =>
      'Proteja sua conexão com a internet usando nossa VPN ilimitada';

  @override
  String get deviceSecurityDeviceSecurity => 'Segurança do dispositivo';

  @override
  String get deviceSecurityDeviceHealthStatus =>
      'Status de segurança do dispositivo';

  @override
  String get deviceSecurityDeviceSecurityRecommendations =>
      'Recomendações de segurança do dispositivo';

  @override
  String get deviceSecurityStopIgnoring => 'Parar de ignorar';

  @override
  String get deviceSecurityIgnoreCheck => 'Ignorar verificação';

  @override
  String get deviceSecurityNoScreenLock => 'Sem bloqueio de tela';

  @override
  String get deviceSecurityAMissingSecureLockMakesLocalAccess =>
      'A ausência de um bloqueio seguro facilita o acesso físico ao dispositivo.';

  @override
  String get deviceSecurityRootShizukuActive => 'Root/Shizuku ativo';

  @override
  String get deviceSecurityRootOrShizukuCanGrantPowerfulDevice =>
      'Root ou Shizuku podem conceder controle avançado do dispositivo.';

  @override
  String get deviceSecurityDisabledAppVerification =>
      'Verificação de apps desativada';

  @override
  String get deviceSecurityAppVerificationHelpsDetectHarmfulInstalls =>
      'A verificação de apps ajuda a detectar instalações maliciosas.';

  @override
  String get deviceSecurityOldAndroidSecurityPatch =>
      'Patch de segurança do Android antigo';

  @override
  String get deviceSecurityOlderPatchLevelsMayLeaveKnownIssues =>
      'Níveis de patch antigos podem deixar problemas conhecidos sem correção.';

  @override
  String get deviceSecurityDeveloperModeOn => 'Modo desenvolvedor ativado';

  @override
  String get deviceSecurityDeveloperOptionsExposeAdvancedDeviceControls =>
      'As opções do desenvolvedor disponibilizam controles avançados do dispositivo.';

  @override
  String get deviceSecurityUsbDebuggingOn => 'Depuração USB ativada';

  @override
  String get deviceSecurityUsbDebuggingAllowsADBControlFromTrusted =>
      'A depuração USB permite controle via ADB por computadores confiáveis.';

  @override
  String get deviceSecurityUnknownSourcesAllowed =>
      'Fontes desconhecidas permitidas';

  @override
  String get deviceSecuritySideloadingCanBypassNormalAppStoreChecks =>
      'A instalação por sideload pode contornar as verificações normais da loja de apps.';

  @override
  String get deviceSecurityAccessibilityAbuseRisk =>
      'Risco de abuso de acessibilidade';

  @override
  String get deviceSecurityAccessibilityServicesCanReadAndControlScreen =>
      'Os serviços de acessibilidade podem ler e controlar ações na tela.';

  @override
  String get homeHelpImproveDetectionsForEverybody =>
      'Ajude a melhorar a detecção para todos';

  @override
  String get homeApkSAndroidAppsFoundToBe =>
      'APKs (apps Android) identificados como maliciosos ';

  @override
  String get homeCanBeUploadedTo => 'podem ser enviados para ';

  @override
  String get homeAndSharedWithTheCommunityThisIs =>
      ' e compartilhados com a comunidade. Isso é ';

  @override
  String get homeStrictlyLimitedToAPKFilesNOTYour =>
      'estritamente limitado a arquivos APK, NÃO aos seus ';

  @override
  String get homeDocuments => 'documentos pessoais.\n\n';

  @override
  String get homeThisWillImproveDetectionsForEveryoneThat =>
      'Isso ajudará a melhorar a detecção para todos que ';

  @override
  String get homeUsesAvarionXNoPressureThough =>
      'usam o AvarionX. Mas sem pressão!\n\n';

  @override
  String get homeThanks => 'Obrigado,\n';

  @override
  String get homeRyanfromcolourswift => 'RyanFromColourswift';

  @override
  String get homeSure => 'Claro!';

  @override
  String get homeNoThanks => 'Não, obrigado!';

  @override
  String get homePsstCustomiseItHere => 'Psst... personalize aqui';

  @override
  String get homeScanNow => 'Escanear agora';

  @override
  String get homeManuallyCheckYourDeviceForMalware =>
      'Verifique manualmente seu dispositivo em busca de malware';

  @override
  String get homeDeviceSecurity => 'Segurança do dispositivo';

  @override
  String get homeScanModes => 'Modos de varredura';

  @override
  String get homeCloudAssistedChecksEnabled =>
      'Verificações assistidas pela nuvem ativadas';

  @override
  String get homeLocalScanEngineOnly => 'Somente mecanismo de varredura local';

  @override
  String get homeProtectedByVXTITANIUM => 'Protegido por VX-TITANIUM';

  @override
  String get homeSecurityOverview => 'Visão geral de segurança';

  @override
  String get homeFilesChecked => 'Arquivos verificados';

  @override
  String get homeThreats => 'Ameaças';

  @override
  String get securityReportAvarionxSecurityReport =>
      'Relatório de segurança do Avarionx';

  @override
  String get securityReportSecurityReport => 'Relatório de segurança';

  @override
  String get securityReportManualScans => 'Varreduras manuais';

  @override
  String get securityReportRealtimeChecks => 'Verificações em tempo real';

  @override
  String get securityReportTotalFilesScanned => 'Total de arquivos verificados';

  @override
  String get securityReportThreatsFound => 'Ameaças encontradas';

  @override
  String get securityReportGenerateReport => 'Gerar relatório';

  @override
  String get securityReportLiveReport => 'Relatório em tempo real';

  @override
  String get securityReportThisBoxUpdatesAsScanServicesWrite =>
      'Esta caixa é atualizada conforme os serviços de varredura gravam os dados do relatório.';

  @override
  String get securityReportExportPDF => 'Exportar PDF';

  @override
  String get securityReportExportCSV => 'Exportar CSV';

  @override
  String get homeLegacyProActivated => 'Pro ativado';

  @override
  String get homeLegacyProDeactivated => 'Pro desativado';

  @override
  String get linkCheckPoweredByVTTICloud => 'Equipado com VTTI Cloud';

  @override
  String get safeViewSafeView => 'Safe View';

  @override
  String get passwordSettingsChangingThisAltersAllPasswords =>
      'Alterar isso muda todas as senhas.\n';

  @override
  String get passwordSettingsUsingTheSameMetaPassRestoresThem =>
      'Usar o mesmo MetaPass as restaura.';

  @override
  String get passwordSettingsPasswordsAreNeverStored =>
      'As senhas nunca são armazenadas.\n\n';

  @override
  String get passwordSettingsTheRestoreCodeContainsOnlyStructureData =>
      'O código de restauração contém apenas dados de estrutura. ';

  @override
  String get passwordSettingsCombinedWithYourMetaPassItRebuildsYour =>
      'Combinado com seu MetaPass, ele reconstrói seu cofre.';

  @override
  String get passwordManagerContinue => 'Continuar';

  @override
  String passwordManagerFailedToLoadApps(Object e) {
    return 'Falha ao carregar apps: $e';
  }

  @override
  String passwordManagerFailedToGeneratePassword(Object e) {
    return 'Falha ao gerar senha: $e';
  }

  @override
  String get passwordManagerPasswordsAreNeverStored =>
      'As senhas nunca são armazenadas.\n\n';

  @override
  String get passwordManagerEachEntryDerivesAPasswordFrom =>
      'Cada entrada deriva uma senha de:\n';

  @override
  String get passwordManagerYourMetaPassword => '• Sua senha meta\n';

  @override
  String get passwordManagerTheLabelName => '• O nome da etiqueta\n';

  @override
  String get passwordManagerTheVersionAndLength => '• A versão e o tamanho\n\n';

  @override
  String get passwordManagerReinstallingTheAppWithTheSameMeta =>
      'Reinstalar o app com a mesma senha meta e as mesmas etiquetas gera novamente as mesmas senhas.';

  @override
  String get permissionsIntroSetupIsNowCompleteTimeToSecure =>
      'A configuração está concluída! Hora de proteger seus dados.';

  @override
  String get proScreenThankYou => 'Obrigado';

  @override
  String get proScreenYourSubscriptionIsConfirmed =>
      'Sua assinatura foi confirmada.';

  @override
  String get proScreenCurrent => 'Atual';

  @override
  String get proScreenAdvancedStealthMode => 'Modo Stealth+ avançado';

  @override
  String get proScreenUnlockStealthTransportModesForRestrictiveNetworks =>
      'Desbloqueie modos de transporte furtivos para redes restritivas.';

  @override
  String get proScreenGlobalServerAccess => 'Acesso global a servidores';

  @override
  String get proScreenAccessEveryVPNServerLocationIncludingPremium =>
      'Acesse todas as localizações de servidores VPN, incluindo regiões premium de alta velocidade.';

  @override
  String get proScreenBilledMonthly => 'Cobrado mensalmente';

  @override
  String proScreenMo(Object monthlyInfo) {
    return '$monthlyInfo/mês';
  }

  @override
  String proScreenMo2(Object currencyCode) {
    return '$currencyCode/mês';
  }

  @override
  String get proScreenCurrentPlan => 'Plano atual';

  @override
  String get quarantineScreenQuarantineDataCorruptedResetting =>
      'Dados da quarentena corrompidos. Redefinindo.';

  @override
  String get quarantineScreenUninstallApp => 'Desinstalar app';

  @override
  String quarantineScreenUninstall(Object appName) {
    return 'Desinstalar $appName?';
  }

  @override
  String get quarantineScreenUninstall2 => 'Desinstalar';

  @override
  String get quarantineScreenFailedToLaunchUninstall =>
      'Falha ao iniciar a desinstalação';

  @override
  String get quarantineScreenFiles => 'Arquivos';

  @override
  String get cleanerAppManagerShizukuNotAvailable => 'Shizuku indisponível';

  @override
  String get cleanerAppManagerWithoutShizukuEachAppRequiresASeparate =>
      'Sem o Shizuku, cada app exige uma confirmação separada do sistema. Continuar?';

  @override
  String cleanerAppManagerAppsUninstalled(Object successCount) {
    return '$successCount apps desinstalados';
  }

  @override
  String cleanerAppManagerUninstalledFailed(
      Object successCount, Object failedCount) {
    return '$successCount desinstalados, $failedCount falharam';
  }

  @override
  String cleanerAppManagerStopped(Object appName) {
    return '$appName interrompido';
  }

  @override
  String get cleanerAppManagerForceStopFailed => 'Falha ao forçar parada';

  @override
  String get cleanerAppManagerClearAppData => 'Limpar dados do app';

  @override
  String cleanerAppManagerResetThisClearsItsAccountsSettingsFiles(
      Object appName) {
    return 'Redefinir $appName? Isso limpa suas contas, configurações, arquivos e cache.';
  }

  @override
  String get cleanerAppManagerClearData => 'Limpar dados';

  @override
  String cleanerAppManagerReset(Object appName) {
    return '$appName redefinido';
  }

  @override
  String get cleanerAppManagerClearDataFailed => 'Falha ao limpar dados';

  @override
  String get cleanerAppManagerOpenApp => 'Abrir app';

  @override
  String get cleanerAppManagerForceStop => 'Forçar parada';

  @override
  String get cleanerAppManagerUninstall => 'Desinstalar';

  @override
  String cleanerAppManagerSelected(Object selectedCount) {
    return '$selectedCount selecionados';
  }

  @override
  String get cleanerAppManagerAppManager => 'Gerenciador de apps';

  @override
  String get cleanerAppManagerDeselectAll => 'Desmarcar tudo';

  @override
  String cleanerAppManagerUninstalling(Object done, Object total) {
    return 'Desinstalando $done / $total…';
  }

  @override
  String cleanerAppManagerUninstall2(Object selectedCount) {
    return 'Desinstalar $selectedCount';
  }

  @override
  String get cleanerProClearAppCaches => 'Limpar caches de apps';

  @override
  String get cleanerProThisAsksAndroidToTrimAppCaches =>
      'Isso solicita ao Android que reduza os caches dos apps em todo o dispositivo. Dados de apps, contas e configurações não são apagados.';

  @override
  String get cleanerProClearCaches => 'Limpar caches';

  @override
  String get cleanerProCacheTrimRequested => 'Redução de cache solicitada';

  @override
  String get cleanerProCacheCleanerFailed => 'Falha na limpeza de cache';

  @override
  String get cleanerProLogFiles => 'Arquivos de log';

  @override
  String get cleanerProCacheCleaner => 'Limpador de cache';

  @override
  String get cleanerProLogCleaner => 'Limpador de logs';

  @override
  String get cleanerProAppDataManager => 'Gerenciador de dados de apps';

  @override
  String get cleanerScreenCleaner => 'Limpador';

  @override
  String get scanDetailDeleteFiles => 'Excluir arquivos';

  @override
  String scanDetailDeleteFilesPermanently(Object selectedCount) {
    return 'Excluir permanentemente $selectedCount arquivos?';
  }

  @override
  String get scanDetailSelectedFilesDeleted =>
      'Arquivos selecionados excluídos';

  @override
  String get scanDetailDeleteAllFiles => 'Excluir todos os arquivos';

  @override
  String scanDetailDeleteAllFilesPermanently(Object fileCount) {
    return 'Excluir permanentemente todos os $fileCount arquivos?';
  }

  @override
  String get scanDetailDeleteAll => 'Excluir tudo';

  @override
  String get scanDetailAllFilesDeleted => 'Todos os arquivos excluídos';

  @override
  String scanDetailSelected(Object selectedCount) {
    return '$selectedCount selecionados';
  }

  @override
  String get scanDetailDeselectAll => 'Desmarcar tudo';

  @override
  String get scanDetailNewestFirst => 'Mais recentes primeiro';

  @override
  String get scanDetailOldestFirst => 'Mais antigos primeiro';

  @override
  String get scanDetailLargestFirst => 'Maiores primeiro';

  @override
  String get scanDetailSmallestFirst => 'Menores primeiro';

  @override
  String get scanDetailNoFilesFound => 'Nenhum arquivo encontrado';

  @override
  String get scanDetailDeleteAll2 => 'Excluir tudo';

  @override
  String get scanInstalledAppsSearchApps => 'Pesquisar apps...';

  @override
  String get scanInstalledAppsNoAppsFound => 'Nenhum app encontrado.';

  @override
  String get scanUiScanComplete => 'Varredura concluída';

  @override
  String scanUiScannedItems(Object scanned) {
    return 'Verificados: $scanned itens';
  }

  @override
  String scanUiProgress(Object pct, Object scanned, Object total) {
    return 'Progresso: $pct ($scanned / $total)';
  }

  @override
  String get scanUiPreparingEngine => 'Preparando mecanismo...';

  @override
  String get scanUiLoadingTargetS => 'Carregando alvo(s)';

  @override
  String get scanUiAvarionxVPN => 'AvarionX VPN';

  @override
  String get scanUiProtectYourInternetWithOurUnlimitedVPN =>
      'Proteja sua conexão com a internet usando nossa VPN ilimitada';

  @override
  String get scanUiTapMe => 'Toque aqui!';

  @override
  String scanUiScanned(Object scanned) {
    return '$scanned verificados';
  }

  @override
  String get scanUiReturn => 'Voltar';

  @override
  String get scanLimitsSettingsUpdated => 'Configurações atualizadas';

  @override
  String get scanLimitsScanLimits => 'Limites de varredura';

  @override
  String get scanLimitsLimitHowMuchTheEngineUsesYour =>
      'Limite quanto o mecanismo usa sua CPU. Threads: 0 significa automático.';

  @override
  String get scanLimitsMaxScanThreads => 'Máximo de threads de varredura';

  @override
  String scanLimits0AutoRange0ToCores(Object maxThreads, Object coreCount) {
    return '0 = automático. Intervalo: 0 a $maxThreads (núcleos: $coreCount).';
  }

  @override
  String scanLegacyScanning(Object percent) {
    return 'Escaneando... $percent%';
  }

  @override
  String scanLegacySuspicious(Object infectedCount) {
    return 'Suspeitos: $infectedCount';
  }

  @override
  String scanLegacyClean(Object cleanCount) {
    return 'Limpos: $cleanCount';
  }

  @override
  String get scanLegacyNoFilesToScan => 'Nenhum arquivo para escanear';

  @override
  String get settingsSponsorsUnlock => 'Patrocinadores desbloqueiam ❤️';

  @override
  String get settingsPickCertificate => 'Escolher certificado';

  @override
  String get settingsCertificateLoaded => 'Certificado carregado';

  @override
  String get settingsEnterCode => 'digite o código';

  @override
  String get settingsSupportFileMissing => 'Arquivo de suporte ausente';

  @override
  String get settingsInvalidSupportCode => 'Código de suporte inválido';

  @override
  String get settingsAvarionxSecurity => 'AvarionX Security';

  @override
  String get settingsAvarionxIsAMobileSecuritySuiteCreated =>
      'O AvarionX é uma suíte de segurança móvel criada pela ColourSwift, com sede em Birmingham, Reino Unido.\n\n';

  @override
  String get settingsContact => 'Contato: ';

  @override
  String get settingsExperimentalFeatures => 'Recursos experimentais';

  @override
  String get settingsEnablingShizukuUnlocksExperimentalWorkInProgress =>
      'Ativar o Shizuku desbloqueia recursos experimentais ainda em desenvolvimento:\n\n';

  @override
  String get settingsAdvancedRansomwareProtection =>
      '• Proteção avançada contra ransomware\n';

  @override
  String get settingsCacheCleanerPlus => '• Cache Cleaner Plus\n\n';

  @override
  String get settingsExperimentalWarning => 'Aviso experimental:\n';

  @override
  String get settingsTheseFeaturesUseAdvancedSystemAccessAnd =>
      'Esses recursos usam acesso avançado ao sistema e podem se comportar de forma diferente entre dispositivos, versões do Android e configurações do Shizuku. Algumas ações podem afetar apps em execução, arquivos ou dados de cache de forma mais direta do que uma varredura normal.\n\n';

  @override
  String get settingsOnlyEnableThisIfYouUnderstandShizuku =>
      'Ative isso apenas se você entender o Shizuku, aceitar que o recurso ainda está em testes e tiver feito backup de tudo que for importante.\n\n';

  @override
  String get settingsPleaseReadTheDocumentationBeforeEnabling =>
      'Leia a documentação antes de ativar.';

  @override
  String get settingsEnable => 'Ativar';

  @override
  String get settingsSigningOut => 'Saindo...';

  @override
  String get settingsCheckingAccountStatus => 'Verificando status da conta...';

  @override
  String get settingsManageSignInPremiumAndPurchases =>
      'Gerenciar login, Premium e compras';

  @override
  String get settingsPremiumActive => 'Premium ativo';

  @override
  String get settingsManagePremiumOptionsAndRestorePurchases =>
      'Gerenciar opções Premium e restaurar compras';

  @override
  String get settingsUnlockDeepAnalysisModeAndVPNFeatures =>
      'Desbloqueie o modo de análise profunda e os recursos de VPN';

  @override
  String get settingsAutoClearNotifications =>
      'Limpar notificações automaticamente';

  @override
  String get settingsScanModes => 'Modos de varredura';

  @override
  String get settingsAdvancedScanModes => 'Modos de varredura avançados';

  @override
  String get settingsDisableToUseTheDefaultScanningMode =>
      'Desative para usar o modo de varredura padrão';

  @override
  String get settingsToggleToEnableAllScanningModes =>
      'Ative para habilitar todos os modos de varredura';

  @override
  String get settingsApkSubmissions => 'Envios de APK';

  @override
  String get settingsShareMaliciousAPKs => 'Compartilhar APKs maliciosos';

  @override
  String get settingsHelpingImproveDetectionForEveryone =>
      'Ajudando a melhorar a detecção para todos';

  @override
  String get settingsOff => 'Desativado';

  @override
  String get settingsIncludeRealtimeProtectionCatches =>
      'Incluir detecções da Proteção em Tempo Real';

  @override
  String get settingsApksFlaggedByRealtimeProtectionAreIncluded =>
      'APKs sinalizados pela Proteção em Tempo Real são incluídos';

  @override
  String get settingsApksFlaggedByRealtimeProtectionAreExcluded =>
      'APKs sinalizados pela Proteção em Tempo Real são excluídos';

  @override
  String get settingsIncludeManualAndScheduledScans =>
      'Incluir varreduras manuais e agendadas';

  @override
  String get settingsApksFlaggedByScansAreIncluded =>
      'APKs sinalizados por varreduras são incluídos';

  @override
  String get settingsApksFlaggedByScansAreExcluded =>
      'APKs sinalizados por varreduras são excluídos';

  @override
  String get settingsWiFiOnly => 'Somente Wi-Fi';

  @override
  String get settingsUploadsWaitForAWiFiConnection =>
      'Os envios aguardam uma conexão Wi-Fi';

  @override
  String get settingsUploadsMayUseMobileData =>
      'Os envios podem usar dados móveis';

  @override
  String get settingsChargingOnly => 'Somente carregando';

  @override
  String get settingsUploadsWaitUntilTheDeviceIsCharging =>
      'Os envios aguardam até o dispositivo estar carregando';

  @override
  String get settingsUploadsAreNotLimitedToCharging =>
      'Os envios não são limitados ao carregamento';

  @override
  String get settingsChooseWhichAppsUpload =>
      'Escolher quais apps serão enviados';

  @override
  String get settingsReviewAndPickAppsEachTimeBefore =>
      'Revisar e escolher apps antes de cada envio';

  @override
  String get settingsFlaggedAppsUploadAutomatically =>
      'Apps sinalizados são enviados automaticamente';

  @override
  String get settingsEnableProDebug => 'Ativar Pro (depuração)';

  @override
  String get settingsLocalUnlockForUITesting =>
      'Desbloqueio local para testes de interface';

  @override
  String get settingsRestorePurchases => 'Restaurar compras';

  @override
  String get settingsReCheckPlayBilling => 'Verificar Play Billing novamente';

  @override
  String get settingsCheckingAccount => 'Verificando conta...';

  @override
  String get settingsAvarionxAccountConnected => 'Conta AvarionX conectada';

  @override
  String settingsAccountID(Object accountId) {
    return 'ID da conta: $accountId';
  }

  @override
  String get settingsSignInToManagePurchasesAndAccount =>
      'Entre para gerenciar compras e recursos da conta.';

  @override
  String get settingsOpenTheAvarionXAccountPortal =>
      'Abrir o portal da conta AvarionX';

  @override
  String get settingsAccountDashboard => 'Painel da conta';

  @override
  String get settingsOpenBillingAndAccountSettings =>
      'Abrir configurações de cobrança e conta';

  @override
  String get settingsRemoveThisAccountFromTheApp => 'Remover esta conta do app';

  @override
  String get settingsPremiumFeaturesAreAvailableOnThisDevice =>
      'Os recursos Premium estão disponíveis neste dispositivo';

  @override
  String get settingsViewOptionalPremiumFeatures =>
      'Ver recursos Premium opcionais';

  @override
  String get settingsReCheckPlayBillingEntitlement =>
      'Verificar novamente o direito no Play Billing';

  @override
  String get settingsRtpNotificationAutoClearNotifications =>
      'Limpar notificações automaticamente';

  @override
  String get settingsRtpNotificationNever => 'Nunca';

  @override
  String get settingsRtpNotification5Minutes => '5 minutos';

  @override
  String get settingsRtpNotification10Minutes => '10 minutos';

  @override
  String get settingsRtpNotification30Minutes => '30 minutos';

  @override
  String get settingsThemeBlack => 'Preto';

  @override
  String get settingsThemeWhite => 'Branco';

  @override
  String get settingsThemeGrey => 'Cinza';

  @override
  String get settingsThemeEmerald => 'Esmeralda';

  @override
  String get settingsThemePurple => 'Roxo';

  @override
  String get settingsThemeRoyalBlue => 'Azul royal';

  @override
  String get settingsAccountCardSyncPurchasesAndUnlockProAcrossApps =>
      'Sincronize compras e desbloqueie o Pro entre os apps.';

  @override
  String get settingsAccountCardLoading => 'Carregando...';

  @override
  String get settingsAccountCardDashboard => 'Painel';

  @override
  String get settingsProCardChangePlan => 'Trocar plano';

  @override
  String get advancedNetworkProtectionEnterYourOwnResolver =>
      'Digite seu próprio resolvedor';

  @override
  String get advancedNetworkProtectionCloudProtectionMode =>
      'Modo de proteção na nuvem';

  @override
  String get advancedNetworkProtectionRoutesAllDNSQueriesToTheCloud =>
      'Roteia todas as consultas DNS para o mecanismo na nuvem, permitindo atualizações de listas de bloqueio em tempo real, verificação da reputação de domínios e muito mais.';

  @override
  String get advancedNetworkProtectionRefreshProStatus =>
      'Atualizar status do Pro';

  @override
  String get advancedNetworkProtectionProActive => 'Pro ativo';

  @override
  String get advancedNetworkProtectionFreePlan => 'Plano gratuito';

  @override
  String get advancedNetworkProtectionChecksYourEntitlementAndSyncsItWith =>
      'Verifica seu direito e o sincroniza com os recursos da nuvem. O Pro desbloqueia o bloqueio de anúncios em todo o sistema.';

  @override
  String get advancedNetworkProtectionMalwareProtection =>
      'Proteção contra malware';

  @override
  String get advancedNetworkProtectionBlocksKnownMaliciousDomains =>
      'Bloqueia domínios maliciosos conhecidos';

  @override
  String get advancedNetworkProtectionTrackerProtection =>
      'Proteção contra rastreadores';

  @override
  String get advancedNetworkProtectionReducesTrackingDomains =>
      'Reduz domínios de rastreamento';

  @override
  String get advancedNetworkProtectionAdProtection =>
      'Proteção contra anúncios';

  @override
  String get advancedNetworkProtectionBlocksCommonAdDomains =>
      'Bloqueia domínios comuns de anúncios';

  @override
  String get advancedNetworkProtectionAdultFilter =>
      'Filtro de conteúdo adulto';

  @override
  String get advancedNetworkProtectionUses1113Upstream =>
      'Usa 1.1.1.3 como upstream';

  @override
  String get advancedNetworkProtectionLockedUntilProIsActiveAndCloud =>
      'Bloqueado até o Pro estar ativo e o modo na nuvem estar habilitado.';

  @override
  String get advancedNetworkProtectionLiveDNSEventsFromTheVPNLayer =>
      'Eventos DNS em tempo real da camada VPN.';

  @override
  String get advancedNetworkProtectionAdvanced => 'Avançado';

  @override
  String get advancedNetworkProtectionDns => 'DNS';

  @override
  String get advancedNetworkProtectionCloudDNSMode => 'Modo DNS na nuvem';

  @override
  String get networkProtectionEnterYourOwnResolver =>
      'Digite seu próprio resolvedor';

  @override
  String get networkAppControlEnableVPNToggles => 'Ativar controles de VPN';

  @override
  String get networkAppControlOpenSettings => 'Abrir configurações';

  @override
  String get networkAppControlAppControl => 'Controle de apps';

  @override
  String get networkAppControlNoAppsFound => 'Nenhum app encontrado.';

  @override
  String get networkSpeedTestCountry => 'País';

  @override
  String get networkSpeedTestRunning => 'Em execução';

  @override
  String get networkSpeedTestRunTest => 'Executar teste';

  @override
  String get networkSpeedTestNoResultsYet => 'Nenhum resultado ainda.';

  @override
  String networkSpeedTestDnsTLS(Object dns, Object tls) {
    return 'DNS: $dns  •  TLS: $tls';
  }

  @override
  String get networkSpeedTestFail => 'Falha';

  @override
  String get dnsNetworkProtectionEnterYourOwnResolver =>
      'Digite seu próprio resolvedor';

  @override
  String get dnsNetworkProtectionDnsFilteringIsSeperateFromTheSecure =>
      'A filtragem DNS é separada da Secure VPN. Ela pode bloquear malware conhecido, anúncios (em todos os apps), rastreadores e conteúdo de categorias indesejadas antes que sejam carregados.';

  @override
  String get fullVpnSignedIn => 'Conectado à conta.';

  @override
  String get fullVpnSignInRequired => 'Login necessário';

  @override
  String get fullVpnClose => 'Fechar';

  @override
  String get fullVpnLoadingUsage => 'Carregando uso...';

  @override
  String get fullVpnSyncing => 'Sincronizando';

  @override
  String fullVpnUsedThisMonth(Object usedBytes) {
    return '$usedBytes usados este mês';
  }

  @override
  String get blockedScreenUnsupportedEnvironment => 'Ambiente não compatível';

  @override
  String updateLogUpdateV(Object version) {
    return 'Atualização: v$version';
  }

  @override
  String get updateLogHiThereAvarionXHasBeenUpdatedBelow =>
      'Olá! O AvarionX foi atualizado. Veja abaixo as mudanças:';

  @override
  String get updateLogNoUserFacingChangesInThisUpdate =>
      'Esta atualização não possui mudanças visíveis para o usuário.';

  @override
  String get updateLogContinue => 'Continuar';

  @override
  String get featuresRealtimeProtectionBody =>
      'Monitora arquivos novos e modificados em segundo plano e bloqueia ameaças assim que aparecem.';

  @override
  String get featuresTriLayerEngineTitle => 'Mecanismo de três camadas';

  @override
  String get featuresTriLayerEngineBody =>
      'Um núcleo de detecção em três etapas que combina filtragem Bloom, varredura por assinaturas e análise de bytes focada em APK para alta precisão e velocidade.';

  @override
  String get featuresMachineLearningTitle => 'Aprendizado de máquina';

  @override
  String get featuresMachineLearningBody =>
      'Um modelo leve no dispositivo treinado para reconhecer padrões de comportamento malicioso em APKs.';

  @override
  String get featuresCleanerProTitle => 'Cleaner Pro';

  @override
  String get featuresCleanerProBody =>
      'Um módulo de limpeza em evolução que identifica duplicatas, cache e apps não usados para recuperar espaço de armazenamento.';

  @override
  String get featuresWifiProtectionTitle => 'Proteção Wi-Fi';

  @override
  String get featuresWifiProtectionBody =>
      'Detecta redes Wi-Fi inseguras ou suspeitas usando análise no dispositivo.';

  @override
  String get featuresRootLevelProtectionTitle => 'Proteção em nível root';

  @override
  String get featuresRootLevelProtectionBody =>
      'Defesa profunda em nível de sistema projetada para dispositivos com root e usuários avançados.';

  @override
  String get featuresPcCompanionTitle => 'Companion para PC';

  @override
  String get featuresPcCompanionBody =>
      'Próxima versão para desktop com integração antivírus entre plataformas.';

  @override
  String get deviceSecurityNoRisksFound =>
      'Nenhum risco no dispositivo encontrado';

  @override
  String get deviceSecurityOneCheckNeedsAttention =>
      '1 verificação do dispositivo precisa de atenção';

  @override
  String deviceSecurityChecksNeedAttention(Object count) {
    return '$count verificações do dispositivo precisam de atenção';
  }

  @override
  String get deviceSecurityHealthSectionBody =>
      'Essas configurações afetam diretamente a postura de segurança do seu dispositivo.';

  @override
  String get deviceSecurityRecommendationsSectionBody =>
      'Essas configurações são boas práticas comuns de segurança.';

  @override
  String get deviceSecuritySignalUnavailable => 'Sinal indisponível';

  @override
  String get deviceSecurityIgnoredByYou => 'Ignorado por você';

  @override
  String get deviceSecurityScreenLockInactiveTitle => 'Bloqueio de tela';

  @override
  String get deviceSecurityScreenLockActiveLabel =>
      'Inseguro: nenhum bloqueio de tela seguro está configurado';

  @override
  String get deviceSecurityScreenLockInactiveLabel =>
      'O bloqueio de tela está ativo';

  @override
  String get deviceSecurityScreenLockDetail =>
      'Um bloqueio de tela seguro protege seu dispositivo se ele for perdido, roubado ou deixado sem supervisão. Sem PIN, senha, padrão, impressão digital ou desbloqueio facial respaldado por um método de bloqueio seguro, qualquer pessoa com acesso físico pode abrir o dispositivo com mais facilidade.';

  @override
  String get deviceSecurityScreenLockHelp =>
      'Abra as configurações de segurança do Android e defina um bloqueio de tela seguro.';

  @override
  String get deviceSecurityCheckSetting => 'Verificar configuração';

  @override
  String get deviceSecurityPrivilegedInactiveTitle => 'Sem acesso privilegiado';

  @override
  String get deviceSecurityPrivilegedActiveLabel =>
      'Acesso privilegiado detectado';

  @override
  String get deviceSecurityPrivilegedInactiveLabel =>
      'Nenhum acesso privilegiado detectado';

  @override
  String get deviceSecurityPrivilegedDetail =>
      'Root e Shizuku podem ser úteis, mas também aumentam o impacto de um app malicioso se o acesso for abusado. Apps com acesso privilegiado podem executar ações que apps Android comuns não conseguem.';

  @override
  String get deviceSecurityPrivilegedHelp =>
      'Revise manualmente suas configurações de root, Magisk ou Shizuku.';

  @override
  String get deviceSecurityReviewSetting => 'Revisar configuração';

  @override
  String get deviceSecurityAppVerificationInactiveTitle =>
      'Verificação de apps';

  @override
  String get deviceSecurityAppVerificationActiveLabel =>
      'Inseguro: a verificação de apps parece estar desativada';

  @override
  String get deviceSecurityAppVerificationInactiveLabel =>
      'A verificação de apps parece estar ativada';

  @override
  String get deviceSecurityAppVerificationDetail =>
      'A verificação de apps do Android ajuda a checar apps antes ou depois da instalação. Se essa proteção estiver desativada ou indisponível, apps nocivos podem ter menos chances de serem bloqueados antes de executar.';

  @override
  String get deviceSecurityAppVerificationHelp =>
      'Abra as configurações de segurança do Android e revise a verificação de apps.';

  @override
  String get deviceSecuritySecurityPatchInactiveTitle =>
      'Patch de segurança atualizado';

  @override
  String get deviceSecuritySecurityPatchActiveLabel =>
      'O nível do patch de segurança está desatualizado';

  @override
  String get deviceSecuritySecurityPatchInactiveLabel =>
      'O nível do patch de segurança está atualizado';

  @override
  String get deviceSecuritySecurityPatchDetail =>
      'Os patches de segurança do Android corrigem problemas conhecidos da plataforma e dos fabricantes. Se o nível do patch for antigo, o dispositivo pode ficar exposto a vulnerabilidades que já foram corrigidas em versões mais recentes.';

  @override
  String get deviceSecuritySecurityPatchHelp =>
      'Abra as configurações de atualização do sistema Android e procure atualizações.';

  @override
  String get deviceSecurityCheckUpdates => 'Verificar atualizações';

  @override
  String get deviceSecurityDeveloperModeInactiveTitle => 'Modo desenvolvedor';

  @override
  String get deviceSecurityDeveloperModeActiveLabel =>
      'As opções do desenvolvedor estão ativadas';

  @override
  String get deviceSecurityDeveloperModeInactiveLabel =>
      'As opções do desenvolvedor estão desativadas';

  @override
  String get deviceSecurityDeveloperModeDetail =>
      'O Modo desenvolvedor é normal para desenvolvedores e testadores, mas expõe configurações avançadas que podem reduzir a segurança do dispositivo se forem alteradas por acidente ou usadas de forma abusiva por alguém com acesso ao aparelho.';

  @override
  String get deviceSecurityDeveloperModeHelp =>
      'Abra as Opções do desenvolvedor e desative as configurações que você não precisa.';

  @override
  String get deviceSecurityUsbDebuggingInactiveTitle => 'Depuração USB';

  @override
  String get deviceSecurityUsbDebuggingActiveLabel =>
      'Inseguro: a depuração USB está ativada';

  @override
  String get deviceSecurityUsbDebuggingInactiveLabel =>
      'A depuração USB está desativada';

  @override
  String get deviceSecurityUsbDebuggingDetail =>
      'A depuração USB permite que um computador conectado interaja com seu dispositivo por meio do Android Debug Bridge. Se ficar ativada, aumenta o risco de acesso não autorizado ao conectar o dispositivo a uma máquina não confiável.';

  @override
  String get deviceSecurityUsbDebuggingHelp =>
      'Abra as Opções do desenvolvedor e desative a depuração USB.';

  @override
  String get deviceSecurityUnknownSourcesInactiveTitle =>
      'Fontes desconhecidas';

  @override
  String get deviceSecurityUnknownSourcesActiveLabel =>
      'A instalação de apps desconhecidos é permitida';

  @override
  String get deviceSecurityUnknownSourcesInactiveLabel =>
      'A instalação de apps desconhecidos é restrita';

  @override
  String get deviceSecurityUnknownSourcesDetail =>
      'Permitir a instalação de apps desconhecidos pode ser útil para APKs confiáveis, mas também aumenta a chance de instalar apps de fontes inseguras. Permita isso apenas para apps e lojas em que você confia.';

  @override
  String get deviceSecurityUnknownSourcesHelp =>
      'Abra as configurações do Android e revise o acesso para instalar apps desconhecidos.';

  @override
  String get deviceSecurityAccessibilityInactiveTitle =>
      'Serviços de acessibilidade';

  @override
  String get deviceSecurityAccessibilityActiveLabel =>
      'Serviço de acessibilidade de terceiros ativado';

  @override
  String get deviceSecurityAccessibilityInactiveLabel =>
      'Nenhum serviço de acessibilidade de risco encontrado';

  @override
  String get deviceSecurityAccessibilityDetail =>
      'Os serviços de acessibilidade são poderosos porque podem observar o conteúdo da tela e executar ações em nome do usuário. Isso é útil para ferramentas legítimas, mas também é frequentemente abusado por apps maliciosos.';

  @override
  String get deviceSecurityAccessibilityHelp =>
      'Abra as configurações de Acessibilidade e revise os serviços ativados.';

  @override
  String get deviceSecurityChecking => 'Verificando a segurança do dispositivo';

  @override
  String get deviceSecurityReadingSignals =>
      'Lendo sinais de postura do dispositivo...';

  @override
  String get deviceSecurityOneCheckAttention =>
      '1 verificação precisa de atenção';

  @override
  String deviceSecurityChecksAttention(Object count) {
    return '$count verificações precisam de atenção';
  }

  @override
  String get deviceSecurityTapSignal =>
      'Toque em um sinal abaixo para saber mais.';

  @override
  String deviceSecurityIgnoredChecks(Object count, String plural) {
    String _temp0 = intl.Intl.selectLogic(
      plural,
      {
        's': '',
        'other': '',
      },
    );
    return 'Verificações ativas ignoradas: $count.$_temp0';
  }

  @override
  String get deviceSecurityPostureNormal =>
      'As verificações de postura de segurança do seu dispositivo parecem normais.';

  @override
  String get timeJustNow => 'agora mesmo';

  @override
  String timeMinutesAgo(Object minutes) {
    return 'há $minutes min';
  }

  @override
  String timeHoursAgo(Object hours) {
    return 'há $hours h';
  }

  @override
  String timeDaysAgo(Object days) {
    return 'há $days d';
  }

  @override
  String get securityNoReportDataYet => 'Ainda não há dados do relatório';

  @override
  String securityLastActivity(Object relative) {
    return 'Última atividade $relative';
  }

  @override
  String get securityReportSharePdfTitle =>
      'Relatório de segurança do Avarionx';

  @override
  String get securityReportCsvField => 'Campo';

  @override
  String get securityReportCsvValue => 'Valor';

  @override
  String get securityReportGeneratedAt => 'Gerado em';

  @override
  String get securityReportOverallStatus => 'Status geral';

  @override
  String get securityReportLastManualScan => 'Última varredura manual';

  @override
  String get securityReportLastRealtimeEvent => 'Último evento em tempo real';

  @override
  String get securityReportLastScheduledScan => 'Última varredura agendada';

  @override
  String get securityReportShareCsvTitle =>
      'CSV do relatório de segurança do Avarionx';

  @override
  String get securityReportReviewRecommended => 'Revisão recomendada';

  @override
  String get securityReportNoKnownThreatDetected =>
      'Nenhuma ameaça conhecida detectada';

  @override
  String securityReportGeneratedLine(Object generatedAt) {
    return 'Gerado: $generatedAt';
  }

  @override
  String securityReportStatusLine(Object status) {
    return 'Status: $status';
  }

  @override
  String securityReportLatestActivityLine(Object latest) {
    return 'Última atividade: $latest';
  }

  @override
  String securityReportManualScansLine(Object count) {
    return 'Varreduras manuais: $count';
  }

  @override
  String securityReportRealtimeChecksLine(Object count) {
    return 'Verificações em tempo real: $count';
  }

  @override
  String securityReportTotalFilesScannedLine(Object count) {
    return 'Total de arquivos verificados: $count';
  }

  @override
  String securityReportThreatsFoundLine(Object count) {
    return 'Ameaças encontradas: $count';
  }

  @override
  String securityReportLastManualScanLine(Object value) {
    return 'Última varredura manual: $value';
  }

  @override
  String securityReportLastRealtimeEventLine(Object value) {
    return 'Último evento em tempo real: $value';
  }

  @override
  String securityReportLastScheduledScanLine(Object value) {
    return 'Última varredura agendada: $value';
  }

  @override
  String get securityReportNotRecorded => 'Não registrado';

  @override
  String get safeViewNavigationBlocked => 'Navegação bloqueada';

  @override
  String get safeViewInvalidDestination => 'Destino inválido';

  @override
  String get safeViewUnsupportedScheme => 'Esquema não compatível';

  @override
  String get safeViewUnableToResolveDestination =>
      'Não foi possível resolver o destino';

  @override
  String get safeViewDestinationBlocked => 'Destino bloqueado';

  @override
  String get safeViewUnableToVerifyDestination =>
      'Não foi possível verificar o destino';

  @override
  String proScreenCurrentStatus(Object status) {
    return 'Status atual: $status';
  }

  @override
  String proScreenBilledAnnuallyAt(Object price) {
    return 'Cobrado anualmente por $price';
  }

  @override
  String get quarantineUnknownApp => 'App desconhecido';

  @override
  String get cleanerScanCancelled => 'Varredura cancelada';

  @override
  String get cleanerProClearingCaches => 'Limpando caches…';

  @override
  String get cleanerProTrimAppCaches =>
      'Reduza os caches de apps em todo o dispositivo.';

  @override
  String get cleanerProEnableShizuku =>
      'Ative o Shizuku nas Configurações para usar isso.';

  @override
  String get cleanerProScanningStorage => 'Escaneando armazenamento…';

  @override
  String get cleanerProFindLogFiles =>
      'Encontre arquivos .log, .trace, .crash e .dmp.';

  @override
  String cleanerProLogFileCount(Object count, Object size) {
    return '$count arquivos • $size';
  }

  @override
  String get cleanerProAppManagerReady =>
      'Force a parada, limpe dados e desinstale apps em lote.';

  @override
  String get cleanerProAppManagerLimited =>
      'A desinstalação funciona normalmente. Forçar parada e limpar dados exigem Shizuku.';

  @override
  String get cleanerProCheckingShizuku => 'Verificando Shizuku…';

  @override
  String get cleanerProShizukuNotRunning =>
      'O Shizuku não está em execução. Ative-o nas Configurações quando necessário.';

  @override
  String get cleanerProShizukuPermissionMissing =>
      'A permissão do Shizuku não foi concedida. Ative-a nas Configurações.';

  @override
  String get cleanerProShizukuNotBound =>
      'O serviço Shizuku ainda não está vinculado. Abra as Configurações e atualize esta tela depois de ativá-lo.';

  @override
  String get cleanerLiteTab => 'Lite';

  @override
  String get cleanerProTab => 'Pro';

  @override
  String get scanCancelled => 'Varredura cancelada';

  @override
  String get scanPreparing => 'Preparando varredura...';

  @override
  String scanSuspiciousItemsFound(Object count, String plural) {
    String _temp0 = intl.Intl.selectLogic(
      plural,
      {
        's': '',
        'other': '',
      },
    );
    return 'Itens suspeitos encontrados: $count.$_temp0';
  }

  @override
  String scanSuspiciousCount(Object count) {
    return '$count suspeitos';
  }

  @override
  String scanCleanCount(Object count) {
    return '$count limpos';
  }

  @override
  String scanNotificationFullItems(Object count) {
    return 'Verificados: $count itens';
  }

  @override
  String scanNotificationCurrent(Object count, Object file) {
    return 'Verificados: $count • $file';
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
  String get settingsThemeRoyalBluePremium => 'Azul royal (Premium)';

  @override
  String get settingsIconDefault => 'Padrão';

  @override
  String get settingsIconBird => 'Pássaro';

  @override
  String get settingsIconNeon => 'Neon';

  @override
  String get settingsIconOriginal => 'Original';

  @override
  String get homeRealtimeProtectionTitle => 'Proteção em tempo real';

  @override
  String get networkCardStatusLocked => 'Bloqueado';

  @override
  String get networkSectionConnection => 'Conexão';

  @override
  String get networkSectionBlocklists => 'Listas de bloqueio';

  @override
  String get networkSectionResolver => 'Resolvedor';

  @override
  String get networkAppControlOtherVpnSetupInstructions =>
      'Outra VPN está selecionada como Sempre ativa no momento.\n\nPara bloquear apps com confiabilidade:\n\n1) Abra as configurações de VPN do Android\n2) Selecione AvarionX como VPN\n3) Ative VPN sempre ativa\n4) Ative Bloquear conexões sem VPN';

  @override
  String get networkAppControlSetupInstructions =>
      'Para bloquear apps com confiabilidade:\n\n1) Abra as configurações de VPN do Android\n2) Selecione AvarionX como VPN\n3) Ative VPN sempre ativa\n4) Ative Bloquear conexões sem VPN';

  @override
  String get networkAppControlBlockingActive =>
      'O bloqueio de apps está ativo.';

  @override
  String get networkAppControlOtherVpnWarning =>
      'Outra VPN está definida como Sempre ativa. Ative Sempre ativa + Bloquear sem VPN para o AvarionX.';

  @override
  String get networkAppControlSetupWarning =>
      'Ative Sempre ativa + Bloquear sem VPN para o AvarionX para que o bloqueio de apps funcione.';

  @override
  String get countryUnitedKingdom => 'Reino Unido';

  @override
  String get countryUnitedStates => 'Estados Unidos';

  @override
  String get countryCanada => 'Canadá';

  @override
  String get countryIreland => 'Irlanda';

  @override
  String get countryFrance => 'França';

  @override
  String get countryGermany => 'Alemanha';

  @override
  String get countryNetherlands => 'Países Baixos';

  @override
  String get countrySpain => 'Espanha';

  @override
  String get countryItaly => 'Itália';

  @override
  String get countrySweden => 'Suécia';

  @override
  String get countryNorway => 'Noruega';

  @override
  String get countryDenmark => 'Dinamarca';

  @override
  String get countryPoland => 'Polônia';

  @override
  String get countryTurkey => 'Turquia';

  @override
  String get countryGreece => 'Grécia';

  @override
  String get countryRomania => 'Romênia';

  @override
  String get countryUkraine => 'Ucrânia';

  @override
  String get countryRussia => 'Rússia';

  @override
  String get countryIndia => 'Índia';

  @override
  String get countryPakistan => 'Paquistão';

  @override
  String get countryBangladesh => 'Bangladesh';

  @override
  String get countrySriLanka => 'Sri Lanka';

  @override
  String get countryNepal => 'Nepal';

  @override
  String get countryJapan => 'Japão';

  @override
  String get countrySouthKorea => 'Coreia do Sul';

  @override
  String get countrySingapore => 'Singapura';

  @override
  String get countryMalaysia => 'Malásia';

  @override
  String get countryThailand => 'Tailândia';

  @override
  String get countryVietnam => 'Vietnã';

  @override
  String get countryPhilippines => 'Filipinas';

  @override
  String get countryIndonesia => 'Indonésia';

  @override
  String get countryAustralia => 'Austrália';

  @override
  String get countryNewZealand => 'Nova Zelândia';

  @override
  String get countryBrazil => 'Brasil';

  @override
  String get countryArgentina => 'Argentina';

  @override
  String get countryChile => 'Chile';

  @override
  String get countryMexico => 'México';

  @override
  String get countryColombia => 'Colômbia';

  @override
  String get countryPeru => 'Peru';

  @override
  String get countrySouthAfrica => 'África do Sul';

  @override
  String get countryNigeria => 'Nigéria';

  @override
  String get countryKenya => 'Quênia';

  @override
  String get countryEgypt => 'Egito';

  @override
  String get countryUAE => 'Emirados Árabes Unidos';

  @override
  String get countrySaudiArabia => 'Arábia Saudita';

  @override
  String get countryIsrael => 'Israel';

  @override
  String networkSpeedTestTesting(Object current, Object total, Object domain) {
    return 'Testando $current/$total • $domain';
  }

  @override
  String get networkSpeedTestDone => 'Concluído';

  @override
  String get vpnFooterCustomisation => 'Personalização';

  @override
  String get apkClipboardReportTitle =>
      'VTTI Cloud - Relatório de análise de APK';

  @override
  String apkClipboardAppName(Object name) {
    return 'Nome do app: $name';
  }

  @override
  String apkClipboardPackageId(Object packageId) {
    return 'ID do pacote: $packageId';
  }

  @override
  String apkClipboardVersion(Object version) {
    return 'Versão: $version';
  }

  @override
  String apkClipboardFileSize(Object size) {
    return 'Tamanho do arquivo: $size';
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
    return 'Assinatura: $signature';
  }

  @override
  String apkClipboardMalwareRisk(Object risk) {
    return 'Risco de malware: $risk';
  }

  @override
  String apkClipboardRiskLabel(Object label) {
    return 'Rótulo de risco: $label';
  }

  @override
  String apkClipboardHashVerdict(Object verdict) {
    return 'Veredito do hash: $verdict';
  }

  @override
  String apkClipboardRationale(Object rationale) {
    return 'Justificativa: $rationale';
  }

  @override
  String get apkReportUnusualFlags => 'Sinalizadores incomuns';

  @override
  String get apkReportUnverifiedItems => 'Itens não verificados';

  @override
  String get apkReportKnownMalware => 'Malware conhecido';

  @override
  String get apkReportSuspiciousHash => 'Hash suspeito';

  @override
  String get apkReportCleanHash => 'Hash limpo';

  @override
  String get apkReportHashNotChecked => 'Hash não verificado';

  @override
  String get apkReportHashUnknown => 'Hash desconhecido';

  @override
  String get apkMetadataPackage => 'Pacote';

  @override
  String get apkMetadataPackageId => 'ID do pacote';

  @override
  String get apkMetadataEngine => 'Mecanismo';

  @override
  String get apkMetadataSize => 'Tamanho';

  @override
  String get apkMetadataMinSdk => 'SDK mínimo';

  @override
  String get apkMetadataTargetSdk => 'SDK de destino';

  @override
  String get apkMetadataSignature => 'Assinatura';

  @override
  String get apkAnalyserStageDeconstructing => 'Desmontando APK';

  @override
  String get apkAnalyserStageAnalysing => 'Analisando conteúdo';

  @override
  String get apkAnalyserSignInRequired =>
      'Entre pelas Configurações para usar a Cloud Analysis.';

  @override
  String get apkAnalyserStageCheckingCloud => 'Verificando VTTI Cloud';

  @override
  String apkAnalyserDailyLimitReached(Object limit) {
    return 'Você atingiu seu limite diário de $limit análises.';
  }

  @override
  String get apkAnalyserCloudAnalysisFailed => 'Falha na análise na nuvem';

  @override
  String get apkAnalyserStageGeneratingReport => 'Gerando relatório';

  @override
  String get apkAnalyserAnalysisFailed => 'Falha ao processar a análise do APK';

  @override
  String get genericError => 'Erro';

  @override
  String get apkReportEngineVttiCloud => 'Mecanismo VTTI Cloud';

  @override
  String get apkReportCertificateDetected => 'Certificado detectado';

  @override
  String get apkReportNoCertificateData => 'Nenhum dado de certificado';

  @override
  String get apkExportOverview => 'Visão geral';

  @override
  String get apkExportMalwareAssessment => 'Avaliação de malware';

  @override
  String get apkExportRiskScore => 'Pontuação de risco';

  @override
  String get apkExportRiskLabel => 'Rótulo de risco';

  @override
  String get apkExportHashVerdict => 'Veredito do hash';

  @override
  String get apkExportScoreRationale => 'Justificativa da pontuação';

  @override
  String get apkExportContributingSignals => 'Sinais contribuintes';

  @override
  String get apkExportDampeningFactors => 'Fatores atenuantes';

  @override
  String get apkExportPermissionsRequested => 'Permissões solicitadas';

  @override
  String get apkExportExtraFlagsUnusual => 'Sinalizadores extras (incomuns)';

  @override
  String get apkExportExtraFlagsUnverified =>
      'Sinalizadores extras (não verificados)';

  @override
  String get apkExportDiscoveredSources => 'Fontes descobertas';

  @override
  String get apkExportRequestedPermissions => 'Permissões solicitadas';

  @override
  String get apkExportRationale => 'Justificativa';

  @override
  String apkExportCsvShareText(Object name) {
    return 'CSV da análise de APK de $name';
  }

  @override
  String get apkExportPdfTitle => 'VTTI Cloud - Análise de APK';

  @override
  String apkExportPdfShareText(Object name) {
    return 'PDF da análise de APK de $name';
  }

  @override
  String get apkMetadataAppName => 'Nome do app';

  @override
  String get apkMetadataFileSize => 'Tamanho do arquivo';

  @override
  String get vpnBackendFailedOpenBrowser => 'Falha ao abrir o navegador.';

  @override
  String get vpnBackendSignedIn => 'Conectado à conta.';

  @override
  String get vpnBackendSignedOut => 'Desconectado da conta.';

  @override
  String get vpnBackendSessionExpiredSignIn =>
      'A sessão expirou. Entre novamente.';

  @override
  String vpnBackendFailedLoadAccountStatus(Object status) {
    return 'Falha ao carregar a conta ($status).';
  }

  @override
  String vpnBackendFailedLoadAccountError(Object error) {
    return 'Falha ao carregar a conta ($error).';
  }

  @override
  String get vpnBackendSignInFirst => 'Entre primeiro.';

  @override
  String get vpnBackendConnecting => 'Conectando...';

  @override
  String get vpnBackendNotificationsPermissionRequired =>
      'Permissão de notificações necessária.';

  @override
  String get vpnBackendPermissionNotGranted =>
      'Permissão de VPN não concedida.';

  @override
  String get vpnBackendAnotherVpnActive =>
      'Outra VPN está ativa. Desative-a primeiro.';

  @override
  String get vpnBackendProvisionIncomplete =>
      'O provisionamento retornou configurações incompletas.';

  @override
  String get vpnBackendSecuringConnection => 'Protegendo a conexão...';

  @override
  String get vpnBackendConnected => 'Conectado.';

  @override
  String vpnBackendWireGuardFailed(Object error) {
    return 'Falha ao iniciar o WireGuard ($error).';
  }

  @override
  String get vpnBackendDisconnecting => 'Desconectando...';

  @override
  String get vpnBackendDisconnected => 'Desconectado.';

  @override
  String vpnBackendSelectedServer(Object server) {
    return 'Selecionado $server';
  }

  @override
  String vpnBackendSwitchingServer(Object server) {
    return 'Mudando para $server...';
  }

  @override
  String get vpnBackendKeyNotFound => 'Chave VPN não encontrada.';

  @override
  String get vpnBackendDnsUpdated => 'Configurações de DNS atualizadas.';

  @override
  String get vpnBackendSessionExpired => 'A sessão expirou.';

  @override
  String vpnBackendFailedStatus(Object status) {
    return 'Falha ($status).';
  }

  @override
  String get vpnBackendPlanNotAllowed =>
      'Seu plano não permite usar a Full VPN.';

  @override
  String vpnBackendProvisionFailed(Object status) {
    return 'Falha no provisionamento ($status).';
  }
}
