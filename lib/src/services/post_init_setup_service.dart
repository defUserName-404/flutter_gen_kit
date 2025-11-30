import 'dart:io';

import 'package:flutter_gen_kit/src/utils/shell_utils.dart';

/// Service for handling post-initialization setup tasks like
/// native splash, launcher icons, and package name changes.
class PostInitSetupService {
  /// Run all post-initialization setup tasks interactively.
  static Future<void> runAllSetups() async {
    await setupNativeSplash();
    await setupLauncherIcons();
    await setupPackageName();
  }

  /// Setup native splash screen with user-provided configuration.
  static Future<void> setupNativeSplash() async {
    print('\n--- Native Splash Screen Setup ---');
    stdout.write('Add flutter_native_splash? (y/N): ');
    final response = stdin.readLineSync()?.toLowerCase();
    if (response != 'y') return;

    stdout.write('Enter background color (hex, e.g., #ffffff): ');
    final color = stdin.readLineSync();
    if (color == null || color.isEmpty) {
      print('Skipping native splash setup (no color provided).');
      return;
    }

    stdout.write('Enter splash image path (optional, press enter to skip): ');
    final imagePath = stdin.readLineSync();

    await _ensureAssetsDirectory();

    bool hasImage = false;
    if (imagePath != null && imagePath.isNotEmpty) {
      hasImage = await _copyAsset(
        sourcePath: imagePath,
        destPath: 'assets/splash.png',
        assetName: 'splash image',
      );
    }

    await _addDevDependency('flutter_native_splash');

    await _appendToPubspec('''

flutter_native_splash:
  color: "$color"${hasImage ? '\n  image: assets/splash.png' : ''}''');

    print('Generating native splash screen...');
    await ShellUtils.runCommand('dart', [
      'run',
      'flutter_native_splash:create',
    ]);
  }

  /// Setup launcher icons with user-provided icon image.
  static Future<void> setupLauncherIcons() async {
    print('\n--- Launcher Icons Setup ---');
    stdout.write('Add flutter_launcher_icons? (y/N): ');
    final response = stdin.readLineSync()?.toLowerCase();
    if (response != 'y') return;

    stdout.write('Enter icon image path: ');
    final imagePath = stdin.readLineSync();
    if (imagePath == null || imagePath.isEmpty) {
      print('Skipping launcher icons setup (no image path provided).');
      return;
    }

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
    print('\n--- Package Name Setup ---');
    stdout.write('Change app package name? (y/N): ');
    final response = stdin.readLineSync()?.toLowerCase();
    if (response != 'y') return;

    stdout.write('Enter new package name (e.g., com.example.app): ');
    final packageName = stdin.readLineSync();
    if (packageName == null || packageName.isEmpty) {
      print('Skipping package name change (no name provided).');
      return;
    }

    await _addDevDependency('change_app_package_name');

    print('Changing package name to $packageName...');
    await ShellUtils.runCommand('dart', [
      'run',
      'change_app_package_name:main',
      packageName,
    ]);
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
}
