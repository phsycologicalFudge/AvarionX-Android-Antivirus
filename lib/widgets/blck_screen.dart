import 'package:flutter/material.dart';

import '../translations/app_localizations.dart';
class BlockScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(child: Text(AppLocalizations.of(context)!.blockedScreenUnsupportedEnvironment)),
      ),
    );
  }
}
