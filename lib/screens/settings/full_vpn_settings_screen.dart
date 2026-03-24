import 'package:app_links/app_links.dart';
import 'package:colourswift_av/screens/vpn/services/full_vpn_backend.dart';
import 'package:flutter/material.dart';
import 'dart:async';

import '../../services/purchase_service.dart';
import '../../translations/app_localizations.dart';

class FullVpnSettingsScreen extends StatefulWidget {
  const FullVpnSettingsScreen({super.key});

  @override
  State<FullVpnSettingsScreen> createState() => _FullVpnSettingsScreenState();
}

class _FullVpnSettingsScreenState extends State<FullVpnSettingsScreen>
    with WidgetsBindingObserver {
  late final FullVpnController c;
  late final AppLinks _appLinks;
  StreamSubscription<Uri>? _linkSub;
  bool _closing = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    c = FullVpnController.shared;
    c.init();

    @override
    void dispose() {
      _closing = true;
      _linkSub?.cancel();
      _linkSub = null;
      WidgetsBinding.instance.removeObserver(this);
      c.dispose();
      super.dispose();
    }

    @override
    void didChangeAppLifecycleState(AppLifecycleState state) {
      if (state == AppLifecycleState.resumed) {
        c.onResumed();
      }
    }
  }


  Future<void> _showSignInPopup() async {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final l10n = AppLocalizations.of(context)!;

    await showDialog(
      context: context,
      barrierDismissible: true,
      builder: (ctx) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(22),
            child: Container(
              decoration: BoxDecoration(
                color: scheme.surfaceContainerHigh,
                borderRadius: BorderRadius.circular(22),
                border: Border.all(color: scheme.outlineVariant.withOpacity(0.25)),
                boxShadow: [
                  BoxShadow(
                    color: scheme.primary.withOpacity(0.08),
                    blurRadius: 40,
                    spreadRadius: -10,
                    offset: const Offset(0, 16),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 14),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 38,
                          height: 38,
                          decoration: BoxDecoration(
                            color: scheme.primaryContainer,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          alignment: Alignment.center,
                          child: Icon(
                            Icons.login_rounded,
                            color: scheme.onPrimaryContainer,
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            l10n.vpnAccountSignInRequiredTitle,
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w800,
                              color: scheme.onSurface,
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: () => Navigator.pop(ctx),
                          icon: Icon(
                            Icons.close_rounded,
                            color: scheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(
                      l10n.vpnAccountSignInManageUsageBody,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: scheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 14),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () => Navigator.pop(ctx),
                            child: Text(l10n.cancel),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: FilledButton(
                            onPressed: () async {
                              Navigator.pop(ctx);
                              await c.startLoginInBrowser();
                            },
                            child: Text(l10n.vpnSettingsSignInToContinue),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  String _planLabel(AppLocalizations l10n) {
    final me = c.me;
    if (me == null) return l10n.vpnAccountNotSignedIn;

    final rawPlan = (me["plan"] ?? "").toString().trim();
    if (rawPlan.isEmpty) return l10n.vpnAccountFree;

    return rawPlan[0].toUpperCase() + rawPlan.substring(1);
  }

  String _membershipLabel(AppLocalizations l10n) {
    final signedIn = c.token.isNotEmpty && c.me != null;
    final rawPlan = (c.me?["plan"] ?? "").toString().trim().toLowerCase();
    final isFounder = PurchaseService.isFounder;

    final isProPlan = signedIn && rawPlan == "pro";

    if (isFounder && isProPlan) return l10n.vpnAccountMembershipFounderVpnPro;
    if (isFounder && !isProPlan) return l10n.vpnAccountMembershipFounder;
    if (isProPlan) return l10n.vpnAccountMembershipPro;
    return l10n.vpnAccountFree;
  }

  String _emailLabel(AppLocalizations l10n) {
    final me = c.me;
    if (me == null) return l10n.vpnAccountNotSignedIn;
    return (me["email"] ?? l10n.vpnAccountUnknown).toString();
  }

  String _accountStatusLabel(AppLocalizations l10n) {
    final signedIn = c.token.isNotEmpty && c.me != null;
    if (!signedIn) return l10n.vpnAccountNotSignedIn;
    return c.busy ? l10n.vpnAccountStatusSyncing : l10n.vpnAccountStatusActive;
  }

  String _usageSummaryLabel(AppLocalizations l10n) {
    if (!c.usageEverLoaded) {
      return c.me == null
          ? l10n.vpnAccountUsageSignInToSync
          : l10n.vpnAccountUsagePullToRefresh;
    }

    if (c.unlimited) {
      return l10n.vpnAccountUsageUsedThisMonthUnlimited(
        c.formatBytes(c.usedBytes),
      );
    }

    if (c.limitBytes > 0) {
      return l10n.vpnAccountUsageUsedOfLimit(
        c.formatBytes(c.usedBytes),
        c.formatBytes(c.limitBytes),
      );
    }

    return l10n.vpnAccountStatusUnavailable;
  }

  String _serverLoadSummaryLabel(AppLocalizations l10n) {
    if (c.serverStatusEverLoaded &&
        c.selectedServerCap != null &&
        c.selectedServerConnectedNow != null) {
      return l10n.vpnAccountServerConnectedCountWithLabel(
        c.selectedServerConnectedNow.toString(),
        c.selectedServerCap.toString(),
      );
    }
    return l10n.vpnAccountStatusUnavailable;
  }

  Widget _sectionShell(
      BuildContext context, {
        required Widget child,
        EdgeInsets padding = const EdgeInsets.all(16),
      }) {
    final scheme = Theme.of(context).colorScheme;

    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: scheme.surfaceContainer,
        borderRadius: BorderRadius.circular(20),
      ),
      child: child,
    );
  }

  Widget _statusChip(BuildContext context, String label) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: scheme.outlineVariant.withOpacity(0.28)),
      ),
      child: Text(
        label,
        style: theme.textTheme.labelMedium?.copyWith(
          fontWeight: FontWeight.w700,
          color: scheme.onSurface,
        ),
      ),
    );
  }

  Widget _identityHeader(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final l10n = AppLocalizations.of(context)!;
    final signedIn = c.token.isNotEmpty && c.me != null;
    final email = _emailLabel(l10n);

    return _sectionShell(
      context,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            signedIn ? email : l10n.vpnAccountIdentityFallbackTitle,
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w800,
              color: scheme.onSurface,
              height: 1.1,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Text(
                l10n.vpnAccountMembershipLabel,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: scheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(width: 8),
              Flexible(
                child: Text(
                  _membershipLabel(l10n),
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                    color: scheme.onSurface,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 2),
        ],
      ),
    );
  }

  Widget _usageAndServerPanel(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final l10n = AppLocalizations.of(context)!;

    final bool hasServerLoad = c.serverStatusEverLoaded &&
        c.selectedServerCap != null &&
        c.selectedServerConnectedNow != null;

    Widget usageBlock() {
      if (!c.usageEverLoaded) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  l10n.vpnAccountUsageTitle,
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: scheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(width: 8),
                if (c.usageSyncing)
                  Text(
                    l10n.vpnAccountStatusSyncing,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: scheme.onSurfaceVariant,
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 10),
            const LinearProgressIndicator(minHeight: 6),
            const SizedBox(height: 10),
            Text(
              c.me == null
                  ? l10n.vpnAccountUsageSignInToSync
                  : l10n.vpnAccountUsageLoading,
              style: theme.textTheme.bodySmall?.copyWith(
                color: scheme.onSurfaceVariant,
              ),
            ),
          ],
        );
      }

      if (c.unlimited) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  l10n.vpnAccountUsageTitle,
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: scheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(width: 8),
                if (c.usageSyncing)
                  Text(
                    l10n.vpnAccountStatusSyncing,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: scheme.onSurfaceVariant,
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              l10n.vpnAccountUsageUnlimited,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w800,
                color: scheme.onSurface,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              l10n.vpnAccountUsageUsedThisMonth(c.formatBytes(c.usedBytes)),
              style: theme.textTheme.bodySmall?.copyWith(
                color: scheme.onSurfaceVariant,
              ),
            ),
          ],
        );
      }

      if (c.limitBytes > 0) {
        final target = (c.usedBytes / c.limitBytes).clamp(0.0, 1.0);

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  l10n.vpnAccountUsageTitle,
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: scheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(width: 8),
                if (c.usageSyncing)
                  Text(
                    l10n.vpnAccountStatusSyncing,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: scheme.onSurfaceVariant,
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 10),
            LinearProgressIndicator(
              value: target,
              minHeight: 6,
              borderRadius: BorderRadius.circular(999),
            ),
            const SizedBox(height: 8),
            Text(
              l10n.vpnAccountUsageUsedOfLimit(
                c.formatBytes(c.usedBytes),
                c.formatBytes(c.limitBytes),
              ),
              style: theme.textTheme.bodySmall?.copyWith(
                color: scheme.onSurface,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        );
      }

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.vpnAccountUsageTitle,
            style: theme.textTheme.labelMedium?.copyWith(
              color: scheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            l10n.vpnAccountStatusUnavailable,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
              color: scheme.onSurface,
            ),
          ),
        ],
      );
    }

    Widget serverBlock() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.vpnAccountServerLoadTitle,
            style: theme.textTheme.labelMedium?.copyWith(
              color: scheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            hasServerLoad
                ? l10n.vpnAccountServerConnectedCount(
              c.selectedServerConnectedNow.toString(),
              c.selectedServerCap.toString(),
            )
                : l10n.vpnAccountStatusUnavailable,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w800,
              color: scheme.onSurface,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            hasServerLoad
                ? l10n.vpnAccountStatusConnectedNow
                : l10n.vpnAccountStatusRefreshToLoadServer,
            style: theme.textTheme.bodySmall?.copyWith(
              color: scheme.onSurfaceVariant,
            ),
          ),
        ],
      );
    }

    return _sectionShell(
      context,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          LayoutBuilder(
            builder: (context, constraints) {
              final wide = constraints.maxWidth >= 520;

              if (!wide) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    usageBlock(),
                    const SizedBox(height: 14),
                    Container(
                      height: 1,
                      color: scheme.outlineVariant.withOpacity(0.18),
                    ),
                    const SizedBox(height: 14),
                    serverBlock(),
                  ],
                );
              }

              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: usageBlock()),
                  const SizedBox(width: 14),
                  Container(
                    width: 1,
                    height: 78,
                    color: scheme.outlineVariant.withOpacity(0.18),
                  ),
                  const SizedBox(width: 14),
                  Expanded(child: serverBlock()),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _kvRow(
      BuildContext context,
      String label,
      String value, {
        bool stacked = false,
      }) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    if (stacked) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: scheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              value,
              style: theme.textTheme.bodySmall?.copyWith(
                color: scheme.onSurface,
                fontWeight: FontWeight.w600,
                height: 1.25,
              ),
            ),
          ],
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 7),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Text(
              label,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: scheme.onSurfaceVariant,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: scheme.onSurface,
                fontWeight: FontWeight.w700,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _accountStatusPanel(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final l10n = AppLocalizations.of(context)!;
    final signedIn = c.token.isNotEmpty && c.me != null;

    return _sectionShell(
      context,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.vpnAccountSectionAccountStatus,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w800,
              color: scheme.onSurface,
            ),
          ),
          const SizedBox(height: 10),
          _kvRow(context, l10n.vpnAccountKvStatus, _accountStatusLabel(l10n)),
          Container(height: 1, color: scheme.outlineVariant.withOpacity(0.14)),
          _kvRow(context, l10n.vpnAccountKvPlan, _planLabel(l10n)),
          Container(height: 1, color: scheme.outlineVariant.withOpacity(0.14)),
          _kvRow(context, l10n.vpnAccountKvUsage, _usageSummaryLabel(l10n), stacked: true),
          Container(height: 1, color: scheme.outlineVariant.withOpacity(0.14)),
          _kvRow(context, l10n.vpnAccountKvSelectedServer, _serverLoadSummaryLabel(l10n)),
          if (signedIn) ...[
            Container(height: 1, color: scheme.outlineVariant.withOpacity(0.14)),
            _kvRow(
              context,
              l10n.vpnAccountKvConnectionState,
              c.connected
                  ? l10n.vpnAccountStatusConnected
                  : l10n.vpnAccountStatusDisconnected,
            ),
          ],
        ],
      ),
    );
  }

  Widget _actionsPanel(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final l10n = AppLocalizations.of(context)!;
    final signedIn = c.token.isNotEmpty && c.me != null;

    return _sectionShell(
      context,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.vpnAccountSectionActions,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w800,
              color: scheme.onSurface,
            ),
          ),
          const SizedBox(height: 12),
          if (!signedIn)
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: c.busy ? null : _showSignInPopup,
                child: Text(l10n.vpnSettingsSignInToContinue),
              ),
            )
          else ...[
            SizedBox(
              width: double.infinity,
              child: FilledButton.tonal(
                onPressed: c.busy
                    ? null
                    : () async {
                  await c.refreshMe();
                  await c.fetchUsage(showSync: true);
                  await c.fetchServerStatus();
                  await c.refreshLocation(force: true);
                },
                child: Text(l10n.vpnAccountActionRefresh),
              ),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: c.busy ? null : () {},
                    icon: const Icon(Icons.open_in_new_rounded, size: 18),
                    label: Text(l10n.vpnAccountActionOpen),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: FilledButton(
                    onPressed: c.busy ? null : c.signOut,
                    child: Text(l10n.vpnSettingsSignOut),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _founderNote(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final l10n = AppLocalizations.of(context)!;

    return Padding(
      padding: const EdgeInsets.fromLTRB(6, 2, 6, 2),
      child: Column(
        children: [
          Text(
            l10n.vpnAccountFounderThanks,
            textAlign: TextAlign.center,
            style: theme.textTheme.bodySmall?.copyWith(
              color: scheme.onSurfaceVariant,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            l10n.vpnAccountFounderNote,
            textAlign: TextAlign.center,
            style: theme.textTheme.bodySmall?.copyWith(
              color: scheme.onSurfaceVariant.withOpacity(0.92),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final l10n = AppLocalizations.of(context)!;

    return AnimatedBuilder(
      animation: c,
      builder: (context, _) {
        return Scaffold(
          backgroundColor: scheme.surface,
          appBar: AppBar(
            title: Text(
              l10n.vpnAccountScreenTitle,
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
            child: RefreshIndicator(
              onRefresh: () async {
                await c.onResumed();
              },
              child: ListView(
                physics: const BouncingScrollPhysics(
                  parent: AlwaysScrollableScrollPhysics(),
                ),
                padding: const EdgeInsets.fromLTRB(14, 14, 14, 18),
                children: [
                  _identityHeader(context),
                  const SizedBox(height: 12),
                  _usageAndServerPanel(context),
                  const SizedBox(height: 12),
                  _accountStatusPanel(context),
                  const SizedBox(height: 12),
                  _actionsPanel(context),
                  const SizedBox(height: 14),
                  _founderNote(context),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}