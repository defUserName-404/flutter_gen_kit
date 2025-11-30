import 'dart:io';

import 'package:flutter_gen_kit/src/services/env_setup_service.dart';
import 'package:flutter_gen_kit/src/services/user_prompt_service.dart';
import 'package:flutter_gen_kit/src/utils/shell_utils.dart';

/// Service for handling post-initialization setup tasks like
/// native splash, launcher icons, and package name changes.
class PostInitSetupService {
  /// Run all post-initialization setup tasks interactively.
  static Future<void> runAllSetups(String projectName) async {
    await setupNativeSplash();
    await setupLauncherIcons();
    await setupPackageName();
    await setupEnvironment(projectName);
  }

  /// Setup native splash screen with user-provided configuration.
  static Future<void> setupNativeSplash() async {
    final config = UserPromptService.promptNativeSplash();
    if (config == null) return;

    await _ensureAssetsDirectory();

    bool hasImage = false;
    if (config.imagePath != null) {
      hasImage = await _copyAsset(
        sourcePath: config.imagePath!,
        destPath: 'assets/splash.png',
        assetName: 'splash image',
      );
    }

    await _addDevDependency('flutter_native_splash');

    await _appendToPubspec('''

flutter_native_splash:
  color: "${config.color}"${hasImage ? '\n  image: assets/splash.png' : ''}''');

    print('Generating native splash screen...');
    await ShellUtils.runCommand('dart', [
      'run',
      'flutter_native_splash:create',
    ]);
  }

  /// Setup launcher icons with user-provided icon image.
  static Future<void> setupLauncherIcons() async {
    final imagePath = UserPromptService.promptLauncherIcons();
    if (imagePath == null) return;

    final sourceFile = File(imagePath);
    if (!await sourceFile.exists()) {
      print(
        'Error: File not found at $imagePath. Skipping launcher icons setup.',
      );
      return;
    }

    await _ensureAssetsDirectory();

    final copied = await _copyAsset(
      sourcePath: imagePath,
      destPath: 'assets/icon.png',
      assetName: 'icon',
    );

    if (!copied) return;

    await _addDevDependency('flutter_launcher_icons');

    await _appendToPubspec('''

flutter_launcher_icons:
  android: "launcher_icon"
  ios: true
  image_path: "assets/icon.png"''');

    print('Generating launcher icons...');
    await ShellUtils.runCommand('dart', ['run', 'flutter_launcher_icons']);
  }

  /// Setup package name change with user-provided package name.
  static Future<void> setupPackageName() async {
    final packageName = UserPromptService.promptPackageName();
    if (packageName == null) return;

    await _addDevDependency('change_app_package_name');

    print('Changing package name to $packageName...');
    await ShellUtils.runCommand('dart', [
      'run',
      'change_app_package_name:main',
      packageName,
    ]);
  }

  /// Setup environment variables with user-provided configuration.
  static Future<void> setupEnvironment(String projectName) async {
    final config = EnvSetupConfig.prompt(projectName);
    if (config == null) return;

    // Add flutter_dotenv dependency
    print('Adding flutter_dotenv to dependencies...');
    await ShellUtils.runCommand('flutter', ['pub', 'add', 'flutter_dotenv']);

    // Setup environment files and config
    await EnvSetupService.setupEnvironment(
      apiBaseUrl: config.apiBaseUrl,
      appName: config.appName,
    );

    // Update pubspec.yaml to include .env in assets
    await _addEnvToAssets();
  }

  // ========== Private Helper Methods ==========

  /// Ensure the assets directory exists, creating it if necessary.
  static Future<void> _ensureAssetsDirectory() async {
    final assetsDir = Directory('assets');
    if (!await assetsDir.exists()) {
      await assetsDir.create();
    }
  }

  /// Copy an asset file from source to destination.
  /// Returns true if successful, false otherwise.
  static Future<bool> _copyAsset({
    required String sourcePath,
    required String destPath,
    required String assetName,
  }) async {
    final sourceFile = File(sourcePath);
    if (!await sourceFile.exists()) {
      print('Warning: File not found at $sourcePath. Skipping $assetName.');
      return false;
    }

    final destFile = File(destPath);
    await sourceFile.copy(destFile.path);
    print('Copied $assetName to $destPath');
    return true;
  }

  /// Add a dev dependency using flutter pub add.
  static Future<void> _addDevDependency(String packageName) async {
    print('Adding $packageName to dev_dependencies...');
    await ShellUtils.runCommand('flutter', ['pub', 'add', 'dev:$packageName']);
  }

  /// Append content to pubspec.yaml file.
  static Future<void> _appendToPubspec(String content) async {
    final pubspecFile = File('pubspec.yaml');
    if (await pubspecFile.exists()) {
      final existingContent = await pubspecFile.readAsString();
      await pubspecFile.writeAsString(existingContent + content);
    }
  }

  /// Add .env file to pubspec.yaml assets.
  static Future<void> _addEnvToAssets() async {
    final pubspecFile = File('pubspec.yaml');
    if (!await pubspecFile.exists()) return;

    final content = await pubspecFile.readAsString();
    
    // Check if .env is already in assets
    if (content.contains('.env')) return;

    // Add .env to assets section
    final envAsset = '\n    - .env';
    await pubspecFile.writeAsString(content + envAsset);
  }
}
