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
  String get companionAppsSectionTitle => 'المزيد من AvarionX';

  @override
  String get cleanerReclaimableLabel => 'يمكن تحريرها';

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
  String get engineReadyBanner => 'VX-TITANIUM-v9';

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
  String get onboardingAppName => 'AvarionX Security';

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
      'تعمل بعض التهديدات عبر الاتصال بخوادم خبيثة أو إعادة توجيه حركة الإنترنت.\nحماية الشبكة تحظر النطاقات الخطرة المعروفة والإعلانات الشائعة باستخدام VPN محلي.\n\nAvarionX Security لا يجمع أي بيانات.';

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
  String get homeUpgrade => 'ترقية';

  @override
  String get homeFeatureSecureVpnTitle => 'AvarionX Secure VPN';

  @override
  String get homeFeatureSecureVpnDesc =>
      'أخفِ عنوان IP الخاص بك واحظر الإعلانات غير المرغوب فيها';

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
  String get vpnSignInRequiredTitle => 'تسجيل الدخول مطلوب';

  @override
  String get vpnClose => 'إغلاق';

  @override
  String get vpnSignInRequiredBody => 'سجّل الدخول لاستخدام Secure VPN.';

  @override
  String get vpnCancel => 'إلغاء';

  @override
  String get vpnSignIn => 'تسجيل الدخول';

  @override
  String get vpnUsageLoading => 'جارٍ تحميل الاستخدام...';

  @override
  String get vpnUsageNoLimits => 'لا توجد حدود للبيانات';

  @override
  String get vpnUsageSyncing => 'جارٍ المزامنة';

  @override
  String vpnUsageUsedThisMonth(Object used) {
    return 'تم استخدام $used هذا الشهر';
  }

  @override
  String get vpnUsageDataTitle => 'استخدام البيانات';

  @override
  String get vpnUsageUnavailable => 'بيانات الاستخدام غير متاحة';

  @override
  String get vpnStatusConnectingEllipsis => 'جارٍ الاتصال...';

  @override
  String vpnStatusConnectedTo(Object country) {
    return 'متصل بـ $country';
  }

  @override
  String get vpnTitleSecure => 'Secure VPN';

  @override
  String get vpnStatusConnected => 'متصل';

  @override
  String get vpnSubtitleEstablishingTunnel => 'جارٍ إنشاء النفق...';

  @override
  String get vpnSubtitleFindingLocation => 'جارٍ تحديد الموقع...';

  @override
  String get vpnStatusProtected => 'محمي';

  @override
  String get vpnStatusNotConnected => 'غير متصل';

  @override
  String get vpnConnect => 'اتصال';

  @override
  String get vpnDisconnect => 'قطع الاتصال';

  @override
  String vpnIpLabel(Object ip) {
    return 'IP: $ip';
  }

  @override
  String vpnServerLoadLabel(Object current, Object max) {
    return '$current/$max';
  }

  @override
  String get vpnBlocklistsTitle => 'قوائم حظر Secure VPN';

  @override
  String get vpnSave => 'حفظ';

  @override
  String get settingsSave => 'حفظ';

  @override
  String get settingsPremium => 'Premium';

  @override
  String get settingsUltimateSecurity => 'الحماية القصوى';

  @override
  String get settingsSwitchPlan => 'تغيير الخطة';

  @override
  String get settingsBestValue => 'أفضل قيمة';

  @override
  String get settingsOneTime => 'دفعة واحدة';

  @override
  String get settingsPlanPriceLoading => 'جارٍ تحميل السعر...';

  @override
  String get settingsMonthly => 'شهري';

  @override
  String get settingsYearly => 'سنوي';

  @override
  String get settingsLifetime => 'مدى الحياة';

  @override
  String get settingsSubscribeMonthly => 'اشتراك شهري';

  @override
  String get settingsSubscribeYearly => 'اشتراك سنوي';

  @override
  String get settingsUnlockLifetime => 'فتح مدى الحياة';

  @override
  String get settingsProBenefitsTitle => 'المزايا';

  @override
  String get settingsUnlimitedDnsTitle => 'استعلامات DNS غير محدودة';

  @override
  String get settingsUnlimitedDnsBody =>
      'أزل حدود الاستعلامات وافتح التصفية السحابية الكاملة.';

  @override
  String get settingsThemesTitle => 'السمات';

  @override
  String get settingsThemesBody => 'افتح السمات المميزة وخيارات التخصيص.';

  @override
  String get settingsIconCustomizationTitle => 'تخصيص أيقونة التطبيق';

  @override
  String get settingsIconCustomizationBody =>
      'غيّر أيقونة التطبيق لتناسب أسلوبك.';

  @override
  String get settingsScheduledScansTitle => 'عمليات الفحص المجدولة';

  @override
  String get settingsScheduledScansBody =>
      'افتح الجدولة المتقدمة وتخصيص عمليات الفحص.';

  @override
  String get settingsProFinePrint =>
      'تتجدد الاشتراكات ما لم يتم إلغاؤها. يمكنك إدارتها أو إلغاؤها في أي وقت من Google Play. خيار مدى الحياة هو عملية شراء لمرة واحدة.';

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
      'يمكن لـ AvarionX التكامل مع Shizuku للوصول إلى عمليات التطبيقات على مستوى النظام.\n\nيسمح ذلك للتطبيق بـ:\n• اكتشاف البرمجيات الخبيثة التي تختبئ من الماسحات القياسية\n• فحص عمليات التطبيقات قيد التشغيل\n• تعطيل أو احتواء معظم البرمجيات الخبيثة النشطة\n\nShizuku لا يمنح وصول root\n\nهذه الميزة مخصصة للمستخدمين المتقدمين وليست مطلوبة للحماية العادية.\n\nالتوثيق:\nhttps://shizuku.rikka.app';

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
  String get settingsAboutApp => 'حول AvarionX';

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
  String get vpnSettingsPrivacySecurityTitle => 'الخصوصية والأمان';

  @override
  String get vpnSettingsNoLogsPolicyTitle => 'سياسة عدم تخزين السجلات';

  @override
  String get vpnSettingsNoLogsPolicyBody =>
      'لا يتم تخزين أي سجلات. لا يتم تسجيل أو الاحتفاظ بنشاط الاتصال أو نشاط التصفح أو استعلامات DNS أو محتوى حركة البيانات.';

  @override
  String get vpnSettingsNoActivityLogsTitle => 'لا توجد سجلات نشاط';

  @override
  String get vpnSettingsNoActivityLogsBody =>
      'لا تتم مراقبة نشاطك أو تتبعه أثناء استخدام Secure VPN.';

  @override
  String get vpnSettingsWireGuardTitle => 'VX-Link مدعوم بواسطة WireGuard';

  @override
  String get vpnSettingsWireGuardBody =>
      'يستخدم Secure VPN بروتوكول WireGuard عبر VX-Link لتوفير تشفير سريع وحديث.';

  @override
  String get vpnSettingsMalwareProtectionTitle =>
      'الحماية من البرمجيات الضارة مفعّلة';

  @override
  String get vpnSettingsMalwareProtectionBody =>
      'يتم حظر النطاقات الضارة افتراضيًا أثناء الاتصال.';

  @override
  String get vpnSettingsAdTrackerProtectionTitle =>
      'حماية اختيارية من الإعلانات وأدوات التتبع';

  @override
  String get vpnSettingsAdTrackerProtectionBody =>
      'فعّل حظرًا إضافيًا للإعلانات وأدوات التتبع من تبويب التخصيص.';

  @override
  String get vpnSettingsBrandFooter => 'مؤمّن بواسطة VX-Link';

  @override
  String get vpnSettingsAccountTitle => 'الحساب';

  @override
  String get vpnSettingsSignInToContinue => 'سجّل الدخول للمتابعة';

  @override
  String get vpnSettingsAccountSyncBody =>
      'تتم مزامنة خطتك واستخدام البيانات مع حسابك.';

  @override
  String get vpnSettingsSignedIn => 'تم تسجيل الدخول';

  @override
  String get vpnSettingsPlanUnknown => 'الخطة: غير معروفة';

  @override
  String vpnSettingsPlanLabel(Object plan) {
    return 'الخطة: $plan';
  }

  @override
  String get vpnSettingsRefresh => 'تحديث';

  @override
  String get vpnSettingsSignOut => 'تسجيل الخروج';

  @override
  String get scheduledChargingOnlyTitle => 'أثناء الشحن فقط';

  @override
  String get scheduledChargingOnlySubtitle =>
      'تشغيل الفحص المجدول فقط أثناء توصيل الجهاز بالشاحن.';

  @override
  String get scheduledPreferredTimeTitle => 'الوقت المفضل';

  @override
  String get scheduledPreferredTimeSubtitle =>
      'سيحاول AvarionX البدء قرب هذا الوقت. قد يؤخره Android لتوفير البطارية.';

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
  String get vpnAccountScreenTitle => 'الحساب';

  @override
  String get vpnAccountSignInRequiredTitle => 'تسجيل الدخول مطلوب';

  @override
  String get vpnAccountSignInManageUsageBody =>
      'سجّل الدخول لإدارة حسابك واستخدامك.';

  @override
  String get vpnAccountNotSignedIn => 'لم يتم تسجيل الدخول';

  @override
  String get vpnAccountFree => 'مجاني';

  @override
  String get vpnAccountUnknown => 'غير معروف';

  @override
  String get vpnAccountStatusSyncing => 'جارٍ المزامنة';

  @override
  String get vpnAccountStatusActive => 'نشط';

  @override
  String get vpnAccountStatusConnected => 'متصل';

  @override
  String get vpnAccountStatusDisconnected => 'غير متصل';

  @override
  String get vpnAccountStatusUnavailable => 'غير متاح';

  @override
  String get vpnAccountStatusConnectedNow => 'متصل الآن';

  @override
  String get vpnAccountStatusRefreshToLoadServer => 'حدّث لتحميل حالة الخادم';

  @override
  String get vpnAccountUsageTitle => 'الاستخدام';

  @override
  String get vpnAccountUsageLoading => 'جارٍ تحميل الاستخدام...';

  @override
  String get vpnAccountUsageSignInToSync => 'سجّل الدخول لمزامنة الاستخدام';

  @override
  String get vpnAccountUsagePullToRefresh => 'اسحب للتحديث لمزامنة الاستخدام';

  @override
  String get vpnAccountUsageUnlimited => 'غير محدود';

  @override
  String vpnAccountUsageUsedThisMonth(Object used) {
    return 'تم استخدام $used هذا الشهر';
  }

  @override
  String vpnAccountUsageUsedThisMonthUnlimited(Object used) {
    return 'تم استخدام $used هذا الشهر، غير محدود';
  }

  @override
  String vpnAccountUsageUsedOfLimit(Object used, Object limit) {
    return '$used / $limit';
  }

  @override
  String get settingsSectionAccount => 'الحساب';

  @override
  String get settingsAccountTitle => 'الحساب';

  @override
  String get settingsAccountSubtitle =>
      'تسجيل الدخول والخطة والاشتراك واستخدام الحساب';

  @override
  String get exploreSecureVpnTitle => 'Secure VPN';

  @override
  String get exploreSecureVpnSubtitle =>
      'أخفِ عنوان IP الخاص بك واحظر المحتوى غير المرغوب فيه';

  @override
  String get vpnAccountServerLoadTitle => 'حِمل الخادم المحدد';

  @override
  String vpnAccountServerConnectedCount(Object connected, Object cap) {
    return '$connected/$cap';
  }

  @override
  String get networkDnsOffTitle => 'التبديل إلى تصفية DNS؟';

  @override
  String get networkDnsOffInfoTitle => 'ما هي تصفية DNS؟';

  @override
  String get networkDnsOffInfoBody1 =>
      'تصفية DNS منفصلة عن Secure VPN. يمكنها حظر البرمجيات الضارة المعروفة والإعلانات عبر التطبيقات وأدوات التتبع والفئات غير المرغوب فيها قبل تحميلها.';

  @override
  String get networkDnsOffInfoBody2 =>
      'لا تقوم بتشفير حركة بياناتك أو إخفاء عنوان IP الخاص بك.';

  @override
  String get networkDnsOffEnableButton => 'تفعيل تصفية DNS';

  @override
  String vpnAccountServerConnectedCountWithLabel(Object connected, Object cap) {
    return '$connected/$cap متصل';
  }

  @override
  String get vpnAccountIdentityFallbackTitle => 'الحساب';

  @override
  String get vpnAccountMembershipLabel => 'العضوية';

  @override
  String get vpnAccountMembershipFounderVpnPro => 'المؤسسون · VPN Pro';

  @override
  String get vpnAccountMembershipFounder => 'مؤسس';

  @override
  String get vpnAccountMembershipPro => 'Pro';

  @override
  String get vpnAccountSectionAccountStatus => 'حالة الحساب';

  @override
  String get vpnAccountSectionActions => 'الإجراءات';

  @override
  String get vpnAccountKvStatus => 'الحالة';

  @override
  String get vpnAccountKvPlan => 'الخطة';

  @override
  String get vpnAccountKvUsage => 'الاستخدام';

  @override
  String get vpnAccountKvSelectedServer => 'الخادم المحدد';

  @override
  String get vpnAccountKvConnectionState => 'حالة الاتصال';

  @override
  String get vpnAccountActionRefresh => 'تحديث';

  @override
  String get vpnAccountActionOpen => 'فتح';

  @override
  String get vpnAccountFounderThanks => 'شكرًا لدعمك ColourSwift';

  @override
  String get vpnAccountFounderNote => 'أنا مجرد شخص واحد، ويسندني أعظم مجتمع.';

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
  String quarantineDeleteDialogBody(Object count, String plural) {
    String _temp0 = intl.Intl.selectLogic(
      plural,
      {
        's': '',
        'other': '',
      },
    );
    return 'عدد العناصر التي سيتم حذفها نهائيًا: $count.$_temp0';
  }

  @override
  String get howThisAppWorksHowAvarionXWorks => 'كيف يعمل AvarionX';

  @override
  String get howThisAppWorksAvarionxIsAMobileSecurityAppThat =>
      'AvarionX هو تطبيق أمان للهواتف يجمع بين فحص مكافحة الفيروسات على الجهاز وحماية الشبكة وميزات VPN الاختيارية. ';

  @override
  String get howThisAppWorksTheAntivirusEngineIsPoweredByVX =>
      'محرك مكافحة الفيروسات مدعوم بواسطة VX-Titanium.';

  @override
  String get howThisAppWorksIfYouUseNetworkProtectionOrVPN =>
      'إذا كنت تستخدم حماية الشبكة أو ميزات VPN، يتصل التطبيق بخدمات ColourSwift لتطبيق إعداداتك وإدارة الوصول إلى حسابك وتوجيه حركة البيانات المحمية.';

  @override
  String get howThisAppWorksKeyFeatures => 'الميزات الرئيسية';

  @override
  String get howThisAppWorksRealTimeProtectionForDownloadedThreats =>
      '• حماية في الوقت الفعلي من التهديدات التي يتم تنزيلها';

  @override
  String get howThisAppWorksNetworkProtectionWithDNSFiltering =>
      '• حماية الشبكة مع تصفية DNS';

  @override
  String get howThisAppWorksOptionalSecureVPNMode => '• وضع Secure VPN اختياري';

  @override
  String get howThisAppWorksBuiltInToolsSuchAsLinkChecker =>
      '• أدوات مدمجة مثل Link Checker';

  @override
  String get howThisAppWorksNotes => 'ملاحظات';

  @override
  String get howThisAppWorksSomeFeaturesMayRequireSignInAn =>
      'قد تتطلب بعض الميزات تسجيل الدخول أو خطة نشطة أو أذونات على الجهاز لتعمل بشكل صحيح.';

  @override
  String get apkAnalyserCopyCurrentReport => 'نسخ التقرير الحالي';

  @override
  String get apkAnalyserReportCopiedToClipboard => 'تم نسخ التقرير إلى الحافظة';

  @override
  String get apkAnalyserExportCurrentAsPDF => 'تصدير الحالي كملف PDF';

  @override
  String get apkAnalyserFailedToExportPDF => 'فشل تصدير PDF';

  @override
  String get apkAnalyserExportCurrentAsCSV => 'تصدير الحالي كملف CSV';

  @override
  String get apkAnalyserFailedToExportCSV => 'فشل تصدير CSV';

  @override
  String get apkAnalyserViewSavedReports => 'عرض التقارير المحفوظة';

  @override
  String get apkAnalyserClearHistory => 'مسح السجل';

  @override
  String get apkAnalyserReportHistoryCleared => 'تم مسح سجل التقارير';

  @override
  String get apkAnalyserSavedReports => 'التقارير المحفوظة';

  @override
  String get apkAnalyserNoSavedReportsFound =>
      'لم يتم العثور على تقارير محفوظة.';

  @override
  String get apkAnalyserChooseTarget => 'اختر الهدف';

  @override
  String get apkAnalyserSelectASourceToAnalyseWithVTTI =>
      'اختر مصدرًا لتحليله باستخدام VTTI Cloud.';

  @override
  String get apkAnalyserApkFile => 'ملف APK';

  @override
  String get apkAnalyserPickAnApkFromStorage =>
      'اختر ملف .apk من مساحة التخزين';

  @override
  String get apkAnalyserInstalledApp => 'تطبيق مثبت';

  @override
  String get apkAnalyserChooseFromAppsOnThisDevice =>
      'اختر من التطبيقات الموجودة على هذا الجهاز';

  @override
  String apkAnalyserAnalysingIn(Object countdown) {
    return 'سيبدأ التحليل خلال $countdown...';
  }

  @override
  String get apkAnalyserStartingAnalysis => 'جارٍ بدء التحليل...';

  @override
  String get apkAnalyserApkFileOrInstalledApp => 'ملف APK أو تطبيق مثبت';

  @override
  String get apkAnalyserDeepAnalysisMode => 'وضع التحليل العميق';

  @override
  String get apkAnalyserAMoreComplexAnalysisUsingGlobalData =>
      'تحليل أكثر تعقيدًا باستخدام مصادر بيانات عالمية';

  @override
  String get apkAnalyserRequiresProToUnlockDeeperAnalysis =>
      'يتطلب Pro لفتح التحليل الأعمق';

  @override
  String get apkAnalyserApkAnalyser => 'محلل APK';

  @override
  String get apkAnalyserPleaseSignInViaSettingsToEnable =>
      'يرجى تسجيل الدخول عبر الإعدادات لتفعيل Cloud Analysis.';

  @override
  String get apkAnalyserAdvancedOPTIONS => 'خيارات متقدمة';

  @override
  String apkAnalyserDailyLimit(Object remaining, Object limit) {
    return 'الحد اليومي: $remaining / $limit';
  }

  @override
  String get apkAnalyserDailyLimitDataUnavailable =>
      'بيانات الحد اليومي غير متاحة';

  @override
  String get apkAnalyserPoweredByVTTICloud => 'مدعوم بواسطة VTTI Cloud';

  @override
  String get apkAnalyserSearchApps => 'البحث في التطبيقات...';

  @override
  String get apkAnalyserFailedToLoadApps => 'فشل تحميل التطبيقات.';

  @override
  String get apkAnalyserNoAppsFound => 'لم يتم العثور على تطبيقات.';

  @override
  String get apkReportSummary => 'الملخص';

  @override
  String get apkReportPermissions => 'الأذونات';

  @override
  String get apkReportExtraFlags => 'علامات إضافية';

  @override
  String get apkReportRiskSignals => 'مؤشرات المخاطر';

  @override
  String get apkReportSources => 'المصادر';

  @override
  String get apkReportMetadata => 'البيانات الوصفية';

  @override
  String get apkReportCopyReport => 'نسخ التقرير';

  @override
  String get apkReportReportCopiedToClipboard => 'تم نسخ التقرير إلى الحافظة';

  @override
  String get apkReportExportAsPDF => 'تصدير كملف PDF';

  @override
  String get apkReportFailedToExportPDF => 'فشل تصدير PDF';

  @override
  String get apkReportExportAsCSV => 'تصدير كملف CSV';

  @override
  String get apkReportFailedToExportCSV => 'فشل تصدير CSV';

  @override
  String get apkReportAnalysisReport => 'تقرير التحليل';

  @override
  String get apkReportMalwareRisk => 'مخاطر البرمجيات الضارة';

  @override
  String get apkReportNoSummaryGenerated => 'لم يتم إنشاء ملخص.';

  @override
  String get apkReportNoRequestedPermissionsExtracted =>
      'لم يتم استخراج أي أذونات مطلوبة.';

  @override
  String get apkReportContributing => 'عوامل مساهمة';

  @override
  String get apkReportDampening => 'عوامل مخفِّضة';

  @override
  String get bootOptimisingYourProtection => 'جارٍ تحسين حمايتك';

  @override
  String get exclusionsFolders => 'المجلدات';

  @override
  String get exclusionsNone => 'لا شيء';

  @override
  String get exclusionsFiles => 'الملفات';

  @override
  String get exploreApkAnalyser => 'محلل APK';

  @override
  String get exploreCreateADetailedAnalysisOnAnyAPK =>
      'أنشئ تحليلًا مفصلًا لأي APK';

  @override
  String get featuresComingSoon => 'قريبًا';

  @override
  String get featuresWantToLearnMore => 'هل تريد معرفة المزيد؟';

  @override
  String get homeDrawerApkAnalyser => 'محلل APK';

  @override
  String get homeDrawerAdvanced => 'متقدم';

  @override
  String get homeDrawerQuarantine => 'الحجر الصحي';

  @override
  String get homeDrawerUpgradeToPro => 'الترقية إلى Pro';

  @override
  String get homeDrawerAvarionxVPN => 'AvarionX VPN';

  @override
  String get homeDrawerProtectYourInternetWithOurUnlimitedVPN =>
      'احمِ اتصالك بالإنترنت باستخدام VPN غير المحدود لدينا';

  @override
  String get deviceSecurityDeviceSecurity => 'أمان الجهاز';

  @override
  String get deviceSecurityDeviceHealthStatus => 'حالة أمان الجهاز';

  @override
  String get deviceSecurityDeviceSecurityRecommendations =>
      'توصيات أمان الجهاز';

  @override
  String get deviceSecurityStopIgnoring => 'إلغاء التجاهل';

  @override
  String get deviceSecurityIgnoreCheck => 'تجاهل الفحص';

  @override
  String get deviceSecurityNoScreenLock => 'لا يوجد قفل للشاشة';

  @override
  String get deviceSecurityAMissingSecureLockMakesLocalAccess =>
      'غياب قفل آمن يجعل الوصول المباشر إلى الجهاز أسهل.';

  @override
  String get deviceSecurityRootShizukuActive => 'Root/Shizuku نشط';

  @override
  String get deviceSecurityRootOrShizukuCanGrantPowerfulDevice =>
      'يمكن أن يمنح Root أو Shizuku تحكمًا قويًا بالجهاز.';

  @override
  String get deviceSecurityDisabledAppVerification =>
      'التحقق من التطبيقات معطّل';

  @override
  String get deviceSecurityAppVerificationHelpsDetectHarmfulInstalls =>
      'يساعد التحقق من التطبيقات في اكتشاف عمليات التثبيت الضارة.';

  @override
  String get deviceSecurityOldAndroidSecurityPatch => 'تصحيح أمان Android قديم';

  @override
  String get deviceSecurityOlderPatchLevelsMayLeaveKnownIssues =>
      'قد تترك مستويات التصحيح القديمة مشكلات معروفة دون إصلاح.';

  @override
  String get deviceSecurityDeveloperModeOn => 'وضع المطور مفعّل';

  @override
  String get deviceSecurityDeveloperOptionsExposeAdvancedDeviceControls =>
      'تتيح خيارات المطور عناصر تحكم متقدمة في الجهاز.';

  @override
  String get deviceSecurityUsbDebuggingOn => 'تصحيح أخطاء USB مفعّل';

  @override
  String get deviceSecurityUsbDebuggingAllowsADBControlFromTrusted =>
      'يسمح تصحيح أخطاء USB بالتحكم عبر ADB من أجهزة الكمبيوتر الموثوقة.';

  @override
  String get deviceSecurityUnknownSourcesAllowed =>
      'المصادر غير المعروفة مسموح بها';

  @override
  String get deviceSecuritySideloadingCanBypassNormalAppStoreChecks =>
      'يمكن للتثبيت الجانبي تجاوز فحوصات متجر التطبيقات المعتادة.';

  @override
  String get deviceSecurityAccessibilityAbuseRisk =>
      'خطر إساءة استخدام إمكانية الوصول';

  @override
  String get deviceSecurityAccessibilityServicesCanReadAndControlScreen =>
      'يمكن لخدمات إمكانية الوصول قراءة الشاشة والتحكم في الإجراءات عليها.';

  @override
  String get homeHelpImproveDetectionsForEverybody =>
      'ساعد في تحسين الاكتشاف للجميع';

  @override
  String get homeApkSAndroidAppsFoundToBe =>
      'ملفات APK (تطبيقات Android) التي يتبين أنها ضارة ';

  @override
  String get homeCanBeUploadedTo => 'يمكن رفعها إلى ';

  @override
  String get homeAndSharedWithTheCommunityThisIs =>
      ' ومشاركتها مع المجتمع. يقتصر هذا ';

  @override
  String get homeStrictlyLimitedToAPKFilesNOTYour =>
      'بشكل صارم على ملفات APK، وليس ';

  @override
  String get homeDocuments => 'مستنداتك الشخصية.\n\n';

  @override
  String get homeThisWillImproveDetectionsForEveryoneThat =>
      'سيساعد هذا في تحسين الاكتشاف لكل من ';

  @override
  String get homeUsesAvarionXNoPressureThough =>
      'يستخدم AvarionX. لا يوجد أي ضغط عليك!\n\n';

  @override
  String get homeThanks => 'شكرًا،\n';

  @override
  String get homeRyanfromcolourswift => 'RyanFromColourswift';

  @override
  String get homeSure => 'بالتأكيد!';

  @override
  String get homeNoThanks => 'لا شكرًا!';

  @override
  String get homePsstCustomiseItHere => 'همسًا... خصّصه من هنا';

  @override
  String get homeScanNow => 'افحص الآن';

  @override
  String get homeManuallyCheckYourDeviceForMalware =>
      'افحص جهازك يدويًا بحثًا عن البرمجيات الضارة';

  @override
  String get homeDeviceSecurity => 'أمان الجهاز';

  @override
  String get homeScanModes => 'أوضاع الفحص';

  @override
  String get homeCloudAssistedChecksEnabled =>
      'الفحوصات بمساعدة السحابة مفعّلة';

  @override
  String get homeLocalScanEngineOnly => 'محرك الفحص المحلي فقط';

  @override
  String get homeProtectedByVXTITANIUM => 'محمي بواسطة VX-TITANIUM';

  @override
  String get homeSecurityOverview => 'نظرة عامة على الأمان';

  @override
  String get homeFilesChecked => 'الملفات التي تم فحصها';

  @override
  String get homeThreats => 'التهديدات';

  @override
  String get securityReportAvarionxSecurityReport => 'تقرير أمان Avarionx';

  @override
  String get securityReportSecurityReport => 'تقرير الأمان';

  @override
  String get securityReportManualScans => 'عمليات الفحص اليدوية';

  @override
  String get securityReportRealtimeChecks => 'فحوصات الوقت الفعلي';

  @override
  String get securityReportTotalFilesScanned => 'إجمالي الملفات التي تم فحصها';

  @override
  String get securityReportThreatsFound => 'التهديدات المكتشفة';

  @override
  String get securityReportGenerateReport => 'إنشاء تقرير';

  @override
  String get securityReportLiveReport => 'تقرير مباشر';

  @override
  String get securityReportThisBoxUpdatesAsScanServicesWrite =>
      'يتم تحديث هذا المربع بينما تكتب خدمات الفحص بيانات التقرير.';

  @override
  String get securityReportExportPDF => 'تصدير PDF';

  @override
  String get securityReportExportCSV => 'تصدير CSV';

  @override
  String get homeLegacyProActivated => 'تم تفعيل Pro';

  @override
  String get homeLegacyProDeactivated => 'تم إلغاء تفعيل Pro';

  @override
  String get linkCheckPoweredByVTTICloud => 'مدعوم بواسطة VTTI Cloud';

  @override
  String get safeViewSafeView => 'Safe View';

  @override
  String get passwordSettingsChangingThisAltersAllPasswords =>
      'تغيير هذا سيغيّر جميع كلمات المرور.\n';

  @override
  String get passwordSettingsUsingTheSameMetaPassRestoresThem =>
      'استخدام MetaPass نفسه يعيد إنشاءها.';

  @override
  String get passwordSettingsPasswordsAreNeverStored =>
      'لا يتم تخزين كلمات المرور مطلقًا.\n\n';

  @override
  String get passwordSettingsTheRestoreCodeContainsOnlyStructureData =>
      'يحتوي رمز الاستعادة على بيانات البنية فقط. ';

  @override
  String get passwordSettingsCombinedWithYourMetaPassItRebuildsYour =>
      'وعند دمجه مع MetaPass الخاص بك، يعيد بناء خزنتك.';

  @override
  String get passwordManagerContinue => 'متابعة';

  @override
  String passwordManagerFailedToLoadApps(Object e) {
    return 'فشل تحميل التطبيقات: $e';
  }

  @override
  String passwordManagerFailedToGeneratePassword(Object e) {
    return 'فشل إنشاء كلمة المرور: $e';
  }

  @override
  String get passwordManagerPasswordsAreNeverStored =>
      'لا يتم تخزين كلمات المرور مطلقًا.\n\n';

  @override
  String get passwordManagerEachEntryDerivesAPasswordFrom =>
      'تُشتق كلمة مرور كل إدخال من:\n';

  @override
  String get passwordManagerYourMetaPassword =>
      '• كلمة المرور الوصفية الخاصة بك\n';

  @override
  String get passwordManagerTheLabelName => '• اسم التصنيف\n';

  @override
  String get passwordManagerTheVersionAndLength => '• الإصدار والطول\n\n';

  @override
  String get passwordManagerReinstallingTheAppWithTheSameMeta =>
      'إعادة تثبيت التطبيق باستخدام كلمة المرور الوصفية نفسها والتصنيفات نفسها تعيد إنشاء كلمات المرور ذاتها.';

  @override
  String get permissionsIntroSetupIsNowCompleteTimeToSecure =>
      'اكتمل الإعداد الآن! حان وقت تأمين بياناتك.';

  @override
  String get proScreenThankYou => 'شكرًا لك';

  @override
  String get proScreenYourSubscriptionIsConfirmed => 'تم تأكيد اشتراكك.';

  @override
  String get proScreenCurrent => 'الحالي';

  @override
  String get proScreenAdvancedStealthMode => 'وضع Stealth+ المتقدم';

  @override
  String get proScreenUnlockStealthTransportModesForRestrictiveNetworks =>
      'افتح أوضاع نقل خفية للشبكات المقيّدة.';

  @override
  String get proScreenGlobalServerAccess => 'الوصول إلى الخوادم العالمية';

  @override
  String get proScreenAccessEveryVPNServerLocationIncludingPremium =>
      'تمتع بالوصول إلى كل مواقع خوادم VPN، بما في ذلك المناطق المميزة عالية السرعة.';

  @override
  String get proScreenBilledMonthly => 'تتم الفوترة شهريًا';

  @override
  String proScreenMo(Object monthlyInfo) {
    return '$monthlyInfo/شهر';
  }

  @override
  String proScreenMo2(Object currencyCode) {
    return '$currencyCode/شهر';
  }

  @override
  String get proScreenCurrentPlan => 'الخطة الحالية';

  @override
  String get quarantineScreenQuarantineDataCorruptedResetting =>
      'بيانات الحجر الصحي تالفة. جارٍ إعادة الضبط.';

  @override
  String get quarantineScreenUninstallApp => 'إلغاء تثبيت التطبيق';

  @override
  String quarantineScreenUninstall(Object appName) {
    return 'هل تريد إلغاء تثبيت $appName؟';
  }

  @override
  String get quarantineScreenUninstall2 => 'إلغاء التثبيت';

  @override
  String get quarantineScreenFailedToLaunchUninstall => 'فشل بدء إلغاء التثبيت';

  @override
  String get quarantineScreenFiles => 'الملفات';

  @override
  String get cleanerAppManagerShizukuNotAvailable => 'Shizuku غير متاح';

  @override
  String get cleanerAppManagerWithoutShizukuEachAppRequiresASeparate =>
      'بدون Shizuku، يتطلب كل تطبيق تأكيدًا منفصلًا من النظام. هل تريد المتابعة؟';

  @override
  String cleanerAppManagerAppsUninstalled(Object successCount) {
    return 'تم إلغاء تثبيت $successCount تطبيقات';
  }

  @override
  String cleanerAppManagerUninstalledFailed(
      Object successCount, Object failedCount) {
    return 'تم إلغاء تثبيت $successCount، وفشل $failedCount';
  }

  @override
  String cleanerAppManagerStopped(Object appName) {
    return 'تم إيقاف $appName';
  }

  @override
  String get cleanerAppManagerForceStopFailed => 'فشل الإيقاف الإجباري';

  @override
  String get cleanerAppManagerClearAppData => 'مسح بيانات التطبيق';

  @override
  String cleanerAppManagerResetThisClearsItsAccountsSettingsFiles(
      Object appName) {
    return 'هل تريد إعادة ضبط $appName؟ سيؤدي ذلك إلى مسح حساباته وإعداداته وملفاته وذاكرة التخزين المؤقت.';
  }

  @override
  String get cleanerAppManagerClearData => 'مسح البيانات';

  @override
  String cleanerAppManagerReset(Object appName) {
    return 'تمت إعادة ضبط $appName';
  }

  @override
  String get cleanerAppManagerClearDataFailed => 'فشل مسح البيانات';

  @override
  String get cleanerAppManagerOpenApp => 'فتح التطبيق';

  @override
  String get cleanerAppManagerForceStop => 'إيقاف إجباري';

  @override
  String get cleanerAppManagerUninstall => 'إلغاء التثبيت';

  @override
  String cleanerAppManagerSelected(Object selectedCount) {
    return 'تم تحديد $selectedCount';
  }

  @override
  String get cleanerAppManagerAppManager => 'مدير التطبيقات';

  @override
  String get cleanerAppManagerDeselectAll => 'إلغاء تحديد الكل';

  @override
  String cleanerAppManagerUninstalling(Object done, Object total) {
    return 'جارٍ إلغاء التثبيت $done / $total…';
  }

  @override
  String cleanerAppManagerUninstall2(Object selectedCount) {
    return 'إلغاء تثبيت $selectedCount';
  }

  @override
  String get cleanerProClearAppCaches => 'مسح ذاكرة التخزين المؤقت للتطبيقات';

  @override
  String get cleanerProThisAsksAndroidToTrimAppCaches =>
      'يطلب هذا من Android تقليص ذاكرات التخزين المؤقت للتطبيقات على الجهاز. لن يتم مسح بيانات التطبيقات أو الحسابات أو الإعدادات.';

  @override
  String get cleanerProClearCaches => 'مسح ذاكرات التخزين المؤقت';

  @override
  String get cleanerProCacheTrimRequested =>
      'تم طلب تقليص ذاكرة التخزين المؤقت';

  @override
  String get cleanerProCacheCleanerFailed => 'فشل تنظيف ذاكرة التخزين المؤقت';

  @override
  String get cleanerProLogFiles => 'ملفات السجل';

  @override
  String get cleanerProCacheCleaner => 'منظف ذاكرة التخزين المؤقت';

  @override
  String get cleanerProLogCleaner => 'منظف السجلات';

  @override
  String get cleanerProAppDataManager => 'مدير بيانات التطبيقات';

  @override
  String get cleanerScreenCleaner => 'المنظف';

  @override
  String get scanDetailDeleteFiles => 'حذف الملفات';

  @override
  String scanDetailDeleteFilesPermanently(Object selectedCount) {
    return 'هل تريد حذف $selectedCount ملفات نهائيًا؟';
  }

  @override
  String get scanDetailSelectedFilesDeleted => 'تم حذف الملفات المحددة';

  @override
  String get scanDetailDeleteAllFiles => 'حذف جميع الملفات';

  @override
  String scanDetailDeleteAllFilesPermanently(Object fileCount) {
    return 'هل تريد حذف جميع الملفات البالغ عددها $fileCount نهائيًا؟';
  }

  @override
  String get scanDetailDeleteAll => 'حذف الكل';

  @override
  String get scanDetailAllFilesDeleted => 'تم حذف جميع الملفات';

  @override
  String scanDetailSelected(Object selectedCount) {
    return 'تم تحديد $selectedCount';
  }

  @override
  String get scanDetailDeselectAll => 'إلغاء تحديد الكل';

  @override
  String get scanDetailNewestFirst => 'الأحدث أولًا';

  @override
  String get scanDetailOldestFirst => 'الأقدم أولًا';

  @override
  String get scanDetailLargestFirst => 'الأكبر أولًا';

  @override
  String get scanDetailSmallestFirst => 'الأصغر أولًا';

  @override
  String get scanDetailNoFilesFound => 'لم يتم العثور على ملفات';

  @override
  String get scanDetailDeleteAll2 => 'حذف الكل';

  @override
  String get scanInstalledAppsSearchApps => 'البحث في التطبيقات...';

  @override
  String get scanInstalledAppsNoAppsFound => 'لم يتم العثور على تطبيقات.';

  @override
  String get scanUiScanComplete => 'اكتمل الفحص';

  @override
  String scanUiScannedItems(Object scanned) {
    return 'تم فحص: $scanned عناصر';
  }

  @override
  String scanUiProgress(Object pct, Object scanned, Object total) {
    return 'التقدم: $pct ($scanned / $total)';
  }

  @override
  String get scanUiPreparingEngine => 'جارٍ تجهيز المحرك...';

  @override
  String get scanUiLoadingTargetS => 'جارٍ تحميل الهدف/الأهداف';

  @override
  String get scanUiAvarionxVPN => 'AvarionX VPN';

  @override
  String get scanUiProtectYourInternetWithOurUnlimitedVPN =>
      'احمِ اتصالك بالإنترنت باستخدام VPN غير المحدود لدينا';

  @override
  String get scanUiTapMe => 'اضغط هنا!';

  @override
  String scanUiScanned(Object scanned) {
    return 'تم فحص $scanned';
  }

  @override
  String get scanUiReturn => 'رجوع';

  @override
  String get scanLimitsSettingsUpdated => 'تم تحديث الإعدادات';

  @override
  String get scanLimitsScanLimits => 'حدود الفحص';

  @override
  String get scanLimitsLimitHowMuchTheEngineUsesYour =>
      'حدد مقدار استخدام المحرك لوحدة المعالجة المركزية. عدد الخيوط: 0 يعني تلقائي.';

  @override
  String get scanLimitsMaxScanThreads => 'الحد الأقصى لخيوط الفحص';

  @override
  String scanLimits0AutoRange0ToCores(Object maxThreads, Object coreCount) {
    return '0 = تلقائي. النطاق: من 0 إلى $maxThreads (الأنوية: $coreCount).';
  }

  @override
  String scanLegacyScanning(Object percent) {
    return 'جارٍ الفحص... $percent%';
  }

  @override
  String scanLegacySuspicious(Object infectedCount) {
    return 'مشبوه: $infectedCount';
  }

  @override
  String scanLegacyClean(Object cleanCount) {
    return 'سليم: $cleanCount';
  }

  @override
  String get scanLegacyNoFilesToScan => 'لا توجد ملفات للفحص';

  @override
  String get settingsSponsorsUnlock => 'يفتحها الداعمون ❤️';

  @override
  String get settingsPickCertificate => 'اختر الشهادة';

  @override
  String get settingsCertificateLoaded => 'تم تحميل الشهادة';

  @override
  String get settingsEnterCode => 'أدخل الرمز';

  @override
  String get settingsSupportFileMissing => 'ملف الدعم مفقود';

  @override
  String get settingsInvalidSupportCode => 'رمز الدعم غير صالح';

  @override
  String get settingsAvarionxSecurity => 'أمان AvarionX';

  @override
  String get settingsAvarionxIsAMobileSecuritySuiteCreated =>
      'AvarionX هو حزمة أمان للهواتف أنشأتها ColourSwift، ومقرها في برمنغهام بالمملكة المتحدة.\n\n';

  @override
  String get settingsContact => 'التواصل: ';

  @override
  String get settingsExperimentalFeatures => 'الميزات التجريبية';

  @override
  String get settingsEnablingShizukuUnlocksExperimentalWorkInProgress =>
      'يؤدي تفعيل Shizuku إلى فتح ميزات تجريبية لا تزال قيد التطوير:\n\n';

  @override
  String get settingsAdvancedRansomwareProtection =>
      '• حماية متقدمة من برامج الفدية\n';

  @override
  String get settingsCacheCleanerPlus => '• Cache Cleaner Plus\n\n';

  @override
  String get settingsExperimentalWarning => 'تحذير بشأن الميزات التجريبية:\n';

  @override
  String get settingsTheseFeaturesUseAdvancedSystemAccessAnd =>
      'تستخدم هذه الميزات وصولًا متقدمًا إلى النظام وقد تتصرف بشكل مختلف باختلاف الأجهزة وإصدارات Android وإعدادات Shizuku. قد تؤثر بعض الإجراءات في التطبيقات قيد التشغيل أو الملفات أو بيانات ذاكرة التخزين المؤقت بصورة مباشرة أكثر من الفحص العادي.\n\n';

  @override
  String get settingsOnlyEnableThisIfYouUnderstandShizuku =>
      'فعّل هذا فقط إذا كنت تفهم Shizuku، وتقبل أن الميزة لا تزال قيد الاختبار، وقد أنشأت نسخة احتياطية من أي بيانات مهمة.\n\n';

  @override
  String get settingsPleaseReadTheDocumentationBeforeEnabling =>
      'يرجى قراءة الوثائق قبل التفعيل.';

  @override
  String get settingsEnable => 'تفعيل';

  @override
  String get settingsSigningOut => 'جارٍ تسجيل الخروج...';

  @override
  String get settingsCheckingAccountStatus => 'جارٍ التحقق من حالة الحساب...';

  @override
  String get settingsManageSignInPremiumAndPurchases =>
      'إدارة تسجيل الدخول وPremium والمشتريات';

  @override
  String get settingsPremiumActive => 'Premium نشط';

  @override
  String get settingsManagePremiumOptionsAndRestorePurchases =>
      'إدارة خيارات Premium واستعادة المشتريات';

  @override
  String get settingsUnlockDeepAnalysisModeAndVPNFeatures =>
      'افتح وضع التحليل العميق وميزات VPN';

  @override
  String get settingsAutoClearNotifications => 'مسح الإشعارات تلقائيًا';

  @override
  String get settingsScanModes => 'أوضاع الفحص';

  @override
  String get settingsAdvancedScanModes => 'أوضاع الفحص المتقدمة';

  @override
  String get settingsDisableToUseTheDefaultScanningMode =>
      'عطّل لاستخدام وضع الفحص الافتراضي';

  @override
  String get settingsToggleToEnableAllScanningModes =>
      'بدّل لتفعيل جميع أوضاع الفحص';

  @override
  String get settingsApkSubmissions => 'إرسال ملفات APK';

  @override
  String get settingsShareMaliciousAPKs => 'مشاركة ملفات APK الضارة';

  @override
  String get settingsHelpingImproveDetectionForEveryone =>
      'المساعدة في تحسين الاكتشاف للجميع';

  @override
  String get settingsOff => 'إيقاف';

  @override
  String get settingsIncludeRealtimeProtectionCatches =>
      'تضمين اكتشافات الحماية في الوقت الفعلي';

  @override
  String get settingsApksFlaggedByRealtimeProtectionAreIncluded =>
      'يتم تضمين ملفات APK التي تكتشفها الحماية في الوقت الفعلي';

  @override
  String get settingsApksFlaggedByRealtimeProtectionAreExcluded =>
      'يتم استبعاد ملفات APK التي تكتشفها الحماية في الوقت الفعلي';

  @override
  String get settingsIncludeManualAndScheduledScans =>
      'تضمين عمليات الفحص اليدوية والمجدولة';

  @override
  String get settingsApksFlaggedByScansAreIncluded =>
      'يتم تضمين ملفات APK التي تكتشفها عمليات الفحص';

  @override
  String get settingsApksFlaggedByScansAreExcluded =>
      'يتم استبعاد ملفات APK التي تكتشفها عمليات الفحص';

  @override
  String get settingsWiFiOnly => 'Wi-Fi فقط';

  @override
  String get settingsUploadsWaitForAWiFiConnection =>
      'تنتظر عمليات الرفع اتصال Wi-Fi';

  @override
  String get settingsUploadsMayUseMobileData =>
      'قد تستخدم عمليات الرفع بيانات الهاتف المحمول';

  @override
  String get settingsChargingOnly => 'أثناء الشحن فقط';

  @override
  String get settingsUploadsWaitUntilTheDeviceIsCharging =>
      'تنتظر عمليات الرفع حتى يبدأ شحن الجهاز';

  @override
  String get settingsUploadsAreNotLimitedToCharging =>
      'عمليات الرفع غير مقيدة بحالة الشحن';

  @override
  String get settingsChooseWhichAppsUpload => 'اختر التطبيقات التي سيتم رفعها';

  @override
  String get settingsReviewAndPickAppsEachTimeBefore =>
      'راجع التطبيقات واخترها في كل مرة قبل الرفع';

  @override
  String get settingsFlaggedAppsUploadAutomatically =>
      'يتم رفع التطبيقات المعلّمة تلقائيًا';

  @override
  String get settingsEnableProDebug => 'تفعيل Pro (تصحيح الأخطاء)';

  @override
  String get settingsLocalUnlockForUITesting =>
      'فتح محلي لاختبار واجهة المستخدم';

  @override
  String get settingsRestorePurchases => 'استعادة المشتريات';

  @override
  String get settingsReCheckPlayBilling => 'إعادة التحقق من فوترة Play';

  @override
  String get settingsCheckingAccount => 'جارٍ التحقق من الحساب...';

  @override
  String get settingsAvarionxAccountConnected => 'حساب AvarionX متصل';

  @override
  String settingsAccountID(Object accountId) {
    return 'معرّف الحساب: $accountId';
  }

  @override
  String get settingsSignInToManagePurchasesAndAccount =>
      'سجّل الدخول لإدارة المشتريات وميزات الحساب.';

  @override
  String get settingsOpenTheAvarionXAccountPortal => 'فتح بوابة حساب AvarionX';

  @override
  String get settingsAccountDashboard => 'لوحة تحكم الحساب';

  @override
  String get settingsOpenBillingAndAccountSettings =>
      'فتح إعدادات الفوترة والحساب';

  @override
  String get settingsRemoveThisAccountFromTheApp =>
      'إزالة هذا الحساب من التطبيق';

  @override
  String get settingsPremiumFeaturesAreAvailableOnThisDevice =>
      'ميزات Premium متاحة على هذا الجهاز';

  @override
  String get settingsViewOptionalPremiumFeatures =>
      'عرض ميزات Premium الاختيارية';

  @override
  String get settingsReCheckPlayBillingEntitlement =>
      'إعادة التحقق من استحقاق Play Billing';

  @override
  String get settingsRtpNotificationAutoClearNotifications =>
      'مسح الإشعارات تلقائيًا';

  @override
  String get settingsRtpNotificationNever => 'أبدًا';

  @override
  String get settingsRtpNotification5Minutes => '5 دقائق';

  @override
  String get settingsRtpNotification10Minutes => '10 دقائق';

  @override
  String get settingsRtpNotification30Minutes => '30 دقيقة';

  @override
  String get settingsThemeBlack => 'أسود';

  @override
  String get settingsThemeWhite => 'أبيض';

  @override
  String get settingsThemeGrey => 'رمادي';

  @override
  String get settingsThemeEmerald => 'زمردي';

  @override
  String get settingsThemePurple => 'أرجواني';

  @override
  String get settingsThemeRoyalBlue => 'أزرق ملكي';

  @override
  String get settingsAccountCardSyncPurchasesAndUnlockProAcrossApps =>
      'زامن المشتريات وافتح Pro عبر التطبيقات.';

  @override
  String get settingsAccountCardLoading => 'جارٍ التحميل...';

  @override
  String get settingsAccountCardDashboard => 'لوحة التحكم';

  @override
  String get settingsProCardChangePlan => 'تغيير الخطة';

  @override
  String get advancedNetworkProtectionEnterYourOwnResolver =>
      'أدخل محلل DNS الخاص بك';

  @override
  String get advancedNetworkProtectionCloudProtectionMode =>
      'وضع الحماية السحابية';

  @override
  String get advancedNetworkProtectionRoutesAllDNSQueriesToTheCloud =>
      'يوجّه جميع استعلامات DNS إلى المحرك السحابي، مما يتيح تحديثات قوائم الحظر المباشرة والتحقق من سمعة النطاقات والمزيد.';

  @override
  String get advancedNetworkProtectionRefreshProStatus => 'تحديث حالة Pro';

  @override
  String get advancedNetworkProtectionProActive => 'Pro نشط';

  @override
  String get advancedNetworkProtectionFreePlan => 'الخطة المجانية';

  @override
  String get advancedNetworkProtectionChecksYourEntitlementAndSyncsItWith =>
      'يتحقق من استحقاقك ويزامنه مع ميزات السحابة. يفتح Pro حظر الإعلانات على مستوى النظام.';

  @override
  String get advancedNetworkProtectionMalwareProtection =>
      'الحماية من البرمجيات الضارة';

  @override
  String get advancedNetworkProtectionBlocksKnownMaliciousDomains =>
      'يحظر النطاقات الضارة المعروفة';

  @override
  String get advancedNetworkProtectionTrackerProtection =>
      'الحماية من أدوات التتبع';

  @override
  String get advancedNetworkProtectionReducesTrackingDomains =>
      'يقلل نطاقات التتبع';

  @override
  String get advancedNetworkProtectionAdProtection => 'الحماية من الإعلانات';

  @override
  String get advancedNetworkProtectionBlocksCommonAdDomains =>
      'يحظر نطاقات الإعلانات الشائعة';

  @override
  String get advancedNetworkProtectionAdultFilter => 'فلتر محتوى البالغين';

  @override
  String get advancedNetworkProtectionUses1113Upstream =>
      'يستخدم 1.1.1.3 كخادم upstream';

  @override
  String get advancedNetworkProtectionLockedUntilProIsActiveAndCloud =>
      'مقفل حتى يصبح Pro نشطًا ويتم تفعيل الوضع السحابي.';

  @override
  String get advancedNetworkProtectionLiveDNSEventsFromTheVPNLayer =>
      'أحداث DNS مباشرة من طبقة VPN.';

  @override
  String get advancedNetworkProtectionAdvanced => 'متقدم';

  @override
  String get advancedNetworkProtectionDns => 'DNS';

  @override
  String get advancedNetworkProtectionCloudDNSMode => 'وضع DNS السحابي';

  @override
  String get networkProtectionEnterYourOwnResolver => 'أدخل محلل DNS الخاص بك';

  @override
  String get networkAppControlEnableVPNToggles => 'تفعيل مفاتيح VPN';

  @override
  String get networkAppControlOpenSettings => 'فتح الإعدادات';

  @override
  String get networkAppControlAppControl => 'التحكم بالتطبيقات';

  @override
  String get networkAppControlNoAppsFound => 'لم يتم العثور على تطبيقات.';

  @override
  String get networkSpeedTestCountry => 'الدولة';

  @override
  String get networkSpeedTestRunning => 'قيد التشغيل';

  @override
  String get networkSpeedTestRunTest => 'تشغيل الاختبار';

  @override
  String get networkSpeedTestNoResultsYet => 'لا توجد نتائج بعد.';

  @override
  String networkSpeedTestDnsTLS(Object dns, Object tls) {
    return 'DNS: $dns  •  TLS: $tls';
  }

  @override
  String get networkSpeedTestFail => 'فشل';

  @override
  String get dnsNetworkProtectionEnterYourOwnResolver =>
      'أدخل محلل DNS الخاص بك';

  @override
  String get dnsNetworkProtectionDnsFilteringIsSeperateFromTheSecure =>
      'تصفية DNS منفصلة عن Secure VPN. يمكنها حظر البرمجيات الضارة المعروفة والإعلانات (عبر جميع التطبيقات) وأدوات التتبع والمحتوى من الفئات غير المرغوب فيها قبل تحميله.';

  @override
  String get fullVpnSignedIn => 'تم تسجيل الدخول.';

  @override
  String get fullVpnSignInRequired => 'تسجيل الدخول مطلوب';

  @override
  String get fullVpnClose => 'إغلاق';

  @override
  String get fullVpnLoadingUsage => 'جارٍ تحميل الاستخدام...';

  @override
  String get fullVpnSyncing => 'جارٍ المزامنة';

  @override
  String fullVpnUsedThisMonth(Object usedBytes) {
    return 'تم استخدام $usedBytes هذا الشهر';
  }

  @override
  String get blockedScreenUnsupportedEnvironment => 'بيئة غير مدعومة';

  @override
  String updateLogUpdateV(Object version) {
    return 'التحديث: v$version';
  }

  @override
  String get updateLogHiThereAvarionXHasBeenUpdatedBelow =>
      'مرحبًا! تم تحديث AvarionX، وفيما يلي التغييرات:';

  @override
  String get updateLogNoUserFacingChangesInThisUpdate =>
      'لا توجد تغييرات مرئية للمستخدم في هذا التحديث.';

  @override
  String get updateLogContinue => 'متابعة';

  @override
  String get featuresRealtimeProtectionBody =>
      'يراقب الملفات الجديدة والمعدلة في الخلفية ويحظر التهديدات فور ظهورها.';

  @override
  String get featuresTriLayerEngineTitle => 'محرك ثلاثي الطبقات';

  @override
  String get featuresTriLayerEngineBody =>
      'نواة كشف من ثلاث مراحل تجمع بين ترشيح Bloom وفحص التوقيعات وتحليل البايتات المخصص لملفات APK لتحقيق دقة وسرعة عاليتين.';

  @override
  String get featuresMachineLearningTitle => 'التعلم الآلي';

  @override
  String get featuresMachineLearningBody =>
      'نموذج خفيف يعمل على الجهاز ومدرّب للتعرف على أنماط سلوك ملفات APK الضارة.';

  @override
  String get featuresCleanerProTitle => 'Cleaner Pro';

  @override
  String get featuresCleanerProBody =>
      'وحدة تنظيف متطورة تحدد الملفات المكررة وذاكرة التخزين المؤقت والتطبيقات غير المستخدمة لاستعادة مساحة التخزين.';

  @override
  String get featuresWifiProtectionTitle => 'حماية Wi-Fi';

  @override
  String get featuresWifiProtectionBody =>
      'يكتشف شبكات Wi-Fi غير الآمنة أو المشبوهة باستخدام تحليل على الجهاز.';

  @override
  String get featuresRootLevelProtectionTitle => 'حماية على مستوى Root';

  @override
  String get featuresRootLevelProtectionBody =>
      'دفاع عميق على مستوى النظام مصمم للأجهزة ذات صلاحيات root والمستخدمين المتقدمين.';

  @override
  String get featuresPcCompanionTitle => 'رفيق الكمبيوتر';

  @override
  String get featuresPcCompanionBody =>
      'إصدار سطح مكتب قادم لتكامل مكافحة الفيروسات عبر المنصات.';

  @override
  String get deviceSecurityNoRisksFound => 'لم يتم العثور على مخاطر بالجهاز';

  @override
  String get deviceSecurityOneCheckNeedsAttention =>
      'فحص واحد للجهاز يحتاج إلى الانتباه';

  @override
  String deviceSecurityChecksNeedAttention(Object count) {
    return '$count من فحوصات الجهاز تحتاج إلى الانتباه';
  }

  @override
  String get deviceSecurityHealthSectionBody =>
      'تؤثر هذه الإعدادات مباشرة في وضع أمان جهازك.';

  @override
  String get deviceSecurityRecommendationsSectionBody =>
      'تُعد هذه الإعدادات من ممارسات الأمان الجيدة الشائعة.';

  @override
  String get deviceSecuritySignalUnavailable => 'المؤشر غير متاح';

  @override
  String get deviceSecurityIgnoredByYou => 'تم تجاهله بواسطتك';

  @override
  String get deviceSecurityScreenLockInactiveTitle => 'قفل الشاشة';

  @override
  String get deviceSecurityScreenLockActiveLabel =>
      'غير آمن، لم يتم تعيين قفل شاشة آمن';

  @override
  String get deviceSecurityScreenLockInactiveLabel => 'قفل الشاشة نشط';

  @override
  String get deviceSecurityScreenLockDetail =>
      'يحمي قفل الشاشة الآمن جهازك إذا فُقد أو سُرق أو تُرك دون مراقبة. بدون رقم PIN أو كلمة مرور أو نمط أو بصمة إصبع أو فتح بالوجه مدعوم بطريقة قفل آمنة، يمكن لأي شخص لديه وصول فعلي إلى الجهاز فتحه بسهولة أكبر.';

  @override
  String get deviceSecurityScreenLockHelp =>
      'افتح إعدادات أمان Android واضبط قفل شاشة آمن.';

  @override
  String get deviceSecurityCheckSetting => 'فحص الإعداد';

  @override
  String get deviceSecurityPrivilegedInactiveTitle => 'لا يوجد وصول مميز';

  @override
  String get deviceSecurityPrivilegedActiveLabel => 'تم اكتشاف وصول مميز';

  @override
  String get deviceSecurityPrivilegedInactiveLabel => 'لم يتم اكتشاف وصول مميز';

  @override
  String get deviceSecurityPrivilegedDetail =>
      'يمكن أن يكون Root وShizuku مفيدين لك، لكنهما يزيدان أيضًا من أثر أي تطبيق ضار إذا أُسيء استخدام الوصول. قد تتمكن التطبيقات ذات الوصول المميز من تنفيذ إجراءات لا تستطيع تطبيقات Android العادية تنفيذها.';

  @override
  String get deviceSecurityPrivilegedHelp =>
      'راجع إعدادات root أو Magisk أو Shizuku يدويًا.';

  @override
  String get deviceSecurityReviewSetting => 'مراجعة الإعداد';

  @override
  String get deviceSecurityAppVerificationInactiveTitle =>
      'التحقق من التطبيقات';

  @override
  String get deviceSecurityAppVerificationActiveLabel =>
      'غير آمن، يبدو أن التحقق من التطبيقات معطّل';

  @override
  String get deviceSecurityAppVerificationInactiveLabel =>
      'يبدو أن التحقق من التطبيقات مفعّل';

  @override
  String get deviceSecurityAppVerificationDetail =>
      'يساعد التحقق من تطبيقات Android في فحص التطبيقات قبل التثبيت أو بعده. إذا كانت هذه الحماية معطلة أو غير متاحة، فقد تقل احتمالية حظر التطبيقات الضارة قبل تشغيلها.';

  @override
  String get deviceSecurityAppVerificationHelp =>
      'افتح إعدادات أمان Android وراجع التحقق من التطبيقات.';

  @override
  String get deviceSecuritySecurityPatchInactiveTitle => 'تصحيح الأمان محدّث';

  @override
  String get deviceSecuritySecurityPatchActiveLabel =>
      'مستوى تصحيح الأمان قديم';

  @override
  String get deviceSecuritySecurityPatchInactiveLabel =>
      'مستوى تصحيح الأمان محدّث';

  @override
  String get deviceSecuritySecurityPatchDetail =>
      'تُصلح تصحيحات أمان Android مشكلات معروفة في النظام وموردي الأجهزة. إذا كان مستوى التصحيح قديمًا، فقد يكون الجهاز عرضة لثغرات تم إصلاحها بالفعل في الإصدارات الأحدث.';

  @override
  String get deviceSecuritySecurityPatchHelp =>
      'افتح إعدادات تحديث نظام Android وتحقق من وجود تحديثات.';

  @override
  String get deviceSecurityCheckUpdates => 'التحقق من التحديثات';

  @override
  String get deviceSecurityDeveloperModeInactiveTitle => 'وضع المطور';

  @override
  String get deviceSecurityDeveloperModeActiveLabel => 'خيارات المطور مفعّلة';

  @override
  String get deviceSecurityDeveloperModeInactiveLabel => 'خيارات المطور معطّلة';

  @override
  String get deviceSecurityDeveloperModeDetail =>
      'وضع المطور أمر طبيعي للمطورين والمختبرين، لكنه يتيح إعدادات متقدمة يمكن أن تقلل أمان الجهاز إذا تم تغييرها عن طريق الخطأ أو أُسيء استخدامها من شخص لديه وصول إلى الجهاز.';

  @override
  String get deviceSecurityDeveloperModeHelp =>
      'افتح خيارات المطور وأوقف الإعدادات التي لا تحتاج إليها.';

  @override
  String get deviceSecurityUsbDebuggingInactiveTitle => 'تصحيح أخطاء USB';

  @override
  String get deviceSecurityUsbDebuggingActiveLabel =>
      'غير آمن، تصحيح أخطاء USB مفعّل';

  @override
  String get deviceSecurityUsbDebuggingInactiveLabel => 'تصحيح أخطاء USB معطّل';

  @override
  String get deviceSecurityUsbDebuggingDetail =>
      'يسمح تصحيح أخطاء USB لجهاز كمبيوتر متصل بالتفاعل مع جهازك عبر Android Debug Bridge. إذا تُرك مفعّلًا، فإنه يزيد خطر الوصول غير المصرح به عند الاتصال بجهاز كمبيوتر غير موثوق.';

  @override
  String get deviceSecurityUsbDebuggingHelp =>
      'افتح خيارات المطور وأوقف تصحيح أخطاء USB.';

  @override
  String get deviceSecurityUnknownSourcesInactiveTitle => 'مصادر غير معروفة';

  @override
  String get deviceSecurityUnknownSourcesActiveLabel =>
      'تثبيت التطبيقات غير المعروفة مسموح';

  @override
  String get deviceSecurityUnknownSourcesInactiveLabel =>
      'تثبيت التطبيقات غير المعروفة مقيّد';

  @override
  String get deviceSecurityUnknownSourcesDetail =>
      'قد يكون السماح بتثبيت تطبيقات من مصادر غير معروفة مفيدًا لملفات APK الموثوقة، لكنه يزيد أيضًا احتمال تثبيت تطبيقات من مصادر غير آمنة. اسمح بذلك فقط للتطبيقات والمتاجر التي تثق بها.';

  @override
  String get deviceSecurityUnknownSourcesHelp =>
      'افتح إعدادات Android وراجع صلاحية تثبيت التطبيقات غير المعروفة.';

  @override
  String get deviceSecurityAccessibilityInactiveTitle => 'خدمات إمكانية الوصول';

  @override
  String get deviceSecurityAccessibilityActiveLabel =>
      'خدمة إمكانية وصول تابعة لجهة خارجية مفعّلة';

  @override
  String get deviceSecurityAccessibilityInactiveLabel =>
      'لم يتم العثور على خدمات إمكانية وصول خطرة';

  @override
  String get deviceSecurityAccessibilityDetail =>
      'خدمات إمكانية الوصول قوية لأنها تستطيع مراقبة محتوى الشاشة وتنفيذ إجراءات نيابة عن المستخدم. وهذا مفيد للأدوات المشروعة، لكنه أيضًا شائع الاستخدام من قبل التطبيقات الضارة.';

  @override
  String get deviceSecurityAccessibilityHelp =>
      'افتح إعدادات إمكانية الوصول وراجع الخدمات المفعّلة.';

  @override
  String get deviceSecurityChecking => 'جارٍ فحص أمان الجهاز';

  @override
  String get deviceSecurityReadingSignals => 'جارٍ قراءة مؤشرات وضع الجهاز...';

  @override
  String get deviceSecurityOneCheckAttention => 'فحص واحد يحتاج إلى الانتباه';

  @override
  String deviceSecurityChecksAttention(Object count) {
    return '$count فحوصات تحتاج إلى الانتباه';
  }

  @override
  String get deviceSecurityTapSignal => 'اضغط على مؤشر أدناه لمعرفة المزيد.';

  @override
  String deviceSecurityIgnoredChecks(Object count, String plural) {
    String _temp0 = intl.Intl.selectLogic(
      plural,
      {
        's': '',
        'other': '',
      },
    );
    return 'عدد الفحوصات النشطة التي تجاهلتها: $count.$_temp0';
  }

  @override
  String get deviceSecurityPostureNormal =>
      'تبدو فحوصات وضع أمان جهازك طبيعية.';

  @override
  String get timeJustNow => 'الآن';

  @override
  String timeMinutesAgo(Object minutes) {
    return 'منذ $minutes د';
  }

  @override
  String timeHoursAgo(Object hours) {
    return 'منذ $hours س';
  }

  @override
  String timeDaysAgo(Object days) {
    return 'منذ $days ي';
  }

  @override
  String get securityNoReportDataYet => 'لا توجد بيانات تقرير بعد';

  @override
  String securityLastActivity(Object relative) {
    return 'آخر نشاط $relative';
  }

  @override
  String get securityReportSharePdfTitle => 'تقرير أمان Avarionx';

  @override
  String get securityReportCsvField => 'الحقل';

  @override
  String get securityReportCsvValue => 'القيمة';

  @override
  String get securityReportGeneratedAt => 'تم الإنشاء في';

  @override
  String get securityReportOverallStatus => 'الحالة العامة';

  @override
  String get securityReportLastManualScan => 'آخر فحص يدوي';

  @override
  String get securityReportLastRealtimeEvent => 'آخر حدث في الوقت الفعلي';

  @override
  String get securityReportLastScheduledScan => 'آخر فحص مجدول';

  @override
  String get securityReportShareCsvTitle => 'تقرير أمان Avarionx بصيغة CSV';

  @override
  String get securityReportReviewRecommended => 'يوصى بالمراجعة';

  @override
  String get securityReportNoKnownThreatDetected => 'لم يتم اكتشاف تهديد معروف';

  @override
  String securityReportGeneratedLine(Object generatedAt) {
    return 'تم الإنشاء: $generatedAt';
  }

  @override
  String securityReportStatusLine(Object status) {
    return 'الحالة: $status';
  }

  @override
  String securityReportLatestActivityLine(Object latest) {
    return 'أحدث نشاط: $latest';
  }

  @override
  String securityReportManualScansLine(Object count) {
    return 'عمليات الفحص اليدوية: $count';
  }

  @override
  String securityReportRealtimeChecksLine(Object count) {
    return 'فحوصات الوقت الفعلي: $count';
  }

  @override
  String securityReportTotalFilesScannedLine(Object count) {
    return 'إجمالي الملفات التي تم فحصها: $count';
  }

  @override
  String securityReportThreatsFoundLine(Object count) {
    return 'التهديدات المكتشفة: $count';
  }

  @override
  String securityReportLastManualScanLine(Object value) {
    return 'آخر فحص يدوي: $value';
  }

  @override
  String securityReportLastRealtimeEventLine(Object value) {
    return 'آخر حدث في الوقت الفعلي: $value';
  }

  @override
  String securityReportLastScheduledScanLine(Object value) {
    return 'آخر فحص مجدول: $value';
  }

  @override
  String get securityReportNotRecorded => 'غير مسجل';

  @override
  String get safeViewNavigationBlocked => 'تم حظر التنقل';

  @override
  String get safeViewInvalidDestination => 'وجهة غير صالحة';

  @override
  String get safeViewUnsupportedScheme => 'مخطط غير مدعوم';

  @override
  String get safeViewUnableToResolveDestination => 'تعذر تحديد الوجهة';

  @override
  String get safeViewDestinationBlocked => 'تم حظر الوجهة';

  @override
  String get safeViewUnableToVerifyDestination => 'تعذر التحقق من الوجهة';

  @override
  String proScreenCurrentStatus(Object status) {
    return 'الحالة الحالية: $status';
  }

  @override
  String proScreenBilledAnnuallyAt(Object price) {
    return 'تتم الفوترة سنويًا بسعر $price';
  }

  @override
  String get quarantineUnknownApp => 'تطبيق غير معروف';

  @override
  String get cleanerScanCancelled => 'تم إلغاء الفحص';

  @override
  String get cleanerProClearingCaches => 'جارٍ مسح ذاكرات التخزين المؤقت…';

  @override
  String get cleanerProTrimAppCaches =>
      'تقليص ذاكرات التخزين المؤقت للتطبيقات على الجهاز.';

  @override
  String get cleanerProEnableShizuku =>
      'فعّل Shizuku في الإعدادات لاستخدام هذا.';

  @override
  String get cleanerProScanningStorage => 'جارٍ فحص مساحة التخزين…';

  @override
  String get cleanerProFindLogFiles =>
      'البحث عن ملفات .log و.trace و.crash و.dmp.';

  @override
  String cleanerProLogFileCount(Object count, Object size) {
    return '$count ملفات • $size';
  }

  @override
  String get cleanerProAppManagerReady =>
      'إيقاف التطبيقات إجباريًا ومسح بياناتها وإلغاء تثبيتها دفعة واحدة.';

  @override
  String get cleanerProAppManagerLimited =>
      'يعمل إلغاء التثبيت بشكل طبيعي. يتطلب الإيقاف الإجباري ومسح البيانات Shizuku.';

  @override
  String get cleanerProCheckingShizuku => 'جارٍ التحقق من Shizuku…';

  @override
  String get cleanerProShizukuNotRunning =>
      'Shizuku لا يعمل. فعّله من الإعدادات عند الحاجة.';

  @override
  String get cleanerProShizukuPermissionMissing =>
      'لم يتم منح إذن Shizuku. فعّله من الإعدادات.';

  @override
  String get cleanerProShizukuNotBound =>
      'خدمة Shizuku غير مرتبطة بعد. افتح الإعدادات وحدّث هذه الشاشة بعد تفعيلها.';

  @override
  String get cleanerLiteTab => 'Lite';

  @override
  String get cleanerProTab => 'Pro';

  @override
  String get scanCancelled => 'تم إلغاء الفحص';

  @override
  String get scanPreparing => 'جارٍ تحضير الفحص...';

  @override
  String scanSuspiciousItemsFound(Object count, String plural) {
    String _temp0 = intl.Intl.selectLogic(
      plural,
      {
        's': '',
        'other': '',
      },
    );
    return 'العناصر المشبوهة التي تم العثور عليها: $count.$_temp0';
  }

  @override
  String scanSuspiciousCount(Object count) {
    return '$count مشبوه';
  }

  @override
  String scanCleanCount(Object count) {
    return '$count سليم';
  }

  @override
  String scanNotificationFullItems(Object count) {
    return 'تم الفحص: $count عناصر';
  }

  @override
  String scanNotificationCurrent(Object count, Object file) {
    return 'تم الفحص: $count • $file';
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
  String get settingsThemeRoyalBluePremium => 'أزرق ملكي (Premium)';

  @override
  String get settingsIconDefault => 'افتراضي';

  @override
  String get settingsIconBird => 'طائر';

  @override
  String get settingsIconNeon => 'نيون';

  @override
  String get settingsIconOriginal => 'أصلي';

  @override
  String get homeRealtimeProtectionTitle => 'الحماية في الوقت الفعلي';

  @override
  String get networkCardStatusLocked => 'مقفل';

  @override
  String get networkSectionConnection => 'الاتصال';

  @override
  String get networkSectionBlocklists => 'قوائم الحظر';

  @override
  String get networkSectionResolver => 'المحلل';

  @override
  String get networkAppControlOtherVpnSetupInstructions =>
      'تم تحديد VPN آخر حاليًا ليعمل دائمًا.\n\nلحظر التطبيقات بشكل موثوق:\n\n1) افتح إعدادات VPN في Android\n2) اختر AvarionX كشبكة VPN\n3) فعّل VPN دائم التشغيل\n4) فعّل حظر الاتصالات بدون VPN';

  @override
  String get networkAppControlSetupInstructions =>
      'لحظر التطبيقات بشكل موثوق:\n\n1) افتح إعدادات VPN في Android\n2) اختر AvarionX كشبكة VPN\n3) فعّل VPN دائم التشغيل\n4) فعّل حظر الاتصالات بدون VPN';

  @override
  String get networkAppControlBlockingActive => 'حظر التطبيقات نشط.';

  @override
  String get networkAppControlOtherVpnWarning =>
      'تم تعيين VPN آخر ليعمل دائمًا. فعّل دائم التشغيل + الحظر بدون VPN لـ AvarionX.';

  @override
  String get networkAppControlSetupWarning =>
      'فعّل دائم التشغيل + الحظر بدون VPN لـ AvarionX لكي يعمل حظر التطبيقات.';

  @override
  String get countryUnitedKingdom => 'المملكة المتحدة';

  @override
  String get countryUnitedStates => 'الولايات المتحدة';

  @override
  String get countryCanada => 'كندا';

  @override
  String get countryIreland => 'أيرلندا';

  @override
  String get countryFrance => 'فرنسا';

  @override
  String get countryGermany => 'ألمانيا';

  @override
  String get countryNetherlands => 'هولندا';

  @override
  String get countrySpain => 'إسبانيا';

  @override
  String get countryItaly => 'إيطاليا';

  @override
  String get countrySweden => 'السويد';

  @override
  String get countryNorway => 'النرويج';

  @override
  String get countryDenmark => 'الدنمارك';

  @override
  String get countryPoland => 'بولندا';

  @override
  String get countryTurkey => 'تركيا';

  @override
  String get countryGreece => 'اليونان';

  @override
  String get countryRomania => 'رومانيا';

  @override
  String get countryUkraine => 'أوكرانيا';

  @override
  String get countryRussia => 'روسيا';

  @override
  String get countryIndia => 'الهند';

  @override
  String get countryPakistan => 'باكستان';

  @override
  String get countryBangladesh => 'بنغلاديش';

  @override
  String get countrySriLanka => 'سريلانكا';

  @override
  String get countryNepal => 'نيبال';

  @override
  String get countryJapan => 'اليابان';

  @override
  String get countrySouthKorea => 'كوريا الجنوبية';

  @override
  String get countrySingapore => 'سنغافورة';

  @override
  String get countryMalaysia => 'ماليزيا';

  @override
  String get countryThailand => 'تايلاند';

  @override
  String get countryVietnam => 'فيتنام';

  @override
  String get countryPhilippines => 'الفلبين';

  @override
  String get countryIndonesia => 'إندونيسيا';

  @override
  String get countryAustralia => 'أستراليا';

  @override
  String get countryNewZealand => 'نيوزيلندا';

  @override
  String get countryBrazil => 'البرازيل';

  @override
  String get countryArgentina => 'الأرجنتين';

  @override
  String get countryChile => 'تشيلي';

  @override
  String get countryMexico => 'المكسيك';

  @override
  String get countryColombia => 'كولومبيا';

  @override
  String get countryPeru => 'بيرو';

  @override
  String get countrySouthAfrica => 'جنوب أفريقيا';

  @override
  String get countryNigeria => 'نيجيريا';

  @override
  String get countryKenya => 'كينيا';

  @override
  String get countryEgypt => 'مصر';

  @override
  String get countryUAE => 'الإمارات العربية المتحدة';

  @override
  String get countrySaudiArabia => 'المملكة العربية السعودية';

  @override
  String get countryIsrael => 'إسرائيل';

  @override
  String networkSpeedTestTesting(Object current, Object total, Object domain) {
    return 'جارٍ الاختبار $current/$total • $domain';
  }

  @override
  String get networkSpeedTestDone => 'تم';

  @override
  String get vpnFooterCustomisation => 'التخصيص';

  @override
  String get apkClipboardReportTitle => 'VTTI Cloud - تقرير تحليل APK';

  @override
  String apkClipboardAppName(Object name) {
    return 'اسم التطبيق: $name';
  }

  @override
  String apkClipboardPackageId(Object packageId) {
    return 'معرّف الحزمة: $packageId';
  }

  @override
  String apkClipboardVersion(Object version) {
    return 'الإصدار: $version';
  }

  @override
  String apkClipboardFileSize(Object size) {
    return 'حجم الملف: $size';
  }

  @override
  String apkClipboardMinSdk(Object sdk) {
    return 'الحد الأدنى لـ SDK: $sdk';
  }

  @override
  String apkClipboardTargetSdk(Object sdk) {
    return 'SDK المستهدف: $sdk';
  }

  @override
  String apkClipboardSignature(Object signature) {
    return 'التوقيع: $signature';
  }

  @override
  String apkClipboardMalwareRisk(Object risk) {
    return 'مخاطر البرمجيات الضارة: $risk';
  }

  @override
  String apkClipboardRiskLabel(Object label) {
    return 'تصنيف المخاطر: $label';
  }

  @override
  String apkClipboardHashVerdict(Object verdict) {
    return 'حكم التجزئة: $verdict';
  }

  @override
  String apkClipboardRationale(Object rationale) {
    return 'التعليل: $rationale';
  }

  @override
  String get apkReportUnusualFlags => 'علامات غير معتادة';

  @override
  String get apkReportUnverifiedItems => 'عناصر غير متحقق منها';

  @override
  String get apkReportKnownMalware => 'برمجيات ضارة معروفة';

  @override
  String get apkReportSuspiciousHash => 'تجزئة مشبوهة';

  @override
  String get apkReportCleanHash => 'تجزئة سليمة';

  @override
  String get apkReportHashNotChecked => 'لم يتم فحص التجزئة';

  @override
  String get apkReportHashUnknown => 'تجزئة غير معروفة';

  @override
  String get apkMetadataPackage => 'الحزمة';

  @override
  String get apkMetadataPackageId => 'معرّف الحزمة';

  @override
  String get apkMetadataEngine => 'المحرك';

  @override
  String get apkMetadataSize => 'الحجم';

  @override
  String get apkMetadataMinSdk => 'الحد الأدنى لـ SDK';

  @override
  String get apkMetadataTargetSdk => 'SDK المستهدف';

  @override
  String get apkMetadataSignature => 'التوقيع';

  @override
  String get apkAnalyserStageDeconstructing => 'جارٍ تفكيك APK';

  @override
  String get apkAnalyserStageAnalysing => 'جارٍ تحليل المحتوى';

  @override
  String get apkAnalyserSignInRequired =>
      'يرجى تسجيل الدخول عبر الإعدادات لاستخدام Cloud Analysis.';

  @override
  String get apkAnalyserStageCheckingCloud => 'جارٍ التحقق من VTTI Cloud';

  @override
  String apkAnalyserDailyLimitReached(Object limit) {
    return 'لقد وصلت إلى حدك اليومي البالغ $limit من التحليلات.';
  }

  @override
  String get apkAnalyserCloudAnalysisFailed => 'فشل التحليل السحابي';

  @override
  String get apkAnalyserStageGeneratingReport => 'جارٍ إنشاء التقرير';

  @override
  String get apkAnalyserAnalysisFailed => 'فشل معالجة تحليل APK';

  @override
  String get genericError => 'خطأ';

  @override
  String get apkReportEngineVttiCloud => 'محرك VTTI Cloud';

  @override
  String get apkReportCertificateDetected => 'تم اكتشاف شهادة';

  @override
  String get apkReportNoCertificateData => 'لا توجد بيانات شهادة';

  @override
  String get apkExportOverview => 'نظرة عامة';

  @override
  String get apkExportMalwareAssessment => 'تقييم البرمجيات الضارة';

  @override
  String get apkExportRiskScore => 'درجة المخاطر';

  @override
  String get apkExportRiskLabel => 'تصنيف المخاطر';

  @override
  String get apkExportHashVerdict => 'حكم التجزئة';

  @override
  String get apkExportScoreRationale => 'تعليل الدرجة';

  @override
  String get apkExportContributingSignals => 'المؤشرات المساهمة';

  @override
  String get apkExportDampeningFactors => 'العوامل المخفِّضة';

  @override
  String get apkExportPermissionsRequested => 'الأذونات المطلوبة';

  @override
  String get apkExportExtraFlagsUnusual => 'علامات إضافية (غير معتادة)';

  @override
  String get apkExportExtraFlagsUnverified => 'علامات إضافية (غير متحقق منها)';

  @override
  String get apkExportDiscoveredSources => 'المصادر المكتشفة';

  @override
  String get apkExportRequestedPermissions => 'الأذونات المطلوبة';

  @override
  String get apkExportRationale => 'التعليل';

  @override
  String apkExportCsvShareText(Object name) {
    return 'ملف CSV لتحليل APK الخاص بـ $name';
  }

  @override
  String get apkExportPdfTitle => 'VTTI Cloud - تحليل APK';

  @override
  String apkExportPdfShareText(Object name) {
    return 'ملف PDF لتحليل APK الخاص بـ $name';
  }

  @override
  String get apkMetadataAppName => 'اسم التطبيق';

  @override
  String get apkMetadataFileSize => 'حجم الملف';

  @override
  String get vpnBackendFailedOpenBrowser => 'فشل فتح المتصفح.';

  @override
  String get vpnBackendSignedIn => 'تم تسجيل الدخول.';

  @override
  String get vpnBackendSignedOut => 'تم تسجيل الخروج.';

  @override
  String get vpnBackendSessionExpiredSignIn =>
      'انتهت صلاحية الجلسة. سجّل الدخول مرة أخرى.';

  @override
  String vpnBackendFailedLoadAccountStatus(Object status) {
    return 'فشل تحميل الحساب ($status).';
  }

  @override
  String vpnBackendFailedLoadAccountError(Object error) {
    return 'فشل تحميل الحساب ($error).';
  }

  @override
  String get vpnBackendSignInFirst => 'سجّل الدخول أولًا.';

  @override
  String get vpnBackendConnecting => 'جارٍ الاتصال...';

  @override
  String get vpnBackendNotificationsPermissionRequired =>
      'إذن الإشعارات مطلوب.';

  @override
  String get vpnBackendPermissionNotGranted => 'لم يتم منح إذن VPN.';

  @override
  String get vpnBackendAnotherVpnActive => 'هناك VPN آخر نشط. عطّله أولًا.';

  @override
  String get vpnBackendProvisionIncomplete =>
      'أعادت عملية التهيئة إعدادات غير مكتملة.';

  @override
  String get vpnBackendSecuringConnection => 'جارٍ تأمين الاتصال...';

  @override
  String get vpnBackendConnected => 'تم الاتصال.';

  @override
  String vpnBackendWireGuardFailed(Object error) {
    return 'فشل بدء WireGuard ($error).';
  }

  @override
  String get vpnBackendDisconnecting => 'جارٍ قطع الاتصال...';

  @override
  String get vpnBackendDisconnected => 'تم قطع الاتصال.';

  @override
  String vpnBackendSelectedServer(Object server) {
    return 'تم اختيار $server';
  }

  @override
  String vpnBackendSwitchingServer(Object server) {
    return 'جارٍ التبديل إلى $server...';
  }

  @override
  String get vpnBackendKeyNotFound => 'لم يتم العثور على مفتاح VPN.';

  @override
  String get vpnBackendDnsUpdated => 'تم تحديث إعدادات DNS.';

  @override
  String get vpnBackendSessionExpired => 'انتهت صلاحية الجلسة.';

  @override
  String vpnBackendFailedStatus(Object status) {
    return 'فشل ($status).';
  }

  @override
  String get vpnBackendPlanNotAllowed => 'خطتك لا تسمح باستخدام Full VPN.';

  @override
  String vpnBackendProvisionFailed(Object status) {
    return 'فشلت التهيئة ($status).';
  }
}
