import 'package:flutter_gen_kit/src/models/gen_kit_config.dart';
import 'package:flutter_gen_kit/src/templates/core/api_client_template.dart';
import 'package:flutter_gen_kit/src/templates/core/app_colors_template.dart';
import 'package:flutter_gen_kit/src/templates/core/app_config_template.dart';
import 'package:flutter_gen_kit/src/templates/core/app_exceptions_template.dart';
import 'package:flutter_gen_kit/src/templates/core/app_logger_template.dart';
import 'package:flutter_gen_kit/src/templates/core/app_providers_template.dart';
import 'package:flutter_gen_kit/src/templates/core/app_router_template.dart';
import 'package:flutter_gen_kit/src/templates/core/app_template.dart';
import 'package:flutter_gen_kit/src/templates/core/app_theme_template.dart';
import 'package:flutter_gen_kit/src/templates/core/app_typography_template.dart';
import 'package:flutter_gen_kit/src/templates/core/base_viewmodel_template.dart';
import 'package:flutter_gen_kit/src/templates/core/common_constants_template.dart';
import 'package:flutter_gen_kit/src/templates/core/common_loading_indicator_template.dart';
import 'package:flutter_gen_kit/src/templates/core/l10n_en_arb_template.dart';
import 'package:flutter_gen_kit/src/templates/core/l10n_template.dart';
import 'package:flutter_gen_kit/src/templates/core/main_template.dart';
import 'package:flutter_gen_kit/src/templates/core/network_info_template.dart';
import 'package:flutter_gen_kit/src/templates/core/pubspec_template.dart';
import 'package:flutter_gen_kit/src/templates/core/service_locator_template.dart';
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

class FileGenerator {
  static Map<String, String> generateCoreFiles(
    String projectName,
    GenKitConfig config,
  ) {
    return {
      PathConstants.pubspec: pubspecTemplate.replaceAll(
        '__project_name__',
        projectName,
      ),
      PathConstants.main: mainDartTemplate,
      PathConstants.app: coreAppTemplate,
      PathConstants.appProviders: getAppProvidersTemplate(config),
      PathConstants.serviceLocator: serviceLocatorTemplate,
      PathConstants.appConfig: appConfigTemplate,
      PathConstants.appRouter: getAppRouterTemplate(config),
      PathConstants.appTheme: appThemeTemplate,
      PathConstants.appColors: appColorsTemplate,
      PathConstants.appTypography: appTypographyTemplate,
      PathConstants.apiClient: apiClientTemplate,
      PathConstants.networkInfo: networkInfoTemplate,
      PathConstants.appLogger: appLoggerTemplate,
      PathConstants.appExceptions: appExceptionsTemplate,
      PathConstants.baseViewModel: baseViewModelTemplate,
      PathConstants.commonConstants: commonConstantsTemplate,
      PathConstants.loadingIndicator: commonLoadingIndicatorTemplate,
      PathConstants.l10nArb: l10nEnArbTemplate,
      PathConstants.l10nYaml: l10nYamlTemplate,
    };
  }

  static Map<String, String> generateFeatureFiles(
    String featureName,
    GenKitConfig config,
  ) {
    final featurePath = 'lib/features/$featureName';
    final Map<String, String> files = {};

    if (config.architecture == Architecture.mvvm) {
      files['$featurePath/${PathConstants.mvvmModels}/${featureName}_model.dart'] =
          getSampleModelTemplate(config);
      files['$featurePath/${PathConstants.mvvmRepositories}/${featureName}_repository.dart'] =
          getSampleMVVMRepositoryTemplate(config);
      files['$featurePath/${PathConstants.mvvmViewModels}/${featureName}_viewmodel.dart'] =
          getSampleMVVMViewModelTemplate(config);
      files['$featurePath/${PathConstants.mvvmViews}/${featureName}_screen.dart'] =
          getSampleMVVMScreenTemplate(config);
    } else {
      // Clean Architecture
      files['$featurePath/${PathConstants.cleanDomainEntities}/${featureName}_entity.dart'] =
          getSampleEntityTemplate(config);
      files['$featurePath/${PathConstants.cleanDomainRepositories}/${featureName}_repository.dart'] =
          getSampleRepositoryTemplate(config);
      files['$featurePath/${PathConstants.cleanDomainUsecases}/get_${featureName}_data.dart'] =
          getGetSampleDataUseCaseTemplate(config);
      files['$featurePath/${PathConstants.cleanDataDto}/${featureName}_dto.dart'] =
          getSampleDtoTemplate(config);
      files['$featurePath/${PathConstants.cleanDataDatasources}/${featureName}_local_datasource.dart'] =
          getSampleLocalDataSourceTemplate(config);
      files['$featurePath/${PathConstants.cleanDataDatasources}/${featureName}_remote_datasource.dart'] =
          getSampleRemoteDataSourceTemplate(config);
      files['$featurePath/${PathConstants.cleanDataRepositories}/${featureName}_repository_impl.dart'] =
          getSampleRepositoryImplTemplate(config);
      files['$featurePath/${PathConstants.cleanPresentationViewModels}/${featureName}_viewmodel.dart'] =
          getSampleViewModelTemplate(config);
      files['$featurePath/${PathConstants.cleanPresentationScreens}/${featureName}_screen.dart'] =
          getSampleScreenTemplate(config);
    }

    return files;
  }
}
