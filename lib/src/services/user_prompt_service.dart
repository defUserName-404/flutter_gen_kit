import 'package:flutter_gen_kit/src/models/gen_kit_config.dart';
import 'package:flutter_gen_kit/src/models/platform_config.dart';
import 'package:interact_cli/interact_cli.dart';

/// Centralized service for all user prompts using interact_cli.
/// This makes the code more maintainable and provides a consistent UX.
class UserPromptService {
  /// Prompt user to select target platforms.
  static PlatformConfig promptPlatforms() {
    final selection = MultiSelect(
      prompt:
          'Select target platforms [Space to select/unselect, Enter to confirm]',
      options: ['Android', 'iOS', 'Web', 'Windows', 'macOS', 'Linux'],
      defaults: [
        true,
        true,
        true,
        true,
        true,
        true,
      ], // All platforms by default
    ).interact();

    // Map selections to platform names
    final platformMap = {
      0: 'android',
      1: 'ios',
      2: 'web',
      3: 'windows',
      4: 'macos',
      5: 'linux',
    };

    // If all platforms selected, return empty list (default behavior)
    if (selection.length == 6) {
      return PlatformConfig.all();
    }

    final platforms = selection.map((index) => platformMap[index]!).toList();

    return PlatformConfig(platforms: platforms);
  }

  /// Prompt user to select architecture.
  static Architecture promptArchitecture() {
    final selection = Select(
      prompt: 'Select architecture',
      options: ['Clean Architecture', 'MVVM'],
      initialIndex: 0,
    ).interact();

    return selection == 0 ? Architecture.clean : Architecture.mvvm;
  }

  /// Prompt user to select state management solution.
  static StateManagement promptStateManagement() {
    final selection = Select(
      prompt: 'Select state management',
      options: ['Provider', 'Riverpod', 'Bloc'],
      initialIndex: 0,
    ).interact();

    switch (selection) {
      case 1:
        return StateManagement.riverpod;
      case 2:
        return StateManagement.bloc;
      default:
        return StateManagement.provider;
    }
  }

  /// Prompt user for native splash configuration.
  /// Returns null if user declines.
  static NativeSplashConfig? promptNativeSplash() {
    final wantsSplash = Confirm(
      prompt: 'Add flutter_native_splash?',
      defaultValue: false,
    ).interact();

    if (!wantsSplash) return null;

    final color = Input(
      prompt: 'Enter background color (hex, e.g., #ffffff)',
      validator: (value) {
        if (value.isEmpty) return false;
        if (!value.startsWith('#')) return false;
        return true;
      },
    ).interact();

    final imagePath = Input(
      prompt: 'Enter splash image path (optional, press enter to skip)',
      defaultValue: '',
    ).interact();

    return NativeSplashConfig(
      color: color,
      imagePath: imagePath.isEmpty ? null : imagePath,
    );
  }

  /// Prompt user for launcher icons configuration.
  /// Returns null if user declines.
  static String? promptLauncherIcons() {
    final wantsIcons = Confirm(
      prompt: 'Add flutter_launcher_icons?',
      defaultValue: false,
    ).interact();

    if (!wantsIcons) return null;

    final imagePath = Input(
      prompt: 'Enter icon image path',
      validator: (value) {
        if (value.isEmpty) return false;
        return true;
      },
    ).interact();

    return imagePath;
  }

  /// Prompt user for package name change.
  /// Returns null if user declines.
  static String? promptPackageName() {
    final wantsChange = Confirm(
      prompt: 'Change app package name?',
      defaultValue: false,
    ).interact();

    if (!wantsChange) return null;

    final packageName = Input(
      prompt: 'Enter new package name (e.g., com.example.app)',
      validator: (value) {
        if (value.isEmpty) return false;
        if (!value.contains('.')) return false;
        return true;
      },
    ).interact();

    return packageName;
  }
}

/// Configuration for native splash screen.
class NativeSplashConfig {
  final String color;
  final String? imagePath;

  const NativeSplashConfig({required this.color, this.imagePath});
}

/// Configuration options for feature generation.
class FeatureGenerationOptions {
  final bool generateTests;
  final bool skipBuildRunner;
  final bool addToRouter;
  final bool generateApiEndpoints;
  final bool registerInDI;
  final bool generateSampleData;

  const FeatureGenerationOptions({
    this.generateTests = false,
    this.skipBuildRunner = false,
    this.addToRouter = true, // Default true - most common
    this.generateApiEndpoints = false,
    this.registerInDI = true, // Default true - most common
    this.generateSampleData = false,
  });

  /// Default options for non-interactive mode.
  factory FeatureGenerationOptions.defaults() {
    return const FeatureGenerationOptions(
      addToRouter: true,
      registerInDI: true,
      skipBuildRunner: false,
    );
  }

  /// Prompt user for feature generation options interactively.
  static FeatureGenerationOptions prompt() {
    final generateTests = Confirm(
      prompt: 'Generate test files?',
      defaultValue: false,
    ).interact();

    final skipBuildRunner = Confirm(
      prompt: 'Skip build_runner? (useful for batch generation)',
      defaultValue: false,
    ).interact();

    final addToRouter = Confirm(
      prompt: 'Add route to app router?',
      defaultValue: true,
    ).interact();

    final generateApiEndpoints = Confirm(
      prompt: 'Generate API endpoint constants?',
      defaultValue: false,
    ).interact();

    final registerInDI = Confirm(
      prompt: 'Register in dependency injection?',
      defaultValue: true,
    ).interact();

    final generateSampleData = Confirm(
      prompt: 'Generate sample/mock data?',
      defaultValue: false,
    ).interact();

    return FeatureGenerationOptions(
      generateTests: generateTests,
      skipBuildRunner: skipBuildRunner,
      addToRouter: addToRouter,
      generateApiEndpoints: generateApiEndpoints,
      registerInDI: registerInDI,
      generateSampleData: generateSampleData,
    );
  }
}

/// Configuration for environment variable setup.
class EnvSetupConfig {
  final String apiBaseUrl;
  final String appName;

  const EnvSetupConfig({
    required this.apiBaseUrl,
    required this.appName,
  });

  /// Prompt user for environment variable setup.
  static EnvSetupConfig? prompt(String projectName) {
    final wantsEnv = Confirm(
      prompt: 'Setup environment variables?',
      defaultValue: true,
    ).interact();

    if (!wantsEnv) return null;

    final apiBaseUrl = Input(
      prompt: 'Enter API base URL',
      defaultValue: 'https://api.example.com',
      validator: (value) {
        if (value.isEmpty) return false;
        return true;
      },
    ).interact();

    final appName = Input(
      prompt: 'Enter app name',
      defaultValue: projectName,
    ).interact();

    return EnvSetupConfig(
      apiBaseUrl: apiBaseUrl,
      appName: appName,
    );
  }
}
