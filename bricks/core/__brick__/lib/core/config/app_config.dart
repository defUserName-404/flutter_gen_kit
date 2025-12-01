import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppConfig {
  static String get appName => dotenv.env['APP_NAME'] ?? '{{project_name}}';
  static String get apiBaseUrl => dotenv.env['API_BASE_URL'] ?? 'https://api.example.com';
  
  static Future<void> load() async {
    await dotenv.load(fileName: ".env");
  }
}
