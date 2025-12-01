import 'dart:io';
import 'package:flutter_gen_kit/src/models/gen_kit_config.dart';
import 'package:flutter_gen_kit/src/models/platform_config.dart';
import 'package:flutter_gen_kit/src/services/mason_service.dart';

/// Quick test to verify mason brick generation works
Future<void> main() async {
  print('Testing mason brick generation...');

  // Create a test config
  final config = GenKitConfig(
    architecture: Architecture.clean,
    stateManagement: StateManagement.provider,
    platformConfig: PlatformConfig.all(),
  );

  // Create mason service
  final masonService = MasonService(config);

  // Create temp directory for testing
  final testDir = Directory('test_output');
  if (await testDir.exists()) {
    await testDir.delete(recursive: true);
  }
  await testDir.create();

  try {
    // Test generating core files
    print('Testing core generation...');
    await masonService.generateCore(
      projectName: 'test_project',
      targetPath: 'test_output',
    );
    print('✓ Core generation completed!');

    // Test generating a feature
    print('Testing feature generation...');
    await masonService.generateFeature(
      featureName: 'user_profile',
      targetPath: 'test_output/lib/features/user_profile',
    );

    print('\n✓ Feature generation completed!');
    print('\n Generated files:');

    // List generated files
    await for (final entity in testDir.list(recursive: true)) {
      if (entity is File) {
        print('  - ${entity.path}');
      }
    }

    print('\n✓ Test passed! Mason generation working correctly.');
  } catch (e, stackTrace) {
    print('\n✗ Test failed: $e');
    print('Stack trace: $stackTrace');
    exit(1);
  } finally {
    // Cleanup
    print('\nCleaning up test directory...');
    if (await testDir.exists()) {
      await testDir.delete(recursive: true);
    }
  }
}
