import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../translations/app_localizations.dart';
class FeaturesScreen extends StatefulWidget {
  const FeaturesScreen({super.key});

  @override
  State<FeaturesScreen> createState() => _FeaturesScreenState();
}

class _FeaturesScreenState extends State<FeaturesScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _openDocs() async {
    final uri = Uri.parse('https://colourswift.com/docs');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  Widget _buildAnimatedFeature(
      {required int index,
        required String title,
        required String description,
        bool comingSoon = false}) {
    final animation = CurvedAnimation(
      parent: _controller,
      curve: Interval(index * 0.1, 1.0, curve: Curves.easeOutCubic),
    );

    return FadeTransition(
      opacity: animation,
      child: SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0, 0.15),
          end: Offset.zero,
        ).animate(animation),
        child: _featureTile(title, description, comingSoon: comingSoon),
      ),
    );
  }

  Widget _featureTile(String title, String description,
      {bool comingSoon = false}) {
    final theme = Theme.of(context);
    final text = theme.textTheme;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                title,
                style: text.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: text.bodyLarge?.color,
                ),
              ),
              if (comingSoon)
                Container(
                  margin: const EdgeInsets.only(left: 8),
                  padding:
                  const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade600,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child:  Text(
                    AppLocalizations.of(context)!.featuresComingSoon,
                    style: TextStyle(color: Colors.white, fontSize: 10),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            description,
            style: text.bodySmall?.copyWith(
              color: text.bodySmall?.color?.withOpacity(0.75),
              height: 1.4,
            ),
          ),
          Divider(
            color: theme.dividerColor.withOpacity(0.2),
            height: 24,
            thickness: 1,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final text = theme.textTheme;

    final features = [
      {
        'title': AppLocalizations.of(context)!.rtpInfoTitle,
        'desc':
        AppLocalizations.of(context)!.featuresRealtimeProtectionBody,
      },
      {
        'title': AppLocalizations.of(context)!.featuresTriLayerEngineTitle,
        'desc':
        AppLocalizations.of(context)!.featuresTriLayerEngineBody,
      },
      {
        'title': AppLocalizations.of(context)!.featuresMachineLearningTitle,
        'desc':
        AppLocalizations.of(context)!.featuresMachineLearningBody,
      },
      {
        'title': AppLocalizations.of(context)!.featuresCleanerProTitle,
        'desc':
        AppLocalizations.of(context)!.featuresCleanerProBody,
      },
      {
        'title': AppLocalizations.of(context)!.featuresWifiProtectionTitle,
        'desc':
        AppLocalizations.of(context)!.featuresWifiProtectionBody,
        'soon': true,
      },
      {
        'title': AppLocalizations.of(context)!.featuresRootLevelProtectionTitle,
        'desc':
        AppLocalizations.of(context)!.featuresRootLevelProtectionBody,
        'soon': true,
      },
      {
        'title': AppLocalizations.of(context)!.featuresPcCompanionTitle,
        'desc':
        AppLocalizations.of(context)!.featuresPcCompanionBody,
        'soon': true,
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title:  Text(AppLocalizations.of(context)!.featuresDrawerTitle),
        centerTitle: true,
        elevation: 0,
        backgroundColor: theme.appBarTheme.backgroundColor,
      ),
      body: ListView.builder(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        itemCount: features.length + 1,
        itemBuilder: (context, index) {
          if (index < features.length) {
            final item = features[index];
            return _buildAnimatedFeature(
              index: index,
              title: item['title'] as String,
              description: item['desc'] as String,
              comingSoon: item['soon'] == true,
            );
          } else {
            return FadeTransition(
              opacity: CurvedAnimation(
                parent: _controller,
                curve: const Interval(0.8, 1.0, curve: Curves.easeIn),
              ),
              child: Padding(
                padding: const EdgeInsets.only(top: 16, bottom: 60),
                child: Center(
                  child: GestureDetector(
                    onTap: _openDocs,
                    child: Text(
                      AppLocalizations.of(context)!.featuresWantToLearnMore,
                      style: text.bodyMedium?.copyWith(
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.w600,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
