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
