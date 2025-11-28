// pubspec_template.dart
const String pubspecTemplate = r'''
name: __project_name__
description: A new Flutter project generated with gen_kit.

publish_to: 'none'

version: 1.0.0+1

environment:
  sdk: '>=3.0.0 <4.0.0' # Adjust based on current stable Flutter SDK

dependencies:
  flutter:
    sdk: flutter

  # State Management
  provider: ^6.0.5 # Or latest stable version

  # Dependency Injection
  get_it: ^7.2.0 # Or latest stable version

  # Routing
  go_router: ^12.0.0 # Or latest stable version

  # API & Networking
  dio: ^5.0.0 # Or latest stable version
  internet_connection_checker_plus: ^2.0.0 # Or latest stable version

  # Logging
  logger: ^2.0.0 # Or latest stable version

  # Localization
  flutter_localizations:
    sdk: flutter
  intl: ^0.20.2 # Or latest stable version

  # Utility/Functional Programming
  dartz: ^0.10.1 # For functional error handling (Either, Left, Right)

dev_dependencies:
  flutter_test:
    sdk: flutter

  flutter_lints: ^2.0.0
  
  # Code generation for localization
  intl_translation: ^0.21.0 # For generating ARB files

flutter:
  uses-material-design: true

  # Enable generation of localized Strings from arb files.
  generate: true

  assets:
    - assets/l10n/ # Folder for localization files

# Localization configuration
localization:
  arb-dir: assets/l10n
  output-class: S
  output-localization-file: l10n.dart
  synthetic-package: generated_l10n
''';
