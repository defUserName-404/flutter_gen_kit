import 'package:args/command_runner.dart';
import 'package:flutter_gen_kit/src/models/architecture_config.dart';
import 'package:flutter_gen_kit/src/models/gen_kit_config.dart';
import 'package:flutter_gen_kit/src/services/template_service.dart';
import 'package:flutter_gen_kit/src/utils/extensions/string_casing_extension.dart';
import 'package:flutter_gen_kit/src/utils/file_utils.dart';
import 'package:flutter_gen_kit/src/utils/shell_utils.dart';

class FeatureCommand extends Command<void> {
  @override
  final name = 'feature';

  @override
  final description = 'Generates a new feature with the selected architecture.';

  FeatureCommand() {
    argParser.addOption(
      'name',
      abbr: 'n',
      help: 'The name of the feature to generate.',
      mandatory: true,
    );
  }

  @override
  Future<void> run() async {
    final featureName = argResults!['name'] as String;
    print('Generating feature "$featureName"...');

    // Load config
    final config = await GenKitConfig.load();

    // Get architecture-specific configuration
    final archConfig = ArchitectureConfig.fromGenKitConfig(config);
    final templateService = TemplateService(config);

    // Get feature path
    final snakeCase = featureName.toSnakeCase();
    final featurePath = 'lib/features/$snakeCase';

    // Create directories
    final directories = archConfig
        .getFeatureDirectories()
        .map((dir) => '$featurePath/$dir')
        .toList();
    await FileUtils.createDirectories(directories);

    // Get file definitions
    final fileDefinitions = archConfig.getFeatureFiles(featureName);

    // Generate files
    for (final entry in fileDefinitions.entries) {
      final fileDef = entry.value;
      final filePath = '$featurePath/${fileDef.relativePath}';

      // Get template
      final template = templateService.getTemplate(fileDef.templateKey);

      // Process template with proper replacements
      final content = _processTemplate(
        template,
        featureName,
        fileDef.className,
      );

      // Write file
      await FileUtils.writeFile(filePath, content);
    }

    // Run build_runner to generate mapper files
    print('Running build_runner...');
    await ShellUtils.runCommand('flutter', ['pub', 'run', 'build_runner', 'build', '--delete-conflicting-outputs']);

    print('Feature "$featureName" generated successfully!');
  }

  String _processTemplate(
    String template,
    String featureName,
    String className,
  ) {
    final pascalCase = featureName.toPascalCase();
    final snakeCase = featureName.toSnakeCase();
    final camelCase = featureName.toCamelCase();

    // Extract base name from className (e.g., UserModel -> User)
    final baseName = className.replaceAll(
      RegExp(
        r'(Model|Entity|Repository|ViewModel|Screen|Dto|DataSource|Impl)$',
      ),
      '',
    );

    return template
        .replaceAll('Sample', baseName)
        .replaceAll('sample_feature', snakeCase)
        .replaceAll('sample', camelCase)
        // Additional replacements for specific patterns
        .replaceAll('SampleModel', '${pascalCase}Model')
        .replaceAll('SampleEntity', '${pascalCase}Entity')
        .replaceAll('SampleDto', '${pascalCase}Dto')
        .replaceAll('SampleRepository', '${pascalCase}Repository')
        .replaceAll('SampleViewModel', '${pascalCase}ViewModel')
        .replaceAll('SampleScreen', '${pascalCase}Screen')
        .replaceAll('SampleLocalDataSource', '${pascalCase}LocalDataSource')
        .replaceAll('SampleRemoteDataSource', '${pascalCase}RemoteDataSource')
        .replaceAll('GetSampleData', 'Get${pascalCase}Data')
        .replaceAll('_SampleScreenState', '_${pascalCase}ScreenState')
        .replaceAll('sampleViewModelProvider', '${camelCase}ViewModelProvider')
        .replaceAll(
          'sampleRepositoryProvider',
          '${camelCase}RepositoryProvider',
        )
        .replaceAll('getSampleDataProvider', 'get${pascalCase}DataProvider')
        .replaceAll('Sample Feature', '$pascalCase Feature')
        .replaceAll('MVVM Feature', '$pascalCase Feature');
  }
}
