import 'package:flutter/material.dart';

import 'cleaner_lite_screen.dart';
import 'cleaner_pro_screen.dart';

import '../../translations/app_localizations.dart';
class CleanerScreen extends StatelessWidget {
  const CleanerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: theme.colorScheme.surface,
        appBar: AppBar(
          title:  Text(AppLocalizations.of(context)!.cleanerScreenCleaner),
          centerTitle: true,
          backgroundColor: theme.colorScheme.surface,
          surfaceTintColor: theme.colorScheme.surfaceTint,
          scrolledUnderElevation: 0,
          elevation: 0,
        ),
        body: SafeArea(
          child: Column(
            children: [
              Container(
                height: 44,
                margin: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surfaceContainerHigh,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: TabBar(
                  dividerColor: Colors.transparent,
                  indicatorSize: TabBarIndicatorSize.tab,
                  indicator: BoxDecoration(
                    color: theme.colorScheme.primary,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  labelColor: theme.colorScheme.onPrimary,
                  unselectedLabelColor: theme.colorScheme.onSurface.withOpacity(0.65),
                  labelStyle: theme.textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w800),
                  unselectedLabelStyle: theme.textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w700),
                  tabs: [
                    Tab(text: AppLocalizations.of(context)!.cleanerLiteTab),
                    Tab(text: AppLocalizations.of(context)!.cleanerProTab),
                  ],
                ),
              ),
              const Expanded(
                child: TabBarView(
                  physics: BouncingScrollPhysics(),
                  children: [
                    CleanerLitePane(),
                    CleanerProPane(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
