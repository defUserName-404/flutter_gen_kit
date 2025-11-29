import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:flutter_gen_kit/src/models/gen_kit_config.dart';
import 'package:flutter_gen_kit/src/templates/core/api_client_template.dart';
import 'package:flutter_gen_kit/src/templates/core/app_colors_template.dart';
import 'package:flutter_gen_kit/src/templates/core/app_config_template.dart';
import 'package:flutter_gen_kit/src/templates/core/app_exceptions_template.dart';
import 'package:flutter_gen_kit/src/templates/core/app_logger_template.dart';
import 'package:flutter_gen_kit/src/templates/core/app_providers_template.dart';
import 'package:flutter_gen_kit/src/templates/core/app_router_template.dart';
import 'package:flutter_gen_kit/src/templates/core/app_template.dart';
import 'package:flutter_gen_kit/src/templates/core/app_theme_template.dart';
import 'package:flutter_gen_kit/src/templates/core/app_typography_template.dart';
import 'package:flutter_gen_kit/src/templates/core/base_viewmodel_template.dart';
import 'package:flutter_gen_kit/src/templates/core/common_constants_template.dart';
import 'package:flutter_gen_kit/src/templates/core/common_loading_indicator_template.dart';
import 'package:flutter_gen_kit/src/templates/core/l10n_en_arb_template.dart';
import 'package:flutter_gen_kit/src/templates/core/l10n_template.dart';
import 'package:flutter_gen_kit/src/templates/core/main_template.dart';
import 'package:flutter_gen_kit/src/templates/core/network_info_template.dart';
import 'package:flutter_gen_kit/src/templates/core/pubspec_template.dart';
import 'package:flutter_gen_kit/src/templates/core/service_locator_template.dart';
import 'package:flutter_gen_kit/src/templates/features/clean_architecture/data/dto_template.dart';
import 'package:flutter_gen_kit/src/templates/features/clean_architecture/data/local_datasource_template.dart';
import 'package:flutter_gen_kit/src/templates/features/clean_architecture/data/remote_datasource_template.dart';
import 'package:flutter_gen_kit/src/templates/features/clean_architecture/data/repository_impl_template.dart';
import 'package:flutter_gen_kit/src/templates/features/clean_architecture/domain/entity_template.dart';
import 'package:flutter_gen_kit/src/templates/features/clean_architecture/domain/repository_template.dart';
import 'package:flutter_gen_kit/src/templates/features/clean_architecture/domain/usecase_template.dart';
import 'package:flutter_gen_kit/src/templates/features/clean_architecture/presentation/screen_template.dart';
import 'package:flutter_gen_kit/src/templates/features/clean_architecture/presentation/viewmodel_template.dart';
import 'package:flutter_gen_kit/src/templates/features/mvvm/model_template.dart';
import 'package:flutter_gen_kit/src/templates/features/mvvm/repository_template.dart';
import 'package:flutter_gen_kit/src/templates/features/mvvm/screen_template.dart';
import 'package:flutter_gen_kit/src/templates/features/mvvm/viewmodel_template.dart';
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
      await ShellUtils.runCommand('flutter', [
        'pub',
        'add',
        'flutter_riverpod',
      ]);
    } else if (config.stateManagement == StateManagement.bloc) {
      await ShellUtils.runCommand('flutter', ['pub', 'add', 'flutter_bloc']);
    } else {
      await ShellUtils.runCommand('flutter', ['pub', 'add', 'provider']);
    }

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

    // TODO: Add support for other architectures
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
    await FileUtils.writeFile(
      'pubspec.yaml',
      pubspecTemplate.replaceAll('__project_name__', projectName),
    );
    await FileUtils.writeFile('lib/main.dart', mainDartTemplate);
    await FileUtils.writeFile('lib/core/app.dart', coreAppTemplate);
    await FileUtils.writeFile(
      'lib/core/app_providers.dart',
      appProvidersTemplate,
    );
    await FileUtils.writeFile(
      'lib/core/service_locator.dart',
      serviceLocatorTemplate,
    );
    await FileUtils.writeFile(
      'lib/core/config/app_config.dart',
      appConfigTemplate,
    );
    await FileUtils.writeFile(
      'lib/core/router/app_router.dart',
      appRouterTemplate,
    );
    await FileUtils.writeFile(
      'lib/core/theme/app_theme.dart',
      appThemeTemplate,
    );
    await FileUtils.writeFile(
      'lib/core/theme/app_colors.dart',
      appColorsTemplate,
    );
    await FileUtils.writeFile(
      'lib/core/theme/app_typography.dart',
      appTypographyTemplate,
    );
    await FileUtils.writeFile(
      'lib/core/network/api_client.dart',
      apiClientTemplate,
    );
    await FileUtils.writeFile(
      'lib/core/network/network_info.dart',
      networkInfoTemplate,
    );
    await FileUtils.writeFile(
      'lib/core/logger/app_logger.dart',
      appLoggerTemplate,
    );
    await FileUtils.writeFile(
      'lib/common/data/exceptions/app_exceptions.dart',
      appExceptionsTemplate,
    );
    await FileUtils.writeFile(
      'lib/core/base/base_viewmodel.dart',
      baseViewModelTemplate,
    );
    await FileUtils.writeFile(
      'lib/common/utils/constants.dart',
      commonConstantsTemplate,
    );
    await FileUtils.writeFile(
      'lib/common/widgets/loading_indicator.dart',
      commonLoadingIndicatorTemplate,
    );
    await FileUtils.writeFile('assets/l10n/app_en.arb', l10nEnArbTemplate);
    await FileUtils.writeFile('l10n.yaml', l10nYamlTemplate);

    // Sample Feature
    final featurePath = 'lib/features/$sampleFeatureDirectoryName';

    if (config.architecture == Architecture.mvvm) {
      await FileUtils.writeFile(
        '$featurePath/${PathConstants.mvvmModels}/${sampleFeatureDirectoryName}_model.dart',
        getSampleModelTemplate(config),
      );
      await FileUtils.writeFile(
        '$featurePath/${PathConstants.mvvmRepositories}/${sampleFeatureDirectoryName}_repository.dart',
        getSampleMVVMRepositoryTemplate(config),
      );
      await FileUtils.writeFile(
        '$featurePath/${PathConstants.mvvmViewModels}/${sampleFeatureDirectoryName}_viewmodel.dart',
        getSampleMVVMViewModelTemplate(config),
      );
      await FileUtils.writeFile(
        '$featurePath/${PathConstants.mvvmViews}/${sampleFeatureDirectoryName}_screen.dart',
        getSampleMVVMScreenTemplate(config),
      );
    } else {
      // Clean Architecture
      await FileUtils.writeFile(
        '$featurePath/${PathConstants.cleanDomainEntities}/${sampleFeatureDirectoryName}_entity.dart',
        getSampleEntityTemplate(config),
      );
      await FileUtils.writeFile(
        '$featurePath/${PathConstants.cleanDomainRepositories}/${sampleFeatureDirectoryName}_repository.dart',
        getSampleRepositoryTemplate(config),
      );
      await FileUtils.writeFile(
        '$featurePath/${PathConstants.cleanDomainUsecases}/get_${sampleFeatureDirectoryName}_data.dart',
        getGetSampleDataUseCaseTemplate(config),
      );
      await FileUtils.writeFile(
        '$featurePath/${PathConstants.cleanDataDto}/${sampleFeatureDirectoryName}_dto.dart',
        getSampleDtoTemplate(config),
      );
      await FileUtils.writeFile(
        '$featurePath/${PathConstants.cleanDataDatasources}/${sampleFeatureDirectoryName}_local_datasource.dart',
        getSampleLocalDataSourceTemplate(config),
      );
      await FileUtils.writeFile(
        '$featurePath/${PathConstants.cleanDataDatasources}/${sampleFeatureDirectoryName}_remote_datasource.dart',
        getSampleRemoteDataSourceTemplate(config),
      );
      await FileUtils.writeFile(
        '$featurePath/${PathConstants.cleanDataRepositories}/${sampleFeatureDirectoryName}_repository_impl.dart',
        getSampleRepositoryImplTemplate(config),
      );
      await FileUtils.writeFile(
        '$featurePath/${PathConstants.cleanPresentationViewModels}/${sampleFeatureDirectoryName}_viewmodel.dart',
        getSampleViewModelTemplate(config),
      );
      await FileUtils.writeFile(
        '$featurePath/${PathConstants.cleanPresentationScreens}/${sampleFeatureDirectoryName}_screen.dart',
        getSampleScreenTemplate(config),
      );
    }
  }
}
