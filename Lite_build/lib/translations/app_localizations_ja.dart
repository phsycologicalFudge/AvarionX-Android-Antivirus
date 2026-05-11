// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Japanese (`ja`).
class AppLocalizationsJa extends AppLocalizations {
  AppLocalizationsJa([String locale = 'ja']) : super(locale);

  @override
  String get appName => 'AvarionX';

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
  String get proBadge => 'プレミアム';

  @override
  String get updateDbTitle => 'データベースを更新中';

  @override
  String updateDbVersionLabel(Object version) {
    return 'バージョン $version';
  }

  @override
  String get companionAppsSectionTitle => 'More from AvarionX';

  @override
  String get cleanerReclaimableLabel => 'Can be freed';

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
  String get engineReadyBanner => 'VX-TITANIUM-v8';

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
  String get networkStatusConnected => '接続済み';

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
  String get onboardingAppName => 'AVarionx Security';

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
  String get onboardingNetworkDesc => 'AndroidのVPN権限を使用してWi Fi保護を有効にします。';

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
    return '$dns に接続中';
  }

  @override
  String get networkStatusVpnConflictDetail => '別のVPNが有効です';

  @override
  String get networkStatusOffDetail => 'ネットワーク保護はオフです';

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
  String get settingsSectionAppearance => '外観';

  @override
  String get settingsTheme => 'テーマ';

  @override
  String settingsThemeCurrent(Object theme) {
    return '現在: $theme';
  }

  @override
  String get settingsLanguage => '言語';

  @override
  String settingsLanguageCurrent(Object language) {
    return '現在: $language';
  }

  @override
  String get settingsChooseLanguage => '言語を選択';

  @override
  String get settingsLanguageApplied => '言語を適用しました';

  @override
  String get settingsSystemDefault => 'システム既定';

  @override
  String get settingsSectionCommunity => 'コミュニティに参加';

  @override
  String get settingsDiscord => 'Discord';

  @override
  String get settingsDiscordSubtitle => 'チャット、更新、フィードバック';

  @override
  String get settingsDiscordOpenFail => 'Discordリンクを開けませんでした';

  @override
  String get settingsSectionPro => 'プレミアム機能';

  @override
  String get settingsProCustomization => 'プレミアム カスタマイズ';

  @override
  String get settingsProSubtitle => '広告を削除し、無制限DNS、テーマ、アイコンを解放';

  @override
  String get settingsUnlockPro => 'プレミアムを解除';

  @override
  String get settingsProUnlocked => 'PROモードが解除されました';

  @override
  String get settingsPurchaseNotConfirmed => '購入を確認できませんでした';

  @override
  String settingsPurchaseFailed(Object error) {
    return '購入エラー: $error';
  }

  @override
  String get homeUpgrade => 'アップグレード';

  @override
  String get homeFeatureSecureVpnTitle => 'AvarionX VPN';

  @override
  String get homeFeatureSecureVpnDesc => 'IPを隠し、不要なコンテンツをブロック';

  @override
  String get proActivated => 'PROを有効化しました';

  @override
  String get proDeactivated => 'PROを無効化しました';

  @override
  String get settingsProReset => 'PROをリセット（デバッグのみ）';

  @override
  String get settingsProSheetTitle => 'プレミアム カスタマイズ';

  @override
  String get settingsHideGoldHeader => 'ホーム画面のゴールドヘッダーを表示（ダークテーマ）';

  @override
  String get settingsAppIcon => 'アプリアイコン';

  @override
  String settingsIconSelected(Object icon) {
    return '選択中のアイコン: $icon';
  }

  @override
  String get vpnSignInRequiredTitle => 'サインインが必要です';

  @override
  String get vpnClose => '閉じる';

  @override
  String get vpnSignInRequiredBody => 'Secure VPNを使うにはサインインしてください。';

  @override
  String get vpnCancel => 'キャンセル';

  @override
  String get vpnSignIn => 'サインイン';

  @override
  String get vpnUsageLoading => '使用量を読み込み中...';

  @override
  String get vpnUsageNoLimits => 'データ制限なし';

  @override
  String get vpnUsageSyncing => '同期中';

  @override
  String vpnUsageUsedThisMonth(Object used) {
    return '今月の使用量: $used';
  }

  @override
  String get vpnUsageDataTitle => 'データ使用量';

  @override
  String get vpnUsageUnavailable => '使用量を取得できません';

  @override
  String get vpnStatusConnectingEllipsis => '接続中...';

  @override
  String vpnStatusConnectedTo(Object country) {
    return '$country に接続中';
  }

  @override
  String get vpnTitleSecure => 'Secure VPN';

  @override
  String get vpnStatusConnected => '接続済み';

  @override
  String get vpnSubtitleEstablishingTunnel => 'トンネルを確立中...';

  @override
  String get vpnSubtitleFindingLocation => '場所を検索中...';

  @override
  String get vpnStatusProtected => '保護中';

  @override
  String get vpnStatusNotConnected => '未接続';

  @override
  String get vpnConnect => '接続';

  @override
  String get vpnDisconnect => '切断';

  @override
  String vpnIpLabel(Object ip) {
    return 'IP: $ip';
  }

  @override
  String vpnServerLoadLabel(Object current, Object max) {
    return '$current/$max';
  }

  @override
  String get vpnBlocklistsTitle => 'Secure VPN ブロックリスト';

  @override
  String get vpnSave => '保存';

  @override
  String get settingsSave => '保存';

  @override
  String get settingsPremium => 'プレミアム';

  @override
  String get settingsUltimateSecurity => '究極のセキュリティ';

  @override
  String get settingsSwitchPlan => 'プランを変更';

  @override
  String get settingsBestValue => '最もお得';

  @override
  String get settingsOneTime => '買い切り';

  @override
  String get settingsPlanPriceLoading => '価格を読み込み中...';

  @override
  String get settingsMonthly => '月額';

  @override
  String get settingsYearly => '年額';

  @override
  String get settingsLifetime => '永久';

  @override
  String get settingsSubscribeMonthly => '月額プランに登録';

  @override
  String get settingsSubscribeYearly => '年額プランに登録';

  @override
  String get settingsUnlockLifetime => '永久版を解除';

  @override
  String get settingsProBenefitsTitle => '特典';

  @override
  String get settingsUnlimitedDnsTitle => '無制限DNSクエリ';

  @override
  String get settingsUnlimitedDnsBody => 'クエリ上限を解除し、クラウド側のフルフィルタリングを利用できます。';

  @override
  String get settingsThemesTitle => 'テーマ';

  @override
  String get settingsThemesBody => 'プレミアムテーマとカスタマイズを解放します。';

  @override
  String get settingsIconCustomizationTitle => 'アイコンのカスタマイズ';

  @override
  String get settingsIconCustomizationBody => '好みに合わせてアプリアイコンを変更できます。';

  @override
  String get settingsScheduledScansTitle => 'スケジュールスキャン';

  @override
  String get settingsScheduledScansBody => '高度なスケジュール設定とスキャンのカスタマイズを解放します。';

  @override
  String get settingsProFinePrint =>
      'サブスクリプションは解約するまで自動更新されます。Google Playでいつでも管理または解約できます。永久版は買い切りです。';

  @override
  String get settingsSectionShizuku => '高度な保護（Shizuku）';

  @override
  String get settingsEnableShizuku => 'Shizukuを有効化';

  @override
  String get settingsShizukuRequiresManager => '外部マネージャーが必要';

  @override
  String get settingsShizukuNotRunning => 'Shizukuサービスが実行されていません';

  @override
  String get settingsShizukuPermissionRequired => '権限が必要';

  @override
  String get settingsShizukuAvailable => '高度なシステムアクセスが利用可能';

  @override
  String get settingsAboutAdvancedProtection => '高度な保護について';

  @override
  String get settingsAboutAdvancedProtectionSubtitle => '高度な保護の仕組みを学ぶ';

  @override
  String get settingsAdvancedProtectionDialogTitle => '高度なシステム保護';

  @override
  String get settingsAdvancedProtectionDialogBody =>
      'Shizukuアクセスには上級者向けの外部マネージャーが必要です。\n\nこの機能は任意であり、通常の保護用途には推奨されません。';

  @override
  String get settingsAboutShizukuTitle => 'Shizukuについて';

  @override
  String get settingsAboutShizukuBody =>
      'AVarionXはShizukuと連携し、システムレベルでアプリのプロセスへアクセスできます。\n\nこれによりアプリは次のことが可能になります:\n• 標準スキャナから隠れるマルウェアを検出\n• 実行中アプリのプロセスを検査\n• 多くのアクティブなマルウェアを無効化または封じ込め\n\nただし、Shizukuはroot権限を付与しません\n\nこの機能は上級者向けであり、通常の保護には不要です。\n\nドキュメント:\nhttps://shizuku.rikka.app';

  @override
  String get settingsSectionGeneral => '一般';

  @override
  String get settingsExclusions => '除外';

  @override
  String get settingsExclusionsSubtitle => '除外の管理と追加';

  @override
  String get settingsExcludeFolder => 'フォルダを除外';

  @override
  String get settingsExcludeFile => 'ファイルを除外';

  @override
  String get settingsManageExclusions => '既存の除外を管理';

  @override
  String get settingsManageExclusionsSubtitle => '除外を表示または削除';

  @override
  String get settingsFolderExcluded => 'フォルダを除外しました';

  @override
  String get settingsFileExcluded => 'ファイルを除外しました';

  @override
  String get settingsPrivacyPolicy => 'プライバシーポリシー';

  @override
  String get settingsPrivacyPolicySubtitle => 'データの扱い方を確認';

  @override
  String get settingsPrivacyPolicyOpenFail => 'プライバシーポリシーを開けませんでした';

  @override
  String get settingsAboutApp => 'AVarionXについて';

  @override
  String get settingsHowThisAppWorks => 'このアプリの仕組み';

  @override
  String get settingsHowThisAppWorksSubtitle => '保護の仕組みを学ぶ';

  @override
  String get settingsThemePickerTitle => 'テーマを選択';

  @override
  String get settingsThemeRequiresPro => 'このテーマにはPROモードが必要です';

  @override
  String get scheduledScansTitle => 'スケジュールスキャン';

  @override
  String get scheduledScansInfoTitle => 'スケジュールスキャン';

  @override
  String get scheduledScansInfoBody =>
      'RTPがダウンロードされたマルウェアに重点を置く一方、スケジュールスキャンは選択したスキャンモードをバックグラウンドで自動開始します。\nRTPが有効な場合にのみ実行されます。\n\nPROユーザーはモードと頻度をカスタマイズできます。';

  @override
  String get scheduledScansHeader => 'バックグラウンド自動スキャン';

  @override
  String get scheduledScansSubheader => 'RTPが有効な間、選択したモードと頻度に従って端末をスキャンします。';

  @override
  String get proRequiredToCustomize => 'カスタマイズにはPROが必要です';

  @override
  String get scheduledScansEnabledTitle => '有効';

  @override
  String get scheduledScansEnabledSubtitle =>
      '有効時、設定したスケジュールに従って自動でスキャンを実行します。';

  @override
  String get scheduledScansModeTitle => 'スキャンモード';

  @override
  String scheduledScansModeHint(Object mode) {
    return '現在のモード: $mode';
  }

  @override
  String get scheduledScansFrequencyTitle => '頻度';

  @override
  String scheduledScansFrequencyHint(Object freq) {
    return '実行: $freq';
  }

  @override
  String get scheduledEveryDay => '毎日';

  @override
  String get scheduledEvery3Days => '3日ごと';

  @override
  String get scheduledEveryWeek => '毎週';

  @override
  String get scheduledEvery2Weeks => '2週間ごと';

  @override
  String get scheduledEvery3Weeks => '3週間ごと';

  @override
  String get scheduledMonthly => '毎月';

  @override
  String scheduledEveryDays(Object days) {
    return '$days日ごと';
  }

  @override
  String scheduledEveryHours(Object hours) {
    return '$hours時間ごと';
  }

  @override
  String get vpnSettingsPrivacySecurityTitle => 'プライバシーとセキュリティ';

  @override
  String get vpnSettingsNoLogsPolicyTitle => 'ノーログポリシー';

  @override
  String get vpnSettingsNoLogsPolicyBody =>
      'ログは保存されません。接続アクティビティ、閲覧アクティビティ、DNSクエリ、トラフィック内容は記録または保持されません。';

  @override
  String get vpnSettingsNoActivityLogsTitle => 'アクティビティログなし';

  @override
  String get vpnSettingsNoActivityLogsBody =>
      'Secure VPN利用中のアクティビティは監視も追跡もされません。';

  @override
  String get vpnSettingsWireGuardTitle => 'VX-Link powered by WireGuard';

  @override
  String get vpnSettingsWireGuardBody =>
      'Secure VPNはVX-Link経由でWireGuardプロトコルを使用し、高速でモダンな暗号化を提供します。';

  @override
  String get vpnSettingsMalwareProtectionTitle => 'マルウェア保護が有効';

  @override
  String get vpnSettingsMalwareProtectionBody =>
      '接続中は悪意のあるドメインがデフォルトでブロックされます。';

  @override
  String get vpnSettingsAdTrackerProtectionTitle => '任意の広告・トラッカー保護';

  @override
  String get vpnSettingsAdTrackerProtectionBody =>
      '追加の広告およびトラッカーブロックは、カスタマイズタブで有効化できます。';

  @override
  String get vpnSettingsBrandFooter => 'VX-Link により保護';

  @override
  String get vpnSettingsAccountTitle => 'アカウント';

  @override
  String get vpnSettingsSignInToContinue => '続行するにはサインインしてください';

  @override
  String get vpnSettingsAccountSyncBody => 'プランとデータ使用量はアカウントと同期されます。';

  @override
  String get vpnSettingsSignedIn => 'サインイン済み';

  @override
  String get vpnSettingsPlanUnknown => 'プラン: 不明';

  @override
  String vpnSettingsPlanLabel(Object plan) {
    return 'プラン: $plan';
  }

  @override
  String get vpnSettingsRefresh => '更新';

  @override
  String get vpnSettingsSignOut => 'サインアウト';

  @override
  String get scheduledChargingOnlyTitle => '充電中のみ';

  @override
  String get scheduledChargingOnlySubtitle => '端末が充電中のときのみスケジュールスキャンを実行します。';

  @override
  String get scheduledPreferredTimeTitle => '希望時刻';

  @override
  String get scheduledPreferredTimeSubtitle =>
      'AVarionXはこの時刻の前後で開始を試みます。Androidが省電力のため遅延させる場合があります。';

  @override
  String get scheduledPickTime => '時刻を選択';

  @override
  String get cleanerTitle => 'Cleaner Pro';

  @override
  String get cleanerReadyToScan => 'スキャン準備完了';

  @override
  String get cleanerScan => 'スキャン';

  @override
  String get cleanerScanning => 'スキャン中…';

  @override
  String get cleanerReady => '準備完了';

  @override
  String get cleanerStatusReady => '準備完了';

  @override
  String get cleanerStatusStarting => '開始中…';

  @override
  String get cleanerStatusFilesScanned => 'ファイルをスキャン済み';

  @override
  String get cleanerStatusFindingUnusedApps => '未使用アプリを検索中…';

  @override
  String get cleanerStatusComplete => '完了';

  @override
  String get cleanerStatusScanError => 'スキャンエラー';

  @override
  String get cleanerStatusScanningApps => 'アプリをスキャン中…';

  @override
  String get cleanerGrantUsageAccessTitle => '使用状況アクセスを許可';

  @override
  String get cleanerGrantUsageAccessBody =>
      '未使用アプリを検出するには、このクリーナーに使用状況アクセス権限が必要です。有効化のためシステム設定へ移動します。';

  @override
  String get cleanerCancel => 'キャンセル';

  @override
  String get cleanerContinue => '続行';

  @override
  String get cleanerDuplicates => '重複';

  @override
  String get cleanerDuplicatesNone => '重複は見つかりませんでした';

  @override
  String cleanerDuplicatesSubtitle(Object count, Object size) {
    return '$count 件 • $size を回復';
  }

  @override
  String get cleanerOldPhotos => '古い写真';

  @override
  String cleanerOldPhotosNone(Object days) {
    return '$days日を超える写真はありません';
  }

  @override
  String cleanerOldPhotosSubtitle(Object count, Object size) {
    return '$count 件 • $size';
  }

  @override
  String get cleanerOldVideos => '古い動画';

  @override
  String cleanerOldVideosNone(Object days) {
    return '$days日を超える動画はありません';
  }

  @override
  String cleanerOldVideosSubtitle(Object count, Object size) {
    return '$count 件 • $size';
  }

  @override
  String get cleanerLargeFiles => '大きなファイル';

  @override
  String cleanerLargeFilesNone(Object size) {
    return '≥ $size のファイルはありません';
  }

  @override
  String cleanerLargeFilesSubtitle(Object count, Object sizeTotal) {
    return '$count 件 • $sizeTotal';
  }

  @override
  String get cleanerUnusedApps => '未使用アプリ';

  @override
  String cleanerUnusedAppsNone(Object days) {
    return '未使用アプリはありません（過去 $days 日）';
  }

  @override
  String cleanerUnusedAppsCount(Object count) {
    return '$count 個のアプリ';
  }

  @override
  String get cleanerStageDuplicates => '重複をスキャン中…';

  @override
  String get cleanerStageDuplicatesGrouping => '重複をグループ化中…';

  @override
  String get cleanerStageOldPhotos => '古い写真をスキャン中…';

  @override
  String get cleanerStageOldVideos => '古い動画をスキャン中…';

  @override
  String get cleanerStageLargeFiles => '大きなファイルをスキャン中…';

  @override
  String cleanerStageOldPhotosProgress(Object count, Object size) {
    return '古い写真: $count • $size';
  }

  @override
  String get vpnAccountScreenTitle => 'アカウント';

  @override
  String get vpnAccountSignInRequiredTitle => 'サインインが必要です';

  @override
  String get vpnAccountSignInManageUsageBody => 'アカウントと使用量を管理するにはサインインしてください。';

  @override
  String get vpnAccountNotSignedIn => '未サインイン';

  @override
  String get vpnAccountFree => '無料';

  @override
  String get vpnAccountUnknown => '不明';

  @override
  String get vpnAccountStatusSyncing => '同期中';

  @override
  String get vpnAccountStatusActive => '有効';

  @override
  String get vpnAccountStatusConnected => '接続済み';

  @override
  String get vpnAccountStatusDisconnected => '未接続';

  @override
  String get vpnAccountStatusUnavailable => '利用不可';

  @override
  String get vpnAccountStatusConnectedNow => '現在接続中';

  @override
  String get vpnAccountStatusRefreshToLoadServer => 'サーバー状態を読み込むには更新してください';

  @override
  String get vpnAccountUsageTitle => '使用量';

  @override
  String get vpnAccountUsageLoading => '使用量を読み込み中...';

  @override
  String get vpnAccountUsageSignInToSync => '同期するにはサインインしてください';

  @override
  String get vpnAccountUsagePullToRefresh => '下に引いて更新し、使用量を同期';

  @override
  String get vpnAccountUsageUnlimited => '無制限';

  @override
  String vpnAccountUsageUsedThisMonth(Object used) {
    return '今月の使用量: $used';
  }

  @override
  String vpnAccountUsageUsedThisMonthUnlimited(Object used) {
    return '今月の使用量: $used、無制限';
  }

  @override
  String vpnAccountUsageUsedOfLimit(Object used, Object limit) {
    return '$used / $limit';
  }

  @override
  String get settingsSectionAccount => 'アカウント';

  @override
  String get settingsAccountTitle => 'アカウント';

  @override
  String get settingsAccountSubtitle => 'サインイン、プラン、サブスクリプション、アカウント使用量';

  @override
  String get exploreSecureVpnTitle => 'Secure VPN';

  @override
  String get exploreSecureVpnSubtitle => 'IPを隠し、不要なコンテンツをブロック';

  @override
  String get vpnAccountServerLoadTitle => '選択中サーバーの負荷';

  @override
  String vpnAccountServerConnectedCount(Object connected, Object cap) {
    return '$connected/$cap';
  }

  @override
  String get networkDnsOffTitle => 'DNSフィルタリングに切り替えますか？';

  @override
  String get networkDnsOffInfoTitle => 'DNSフィルタリングとは？';

  @override
  String get networkDnsOffInfoBody1 =>
      'DNSフィルタリングはSecure VPNとは別機能です。既知のマルウェア、アプリ内広告、トラッカー、不要なカテゴリを読み込み前にブロックできます。';

  @override
  String get networkDnsOffInfoBody2 => '通信を暗号化したり、IPを隠したりはしません。';

  @override
  String get networkDnsOffEnableButton => 'DNSフィルタリングを有効化';

  @override
  String vpnAccountServerConnectedCountWithLabel(Object connected, Object cap) {
    return '$connected/$cap 接続中';
  }

  @override
  String get vpnAccountIdentityFallbackTitle => 'アカウント';

  @override
  String get vpnAccountMembershipLabel => 'メンバーシップ';

  @override
  String get vpnAccountMembershipFounderVpnPro => 'Founder ・ VPN Pro';

  @override
  String get vpnAccountMembershipFounder => 'Founder';

  @override
  String get vpnAccountMembershipPro => 'Pro';

  @override
  String get vpnAccountSectionAccountStatus => 'アカウント状態';

  @override
  String get vpnAccountSectionActions => '操作';

  @override
  String get vpnAccountKvStatus => '状態';

  @override
  String get vpnAccountKvPlan => 'プラン';

  @override
  String get vpnAccountKvUsage => '使用量';

  @override
  String get vpnAccountKvSelectedServer => '選択中サーバー';

  @override
  String get vpnAccountKvConnectionState => '接続状態';

  @override
  String get vpnAccountActionRefresh => '更新';

  @override
  String get vpnAccountActionOpen => '開く';

  @override
  String get vpnAccountFounderThanks => 'ColourSwiftを支えてくれてありがとうございます';

  @override
  String get vpnAccountFounderNote => '一人で作っていますが、最高のコミュニティに支えられています。';

  @override
  String cleanerStageOldVideosProgress(Object count, Object size) {
    return '古い動画: $count • $size';
  }

  @override
  String cleanerStageLargeFilesProgress(Object count, Object size) {
    return '大きなファイル: $count • $size';
  }

  @override
  String get unusedAppsTitle => '未使用アプリ';

  @override
  String unusedAppsEmpty(Object days) {
    return '過去 $days 日に未使用アプリはありません';
  }

  @override
  String get quarantineTitle => '削除済み';

  @override
  String get quarantineSelectAll => 'すべて選択';

  @override
  String get quarantineRefresh => '更新';

  @override
  String get quarantineEmptyTitle => '削除済みファイルはありません';

  @override
  String get quarantineEmptyBody => '削除したものはここに表示されます。';

  @override
  String get quarantineRestore => '復元';

  @override
  String get quarantineDelete => '削除';

  @override
  String get quarantineSnackRestored => '復元しました';

  @override
  String get quarantineSnackDeleted => '削除しました';

  @override
  String get quarantineDeleteDialogTitle => '選択したファイルを削除しますか？';

  @override
  String quarantineDeleteDialogBody(Object count, Object plural) {
    return '$count 件の項目を完全に削除します。';
  }
}
