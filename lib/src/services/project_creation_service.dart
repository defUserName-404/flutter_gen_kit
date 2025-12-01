import 'dart:io';

import 'package:flutter_gen_kit/src/models/gen_kit_config.dart';
import 'package:flutter_gen_kit/src/models/platform_config.dart';

import 'package:flutter_gen_kit/src/services/mason_service.dart';
import 'package:flutter_gen_kit/src/utils/constants/path_constants.dart';
import 'package:flutter_gen_kit/src/utils/file_utils.dart';
import 'package:flutter_gen_kit/src/utils/shell_utils.dart';

/// Service for creating and setting up Flutter projects.
class ProjectCreationService {
  static const String sampleFeatureDirectoryName = 'sample_feature';

  /// Create a new Flutter project with specified platforms.
  static Future<void> createFlutterProject(
    String projectName,
    PlatformConfig platformConfig,
  ) async {
    final createArgs = ['create'];

    // Add platform-specific flags if user selected specific platforms
    final platformArg = platformConfig.toFlutterCreateArg();
    if (platformArg != null) {
      createArgs.add(platformArg);
    }

    createArgs.add(projectName);

    await ShellUtils.runCommand('flutter', createArgs);
    print('Flutter project "$projectName" created.');

    // Change directory to the newly created project
    Directory.current = projectName;
  }

  /// Apply architectural setup (directories and templates).
  static Future<void> setupArchitecture(
    String projectName,
    GenKitConfig config,
  ) async {
    print(
      'Applying ${config.architecture.name} setup with ${config.stateManagement.name}...',
    );

    // Core directories (Shared)
    await FileUtils.createDirectories(PathConstants.coreDirectories);

    // Write core templates using mason
    print('Generating core files...');
    final masonService = MasonService(config);
    await masonService.generateCore(
      projectName: projectName,
      targetPath: '.',
    );

    // Generate sample feature using mason
    print('Generating sample feature...');
    await masonService.generateFeature(
      featureName: sampleFeatureDirectoryName,
      targetPath: 'lib/features/$sampleFeatureDirectoryName',
    );
  }

  /// Install dependencies based on configuration.
  static Future<void> installDependencies(GenKitConfig config) async {
    print('Running flutter pub get...');

    // Add dependencies based on config
    if (config.stateManagement == StateManagement.riverpod) {
      await ShellUtils.runCommand('flutter', ['pub', 'add', 'riverpod']);
    } else if (config.stateManagement == StateManagement.bloc) {
      await ShellUtils.runCommand('flutter', ['pub', 'add', 'flutter_bloc']);
    } else {
      await ShellUtils.runCommand('flutter', ['pub', 'add', 'provider']);
    }

    // Add dart_mappable dependencies
    await ShellUtils.runCommand('flutter', ['pub', 'add', 'dart_mappable']);
    await ShellUtils.runCommand('flutter', ['pub', 'add', 'dev:build_runner']);
    await ShellUtils.runCommand('flutter', [
      'pub',
      'add',
      'dev:dart_mappable_builder',
    ]);

    await ShellUtils.runCommand('flutter', ['pub', 'get']);
    print('Generating localization files...');
    await ShellUtils.runCommand('flutter', ['gen-l10n']);
  }
}
