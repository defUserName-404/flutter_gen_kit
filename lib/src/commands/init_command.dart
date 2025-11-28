import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:gen_kit/src/templates/core_templates.dart';
import 'package:gen_kit/src/templates/feature_templates.dart';
import 'package:gen_kit/src/templates/pubspec_template.dart';
import 'package:gen_kit/src/utils/file_utils.dart';
import 'package:gen_kit/src/utils/shell_utils.dart';

class InitCommand extends Command<void> {
  @override
  final name = 'init';
  @override
  final description = 'Initializes a new Flutter project with Clean Architecture and other best practices.';

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

    // 1. Create a new Flutter project
    await ShellUtils.runCommand('flutter', ['create', projectName]);
    print('Flutter project "$projectName" created.');

    // Change directory to the newly created project
    Directory.current = projectName;

    // 2. Apply architectural setup
    print('Applying Clean Architecture setup...');
    await _applyArchitecture(projectName);

    // 3. Run flutter pub get and gen-l10n
    print('Running flutter pub get...');
    await ShellUtils.runCommand('flutter', ['pub', 'get']);
    print('Generating localization files...');
    await ShellUtils.runCommand('flutter', ['gen-l10n']);

    print('Project "$projectName" initialized successfully!');
  }

  Future<void> _applyArchitecture(String projectName) async {
    // Create core directories
    await FileUtils.createDirectories([
      'lib/core/config',
      'lib/core/network',
      'lib/core/router',
      'lib/core/theme',
      'lib/core/logger',
      'lib/core/base',
      'lib/common/data/exceptions',
      'lib/common/data/remote',
      'lib/common/utils',
      'lib/common/widgets',
      'lib/features/$sampleFeatureDirectoryName/data/datasources',
      'lib/features/$sampleFeatureDirectoryName/data/dto',
      'lib/features/$sampleFeatureDirectoryName/data/repositories',
      'lib/features/$sampleFeatureDirectoryName/domain/entities',
      'lib/features/$sampleFeatureDirectoryName/domain/repositories',
      'lib/features/$sampleFeatureDirectoryName/domain/usecases',
      'lib/features/$sampleFeatureDirectoryName/presentation/screens',
      'lib/features/$sampleFeatureDirectoryName/presentation/viewmodels',
      'assets/l10n',
      'assets/config',
    ]);

    // Write templates
    await FileUtils.writeFile('pubspec.yaml', pubspecTemplate.replaceAll('__project_name__', projectName));
    await FileUtils.writeFile('lib/main.dart', mainDartTemplate);
    await FileUtils.writeFile('lib/core/app.dart', coreAppTemplate);
    await FileUtils.writeFile('lib/core/app_providers.dart', appProvidersTemplate);
    await FileUtils.writeFile('lib/core/service_locator.dart', serviceLocatorTemplate);
    await FileUtils.writeFile('lib/core/config/app_config.dart', appConfigTemplate);
    await FileUtils.writeFile('lib/core/router/app_router.dart', appRouterTemplate);
    await FileUtils.writeFile('lib/core/theme/app_theme.dart', appThemeTemplate);
    await FileUtils.writeFile('lib/core/theme/app_colors.dart', appColorsTemplate);
    await FileUtils.writeFile('lib/core/theme/app_typography.dart', appTypographyTemplate);
    await FileUtils.writeFile('lib/core/network/api_client.dart', apiClientTemplate);
    await FileUtils.writeFile('lib/core/network/network_info.dart', networkInfoTemplate);
    await FileUtils.writeFile('lib/core/logger/app_logger.dart', appLoggerTemplate);
    await FileUtils.writeFile('lib/common/data/exceptions/app_exceptions.dart', appExceptionsTemplate);
    await FileUtils.writeFile('lib/core/base/base_viewmodel.dart', baseViewModelTemplate);
    await FileUtils.writeFile('lib/common/utils/constants.dart', commonConstantsTemplate);
    await FileUtils.writeFile('lib/common/widgets/loading_indicator.dart', commonLoadingIndicatorTemplate);
    await FileUtils.writeFile('assets/l10n/app_en.arb', l10nEnArbTemplate);

    // Sample Feature
    final featurePath = 'lib/features/$sampleFeatureDirectoryName';
    await FileUtils.writeFile('$featurePath/domain/entities/${sampleFeatureDirectoryName}_entity.dart', sampleEntityTemplate);
    await FileUtils.writeFile('$featurePath/domain/repositories/${sampleFeatureDirectoryName}_repository.dart', sampleRepositoryTemplate);
    await FileUtils.writeFile('$featurePath/domain/usecases/get_${sampleFeatureDirectoryName}_data.dart', getSampleDataUseCaseTemplate);
    await FileUtils.writeFile('$featurePath/data/dto/${sampleFeatureDirectoryName}_dto.dart', sampleDtoTemplate);
    await FileUtils.writeFile('$featurePath/data/datasources/${sampleFeatureDirectoryName}_local_datasource.dart', sampleLocalDataSourceTemplate);
    await FileUtils.writeFile('$featurePath/data/datasources/${sampleFeatureDirectoryName}_remote_datasource.dart', sampleRemoteDataSourceTemplate);
    await FileUtils.writeFile('$featurePath/data/repositories/${sampleFeatureDirectoryName}_repository_impl.dart', sampleRepositoryImplTemplate);
    await FileUtils.writeFile('$featurePath/presentation/viewmodels/${sampleFeatureDirectoryName}_viewmodel.dart', sampleViewModelTemplate);
    await FileUtils.writeFile('$featurePath/presentation/screens/${sampleFeatureDirectoryName}_screen.dart', sampleScreenTemplate);
  }
}
