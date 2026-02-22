// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Japanese (`ja`).
class AppLocalizationsJa extends AppLocalizations {
  AppLocalizationsJa([String locale = 'ja']) : super(locale);

  @override
  String get appName => 'AVarionX Security';

  @override
  String get ok => 'OK';

  @override
  String get cancel => 'キャンセル';

  @override
  String get footerHome => 'ホーム';

  @override
  String get footerExplore => '探索';

  @override
  String get footerRemoved => '削除済み';

  @override
  String get footerSettings => '設定';

  @override
  String get proBadge => 'PRO';

  @override
  String get updateDbTitle => 'データベースを更新中';

  @override
  String updateDbVersionLabel(Object version) {
    return 'バージョン $version';
  }

  @override
  String get exploreMultiThreadingTitle => 'マルチスレッド';

  @override
  String get exploreMultiThreadingSubtitle => '実験的なエンジン制御';

  @override
  String get updateDbAutoDownloadLabel => '今後の更新を自動でダウンロード';

  @override
  String get updateDbUpdatedAutoOn => 'データベース更新済み • 自動更新が有効';

  @override
  String get updateDbUpdatedSuccess => 'データベースを更新しました';

  @override
  String get updateDbUpdateFailed => 'データベースの更新に失敗しました';

  @override
  String get engineReadyBanner => 'エンジン準備完了 • VX-TITANIUM-v7';

  @override
  String get scanButton => 'スキャン';

  @override
  String get scanModeFullTitle => '端末全体スキャン';

  @override
  String get scanModeFullSubtitle => '読み取り可能なストレージ内の全ファイルをスキャンします。';

  @override
  String get scanModeSmartTitle => 'スマートスキャン [推奨]';

  @override
  String get scanModeSmartSubtitle => 'マルウェアを含む可能性のあるファイルをスキャンします。';

  @override
  String get scanModeRapidTitle => 'クイックスキャン';

  @override
  String get scanModeRapidSubtitle => 'ダウンロード内の最近のAPKを確認します。';

  @override
  String get scanModeInstalledTitle => 'インストール済みアプリ';

  @override
  String get scanModeInstalledSubtitle => 'インストール済みアプリを脅威スキャンします。';

  @override
  String get scanModeSingleTitle => 'ファイル / アプリ スキャン';

  @override
  String get scanModeSingleSubtitle => 'スキャンするファイルまたはアプリを選択します。';

  @override
  String get useCloudAssistedScan => 'クラウド支援スキャンを使用';

  @override
  String get protectionTitle => '保護';

  @override
  String get stateOffLine1 => '端末保護はオフです';

  @override
  String get stateOffLine2 => 'タップしてオンにする';

  @override
  String get stateAdvancedActiveLine1 => '高度な保護が有効です';

  @override
  String get stateFileOnlyLine1 => 'ファイル保護のみ';

  @override
  String get stateFileOnlyLine2 => 'ネットワーク保護は無効です';

  @override
  String get stateVpnConflictLine2 => '別のVPNが有効です';

  @override
  String get stateProtectedLine1 => '端末は保護されています';

  @override
  String get stateProtectedLine2 => 'タップしてオフにする';

  @override
  String get dbUpdating => 'データベース更新中';

  @override
  String dbVersionAutoUpdated(Object version) {
    return 'データベース v$version • 自動更新';
  }

  @override
  String get rtpInfoTitle => 'リアルタイム保護';

  @override
  String get rtpInfoBody =>
      'RTPは、意図的（またはマルウェア）にダウンロードされた疑わしいファイルをブロックするだけでなく、ローカルVPNを使用してシステム全体で悪意のあるドメインをブロックします。\n\n有効化すると、ネットワークフィルタリングは次の場合を除き有効のままです:\n• ターミナルから手動で無効化\n• 別のVPNに置き換え\n\nRTPが有効な限り、ファイル保護は継続されます。';

  @override
  String get scanTitleDefault => 'スキャン';

  @override
  String get scanTitleSmart => 'スマートスキャン';

  @override
  String get scanTitleRapid => 'クイックスキャン';

  @override
  String get scanTitleInstalled => 'インストール済みアプリをスキャン';

  @override
  String get scanTitleFull => '端末全体スキャン';

  @override
  String get scanTitleSingle => '単体スキャン';

  @override
  String get cancellingScan => 'スキャンをキャンセル中…';

  @override
  String get cancelScan => 'スキャンをキャンセル';

  @override
  String get scanProgressZero => '進捗: 0%';

  @override
  String scanProgressWithPct(Object pct, Object scanned, Object total) {
    return '進捗: $pct% ($scanned / $total)';
  }

  @override
  String scanProgressFullItems(Object count) {
    return 'スキャン済み: $count 件';
  }

  @override
  String get initializing => '初期化中...';

  @override
  String get scanningEllipsis => 'スキャン中...';

  @override
  String get fullScanInfoTitle => '端末全体スキャン';

  @override
  String get fullScanInfoBody =>
      'このモードはストレージ内の読み取り可能な全ファイルを、フィルタなしでスキャンします。\n\nこのモードではクラウド支援スキャンおよびアプリスキャンは使用されません。';

  @override
  String get scanComplete => 'スキャン完了';

  @override
  String pillSuspiciousCount(Object count) {
    return '疑わしい: $count';
  }

  @override
  String pillCleanCount(Object count) {
    return '安全: $count';
  }

  @override
  String pillScannedCount(Object count) {
    return 'スキャン済み: $count';
  }

  @override
  String get resultNoThreatsTitle => '脅威は検出されませんでした';

  @override
  String get resultNoThreatsBody => 'スキャンした項目で脅威は検出されませんでした。';

  @override
  String get resultSuspiciousAppsTitle => '疑わしいアプリ';

  @override
  String get resultSuspiciousItemsTitle => '疑わしい項目';

  @override
  String get returnHome => 'ホームに戻る';

  @override
  String get emptyTitle => 'スキャン対象のファイルがありません';

  @override
  String get emptyBody => 'スキャン条件に一致するファイルが見つかりませんでした。';

  @override
  String get knownMalware => '既知のマルウェア';

  @override
  String get suspiciousActivityDetected => '疑わしい活動を検出';

  @override
  String get maliciousActivityDetected => '悪意のある活動を検出';

  @override
  String get androidBankingTrojan => 'Android 銀行型トロイの木馬';

  @override
  String get androidSpyware => 'Android スパイウェア';

  @override
  String get androidAdware => 'Android アドウェア';

  @override
  String get androidSmsFraud => 'Android SMS 不正';

  @override
  String get threatLevelConfirmed => '確認済み';

  @override
  String get threatLevelHigh => '高';

  @override
  String get threatLevelMedium => '中';

  @override
  String threatLevelLabel(Object level) {
    return '脅威レベル: $level';
  }

  @override
  String get explainFoundInCloud => 'この項目はColourSwiftのクラウド脅威データベースに登録されています。';

  @override
  String get explainFoundInOffline => 'この項目は端末内のオフラインマルウェアデータベースに登録されています。';

  @override
  String get explainBanker => '金融情報を盗む目的で作られ、オーバーレイ、キー入力の記録、通信の傍受などを行うことがあります。';

  @override
  String get explainSpyware => 'メッセージ、位置情報、端末識別子などの個人データを密かに収集または監視します。';

  @override
  String get explainAdware => '迷惑広告の表示、リダイレクト、または不正な広告トラフィック生成を行います。';

  @override
  String get explainSmsFraud => '同意なくSMS送信やSMS関連の操作を試み、予期しない課金につながる可能性があります。';

  @override
  String get explainGenericMalware => '特定のファミリに一致しない場合でも、悪意の強い兆候が検出されました。';

  @override
  String get explainSuspiciousDefault =>
      '疑わしい挙動の兆候が検出されました。マルウェアで見られるパターンを含む場合がありますが、誤検知の可能性もあります。';

  @override
  String get singleChoiceScanFile => 'ファイルをスキャン';

  @override
  String get singleChoiceScanInstalledApp => 'インストール済みアプリをスキャン';

  @override
  String get singleChoiceManageExclusions => '除外を管理';

  @override
  String get labelKnownMalwareDb => 'マルウェアDBに登録';

  @override
  String get labelFoundInCloudDb => 'クラウドDBに登録';

  @override
  String get logEngineFullDeviceScan => '[ENGINE] 端末全体スキャン';

  @override
  String get logEngineTargetStorage => '[ENGINE] 対象: /storage/emulated/0';

  @override
  String get logEngineNoFilesFound => '[ENGINE] ファイルが見つかりません。';

  @override
  String logEngineFilesEnumerated(Object count) {
    return '[ENGINE] 列挙したファイル数: $count';
  }

  @override
  String get logEngineNoReadableFilesFound => '[ENGINE] 読み取り可能なファイルが見つかりません。';

  @override
  String logEngineInstalledAppsFound(Object count) {
    return '[ENGINE] 見つかったインストール済みアプリ数: $count';
  }

  @override
  String get logModeCloudAssisted => '[MODE] クラウド支援モード';

  @override
  String get logModeOffline => '[MODE] オフラインモード';

  @override
  String get logStageHashing => '[STAGE 1] ファイルハッシュ取得（キャッシュ）...';

  @override
  String get logStageCloudLookup => '[STAGE 2] クラウドでハッシュ照合...';

  @override
  String logStageLocalScanning(Object stage) {
    return '[STAGE $stage] ローカルでファイルをスキャン中...';
  }

  @override
  String logCloudHashHits(Object count) {
    return '[CLOUD] ハッシュ一致: $count';
  }

  @override
  String logSummary(Object suspicious, Object clean) {
    return '[SUMMARY] 疑わしい $suspicious • 安全 $clean';
  }

  @override
  String logErrorPrefix(Object message) {
    return '[ERROR] $message';
  }

  @override
  String get genericUnknownAppName => '不明';

  @override
  String get genericUnknownFileName => '不明';

  @override
  String get featuresDrawerTitle => '機能';

  @override
  String get recommendedSectionTitle => 'おすすめ';

  @override
  String get featureNetworkProtection => 'ネットワーク保護';

  @override
  String get featureLinkChecker => 'リンクチェッカー';

  @override
  String get featureMetaPass => 'MetaPass';

  @override
  String get featureCleanerPro => 'Cleaner Pro';

  @override
  String get featureTerminal => 'ターミナル';

  @override
  String get featureScheduledScans => 'スケジュールスキャン';

  @override
  String get networkStatusDisconnected => '未接続';

  @override
  String get networkStatusConnecting => '接続中';

  @override
  String get networkStatusConnected => 'Connected to null';

  @override
  String get networkUsageTitle => '使用量';

  @override
  String get networkUsageEnableVpnToView => '使用量を表示するにはVPNを有効にしてください。';

  @override
  String get networkUsageUnlimited => '無制限';

  @override
  String networkUsageUsedOf(Object used, Object limit) {
    return '$used / $limit';
  }

  @override
  String networkUsageResetsOn(Object y, Object m, Object d) {
    return '$y-$m-$d にリセット';
  }

  @override
  String networkUsageUpdatedAt(Object hh, Object mm) {
    return '$hh:$mm に更新';
  }

  @override
  String get networkCardStatusAvailable => '利用可能';

  @override
  String get networkCardStatusDisabled => '無効';

  @override
  String get networkCardStatusCustom => 'カスタム';

  @override
  String get networkCardStatusReady => '準備完了';

  @override
  String get networkCardStatusOpen => '開く';

  @override
  String get networkCardStatusComingSoon => '近日公開';

  @override
  String get networkCardBlocklistsTitle => 'ブロックリスト';

  @override
  String get networkCardBlocklistsSubtitle => 'フィルタ設定';

  @override
  String get networkCardUpstreamTitle => 'Upstream';

  @override
  String get networkCardUpstreamSubtitle => 'リゾルバ選択';

  @override
  String get networkCardAppsTitle => 'アプリ';

  @override
  String get networkCardAppsSubtitle => 'Wi-Fiでアプリをブロック';

  @override
  String get networkCardLogsTitle => 'ログ';

  @override
  String get networkCardLogsSubtitle => 'DNSイベント（ライブ）';

  @override
  String get networkCardSpeedTitle => '速度';

  @override
  String get networkCardSpeedSubtitle => 'DNSテスト';

  @override
  String get networkCardAboutTitle => '情報';

  @override
  String get networkCardAboutSubtitle => 'GitHub';

  @override
  String get networkLogsStatusNoActivity => 'アクティビティなし';

  @override
  String networkLogsStatusRecent(Object count) {
    return '最近 $count 件';
  }

  @override
  String get networkResolverTitle => 'リゾルバ';

  @override
  String get networkResolverIpLabel => 'リゾルバIP';

  @override
  String get networkResolverIpHint => '例: 1.1.1.1';

  @override
  String get networkSpeedTestTitle => '速度テスト';

  @override
  String get networkSpeedTestBody => '現在の設定でDNS速度テスターを実行します。';

  @override
  String get networkSpeedTestRun => '速度テストを実行';

  @override
  String get networkBlocklistsRecommendedTitle => 'おすすめ';

  @override
  String get networkBlocklistsCsMalwareTitle => 'ColourSwift Malware';

  @override
  String get networkBlocklistsCsAdsTitle => 'ColourSwift ads';

  @override
  String get networkBlocklistsSeeGithub => '詳細はGitHubを参照...';

  @override
  String get networkBlocklistsMalwareSection => 'マルウェア';

  @override
  String get networkBlocklistsMalwareTitle => 'マルウェア ブロックリスト';

  @override
  String get networkBlocklistsMalwareSources =>
      'HaGeZi TIF • URLHaus • DigitalSide • Spam404';

  @override
  String get networkBlocklistsAdsSection => '広告';

  @override
  String get networkBlocklistsAdsTitle => '広告 ブロックリスト';

  @override
  String get networkBlocklistsAdsSources =>
      'OISD • AdAway • Yoyo • AnudeepND • Firebog AdGuard';

  @override
  String get networkBlocklistsTrackersSection => 'トラッカー';

  @override
  String get networkBlocklistsTrackersTitle => 'トラッカー ブロックリスト';

  @override
  String get networkBlocklistsTrackersSources =>
      'EasyPrivacy • Disconnect • Frogeye • Perflyst • WindowsSpyBlocker';

  @override
  String get networkBlocklistsGamblingSection => 'ギャンブル';

  @override
  String get networkBlocklistsGamblingTitle => 'ギャンブル ブロックリスト';

  @override
  String get networkBlocklistsGamblingSources => 'HaGeZi Gambling';

  @override
  String get networkBlocklistsSocialSection => 'ソーシャルメディア';

  @override
  String get networkBlocklistsSocialTitle => 'ソーシャルメディア ブロックリスト';

  @override
  String get networkBlocklistsSocialSources => 'HaGeZi Social';

  @override
  String get networkBlocklistsAdultSection => '18+';

  @override
  String get networkBlocklistsAdultTitle => 'アダルト ブロックリスト';

  @override
  String get networkBlocklistsAdultSources => 'StevenBlack 18+ • HaGeZi NSFW';

  @override
  String get networkLiveLogsTitle => 'ライブログ';

  @override
  String get networkLiveLogsEmpty => 'リクエストはまだありません。';

  @override
  String get networkLiveLogsBlocked => 'ブロック';

  @override
  String get networkLiveLogsAllowed => '許可';

  @override
  String get recommendedMetaPassDesc => '安全なオフラインパスワードを生成します。';

  @override
  String get recommendedCleanerProDesc => '重複、古いメディア、未使用アプリを見つけて自動的に容量を回復します。';

  @override
  String get recommendedLinkCheckerDesc => 'セーフビュー機能で疑わしいリンクを安全にチェックします。';

  @override
  String get recommendedNetworkProtectionDesc => 'マルウェアからインターネット接続を守ります。';

  @override
  String get recommendedTerminalDesc => 'Shizuku向けの高度な機能';

  @override
  String get recommendedScheduledScansDesc => 'バックグラウンドで自動スキャンします。';

  @override
  String get metaPassTitle => 'MetaPass';

  @override
  String get metaPassHowItWorks => 'MetaPassの仕組み';

  @override
  String get metaPassOk => 'OK';

  @override
  String get metaPassSettings => '設定';

  @override
  String get metaPassPoweredBy => 'powered by VX-TITANIUM';

  @override
  String get metaPassLoading => '読み込み中…';

  @override
  String get metaPassEmptyTitle => 'まだエントリがありません';

  @override
  String get metaPassEmptyBody =>
      'アプリまたはWebサイトを追加してください。\nパスワードは秘密のメタパスワードから端末上で生成されます。';

  @override
  String get metaPassAddFirstEntry => '最初のエントリを追加';

  @override
  String get metaPassTapToCopyHint => 'タップでコピー。長押しで削除。';

  @override
  String get metaPassCopyTooltip => 'パスワードをコピー';

  @override
  String get metaPassAdd => '追加';

  @override
  String get metaPassPickFromInstalledApps => 'インストール済みアプリから選択';

  @override
  String get metaPassAddWebsiteOrLabel => 'Webサイトまたはカスタム名を追加';

  @override
  String get metaPassSelectApp => 'アプリを選択';

  @override
  String get metaPassSearchApps => 'アプリを検索';

  @override
  String get metaPassCancel => 'キャンセル';

  @override
  String get metaPassContinue => '続行';

  @override
  String get metaPassSave => '保存';

  @override
  String get metaPassAddEntryTitle => 'エントリを追加';

  @override
  String get metaPassNameOrUrl => '名前またはURL';

  @override
  String get metaPassNameOrUrlHint => '例: nextcloud, steam, example.com';

  @override
  String get metaPassVersion => 'バージョン';

  @override
  String get metaPassLength => '長さ';

  @override
  String get metaPassSetMetaTitle => 'メタパスワードを設定';

  @override
  String get metaPassSetMetaBody =>
      'メタパスワードを入力してください。端末の外へ出ません。すべての保管庫パスワードはこれに依存します。';

  @override
  String get metaPassMetaLabel => 'メタパスワード';

  @override
  String get metaPassRememberThisDevice => 'この端末で記憶（安全に保存）';

  @override
  String get metaPassChangingMetaWarning =>
      '後で変更すると生成されるパスワードがすべて変わります。同じメタパスワードを使うと復元できます。';

  @override
  String get metaPassRemoveEntryTitle => 'エントリを削除';

  @override
  String metaPassRemoveEntryBody(Object label) {
    return '保管庫から「$label」を削除しますか？';
  }

  @override
  String get metaPassRemove => '削除';

  @override
  String metaPassPasswordCopied(Object label, Object version, Object length) {
    return '$label のパスワードをコピーしました (v$version, $length chars)';
  }

  @override
  String metaPassGenerateFailed(Object error) {
    return 'パスワード生成に失敗しました: $error';
  }

  @override
  String metaPassLoadAppsFailed(Object error) {
    return 'アプリの読み込みに失敗しました: $error';
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
      'パスワードは保存されません。\n\n各エントリは次からパスワードを導出します:\n• メタパスワード\n• ラベル（名前）\n• バージョンと長さ\n\n同じメタパスワードとラベルでアプリを再インストールすると、同じパスワードが再生成されます。';

  @override
  String get passwordSettingsTitle => 'パスワード設定';

  @override
  String get passwordSettingsSectionMetaPass => 'MetaPass';

  @override
  String get passwordSettingsMetaPasswordTitle => 'メタパスワード';

  @override
  String get passwordSettingsMetaNotSet => '未設定';

  @override
  String get passwordSettingsMetaStoredSecurely => 'この端末に安全に保存';

  @override
  String get passwordSettingsChange => '変更';

  @override
  String get passwordSettingsSetMetaPassTitle => 'MetaPassを設定';

  @override
  String get passwordSettingsMetaPasswordLabel => 'メタパスワード';

  @override
  String get passwordSettingsChangingAltersAll =>
      '変更するとすべてのパスワードが変わります。\n同じMetaPassを使うと復元できます。';

  @override
  String get passwordSettingsCancel => 'キャンセル';

  @override
  String get passwordSettingsSave => '保存';

  @override
  String get passwordSettingsSectionRestoreCode => '復元コード';

  @override
  String get passwordSettingsGenerateRestoreCode => '復元コードを生成';

  @override
  String get passwordSettingsCopy => 'コピー';

  @override
  String get passwordSettingsRestoreCodeCopied => '復元コードをコピーしました';

  @override
  String get passwordSettingsSectionRestoreFromCode => 'コードから復元';

  @override
  String get passwordSettingsRestoreCodeLabel => '復元コード';

  @override
  String get passwordSettingsRestore => '復元';

  @override
  String get passwordSettingsVaultRestored => '保管庫を復元しました';

  @override
  String get passwordSettingsFooterInfo =>
      'パスワードは保存されません。\n\n復元コードには構造データのみが含まれます。MetaPassと組み合わせることで保管庫を再構築します。';

  @override
  String get onboardingAppName => 'AVarionX Security';

  @override
  String get onboardingStorageTitle => 'ストレージアクセス';

  @override
  String get onboardingStorageDesc =>
      'この権限は端末内ファイルをスキャンするために必要です。今すぐ付与するか後で付与できます。';

  @override
  String get onboardingStorageFootnote => 'スキップできますが、スキャンモードを選択すると再度求められます。';

  @override
  String get onboardingStorageSnack => 'スキャンにはストレージ権限が必要です。';

  @override
  String get onboardingNotificationsTitle => '通知';

  @override
  String get onboardingNotificationsDesc => 'リアルタイムアラート、スキャン状況、隔離の更新に使用されます。';

  @override
  String get onboardingNotificationsFootnote => 'リアルタイム保護のためにAndroidが要求します。';

  @override
  String get onboardingNetworkTitle => 'ネットワーク保護';

  @override
  String get onboardingNetworkDesc => 'AndroidのVPN権限を使用してWi-Fi保護を有効にします。';

  @override
  String get onboardingNetworkFootnote => '任意ですが推奨です。';

  @override
  String get onboardingGranted => '付与済み';

  @override
  String get onboardingNotGranted => '未付与';

  @override
  String get onboardingGrantAccess => '権限を付与';

  @override
  String get onboardingAllowNotifications => '通知を許可';

  @override
  String get onboardingAllowVpnAccess => 'VPNアクセスを許可';

  @override
  String get onboardingBack => '戻る';

  @override
  String get onboardingNext => '次へ';

  @override
  String get onboardingFinish => '完了';

  @override
  String get onboardingSetupCompleteTitle => 'セットアップ完了';

  @override
  String get onboardingSetupCompleteDesc =>
      '端末全体スキャンの実行を推奨します（現時点ではインストール済みアプリはスキャンしません）。またはホーム画面へ移動してください。';

  @override
  String get onboardingRunFullScan => '端末全体スキャンを実行';

  @override
  String get onboardingGoHome => 'ホームへ';

  @override
  String get networkProtectionTitle => 'ネットワーク保護';

  @override
  String networkStatusConnectedToDns(Object dns) {
    return 'Connected to $dns';
  }

  @override
  String get networkStatusVpnConflictDetail => 'Another VPN is active';

  @override
  String get networkStatusOffDetail => 'Network protection is off';

  @override
  String get networkModeMalwareTitle => 'マルウェアのみブロック';

  @override
  String get networkModeMalwareSubtitle => '1.1.1.2 を使用';

  @override
  String get networkModeMalwareDescription =>
      'AVarionXのローカルマルウェアDBとCloudflareのオンライン脅威インテリジェンスを組み合わせ、最大限のマルウェア保護を提供します。';

  @override
  String get networkModeAdultTitle => 'マルウェア + アダルトコンテンツ';

  @override
  String get networkModeAdultSubtitle => '1.1.1.3 を使用';

  @override
  String get networkModeAdultDescription =>
      'AVarionXのオフラインマルウェアDBを使用し、アダルトコンテンツのフィルタを追加します。このモードではクラウドのマルウェアインテリジェンスは無効です。';

  @override
  String get networkInfoTitle => 'ネットワーク保護とは？';

  @override
  String get networkInfoBody =>
      '一部の脅威は悪意のあるサーバーへ接続したり、通信をリダイレクトしたりして動作します。\nネットワーク保護はローカルVPNを使用して、既知の危険ドメインや一般的な広告をブロックします。\n\nAVarionX Securityはデータを収集しません。';

  @override
  String get linkCheckerTitle => 'リンクチェッカー';

  @override
  String get linkCheckerTabAnalyse => '解析';

  @override
  String get linkCheckerTabView => '表示';

  @override
  String get linkCheckerTabHistory => '履歴';

  @override
  String get linkCheckerAnalyseSubtitle => 'ページにマルウェアや疑わしい内容がないか確認';

  @override
  String get linkCheckerUrlLabel => 'URL';

  @override
  String get linkCheckerUrlHint => 'https://example.com';

  @override
  String get linkCheckerButtonAnalyse => '解析';

  @override
  String get linkCheckerButtonChecking => '確認中';

  @override
  String get linkCheckerEngineNotReadySnack => 'エンジンが準備できていません';

  @override
  String get linkCheckerStatusVerifyingLink => 'リンクを検証中…';

  @override
  String get linkCheckerStatusScanningPage => 'ページをスキャン中…';

  @override
  String get linkCheckerBlockedNavigation => 'ナビゲーションをブロックしました';

  @override
  String get linkCheckerBlockedUnsupportedType => '未対応のリンク種類';

  @override
  String get linkCheckerBlockedInvalidDestination => '無効な宛先';

  @override
  String get linkCheckerBlockedUnableResolve => '宛先を解決できません';

  @override
  String get linkCheckerBlockedUnableVerify => '検証できません';

  @override
  String get linkCheckerAnalyseCardTitleDefault => 'ページの疑わしい内容を確認';

  @override
  String get linkCheckerAnalyseCardDetailDefault => 'URLを貼り付けて解析を実行してください。';

  @override
  String get linkCheckerAnalyseCardTitleEngineNotReady => 'エンジンが準備できていません';

  @override
  String get linkCheckerAnalyseCardDetailEngineNotReady => 'error 1001.';

  @override
  String get linkCheckerAnalyseCardTitleChecking => '確認中';

  @override
  String get linkCheckerVerdictClean => '安全';

  @override
  String get linkCheckerVerdictCleanDetail => 'このページは安全と思われます。';

  @override
  String get linkCheckerVerdictSuspicious => '疑わしい';

  @override
  String get linkCheckerVerdictSuspiciousDetail => 'このページには疑わしい内容があります。';

  @override
  String get linkCheckerViewLockedBody => '表示を有効にするには先に解析を実行してください。';

  @override
  String get linkCheckerViewSubtitle => 'ページを安全に表示';

  @override
  String get linkCheckerViewPage => 'ページを表示';

  @override
  String get linkCheckerClose => '閉じる';

  @override
  String get linkCheckerBlockedBody => 'このページは読み込まれる前に停止されました。';

  @override
  String get linkCheckerSuspiciousBanner =>
      '疑わしいリンクです。ブロックされた要素が必要な場合、正しく表示されない可能性があります。';

  @override
  String get linkCheckerHistorySubtitle => '項目をタップしてリンクをコピー。';

  @override
  String get linkCheckerHistoryEmpty => 'まだ履歴がありません。';

  @override
  String get linkCheckerCopied => 'コピーしました';

  @override
  String get settingsSectionAppearance => 'Appearance';

  @override
  String get settingsTheme => 'Theme';

  @override
  String settingsThemeCurrent(Object theme) {
    return 'Current: $theme';
  }

  @override
  String get settingsLanguage => 'Language';

  @override
  String settingsLanguageCurrent(Object language) {
    return 'Current: $language';
  }

  @override
  String get settingsChooseLanguage => 'Choose Language';

  @override
  String get settingsLanguageApplied => 'Language applied';

  @override
  String get settingsSystemDefault => 'System default';

  @override
  String get settingsSectionCommunity => 'Join the community!';

  @override
  String get settingsDiscord => 'Discord';

  @override
  String get settingsDiscordSubtitle => 'Chat, updates and feedback';

  @override
  String get settingsDiscordOpenFail => 'Unable to open Discord link';

  @override
  String get settingsSectionPro => 'PRO Features';

  @override
  String get settingsProCustomization => 'PRO Customization';

  @override
  String get settingsProSubtitle =>
      'Go ad free, unlock unlimited DNS, themes and icons';

  @override
  String get settingsUnlockPro => 'Unlock Premium';

  @override
  String get settingsProUnlocked => 'PRO mode unlocked';

  @override
  String get settingsPurchaseNotConfirmed => 'Purchase not confirmed';

  @override
  String settingsPurchaseFailed(Object error) {
    return 'Purchase failed: $error';
  }

  @override
  String get proActivated => 'PRO activated';

  @override
  String get proDeactivated => 'PRO deactivated';

  @override
  String get settingsProReset => 'PRO reset (debug only)';

  @override
  String get settingsProSheetTitle => 'PRO Customization';

  @override
  String get settingsHideGoldHeader =>
      'Show gold header on Home Screen (dark themes)';

  @override
  String get settingsAppIcon => 'App Icon';

  @override
  String settingsIconSelected(Object icon) {
    return 'Icon selected: $icon';
  }

  @override
  String get settingsSave => 'Save';

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
  String get settingsSectionShizuku => 'Advanced Protection (Shizuku)';

  @override
  String get settingsEnableShizuku => 'Enable Shizuku';

  @override
  String get settingsShizukuRequiresManager => 'Requires external manager';

  @override
  String get settingsShizukuNotRunning => 'Shizuku service not running';

  @override
  String get settingsShizukuPermissionRequired => 'Permission required';

  @override
  String get settingsShizukuAvailable => 'Advanced system access available';

  @override
  String get settingsAboutAdvancedProtection => 'About Advanced Protection';

  @override
  String get settingsAboutAdvancedProtectionSubtitle =>
      'Learn how advanced protection works';

  @override
  String get settingsAdvancedProtectionDialogTitle =>
      'Advanced system Protection';

  @override
  String get settingsAdvancedProtectionDialogBody =>
      'Shizuku access requires an external manager intended for advanced users.\n\nThis feature is optional and not recommended for casual protection.';

  @override
  String get settingsAboutShizukuTitle => 'About Shizuku';

  @override
  String get settingsAboutShizukuBody =>
      'AVarionX can integrate with Shizuku to access app processes at the system level.\n\nThis allows the app to:\n• Detect malware that hides from standard scanners\n• Inspect running app processes\n• Disable or contain most active malware\n\nShizuku however, does not grant root access\n\nThis feature is intended for advanced users and is not required for normal protection.\n\nDocumentation:\nhttps://shizuku.rikka.app';

  @override
  String get settingsSectionGeneral => 'General';

  @override
  String get settingsExclusions => 'Exclusions';

  @override
  String get settingsExclusionsSubtitle => 'Manage and add exclusions';

  @override
  String get settingsExcludeFolder => 'Exclude a Folder';

  @override
  String get settingsExcludeFile => 'Exclude a File';

  @override
  String get settingsManageExclusions => 'Manage Existing Exclusions';

  @override
  String get settingsManageExclusionsSubtitle => 'View or remove exclusions';

  @override
  String get settingsFolderExcluded => 'Folder excluded';

  @override
  String get settingsFileExcluded => 'File excluded';

  @override
  String get settingsPrivacyPolicy => 'Privacy Policy';

  @override
  String get settingsPrivacyPolicySubtitle => 'View how your data is handled';

  @override
  String get settingsPrivacyPolicyOpenFail => 'Unable to open privacy policy';

  @override
  String get settingsAboutApp => 'About AVarionX';

  @override
  String get settingsHowThisAppWorks => 'How This App Works';

  @override
  String get settingsHowThisAppWorksSubtitle => 'Learn about protection';

  @override
  String get settingsThemePickerTitle => 'Choose Theme';

  @override
  String get settingsThemeRequiresPro => 'That theme requires PRO mode';

  @override
  String get scheduledScansTitle => 'Scheduled Scans';

  @override
  String get scheduledScansInfoTitle => 'Scheduled Scans';

  @override
  String get scheduledScansInfoBody =>
      'While RTP focuses on downloaded malware, Scheduled Scans will automatically launch your chosen scan mode in the background.\nIt will only run while RTP is enabled.\n\nPRO users can customize scan mode and frequency.';

  @override
  String get scheduledScansHeader => 'Automatic background scans';

  @override
  String get scheduledScansSubheader =>
      'While RTP is active, the app will scan your device based on the selected scan mode and frequency.';

  @override
  String get proRequiredToCustomize => 'PRO required to customize';

  @override
  String get scheduledScansEnabledTitle => 'Enabled';

  @override
  String get scheduledScansEnabledSubtitle =>
      'When enabled, a scan runs automatically on your chosen schedule.';

  @override
  String get scheduledScansModeTitle => 'Scan mode';

  @override
  String scheduledScansModeHint(Object mode) {
    return 'Current mode: $mode';
  }

  @override
  String get scheduledScansFrequencyTitle => 'Frequency';

  @override
  String scheduledScansFrequencyHint(Object freq) {
    return 'Runs: $freq';
  }

  @override
  String get scheduledEveryDay => 'Every day';

  @override
  String get scheduledEvery3Days => 'Every 3 days';

  @override
  String get scheduledEveryWeek => 'Every week';

  @override
  String get scheduledEvery2Weeks => 'Every 2 weeks';

  @override
  String get scheduledEvery3Weeks => 'Every 3 weeks';

  @override
  String get scheduledMonthly => 'Monthly';

  @override
  String scheduledEveryDays(Object days) {
    return 'Every $days days';
  }

  @override
  String scheduledEveryHours(Object hours) {
    return 'Every $hours hours';
  }

  @override
  String get scheduledChargingOnlyTitle => 'Only when charging';

  @override
  String get scheduledChargingOnlySubtitle =>
      'Run the scheduled scan only while the device is plugged in.';

  @override
  String get scheduledPreferredTimeTitle => 'Preferred time';

  @override
  String get scheduledPreferredTimeSubtitle =>
      'AVarionX will aim to start around this time. Android may delay it to save battery.';

  @override
  String get scheduledPickTime => 'Pick time';

  @override
  String get cleanerTitle => 'Cleaner Pro';

  @override
  String get cleanerReadyToScan => 'Ready to Scan';

  @override
  String get cleanerScan => 'Scan';

  @override
  String get cleanerScanning => 'Scanning…';

  @override
  String get cleanerReady => 'Ready';

  @override
  String get cleanerStatusReady => 'Ready';

  @override
  String get cleanerStatusStarting => 'Starting…';

  @override
  String get cleanerStatusFilesScanned => 'Files scanned';

  @override
  String get cleanerStatusFindingUnusedApps => 'Finding unused apps…';

  @override
  String get cleanerStatusComplete => 'Complete';

  @override
  String get cleanerStatusScanError => 'Scan error';

  @override
  String get cleanerStatusScanningApps => 'Scanning apps…';

  @override
  String get cleanerGrantUsageAccessTitle => 'Grant Usage Access';

  @override
  String get cleanerGrantUsageAccessBody =>
      'To detect unused apps, this cleaner requires Usage Access permission. You’ll be redirected to system settings to enable it.';

  @override
  String get cleanerCancel => 'Cancel';

  @override
  String get cleanerContinue => 'Continue';

  @override
  String get cleanerDuplicates => 'Duplicates';

  @override
  String get cleanerDuplicatesNone => 'No duplicates found';

  @override
  String cleanerDuplicatesSubtitle(Object count, Object size) {
    return '$count items • reclaim $size';
  }

  @override
  String get cleanerOldPhotos => 'Old Photos';

  @override
  String cleanerOldPhotosNone(Object days) {
    return 'No photos older than $days days';
  }

  @override
  String cleanerOldPhotosSubtitle(Object count, Object size) {
    return '$count items • $size';
  }

  @override
  String get cleanerOldVideos => 'Old Videos';

  @override
  String cleanerOldVideosNone(Object days) {
    return 'No videos older than $days days';
  }

  @override
  String cleanerOldVideosSubtitle(Object count, Object size) {
    return '$count items • $size';
  }

  @override
  String get cleanerLargeFiles => 'Large Files';

  @override
  String cleanerLargeFilesNone(Object size) {
    return 'No files ≥ $size';
  }

  @override
  String cleanerLargeFilesSubtitle(Object count, Object sizeTotal) {
    return '$count items • $sizeTotal';
  }

  @override
  String get cleanerUnusedApps => 'Unused Apps';

  @override
  String cleanerUnusedAppsNone(Object days) {
    return 'No unused apps (last $days days)';
  }

  @override
  String cleanerUnusedAppsCount(Object count) {
    return '$count apps';
  }

  @override
  String get cleanerStageDuplicates => 'Scanning duplicates…';

  @override
  String get cleanerStageDuplicatesGrouping => 'Grouping duplicates…';

  @override
  String get cleanerStageOldPhotos => 'Scanning old photos…';

  @override
  String get cleanerStageOldVideos => 'Scanning old videos…';

  @override
  String get cleanerStageLargeFiles => 'Scanning large files…';

  @override
  String cleanerStageOldPhotosProgress(Object count, Object size) {
    return 'Old photos: $count • $size';
  }

  @override
  String cleanerStageOldVideosProgress(Object count, Object size) {
    return 'Old videos: $count • $size';
  }

  @override
  String cleanerStageLargeFilesProgress(Object count, Object size) {
    return 'Large files: $count • $size';
  }

  @override
  String get unusedAppsTitle => 'Unused Apps';

  @override
  String unusedAppsEmpty(Object days) {
    return 'No unused apps in last $days days';
  }

  @override
  String get quarantineTitle => 'Removed';

  @override
  String get quarantineSelectAll => 'Select all';

  @override
  String get quarantineRefresh => 'Refresh';

  @override
  String get quarantineEmptyTitle => 'No removed files';

  @override
  String get quarantineEmptyBody => 'Anything you remove will show up here.';

  @override
  String get quarantineRestore => 'Restore';

  @override
  String get quarantineDelete => 'Delete';

  @override
  String get quarantineSnackRestored => 'Restored';

  @override
  String get quarantineSnackDeleted => 'Deleted';

  @override
  String get quarantineDeleteDialogTitle => 'Delete selected files?';

  @override
  String quarantineDeleteDialogBody(Object count, Object plural) {
    return 'This will permanently delete $count item$plural.';
  }
}
