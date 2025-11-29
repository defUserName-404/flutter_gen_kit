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
}
