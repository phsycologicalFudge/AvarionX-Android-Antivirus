// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get appName => 'AVarionX Security';

  @override
  String get ok => 'موافق';

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
  String get updateDbTitle => 'تحديث قاعدة البيانات';

  @override
  String updateDbVersionLabel(Object version) {
    return 'الإصدار $version';
  }

  @override
  String get updateDbAutoDownloadLabel => 'تنزيل التحديثات المستقبلية تلقائيًا';

  @override
  String get updateDbUpdatedAutoOn =>
      'تم تحديث قاعدة البيانات • التحديث التلقائي مفعل';

  @override
  String get updateDbUpdatedSuccess => 'تم تحديث قاعدة البيانات بنجاح';

  @override
  String get updateDbUpdateFailed => 'فشل تحديث قاعدة البيانات';

  @override
  String get engineReadyBanner => 'المحرك جاهز • VX-TITANIUM-v7';

  @override
  String get scanButton => 'فحص';

  @override
  String get scanModeFullTitle => 'فحص كامل للجهاز';

  @override
  String get scanModeFullSubtitle => 'فحص جميع ملفات التخزين القابلة للقراءة.';

  @override
  String get scanModeSmartTitle => 'فحص ذكي [موصى به]';

  @override
  String get scanModeSmartSubtitle =>
      'فحص الملفات التي قد تحتوي على برمجيات خبيثة.';

  @override
  String get scanModeRapidTitle => 'فحص سريع';

  @override
  String get scanModeRapidSubtitle =>
      'التحقق من ملفات APK الأخيرة في التنزيلات.';

  @override
  String get scanModeInstalledTitle => 'التطبيقات المثبتة';

  @override
  String get scanModeInstalledSubtitle =>
      'فحص تطبيقاتك المثبتة بحثًا عن تهديدات.';

  @override
  String get scanModeSingleTitle => 'فحص ملف / تطبيق';

  @override
  String get scanModeSingleSubtitle => 'اختر ملفًا أو تطبيقًا لفحصه.';

  @override
  String get useCloudAssistedScan => 'استخدام الفحص المدعوم سحابيًا';

  @override
  String get protectionTitle => 'الحماية';

  @override
  String get stateOffLine1 => 'حماية الجهاز متوقفة';

  @override
  String get stateOffLine2 => 'انقر للتشغيل';

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
  String get stateProtectedLine2 => 'انقر للإيقاف';

  @override
  String get dbUpdating => 'جاري تحديث قاعدة البيانات';

  @override
  String dbVersionAutoUpdated(Object version) {
    return 'قاعدة البيانات v$version • تحديث تلقائي';
  }

  @override
  String get rtpInfoTitle => 'الحماية في الوقت الحقيقي';

  @override
  String get rtpInfoBody =>
      'بالإضافة إلى حظر الملفات المشبوهة التي يتم تنزيلها عمدًا (أو بواسطة برمجيات خبيثة)، تستخدم الحماية في الوقت الحقيقي (RTP) شبكة VPN محلية لحظر النطاقات الضارة على مستوى النظام.\n\nعند التفعيل، يظل تصفية الشبكة نشطًا إلا في الحالات التالية:\n• التعطيل يدويًا عبر Terminal\n• الاستبدال بواسطة VPN آخر\n\nتستمر حماية الملفات بغض النظر عن ذلك طالما أن RTP مفعل.';

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
  String get scanTitleSingle => 'فحص فردي';

  @override
  String get cancellingScan => 'جاري إلغاء الفحص…';

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
  String get initializing => 'جاري التهيئة...';

  @override
  String get scanningEllipsis => 'جاري الفحص...';

  @override
  String get fullScanInfoTitle => 'فحص كامل للجهاز';

  @override
  String get fullScanInfoBody =>
      'يقوم هذا الوضع بفحص كل ملف قابل للقراءة في التخزين دون تصفية.\n\nلا يتم استخدام الفحص المدعوم سحابيًا وفحص التطبيقات في هذا الوضع.';

  @override
  String get scanComplete => 'اكتمل الفحص';

  @override
  String pillSuspiciousCount(Object count) {
    return 'مشبوه: $count';
  }

  @override
  String pillCleanCount(Object count) {
    return 'آمن: $count';
  }

  @override
  String pillScannedCount(Object count) {
    return 'مفحوص: $count';
  }

  @override
  String get resultNoThreatsTitle => 'لم يتم اكتشاف تهديدات';

  @override
  String get resultNoThreatsBody =>
      'لم يتم العثور على تهديدات في العناصر المفحوصة.';

  @override
  String get resultSuspiciousAppsTitle => 'تطبيقات مشبوهة';

  @override
  String get resultSuspiciousItemsTitle => 'عناصر مشبوهة';

  @override
  String get returnHome => 'العودة للرئيسية';

  @override
  String get emptyTitle => 'لا توجد ملفات قابلة للفحص';

  @override
  String get emptyBody => 'لا يحتوي جهازك على أي ملفات تطابق معايير الفحص.';

  @override
  String get knownMalware => 'برمجيات خبيثة معروفة';

  @override
  String get suspiciousActivityDetected => 'تم اكتشاف نشاط مشبوه';

  @override
  String get maliciousActivityDetected => 'تم اكتشاف نشاط ضار';

  @override
  String get androidBankingTrojan => 'طروادة مصرفية للأندرويد';

  @override
  String get androidSpyware => 'برمجيات تجسس للأندرويد';

  @override
  String get androidAdware => 'برمجيات إعلانية للأندرويد';

  @override
  String get androidSmsFraud => 'احتيال عبر الرسائل النصية';

  @override
  String get threatLevelConfirmed => 'مؤكد';

  @override
  String get threatLevelHigh => 'عالي';

  @override
  String get threatLevelMedium => 'متوسط';

  @override
  String threatLevelLabel(Object level) {
    return 'مستوى التهديد: $level';
  }

  @override
  String get explainFoundInCloud =>
      'هذا العنصر مدرج في قاعدة بيانات تهديدات ColourSwift السحابية.';

  @override
  String get explainFoundInOffline =>
      'هذا العنصر مدرج في قاعدة بيانات البرمجيات الخبيثة غير المتصلة بالإنترنت على جهازك.';

  @override
  String get explainBanker =>
      'مصمم لسرقة البيانات المالية، غالبًا باستخدام واجهات وهمية، أو تسجيل ضربات المفاتيح، أو اعتراض حركة المرور.';

  @override
  String get explainSpyware =>
      'يراقب النشاط بصمت أو يجمع البيانات الشخصية مثل الرسائل أو الموقع أو معرفات الجهاز.';

  @override
  String get explainAdware =>
      'يعرض إعلانات متطفلة، أو يقوم بعمليات إعادة توجيه، أو يولد حركة مرور إعلانية احتيالية.';

  @override
  String get explainSmsFraud =>
      'يحاول إرسال رسائل نصية أو تشغيل إجراءات SMS دون موافقة، مما قد يسبب رسومًا غير متوقعة.';

  @override
  String get explainGenericMalware =>
      'تم اكتشاف مؤشرات قوية على وجود نوايا ضارة، رغم أنه لا يتطابق مع عائلة برمجيات محددة الاسم.';

  @override
  String get explainSuspiciousDefault =>
      'تم اكتشاف مؤشرات على سلوك مشبوه. قد يشمل ذلك أنماط إساءة شوهدت في البرمجيات الخبيثة، ولكن قد يكون أيضًا إنذارًا خاطئًا.';

  @override
  String get singleChoiceScanFile => 'فحص ملف';

  @override
  String get singleChoiceScanInstalledApp => 'فحص تطبيق مثبت';

  @override
  String get singleChoiceManageExclusions => 'إدارة الاستثناءات';

  @override
  String get labelKnownMalwareDb => 'موجود في قاعدة بيانات البرمجيات الخبيثة';

  @override
  String get labelFoundInCloudDb => 'موجود في قاعدة البيانات السحابية';

  @override
  String get logEngineFullDeviceScan => '[المحرك] فحص كامل للجهاز';

  @override
  String get logEngineTargetStorage => '[المحرك] الهدف: /storage/emulated/0';

  @override
  String get logEngineNoFilesFound => '[المحرك] لم يتم العثور على ملفات.';

  @override
  String logEngineFilesEnumerated(Object count) {
    return '[المحرك] الملفات المكتشفة: $count';
  }

  @override
  String get logEngineNoReadableFilesFound =>
      '[المحرك] لم يتم العثور على ملفات قابلة للقراءة.';

  @override
  String logEngineInstalledAppsFound(Object count) {
    return '[المحرك] التطبيقات المثبتة المكتشفة: $count';
  }

  @override
  String get logModeCloudAssisted => '[الوضع] وضع المساعدة السحابية';

  @override
  String get logModeOffline => '[الوضع] وضع عدم الاتصال';

  @override
  String get logStageHashing => '[المرحلة 1] جلب بصمات الملفات (مخزنة)...';

  @override
  String get logStageCloudLookup => '[المرحلة 2] البحث عن البصمة في السحابة...';

  @override
  String logStageLocalScanning(Object stage) {
    return '[المرحلة $stage] فحص الملفات محليًا...';
  }

  @override
  String logCloudHashHits(Object count) {
    return '[السحابة] $count تطابق للبصمات';
  }

  @override
  String logSummary(Object suspicious, Object clean) {
    return '[الملخص] $suspicious مشبوه • $clean آمن';
  }

  @override
  String logErrorPrefix(Object message) {
    return '[خطأ] $message';
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
  String get featureTerminal => 'المحطة الطرفية';

  @override
  String get featureScheduledScans => 'الفحوصات المجدولة';

  @override
  String get recommendedMetaPassDesc =>
      'توليد كلمات مرور آمنة دون اتصال بالإنترنت.';

  @override
  String get recommendedCleanerProDesc =>
      'البحث عن التكرارات، والوسائط القديمة، والتطبيقات غير المستخدمة لاستعادة مساحة التخزين تلقائيًا.';

  @override
  String get recommendedLinkCheckerDesc =>
      'تحقق من الروابط المشبوهة باستخدام ميزة العرض الآمن، دون مخاطر.';

  @override
  String get recommendedNetworkProtectionDesc =>
      'حافظ على أمان اتصالك بالإنترنت من البرمجيات الخبيثة.';

  @override
  String get recommendedTerminalDesc => 'ميزة متقدمة لـ Shizuku';

  @override
  String get recommendedScheduledScansDesc => 'فحوصات تلقائية في الخلفية.';

  @override
  String get metaPassTitle => 'MetaPass';

  @override
  String get metaPassHowItWorks => 'كيف يعمل MetaPass';

  @override
  String get metaPassOk => 'موافق';

  @override
  String get metaPassSettings => 'الإعدادات';

  @override
  String get metaPassPoweredBy => 'مدعوم من VX-TITANIUM';

  @override
  String get metaPassLoading => 'جاري التحميل…';

  @override
  String get metaPassEmptyTitle => 'لا توجد إدخالات بعد';

  @override
  String get metaPassEmptyBody =>
      'أضف تطبيقًا أو موقعًا إلكترونيًا.\nيتم توليد كلمات المرور على الجهاز من كلمة مرور Meta السرية الخاصة بك.';

  @override
  String get metaPassAddFirstEntry => 'إضافة أول إدخال';

  @override
  String get metaPassTapToCopyHint => 'اضغط للنسخ. اضغط مطولاً للإزالة.';

  @override
  String get metaPassCopyTooltip => 'نسخ كلمة المرور';

  @override
  String get metaPassAdd => 'إضافة';

  @override
  String get metaPassPickFromInstalledApps => 'اختر من التطبيقات المثبتة';

  @override
  String get metaPassAddWebsiteOrLabel => 'إضافة موقع أو تسمية مخصصة';

  @override
  String get metaPassSelectApp => 'اختر تطبيقًا';

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
  String get metaPassNameOrUrl => 'الاسم أو الرابط';

  @override
  String get metaPassNameOrUrlHint => 'مثال: nextcloud, steam, example.com';

  @override
  String get metaPassVersion => 'الإصدار';

  @override
  String get metaPassLength => 'الطول';

  @override
  String get metaPassSetMetaTitle => 'تعيين كلمة مرور Meta';

  @override
  String get metaPassSetMetaBody =>
      'أدخل كلمة مرور meta الخاصة بك. لن تغادر هذا الجهاز أبدًا. تعتمد جميع كلمات مرور الخزنة عليها.';

  @override
  String get metaPassMetaLabel => 'كلمة مرور Meta';

  @override
  String get metaPassRememberThisDevice => 'تذكر هذا الجهاز (مخزنة بأمان)';

  @override
  String get metaPassChangingMetaWarning =>
      'تغيير هذا لاحقًا سيغير جميع كلمات المرور المولدة. استخدام نفس كلمة مرور meta يعيد استعادتها.';

  @override
  String get metaPassRemoveEntryTitle => 'إزالة الإدخال';

  @override
  String metaPassRemoveEntryBody(Object label) {
    return 'هل تريد إزالة \"$label\" من خزنتك؟';
  }

  @override
  String get metaPassRemove => 'إزالة';

  @override
  String metaPassPasswordCopied(Object label, Object version, Object length) {
    return 'تم نسخ كلمة المرور لـ $label (الإصدار $version، الطول $length)';
  }

  @override
  String metaPassGenerateFailed(Object error) {
    return 'فشل توليد كلمة المرور: $error';
  }

  @override
  String metaPassLoadAppsFailed(Object error) {
    return 'فشل تحميل التطبيقات: $error';
  }

  @override
  String metaPassChars(Object length) {
    return '$length حرف';
  }

  @override
  String metaPassVersionShort(Object version) {
    return 'إصدار $version';
  }

  @override
  String get metaPassInfoBody =>
      'لا يتم تخزين كلمات المرور أبدًا.\n\nيتم اشتقاق كل كلمة مرور من:\n• كلمة مرور Meta الخاصة بك\n• التسمية (الاسم)\n• الإصدار والطول\n\nإعادة تثبيت التطبيق بنفس كلمة مرور meta والتسميات يعيد توليد نفس كلمات المرور.';

  @override
  String get passwordSettingsTitle => 'إعدادات كلمة المرور';

  @override
  String get passwordSettingsSectionMetaPass => 'MetaPass';

  @override
  String get passwordSettingsMetaPasswordTitle => 'كلمة مرور Meta';

  @override
  String get passwordSettingsMetaNotSet => 'لم يتم التعيين';

  @override
  String get passwordSettingsMetaStoredSecurely => 'مخزنة بأمان على هذا الجهاز';

  @override
  String get passwordSettingsChange => 'تغيير';

  @override
  String get passwordSettingsSetMetaPassTitle => 'تعيين MetaPass';

  @override
  String get passwordSettingsMetaPasswordLabel => 'كلمة مرور Meta';

  @override
  String get passwordSettingsChangingAltersAll =>
      'تغيير هذا يؤدي لتغيير جميع كلمات المرور.\nاستخدام نفس MetaPass يعيد استعادتها.';

  @override
  String get passwordSettingsCancel => 'إلغاء';

  @override
  String get passwordSettingsSave => 'حفظ';

  @override
  String get passwordSettingsSectionRestoreCode => 'كود الاستعادة';

  @override
  String get passwordSettingsGenerateRestoreCode => 'توليد كود الاستعادة';

  @override
  String get passwordSettingsCopy => 'نسخ';

  @override
  String get passwordSettingsRestoreCodeCopied => 'تم نسخ كود الاستعادة';

  @override
  String get passwordSettingsSectionRestoreFromCode => 'استعادة من كود';

  @override
  String get passwordSettingsRestoreCodeLabel => 'كود الاستعادة';

  @override
  String get passwordSettingsRestore => 'استعادة';

  @override
  String get passwordSettingsVaultRestored => 'تمت استعادة الخزنة';

  @override
  String get passwordSettingsFooterInfo =>
      'لا يتم تخزين كلمات المرور أبدًا.\n\nيحتوي كود الاستعادة على بيانات الهيكل فقط. بالاقتران مع MetaPass، يعيد بناء خزنتك.';

  @override
  String get onboardingAppName => 'AVarionX Security';

  @override
  String get onboardingStorageTitle => 'الوصول للتخزين';

  @override
  String get onboardingStorageDesc =>
      'هذا الإذن مطلوب لفحص الملفات على جهازك. يمكنك منحه الآن أو لاحقًا.';

  @override
  String get onboardingStorageFootnote =>
      'يمكنك تخطي هذا، ولكن سيتم سؤالك مرة أخرى عند اختيار وضع الفحص.';

  @override
  String get onboardingStorageSnack => 'إذن التخزين مطلوب لعملية الفحص.';

  @override
  String get onboardingNotificationsTitle => 'الإشعارات';

  @override
  String get onboardingNotificationsDesc =>
      'تستخدم للتنبيهات الفورية، وحالة الفحص، وتحديثات الحجر الصحي.';

  @override
  String get onboardingNotificationsFootnote =>
      'مطلوب من قبل نظام أندرويد لعمل الحماية في الوقت الحقيقي.';

  @override
  String get onboardingNetworkTitle => 'حماية الشبكة';

  @override
  String get onboardingNetworkDesc =>
      'تمكن حماية الواي فاي باستخدام إذن VPN الخاص بأندرويد.';

  @override
  String get onboardingNetworkFootnote => 'هذا اختياري ولكن موصى به.';

  @override
  String get onboardingGranted => 'تم المنح';

  @override
  String get onboardingNotGranted => 'لم يتم المنح';

  @override
  String get onboardingGrantAccess => 'منح الوصول';

  @override
  String get onboardingAllowNotifications => 'السماح بالإشعارات';

  @override
  String get onboardingAllowVpnAccess => 'السماح بالوصول لـ VPN';

  @override
  String get onboardingBack => 'رجوع';

  @override
  String get onboardingNext => 'التالي';

  @override
  String get onboardingFinish => 'إنهاء';

  @override
  String get onboardingSetupCompleteTitle => 'اكتمل الإعداد';

  @override
  String get onboardingSetupCompleteDesc =>
      'نوصي بتشغيل فحص كامل للجهاز (هذا لا يفحص التطبيقات المثبتة حاليًا)، أو الانتقال مباشرة إلى الشاشة الرئيسية.';

  @override
  String get onboardingRunFullScan => 'تشغيل فحص كامل';

  @override
  String get onboardingGoHome => 'الانتقال للرئيسية';

  @override
  String get networkProtectionTitle => 'حماية الشبكة';

  @override
  String networkStatusConnected(Object dns) {
    return 'متصل بـ $dns';
  }

  @override
  String get networkStatusVpnConflict => 'هناك VPN آخر نشط';

  @override
  String get networkStatusOff => 'حماية الشبكة متوقفة';

  @override
  String get networkModeMalwareTitle => 'حظر البرمجيات الخبيثة فقط';

  @override
  String get networkModeMalwareSubtitle => 'يستخدم 1.1.1.2';

  @override
  String get networkModeMalwareDescription =>
      'يجمع بين قاعدة بيانات AvarionX المحلية ومعلومات التهديدات عبر الإنترنت من Cloudflare لأقصى حماية.';

  @override
  String get networkModeAdultTitle => 'البرمجيات الخبيثة والمحتوى للبالغين';

  @override
  String get networkModeAdultSubtitle => 'يستخدم 1.1.1.3';

  @override
  String get networkModeAdultDescription =>
      'يستخدم قاعدة بيانات AvarionX غير المتصلة بالإنترنت ويضيف تصفية محتوى البالغين. يتم تعطيل المعلومات السحابية في هذا الوضع.';

  @override
  String get networkInfoTitle => 'ما هي حماية الشبكة؟';

  @override
  String get networkInfoBody =>
      'تعمل بعض التهديدات من خلال الاتصال بخوادم ضارة أو إعادة توجيه حركة المرور.\nتحظر حماية الشبكة النطاقات الخطيرة المعروفة والإعلانات الشائعة باستخدام VPN محلي.\n\nAVarionX Security لا يجمع أي بيانات.';

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
      'تحقق من الصفحة بحثًا عن برمجيات خبيثة أو محتوى مشبوه';

  @override
  String get linkCheckerUrlLabel => 'الرابط (URL)';

  @override
  String get linkCheckerUrlHint => 'https://example.com';

  @override
  String get linkCheckerButtonAnalyse => 'تحليل';

  @override
  String get linkCheckerButtonChecking => 'جاري التحقق';

  @override
  String get linkCheckerEngineNotReadySnack => 'المحرك غير جاهز';

  @override
  String get linkCheckerStatusVerifyingLink => 'جاري التحقق من الرابط…';

  @override
  String get linkCheckerStatusScanningPage => 'جاري فحص الصفحة…';

  @override
  String get linkCheckerBlockedNavigation => 'تم حظر التنقل';

  @override
  String get linkCheckerBlockedUnsupportedType => 'نوع رابط غير مدعوم';

  @override
  String get linkCheckerBlockedInvalidDestination => 'وجهة غير صالحة';

  @override
  String get linkCheckerBlockedUnableResolve => 'تعذر الوصول للوجهة';

  @override
  String get linkCheckerBlockedUnableVerify => 'تعذر التحقق من الوجهة';

  @override
  String get linkCheckerAnalyseCardTitleDefault =>
      'افحص الصفحة بحثًا عن محتوى مشبوه';

  @override
  String get linkCheckerAnalyseCardDetailDefault =>
      'ألصق رابطًا وقم بتشغيل التحليل.';

  @override
  String get linkCheckerAnalyseCardTitleEngineNotReady => 'المحرك غير جاهز';

  @override
  String get linkCheckerAnalyseCardDetailEngineNotReady => 'خطأ 1001.';

  @override
  String get linkCheckerAnalyseCardTitleChecking => 'جاري التحقق';

  @override
  String get linkCheckerVerdictClean => 'آمن';

  @override
  String get linkCheckerVerdictCleanDetail => 'تبدو هذه الصفحة آمنة.';

  @override
  String get linkCheckerVerdictSuspicious => 'مشبوه';

  @override
  String get linkCheckerVerdictSuspiciousDetail =>
      'تحتوي هذه الصفحة على محتوى مشبوه.';

  @override
  String get linkCheckerViewLockedBody =>
      'قم بتشغيل التحليل أولاً لتمكين العرض.';

  @override
  String get linkCheckerViewSubtitle => 'عرض الموقع بأمان';

  @override
  String get linkCheckerViewPage => 'عرض الصفحة';

  @override
  String get linkCheckerClose => 'إغلاق';

  @override
  String get linkCheckerBlockedBody => 'تم إيقاف هذه الصفحة قبل تحميلها.';

  @override
  String get linkCheckerSuspiciousBanner =>
      'رابط مشبوه، قد لا يتم العرض إذا تطلب الأمر محتوى محظورًا.';

  @override
  String get linkCheckerHistorySubtitle => 'اضغط على إدخال لنسخ الرابط.';

  @override
  String get linkCheckerHistoryEmpty => 'لا توجد فحوصات بعد.';

  @override
  String get linkCheckerCopied => 'تم النسخ';

  @override
  String get settingsSectionAppearance => 'المظهر';

  @override
  String get settingsTheme => 'المظهر (Theme)';

  @override
  String settingsThemeCurrent(Object theme) {
    return 'الحالي: $theme';
  }

  @override
  String get settingsLanguage => 'اللغة';

  @override
  String settingsLanguageCurrent(Object language) {
    return 'الحالية: $language';
  }

  @override
  String get settingsChooseLanguage => 'اختر اللغة';

  @override
  String get settingsLanguageApplied => 'تم تطبيق اللغة';

  @override
  String get settingsSystemDefault => 'تلقائي حسب النظام';

  @override
  String get settingsSectionCommunity => 'انضم للمجتمع!';

  @override
  String get settingsDiscord => 'ديسكورد';

  @override
  String get settingsDiscordSubtitle => 'دردشة، تحديثات وآراء';

  @override
  String get settingsDiscordOpenFail => 'تعذر فتح رابط ديسكورد';

  @override
  String get settingsSectionPro => 'ميزات PRO';

  @override
  String get settingsProCustomization => 'تخصيص PRO';

  @override
  String get settingsProSubtitle => 'إزالة الإعلانات وفتح المظاهر والأيقونات';

  @override
  String get settingsUnlockPro => 'فتح ميزات PRO';

  @override
  String get settingsProUnlocked => 'تم فتح وضع PRO';

  @override
  String get settingsPurchaseNotConfirmed => 'لم يتم تأكيد الشراء';

  @override
  String settingsPurchaseFailed(Object error) {
    return 'فشل الشراء: $error';
  }

  @override
  String get settingsProReset => 'إعادة ضبط PRO (للمطورين فقط)';

  @override
  String get settingsProSheetTitle => 'تخصيص PRO';

  @override
  String get settingsHideGoldHeader => 'إخفاء الترويسة الذهبية في الرئيسية';

  @override
  String get settingsAppIcon => 'أيقونة التطبيق';

  @override
  String settingsIconSelected(Object icon) {
    return 'الأيقونة المختارة: $icon';
  }

  @override
  String get settingsSave => 'حفظ';

  @override
  String get settingsSectionShizuku => 'الحماية المتقدمة (Shizuku)';

  @override
  String get settingsEnableShizuku => 'تفعيل Shizuku';

  @override
  String get settingsShizukuRequiresManager => 'يتطلب مديراً خارجياً';

  @override
  String get settingsShizukuNotRunning => 'خدمة Shizuku لا تعمل';

  @override
  String get settingsShizukuPermissionRequired => 'الإذن مطلوب';

  @override
  String get settingsShizukuAvailable => 'الوصول المتقدم للنظام متاح';

  @override
  String get settingsAboutAdvancedProtection => 'حول الحماية المتقدمة';

  @override
  String get settingsAboutAdvancedProtectionSubtitle =>
      'تعرف على كيفية عمل الحماية المتقدمة';

  @override
  String get settingsAdvancedProtectionDialogTitle => 'حماية النظام المتقدمة';

  @override
  String get settingsAdvancedProtectionDialogBody =>
      'يتطلب الوصول عبر Shizuku مديراً خارجياً مخصصاً للمستخدمين المتقدمين.\n\nهذه الميزة اختيارية ولا يوصى بها للحماية العادية.';

  @override
  String get settingsAboutShizukuTitle => 'حول Shizuku';

  @override
  String get settingsAboutShizukuBody =>
      'يمكن لـ AVarionX التكامل مع Shizuku للوصول إلى عمليات التطبيق على مستوى النظام.\n\nيسمح هذا للتطبيق بـ:\n• اكتشاف البرمجيات الخبيثة التي تختبئ من الفاحصات العادية\n• فحص عمليات التطبيقات الجارية\n• تعطيل أو احتواء معظم البرمجيات الخبيثة النشطة\n\nومع ذلك، لا يمنح Shizuku صلاحيات الروت (root)\n\nهذه الميزة مخصصة للمستخدمين المتقدمين وليست مطلوبة للحماية العادية.\n\nالتوثيق:\nhttps://shizuku.rikka.app';

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
  String get settingsHowThisAppWorks => 'كيف يعمل التطبيق';

  @override
  String get settingsHowThisAppWorksSubtitle => 'تعرف على آليات الحماية';

  @override
  String get settingsThemePickerTitle => 'اختر المظهر';

  @override
  String get settingsThemeRequiresPro => 'هذا المظهر يتطلب وضع PRO';

  @override
  String get scheduledScansTitle => 'الفحوصات المجدولة';

  @override
  String get scheduledScansInfoTitle => 'الفحوصات المجدولة';

  @override
  String get scheduledScansInfoBody =>
      'بينما يركز RTP على البرمجيات الخبيثة المحملة، ستقوم الفحوصات المجدولة بتشغيل وضع الفحص المختار تلقائيًا في الخلفية.\nسيعمل فقط عندما يكون RTP مفعلاً.\n\nيمكن لمستخدمي PRO تخصيص وضع الفحص وتكراره.';

  @override
  String get scheduledScansHeader => 'فحوصات تلقائية في الخلفية';

  @override
  String get scheduledScansSubheader =>
      'بينما يكون RTP نشطًا، سيقوم التطبيق بفحص جهازك بناءً على وضع الفحص والتكرار المختار.';

  @override
  String get proRequiredToCustomize => 'ميزة PRO مطلوبة للتخصيص';

  @override
  String get scheduledScansEnabledTitle => 'مفعل';

  @override
  String get scheduledScansEnabledSubtitle =>
      'عند التفعيل، يتم تشغيل الفحص تلقائيًا حسب جدولك المختار.';

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
    return 'كل $days يوم';
  }

  @override
  String scheduledEveryHours(Object hours) {
    return 'كل $hours ساعة';
  }

  @override
  String get scheduledChargingOnlyTitle => 'أثناء الشحن فقط';

  @override
  String get scheduledChargingOnlySubtitle =>
      'تشغيل الفحص المجدول فقط عندما يكون الجهاز متصلاً بالشاحن.';

  @override
  String get scheduledPreferredTimeTitle => 'الوقت المفضل';

  @override
  String get scheduledPreferredTimeSubtitle =>
      'سيحاول AVarionX البدء في هذا الوقت تقريبًا. قد يؤخر نظام أندرويد ذلك لتوفير البطارية.';

  @override
  String get scheduledPickTime => 'اختر الوقت';

  @override
  String get cleanerTitle => 'Cleaner Pro';

  @override
  String get cleanerReadyToScan => 'جاهز للفحص';

  @override
  String get cleanerScan => 'فحص';

  @override
  String get cleanerScanning => 'جاري الفحص…';

  @override
  String get cleanerReady => 'جاهز';

  @override
  String get cleanerStatusReady => 'جاهز';

  @override
  String get cleanerStatusStarting => 'جاري البدء…';

  @override
  String get cleanerStatusFilesScanned => 'تم فحص الملفات';

  @override
  String get cleanerStatusFindingUnusedApps =>
      'جاري البحث عن التطبيقات غير المستخدمة…';

  @override
  String get cleanerStatusComplete => 'اكتمل';

  @override
  String get cleanerStatusScanError => 'خطأ في الفحص';

  @override
  String get cleanerStatusScanningApps => 'جاري فحص التطبيقات…';

  @override
  String get cleanerGrantUsageAccessTitle => 'منح الوصول لبيانات الاستخدام';

  @override
  String get cleanerGrantUsageAccessBody =>
      'لاكتشاف التطبيقات غير المستخدمة، يتطلب المنظف إذن الوصول إلى بيانات الاستخدام. سيتم توجيهك لإعدادات النظام لتمكينه.';

  @override
  String get cleanerCancel => 'إلغاء';

  @override
  String get cleanerContinue => 'متابعة';

  @override
  String get cleanerDuplicates => 'التكرارات';

  @override
  String get cleanerDuplicatesNone => 'لم يتم العثور على تكرارات';

  @override
  String cleanerDuplicatesSubtitle(Object count, Object size) {
    return '$count عناصر • استعادة $size';
  }

  @override
  String get cleanerOldPhotos => 'الصور القديمة';

  @override
  String cleanerOldPhotosNone(Object days) {
    return 'لا توجد صور أقدم من $days يوم';
  }

  @override
  String cleanerOldPhotosSubtitle(Object count, Object size) {
    return '$count عناصر • $size';
  }

  @override
  String get cleanerOldVideos => 'الفيديوهات القديمة';

  @override
  String cleanerOldVideosNone(Object days) {
    return 'لا توجد فيديوهات أقدم من $days يوم';
  }

  @override
  String cleanerOldVideosSubtitle(Object count, Object size) {
    return '$count عناصر • $size';
  }

  @override
  String get cleanerLargeFiles => 'الملفات الكبيرة';

  @override
  String cleanerLargeFilesNone(Object size) {
    return 'لا توجد ملفات ≥ $size';
  }

  @override
  String cleanerLargeFilesSubtitle(Object count, Object sizeTotal) {
    return '$count عناصر • $sizeTotal';
  }

  @override
  String get cleanerUnusedApps => 'تطبيقات غير مستخدمة';

  @override
  String cleanerUnusedAppsNone(Object days) {
    return 'لا توجد تطبيقات غير مستخدمة (آخر $days يوم)';
  }

  @override
  String cleanerUnusedAppsCount(Object count) {
    return '$count تطبيق';
  }

  @override
  String get cleanerStageDuplicates => 'جاري فحص التكرارات…';

  @override
  String get cleanerStageDuplicatesGrouping => 'جاري تجميع التكرارات…';

  @override
  String get cleanerStageOldPhotos => 'جاري فحص الصور القديمة…';

  @override
  String get cleanerStageOldVideos => 'جاري فحص الفيديوهات القديمة…';

  @override
  String get cleanerStageLargeFiles => 'جاري فحص الملفات الكبيرة…';

  @override
  String cleanerStageOldPhotosProgress(Object count, Object size) {
    return 'صور قديمة: $count • $size';
  }

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
    return 'لا توجد تطبيقات غير مستخدمة في آخر $days يوم';
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
  String get quarantineEmptyBody => 'أي شيء تقوم بإزالته سيظهر هنا.';

  @override
  String get quarantineRestore => 'استعادة';

  @override
  String get quarantineDelete => 'حذف';

  @override
  String get quarantineSnackRestored => 'تمت الاستعادة';

  @override
  String get quarantineSnackDeleted => 'تم الحذف';

  @override
  String get quarantineDeleteDialogTitle => 'حذف الملفات المختارة؟';

  @override
  String quarantineDeleteDialogBody(Object count, Object plural) {
    return 'سيؤدي هذا لحذف $count $plural نهائيًا.';
  }
}
