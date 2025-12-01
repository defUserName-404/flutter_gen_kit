import 'dart:io';

import 'package:mason/mason.dart';
import 'package:flutter_gen_kit/src/models/gen_kit_config.dart';
import 'package:flutter_gen_kit/src/utils/extensions/string_casing_extension.dart';

/// Service for generating code from mason bricks
class MasonService {
  final GenKitConfig config;

  MasonService(this.config);

  /// Generate feature from mason brick based on architecture
  Future<void> generateFeature({
    required String featureName,
    required String targetPath,
  }) async {
    // Get the appropriate brick path
    final brickPath = _getBrickPath();

    // Create brick from local path
    final brick = Brick.path(brickPath);

    // Create generator
    final generator = await MasonGenerator.fromBrick(brick);

    // Prepare variables
    final vars = _prepareVariables(featureName);

    // Create target directory
    final targetDir = Directory(targetPath);
    if (!await targetDir.exists()) {
      await targetDir.create(recursive: true);
    }

    // Generate
    final target = DirectoryGeneratorTarget(targetDir);
    final _ = await generator.generate(
      target,
      vars: vars,
      logger: Logger(),
    );
  }

  /// Generate core project files from mason brick
  Future<void> generateCore({
    required String projectName,
    required String targetPath,
  }) async {
    // Get the core brick path
    final brickPath = _getCoreBrickPath();

    // Create brick from local path
    final brick = Brick.path(brickPath);

    // Create generator
    final generator = await MasonGenerator.fromBrick(brick);

    // Prepare variables
    final vars = <String, dynamic>{
      'project_name': projectName,
      'state_management': config.stateManagement.name,
      'architecture': config.architecture.name,
      'riverpod': config.stateManagement == StateManagement.riverpod,
      'bloc': config.stateManagement == StateManagement.bloc,
    };

    // Create target directory
    final targetDir = Directory(targetPath);
    if (!await targetDir.exists()) {
      await targetDir.create(recursive: true);
    }

    // Generate
    final target = DirectoryGeneratorTarget(targetDir);
    await generator.generate(
      target,
      vars: vars,
      logger: Logger(),
    );
  }

  /// Get brick path based on architecture type
  String _getBrickPath() {
    // Get the package root directory
    // In a Dart package, we can use Platform.script to determine location
    // For a globally activated package, bricks should be bundled with the package
    final packageRoot = _getPackageRoot();

    switch (config.architecture) {
      case Architecture.clean:
        return '$packageRoot/bricks/clean_architecture';
      case Architecture.mvvm:
        return '$packageRoot/bricks/mvvm';
    }
  }

  /// Get package root directory
  String _getPackageRoot() {
    // For development: use current directory
    // For production: use the package installation directory
    final scriptPath = Platform.script.toFilePath();
    final scriptDir = File(scriptPath).parent.parent.parent.path;
    
    // Check if bricks directory exists in current location
    if (Directory('$scriptDir/bricks').existsSync()) {
      return scriptDir;
    }
    
    // Fallback to current directory (development mode)
    return Directory.current.path;
  }

  /// Prepare variables for mason brick generation
  Map<String, dynamic> _prepareVariables(String featureName) {
    final pascalCase = featureName.toPascalCase();
    final camelCase = featureName.toCamelCase();
    final snakeCase = featureName.toSnakeCase();

    final vars = <String, dynamic>{
      'feature_name': snakeCase,
      'feature_pascal': pascalCase,
      'feature_camel': camelCase,
      'state_management': config.stateManagement.name,
      'architecture': config.architecture.name,
    };

    // Add conditional flags for mustache sections
    // For riverpod, we need to set 'riverpod' to true
    if (config.stateManagement == StateManagement.riverpod) {
      vars['riverpod'] = true;
    }

    return vars;
  }

  /// Get core brick path
  String _getCoreBrickPath() {
    final packageRoot = _getPackageRoot();
    return '$packageRoot/bricks/core';
  }
}
