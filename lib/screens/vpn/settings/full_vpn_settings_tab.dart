import 'package:flutter/material.dart';
import '../services/full_vpn_backend.dart';

class FullVpnSettingsTab extends StatelessWidget {
  final FullVpnController c;
  final Widget Function(BuildContext context, {bool showWhenDisconnected}) usageRow;

  const FullVpnSettingsTab({
    super.key,
    required this.c,
    required this.usageRow,
  });

  @override
  Widget build(BuildContext context) {
    final signedIn = c.token.isNotEmpty && c.me != null;
    final email = (c.me?["email"] ?? "").toString();
    final plan = (c.me?["plan"] ?? "").toString();
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return LayoutBuilder(
      builder: (context, constraints) {
        return ConstrainedBox(
          constraints: BoxConstraints(minHeight: constraints.maxHeight),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Account",
                  style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w900),
                ),
                const SizedBox(height: 12),
                if (!signedIn) ...[
                  Text(
                    "Sign in to continue",
                    style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w900),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    "Your plan and data usage sync to your account.",
                    style: theme.textTheme.bodySmall?.copyWith(color: scheme.onSurfaceVariant),
                  ),
                  const SizedBox(height: 14),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: c.busy ? null : c.startLoginInBrowser,
                      child: const Text("Sign in"),
                    ),
                  ),
                ] else ...[
                  Text(
                    email.isEmpty ? "Signed in" : email,
                    style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w900),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    plan.isEmpty ? "Plan: unknown" : "Plan: $plan",
                    style: theme.textTheme.bodySmall?.copyWith(color: scheme.onSurfaceVariant),
                  ),
                  const SizedBox(height: 14),
                  usageRow(context, showWhenDisconnected: true),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: c.busy
                              ? null
                              : () async {
                            await c.refreshMe();
                            await c.fetchUsage(showSync: true);
                          },
                          child: const Text("Refresh"),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: c.busy ? null : c.signOut,
                          child: const Text("Sign out"),
                        ),
                      ),
                    ],
                  ),
                ],
                const Spacer(),
                SafeArea(
                  top: false,
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Text(
                        "Secured by VX-Link",
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: scheme.onSurfaceVariant.withOpacity(0.55),
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.2,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}