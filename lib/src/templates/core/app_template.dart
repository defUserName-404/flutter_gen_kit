const String coreAppTemplate = r'''
import 'package:flutter/material.dart';
import 'package:flutter_generated_app/core/router/app_router.dart';

import 'config/app_config.dart';
import 'localization/app_localizations.dart';

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: AppRouter.router,
      title: AppConfig.appName,
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light(),
      // Placeholder, will use actual theme
      darkTheme: ThemeData.dark(),
      // Placeholder, will use actual theme
      themeMode: ThemeMode.system,
      // Placeholder, will be managed by a ThemeProvider

      // Localization delegates
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
    );
  }
}
''';
