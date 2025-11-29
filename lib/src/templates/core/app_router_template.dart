import '../../models/architecture_config.dart';
import '../../models/gen_kit_config.dart';

String getAppRouterTemplate(GenKitConfig config) {
  final archConfig = ArchitectureConfig.fromGenKitConfig(config);
  final screenPath = archConfig.getScreenImportPath('sample_feature');

  return '''
import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';

import '$screenPath'; // Example

class AppRouter {
  static final GoRouter router = GoRouter(
    routes: <RouteBase>[
      GoRoute(
        path: '/',
        builder: (BuildContext context, GoRouterState state) {
          return const SampleScreen(); // Initial screen
        },
      ),
      // Add more routes here for features
      GoRoute(
        path: '/sample',
        builder: (BuildContext context, GoRouterState state) {
          return const SampleScreen();
        },
      ),
    ],
    // Redirect logic, error handling etc.
    // errorBuilder: (context, state) => const ErrorScreen(), // You would define an ErrorScreen
  );
}
''';
}
