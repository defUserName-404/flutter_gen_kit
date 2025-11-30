import 'package:flutter_gen_kit/src/models/architecture_config.dart';
import 'package:flutter_gen_kit/src/models/gen_kit_config.dart';
import 'package:flutter_gen_kit/src/services/template_service.dart';
import 'package:flutter_gen_kit/src/services/user_prompt_service.dart';
import 'package:flutter_gen_kit/src/utils/extensions/string_casing_extension.dart';
import 'package:flutter_gen_kit/src/utils/file_utils.dart';
import 'package:flutter_gen_kit/src/utils/shell_utils.dart';

/// Service for generating features with various options.
class FeatureGenerationService {
  /// Generate a new feature with the given name and options.
  static Future<void> generateFeature(
    String featureName,
    GenKitConfig config,
    FeatureGenerationOptions options,
  ) async {
    print('Generating feature "$featureName"...');

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

    // Generate tests if requested
    if (options.generateTests) {
      await _generateTests(featureName, archConfig);
    }

    // Generate sample data if requested
    if (options.generateSampleData) {
      await _generateSampleData(featureName, featurePath);
    }

    // Run build_runner unless skipped
    if (!options.skipBuildRunner) {
      print('Running build_runner...');
      await ShellUtils.runCommand('flutter', [
        'pub',
        'run',
        'build_runner',
        'build',
        '--delete-conflicting-outputs',
      ]);
    } else {
      print(
        'Skipped build_runner (run manually with: flutter pub run build_runner build)',
      );
    }

    print('Feature "$featureName" generated successfully!');

    // Show next steps for optional features
    if (options.addToRouter) {
      print('\n✓ TODO: Add route to lib/core/router/app_router.dart');
    }
    if (options.registerInDI) {
      print(
        '✓ TODO: Register dependencies in lib/core/di/service_locator.dart',
      );
    }
    if (options.generateApiEndpoints) {
      print(
        '✓ TODO: Add API endpoints to lib/core/constants/api_endpoints.dart',
      );
    }
  }

  /// Process template with replacements.
  static String _processTemplate(
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

  /// Generate test files for the feature.
  static Future<void> _generateTests(
    String featureName,
    ArchitectureConfig archConfig,
  ) async {
    final snakeCase = featureName.toSnakeCase();
    final testPath = 'test/features/$snakeCase';

    print('Generating test files...');

    // Create test directories
    await FileUtils.createDirectories([
      '$testPath/domain',
      '$testPath/data',
      '$testPath/presentation',
    ]);

    // TODO: Generate actual test files with templates
    // For now, just create placeholder files
    await FileUtils.writeFile(
      '$testPath/${snakeCase}_test.dart',
      '// TODO: Add tests for $featureName feature\n',
    );

    print('Test files generated at $testPath');
  }

  /// Generate sample/mock data for the feature.
  static Future<void> _generateSampleData(
    String featureName,
    String featurePath,
  ) async {
    print('Generating sample data...');

    // TODO: Generate sample data based on architecture
    // For now, just add a comment
    print('Sample data generation not yet implemented');
  }
}
