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

  @override
  void initState() {
    super.initState();
    _loadDefaultPlan();
    _loadPrices();
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

  Future<void> _buySelected() async {
    if (_buying) return;

    setState(() => _buying = true);

    try {
      if (_selected == ProPlanType.monthly) {
        await PurchaseService.buyMonthly();
      } else {
        await PurchaseService.buyYearly();
      }

      await PurchaseService.restore();
      final ok = await PurchaseService.hasPro();

      if (!mounted) return;

      if (ok) {
        await _persistDefaultPlan(_selected);
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

          return Card(
            color: scheme.surfaceContainer,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            clipBehavior: Clip.antiAlias,
            child: ListTile(
              onTap: () {
                Navigator.pop(ctx);
                setState(() => _selected = p);
              },
              title: Row(
                children: [
                  Expanded(
                    child: Text(
                      _titleFor(p, l10n),
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: selected ? FontWeight.w800 : FontWeight.w700,
                      ),
                    ),
                  ),
                  if (badge != null)
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
              subtitle: subtitle == null ? null : Text(subtitle),
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
                  option(ProPlanType.yearly, badge: l10n.settingsBestValue, subtitle: yearlySubtitle.isEmpty ? null : yearlySubtitle),
                  option(ProPlanType.monthly, subtitle: monthlySubtitle.isEmpty ? null : monthlySubtitle),
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
                      Text(
                        l10n.settingsUltimateSecurity,
                        style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w900),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        l10n.settingsProSubtitle,
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
                          onPressed: _buying ? null : _buySelected,
                          child: _buying
                              ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                              : Text(
                            _ctaLabel(_selected, l10n),
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
        item(Icons.public_rounded, l10n.settingsUnlimitedDnsTitle, l10n.settingsUnlimitedDnsBody),
        item(Icons.block_rounded, 'Ad-free experience', 'Remove ads across the entire app'),
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