import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../translations/app_localizations.dart';
class HowThisAppWorksScreen extends StatelessWidget {
  const HowThisAppWorksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final text = theme.textTheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context)!.settingsHowThisAppWorks,
          style: text.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: text.bodyLarge?.color,
          ),
        ),
        backgroundColor: theme.appBarTheme.backgroundColor,
        centerTitle: true,
      ),
      backgroundColor: theme.scaffoldBackgroundColor,
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: ListView(
          physics: const BouncingScrollPhysics(),
          children: [
            Text(
              AppLocalizations.of(context)!.howThisAppWorksHowAvarionXWorks,
              style: text.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.primary,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              AppLocalizations.of(context)!.howThisAppWorksAvarionxIsAMobileSecurityAppThat +
                  AppLocalizations.of(context)!.howThisAppWorksTheAntivirusEngineIsPoweredByVX,
              style: text.bodyMedium,
            ),
            const SizedBox(height: 12),
            Text(
              AppLocalizations.of(context)!.howThisAppWorksIfYouUseNetworkProtectionOrVPN,
              style: text.bodyMedium,
            ),
            const SizedBox(height: 20),
            Text(
              AppLocalizations.of(context)!.howThisAppWorksKeyFeatures,
              style: text.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
             Text(AppLocalizations.of(context)!.howThisAppWorksRealTimeProtectionForDownloadedThreats),
             Text(AppLocalizations.of(context)!.howThisAppWorksNetworkProtectionWithDNSFiltering),
             Text(AppLocalizations.of(context)!.howThisAppWorksOptionalSecureVPNMode),
             Text(AppLocalizations.of(context)!.howThisAppWorksBuiltInToolsSuchAsLinkChecker),
            const SizedBox(height: 20),
            Text(
              AppLocalizations.of(context)!.howThisAppWorksNotes,
              style: text.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              AppLocalizations.of(context)!.howThisAppWorksSomeFeaturesMayRequireSignInAn,
              style: text.bodyMedium,
            ),
            const SizedBox(height: 12),
            Center(
              child: SvgPicture.asset(
                'assets/illustrations/thumbs_up_stickman.svg',
                width: 84,
                height: 84,
              ),
            ),
          ],
        ),
      ),
    );
  }
}