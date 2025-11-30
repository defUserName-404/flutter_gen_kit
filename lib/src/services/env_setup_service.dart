import 'dart:io';

import 'package:flutter_gen_kit/src/templates/core/app_config_template.dart';

/// Service for setting up environment variables in Flutter projects.
class EnvSetupService {
  /// Setup environment variables with user-provided configuration.
  static Future<void> setupEnvironment({
    required String apiBaseUrl,
    required String appName,
  }) async {
    print('Setting up environment variables...');

    // Create .env.example
    await _createFile('.env.example', _getEnvExampleContent(apiBaseUrl, appName));

    // Create .env
    await _createFile('.env', _getEnvContent(apiBaseUrl, appName));

    // Create environment-specific files
    await _createFile('.env.dev', _getEnvDevContent(apiBaseUrl, appName));
    await _createFile('.env.staging', _getEnvStagingContent(apiBaseUrl, appName));
    await _createFile('.env.prod', _getEnvProdContent(apiBaseUrl, appName));

    // Create AppConfig class
    await _createFile('lib/core/config/app_config.dart', _getAppConfigContent());

    // Update .gitignore
    await _updateGitignore();

    print('Environment variables configured successfully!');
    print('\n📝 Next steps:');
    print('  1. Update .env with your actual API keys');
    print('  2. Never commit .env to version control');
    print('  3. Use AppConfig() to access configuration in your app');
  }

  static Future<void> _createFile(String path, String content) async {
    final file = File(path);
    await file.parent.create(recursive: true);
    await file.writeAsString(content);
  }

  static Future<void> _updateGitignore() async {
    final gitignoreFile = File('.gitignore');
    
    if (!await gitignoreFile.exists()) {
      await gitignoreFile.writeAsString('');
    }

    final content = await gitignoreFile.readAsString();
    
    // Check if env files are already in gitignore
    if (!content.contains('.env')) {
      final envIgnore = '''

# Environment files
.env
.env.local
''';
      await gitignoreFile.writeAsString(content + envIgnore);
    }
  }

  static String _getEnvExampleContent(String apiBaseUrl, String appName) {
    return '''
# API Configuration
API_BASE_URL=$apiBaseUrl
API_TIMEOUT=30
API_KEY=your_api_key_here

# App Configuration
APP_NAME=$appName
ENVIRONMENT=development

# Feature Flags
ENABLE_ANALYTICS=false
ENABLE_CRASH_REPORTING=false
ENABLE_LOGGING=true

# Third-Party Services (Optional)
# FIREBASE_API_KEY=
# SENTRY_DSN=
# GOOGLE_MAPS_API_KEY=
''';
  }

  static String _getEnvContent(String apiBaseUrl, String appName) {
    return '''
# API Configuration
API_BASE_URL=$apiBaseUrl
API_TIMEOUT=30
API_KEY=

# App Configuration
APP_NAME=$appName
ENVIRONMENT=development

# Feature Flags
ENABLE_ANALYTICS=false
ENABLE_CRASH_REPORTING=false
ENABLE_LOGGING=true

# Third-Party Services (Optional)
# FIREBASE_API_KEY=
# SENTRY_DSN=
# GOOGLE_MAPS_API_KEY=
''';
  }

  static String _getEnvDevContent(String apiBaseUrl, String appName) {
    return '''
# Development Environment
API_BASE_URL=$apiBaseUrl/dev
API_TIMEOUT=30
APP_NAME=$appName (Dev)
ENVIRONMENT=development
ENABLE_LOGGING=true
''';
  }

  static String _getEnvStagingContent(String apiBaseUrl, String appName) {
    return '''
# Staging Environment
API_BASE_URL=$apiBaseUrl/staging
API_TIMEOUT=30
APP_NAME=$appName (Staging)
ENVIRONMENT=staging
ENABLE_ANALYTICS=true
ENABLE_LOGGING=true
''';
  }

  static String _getEnvProdContent(String apiBaseUrl, String appName) {
    return '''
# Production Environment
API_BASE_URL=$apiBaseUrl
API_TIMEOUT=30
APP_NAME=$appName
ENVIRONMENT=production
ENABLE_ANALYTICS=true
ENABLE_CRASH_REPORTING=true
ENABLE_LOGGING=false
''';
  }

  static String _getAppConfigContent() {
    // Use the enhanced template from app_config_template.dart
    return appConfigWithEnvTemplate;
  }
}
