import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../services/purchase_service.dart';
import '../../translations/app_localizations.dart';

enum ProPlanType { yearly, monthly }

class ProScreen extends StatefulWidget {
  const ProScreen({super.key});

  @override
  State<ProScreen> createState() => _ProScreenState();
}

class _ProScreenState extends State<ProScreen> {
  ProPlanType _selected = ProPlanType.yearly;
  bool _loading = true;
  bool _buying = false;

  PlanPriceInfo? _monthlyInfo;
  PlanPriceInfo? _yearlyInfo;

  bool _isPro = false;
  bool _isFounder = false;
  ProPlanType? _currentPlanType;

  @override
  void initState() {
    super.initState();
    _loadDefaultPlan();
    _loadPrices();
    _loadCurrentStatus();
  }

  Future<void> _loadDefaultPlan() async {
    final prefs = await SharedPreferences.getInstance();
    final v = prefs.getString('pro_default_plan') ?? 'yearly';
    if (!mounted) return;
    setState(() {
      _selected = v == 'monthly' ? ProPlanType.monthly : ProPlanType.yearly;
    });
  }

  Future<void> _persistDefaultPlan(ProPlanType p) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('pro_default_plan', p == ProPlanType.monthly ? 'monthly' : 'yearly');
  }

  ProPlanType? _planTypeFromServerPlan(String plan) {
    final p = plan.toLowerCase();
    if (p.contains('year') || p.contains('annual')) return ProPlanType.yearly;
    if (p.contains('month')) return ProPlanType.monthly;
    return null;
  }

  Future<void> _loadCurrentStatus() async {
    final prefs = await SharedPreferences.getInstance();

    String serverPlan = (prefs.getString('billing_server_plan') ?? '').toLowerCase();
    ProPlanType? planType = _planTypeFromServerPlan(serverPlan);

    if (planType == null) {
      final localPlan = prefs.getString('billing_local_sub_plan') ?? '';
      if (localPlan == PurchaseService.basePlanYearly) {
        planType = ProPlanType.yearly;
      } else if (localPlan == PurchaseService.basePlanMonthly) {
        planType = ProPlanType.monthly;
      }
    }

    final isPro = PurchaseService.isPro || (prefs.getBool('billing_is_pro') ?? false);

    if (!mounted) return;
    setState(() {
      _isPro = isPro;
      _isFounder = false;
      _currentPlanType = isPro ? planType : null;
    });
  }

  Future<void> _loadPrices() async {
    try {
      await PurchaseService.ensureReady();

      final monthlyInfo = await PurchaseService.priceInfoForBasePlan(
        PurchaseService.basePlanMonthly,
      );
      final yearlyInfo = await PurchaseService.priceInfoForBasePlan(
        PurchaseService.basePlanYearly,
      );

      if (!mounted) return;
      setState(() {
        _monthlyInfo = monthlyInfo;
        _yearlyInfo = yearlyInfo;
        _loading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() => _loading = false);
    }
  }

  String _titleFor(ProPlanType p, AppLocalizations l10n) {
    return p == ProPlanType.monthly ? l10n.settingsMonthly : l10n.settingsYearly;
  }

  String _formatCurrency(double value, String currencyCode) {
    return NumberFormat.simpleCurrency(name: currencyCode).format(value);
  }

  bool _isSelectedCurrentPlan() {
    return _isPro && _currentPlanType != null && _selected == _currentPlanType;
  }

  Future<void> _showThankYou() async {
    if (!mounted) return;
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    await showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.35),
      builder: (context) {
        return AlertDialog(
          backgroundColor: scheme.surfaceContainerHigh,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
          title: Text(
            AppLocalizations.of(context)!.proScreenThankYou,
            style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
          ),
          content: Text(
            AppLocalizations.of(context)!.proScreenYourSubscriptionIsConfirmed,
            style: theme.textTheme.bodySmall?.copyWith(
              color: scheme.onSurfaceVariant,
              height: 1.35,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(l10n.ok),
            ),
          ],
        );
      },
    );
  }

  Future<void> _buySelected() async {
    if (_buying) return;
    if (_isSelectedCurrentPlan()) return;

    setState(() => _buying = true);

    try {
      if (_selected == ProPlanType.monthly) {
        await PurchaseService.buyMonthly();
      } else {
        await PurchaseService.buyYearly();
      }

      await PurchaseService.restore();
      if (!mounted) return;

      await _loadCurrentStatus();

      if (_isSelectedCurrentPlan()) {
        await _persistDefaultPlan(_selected);
        await _showThankYou();
        if (!mounted) return;
        Navigator.pop(context, true);
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context)!.settingsPurchaseNotConfirmed)),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context)!.settingsPurchaseFailed(e.toString()))),
      );
    } finally {
      if (mounted) setState(() => _buying = false);
    }
  }

  void _openPlanPicker() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      useSafeArea: true,
      isScrollControlled: true,
      builder: (ctx) {
        final theme = Theme.of(ctx);
        final scheme = theme.colorScheme;
        final l10n = AppLocalizations.of(ctx)!;

        Widget option(ProPlanType p, {String? badge, String? subtitle}) {
          final selected = _selected == p;
          final isCurrent = _isPro && _currentPlanType != null && _currentPlanType == p;

          return GestureDetector(
            onTap: isCurrent
                ? null
                : () {
              Navigator.pop(ctx);
              setState(() => _selected = p);
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: selected
                    ? scheme.primary.withOpacity(0.08)
                    : scheme.surfaceContainer,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: selected
                      ? scheme.primary.withOpacity(0.7)
                      : scheme.outlineVariant,
                  width: selected ? 2 : 1,
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _titleFor(p, l10n),
                          style: theme.textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w700,
                            color: isCurrent
                                ? scheme.onSurface.withOpacity(0.45)
                                : scheme.onSurface,
                          ),
                        ),
                        if (subtitle != null) ...[
                          const SizedBox(height: 2),
                          Text(
                            subtitle,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: isCurrent
                                  ? scheme.onSurfaceVariant.withOpacity(0.45)
                                  : scheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  if (isCurrent)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: scheme.surfaceContainerHigh,
                        borderRadius: BorderRadius.circular(999),
                        border: Border.all(color: scheme.outlineVariant),
                      ),
                      child: Text(
                        AppLocalizations.of(context)!.proScreenCurrent,
                        style: theme.textTheme.labelSmall?.copyWith(
                          fontWeight: FontWeight.w800,
                          color: scheme.onSurfaceVariant,
                        ),
                      ),
                    )
                  else if (badge != null)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: scheme.primary.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(999),
                        border: Border.all(color: scheme.primary.withOpacity(0.35)),
                      ),
                      child: Text(
                        badge,
                        style: theme.textTheme.labelSmall?.copyWith(
                          fontWeight: FontWeight.w800,
                          color: scheme.primary,
                        ),
                      ),
                    ),
                  const SizedBox(width: 8),
                  if (selected) const Icon(Icons.check_rounded, size: 18),
                ],
              ),
            ),
          );
        }

        return Padding(
          padding: EdgeInsets.only(
            left: 14,
            right: 14,
            top: 10,
            bottom: MediaQuery.of(ctx).viewInsets.bottom + 14,
          ),
          child: Material(
            color: scheme.surfaceContainerHigh,
            borderRadius: BorderRadius.circular(22),
            clipBehavior: Clip.antiAlias,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          l10n.settingsSwitchPlan,
                          style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
                        ),
                      ),
                      IconButton(
                        onPressed: () => Navigator.pop(ctx),
                        icon: const Icon(Icons.close_rounded),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  option(
                    ProPlanType.yearly,
                    badge: l10n.settingsBestValue,
                    subtitle: _yearlyInfo?.formattedPrice,
                  ),
                  option(
                    ProPlanType.monthly,
                    subtitle: _monthlyInfo?.formattedPrice,
                  ),
                  const SizedBox(height: 6),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildFeatureRow(BuildContext context, String title, String subtitle) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: scheme.onSurface,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: scheme.onSurfaceVariant,
                    height: 1.25,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Icon(
            Icons.check_circle_outline_rounded,
            color: scheme.primary,
            size: 22,
          ),
        ],
      ),
    );
  }

  Widget _buildPlanCard({
    required BuildContext context,
    required ProPlanType type,
    required String title,
    required String priceStr,
    required String subtitleStr,
    String? discountBadge,
    String? crossedOutPrice,
  }) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final isSelected = _selected == type;
    final isCurrent = _isPro && _currentPlanType == type;

    return Expanded(
      child: GestureDetector(
        onTap: isCurrent ? null : () => setState(() => _selected = type),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: isSelected
                ? scheme.primary.withOpacity(0.08)
                : scheme.surfaceContainer,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: isSelected
                  ? scheme.primary.withOpacity(0.75)
                  : scheme.outlineVariant,
              width: isSelected ? 2 : 1,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    title,
                    style: theme.textTheme.titleSmall?.copyWith(
                      color: scheme.onSurface,
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                  if (isSelected)
                    Icon(Icons.check_circle, color: scheme.primary, size: 16)
                  else if (isCurrent)
                    Text(
                      AppLocalizations.of(context)!.proScreenCurrent,
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: scheme.onSurfaceVariant,
                      ),
                    )
                  else if (discountBadge != null)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                        decoration: BoxDecoration(
                          color: scheme.primary.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(color: scheme.primary.withOpacity(0.35)),
                        ),
                        child: Text(
                          discountBadge,
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: scheme.primary,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                ],
              ),
              const SizedBox(height: 8),
              if (crossedOutPrice != null)
                Text(
                  crossedOutPrice,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: scheme.onSurfaceVariant,
                    decoration: TextDecoration.lineThrough,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              Text(
                priceStr,
                style: theme.textTheme.headlineSmall?.copyWith(
                  color: scheme.onSurface,
                  fontWeight: FontWeight.w900,
                  fontSize: 20,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitleStr,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: scheme.onSurfaceVariant,
                  height: 1.15,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _currentStatusText(AppLocalizations l10n) {
    if (!_isPro) return l10n.vpnAccountFree;
    if (_currentPlanType == ProPlanType.yearly) return l10n.settingsYearly;
    if (_currentPlanType == ProPlanType.monthly) return l10n.settingsMonthly;
    return l10n.vpnAccountMembershipPro;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    double? yearlyPerMonth;
    int? savePercent;

    if (_monthlyInfo != null && _yearlyInfo != null) {
      yearlyPerMonth = _yearlyInfo!.price / 12.0;
      final ratio = yearlyPerMonth / _monthlyInfo!.price;
      savePercent = ((1.0 - ratio) * 100.0).round().clamp(0, 95);
    }

    return Scaffold(
      backgroundColor: scheme.surface,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        actions: [
          TextButton(
            onPressed: PurchaseService.restore,
            child: Text(
              AppLocalizations.of(context)!.quarantineRestore,
              style: TextStyle(color: scheme.onSurfaceVariant),
            ),
          ),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.only(top: 100, bottom: 28),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    scheme.primary.withOpacity(0.18),
                    scheme.surface,
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: Column(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(18),
                    child: Image.asset(
                      'assets/icons/logo.png',
                      width: 72,
                      height: 72,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'AvarionX ',
                        style: theme.textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.w900,
                          letterSpacing: -0.5,
                          fontSize: 24,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: scheme.primary,
                            width: 1.5,
                          ),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Text(
                          'PRO',
                          style: theme.textTheme.titleSmall?.copyWith(
                            color: scheme.primary,
                            fontWeight: FontWeight.w900,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    l10n.proScreenCurrentStatus(_currentStatusText(l10n)),
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: scheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildFeatureRow(
                    context,
                    l10n.settingsUnlimitedDnsTitle,
                    l10n.settingsUnlimitedDnsBody,
                  ),
                  _buildFeatureRow(
                    context,
                    AppLocalizations.of(context)!.proScreenAdvancedStealthMode,
                    AppLocalizations.of(context)!.proScreenUnlockStealthTransportModesForRestrictiveNetworks,
                  ),
                  _buildFeatureRow(
                    context,
                    AppLocalizations.of(context)!.proScreenGlobalServerAccess,
                    AppLocalizations.of(context)!.proScreenAccessEveryVPNServerLocationIncludingPremium,
                  ),
                  _buildFeatureRow(
                    context,
                    l10n.settingsScheduledScansTitle,
                    l10n.settingsScheduledScansBody,
                  ),
                  _buildFeatureRow(
                    context,
                    l10n.settingsThemesTitle,
                    l10n.settingsThemesBody,
                  ),
                  _buildFeatureRow(
                    context,
                    l10n.settingsIconCustomizationTitle,
                    l10n.settingsIconCustomizationBody,
                  ),
                  const SizedBox(height: 18),
                  Row(
                    children: [
                      _buildPlanCard(
                        context: context,
                        type: ProPlanType.monthly,
                        title: l10n.settingsMonthly,
                        priceStr: _monthlyInfo?.formattedPrice ?? '-',
                        subtitleStr: AppLocalizations.of(context)!.proScreenBilledMonthly,
                      ),
                      const SizedBox(width: 10),
                      _buildPlanCard(
                        context: context,
                        type: ProPlanType.yearly,
                        title: l10n.settingsYearly,
                        discountBadge: savePercent != null ? '-$savePercent%' : null,
                        crossedOutPrice: _monthlyInfo != null
                            ? AppLocalizations.of(context)!.proScreenMo(_monthlyInfo!.formattedPrice)
                            : null,
                        priceStr: yearlyPerMonth != null
                            ? AppLocalizations.of(context)!.proScreenMo2(_formatCurrency(yearlyPerMonth, _yearlyInfo!.currencyCode))
                            : '-',
                        subtitleStr: l10n.proScreenBilledAnnuallyAt(
                          _yearlyInfo?.formattedPrice ?? '-',
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            side: BorderSide(color: scheme.outlineVariant),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                          onPressed: _openPlanPicker,
                          child: Text(
                            l10n.settingsSwitchPlan,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w700,
                              color: scheme.onSurfaceVariant,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        flex: 2,
                        child: Container(
                          height: 50,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(14),
                            gradient: (_buying || _isSelectedCurrentPlan())
                                ? null
                                : LinearGradient(
                              colors: [
                                scheme.primary,
                                scheme.primary.withOpacity(0.8),
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            color: (_buying || _isSelectedCurrentPlan())
                                ? scheme.surfaceContainerHighest
                                : null,
                          ),
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              borderRadius: BorderRadius.circular(14),
                              onTap: (_buying || _isSelectedCurrentPlan())
                                  ? null
                                  : _buySelected,
                              child: Center(
                                child: _buying
                                    ? SizedBox(
                                  height: 22,
                                  width: 22,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2.5,
                                    color: scheme.onSurface,
                                  ),
                                )
                                    : Text(
                                  _isSelectedCurrentPlan()
                                      ? AppLocalizations.of(context)!.proScreenCurrentPlan
                                      : _selected == ProPlanType.monthly
                                      ? l10n.settingsSubscribeMonthly
                                      : l10n.settingsSubscribeYearly,
                                  style: theme.textTheme.titleSmall?.copyWith(
                                    color: (_buying || _isSelectedCurrentPlan())
                                        ? scheme.onSurfaceVariant
                                        : Colors.white,
                                    fontWeight: FontWeight.w900,
                                    letterSpacing: 0.3,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    l10n.settingsProFinePrint,
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: scheme.onSurfaceVariant.withOpacity(0.6),
                      fontSize: 10,
                      height: 1.3,
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}