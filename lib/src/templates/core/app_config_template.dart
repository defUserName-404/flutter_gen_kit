const String appConfigTemplate = r'''
import 'package:flutter/services.dart' show rootBundle;
import 'dart:convert';

class AppConfig {
  static late Map<String, dynamic> _config;

  static String get appName => _config['appName'] as String;
  static String get baseUrl => _config['baseUrl'] as String;
  // Add other configurations as needed

  static Future<void> load() async {
    final configString = await rootBundle.loadString('assets/config/app_config.json');
    _config = json.decode(configString) as Map<String, dynamic>;
  }
}
''';

/// Enhanced AppConfig template with flutter_dotenv support
const String appConfigWithEnvTemplate = r'''
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:convert';

class AppConfig {
  static late Map<String, dynamic> _config;

  // Singleton
  static final AppConfig _instance = AppConfig._internal();
  factory AppConfig() => _instance;
  AppConfig._internal();

  // JSON-based config (from assets/config/app_config.json)
  static String get appName => _config['appName'] as String;
  static String get baseUrl => _config['baseUrl'] as String;

  // Environment-based config (from .env)
  String get apiBaseUrl => dotenv.get('API_BASE_URL', fallback: baseUrl);
  int get apiTimeout => int.parse(dotenv.get('API_TIMEOUT', fallback: '30'));
  String? get apiKey => dotenv.maybeGet('API_KEY');

  String get environment => dotenv.get('ENVIRONMENT', fallback: 'development');

  // Feature Flags
  bool get enableAnalytics => dotenv.get('ENABLE_ANALYTICS', fallback: 'false') == 'true';
  bool get enableCrashReporting => dotenv.get('ENABLE_CRASH_REPORTING', fallback: 'false') == 'true';
  bool get enableLogging => dotenv.get('ENABLE_LOGGING', fallback: 'true') == 'true';

  // Helpers
  bool get isDevelopment => environment == 'development';
  bool get isStaging => environment == 'staging';
  bool get isProduction => environment == 'production';

  static Future<void> load() async {
    final configString = await rootBundle.loadString('assets/config/app_config.json');
    _config = json.decode(configString) as Map<String, dynamic>;
  }
}
''';
