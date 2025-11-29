import 'package:flutter_gen_kit/src/utils/extensions/name_extraction_extension.dart';
import 'package:flutter_gen_kit/src/utils/extensions/string_casing_extension.dart';

import '../models/architecture_config.dart';
import '../models/gen_kit_config.dart';
import '../templates/features/clean_architecture/data/dto_template.dart';
import '../templates/features/clean_architecture/data/local_datasource_template.dart';
import '../templates/features/clean_architecture/data/remote_datasource_template.dart';
import '../templates/features/clean_architecture/data/repository_impl_template.dart';
import '../templates/features/clean_architecture/domain/entity_template.dart';
import '../templates/features/clean_architecture/domain/repository_template.dart';
import '../templates/features/clean_architecture/domain/usecase_template.dart';
import '../templates/features/clean_architecture/presentation/screen_template.dart';
import '../templates/features/clean_architecture/presentation/viewmodel_template.dart';
import '../templates/features/mvvm/model_template.dart';
import '../templates/features/mvvm/repository_template.dart';
import '../templates/features/mvvm/screen_template.dart';
import '../templates/features/mvvm/viewmodel_template.dart';

/// Service to get the appropriate template based on template key
class TemplateService {
  final GenKitConfig config;

  TemplateService(this.config);

  /// Get template content by key
  String getTemplate(String templateKey) {
    switch (templateKey) {
      // MVVM Templates
      case 'mvvm_model':
        return getSampleModelTemplate(config);
      case 'mvvm_repository':
        return getSampleMVVMRepositoryTemplate(config);
      case 'mvvm_viewmodel':
        return getSampleMVVMViewModelTemplate(config);
      case 'mvvm_screen':
        return getSampleMVVMScreenTemplate(config);

      // Clean Architecture Templates
      case 'clean_entity':
        return getSampleEntityTemplate(config);
      case 'clean_repository':
        return getSampleRepositoryTemplate(config);
      case 'clean_usecase':
        return getGetSampleDataUseCaseTemplate(config);
      case 'clean_dto':
        return getSampleDtoTemplate(config);
      case 'clean_local_datasource':
        return getSampleLocalDataSourceTemplate(config);
      case 'clean_remote_datasource':
        return getSampleRemoteDataSourceTemplate(config);
      case 'clean_repository_impl':
        return getSampleRepositoryImplTemplate(config);
      case 'clean_viewmodel':
        return getSampleViewModelTemplate(config);
      case 'clean_screen':
        return getSampleScreenTemplate(config);
      default:
        throw Exception('Unknown template key: $templateKey');
    }
  }

  /// Process template with replacements based on file definition
  String processTemplate(
    String template,
    FileDefinition fileDef,
    String featureName,
  ) {
    // Replace class names
    final processed = template
        .replaceAll('Sample', fileDef.className.extractBaseName())
        .replaceAll('sample', featureName.toSnakeCase());
    return processed;
  }
}
