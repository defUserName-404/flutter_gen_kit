const String appRouterTemplate = r'''
import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';

import '../../features/sample_feature/presentation/screens/sample_screen.dart'; // Example

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
