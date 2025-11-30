class PathConstants {
  // Core Directories
  static const List<String> coreDirectories = [
    'lib/core/config',
    'lib/core/network',
    'lib/core/router',
    'lib/core/theme',
    'lib/core/logger',
    'lib/core/base',
    'lib/common/data/exceptions',
    'lib/common/data/remote',
    'lib/common/utils',
    'lib/common/widgets',
    'assets/l10n',
    'assets/config',
  ];

  // MVVM Feature Paths (Relative to feature root)
  static const String mvvmModels = 'models';
  static const String mvvmViews = 'views';
  static const String mvvmViewModels = 'viewmodels';
  static const String mvvmRepositories = 'repositories';

  static const List<String> mvvmFeatureDirectories = [
    mvvmModels,
    mvvmViews,
    mvvmViewModels,
    mvvmRepositories,
  ];

  // Clean Architecture Feature Paths (Relative to feature root)
  static const String cleanDataDatasources = 'data/datasources';
  static const String cleanDataDto = 'data/dto';
  static const String cleanDataRepositories = 'data/repositories';
  static const String cleanDomainEntities = 'domain/entities';
  static const String cleanDomainRepositories = 'domain/repositories';
  static const String cleanDomainUsecases = 'domain/usecases';
  static const String cleanPresentationScreens = 'presentation/screens';
  static const String cleanPresentationViewModels = 'presentation/viewmodels';

  static const List<String> cleanFeatureDirectories = [
    cleanDataDatasources,
    cleanDataDto,
    cleanDataRepositories,
    cleanDomainEntities,
    cleanDomainRepositories,
    cleanDomainUsecases,
    cleanPresentationScreens,
    cleanPresentationViewModels,
  ];

  // Core File Paths
  static const String pubspec = 'pubspec.yaml';
  static const String main = 'lib/main.dart';
  static const String app = 'lib/core/app.dart';
  static const String appProviders = 'lib/core/app_providers.dart';
  static const String serviceLocator = 'lib/core/service_locator.dart';
  static const String appConfig = 'lib/core/config/app_config.dart';
  static const String appRouter = 'lib/core/router/app_router.dart';
  static const String appTheme = 'lib/core/theme/app_theme.dart';
  static const String appColors = 'lib/core/theme/app_colors.dart';
  static const String appTypography = 'lib/core/theme/app_typography.dart';
  static const String apiClient = 'lib/core/network/api_client.dart';
  static const String networkInfo = 'lib/core/network/network_info.dart';
  static const String appLogger = 'lib/core/logger/app_logger.dart';
  static const String appExceptions = 'lib/common/data/exceptions/app_exceptions.dart';
  static const String baseViewModel = 'lib/core/base/base_viewmodel.dart';
  static const String commonConstants = 'lib/common/utils/constants.dart';
  static const String loadingIndicator = 'lib/common/widgets/loading_indicator.dart';
  static const String l10nArb = 'assets/l10n/app_en.arb';
  static const String l10nYaml = 'l10n.yaml';
}
