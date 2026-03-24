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
  String _currentStatusLabel = '';

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
    final v = p == ProPlanType.monthly ? 'monthly' : 'yearly';
    await prefs.setString('pro_default_plan', v);
  }

  ProPlanType? _planTypeFromServerPlan(String plan) {
    final p = plan.toLowerCase();
    if (p.contains('year')) return ProPlanType.yearly;
    if (p.contains('annual')) return ProPlanType.yearly;
    if (p.contains('month')) return ProPlanType.monthly;
    return null;
  }

  String _statusLabelFrom(ProPlanType? planType, bool isPro, bool isFounder) {
    if (!isPro) return 'Free';
    if (planType == null) return isFounder ? 'Founder' : 'Pro';
    final base = planType == ProPlanType.yearly ? 'Yearly' : 'Monthly';
    return isFounder ? '$base (Founder)' : base;
  }

  Future<void> _loadCurrentStatus() async {
    final prefs = await SharedPreferences.getInstance();

    String serverPlan = (prefs.getString('billing_server_plan') ?? '').toLowerCase();
    ProPlanType? planType = _planTypeFromServerPlan(serverPlan);

    if (planType == null) {
      final localPlan = (prefs.getString('billing_local_sub_plan') ?? '').toString();
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
      _currentStatusLabel = isPro
          ? (planType == null ? 'Pro' : (planType == ProPlanType.yearly ? 'Yearly' : 'Monthly'))
          : 'Free';
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
      setState(() {
        _loading = false;
      });
    }
  }

  String _titleFor(ProPlanType p, AppLocalizations l10n) {
    switch (p) {
      case ProPlanType.monthly:
        return l10n.settingsMonthly;
      case ProPlanType.yearly:
        return l10n.settingsYearly;
    }
  }

  String _ctaLabel(ProPlanType p, AppLocalizations l10n) {
    switch (p) {
      case ProPlanType.monthly:
        return l10n.settingsSubscribeMonthly;
      case ProPlanType.yearly:
        return l10n.settingsSubscribeYearly;
    }
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

    await showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.35),
      builder: (context) {
        final theme = Theme.of(context);
        final text = theme.textTheme;

        return AlertDialog(
          backgroundColor: theme.colorScheme.surfaceContainerHigh,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          title: Text(
            'Thank you',
            style: text.titleMedium?.copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),
          content: Text(
            'Your purchase is confirmed.',
            style: text.bodySmall?.copyWith(
              height: 1.4,
              color: text.bodySmall?.color?.withOpacity(0.85),
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

      final bool nowOnSelectedPlan = _isSelectedCurrentPlan();

      if (nowOnSelectedPlan) {
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

          final titleStyle = theme.textTheme.titleMedium?.copyWith(
            fontWeight: selected ? FontWeight.w800 : FontWeight.w700,
            color: isCurrent ? scheme.onSurface.withOpacity(0.55) : scheme.onSurface,
          );

          final subtitleStyle = theme.textTheme.bodySmall?.copyWith(
            color: isCurrent ? scheme.onSurfaceVariant.withOpacity(0.55) : scheme.onSurfaceVariant,
          );

          return Card(
            color: scheme.surfaceContainer,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            clipBehavior: Clip.antiAlias,
            child: ListTile(
              enabled: !isCurrent,
              onTap: isCurrent
                  ? null
                  : () {
                Navigator.pop(ctx);
                setState(() => _selected = p);
              },
              title: Row(
                children: [
                  Expanded(
                    child: Text(
                      _titleFor(p, l10n),
                      style: titleStyle,
                    ),
                  ),
                  if (isCurrent)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: scheme.surfaceContainerHigh,
                        borderRadius: BorderRadius.circular(999),
                        border: Border.all(color: scheme.outlineVariant),
                      ),
                      child: Text(
                        'Current',
                        style: theme.textTheme.labelSmall?.copyWith(
                          fontWeight: FontWeight.w800,
                          color: scheme.onSurfaceVariant,
                        ),
                      ),
                    )
                  else if (badge != null)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: const Color(0xFFB8860B).withOpacity(0.18),
                        borderRadius: BorderRadius.circular(999),
                        border: Border.all(color: const Color(0xFFB8860B).withOpacity(0.35)),
                      ),
                      child: Text(
                        badge,
                        style: theme.textTheme.labelSmall?.copyWith(
                          fontWeight: FontWeight.w800,
                          color: const Color(0xFFB8860B),
                        ),
                      ),
                    ),
                  const SizedBox(width: 10),
                  if (selected) const Icon(Icons.check_rounded),
                ],
              ),
              subtitle: subtitle == null
                  ? null
                  : Text(
                subtitle,
                style: subtitleStyle,
              ),
            ),
          );
        }

        final yearlySubtitle = _yearlyInfo?.formattedPrice ?? '';
        final monthlySubtitle = _monthlyInfo?.formattedPrice ?? '';

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
                    subtitle: yearlySubtitle.isEmpty ? null : yearlySubtitle,
                  ),
                  option(
                    ProPlanType.monthly,
                    subtitle: monthlySubtitle.isEmpty ? null : monthlySubtitle,
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

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    final monthly = _monthlyInfo;
    final yearly = _yearlyInfo;

    final bool hasPrices = monthly != null && yearly != null;

    double? yearlyPerMonth;
    int? savePercent;

    if (hasPrices) {
      yearlyPerMonth = yearly!.price / 12.0;
      final ratio = yearlyPerMonth / monthly!.price;
      savePercent = ((1.0 - ratio) * 100.0).round();
      if (savePercent < 0) savePercent = 0;
      if (savePercent > 95) savePercent = 95;
    }

    Widget planPriceBlock() {
      if (!hasPrices) {
        return Text(
          l10n.settingsPlanPriceLoading,
          style: theme.textTheme.bodySmall?.copyWith(color: scheme.onSurfaceVariant),
        );
      }

      if (_selected == ProPlanType.yearly) {
        final perMonthStr = _formatCurrency(yearlyPerMonth!, yearly!.currencyCode);

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${monthly!.formattedPrice} / month',
              style: theme.textTheme.bodySmall?.copyWith(
                color: scheme.onSurfaceVariant,
                decoration: TextDecoration.lineThrough,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              '$perMonthStr / month',
              style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w900),
            ),
            const SizedBox(height: 4),
            Text(
              'Billed ${yearly.formattedPrice} yearly',
              style: theme.textTheme.bodySmall?.copyWith(color: scheme.onSurfaceVariant),
            ),
            const SizedBox(height: 8),
            if (savePercent != null)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: scheme.primaryContainer,
                  borderRadius: BorderRadius.circular(999),
                  border: Border.all(color: scheme.primaryContainer.withOpacity(0.6)),
                ),
                child: Text(
                  'Save $savePercent%',
                  style: theme.textTheme.labelSmall?.copyWith(
                    fontWeight: FontWeight.w900,
                    color: scheme.onPrimaryContainer,
                  ),
                ),
              ),
          ],
        );
      }

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${monthly!.formattedPrice} / month',
            style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 4),
          Text(
            'Cancel anytime',
            style: theme.textTheme.bodySmall?.copyWith(color: scheme.onSurfaceVariant),
          ),
        ],
      );
    }

    final disabledBuy = _buying || _isSelectedCurrentPlan();

    return Scaffold(
      backgroundColor: scheme.surface,
      appBar: AppBar(
        title: Text(
          l10n.settingsUnlockPro,
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w800,
            color: scheme.onSurface,
          ),
        ),
        centerTitle: true,
        backgroundColor: scheme.surface,
        surfaceTintColor: scheme.surfaceTint,
        scrolledUnderElevation: 0,
        elevation: 0,
      ),
      body: SafeArea(
        child: _loading
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Card.outlined(
                color: scheme.surfaceContainer,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                clipBehavior: Clip.antiAlias,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                            decoration: BoxDecoration(
                              color: const Color(0xFFB8860B).withOpacity(0.18),
                              borderRadius: BorderRadius.circular(999),
                              border: Border.all(color: const Color(0xFFB8860B).withOpacity(0.35)),
                            ),
                            child: Text(
                              l10n.settingsPremium,
                              style: theme.textTheme.labelSmall?.copyWith(
                                fontWeight: FontWeight.w800,
                                color: const Color(0xFFB8860B),
                              ),
                            ),
                          ),
                          const Spacer(),
                          TextButton.icon(
                            onPressed: _openPlanPicker,
                            icon: const Icon(Icons.swap_horiz_rounded),
                            label: Text(l10n.settingsSwitchPlan),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                        decoration: BoxDecoration(
                          color: scheme.surfaceContainerHigh,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: scheme.outlineVariant),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.verified_rounded, color: scheme.onSurfaceVariant),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                'Current status: ${_currentStatusLabel.isEmpty ? 'Free' : _currentStatusLabel}',
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  fontWeight: FontWeight.w700,
                                  color: scheme.onSurface,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        l10n.settingsUltimateSecurity,
                        style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w900),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        '${l10n.settingsProSubtitle}\nIncludes up to 5 VPN devices.',
                        style: theme.textTheme.bodySmall?.copyWith(color: scheme.onSurfaceVariant),
                      ),
                      const SizedBox(height: 14),
                      Card(
                        color: scheme.surfaceContainerHigh,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _titleFor(_selected, l10n),
                                style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
                              ),
                              const SizedBox(height: 8),
                              planPriceBlock(),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 14),
                      SizedBox(
                        width: double.infinity,
                        child: FilledButton(
                          style: FilledButton.styleFrom(
                            backgroundColor: const Color(0xFFB8860B),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                          ),
                          onPressed: disabledBuy ? null : _buySelected,
                          child: _buying
                              ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                              : Text(
                            _isSelectedCurrentPlan() ? 'Current plan' : _ctaLabel(_selected, l10n),
                            style: const TextStyle(
                              fontWeight: FontWeight.w800,
                              letterSpacing: 0.3,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 14),
              _benefitsCard(context),
              const SizedBox(height: 10),
              _finePrint(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _benefitsCard(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    Widget item(IconData icon, String title, String subtitle) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: Card.outlined(
          color: scheme.surfaceContainer,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          clipBehavior: Clip.antiAlias,
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: scheme.primaryContainer,
              child: Icon(icon, color: scheme.onPrimaryContainer),
            ),
            title: Text(
              title,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
                color: scheme.onSurface,
              ),
            ),
            subtitle: Text(
              subtitle,
              style: theme.textTheme.bodySmall?.copyWith(color: scheme.onSurfaceVariant),
            ),
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.settingsProBenefitsTitle,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w800,
            color: scheme.onSurface.withOpacity(0.92),
          ),
        ),
        const SizedBox(height: 10),
        item(Icons.vpn_lock_rounded, 'Unlimited VPN', 'Unlimited bandwidth and secure browsing anywhere'),
        item(Icons.devices_rounded, '5 VPN devices', 'Use your Premium VPN on up to 5 devices at the same time'),
        item(Icons.public_rounded, l10n.settingsUnlimitedDnsTitle, l10n.settingsUnlimitedDnsBody),
        item(Icons.palette_rounded, l10n.settingsThemesTitle, l10n.settingsThemesBody),
        item(Icons.apps_rounded, l10n.settingsIconCustomizationTitle, l10n.settingsIconCustomizationBody),
        item(Icons.schedule_rounded, l10n.settingsScheduledScansTitle, l10n.settingsScheduledScansBody),
      ],
    );
  }

  Widget _finePrint(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Text(
      l10n.settingsProFinePrint,
      style: theme.textTheme.bodySmall?.copyWith(color: scheme.onSurfaceVariant),
    );
  }
}