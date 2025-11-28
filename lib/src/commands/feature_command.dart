import 'package:args/command_runner.dart';
import 'package:flutter_gen_kit/src/models/gen_kit_config.dart';
import 'package:flutter_gen_kit/src/templates/feature_templates.dart';
import 'package:flutter_gen_kit/src/templates/feature_templates.dart';
import 'package:flutter_gen_kit/src/utils/file_utils.dart';
import 'package:flutter_gen_kit/src/utils/path_constants.dart';

class FeatureCommand extends Command<void> {
  @override
  final name = 'feature';
  @override
  final description = 'Generates a new Clean Architecture feature.';

  FeatureCommand();

  @override
  Future<void> run() async {
    if (argResults!.rest.isEmpty) {
      print('Usage: flutter_gen_kit feature <feature_name>');
      return;
    }

    final featureName = argResults!.rest.first;
    print('Generating feature "$featureName"...');

    await _generateFeature(featureName);

    print('Feature "$featureName" generated successfully!');
  }

  Future<void> _generateFeature(String featureName) async {
    final featurePath = 'lib/features/$featureName';

    // Load config
    final config = await GenKitConfig.load();

    // Create directories
    if (config.architecture == Architecture.mvvm) {
      await FileUtils.createDirectories(
        PathConstants.mvvmFeatureDirectories
            .map((path) => '$featurePath/$path')
            .toList(),
      );
    } else {
      await FileUtils.createDirectories(
        PathConstants.cleanFeatureDirectories
            .map((path) => '$featurePath/$path')
            .toList(),
      );
    }

    // Helper to capitalize first letter
    String capitalize(String s) => s[0].toUpperCase() + s.substring(1);

    // Helper to convert snake_case to PascalCase
    String toPascalCase(String s) {
      return s.split('_').map((word) => capitalize(word)).join('');
    }

    // Helper to convert snake_case to camelCase
    String toCamelCase(String s) {
      final pascal = toPascalCase(s);
      return pascal[0].toLowerCase() + pascal.substring(1);
    }

    final featureNamePascal = toPascalCase(featureName);
    final featureNameCamel = toCamelCase(featureName);

    // Replace placeholders
    String processTemplate(String template) {
      return template
          .replaceAll('Sample', featureNamePascal)
          .replaceAll('sample_feature', featureName)
          .replaceAll('sample', featureNameCamel);
    }

    // Write files
    if (config.architecture == Architecture.mvvm) {
      await FileUtils.writeFile(
          '$featurePath/${PathConstants.mvvmModels}/${featureName}_model.dart',
          processTemplate(getSampleModelTemplate(config)));
      await FileUtils.writeFile(
          '$featurePath/${PathConstants
              .mvvmRepositories}/${featureName}_repository.dart',
          processTemplate(getSampleMVVMRepositoryTemplate(config)));
      await FileUtils.writeFile(
          '$featurePath/${PathConstants
              .mvvmViewModels}/${featureName}_viewmodel.dart',
          processTemplate(getSampleMVVMViewModelTemplate(config)));
      await FileUtils.writeFile(
          '$featurePath/${PathConstants.mvvmViews}/${featureName}_screen.dart',
          processTemplate(getSampleMVVMScreenTemplate(config)));
    } else {
      await FileUtils.writeFile(
          '$featurePath/${PathConstants
              .cleanDomainEntities}/${featureName}_entity.dart',
          processTemplate(getSampleEntityTemplate(config)));
      await FileUtils.writeFile(
          '$featurePath/${PathConstants
              .cleanDomainRepositories}/${featureName}_repository.dart',
          processTemplate(getSampleRepositoryTemplate(config)));
      await FileUtils.writeFile(
          '$featurePath/${PathConstants
              .cleanDomainUsecases}/get_${featureName}_data.dart',
          processTemplate(getGetSampleDataUseCaseTemplate(config)));
      await FileUtils.writeFile(
          '$featurePath/${PathConstants.cleanDataDto}/${featureName}_dto.dart',
          processTemplate(getSampleDtoTemplate(config)));
      await FileUtils.writeFile(
          '$featurePath/${PathConstants
              .cleanDataDatasources}/${featureName}_local_datasource.dart',
          processTemplate(getSampleLocalDataSourceTemplate(config)));
      await FileUtils.writeFile(
          '$featurePath/${PathConstants
              .cleanDataDatasources}/${featureName}_remote_datasource.dart',
          processTemplate(getSampleRemoteDataSourceTemplate(config)));
      await FileUtils.writeFile(
          '$featurePath/${PathConstants
              .cleanDataRepositories}/${featureName}_repository_impl.dart',
          processTemplate(getSampleRepositoryImplTemplate(config)));
      await FileUtils.writeFile(
          '$featurePath/${PathConstants
              .cleanPresentationViewModels}/${featureName}_viewmodel.dart',
          processTemplate(getSampleViewModelTemplate(config)));
      await FileUtils.writeFile(
          '$featurePath/${PathConstants
              .cleanPresentationScreens}/${featureName}_screen.dart',
          processTemplate(getSampleScreenTemplate(config)));
    }
  }
}
