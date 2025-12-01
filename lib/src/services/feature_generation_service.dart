import 'package:flutter_gen_kit/src/models/architecture_config.dart';
import 'package:flutter_gen_kit/src/models/gen_kit_config.dart';
import 'package:flutter_gen_kit/src/services/mason_service.dart';
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

    // Get feature path
    final snakeCase = featureName.toSnakeCase();
    final featurePath = 'lib/features/$snakeCase';

    // Use mason service to generate feature
    final masonService = MasonService(config);
    await masonService.generateFeature(
      featureName: featureName,
      targetPath: featurePath,
    );

    print('Feature files generated successfully!');

    // Generate tests if requested
    if (options.generateTests) {
      final archConfig = ArchitectureConfig.fromGenKitConfig(config);
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
