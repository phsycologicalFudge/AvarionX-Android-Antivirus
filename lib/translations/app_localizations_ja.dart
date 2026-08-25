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
  String get companionAppsSectionTitle => 'AvarionX のその他のアプリ';

  @override
  String get cleanerReclaimableLabel => '解放可能';

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
  String get engineReadyBanner => 'VX-TITANIUM-v9';

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
  String quarantineDeleteDialogBody(Object count, String plural) {
    String _temp0 = intl.Intl.selectLogic(
      plural,
      {
        's': '',
        'other': '',
      },
    );
    return '$count 件の項目を完全に削除します。$_temp0';
  }

  @override
  String get howThisAppWorksHowAvarionXWorks => 'AvarionX の仕組み';

  @override
  String get howThisAppWorksAvarionxIsAMobileSecurityAppThat =>
      'AvarionX は、端末上のウイルススキャン、ネットワーク保護、オプションの VPN 機能を組み合わせたモバイルセキュリティアプリです。 ';

  @override
  String get howThisAppWorksTheAntivirusEngineIsPoweredByVX =>
      'ウイルス対策エンジンには VX-Titanium が使用されています。';

  @override
  String get howThisAppWorksIfYouUseNetworkProtectionOrVPN =>
      'ネットワーク保護または VPN 機能を使用する場合、アプリは ColourSwift のサービスに接続して設定を適用し、アカウントへのアクセスを管理し、保護された通信をルーティングします。';

  @override
  String get howThisAppWorksKeyFeatures => '主な機能';

  @override
  String get howThisAppWorksRealTimeProtectionForDownloadedThreats =>
      '• ダウンロードされた脅威に対するリアルタイム保護';

  @override
  String get howThisAppWorksNetworkProtectionWithDNSFiltering =>
      '• DNS フィルタリングによるネットワーク保護';

  @override
  String get howThisAppWorksOptionalSecureVPNMode => '• オプションの Secure VPN モード';

  @override
  String get howThisAppWorksBuiltInToolsSuchAsLinkChecker =>
      '• Link Checker などの内蔵ツール';

  @override
  String get howThisAppWorksNotes => '注意事項';

  @override
  String get howThisAppWorksSomeFeaturesMayRequireSignInAn =>
      '一部の機能を正常に使用するには、サインイン、有効なプラン、または端末の権限が必要な場合があります。';

  @override
  String get apkAnalyserCopyCurrentReport => '現在のレポートをコピー';

  @override
  String get apkAnalyserReportCopiedToClipboard => 'レポートをクリップボードにコピーしました';

  @override
  String get apkAnalyserExportCurrentAsPDF => '現在のレポートを PDF としてエクスポート';

  @override
  String get apkAnalyserFailedToExportPDF => 'PDF のエクスポートに失敗しました';

  @override
  String get apkAnalyserExportCurrentAsCSV => '現在のレポートを CSV としてエクスポート';

  @override
  String get apkAnalyserFailedToExportCSV => 'CSV のエクスポートに失敗しました';

  @override
  String get apkAnalyserViewSavedReports => '保存済みレポートを表示';

  @override
  String get apkAnalyserClearHistory => '履歴を消去';

  @override
  String get apkAnalyserReportHistoryCleared => 'レポート履歴を消去しました';

  @override
  String get apkAnalyserSavedReports => '保存済みレポート';

  @override
  String get apkAnalyserNoSavedReportsFound => '保存済みレポートはありません。';

  @override
  String get apkAnalyserChooseTarget => '対象を選択';

  @override
  String get apkAnalyserSelectASourceToAnalyseWithVTTI =>
      'VTTI Cloud で解析するソースを選択してください。';

  @override
  String get apkAnalyserApkFile => 'APK ファイル';

  @override
  String get apkAnalyserPickAnApkFromStorage => 'ストレージから .apk を選択';

  @override
  String get apkAnalyserInstalledApp => 'インストール済みアプリ';

  @override
  String get apkAnalyserChooseFromAppsOnThisDevice => 'この端末のアプリから選択';

  @override
  String apkAnalyserAnalysingIn(Object countdown) {
    return '$countdown 後に解析...';
  }

  @override
  String get apkAnalyserStartingAnalysis => '解析を開始しています...';

  @override
  String get apkAnalyserApkFileOrInstalledApp => 'APK ファイルまたはインストール済みアプリ';

  @override
  String get apkAnalyserDeepAnalysisMode => '詳細解析モード';

  @override
  String get apkAnalyserAMoreComplexAnalysisUsingGlobalData =>
      'グローバルなデータソースを使用する、より高度な解析';

  @override
  String get apkAnalyserRequiresProToUnlockDeeperAnalysis =>
      'より詳細な解析を利用するには Pro が必要です';

  @override
  String get apkAnalyserApkAnalyser => 'APK 解析';

  @override
  String get apkAnalyserPleaseSignInViaSettingsToEnable =>
      'Cloud Analysis を有効にするには、設定からサインインしてください。';

  @override
  String get apkAnalyserAdvancedOPTIONS => '詳細オプション';

  @override
  String apkAnalyserDailyLimit(Object remaining, Object limit) {
    return '1 日の上限: $remaining / $limit';
  }

  @override
  String get apkAnalyserDailyLimitDataUnavailable => '1 日の上限データを利用できません';

  @override
  String get apkAnalyserPoweredByVTTICloud => 'VTTI Cloud 搭載';

  @override
  String get apkAnalyserSearchApps => 'アプリを検索...';

  @override
  String get apkAnalyserFailedToLoadApps => 'アプリの読み込みに失敗しました。';

  @override
  String get apkAnalyserNoAppsFound => 'アプリが見つかりません。';

  @override
  String get apkReportSummary => '概要';

  @override
  String get apkReportPermissions => '権限';

  @override
  String get apkReportExtraFlags => '追加フラグ';

  @override
  String get apkReportRiskSignals => 'リスクシグナル';

  @override
  String get apkReportSources => 'ソース';

  @override
  String get apkReportMetadata => 'メタデータ';

  @override
  String get apkReportCopyReport => 'レポートをコピー';

  @override
  String get apkReportReportCopiedToClipboard => 'レポートをクリップボードにコピーしました';

  @override
  String get apkReportExportAsPDF => 'PDF としてエクスポート';

  @override
  String get apkReportFailedToExportPDF => 'PDF のエクスポートに失敗しました';

  @override
  String get apkReportExportAsCSV => 'CSV としてエクスポート';

  @override
  String get apkReportFailedToExportCSV => 'CSV のエクスポートに失敗しました';

  @override
  String get apkReportAnalysisReport => '解析レポート';

  @override
  String get apkReportMalwareRisk => 'マルウェアリスク';

  @override
  String get apkReportNoSummaryGenerated => '概要は生成されませんでした。';

  @override
  String get apkReportNoRequestedPermissionsExtracted => '要求された権限は抽出されませんでした。';

  @override
  String get apkReportContributing => 'リスク増加要因';

  @override
  String get apkReportDampening => 'リスク軽減要因';

  @override
  String get bootOptimisingYourProtection => '保護を最適化しています';

  @override
  String get exclusionsFolders => 'フォルダー';

  @override
  String get exclusionsNone => 'なし';

  @override
  String get exclusionsFiles => 'ファイル';

  @override
  String get exploreApkAnalyser => 'APK 解析';

  @override
  String get exploreCreateADetailedAnalysisOnAnyAPK => '任意の APK を詳細に解析';

  @override
  String get featuresComingSoon => '近日公開';

  @override
  String get featuresWantToLearnMore => '詳しく知りたいですか？';

  @override
  String get homeDrawerApkAnalyser => 'APK 解析';

  @override
  String get homeDrawerAdvanced => '詳細設定';

  @override
  String get homeDrawerQuarantine => '隔離';

  @override
  String get homeDrawerUpgradeToPro => 'Pro にアップグレード';

  @override
  String get homeDrawerAvarionxVPN => 'AvarionX VPN';

  @override
  String get homeDrawerProtectYourInternetWithOurUnlimitedVPN =>
      '無制限 VPN でインターネット接続を保護';

  @override
  String get deviceSecurityDeviceSecurity => '端末のセキュリティ';

  @override
  String get deviceSecurityDeviceHealthStatus => '端末のセキュリティ状態';

  @override
  String get deviceSecurityDeviceSecurityRecommendations => '端末のセキュリティに関する推奨事項';

  @override
  String get deviceSecurityStopIgnoring => '無視を解除';

  @override
  String get deviceSecurityIgnoreCheck => 'チェックを無視';

  @override
  String get deviceSecurityNoScreenLock => '画面ロックなし';

  @override
  String get deviceSecurityAMissingSecureLockMakesLocalAccess =>
      '安全なロックがないと、端末への直接アクセスが容易になります。';

  @override
  String get deviceSecurityRootShizukuActive => 'Root/Shizuku が有効';

  @override
  String get deviceSecurityRootOrShizukuCanGrantPowerfulDevice =>
      'Root または Shizuku は端末を強力に制御できる権限を与える場合があります。';

  @override
  String get deviceSecurityDisabledAppVerification => 'アプリの検証が無効';

  @override
  String get deviceSecurityAppVerificationHelpsDetectHarmfulInstalls =>
      'アプリの検証は、有害なインストールの検出に役立ちます。';

  @override
  String get deviceSecurityOldAndroidSecurityPatch => '古い Android セキュリティパッチ';

  @override
  String get deviceSecurityOlderPatchLevelsMayLeaveKnownIssues =>
      '古いパッチレベルでは、既知の問題が未修正のまま残る可能性があります。';

  @override
  String get deviceSecurityDeveloperModeOn => '開発者モードが有効';

  @override
  String get deviceSecurityDeveloperOptionsExposeAdvancedDeviceControls =>
      '開発者向けオプションでは高度な端末制御が利用できます。';

  @override
  String get deviceSecurityUsbDebuggingOn => 'USB デバッグが有効';

  @override
  String get deviceSecurityUsbDebuggingAllowsADBControlFromTrusted =>
      'USB デバッグでは、信頼できるコンピューターから ADB で端末を制御できます。';

  @override
  String get deviceSecurityUnknownSourcesAllowed => '提供元不明のアプリを許可';

  @override
  String get deviceSecuritySideloadingCanBypassNormalAppStoreChecks =>
      'サイドロードでは通常のアプリストアのチェックを回避できる場合があります。';

  @override
  String get deviceSecurityAccessibilityAbuseRisk => 'ユーザー補助機能の悪用リスク';

  @override
  String get deviceSecurityAccessibilityServicesCanReadAndControlScreen =>
      'ユーザー補助サービスは画面内容を読み取り、画面上の操作を制御できます。';

  @override
  String get homeHelpImproveDetectionsForEverybody => 'みんなの検出精度向上にご協力ください';

  @override
  String get homeApkSAndroidAppsFoundToBe => '悪意があると判定された APK（Android アプリ）は ';

  @override
  String get homeCanBeUploadedTo => '次の場所にアップロードされ、';

  @override
  String get homeAndSharedWithTheCommunityThisIs => 'コミュニティと共有できます。対象は ';

  @override
  String get homeStrictlyLimitedToAPKFilesNOTYour => 'APK ファイルのみに厳密に限定され、個人の ';

  @override
  String get homeDocuments => 'ドキュメントは対象になりません。\n\n';

  @override
  String get homeThisWillImproveDetectionsForEveryoneThat =>
      'これにより、AvarionX を ';

  @override
  String get homeUsesAvarionXNoPressureThough =>
      '利用するすべての人の検出精度が向上します。もちろん強制ではありません！\n\n';

  @override
  String get homeThanks => 'ありがとうございます。\n';

  @override
  String get homeRyanfromcolourswift => 'RyanFromColourswift';

  @override
  String get homeSure => '協力する！';

  @override
  String get homeNoThanks => 'いいえ';

  @override
  String get homePsstCustomiseItHere => 'ここでカスタマイズできます';

  @override
  String get homeScanNow => '今すぐスキャン';

  @override
  String get homeManuallyCheckYourDeviceForMalware => '端末を手動でマルウェアチェック';

  @override
  String get homeDeviceSecurity => '端末のセキュリティ';

  @override
  String get homeScanModes => 'スキャンモード';

  @override
  String get homeCloudAssistedChecksEnabled => 'クラウド支援チェックが有効';

  @override
  String get homeLocalScanEngineOnly => 'ローカルスキャンエンジンのみ';

  @override
  String get homeProtectedByVXTITANIUM => 'VX-TITANIUM による保護';

  @override
  String get homeSecurityOverview => 'セキュリティ概要';

  @override
  String get homeFilesChecked => 'チェック済みファイル';

  @override
  String get homeThreats => '脅威';

  @override
  String get securityReportAvarionxSecurityReport => 'Avarionx セキュリティレポート';

  @override
  String get securityReportSecurityReport => 'セキュリティレポート';

  @override
  String get securityReportManualScans => '手動スキャン';

  @override
  String get securityReportRealtimeChecks => 'リアルタイムチェック';

  @override
  String get securityReportTotalFilesScanned => 'スキャンしたファイル総数';

  @override
  String get securityReportThreatsFound => '検出された脅威';

  @override
  String get securityReportGenerateReport => 'レポートを生成';

  @override
  String get securityReportLiveReport => 'ライブレポート';

  @override
  String get securityReportThisBoxUpdatesAsScanServicesWrite =>
      'スキャンサービスがレポートデータを書き込むと、この欄が更新されます。';

  @override
  String get securityReportExportPDF => 'PDF をエクスポート';

  @override
  String get securityReportExportCSV => 'CSV をエクスポート';

  @override
  String get homeLegacyProActivated => 'Pro が有効になりました';

  @override
  String get homeLegacyProDeactivated => 'Pro が無効になりました';

  @override
  String get linkCheckPoweredByVTTICloud => 'VTTI Cloud 搭載';

  @override
  String get safeViewSafeView => 'Safe View';

  @override
  String get passwordSettingsChangingThisAltersAllPasswords =>
      'これを変更すると、すべてのパスワードが変わります。\n';

  @override
  String get passwordSettingsUsingTheSameMetaPassRestoresThem =>
      '同じ MetaPass を使うと復元できます。';

  @override
  String get passwordSettingsPasswordsAreNeverStored =>
      'パスワードが保存されることはありません。\n\n';

  @override
  String get passwordSettingsTheRestoreCodeContainsOnlyStructureData =>
      '復元コードには構造データのみが含まれます。 ';

  @override
  String get passwordSettingsCombinedWithYourMetaPassItRebuildsYour =>
      'MetaPass と組み合わせることで、保管庫を再構築できます。';

  @override
  String get passwordManagerContinue => '続行';

  @override
  String passwordManagerFailedToLoadApps(Object e) {
    return 'アプリの読み込みに失敗しました: $e';
  }

  @override
  String passwordManagerFailedToGeneratePassword(Object e) {
    return 'パスワードの生成に失敗しました: $e';
  }

  @override
  String get passwordManagerPasswordsAreNeverStored =>
      'パスワードが保存されることはありません。\n\n';

  @override
  String get passwordManagerEachEntryDerivesAPasswordFrom =>
      '各エントリのパスワードは次の情報から生成されます:\n';

  @override
  String get passwordManagerYourMetaPassword => '• メタパスワード\n';

  @override
  String get passwordManagerTheLabelName => '• ラベル名\n';

  @override
  String get passwordManagerTheVersionAndLength => '• バージョンと長さ\n\n';

  @override
  String get passwordManagerReinstallingTheAppWithTheSameMeta =>
      '同じメタパスワードとラベルでアプリを再インストールすると、同じパスワードが再生成されます。';

  @override
  String get permissionsIntroSetupIsNowCompleteTimeToSecure =>
      'セットアップが完了しました！データを保護しましょう。';

  @override
  String get proScreenThankYou => 'ありがとうございます';

  @override
  String get proScreenYourSubscriptionIsConfirmed => 'サブスクリプションが確認されました。';

  @override
  String get proScreenCurrent => '現在';

  @override
  String get proScreenAdvancedStealthMode => '高度な Stealth+ モード';

  @override
  String get proScreenUnlockStealthTransportModesForRestrictiveNetworks =>
      '制限の厳しいネットワーク向けのステルス通信モードを利用できます。';

  @override
  String get proScreenGlobalServerAccess => 'グローバルサーバーアクセス';

  @override
  String get proScreenAccessEveryVPNServerLocationIncludingPremium =>
      '高速なプレミアム地域を含む、すべての VPN サーバー拠点を利用できます。';

  @override
  String get proScreenBilledMonthly => '月払い';

  @override
  String proScreenMo(Object monthlyInfo) {
    return '$monthlyInfo/月';
  }

  @override
  String proScreenMo2(Object currencyCode) {
    return '$currencyCode/月';
  }

  @override
  String get proScreenCurrentPlan => '現在のプラン';

  @override
  String get quarantineScreenQuarantineDataCorruptedResetting =>
      '隔離データが破損しています。リセットしています。';

  @override
  String get quarantineScreenUninstallApp => 'アプリをアンインストール';

  @override
  String quarantineScreenUninstall(Object appName) {
    return '$appName をアンインストールしますか？';
  }

  @override
  String get quarantineScreenUninstall2 => 'アンインストール';

  @override
  String get quarantineScreenFailedToLaunchUninstall => 'アンインストールを開始できませんでした';

  @override
  String get quarantineScreenFiles => 'ファイル';

  @override
  String get cleanerAppManagerShizukuNotAvailable => 'Shizuku を利用できません';

  @override
  String get cleanerAppManagerWithoutShizukuEachAppRequiresASeparate =>
      'Shizuku がない場合、アプリごとに個別のシステム確認が必要です。続行しますか？';

  @override
  String cleanerAppManagerAppsUninstalled(Object successCount) {
    return '$successCount 個のアプリをアンインストールしました';
  }

  @override
  String cleanerAppManagerUninstalledFailed(
      Object successCount, Object failedCount) {
    return '$successCount 個をアンインストール、$failedCount 個は失敗';
  }

  @override
  String cleanerAppManagerStopped(Object appName) {
    return '$appName を停止しました';
  }

  @override
  String get cleanerAppManagerForceStopFailed => '強制停止に失敗しました';

  @override
  String get cleanerAppManagerClearAppData => 'アプリデータを消去';

  @override
  String cleanerAppManagerResetThisClearsItsAccountsSettingsFiles(
      Object appName) {
    return '$appName をリセットしますか？アカウント、設定、ファイル、キャッシュが消去されます。';
  }

  @override
  String get cleanerAppManagerClearData => 'データを消去';

  @override
  String cleanerAppManagerReset(Object appName) {
    return '$appName をリセットしました';
  }

  @override
  String get cleanerAppManagerClearDataFailed => 'データの消去に失敗しました';

  @override
  String get cleanerAppManagerOpenApp => 'アプリを開く';

  @override
  String get cleanerAppManagerForceStop => '強制停止';

  @override
  String get cleanerAppManagerUninstall => 'アンインストール';

  @override
  String cleanerAppManagerSelected(Object selectedCount) {
    return '$selectedCount 件選択';
  }

  @override
  String get cleanerAppManagerAppManager => 'アプリマネージャー';

  @override
  String get cleanerAppManagerDeselectAll => 'すべて選択解除';

  @override
  String cleanerAppManagerUninstalling(Object done, Object total) {
    return 'アンインストール中 $done / $total…';
  }

  @override
  String cleanerAppManagerUninstall2(Object selectedCount) {
    return '$selectedCount 件をアンインストール';
  }

  @override
  String get cleanerProClearAppCaches => 'アプリキャッシュを消去';

  @override
  String get cleanerProThisAsksAndroidToTrimAppCaches =>
      'Android に端末全体のアプリキャッシュの削減を要求します。アプリデータ、アカウント、設定は消去されません。';

  @override
  String get cleanerProClearCaches => 'キャッシュを消去';

  @override
  String get cleanerProCacheTrimRequested => 'キャッシュ削減を要求しました';

  @override
  String get cleanerProCacheCleanerFailed => 'キャッシュのクリーンアップに失敗しました';

  @override
  String get cleanerProLogFiles => 'ログファイル';

  @override
  String get cleanerProCacheCleaner => 'キャッシュクリーナー';

  @override
  String get cleanerProLogCleaner => 'ログクリーナー';

  @override
  String get cleanerProAppDataManager => 'アプリデータマネージャー';

  @override
  String get cleanerScreenCleaner => 'クリーナー';

  @override
  String get scanDetailDeleteFiles => 'ファイルを削除';

  @override
  String scanDetailDeleteFilesPermanently(Object selectedCount) {
    return '$selectedCount 個のファイルを完全に削除しますか？';
  }

  @override
  String get scanDetailSelectedFilesDeleted => '選択したファイルを削除しました';

  @override
  String get scanDetailDeleteAllFiles => 'すべてのファイルを削除';

  @override
  String scanDetailDeleteAllFilesPermanently(Object fileCount) {
    return '$fileCount 個のファイルをすべて完全に削除しますか？';
  }

  @override
  String get scanDetailDeleteAll => 'すべて削除';

  @override
  String get scanDetailAllFilesDeleted => 'すべてのファイルを削除しました';

  @override
  String scanDetailSelected(Object selectedCount) {
    return '$selectedCount 件選択';
  }

  @override
  String get scanDetailDeselectAll => 'すべて選択解除';

  @override
  String get scanDetailNewestFirst => '新しい順';

  @override
  String get scanDetailOldestFirst => '古い順';

  @override
  String get scanDetailLargestFirst => '大きい順';

  @override
  String get scanDetailSmallestFirst => '小さい順';

  @override
  String get scanDetailNoFilesFound => 'ファイルが見つかりません';

  @override
  String get scanDetailDeleteAll2 => 'すべて削除';

  @override
  String get scanInstalledAppsSearchApps => 'アプリを検索...';

  @override
  String get scanInstalledAppsNoAppsFound => 'アプリが見つかりません。';

  @override
  String get scanUiScanComplete => 'スキャン完了';

  @override
  String scanUiScannedItems(Object scanned) {
    return 'スキャン済み: $scanned 項目';
  }

  @override
  String scanUiProgress(Object pct, Object scanned, Object total) {
    return '進行状況: $pct ($scanned / $total)';
  }

  @override
  String get scanUiPreparingEngine => 'エンジンを準備しています...';

  @override
  String get scanUiLoadingTargetS => '対象を読み込んでいます';

  @override
  String get scanUiAvarionxVPN => 'AvarionX VPN';

  @override
  String get scanUiProtectYourInternetWithOurUnlimitedVPN =>
      '無制限 VPN でインターネット接続を保護';

  @override
  String get scanUiTapMe => 'タップ！';

  @override
  String scanUiScanned(Object scanned) {
    return '$scanned 件スキャン済み';
  }

  @override
  String get scanUiReturn => '戻る';

  @override
  String get scanLimitsSettingsUpdated => '設定を更新しました';

  @override
  String get scanLimitsScanLimits => 'スキャン制限';

  @override
  String get scanLimitsLimitHowMuchTheEngineUsesYour =>
      'エンジンが使用する CPU 量を制限します。スレッド数が 0 の場合は自動です。';

  @override
  String get scanLimitsMaxScanThreads => '最大スキャンスレッド数';

  @override
  String scanLimits0AutoRange0ToCores(Object maxThreads, Object coreCount) {
    return '0 = 自動。範囲: 0～$maxThreads（コア数: $coreCount）。';
  }

  @override
  String scanLegacyScanning(Object percent) {
    return 'スキャン中... $percent%';
  }

  @override
  String scanLegacySuspicious(Object infectedCount) {
    return '疑わしい: $infectedCount';
  }

  @override
  String scanLegacyClean(Object cleanCount) {
    return '安全: $cleanCount';
  }

  @override
  String get scanLegacyNoFilesToScan => 'スキャンするファイルがありません';

  @override
  String get settingsSponsorsUnlock => 'スポンサー特典で解除 ❤️';

  @override
  String get settingsPickCertificate => '証明書を選択';

  @override
  String get settingsCertificateLoaded => '証明書を読み込みました';

  @override
  String get settingsEnterCode => 'コードを入力';

  @override
  String get settingsSupportFileMissing => 'サポートファイルがありません';

  @override
  String get settingsInvalidSupportCode => '無効なサポートコード';

  @override
  String get settingsAvarionxSecurity => 'AvarionX Security';

  @override
  String get settingsAvarionxIsAMobileSecuritySuiteCreated =>
      'AvarionX は、英国バーミンガムを拠点とする ColourSwift が開発したモバイルセキュリティスイートです。\n\n';

  @override
  String get settingsContact => '連絡先: ';

  @override
  String get settingsExperimentalFeatures => '試験的機能';

  @override
  String get settingsEnablingShizukuUnlocksExperimentalWorkInProgress =>
      'Shizuku を有効にすると、開発中の試験的機能を利用できます:\n\n';

  @override
  String get settingsAdvancedRansomwareProtection => '• 高度なランサムウェア保護\n';

  @override
  String get settingsCacheCleanerPlus => '• Cache Cleaner Plus\n\n';

  @override
  String get settingsExperimentalWarning => '試験的機能に関する注意:\n';

  @override
  String get settingsTheseFeaturesUseAdvancedSystemAccessAnd =>
      'これらの機能は高度なシステムアクセスを使用するため、端末、Android のバージョン、Shizuku の設定によって動作が異なる場合があります。一部の操作は、通常のスキャンよりも実行中のアプリ、ファイル、キャッシュデータへ直接影響する可能性があります。\n\n';

  @override
  String get settingsOnlyEnableThisIfYouUnderstandShizuku =>
      'Shizuku を理解しており、この機能がまだテスト中であることを承知し、重要なデータをバックアップ済みの場合にのみ有効にしてください。\n\n';

  @override
  String get settingsPleaseReadTheDocumentationBeforeEnabling =>
      '有効にする前にドキュメントをお読みください。';

  @override
  String get settingsEnable => '有効にする';

  @override
  String get settingsSigningOut => 'サインアウトしています...';

  @override
  String get settingsCheckingAccountStatus => 'アカウント状態を確認しています...';

  @override
  String get settingsManageSignInPremiumAndPurchases => 'サインイン、Premium、購入を管理';

  @override
  String get settingsPremiumActive => 'Premium 有効';

  @override
  String get settingsManagePremiumOptionsAndRestorePurchases =>
      'Premium オプションの管理と購入の復元';

  @override
  String get settingsUnlockDeepAnalysisModeAndVPNFeatures =>
      '詳細解析モードと VPN 機能を解除';

  @override
  String get settingsAutoClearNotifications => '通知を自動消去';

  @override
  String get settingsScanModes => 'スキャンモード';

  @override
  String get settingsAdvancedScanModes => '高度なスキャンモード';

  @override
  String get settingsDisableToUseTheDefaultScanningMode =>
      '無効にすると既定のスキャンモードを使用します';

  @override
  String get settingsToggleToEnableAllScanningModes =>
      'オンにするとすべてのスキャンモードを利用できます';

  @override
  String get settingsApkSubmissions => 'APK の送信';

  @override
  String get settingsShareMaliciousAPKs => '悪意のある APK を共有';

  @override
  String get settingsHelpingImproveDetectionForEveryone =>
      'すべてのユーザーの検出精度向上に役立ちます';

  @override
  String get settingsOff => 'オフ';

  @override
  String get settingsIncludeRealtimeProtectionCatches => 'リアルタイム保護の検出結果を含める';

  @override
  String get settingsApksFlaggedByRealtimeProtectionAreIncluded =>
      'リアルタイム保護で検出された APK を含めます';

  @override
  String get settingsApksFlaggedByRealtimeProtectionAreExcluded =>
      'リアルタイム保護で検出された APK を除外します';

  @override
  String get settingsIncludeManualAndScheduledScans => '手動スキャンとスケジュールスキャンを含める';

  @override
  String get settingsApksFlaggedByScansAreIncluded => 'スキャンで検出された APK を含めます';

  @override
  String get settingsApksFlaggedByScansAreExcluded => 'スキャンで検出された APK を除外します';

  @override
  String get settingsWiFiOnly => 'Wi-Fi のみ';

  @override
  String get settingsUploadsWaitForAWiFiConnection => 'アップロードは Wi-Fi 接続まで待機します';

  @override
  String get settingsUploadsMayUseMobileData => 'アップロードにモバイルデータ通信を使用する場合があります';

  @override
  String get settingsChargingOnly => '充電中のみ';

  @override
  String get settingsUploadsWaitUntilTheDeviceIsCharging =>
      '端末が充電中になるまでアップロードを待機します';

  @override
  String get settingsUploadsAreNotLimitedToCharging => 'アップロードは充電中に限定されません';

  @override
  String get settingsChooseWhichAppsUpload => 'アップロードするアプリを選択';

  @override
  String get settingsReviewAndPickAppsEachTimeBefore => 'アップロード前に毎回アプリを確認して選択';

  @override
  String get settingsFlaggedAppsUploadAutomatically => '検出されたアプリを自動的にアップロード';

  @override
  String get settingsEnableProDebug => 'Pro を有効化（デバッグ）';

  @override
  String get settingsLocalUnlockForUITesting => 'UI テスト用のローカル解除';

  @override
  String get settingsRestorePurchases => '購入を復元';

  @override
  String get settingsReCheckPlayBilling => 'Play Billing を再確認';

  @override
  String get settingsCheckingAccount => 'アカウントを確認しています...';

  @override
  String get settingsAvarionxAccountConnected => 'AvarionX アカウント接続済み';

  @override
  String settingsAccountID(Object accountId) {
    return 'アカウント ID: $accountId';
  }

  @override
  String get settingsSignInToManagePurchasesAndAccount =>
      '購入とアカウント機能を管理するにはサインインしてください。';

  @override
  String get settingsOpenTheAvarionXAccountPortal => 'AvarionX アカウントポータルを開く';

  @override
  String get settingsAccountDashboard => 'アカウントダッシュボード';

  @override
  String get settingsOpenBillingAndAccountSettings => '請求とアカウント設定を開く';

  @override
  String get settingsRemoveThisAccountFromTheApp => 'このアカウントをアプリから削除';

  @override
  String get settingsPremiumFeaturesAreAvailableOnThisDevice =>
      'この端末では Premium 機能を利用できます';

  @override
  String get settingsViewOptionalPremiumFeatures => 'オプションの Premium 機能を表示';

  @override
  String get settingsReCheckPlayBillingEntitlement => 'Play Billing の利用資格を再確認';

  @override
  String get settingsRtpNotificationAutoClearNotifications => '通知を自動消去';

  @override
  String get settingsRtpNotificationNever => 'しない';

  @override
  String get settingsRtpNotification5Minutes => '5 分';

  @override
  String get settingsRtpNotification10Minutes => '10 分';

  @override
  String get settingsRtpNotification30Minutes => '30 分';

  @override
  String get settingsThemeBlack => 'ブラック';

  @override
  String get settingsThemeWhite => 'ホワイト';

  @override
  String get settingsThemeGrey => 'グレー';

  @override
  String get settingsThemeEmerald => 'エメラルド';

  @override
  String get settingsThemePurple => 'パープル';

  @override
  String get settingsThemeRoyalBlue => 'ロイヤルブルー';

  @override
  String get settingsAccountCardSyncPurchasesAndUnlockProAcrossApps =>
      '購入を同期し、各アプリで Pro を解除します。';

  @override
  String get settingsAccountCardLoading => '読み込み中...';

  @override
  String get settingsAccountCardDashboard => 'ダッシュボード';

  @override
  String get settingsProCardChangePlan => 'プランを変更';

  @override
  String get advancedNetworkProtectionEnterYourOwnResolver => '独自のリゾルバーを入力';

  @override
  String get advancedNetworkProtectionCloudProtectionMode => 'クラウド保護モード';

  @override
  String get advancedNetworkProtectionRoutesAllDNSQueriesToTheCloud =>
      'すべての DNS クエリをクラウドエンジンにルーティングし、ブロックリストのリアルタイム更新、ドメイン評価の確認などを有効にします。';

  @override
  String get advancedNetworkProtectionRefreshProStatus => 'Pro の状態を更新';

  @override
  String get advancedNetworkProtectionProActive => 'Pro 有効';

  @override
  String get advancedNetworkProtectionFreePlan => '無料プラン';

  @override
  String get advancedNetworkProtectionChecksYourEntitlementAndSyncsItWith =>
      '利用資格を確認し、クラウド機能と同期します。Pro ではシステム全体の広告ブロックが利用できます。';

  @override
  String get advancedNetworkProtectionMalwareProtection => 'マルウェア保護';

  @override
  String get advancedNetworkProtectionBlocksKnownMaliciousDomains =>
      '既知の悪意のあるドメインをブロック';

  @override
  String get advancedNetworkProtectionTrackerProtection => 'トラッカー保護';

  @override
  String get advancedNetworkProtectionReducesTrackingDomains =>
      'トラッキングドメインを減らします';

  @override
  String get advancedNetworkProtectionAdProtection => '広告保護';

  @override
  String get advancedNetworkProtectionBlocksCommonAdDomains =>
      '一般的な広告ドメインをブロック';

  @override
  String get advancedNetworkProtectionAdultFilter => '成人向けコンテンツフィルター';

  @override
  String get advancedNetworkProtectionUses1113Upstream => '上流に 1.1.1.3 を使用';

  @override
  String get advancedNetworkProtectionLockedUntilProIsActiveAndCloud =>
      'Pro が有効で、クラウドモードがオンになるまでロックされています。';

  @override
  String get advancedNetworkProtectionLiveDNSEventsFromTheVPNLayer =>
      'VPN レイヤーからのリアルタイム DNS イベント。';

  @override
  String get advancedNetworkProtectionAdvanced => '詳細';

  @override
  String get advancedNetworkProtectionDns => 'DNS';

  @override
  String get advancedNetworkProtectionCloudDNSMode => 'クラウド DNS モード';

  @override
  String get networkProtectionEnterYourOwnResolver => '独自のリゾルバーを入力';

  @override
  String get networkAppControlEnableVPNToggles => 'VPN 切り替えを有効化';

  @override
  String get networkAppControlOpenSettings => '設定を開く';

  @override
  String get networkAppControlAppControl => 'アプリ制御';

  @override
  String get networkAppControlNoAppsFound => 'アプリが見つかりません。';

  @override
  String get networkSpeedTestCountry => '国';

  @override
  String get networkSpeedTestRunning => '実行中';

  @override
  String get networkSpeedTestRunTest => 'テストを実行';

  @override
  String get networkSpeedTestNoResultsYet => 'まだ結果がありません。';

  @override
  String networkSpeedTestDnsTLS(Object dns, Object tls) {
    return 'DNS: $dns  •  TLS: $tls';
  }

  @override
  String get networkSpeedTestFail => '失敗';

  @override
  String get dnsNetworkProtectionEnterYourOwnResolver => '独自のリゾルバーを入力';

  @override
  String get dnsNetworkProtectionDnsFilteringIsSeperateFromTheSecure =>
      'DNS フィルタリングは Secure VPN とは別の機能です。既知のマルウェア、すべてのアプリ内の広告、トラッカー、不要なカテゴリのコンテンツを読み込み前にブロックできます。';

  @override
  String get fullVpnSignedIn => 'サインイン済みです。';

  @override
  String get fullVpnSignInRequired => 'サインインが必要です';

  @override
  String get fullVpnClose => '閉じる';

  @override
  String get fullVpnLoadingUsage => '使用量を読み込んでいます...';

  @override
  String get fullVpnSyncing => '同期中';

  @override
  String fullVpnUsedThisMonth(Object usedBytes) {
    return '今月 $usedBytes 使用';
  }

  @override
  String get blockedScreenUnsupportedEnvironment => 'サポートされていない環境';

  @override
  String updateLogUpdateV(Object version) {
    return 'アップデート: v$version';
  }

  @override
  String get updateLogHiThereAvarionXHasBeenUpdatedBelow =>
      'AvarionX が更新されました。変更内容は次のとおりです:';

  @override
  String get updateLogNoUserFacingChangesInThisUpdate =>
      'このアップデートにはユーザー向けの変更はありません。';

  @override
  String get updateLogContinue => '続行';

  @override
  String get featuresRealtimeProtectionBody =>
      '新規または変更されたファイルをバックグラウンドで監視し、脅威が現れた瞬間にブロックします。';

  @override
  String get featuresTriLayerEngineTitle => '3 層エンジン';

  @override
  String get featuresTriLayerEngineBody =>
      'Bloom フィルタリング、シグネチャスキャン、APK に特化したバイト解析を組み合わせ、高い精度と速度を実現する 3 段階の検出コアです。';

  @override
  String get featuresMachineLearningTitle => '機械学習';

  @override
  String get featuresMachineLearningBody =>
      '悪意のある APK の挙動パターンを認識するよう学習した、軽量なオンデバイスモデルです。';

  @override
  String get featuresCleanerProTitle => 'Cleaner Pro';

  @override
  String get featuresCleanerProBody =>
      '重複ファイル、キャッシュ、未使用アプリを特定してストレージ容量を取り戻す、進化を続けるクリーニングモジュールです。';

  @override
  String get featuresWifiProtectionTitle => 'Wi-Fi 保護';

  @override
  String get featuresWifiProtectionBody =>
      '端末上の解析によって、安全でない、または不審な Wi-Fi ネットワークを検出します。';

  @override
  String get featuresRootLevelProtectionTitle => 'Root レベル保護';

  @override
  String get featuresRootLevelProtectionBody =>
      'root 化された端末や上級ユーザー向けに設計された、システムレベルの高度な防御です。';

  @override
  String get featuresPcCompanionTitle => 'PC コンパニオン';

  @override
  String get featuresPcCompanionBody =>
      'クロスプラットフォームのウイルス対策連携に対応する、今後提供予定のデスクトップ版です。';

  @override
  String get deviceSecurityNoRisksFound => '端末のリスクは見つかりませんでした';

  @override
  String get deviceSecurityOneCheckNeedsAttention => '1 件の端末チェックに対応が必要です';

  @override
  String deviceSecurityChecksNeedAttention(Object count) {
    return '$count 件の端末チェックに対応が必要です';
  }

  @override
  String get deviceSecurityHealthSectionBody => 'これらの設定は端末のセキュリティ状態に直接影響します。';

  @override
  String get deviceSecurityRecommendationsSectionBody =>
      'これらは一般的に推奨されるセキュリティ設定です。';

  @override
  String get deviceSecuritySignalUnavailable => 'シグナルを利用できません';

  @override
  String get deviceSecurityIgnoredByYou => 'あなたが無視しました';

  @override
  String get deviceSecurityScreenLockInactiveTitle => '画面ロック';

  @override
  String get deviceSecurityScreenLockActiveLabel =>
      '安全ではありません。安全な画面ロックが設定されていません';

  @override
  String get deviceSecurityScreenLockInactiveLabel => '画面ロックは有効です';

  @override
  String get deviceSecurityScreenLockDetail =>
      '安全な画面ロックは、端末を紛失した場合、盗難に遭った場合、または放置した場合に保護します。PIN、パスワード、パターン、指紋、または安全なロック方式で保護された顔認証がないと、端末を物理的に手にした人が簡単に開ける可能性があります。';

  @override
  String get deviceSecurityScreenLockHelp =>
      'Android のセキュリティ設定を開き、安全な画面ロックを設定してください。';

  @override
  String get deviceSecurityCheckSetting => '設定を確認';

  @override
  String get deviceSecurityPrivilegedInactiveTitle => '特権アクセスなし';

  @override
  String get deviceSecurityPrivilegedActiveLabel => '特権アクセスを検出';

  @override
  String get deviceSecurityPrivilegedInactiveLabel => '特権アクセスは検出されませんでした';

  @override
  String get deviceSecurityPrivilegedDetail =>
      'Root や Shizuku は便利な場合がありますが、アクセスが悪用された場合、悪意のあるアプリの影響を大きくする可能性もあります。特権アクセスを持つアプリは、通常の Android アプリでは実行できない操作を行える場合があります。';

  @override
  String get deviceSecurityPrivilegedHelp =>
      'root、Magisk、Shizuku の設定を手動で確認してください。';

  @override
  String get deviceSecurityReviewSetting => '設定を確認';

  @override
  String get deviceSecurityAppVerificationInactiveTitle => 'アプリの検証';

  @override
  String get deviceSecurityAppVerificationActiveLabel =>
      '安全ではありません。アプリの検証が無効になっているようです';

  @override
  String get deviceSecurityAppVerificationInactiveLabel =>
      'アプリの検証が有効になっているようです';

  @override
  String get deviceSecurityAppVerificationDetail =>
      'Android のアプリ検証は、インストール前後にアプリを確認するのに役立ちます。この保護が無効または利用できない場合、有害なアプリが実行前にブロックされる可能性が低くなる場合があります。';

  @override
  String get deviceSecurityAppVerificationHelp =>
      'Android のセキュリティ設定を開き、アプリの検証を確認してください。';

  @override
  String get deviceSecuritySecurityPatchInactiveTitle => 'セキュリティパッチは最新';

  @override
  String get deviceSecuritySecurityPatchActiveLabel => 'セキュリティパッチレベルが古くなっています';

  @override
  String get deviceSecuritySecurityPatchInactiveLabel => 'セキュリティパッチレベルは最新です';

  @override
  String get deviceSecuritySecurityPatchDetail =>
      'Android のセキュリティパッチは、既知のプラットフォームやメーカー固有の問題を修正します。パッチレベルが古い場合、新しいビルドではすでに修正されている脆弱性に端末がさらされる可能性があります。';

  @override
  String get deviceSecuritySecurityPatchHelp =>
      'Android のシステム更新設定を開き、アップデートを確認してください。';

  @override
  String get deviceSecurityCheckUpdates => 'アップデートを確認';

  @override
  String get deviceSecurityDeveloperModeInactiveTitle => '開発者モード';

  @override
  String get deviceSecurityDeveloperModeActiveLabel => '開発者向けオプションが有効です';

  @override
  String get deviceSecurityDeveloperModeInactiveLabel => '開発者向けオプションが無効です';

  @override
  String get deviceSecurityDeveloperModeDetail =>
      '開発者モードは開発者やテスターにとって通常の機能ですが、高度な設定が公開されるため、誤って変更したり端末にアクセスできる人に悪用されたりすると、端末のセキュリティが低下する可能性があります。';

  @override
  String get deviceSecurityDeveloperModeHelp =>
      '開発者向けオプションを開き、不要な設定をオフにしてください。';

  @override
  String get deviceSecurityUsbDebuggingInactiveTitle => 'USB デバッグ';

  @override
  String get deviceSecurityUsbDebuggingActiveLabel => '安全ではありません。USB デバッグがオンです';

  @override
  String get deviceSecurityUsbDebuggingInactiveLabel => 'USB デバッグはオフです';

  @override
  String get deviceSecurityUsbDebuggingDetail =>
      'USB デバッグを有効にすると、接続したコンピューターが Android Debug Bridge を介して端末とやり取りできます。有効なままにすると、信頼できないコンピューターへ接続した際に不正アクセスのリスクが高まります。';

  @override
  String get deviceSecurityUsbDebuggingHelp =>
      '開発者向けオプションを開き、USB デバッグをオフにしてください。';

  @override
  String get deviceSecurityUnknownSourcesInactiveTitle => '提供元不明のアプリ';

  @override
  String get deviceSecurityUnknownSourcesActiveLabel =>
      '提供元不明のアプリのインストールが許可されています';

  @override
  String get deviceSecurityUnknownSourcesInactiveLabel =>
      '提供元不明のアプリのインストールは制限されています';

  @override
  String get deviceSecurityUnknownSourcesDetail =>
      '提供元不明のアプリのインストールを許可すると、信頼できる APK を導入する際には便利ですが、安全でないソースからアプリをインストールする可能性も高まります。信頼できるアプリやストアにのみ許可してください。';

  @override
  String get deviceSecurityUnknownSourcesHelp =>
      'Android の設定を開き、「不明なアプリのインストール」のアクセス権を確認してください。';

  @override
  String get deviceSecurityAccessibilityInactiveTitle => 'ユーザー補助サービス';

  @override
  String get deviceSecurityAccessibilityActiveLabel =>
      'サードパーティのユーザー補助サービスが有効です';

  @override
  String get deviceSecurityAccessibilityInactiveLabel =>
      '危険なユーザー補助サービスは見つかりませんでした';

  @override
  String get deviceSecurityAccessibilityDetail =>
      'ユーザー補助サービスは画面内容を確認し、ユーザーに代わって操作を実行できる強力な機能です。正規のツールには有用ですが、悪意のあるアプリによって悪用されることもよくあります。';

  @override
  String get deviceSecurityAccessibilityHelp => 'ユーザー補助設定を開き、有効なサービスを確認してください。';

  @override
  String get deviceSecurityChecking => '端末のセキュリティを確認しています';

  @override
  String get deviceSecurityReadingSignals => '端末のセキュリティ状態を読み取っています...';

  @override
  String get deviceSecurityOneCheckAttention => '1 件のチェックに対応が必要です';

  @override
  String deviceSecurityChecksAttention(Object count) {
    return '$count 件のチェックに対応が必要です';
  }

  @override
  String get deviceSecurityTapSignal => '詳しく見るには下のシグナルをタップしてください。';

  @override
  String deviceSecurityIgnoredChecks(Object count, String plural) {
    String _temp0 = intl.Intl.selectLogic(
      plural,
      {
        's': '',
        'other': '',
      },
    );
    return '無視している有効なチェック: $count 件。$_temp0';
  }

  @override
  String get deviceSecurityPostureNormal => '端末のセキュリティ状態のチェックは正常です。';

  @override
  String get timeJustNow => 'たった今';

  @override
  String timeMinutesAgo(Object minutes) {
    return '$minutes 分前';
  }

  @override
  String timeHoursAgo(Object hours) {
    return '$hours 時間前';
  }

  @override
  String timeDaysAgo(Object days) {
    return '$days 日前';
  }

  @override
  String get securityNoReportDataYet => 'まだレポートデータがありません';

  @override
  String securityLastActivity(Object relative) {
    return '最終アクティビティ $relative';
  }

  @override
  String get securityReportSharePdfTitle => 'Avarionx セキュリティレポート';

  @override
  String get securityReportCsvField => '項目';

  @override
  String get securityReportCsvValue => '値';

  @override
  String get securityReportGeneratedAt => '生成日時';

  @override
  String get securityReportOverallStatus => '全体の状態';

  @override
  String get securityReportLastManualScan => '前回の手動スキャン';

  @override
  String get securityReportLastRealtimeEvent => '前回のリアルタイムイベント';

  @override
  String get securityReportLastScheduledScan => '前回のスケジュールスキャン';

  @override
  String get securityReportShareCsvTitle => 'Avarionx セキュリティレポート CSV';

  @override
  String get securityReportReviewRecommended => '確認を推奨';

  @override
  String get securityReportNoKnownThreatDetected => '既知の脅威は検出されませんでした';

  @override
  String securityReportGeneratedLine(Object generatedAt) {
    return '生成日時: $generatedAt';
  }

  @override
  String securityReportStatusLine(Object status) {
    return '状態: $status';
  }

  @override
  String securityReportLatestActivityLine(Object latest) {
    return '最新のアクティビティ: $latest';
  }

  @override
  String securityReportManualScansLine(Object count) {
    return '手動スキャン: $count';
  }

  @override
  String securityReportRealtimeChecksLine(Object count) {
    return 'リアルタイムチェック: $count';
  }

  @override
  String securityReportTotalFilesScannedLine(Object count) {
    return 'スキャンしたファイル総数: $count';
  }

  @override
  String securityReportThreatsFoundLine(Object count) {
    return '検出された脅威: $count';
  }

  @override
  String securityReportLastManualScanLine(Object value) {
    return '前回の手動スキャン: $value';
  }

  @override
  String securityReportLastRealtimeEventLine(Object value) {
    return '前回のリアルタイムイベント: $value';
  }

  @override
  String securityReportLastScheduledScanLine(Object value) {
    return '前回のスケジュールスキャン: $value';
  }

  @override
  String get securityReportNotRecorded => '記録なし';

  @override
  String get safeViewNavigationBlocked => '移動をブロックしました';

  @override
  String get safeViewInvalidDestination => '無効な移動先';

  @override
  String get safeViewUnsupportedScheme => 'サポートされていないスキーム';

  @override
  String get safeViewUnableToResolveDestination => '移動先を解決できません';

  @override
  String get safeViewDestinationBlocked => '移動先をブロックしました';

  @override
  String get safeViewUnableToVerifyDestination => '移動先を確認できません';

  @override
  String proScreenCurrentStatus(Object status) {
    return '現在の状態: $status';
  }

  @override
  String proScreenBilledAnnuallyAt(Object price) {
    return '年額 $price で請求';
  }

  @override
  String get quarantineUnknownApp => '不明なアプリ';

  @override
  String get cleanerScanCancelled => 'スキャンをキャンセルしました';

  @override
  String get cleanerProClearingCaches => 'キャッシュを消去しています…';

  @override
  String get cleanerProTrimAppCaches => '端末全体のアプリキャッシュを削減します。';

  @override
  String get cleanerProEnableShizuku => '使用するには設定で Shizuku を有効にしてください。';

  @override
  String get cleanerProScanningStorage => 'ストレージをスキャンしています…';

  @override
  String get cleanerProFindLogFiles => '.log、.trace、.crash、.dmp ファイルを検索します。';

  @override
  String cleanerProLogFileCount(Object count, Object size) {
    return '$count ファイル • $size';
  }

  @override
  String get cleanerProAppManagerReady => 'アプリの強制停止、データ消去、一括アンインストールができます。';

  @override
  String get cleanerProAppManagerLimited =>
      'アンインストールは通常どおり利用できます。強制停止とデータ消去には Shizuku が必要です。';

  @override
  String get cleanerProCheckingShizuku => 'Shizuku を確認しています…';

  @override
  String get cleanerProShizukuNotRunning =>
      'Shizuku が実行されていません。必要なときに設定から有効にしてください。';

  @override
  String get cleanerProShizukuPermissionMissing =>
      'Shizuku の権限が付与されていません。設定から有効にしてください。';

  @override
  String get cleanerProShizukuNotBound =>
      'Shizuku サービスはまだバインドされていません。有効にした後、設定を開いてこの画面を更新してください。';

  @override
  String get cleanerLiteTab => 'Lite';

  @override
  String get cleanerProTab => 'Pro';

  @override
  String get scanCancelled => 'スキャンをキャンセルしました';

  @override
  String get scanPreparing => 'スキャンを準備しています...';

  @override
  String scanSuspiciousItemsFound(Object count, String plural) {
    String _temp0 = intl.Intl.selectLogic(
      plural,
      {
        's': '',
        'other': '',
      },
    );
    return '疑わしい項目が $count 件見つかりました。$_temp0';
  }

  @override
  String scanSuspiciousCount(Object count) {
    return '疑わしい: $count';
  }

  @override
  String scanCleanCount(Object count) {
    return '安全: $count';
  }

  @override
  String scanNotificationFullItems(Object count) {
    return 'スキャン済み: $count 項目';
  }

  @override
  String scanNotificationCurrent(Object count, Object file) {
    return 'スキャン済み: $count • $file';
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
  String get settingsThemeRoyalBluePremium => 'ロイヤルブルー（Premium）';

  @override
  String get settingsIconDefault => 'デフォルト';

  @override
  String get settingsIconBird => 'バード';

  @override
  String get settingsIconNeon => 'ネオン';

  @override
  String get settingsIconOriginal => 'オリジナル';

  @override
  String get homeRealtimeProtectionTitle => 'リアルタイム保護';

  @override
  String get networkCardStatusLocked => 'ロック中';

  @override
  String get networkSectionConnection => '接続';

  @override
  String get networkSectionBlocklists => 'ブロックリスト';

  @override
  String get networkSectionResolver => 'リゾルバー';

  @override
  String get networkAppControlOtherVpnSetupInstructions =>
      '別の VPN が「常時接続」として選択されています。\n\nアプリを確実にブロックするには:\n\n1) Android の VPN 設定を開く\n2) VPN として AvarionX を選択\n3) 「常時接続 VPN」を有効にする\n4) 「VPN 以外の接続をブロック」を有効にする';

  @override
  String get networkAppControlSetupInstructions =>
      'アプリを確実にブロックするには:\n\n1) Android の VPN 設定を開く\n2) VPN として AvarionX を選択\n3) 「常時接続 VPN」を有効にする\n4) 「VPN 以外の接続をブロック」を有効にする';

  @override
  String get networkAppControlBlockingActive => 'アプリのブロックが有効です。';

  @override
  String get networkAppControlOtherVpnWarning =>
      '別の VPN が常時接続に設定されています。AvarionX で「常時接続」+「VPN なしの接続をブロック」を有効にしてください。';

  @override
  String get networkAppControlSetupWarning =>
      'アプリのブロックを機能させるには、AvarionX で「常時接続」+「VPN なしの接続をブロック」を有効にしてください。';

  @override
  String get countryUnitedKingdom => 'イギリス';

  @override
  String get countryUnitedStates => 'アメリカ合衆国';

  @override
  String get countryCanada => 'カナダ';

  @override
  String get countryIreland => 'アイルランド';

  @override
  String get countryFrance => 'フランス';

  @override
  String get countryGermany => 'ドイツ';

  @override
  String get countryNetherlands => 'オランダ';

  @override
  String get countrySpain => 'スペイン';

  @override
  String get countryItaly => 'イタリア';

  @override
  String get countrySweden => 'スウェーデン';

  @override
  String get countryNorway => 'ノルウェー';

  @override
  String get countryDenmark => 'デンマーク';

  @override
  String get countryPoland => 'ポーランド';

  @override
  String get countryTurkey => 'トルコ';

  @override
  String get countryGreece => 'ギリシャ';

  @override
  String get countryRomania => 'ルーマニア';

  @override
  String get countryUkraine => 'ウクライナ';

  @override
  String get countryRussia => 'ロシア';

  @override
  String get countryIndia => 'インド';

  @override
  String get countryPakistan => 'パキスタン';

  @override
  String get countryBangladesh => 'バングラデシュ';

  @override
  String get countrySriLanka => 'スリランカ';

  @override
  String get countryNepal => 'ネパール';

  @override
  String get countryJapan => '日本';

  @override
  String get countrySouthKorea => '韓国';

  @override
  String get countrySingapore => 'シンガポール';

  @override
  String get countryMalaysia => 'マレーシア';

  @override
  String get countryThailand => 'タイ';

  @override
  String get countryVietnam => 'ベトナム';

  @override
  String get countryPhilippines => 'フィリピン';

  @override
  String get countryIndonesia => 'インドネシア';

  @override
  String get countryAustralia => 'オーストラリア';

  @override
  String get countryNewZealand => 'ニュージーランド';

  @override
  String get countryBrazil => 'ブラジル';

  @override
  String get countryArgentina => 'アルゼンチン';

  @override
  String get countryChile => 'チリ';

  @override
  String get countryMexico => 'メキシコ';

  @override
  String get countryColombia => 'コロンビア';

  @override
  String get countryPeru => 'ペルー';

  @override
  String get countrySouthAfrica => '南アフリカ';

  @override
  String get countryNigeria => 'ナイジェリア';

  @override
  String get countryKenya => 'ケニア';

  @override
  String get countryEgypt => 'エジプト';

  @override
  String get countryUAE => 'アラブ首長国連邦';

  @override
  String get countrySaudiArabia => 'サウジアラビア';

  @override
  String get countryIsrael => 'イスラエル';

  @override
  String networkSpeedTestTesting(Object current, Object total, Object domain) {
    return 'テスト中 $current/$total • $domain';
  }

  @override
  String get networkSpeedTestDone => '完了';

  @override
  String get vpnFooterCustomisation => 'カスタマイズ';

  @override
  String get apkClipboardReportTitle => 'VTTI Cloud - APK 解析レポート';

  @override
  String apkClipboardAppName(Object name) {
    return 'アプリ名: $name';
  }

  @override
  String apkClipboardPackageId(Object packageId) {
    return 'パッケージ ID: $packageId';
  }

  @override
  String apkClipboardVersion(Object version) {
    return 'バージョン: $version';
  }

  @override
  String apkClipboardFileSize(Object size) {
    return 'ファイルサイズ: $size';
  }

  @override
  String apkClipboardMinSdk(Object sdk) {
    return '最小 SDK: $sdk';
  }

  @override
  String apkClipboardTargetSdk(Object sdk) {
    return 'ターゲット SDK: $sdk';
  }

  @override
  String apkClipboardSignature(Object signature) {
    return '署名: $signature';
  }

  @override
  String apkClipboardMalwareRisk(Object risk) {
    return 'マルウェアリスク: $risk';
  }

  @override
  String apkClipboardRiskLabel(Object label) {
    return 'リスクラベル: $label';
  }

  @override
  String apkClipboardHashVerdict(Object verdict) {
    return 'ハッシュ判定: $verdict';
  }

  @override
  String apkClipboardRationale(Object rationale) {
    return '根拠: $rationale';
  }

  @override
  String get apkReportUnusualFlags => '通常と異なるフラグ';

  @override
  String get apkReportUnverifiedItems => '未検証の項目';

  @override
  String get apkReportKnownMalware => '既知のマルウェア';

  @override
  String get apkReportSuspiciousHash => '疑わしいハッシュ';

  @override
  String get apkReportCleanHash => '安全なハッシュ';

  @override
  String get apkReportHashNotChecked => 'ハッシュ未確認';

  @override
  String get apkReportHashUnknown => '不明なハッシュ';

  @override
  String get apkMetadataPackage => 'パッケージ';

  @override
  String get apkMetadataPackageId => 'パッケージ ID';

  @override
  String get apkMetadataEngine => 'エンジン';

  @override
  String get apkMetadataSize => 'サイズ';

  @override
  String get apkMetadataMinSdk => '最小 SDK';

  @override
  String get apkMetadataTargetSdk => 'ターゲット SDK';

  @override
  String get apkMetadataSignature => '署名';

  @override
  String get apkAnalyserStageDeconstructing => 'APK を展開しています';

  @override
  String get apkAnalyserStageAnalysing => '内容を解析しています';

  @override
  String get apkAnalyserSignInRequired =>
      'Cloud Analysis を使用するには、設定からサインインしてください。';

  @override
  String get apkAnalyserStageCheckingCloud => 'VTTI Cloud を確認しています';

  @override
  String apkAnalyserDailyLimitReached(Object limit) {
    return '1 日の解析上限 $limit 回に達しました。';
  }

  @override
  String get apkAnalyserCloudAnalysisFailed => 'クラウド解析に失敗しました';

  @override
  String get apkAnalyserStageGeneratingReport => 'レポートを生成しています';

  @override
  String get apkAnalyserAnalysisFailed => 'APK 解析を処理できませんでした';

  @override
  String get genericError => 'エラー';

  @override
  String get apkReportEngineVttiCloud => 'VTTI Cloud エンジン';

  @override
  String get apkReportCertificateDetected => '証明書を検出しました';

  @override
  String get apkReportNoCertificateData => '証明書データがありません';

  @override
  String get apkExportOverview => '概要';

  @override
  String get apkExportMalwareAssessment => 'マルウェア評価';

  @override
  String get apkExportRiskScore => 'リスクスコア';

  @override
  String get apkExportRiskLabel => 'リスクラベル';

  @override
  String get apkExportHashVerdict => 'ハッシュ判定';

  @override
  String get apkExportScoreRationale => 'スコアの根拠';

  @override
  String get apkExportContributingSignals => '寄与シグナル';

  @override
  String get apkExportDampeningFactors => '軽減要因';

  @override
  String get apkExportPermissionsRequested => '要求された権限';

  @override
  String get apkExportExtraFlagsUnusual => '追加フラグ（通常と異なる）';

  @override
  String get apkExportExtraFlagsUnverified => '追加フラグ（未検証）';

  @override
  String get apkExportDiscoveredSources => '検出されたソース';

  @override
  String get apkExportRequestedPermissions => '要求された権限';

  @override
  String get apkExportRationale => '根拠';

  @override
  String apkExportCsvShareText(Object name) {
    return '$name の APK 解析 CSV';
  }

  @override
  String get apkExportPdfTitle => 'VTTI Cloud - APK 解析';

  @override
  String apkExportPdfShareText(Object name) {
    return '$name の APK 解析 PDF';
  }

  @override
  String get apkMetadataAppName => 'アプリ名';

  @override
  String get apkMetadataFileSize => 'ファイルサイズ';

  @override
  String get vpnBackendFailedOpenBrowser => 'ブラウザーを開けませんでした。';

  @override
  String get vpnBackendSignedIn => 'サインインしました。';

  @override
  String get vpnBackendSignedOut => 'サインアウトしました。';

  @override
  String get vpnBackendSessionExpiredSignIn =>
      'セッションの有効期限が切れました。もう一度サインインしてください。';

  @override
  String vpnBackendFailedLoadAccountStatus(Object status) {
    return 'アカウントを読み込めませんでした（$status）。';
  }

  @override
  String vpnBackendFailedLoadAccountError(Object error) {
    return 'アカウントを読み込めませんでした（$error）。';
  }

  @override
  String get vpnBackendSignInFirst => '先にサインインしてください。';

  @override
  String get vpnBackendConnecting => '接続しています...';

  @override
  String get vpnBackendNotificationsPermissionRequired => '通知の権限が必要です。';

  @override
  String get vpnBackendPermissionNotGranted => 'VPN の権限が付与されていません。';

  @override
  String get vpnBackendAnotherVpnActive => '別の VPN が有効です。先に無効にしてください。';

  @override
  String get vpnBackendProvisionIncomplete => 'プロビジョニングから不完全な設定が返されました。';

  @override
  String get vpnBackendSecuringConnection => '接続を保護しています...';

  @override
  String get vpnBackendConnected => '接続しました。';

  @override
  String vpnBackendWireGuardFailed(Object error) {
    return 'WireGuard を開始できませんでした（$error）。';
  }

  @override
  String get vpnBackendDisconnecting => '切断しています...';

  @override
  String get vpnBackendDisconnected => '切断しました。';

  @override
  String vpnBackendSelectedServer(Object server) {
    return '$server を選択しました';
  }

  @override
  String vpnBackendSwitchingServer(Object server) {
    return '$server に切り替えています...';
  }

  @override
  String get vpnBackendKeyNotFound => 'VPN キーが見つかりません。';

  @override
  String get vpnBackendDnsUpdated => 'DNS 設定を更新しました。';

  @override
  String get vpnBackendSessionExpired => 'セッションの有効期限が切れました。';

  @override
  String vpnBackendFailedStatus(Object status) {
    return '失敗しました（$status）。';
  }

  @override
  String get vpnBackendPlanNotAllowed => '現在のプランでは Full VPN を使用できません。';

  @override
  String vpnBackendProvisionFailed(Object status) {
    return 'プロビジョニングに失敗しました（$status）。';
  }
}
