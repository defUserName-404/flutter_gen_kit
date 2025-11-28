import 'package:args/command_runner.dart';
import 'package:flutter_gen_kit/src/models/gen_kit_config.dart';
import 'package:flutter_gen_kit/src/templates/feature_templates.dart';
import 'package:flutter_gen_kit/src/utils/file_utils.dart';

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

    // Create directories
    await FileUtils.createDirectories([
      '$featurePath/data/datasources',
      '$featurePath/data/dto',
      '$featurePath/data/repositories',
      '$featurePath/domain/entities',
      '$featurePath/domain/repositories',
      '$featurePath/domain/usecases',
      '$featurePath/presentation/screens',
      '$featurePath/presentation/viewmodels',
    ]);

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

    // Load config
    final config = await GenKitConfig.load();

    // Replace placeholders
    String processTemplate(String template) {
      return template
          .replaceAll('Sample', featureNamePascal)
          .replaceAll('sample_feature', featureName)
          .replaceAll('sample', featureNameCamel);
    }

    // Write files
    await FileUtils.writeFile(
        '$featurePath/domain/entities/${featureName}_entity.dart',
        processTemplate(getSampleEntityTemplate(config)));
    await FileUtils.writeFile(
        '$featurePath/domain/repositories/${featureName}_repository.dart',
        processTemplate(getSampleRepositoryTemplate(config)));
    await FileUtils.writeFile(
        '$featurePath/domain/usecases/get_${featureName}_data.dart',
        processTemplate(getGetSampleDataUseCaseTemplate(config)));
    await FileUtils.writeFile('$featurePath/data/dto/${featureName}_dto.dart',
        processTemplate(getSampleDtoTemplate(config)));
    await FileUtils.writeFile(
        '$featurePath/data/datasources/${featureName}_local_datasource.dart',
        processTemplate(getSampleLocalDataSourceTemplate(config)));
    await FileUtils.writeFile(
        '$featurePath/data/datasources/${featureName}_remote_datasource.dart',
        processTemplate(getSampleRemoteDataSourceTemplate(config)));
    await FileUtils.writeFile(
        '$featurePath/data/repositories/${featureName}_repository_impl.dart',
        processTemplate(getSampleRepositoryImplTemplate(config)));
    await FileUtils.writeFile(
        '$featurePath/presentation/viewmodels/${featureName}_viewmodel.dart',
        processTemplate(getSampleViewModelTemplate(config)));
    await FileUtils.writeFile(
        '$featurePath/presentation/screens/${featureName}_screen.dart',
        processTemplate(getSampleScreenTemplate(config)));
  }
}
