import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:flutter_gen_kit/src/models/gen_kit_config.dart';
import 'package:flutter_gen_kit/src/services/file_generator.dart';
import 'package:flutter_gen_kit/src/utils/constants/path_constants.dart';
import 'package:flutter_gen_kit/src/utils/file_utils.dart';
import 'package:flutter_gen_kit/src/utils/shell_utils.dart';

class InitCommand extends Command<void> {
  @override
  final name = 'init';
  @override
  final description =
      'Initializes a new Flutter project with Clean Architecture and other best practices.';

  static const String sampleFeatureDirectoryName = 'sample_feature';

  InitCommand() {
    argParser.addOption(
      'name',
      abbr: 'n',
      help: 'The name of the Flutter project to create.',
      mandatory: true,
    );
  }

  @override
  Future<void> run() async {
    final projectName = argResults!['name'] as String;

    print('Initializing new Flutter project: $projectName...');

    // Interactive prompts
    print('\nSelect Architecture:');
    print('[1] Clean Architecture (default)');
    print('[2] MVVM');
    stdout.write('Enter choice [1]: ');
    final archInput = stdin.readLineSync();
    final architecture = archInput == '2'
        ? Architecture.mvvm
        : Architecture.clean;

    print('\nSelect State Management:');
    print('[1] Provider (default)');
    print('[2] Riverpod');
    print('[3] Bloc');
    stdout.write('Enter choice [1]: ');
    final stateInput = stdin.readLineSync();
    StateManagement stateManagement;
    switch (stateInput) {
      case '2':
        stateManagement = StateManagement.riverpod;
        break;
      case '3':
        stateManagement = StateManagement.bloc;
        break;
      default:
        stateManagement = StateManagement.provider;
    }

    final config = GenKitConfig(
      architecture: architecture,
      stateManagement: stateManagement,
    );

    // 1. Create a new Flutter project
    await ShellUtils.runCommand('flutter', ['create', projectName]);
    print('Flutter project "$projectName" created.');

    // Change directory to the newly created project
    Directory.current = projectName;

    // Save config
    await config.save();
    print('Configuration saved to gen_kit.yaml');

    // 2. Apply architectural setup
    print(
      'Applying ${architecture.name} setup with ${stateManagement.name}...',
    );
    await _applyArchitecture(projectName, config);

    // 3. Run flutter pub get and gen-l10n
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

    print('Project "$projectName" initialized successfully!');
  }

  Future<void> _applyArchitecture(
    String projectName,
    GenKitConfig config,
  ) async {
    // Core directories (Shared)
    await FileUtils.createDirectories(PathConstants.coreDirectories);

    // Architecture specific directories
    // MVVM
    if (config.architecture == Architecture.mvvm) {
      await FileUtils.createDirectories(
        PathConstants.mvvmFeatureDirectories
            .map((path) => 'lib/features/$sampleFeatureDirectoryName/$path')
            .toList(),
      );
    } else {
      // Clean Architecture
      await FileUtils.createDirectories(
        PathConstants.cleanFeatureDirectories
            .map((path) => 'lib/features/$sampleFeatureDirectoryName/$path')
            .toList(),
      );
    }

    // Write templates (Shared)
    final coreFiles = FileGenerator.generateCoreFiles(projectName, config);
    for (final entry in coreFiles.entries) {
      await FileUtils.writeFile(entry.key, entry.value);
    }

    // Sample Feature
    final featureFiles = FileGenerator.generateFeatureFiles(
      sampleFeatureDirectoryName,
      config,
    );
    for (final entry in featureFiles.entries) {
      await FileUtils.writeFile(entry.key, entry.value);
    }
  }
}
