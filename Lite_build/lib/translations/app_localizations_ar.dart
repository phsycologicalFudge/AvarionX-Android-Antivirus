// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get appName => 'AvarionX';

  @override
  String get ok => 'حسنًا';

  @override
  String get cancel => 'إلغاء';

  @override
  String get footerHome => 'الرئيسية';

  @override
  String get footerExplore => 'استكشاف';

  @override
  String get footerRemoved => 'المحذوفات';

  @override
  String get footerSettings => 'الإعدادات';

  @override
  String get proBadge => 'PRO';

  @override
  String get updateDbTitle => 'جارٍ تحديث قاعدة البيانات';

  @override
  String updateDbVersionLabel(Object version) {
    return 'الإصدار $version';
  }

  @override
  String get companionAppsSectionTitle => 'More from AvarionX';

  @override
  String get cleanerReclaimableLabel => 'Can be freed';

  @override
  String get exploreMultiThreadingTitle => 'تعدد الخيوط';

  @override
  String get exploreMultiThreadingSubtitle => 'تحكم تجريبي بالمحرك';

  @override
  String get updateDbAutoDownloadLabel => 'تنزيل التحديثات المستقبلية تلقائيًا';

  @override
  String get updateDbUpdatedAutoOn =>
      'تم تحديث قاعدة البيانات • التحديثات التلقائية مفعلة';

  @override
  String get updateDbUpdatedSuccess => 'تم تحديث قاعدة البيانات بنجاح';

  @override
  String get updateDbUpdateFailed => 'فشل تحديث قاعدة البيانات';

  @override
  String get engineReadyBanner => 'VX-TITANIUM-v8';

  @override
  String get scanButton => 'فحص';

  @override
  String get scanModeFullTitle => 'فحص كامل للجهاز';

  @override
  String get scanModeFullSubtitle =>
      'يفحص كل الملفات القابلة للقراءة في التخزين.';

  @override
  String get scanModeSmartTitle => 'فحص ذكي [موصى به]';

  @override
  String get scanModeSmartSubtitle =>
      'يفحص الملفات التي قد تحتوي على برمجيات خبيثة.';

  @override
  String get scanModeRapidTitle => 'فحص سريع';

  @override
  String get scanModeRapidSubtitle => 'يفحص ملفات APK الحديثة في التنزيلات.';

  @override
  String get scanModeInstalledTitle => 'التطبيقات المثبتة';

  @override
  String get scanModeInstalledSubtitle =>
      'يفحص تطبيقاتك المثبتة بحثًا عن التهديدات.';

  @override
  String get scanModeSingleTitle => 'فحص ملف / تطبيق';

  @override
  String get scanModeSingleSubtitle => 'اختر ملفًا أو تطبيقًا لفحصه.';

  @override
  String get useCloudAssistedScan => 'استخدام فحص بمساعدة السحابة';

  @override
  String get protectionTitle => 'الحماية';

  @override
  String get stateOffLine1 => 'حماية الجهاز متوقفة';

  @override
  String get stateOffLine2 => 'اضغط للتشغيل';

  @override
  String get stateAdvancedActiveLine1 => 'الحماية المتقدمة نشطة';

  @override
  String get stateFileOnlyLine1 => 'حماية الملفات فقط';

  @override
  String get stateFileOnlyLine2 => 'حماية الشبكة معطلة';

  @override
  String get stateVpnConflictLine2 => 'هناك VPN آخر نشط';

  @override
  String get stateProtectedLine1 => 'الجهاز محمي';

  @override
  String get stateProtectedLine2 => 'اضغط للإيقاف';

  @override
  String get dbUpdating => 'جارٍ تحديث قاعدة البيانات';

  @override
  String dbVersionAutoUpdated(Object version) {
    return 'قاعدة البيانات v$version • تم تحديثها تلقائيًا';
  }

  @override
  String get rtpInfoTitle => 'الحماية في الوقت الحقيقي';

  @override
  String get rtpInfoBody =>
      'بالإضافة إلى حظر الملفات المشبوهة التي تم تنزيلها عمدًا (أو بواسطة برمجيات خبيثة)، يستخدم RTP شبكة VPN محلية لحظر النطاقات الخبيثة على مستوى النظام.\n\nعند التفعيل، يبقى ترشيح الشبكة نشطًا إلا إذا:\n• تم تعطيله يدويًا عبر الطرفية\n• تم استبداله بـ VPN آخر\n\nتستمر حماية الملفات طالما أن RTP مفعّل.';

  @override
  String get scanTitleDefault => 'فحص';

  @override
  String get scanTitleSmart => 'فحص ذكي';

  @override
  String get scanTitleRapid => 'فحص سريع';

  @override
  String get scanTitleInstalled => 'فحص التطبيقات المثبتة';

  @override
  String get scanTitleFull => 'فحص كامل للجهاز';

  @override
  String get scanTitleSingle => 'فحص واحد';

  @override
  String get cancellingScan => 'جارٍ إلغاء الفحص…';

  @override
  String get cancelScan => 'إلغاء الفحص';

  @override
  String get scanProgressZero => 'التقدم: 0%';

  @override
  String scanProgressWithPct(Object pct, Object scanned, Object total) {
    return 'التقدم: $pct% ($scanned / $total)';
  }

  @override
  String scanProgressFullItems(Object count) {
    return 'تم فحص: $count عنصر';
  }

  @override
  String get initializing => 'جارٍ التهيئة...';

  @override
  String get scanningEllipsis => 'جارٍ الفحص...';

  @override
  String get fullScanInfoTitle => 'فحص كامل للجهاز';

  @override
  String get fullScanInfoBody =>
      'يقوم هذا الوضع بفحص كل ملف قابل للقراءة في التخزين دون أي فلترة.\n\nلا يتم استخدام الفحص بمساعدة السحابة أو فحص التطبيقات في هذا الوضع.';

  @override
  String get scanComplete => 'اكتمل الفحص';

  @override
  String pillSuspiciousCount(Object count) {
    return 'مشبوه: $count';
  }

  @override
  String pillCleanCount(Object count) {
    return 'نظيف: $count';
  }

  @override
  String pillScannedCount(Object count) {
    return 'تم فحص: $count';
  }

  @override
  String get resultNoThreatsTitle => 'لم يتم اكتشاف تهديدات';

  @override
  String get resultNoThreatsBody =>
      'لم يتم اكتشاف تهديدات في العناصر التي تم فحصها.';

  @override
  String get resultSuspiciousAppsTitle => 'تطبيقات مشبوهة';

  @override
  String get resultSuspiciousItemsTitle => 'عناصر مشبوهة';

  @override
  String get returnHome => 'العودة للرئيسية';

  @override
  String get emptyTitle => 'لا توجد ملفات قابلة للفحص';

  @override
  String get emptyBody => 'لم يحتوي جهازك على أي ملفات تطابق معايير الفحص.';

  @override
  String get knownMalware => 'برمجيات خبيثة معروفة';

  @override
  String get suspiciousActivityDetected => 'تم اكتشاف نشاط مشبوه';

  @override
  String get maliciousActivityDetected => 'تم اكتشاف نشاط خبيث';

  @override
  String get androidBankingTrojan => 'حصان طروادة مصرفي لأندرويد';

  @override
  String get androidSpyware => 'برامج تجسس لأندرويد';

  @override
  String get androidAdware => 'برامج إعلانات لأندرويد';

  @override
  String get androidSmsFraud => 'احتيال رسائل SMS لأندرويد';

  @override
  String get threatLevelConfirmed => 'مؤكد';

  @override
  String get threatLevelHigh => 'مرتفع';

  @override
  String get threatLevelMedium => 'متوسط';

  @override
  String threatLevelLabel(Object level) {
    return 'مستوى التهديد: $level';
  }

  @override
  String get explainFoundInCloud =>
      'هذا العنصر مُدرج في قاعدة بيانات تهديدات ColourSwift السحابية.';

  @override
  String get explainFoundInOffline =>
      'هذا العنصر مُدرج في قاعدة بيانات البرمجيات الخبيثة غير المتصلة على جهازك.';

  @override
  String get explainBanker =>
      'مصمم لسرقة بيانات الاعتماد المالية، غالبًا عبر التراكبات أو تسجيل المفاتيح أو اعتراض الحركة.';

  @override
  String get explainSpyware =>
      'يراقب النشاط بصمت أو يجمع بيانات شخصية مثل الرسائل أو الموقع أو معرفات الجهاز.';

  @override
  String get explainAdware =>
      'يعرض إعلانات مزعجة، أو ينفذ إعادة توجيه، أو يولد حركة إعلانات احتيالية.';

  @override
  String get explainSmsFraud =>
      'يحاول إرسال أو تشغيل إجراءات عبر SMS دون موافقة، ما قد يسبب رسومًا غير متوقعة.';

  @override
  String get explainGenericMalware =>
      'تم اكتشاف مؤشرات قوية على نية خبيثة، رغم أنه لا يطابق عائلة مسماة.';

  @override
  String get explainSuspiciousDefault =>
      'تم اكتشاف مؤشرات لسلوك مشبوه. قد يتضمن ذلك أنماطًا تُرى في البرمجيات الخبيثة، لكنه قد يكون إنذارًا كاذبًا.';

  @override
  String get singleChoiceScanFile => 'فحص ملف';

  @override
  String get singleChoiceScanInstalledApp => 'فحص تطبيق مثبت';

  @override
  String get singleChoiceManageExclusions => 'إدارة الاستثناءات';

  @override
  String get labelKnownMalwareDb => 'موجود في قاعدة بيانات البرمجيات الخبيثة';

  @override
  String get labelFoundInCloudDb => 'موجود في قاعدة بيانات السحابة';

  @override
  String get logEngineFullDeviceScan => '[ENGINE] فحص كامل للجهاز';

  @override
  String get logEngineTargetStorage => '[ENGINE] الهدف: /storage/emulated/0';

  @override
  String get logEngineNoFilesFound => '[ENGINE] لم يتم العثور على ملفات.';

  @override
  String logEngineFilesEnumerated(Object count) {
    return '[ENGINE] عدد الملفات: $count';
  }

  @override
  String get logEngineNoReadableFilesFound =>
      '[ENGINE] لم يتم العثور على ملفات قابلة للقراءة.';

  @override
  String logEngineInstalledAppsFound(Object count) {
    return '[ENGINE] تم العثور على تطبيقات مثبتة: $count';
  }

  @override
  String get logModeCloudAssisted => '[MODE] وضع بمساعدة السحابة';

  @override
  String get logModeOffline => '[MODE] وضع غير متصل';

  @override
  String get logStageHashing => '[STAGE 1] الحصول على بصمات الملفات (مخزنة)...';

  @override
  String get logStageCloudLookup => '[STAGE 2] البحث عن البصمات في السحابة...';

  @override
  String logStageLocalScanning(Object stage) {
    return '[STAGE $stage] فحص الملفات محليًا...';
  }

  @override
  String logCloudHashHits(Object count) {
    return '[CLOUD] تطابقات بصمات: $count';
  }

  @override
  String logSummary(Object suspicious, Object clean) {
    return '[SUMMARY] $suspicious مشبوه • $clean نظيف';
  }

  @override
  String logErrorPrefix(Object message) {
    return '[ERROR] $message';
  }

  @override
  String get genericUnknownAppName => 'غير معروف';

  @override
  String get genericUnknownFileName => 'غير معروف';

  @override
  String get featuresDrawerTitle => 'الميزات';

  @override
  String get recommendedSectionTitle => 'موصى به';

  @override
  String get featureNetworkProtection => 'حماية الشبكة';

  @override
  String get featureLinkChecker => 'فاحص الروابط';

  @override
  String get featureMetaPass => 'MetaPass';

  @override
  String get featureCleanerPro => 'Cleaner Pro';

  @override
  String get featureTerminal => 'الطرفية';

  @override
  String get featureScheduledScans => 'عمليات فحص مجدولة';

  @override
  String get networkStatusDisconnected => 'غير متصل';

  @override
  String get networkStatusConnecting => 'جارٍ الاتصال';

  @override
  String get networkStatusConnected => 'متصل';

  @override
  String get networkUsageTitle => 'الاستخدام';

  @override
  String get networkUsageEnableVpnToView => 'فعّل VPN لعرض الاستخدام.';

  @override
  String get networkUsageUnlimited => 'غير محدود';

  @override
  String networkUsageUsedOf(Object used, Object limit) {
    return '$used / $limit';
  }

  @override
  String networkUsageResetsOn(Object y, Object m, Object d) {
    return 'يعاد الضبط في $y-$m-$d';
  }

  @override
  String networkUsageUpdatedAt(Object hh, Object mm) {
    return 'تم التحديث $hh:$mm';
  }

  @override
  String get networkCardStatusAvailable => 'متاح';

  @override
  String get networkCardStatusDisabled => 'معطل';

  @override
  String get networkCardStatusCustom => 'مخصص';

  @override
  String get networkCardStatusReady => 'جاهز';

  @override
  String get networkCardStatusOpen => 'فتح';

  @override
  String get networkCardStatusComingSoon => 'قريبًا';

  @override
  String get networkCardBlocklistsTitle => 'قوائم الحظر';

  @override
  String get networkCardBlocklistsSubtitle => 'عناصر التحكم بالترشيح';

  @override
  String get networkCardUpstreamTitle => 'Upstream';

  @override
  String get networkCardUpstreamSubtitle => 'اختيار المُحلّل';

  @override
  String get networkCardAppsTitle => 'التطبيقات';

  @override
  String get networkCardAppsSubtitle => 'حظر التطبيقات على Wi-Fi';

  @override
  String get networkCardLogsTitle => 'السجلات';

  @override
  String get networkCardLogsSubtitle => 'أحداث DNS مباشرة';

  @override
  String get networkCardSpeedTitle => 'السرعة';

  @override
  String get networkCardSpeedSubtitle => 'اختبار DNS';

  @override
  String get networkCardAboutTitle => 'حول';

  @override
  String get networkCardAboutSubtitle => 'GitHub';

  @override
  String get networkLogsStatusNoActivity => 'لا نشاط';

  @override
  String networkLogsStatusRecent(Object count) {
    return '$count حديثة';
  }

  @override
  String get networkResolverTitle => 'المُحلّل';

  @override
  String get networkResolverIpLabel => 'IP المُحلّل';

  @override
  String get networkResolverIpHint => 'مثال: 1.1.1.1';

  @override
  String get networkSpeedTestTitle => 'اختبار السرعة';

  @override
  String get networkSpeedTestBody =>
      'يشغّل اختبار سرعة DNS باستخدام إعداداتك الحالية.';

  @override
  String get networkSpeedTestRun => 'تشغيل اختبار السرعة';

  @override
  String get networkBlocklistsRecommendedTitle => 'موصى به';

  @override
  String get networkBlocklistsCsMalwareTitle => 'ColourSwift Malware';

  @override
  String get networkBlocklistsCsAdsTitle => 'ColourSwift ads';

  @override
  String get networkBlocklistsSeeGithub => 'راجع GitHub للتفاصيل...';

  @override
  String get networkBlocklistsMalwareSection => 'برمجيات خبيثة';

  @override
  String get networkBlocklistsMalwareTitle => 'قائمة حظر البرمجيات الخبيثة';

  @override
  String get networkBlocklistsMalwareSources =>
      'HaGeZi TIF • URLHaus • DigitalSide • Spam404';

  @override
  String get networkBlocklistsAdsSection => 'إعلانات';

  @override
  String get networkBlocklistsAdsTitle => 'قائمة حظر الإعلانات';

  @override
  String get networkBlocklistsAdsSources =>
      'OISD • AdAway • Yoyo • AnudeepND • Firebog AdGuard';

  @override
  String get networkBlocklistsTrackersSection => 'متعقبات';

  @override
  String get networkBlocklistsTrackersTitle => 'قائمة حظر المتعقبات';

  @override
  String get networkBlocklistsTrackersSources =>
      'EasyPrivacy • Disconnect • Frogeye • Perflyst • WindowsSpyBlocker';

  @override
  String get networkBlocklistsGamblingSection => 'مقامرة';

  @override
  String get networkBlocklistsGamblingTitle => 'قائمة حظر المقامرة';

  @override
  String get networkBlocklistsGamblingSources => 'HaGeZi Gambling';

  @override
  String get networkBlocklistsSocialSection => 'وسائل التواصل';

  @override
  String get networkBlocklistsSocialTitle => 'قائمة حظر وسائل التواصل';

  @override
  String get networkBlocklistsSocialSources => 'HaGeZi Social';

  @override
  String get networkBlocklistsAdultSection => '18+';

  @override
  String get networkBlocklistsAdultTitle => 'قائمة حظر المحتوى الإباحي';

  @override
  String get networkBlocklistsAdultSources => 'StevenBlack 18+ • HaGeZi NSFW';

  @override
  String get networkLiveLogsTitle => 'سجلات مباشرة';

  @override
  String get networkLiveLogsEmpty => 'لا توجد طلبات بعد.';

  @override
  String get networkLiveLogsBlocked => 'محظور';

  @override
  String get networkLiveLogsAllowed => 'مسموح';

  @override
  String get recommendedMetaPassDesc => 'إنشاء كلمات مرور آمنة دون اتصال.';

  @override
  String get recommendedCleanerProDesc =>
      'اعثر على التكرارات والوسائط القديمة والتطبيقات غير المستخدمة لاستعادة المساحة تلقائيًا.';

  @override
  String get recommendedLinkCheckerDesc =>
      'تحقق من الروابط المشبوهة باستخدام وضع العرض الآمن، دون مخاطر.';

  @override
  String get recommendedNetworkProtectionDesc =>
      'حافظ على اتصالك بالإنترنت آمنًا من البرمجيات الخبيثة.';

  @override
  String get recommendedTerminalDesc => 'ميزة متقدمة لـ Shizuku';

  @override
  String get recommendedScheduledScansDesc => 'عمليات فحص تلقائية في الخلفية.';

  @override
  String get metaPassTitle => 'MetaPass';

  @override
  String get metaPassHowItWorks => 'كيف يعمل MetaPass';

  @override
  String get metaPassOk => 'حسنًا';

  @override
  String get metaPassSettings => 'الإعدادات';

  @override
  String get metaPassPoweredBy => 'powered by VX-TITANIUM';

  @override
  String get metaPassLoading => 'جارٍ التحميل…';

  @override
  String get metaPassEmptyTitle => 'لا توجد إدخالات بعد';

  @override
  String get metaPassEmptyBody =>
      'أضف تطبيقًا أو موقعًا.\nيتم إنشاء كلمات المرور على الجهاز من كلمة مرورك الرئيسية السرية.';

  @override
  String get metaPassAddFirstEntry => 'إضافة أول إدخال';

  @override
  String get metaPassTapToCopyHint => 'اضغط للنسخ. اضغط مطولًا للإزالة.';

  @override
  String get metaPassCopyTooltip => 'نسخ كلمة المرور';

  @override
  String get metaPassAdd => 'إضافة';

  @override
  String get metaPassPickFromInstalledApps => 'اختيار من التطبيقات المثبتة';

  @override
  String get metaPassAddWebsiteOrLabel => 'إضافة موقع أو تسمية مخصصة';

  @override
  String get metaPassSelectApp => 'اختيار تطبيق';

  @override
  String get metaPassSearchApps => 'بحث في التطبيقات';

  @override
  String get metaPassCancel => 'إلغاء';

  @override
  String get metaPassContinue => 'متابعة';

  @override
  String get metaPassSave => 'حفظ';

  @override
  String get metaPassAddEntryTitle => 'إضافة إدخال';

  @override
  String get metaPassNameOrUrl => 'الاسم أو URL';

  @override
  String get metaPassNameOrUrlHint => 'مثال: nextcloud, steam, example.com';

  @override
  String get metaPassVersion => 'الإصدار';

  @override
  String get metaPassLength => 'الطول';

  @override
  String get metaPassSetMetaTitle => 'تعيين Meta Password';

  @override
  String get metaPassSetMetaBody =>
      'أدخل كلمة مرورك الرئيسية. لا تغادر هذا الجهاز أبدًا. تعتمد كل كلمات المرور في الخزنة عليها.';

  @override
  String get metaPassMetaLabel => 'Meta password';

  @override
  String get metaPassRememberThisDevice => 'تذكر على هذا الجهاز (مخزنة بأمان)';

  @override
  String get metaPassChangingMetaWarning =>
      'تغيير هذا لاحقًا يغير كل كلمات المرور المُنشأة. استخدام نفس الكلمة يعيدها.';

  @override
  String get metaPassRemoveEntryTitle => 'إزالة إدخال';

  @override
  String metaPassRemoveEntryBody(Object label) {
    return 'إزالة \"$label\" من خزنتك؟';
  }

  @override
  String get metaPassRemove => 'إزالة';

  @override
  String metaPassPasswordCopied(Object label, Object version, Object length) {
    return 'تم نسخ كلمة المرور لـ $label (v$version, $length chars)';
  }

  @override
  String metaPassGenerateFailed(Object error) {
    return 'فشل إنشاء كلمة المرور: $error';
  }

  @override
  String metaPassLoadAppsFailed(Object error) {
    return 'فشل تحميل التطبيقات: $error';
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
      'لا يتم تخزين كلمات المرور.\n\nكل إدخال يشتق كلمة مرور من:\n• كلمة مرورك الرئيسية\n• التسمية (الاسم)\n• الإصدار والطول\n\nإعادة تثبيت التطبيق مع نفس الكلمة والتسميات يعيد إنشاء نفس كلمات المرور.';

  @override
  String get passwordSettingsTitle => 'إعدادات كلمة المرور';

  @override
  String get passwordSettingsSectionMetaPass => 'MetaPass';

  @override
  String get passwordSettingsMetaPasswordTitle => 'Meta password';

  @override
  String get passwordSettingsMetaNotSet => 'غير معيّنة';

  @override
  String get passwordSettingsMetaStoredSecurely => 'مخزنة بأمان على هذا الجهاز';

  @override
  String get passwordSettingsChange => 'تغيير';

  @override
  String get passwordSettingsSetMetaPassTitle => 'تعيين MetaPass';

  @override
  String get passwordSettingsMetaPasswordLabel => 'Meta password';

  @override
  String get passwordSettingsChangingAltersAll =>
      'تغيير هذا يغير كل كلمات المرور.\nاستخدام نفس MetaPass يعيدها.';

  @override
  String get passwordSettingsCancel => 'إلغاء';

  @override
  String get passwordSettingsSave => 'حفظ';

  @override
  String get passwordSettingsSectionRestoreCode => 'رمز الاستعادة';

  @override
  String get passwordSettingsGenerateRestoreCode => 'إنشاء رمز استعادة';

  @override
  String get passwordSettingsCopy => 'نسخ';

  @override
  String get passwordSettingsRestoreCodeCopied => 'تم نسخ رمز الاستعادة';

  @override
  String get passwordSettingsSectionRestoreFromCode => 'استعادة من رمز';

  @override
  String get passwordSettingsRestoreCodeLabel => 'رمز الاستعادة';

  @override
  String get passwordSettingsRestore => 'استعادة';

  @override
  String get passwordSettingsVaultRestored => 'تمت استعادة الخزنة';

  @override
  String get passwordSettingsFooterInfo =>
      'لا يتم تخزين كلمات المرور.\n\nرمز الاستعادة يحتوي فقط على بيانات البنية. مع MetaPass، يعيد بناء خزنتك.';

  @override
  String get onboardingAppName => 'AVarionX Security';

  @override
  String get onboardingStorageTitle => 'إذن التخزين';

  @override
  String get onboardingStorageDesc =>
      'هذا الإذن مطلوب لفحص الملفات على جهازك. يمكنك منحه الآن أو لاحقًا.';

  @override
  String get onboardingStorageFootnote =>
      'يمكنك التخطي، لكن سيُطلب منك مرة أخرى عند اختيار وضع الفحص.';

  @override
  String get onboardingStorageSnack => 'إذن التخزين مطلوب للفحص.';

  @override
  String get onboardingNotificationsTitle => 'الإشعارات';

  @override
  String get onboardingNotificationsDesc =>
      'تُستخدم لتنبيهات الوقت الحقيقي، حالة الفحص، وتحديثات العزل.';

  @override
  String get onboardingNotificationsFootnote =>
      'مطلوب من Android للحماية في الوقت الحقيقي.';

  @override
  String get onboardingNetworkTitle => 'حماية الشبكة';

  @override
  String get onboardingNetworkDesc =>
      'تفعّل حماية Wi-Fi باستخدام إذن VPN في Android.';

  @override
  String get onboardingNetworkFootnote => 'هذا اختياري لكنه موصى به.';

  @override
  String get onboardingGranted => 'تم المنح';

  @override
  String get onboardingNotGranted => 'لم يُمنح';

  @override
  String get onboardingGrantAccess => 'منح الإذن';

  @override
  String get onboardingAllowNotifications => 'السماح بالإشعارات';

  @override
  String get onboardingAllowVpnAccess => 'السماح بإذن VPN';

  @override
  String get onboardingBack => 'رجوع';

  @override
  String get onboardingNext => 'التالي';

  @override
  String get onboardingFinish => 'إنهاء';

  @override
  String get onboardingSetupCompleteTitle => 'اكتملت الإعدادات';

  @override
  String get onboardingSetupCompleteDesc =>
      'نوصي بتشغيل فحص كامل للجهاز (هذا لا يفحص التطبيقات المثبتة حاليًا)، أو الانتقال مباشرة إلى الشاشة الرئيسية.';

  @override
  String get onboardingRunFullScan => 'تشغيل الفحص الكامل';

  @override
  String get onboardingGoHome => 'الانتقال للرئيسية';

  @override
  String get networkProtectionTitle => 'حماية الشبكة';

  @override
  String networkStatusConnectedToDns(Object dns) {
    return 'متصل بـ $dns';
  }

  @override
  String get networkStatusVpnConflictDetail => 'هناك VPN آخر نشط';

  @override
  String get networkStatusOffDetail => 'حماية الشبكة متوقفة';

  @override
  String get networkModeMalwareTitle => 'حظر البرمجيات الخبيثة فقط';

  @override
  String get networkModeMalwareSubtitle => 'يستخدم 1.1.1.2';

  @override
  String get networkModeMalwareDescription =>
      'يجمع بين قاعدة بيانات البرمجيات الخبيثة المحلية لدى AvarionX ومعلومات التهديدات عبر الإنترنت من Cloudflare لأقصى حماية.';

  @override
  String get networkModeAdultTitle => 'برمجيات خبيثة ومحتوى للبالغين';

  @override
  String get networkModeAdultSubtitle => 'يستخدم 1.1.1.3';

  @override
  String get networkModeAdultDescription =>
      'يستخدم قاعدة بيانات البرمجيات الخبيثة غير المتصلة لدى AvarionX ويضيف فلترة محتوى للبالغين. يتم تعطيل ذكاء البرمجيات الخبيثة السحابي في هذا الوضع.';

  @override
  String get networkInfoTitle => 'ما هي حماية الشبكة؟';

  @override
  String get networkInfoBody =>
      'تعمل بعض التهديدات عبر الاتصال بخوادم خبيثة أو إعادة توجيه حركة الإنترنت.\nحماية الشبكة تحظر النطاقات الخطرة المعروفة والإعلانات الشائعة باستخدام VPN محلي.\n\nAVarionX Security لا يجمع أي بيانات.';

  @override
  String get linkCheckerTitle => 'فاحص الروابط';

  @override
  String get linkCheckerTabAnalyse => 'تحليل';

  @override
  String get linkCheckerTabView => 'عرض';

  @override
  String get linkCheckerTabHistory => 'السجل';

  @override
  String get linkCheckerAnalyseSubtitle =>
      'فحص الصفحة بحثًا عن برمجيات خبيثة أو محتوى مشبوه';

  @override
  String get linkCheckerUrlLabel => 'URL';

  @override
  String get linkCheckerUrlHint => 'https://example.com';

  @override
  String get linkCheckerButtonAnalyse => 'تحليل';

  @override
  String get linkCheckerButtonChecking => 'جارٍ الفحص';

  @override
  String get linkCheckerEngineNotReadySnack => 'المحرك غير جاهز';

  @override
  String get linkCheckerStatusVerifyingLink => 'جارٍ التحقق من الرابط…';

  @override
  String get linkCheckerStatusScanningPage => 'جارٍ فحص الصفحة…';

  @override
  String get linkCheckerBlockedNavigation => 'تم حظر التنقل';

  @override
  String get linkCheckerBlockedUnsupportedType => 'نوع الرابط غير مدعوم';

  @override
  String get linkCheckerBlockedInvalidDestination => 'وجهة غير صالحة';

  @override
  String get linkCheckerBlockedUnableResolve => 'تعذر حل الوجهة';

  @override
  String get linkCheckerBlockedUnableVerify => 'تعذر التحقق';

  @override
  String get linkCheckerAnalyseCardTitleDefault =>
      'افحص الصفحة بحثًا عن محتوى مشبوه';

  @override
  String get linkCheckerAnalyseCardDetailDefault =>
      'الصق رابطًا وشغّل التحليل.';

  @override
  String get linkCheckerAnalyseCardTitleEngineNotReady => 'المحرك غير جاهز';

  @override
  String get linkCheckerAnalyseCardDetailEngineNotReady => 'error 1001.';

  @override
  String get linkCheckerAnalyseCardTitleChecking => 'جارٍ الفحص';

  @override
  String get linkCheckerVerdictClean => 'نظيف';

  @override
  String get linkCheckerVerdictCleanDetail => 'تبدو هذه الصفحة آمنة.';

  @override
  String get linkCheckerVerdictSuspicious => 'مشبوه';

  @override
  String get linkCheckerVerdictSuspiciousDetail =>
      'تحتوي هذه الصفحة على محتوى مشبوه.';

  @override
  String get linkCheckerViewLockedBody => 'شغّل التحليل أولًا لتمكين العرض.';

  @override
  String get linkCheckerViewSubtitle => 'عرض الصفحة بأمان';

  @override
  String get linkCheckerViewPage => 'عرض الصفحة';

  @override
  String get linkCheckerClose => 'إغلاق';

  @override
  String get linkCheckerBlockedBody =>
      'تم إيقاف هذه الصفحة قبل أن يتم تحميلها.';

  @override
  String get linkCheckerSuspiciousBanner =>
      'رابط مشبوه، قد لا يتم عرضه إذا كان يتطلب محتوى محظورًا.';

  @override
  String get linkCheckerHistorySubtitle => 'اضغط على إدخال لنسخ الرابط.';

  @override
  String get linkCheckerHistoryEmpty => 'لا توجد فحوصات بعد.';

  @override
  String get linkCheckerCopied => 'تم النسخ';

  @override
  String get settingsSectionAppearance => 'المظهر';

  @override
  String get settingsTheme => 'السمة';

  @override
  String settingsThemeCurrent(Object theme) {
    return 'الحالية: $theme';
  }

  @override
  String get settingsLanguage => 'اللغة';

  @override
  String settingsLanguageCurrent(Object language) {
    return 'الحالية: $language';
  }

  @override
  String get settingsChooseLanguage => 'اختيار اللغة';

  @override
  String get settingsLanguageApplied => 'تم تطبيق اللغة';

  @override
  String get settingsSystemDefault => 'افتراضي النظام';

  @override
  String get settingsSectionCommunity => 'انضم للمجتمع!';

  @override
  String get settingsDiscord => 'Discord';

  @override
  String get settingsDiscordSubtitle => 'دردشة وتحديثات وملاحظات';

  @override
  String get settingsDiscordOpenFail => 'تعذر فتح رابط Discord';

  @override
  String get settingsSectionPro => 'ميزات PRO';

  @override
  String get settingsProCustomization => 'تخصيص PRO';

  @override
  String get settingsProSubtitle => 'إزالة الإعلانات وفتح السمات والأيقونات';

  @override
  String get settingsUnlockPro => 'فتح PRO';

  @override
  String get settingsProUnlocked => 'تم فتح وضع PRO';

  @override
  String get settingsPurchaseNotConfirmed => 'لم يتم تأكيد الشراء';

  @override
  String settingsPurchaseFailed(Object error) {
    return 'فشل الشراء: $error';
  }

  @override
  String get homeUpgrade => 'Upgrade';

  @override
  String get homeFeatureSecureVpnTitle => 'AvarionX Secure VPN';

  @override
  String get homeFeatureSecureVpnDesc => 'Hide your IP and block unwanted ads';

  @override
  String get proActivated => 'تم تفعيل PRO';

  @override
  String get proDeactivated => 'تم إيقاف PRO';

  @override
  String get settingsProReset => 'إعادة ضبط PRO (للتصحيح فقط)';

  @override
  String get settingsProSheetTitle => 'تخصيص PRO';

  @override
  String get settingsHideGoldHeader => 'إخفاء الرأس الذهبي في الشاشة الرئيسية';

  @override
  String get settingsAppIcon => 'أيقونة التطبيق';

  @override
  String settingsIconSelected(Object icon) {
    return 'الأيقونة المختارة: $icon';
  }

  @override
  String get vpnSignInRequiredTitle => 'Sign in required';

  @override
  String get vpnClose => 'Close';

  @override
  String get vpnSignInRequiredBody => 'Sign in to use Secure VPN.';

  @override
  String get vpnCancel => 'Cancel';

  @override
  String get vpnSignIn => 'Sign in';

  @override
  String get vpnUsageLoading => 'Loading usage...';

  @override
  String get vpnUsageNoLimits => 'No data limits';

  @override
  String get vpnUsageSyncing => 'Syncing';

  @override
  String vpnUsageUsedThisMonth(Object used) {
    return '$used used this month';
  }

  @override
  String get vpnUsageDataTitle => 'Data Usage';

  @override
  String get vpnUsageUnavailable => 'Usage unavailable';

  @override
  String get vpnStatusConnectingEllipsis => 'Connecting...';

  @override
  String vpnStatusConnectedTo(Object country) {
    return 'Connected to $country';
  }

  @override
  String get vpnTitleSecure => 'Secure VPN';

  @override
  String get vpnStatusConnected => 'Connected';

  @override
  String get vpnSubtitleEstablishingTunnel => 'Establishing tunnel...';

  @override
  String get vpnSubtitleFindingLocation => 'Finding location...';

  @override
  String get vpnStatusProtected => 'Protected';

  @override
  String get vpnStatusNotConnected => 'Not connected';

  @override
  String get vpnConnect => 'Connect';

  @override
  String get vpnDisconnect => 'Disconnect';

  @override
  String vpnIpLabel(Object ip) {
    return 'IP: $ip';
  }

  @override
  String vpnServerLoadLabel(Object current, Object max) {
    return '$current/$max';
  }

  @override
  String get vpnBlocklistsTitle => 'Secure VPN Blocklists';

  @override
  String get vpnSave => 'Save';

  @override
  String get settingsSave => 'حفظ';

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
  String get settingsSectionShizuku => 'حماية متقدمة (Shizuku)';

  @override
  String get settingsEnableShizuku => 'تفعيل Shizuku';

  @override
  String get settingsShizukuRequiresManager => 'يتطلب مديرًا خارجيًا';

  @override
  String get settingsShizukuNotRunning => 'خدمة Shizuku غير قيد التشغيل';

  @override
  String get settingsShizukuPermissionRequired => 'إذن مطلوب';

  @override
  String get settingsShizukuAvailable => 'وصول متقدم للنظام متاح';

  @override
  String get settingsAboutAdvancedProtection => 'حول الحماية المتقدمة';

  @override
  String get settingsAboutAdvancedProtectionSubtitle =>
      'تعرف على كيفية عمل الحماية المتقدمة';

  @override
  String get settingsAdvancedProtectionDialogTitle => 'حماية متقدمة للنظام';

  @override
  String get settingsAdvancedProtectionDialogBody =>
      'يتطلب وصول Shizuku مديرًا خارجيًا مخصصًا للمستخدمين المتقدمين.\n\nهذه الميزة اختيارية وغير موصى بها للحماية العادية.';

  @override
  String get settingsAboutShizukuTitle => 'حول Shizuku';

  @override
  String get settingsAboutShizukuBody =>
      'يمكن لـ AVarionX التكامل مع Shizuku للوصول إلى عمليات التطبيقات على مستوى النظام.\n\nيسمح ذلك للتطبيق بـ:\n• اكتشاف البرمجيات الخبيثة التي تختبئ من الماسحات القياسية\n• فحص عمليات التطبيقات قيد التشغيل\n• تعطيل أو احتواء معظم البرمجيات الخبيثة النشطة\n\nShizuku لا يمنح وصول root\n\nهذه الميزة مخصصة للمستخدمين المتقدمين وليست مطلوبة للحماية العادية.\n\nالتوثيق:\nhttps://shizuku.rikka.app';

  @override
  String get settingsSectionGeneral => 'عام';

  @override
  String get settingsExclusions => 'الاستثناءات';

  @override
  String get settingsExclusionsSubtitle => 'إدارة وإضافة الاستثناءات';

  @override
  String get settingsExcludeFolder => 'استثناء مجلد';

  @override
  String get settingsExcludeFile => 'استثناء ملف';

  @override
  String get settingsManageExclusions => 'إدارة الاستثناءات الحالية';

  @override
  String get settingsManageExclusionsSubtitle => 'عرض أو إزالة الاستثناءات';

  @override
  String get settingsFolderExcluded => 'تم استثناء المجلد';

  @override
  String get settingsFileExcluded => 'تم استثناء الملف';

  @override
  String get settingsPrivacyPolicy => 'سياسة الخصوصية';

  @override
  String get settingsPrivacyPolicySubtitle => 'عرض كيفية التعامل مع بياناتك';

  @override
  String get settingsPrivacyPolicyOpenFail => 'تعذر فتح سياسة الخصوصية';

  @override
  String get settingsAboutApp => 'حول AVarionX';

  @override
  String get settingsHowThisAppWorks => 'كيف يعمل هذا التطبيق';

  @override
  String get settingsHowThisAppWorksSubtitle => 'تعرف على الحماية';

  @override
  String get settingsThemePickerTitle => 'اختيار السمة';

  @override
  String get settingsThemeRequiresPro => 'هذه السمة تتطلب وضع PRO';

  @override
  String get scheduledScansTitle => 'عمليات فحص مجدولة';

  @override
  String get scheduledScansInfoTitle => 'عمليات فحص مجدولة';

  @override
  String get scheduledScansInfoBody =>
      'بينما يركز RTP على البرمجيات الخبيثة التي تم تنزيلها، ستطلق عمليات الفحص المجدولة وضع الفحص الذي اخترته في الخلفية تلقائيًا.\nلن تعمل إلا عندما يكون RTP مفعّلًا.\n\nيمكن لمستخدمي PRO تخصيص وضع الفحص وتكراره.';

  @override
  String get scheduledScansHeader => 'عمليات فحص تلقائية في الخلفية';

  @override
  String get scheduledScansSubheader =>
      'أثناء تفعيل RTP، سيقوم التطبيق بفحص جهازك حسب وضع الفحص والتكرار المحددين.';

  @override
  String get proRequiredToCustomize => 'يتطلب PRO للتخصيص';

  @override
  String get scheduledScansEnabledTitle => 'مفعّل';

  @override
  String get scheduledScansEnabledSubtitle =>
      'عند التفعيل، يتم تشغيل فحص تلقائيًا وفق الجدول.';

  @override
  String get scheduledScansModeTitle => 'وضع الفحص';

  @override
  String scheduledScansModeHint(Object mode) {
    return 'الوضع الحالي: $mode';
  }

  @override
  String get scheduledScansFrequencyTitle => 'التكرار';

  @override
  String scheduledScansFrequencyHint(Object freq) {
    return 'يعمل: $freq';
  }

  @override
  String get scheduledEveryDay => 'كل يوم';

  @override
  String get scheduledEvery3Days => 'كل 3 أيام';

  @override
  String get scheduledEveryWeek => 'كل أسبوع';

  @override
  String get scheduledEvery2Weeks => 'كل أسبوعين';

  @override
  String get scheduledEvery3Weeks => 'كل 3 أسابيع';

  @override
  String get scheduledMonthly => 'شهريًا';

  @override
  String scheduledEveryDays(Object days) {
    return 'كل $days يومًا';
  }

  @override
  String scheduledEveryHours(Object hours) {
    return 'كل $hours ساعة';
  }

  @override
  String get vpnSettingsPrivacySecurityTitle => 'Privacy & Security';

  @override
  String get vpnSettingsNoLogsPolicyTitle => 'No logs stored Policy';

  @override
  String get vpnSettingsNoLogsPolicyBody =>
      'No logs are stored. Connection activity, browsing activity, DNS queries, and traffic content are not recorded or retained.';

  @override
  String get vpnSettingsNoActivityLogsTitle => 'No activity logs';

  @override
  String get vpnSettingsNoActivityLogsBody =>
      'Your activity is not monitored or tracked while using Secure VPN.';

  @override
  String get vpnSettingsWireGuardTitle => 'VX-Link powered by WireGuard';

  @override
  String get vpnSettingsWireGuardBody =>
      'Secure VPN uses the WireGuard protocol through VX-Link to provide fast, modern encryption.';

  @override
  String get vpnSettingsMalwareProtectionTitle => 'Malware protection enabled';

  @override
  String get vpnSettingsMalwareProtectionBody =>
      'Malicious domains are blocked by default while connected.';

  @override
  String get vpnSettingsAdTrackerProtectionTitle =>
      'Optional ad and tracker protection';

  @override
  String get vpnSettingsAdTrackerProtectionBody =>
      'Enable additional blocking for ads and trackers in the Customisation tab.';

  @override
  String get vpnSettingsBrandFooter => 'Secured by VX-Link';

  @override
  String get vpnSettingsAccountTitle => 'Account';

  @override
  String get vpnSettingsSignInToContinue => 'Sign in to continue';

  @override
  String get vpnSettingsAccountSyncBody =>
      'Your plan and data usage sync to your account.';

  @override
  String get vpnSettingsSignedIn => 'Signed in';

  @override
  String get vpnSettingsPlanUnknown => 'Plan: unknown';

  @override
  String vpnSettingsPlanLabel(Object plan) {
    return 'Plan: $plan';
  }

  @override
  String get vpnSettingsRefresh => 'Refresh';

  @override
  String get vpnSettingsSignOut => 'Sign out';

  @override
  String get scheduledChargingOnlyTitle => 'أثناء الشحن فقط';

  @override
  String get scheduledChargingOnlySubtitle =>
      'تشغيل الفحص المجدول فقط أثناء توصيل الجهاز بالشاحن.';

  @override
  String get scheduledPreferredTimeTitle => 'الوقت المفضل';

  @override
  String get scheduledPreferredTimeSubtitle =>
      'سيحاول AVarionX البدء قرب هذا الوقت. قد يؤخره Android لتوفير البطارية.';

  @override
  String get scheduledPickTime => 'اختيار وقت';

  @override
  String get cleanerTitle => 'Cleaner Pro';

  @override
  String get cleanerReadyToScan => 'جاهز للفحص';

  @override
  String get cleanerScan => 'فحص';

  @override
  String get cleanerScanning => 'جارٍ الفحص…';

  @override
  String get cleanerReady => 'جاهز';

  @override
  String get cleanerStatusReady => 'جاهز';

  @override
  String get cleanerStatusStarting => 'جارٍ البدء…';

  @override
  String get cleanerStatusFilesScanned => 'تم فحص الملفات';

  @override
  String get cleanerStatusFindingUnusedApps =>
      'جارٍ البحث عن التطبيقات غير المستخدمة…';

  @override
  String get cleanerStatusComplete => 'مكتمل';

  @override
  String get cleanerStatusScanError => 'خطأ في الفحص';

  @override
  String get cleanerStatusScanningApps => 'جارٍ فحص التطبيقات…';

  @override
  String get cleanerGrantUsageAccessTitle => 'منح إذن الاستخدام';

  @override
  String get cleanerGrantUsageAccessBody =>
      'لاكتشاف التطبيقات غير المستخدمة، يتطلب هذا المنظف إذن الوصول إلى الاستخدام. سيتم تحويلك إلى إعدادات النظام لتفعيله.';

  @override
  String get cleanerCancel => 'إلغاء';

  @override
  String get cleanerContinue => 'متابعة';

  @override
  String get cleanerDuplicates => 'مكررات';

  @override
  String get cleanerDuplicatesNone => 'لم يتم العثور على مكررات';

  @override
  String cleanerDuplicatesSubtitle(Object count, Object size) {
    return '$count عنصر • استعادة $size';
  }

  @override
  String get cleanerOldPhotos => 'صور قديمة';

  @override
  String cleanerOldPhotosNone(Object days) {
    return 'لا توجد صور أقدم من $days يومًا';
  }

  @override
  String cleanerOldPhotosSubtitle(Object count, Object size) {
    return '$count عنصر • $size';
  }

  @override
  String get cleanerOldVideos => 'فيديوهات قديمة';

  @override
  String cleanerOldVideosNone(Object days) {
    return 'لا توجد فيديوهات أقدم من $days يومًا';
  }

  @override
  String cleanerOldVideosSubtitle(Object count, Object size) {
    return '$count عنصر • $size';
  }

  @override
  String get cleanerLargeFiles => 'ملفات كبيرة';

  @override
  String cleanerLargeFilesNone(Object size) {
    return 'لا توجد ملفات ≥ $size';
  }

  @override
  String cleanerLargeFilesSubtitle(Object count, Object sizeTotal) {
    return '$count عنصر • $sizeTotal';
  }

  @override
  String get cleanerUnusedApps => 'تطبيقات غير مستخدمة';

  @override
  String cleanerUnusedAppsNone(Object days) {
    return 'لا توجد تطبيقات غير مستخدمة (آخر $days يومًا)';
  }

  @override
  String cleanerUnusedAppsCount(Object count) {
    return '$count تطبيق';
  }

  @override
  String get cleanerStageDuplicates => 'جارٍ فحص المكررات…';

  @override
  String get cleanerStageDuplicatesGrouping => 'جارٍ تجميع المكررات…';

  @override
  String get cleanerStageOldPhotos => 'جارٍ فحص الصور القديمة…';

  @override
  String get cleanerStageOldVideos => 'جارٍ فحص الفيديوهات القديمة…';

  @override
  String get cleanerStageLargeFiles => 'جارٍ فحص الملفات الكبيرة…';

  @override
  String cleanerStageOldPhotosProgress(Object count, Object size) {
    return 'صور قديمة: $count • $size';
  }

  @override
  String get vpnAccountScreenTitle => 'Account';

  @override
  String get vpnAccountSignInRequiredTitle => 'Sign in required';

  @override
  String get vpnAccountSignInManageUsageBody =>
      'Sign in to manage your account and usage.';

  @override
  String get vpnAccountNotSignedIn => 'Not signed in';

  @override
  String get vpnAccountFree => 'Free';

  @override
  String get vpnAccountUnknown => 'Unknown';

  @override
  String get vpnAccountStatusSyncing => 'Syncing';

  @override
  String get vpnAccountStatusActive => 'Active';

  @override
  String get vpnAccountStatusConnected => 'Connected';

  @override
  String get vpnAccountStatusDisconnected => 'Disconnected';

  @override
  String get vpnAccountStatusUnavailable => 'Unavailable';

  @override
  String get vpnAccountStatusConnectedNow => 'Connected now';

  @override
  String get vpnAccountStatusRefreshToLoadServer =>
      'Refresh to load server status';

  @override
  String get vpnAccountUsageTitle => 'Usage';

  @override
  String get vpnAccountUsageLoading => 'Loading usage...';

  @override
  String get vpnAccountUsageSignInToSync => 'Sign in to sync usage';

  @override
  String get vpnAccountUsagePullToRefresh => 'Pull to refresh to sync usage';

  @override
  String get vpnAccountUsageUnlimited => 'Unlimited';

  @override
  String vpnAccountUsageUsedThisMonth(Object used) {
    return '$used used this month';
  }

  @override
  String vpnAccountUsageUsedThisMonthUnlimited(Object used) {
    return '$used used this month, unlimited';
  }

  @override
  String vpnAccountUsageUsedOfLimit(Object used, Object limit) {
    return '$used / $limit';
  }

  @override
  String get settingsSectionAccount => 'Account';

  @override
  String get settingsAccountTitle => 'Account';

  @override
  String get settingsAccountSubtitle =>
      'Sign in, plan, subscription, and account usage';

  @override
  String get exploreSecureVpnTitle => 'Secure VPN';

  @override
  String get exploreSecureVpnSubtitle =>
      'Hide your IP and block unwanted content';

  @override
  String get vpnAccountServerLoadTitle => 'Selected Server Load';

  @override
  String vpnAccountServerConnectedCount(Object connected, Object cap) {
    return '$connected/$cap';
  }

  @override
  String get networkDnsOffTitle => 'Switch to DNS filtering?';

  @override
  String get networkDnsOffInfoTitle => 'What is DNS filtering?';

  @override
  String get networkDnsOffInfoBody1 =>
      'DNS filtering is separate from Secure VPN. It can block known malware, ads across apps, trackers, and unwanted categories before they load.';

  @override
  String get networkDnsOffInfoBody2 =>
      'It does not encrypt your traffic or hide your IP.';

  @override
  String get networkDnsOffEnableButton => 'Enable DNS Filtering';

  @override
  String vpnAccountServerConnectedCountWithLabel(Object connected, Object cap) {
    return '$connected/$cap connected';
  }

  @override
  String get vpnAccountIdentityFallbackTitle => 'Account';

  @override
  String get vpnAccountMembershipLabel => 'Membership';

  @override
  String get vpnAccountMembershipFounderVpnPro => 'Founders · VPN Pro';

  @override
  String get vpnAccountMembershipFounder => 'Founder';

  @override
  String get vpnAccountMembershipPro => 'Pro';

  @override
  String get vpnAccountSectionAccountStatus => 'Account Status';

  @override
  String get vpnAccountSectionActions => 'Actions';

  @override
  String get vpnAccountKvStatus => 'Status';

  @override
  String get vpnAccountKvPlan => 'Plan';

  @override
  String get vpnAccountKvUsage => 'Usage';

  @override
  String get vpnAccountKvSelectedServer => 'Selected Server';

  @override
  String get vpnAccountKvConnectionState => 'Connection State';

  @override
  String get vpnAccountActionRefresh => 'Refresh';

  @override
  String get vpnAccountActionOpen => 'Open';

  @override
  String get vpnAccountFounderThanks => 'Thank you for supporting ColourSwift';

  @override
  String get vpnAccountFounderNote =>
      'I\'m just one guy, held by the greatest community.';

  @override
  String cleanerStageOldVideosProgress(Object count, Object size) {
    return 'فيديوهات قديمة: $count • $size';
  }

  @override
  String cleanerStageLargeFilesProgress(Object count, Object size) {
    return 'ملفات كبيرة: $count • $size';
  }

  @override
  String get unusedAppsTitle => 'تطبيقات غير مستخدمة';

  @override
  String unusedAppsEmpty(Object days) {
    return 'لا توجد تطبيقات غير مستخدمة خلال آخر $days يومًا';
  }

  @override
  String get quarantineTitle => 'المحذوفات';

  @override
  String get quarantineSelectAll => 'تحديد الكل';

  @override
  String get quarantineRefresh => 'تحديث';

  @override
  String get quarantineEmptyTitle => 'لا توجد ملفات محذوفة';

  @override
  String get quarantineEmptyBody => 'أي شيء تزيله سيظهر هنا.';

  @override
  String get quarantineRestore => 'استعادة';

  @override
  String get quarantineDelete => 'حذف';

  @override
  String get quarantineSnackRestored => 'تمت الاستعادة';

  @override
  String get quarantineSnackDeleted => 'تم الحذف';

  @override
  String get quarantineDeleteDialogTitle => 'حذف الملفات المحددة؟';

  @override
  String quarantineDeleteDialogBody(Object count, Object plural) {
    return 'سيؤدي هذا إلى حذف $count عنصر$plural نهائيًا.';
  }
}
