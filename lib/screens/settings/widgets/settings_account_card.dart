import 'package:flutter/material.dart';

import '../../../translations/app_localizations.dart';
class SettingsAccountCard extends StatelessWidget {
  final bool signedIn;
  final bool accountLoading;
  final String? accountEmail;
  final String? accountId;
  final VoidCallback onSignIn;
  final VoidCallback onDashboard;
  final VoidCallback onSignOut;

  const SettingsAccountCard({
    super.key,
    required this.signedIn,
    required this.accountLoading,
    required this.accountEmail,
    required this.accountId,
    required this.onSignIn,
    required this.onDashboard,
    required this.onSignOut,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppLocalizations.of(context)!.settingsAccountTitle,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w800,
            color: scheme.onSurface.withOpacity(0.92),
          ),
        ),
        const SizedBox(height: 10),
        Card.outlined(
          color: scheme.surfaceContainer,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          clipBehavior: Clip.antiAlias,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (!signedIn) ...[
                  Text(
                    AppLocalizations.of(context)!.vpnSettingsSignInToContinue,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                      color: scheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    AppLocalizations.of(context)!.settingsAccountCardSyncPurchasesAndUnlockProAcrossApps,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: scheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 14),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: onSignIn,
                      style: ElevatedButton.styleFrom(
                        elevation: 0,
                        backgroundColor: scheme.primary,
                        foregroundColor: scheme.onPrimary,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        textStyle: const TextStyle(fontWeight: FontWeight.w800),
                      ),
                      child:  Text(AppLocalizations.of(context)!.vpnSignIn),
                    ),
                  ),
                ] else ...[
                  Text(
                    accountEmail ??
                        accountId ??
                        (accountLoading ? AppLocalizations.of(context)!.settingsAccountCardLoading : AppLocalizations.of(context)!.vpnSettingsSignedIn),
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                      color: scheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: onDashboard,
                          style: ElevatedButton.styleFrom(
                            elevation: 0,
                            backgroundColor: scheme.primary,
                            foregroundColor: scheme.onPrimary,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                            textStyle: const TextStyle(fontWeight: FontWeight.w800),
                          ),
                          child:  Text(AppLocalizations.of(context)!.settingsAccountCardDashboard),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: OutlinedButton(
                          onPressed: onSignOut,
                          style: OutlinedButton.styleFrom(
                            foregroundColor: scheme.onSurface,
                            side: BorderSide(
                              color: scheme.outlineVariant.withValues(alpha: 0.45),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                            textStyle: const TextStyle(fontWeight: FontWeight.w800),
                          ),
                          child:  Text(AppLocalizations.of(context)!.vpnSettingsSignOut),
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }
}