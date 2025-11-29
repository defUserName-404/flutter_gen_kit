import 'package:flutter_gen_kit/src/utils/extensions/string_casing_extension.dart';

import 'gen_kit_config.dart';

/// Defines the file structure and naming conventions for an architecture
abstract class ArchitectureConfig {
  /// Get the appropriate config based on architecture type
  static ArchitectureConfig fromGenKitConfig(GenKitConfig config) {
    switch (config.architecture) {
      case Architecture.mvvm:
        return MVVMArchitectureConfig();
      case Architecture.clean:
        return CleanArchitectureConfig();
    }
  }

  /// Get all directory paths for a feature (relative to feature root)
  List<String> getFeatureDirectories();

  /// Get file definitions for a feature
  Map<String, FileDefinition> getFeatureFiles(String featureName);

  /// Get import path for viewmodel (used in core files)
  String getViewModelImportPath(String featureName);

  /// Get import path for screen (used in core files)
  String getScreenImportPath(String featureName);
}

/// File definition with path and class name
class FileDefinition {
  final String relativePath; // e.g., 'models/user_model.dart'
  final String className; // e.g., 'UserModel'
  final String templateKey; // e.g., 'model', 'entity', 'repository'

  FileDefinition({
    required this.relativePath,
    required this.className,
    required this.templateKey,
  });
}

/// MVVM Architecture Configuration
class MVVMArchitectureConfig extends ArchitectureConfig {
  @override
  List<String> getFeatureDirectories() {
    return ['models', 'views', 'viewmodels', 'repositories'];
  }

  @override
  Map<String, FileDefinition> getFeatureFiles(String featureName) {
    final pascalCase = featureName.toPascalCase();
    final snakeCase = featureName.toSnakeCase();

    return {
      'model': FileDefinition(
        relativePath: 'models/${snakeCase}_model.dart',
        className: '${pascalCase}Model',
        templateKey: 'mvvm_model',
      ),
      'repository': FileDefinition(
        relativePath: 'repositories/${snakeCase}_repository.dart',
        className: '${pascalCase}Repository',
        templateKey: 'mvvm_repository',
      ),
      'viewmodel': FileDefinition(
        relativePath: 'viewmodels/${snakeCase}_viewmodel.dart',
        className: '${pascalCase}ViewModel',
        templateKey: 'mvvm_viewmodel',
      ),
      'screen': FileDefinition(
        relativePath: 'views/${snakeCase}_screen.dart',
        className: '${pascalCase}Screen',
        templateKey: 'mvvm_screen',
      ),
    };
  }

  @override
  String getViewModelImportPath(String featureName) {
    final featureNameSnakeCase = featureName.toSnakeCase();
    return '../features/$featureNameSnakeCase/viewmodels/${featureNameSnakeCase}_viewmodel.dart';
  }

  @override
  String getScreenImportPath(String featureName) {
    final featureNameSnakeCase = featureName.toSnakeCase();
    return '../../features/$featureNameSnakeCase/views/${featureNameSnakeCase}_screen.dart';
  }
}

/// Clean Architecture Configuration
class CleanArchitectureConfig extends ArchitectureConfig {
  @override
  List<String> getFeatureDirectories() {
    return [
      'data/datasources',
      'data/dto',
      'data/repositories',
      'domain/entities',
      'domain/repositories',
      'domain/usecases',
      'presentation/screens',
      'presentation/viewmodels',
    ];
  }

  @override
  Map<String, FileDefinition> getFeatureFiles(String featureName) {
    final pascalCase = featureName.toPascalCase();
    final snakeCase = featureName.toSnakeCase();

    return {
      'entity': FileDefinition(
        relativePath: 'domain/entities/${snakeCase}_entity.dart',
        className: '${pascalCase}Entity',
        templateKey: 'clean_entity',
      ),
      'repository_interface': FileDefinition(
        relativePath: 'domain/repositories/${snakeCase}_repository.dart',
        className: '${pascalCase}Repository',
        templateKey: 'clean_repository',
      ),
      'usecase': FileDefinition(
        relativePath: 'domain/usecases/get_${snakeCase}_data.dart',
        className: 'Get${pascalCase}Data',
        templateKey: 'clean_usecase',
      ),
      'dto': FileDefinition(
        relativePath: 'data/dto/${snakeCase}_dto.dart',
        className: '${pascalCase}Dto',
        templateKey: 'clean_dto',
      ),
      'local_datasource': FileDefinition(
        relativePath: 'data/datasources/${snakeCase}_local_datasource.dart',
        className: '${pascalCase}LocalDataSource',
        templateKey: 'clean_local_datasource',
      ),
      'remote_datasource': FileDefinition(
        relativePath: 'data/datasources/${snakeCase}_remote_datasource.dart',
        className: '${pascalCase}RemoteDataSource',
        templateKey: 'clean_remote_datasource',
      ),
      'repository_impl': FileDefinition(
        relativePath: 'data/repositories/${snakeCase}_repository_impl.dart',
        className: '${pascalCase}RepositoryImpl',
        templateKey: 'clean_repository_impl',
      ),
      'viewmodel': FileDefinition(
        relativePath: 'presentation/viewmodels/${snakeCase}_viewmodel.dart',
        className: '${pascalCase}ViewModel',
        templateKey: 'clean_viewmodel',
      ),
      'screen': FileDefinition(
        relativePath: 'presentation/screens/${snakeCase}_screen.dart',
        className: '${pascalCase}Screen',
        templateKey: 'clean_screen',
      ),
    };
  }

  @override
  String getViewModelImportPath(String featureName) {
    final featureNameSnakeCase = featureName.toSnakeCase();
    return '../features/$featureNameSnakeCase/presentation/viewmodels/${featureNameSnakeCase}_viewmodel.dart';
  }

  @override
  String getScreenImportPath(String featureName) {
    final featureNameSnakeCase = featureName.toSnakeCase();
    return '../../features/$featureNameSnakeCase/presentation/screens/${featureNameSnakeCase}_screen.dart';
  }
}
