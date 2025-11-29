import 'package:args/command_runner.dart';
import 'package:flutter_gen_kit/src/models/gen_kit_config.dart';
import 'package:flutter_gen_kit/src/templates/features/clean_architecture/data/dto_template.dart';
import 'package:flutter_gen_kit/src/templates/features/clean_architecture/data/local_datasource_template.dart';
import 'package:flutter_gen_kit/src/templates/features/clean_architecture/data/remote_datasource_template.dart';
import 'package:flutter_gen_kit/src/templates/features/clean_architecture/data/repository_impl_template.dart';
import 'package:flutter_gen_kit/src/templates/features/clean_architecture/domain/entity_template.dart';
import 'package:flutter_gen_kit/src/templates/features/clean_architecture/domain/repository_template.dart';
import 'package:flutter_gen_kit/src/templates/features/clean_architecture/domain/usecase_template.dart';
import 'package:flutter_gen_kit/src/templates/features/clean_architecture/presentation/screen_template.dart';
import 'package:flutter_gen_kit/src/templates/features/clean_architecture/presentation/viewmodel_template.dart';
import 'package:flutter_gen_kit/src/templates/features/mvvm/model_template.dart';
import 'package:flutter_gen_kit/src/templates/features/mvvm/repository_template.dart';
import 'package:flutter_gen_kit/src/templates/features/mvvm/screen_template.dart';
import 'package:flutter_gen_kit/src/templates/features/mvvm/viewmodel_template.dart';
import 'package:flutter_gen_kit/src/utils/constants/path_constants.dart';
import 'package:flutter_gen_kit/src/utils/extensions/string_casing_extension.dart';
import 'package:flutter_gen_kit/src/utils/file_utils.dart';

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
    final featureNameSnakeCase = featureName.toSnakeCase();
    final featureNamePascalCase = featureName.toPascalCase();

    print('Generating feature "$featureName"...');

    // Load config
    final config = await GenKitConfig.load();

    final featurePath = 'lib/features/$featureNameSnakeCase';

    if (config.architecture == Architecture.mvvm) {
      // MVVM Generation
      await FileUtils.createDirectories(
        PathConstants.mvvmFeatureDirectories
            .map((path) => '$featurePath/$path')
            .toList(),
      );

      await FileUtils.writeFile(
        '$featurePath/${PathConstants.mvvmModels}/${featureNameSnakeCase}_model.dart',
        getSampleModelTemplate(config)
            .replaceAll('SampleModel', '${featureNamePascalCase}Model')
            .replaceAll('sample_feature', featureNameSnakeCase),
      );

      await FileUtils.writeFile(
        '$featurePath/${PathConstants.mvvmRepositories}/${featureNameSnakeCase}_repository.dart',
        getSampleMVVMRepositoryTemplate(config)
            .replaceAll(
              'SampleRepository',
              '${featureNamePascalCase}Repository',
            )
            .replaceAll('SampleModel', '${featureNamePascalCase}Model')
            .replaceAll(
              'sample_feature_model.dart',
              '${featureNameSnakeCase}_model.dart',
            ),
      );

      await FileUtils.writeFile(
        '$featurePath/${PathConstants.mvvmViewModels}/${featureNameSnakeCase}_viewmodel.dart',
        getSampleMVVMViewModelTemplate(config)
            .replaceAll('SampleViewModel', '${featureNamePascalCase}ViewModel')
            .replaceAll(
              'SampleRepository',
              '${featureNamePascalCase}Repository',
            )
            .replaceAll(
              'sampleRepositoryProvider',
              '${featureName.toCamelCase()}RepositoryProvider',
            )
            .replaceAll(
              'sampleViewModelProvider',
              '${featureName.toCamelCase()}ViewModelProvider',
            )
            .replaceAll('SampleModel', '${featureNamePascalCase}Model')
            .replaceAll('sample_feature', featureNameSnakeCase),
      );

      await FileUtils.writeFile(
        '$featurePath/${PathConstants.mvvmViews}/${featureNameSnakeCase}_screen.dart',
        getSampleMVVMScreenTemplate(config)
            .replaceAll('SampleScreen', '${featureNamePascalCase}Screen')
            .replaceAll(
              '_SampleScreenState',
              '_${featureNamePascalCase}ScreenState',
            )
            .replaceAll('SampleViewModel', '${featureNamePascalCase}ViewModel')
            .replaceAll(
              'sampleViewModelProvider',
              '${featureName.toCamelCase()}ViewModelProvider',
            )
            .replaceAll('sample_feature', featureNameSnakeCase)
            .replaceAll('MVVM Feature', '$featureNamePascalCase Feature'),
      );
    } else {
      // Clean Architecture Generation
      await FileUtils.createDirectories(
        PathConstants.cleanFeatureDirectories
            .map((path) => '$featurePath/$path')
            .toList(),
      );

      // Domain
      await FileUtils.writeFile(
        '$featurePath/${PathConstants.cleanDomainEntities}/${featureNameSnakeCase}_entity.dart',
        getSampleEntityTemplate(
          config,
        ).replaceAll('SampleEntity', '${featureNamePascalCase}Entity'),
      );

      await FileUtils.writeFile(
        '$featurePath/${PathConstants.cleanDomainRepositories}/${featureNameSnakeCase}_repository.dart',
        getSampleRepositoryTemplate(config)
            .replaceAll(
              'SampleRepository',
              '${featureNamePascalCase}Repository',
            )
            .replaceAll('SampleEntity', '${featureNamePascalCase}Entity')
            .replaceAll(
              'sample_feature_entity.dart',
              '${featureNameSnakeCase}_entity.dart',
            ),
      );

      await FileUtils.writeFile(
        '$featurePath/${PathConstants.cleanDomainUsecases}/get_${featureNameSnakeCase}_data.dart',
        getGetSampleDataUseCaseTemplate(config)
            .replaceAll('GetSampleData', 'Get${featureNamePascalCase}Data')
            .replaceAll(
              'SampleRepository',
              '${featureNamePascalCase}Repository',
            )
            .replaceAll('SampleEntity', '${featureNamePascalCase}Entity')
            .replaceAll('sample_feature', featureNameSnakeCase),
      );

      // Data
      await FileUtils.writeFile(
        '$featurePath/${PathConstants.cleanDataDto}/${featureNameSnakeCase}_dto.dart',
        getSampleDtoTemplate(
          config,
        ).replaceAll('SampleDto', '${featureNamePascalCase}Dto'),
      );

      await FileUtils.writeFile(
        '$featurePath/${PathConstants.cleanDataDatasources}/${featureNameSnakeCase}_local_datasource.dart',
        getSampleLocalDataSourceTemplate(config)
            .replaceAll(
              'SampleLocalDataSource',
              '${featureNamePascalCase}LocalDataSource',
            )
            .replaceAll('SampleModel', '${featureNamePascalCase}Model')
            .replaceAll('sample_feature', featureNameSnakeCase),
      );

      await FileUtils.writeFile(
        '$featurePath/${PathConstants.cleanDataDatasources}/${featureNameSnakeCase}_remote_datasource.dart',
        getSampleRemoteDataSourceTemplate(config)
            .replaceAll(
              'SampleRemoteDataSource',
              '${featureNamePascalCase}RemoteDataSource',
            )
            .replaceAll('SampleModel', '${featureNamePascalCase}Model')
            .replaceAll('sample_feature', featureNameSnakeCase),
      );

      await FileUtils.writeFile(
        '$featurePath/${PathConstants.cleanDataRepositories}/${featureNameSnakeCase}_repository_impl.dart',
        getSampleRepositoryImplTemplate(config)
            .replaceAll(
              'SampleRepository',
              '${featureNamePascalCase}Repository',
            )
            .replaceAll(
              'SampleLocalDataSource',
              '${featureNamePascalCase}LocalDataSource',
            )
            .replaceAll(
              'SampleRemoteDataSource',
              '${featureNamePascalCase}RemoteDataSource',
            )
            .replaceAll('SampleEntity', '${featureNamePascalCase}Entity')
            .replaceAll('sample_feature', featureNameSnakeCase),
      );

      // Presentation
      await FileUtils.writeFile(
        '$featurePath/${PathConstants.cleanPresentationViewModels}/${featureNameSnakeCase}_viewmodel.dart',
        getSampleViewModelTemplate(config)
            .replaceAll('SampleViewModel', '${featureNamePascalCase}ViewModel')
            .replaceAll('GetSampleData', 'Get${featureNamePascalCase}Data')
            .replaceAll('SampleEntity', '${featureNamePascalCase}Entity')
            .replaceAll(
              'sampleViewModelProvider',
              '${featureName.toCamelCase()}ViewModelProvider',
            )
            .replaceAll(
              'getSampleDataProvider',
              'get${featureNamePascalCase}DataProvider',
            )
            .replaceAll('sample_feature', featureNameSnakeCase),
      );

      await FileUtils.writeFile(
        '$featurePath/${PathConstants.cleanPresentationScreens}/${featureNameSnakeCase}_screen.dart',
        getSampleScreenTemplate(config)
            .replaceAll('SampleScreen', '${featureNamePascalCase}Screen')
            .replaceAll(
              '_SampleScreenState',
              '_${featureNamePascalCase}ScreenState',
            )
            .replaceAll('SampleViewModel', '${featureNamePascalCase}ViewModel')
            .replaceAll(
              'sampleViewModelProvider',
              '${featureName.toCamelCase()}ViewModelProvider',
            )
            .replaceAll('sample_feature', featureNameSnakeCase)
            .replaceAll('Sample Feature', '$featureNamePascalCase Feature'),
      );
    }

    print('Feature "$featureName" generated successfully!');
  }
}
