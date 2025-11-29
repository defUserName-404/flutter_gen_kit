const String serviceLocatorTemplate = r'''
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:dio/dio.dart';

import '../core/logger/app_logger.dart';
import '../core/network/api_client.dart';
import '../core/network/network_info.dart';

import '../features/sample_feature/data/datasources/sample_local_datasource.dart';
import '../features/sample_feature/data/datasources/sample_remote_datasource.dart';
import '../features/sample_feature/data/repositories/sample_repository_impl.dart';
import '../features/sample_feature/domain/repositories/sample_repository.dart';
import '../features/sample_feature/domain/usecases/get_sample_data.dart';
import '../features/sample_feature/presentation/viewmodels/sample_viewmodel.dart';

class ServiceLocator {
  ServiceLocator._();

  static final GetIt _sl = GetIt.instance;

  static GetIt get instance => _sl;

  static Future<void> setup() async {
    // External dependencies
    final sharedPreferences = await SharedPreferences.getInstance();
    _sl.registerLazySingleton<SharedPreferences>(() => sharedPreferences);
    _sl.registerLazySingleton<Dio>(() => Dio());

    // Core services
    _sl.registerLazySingleton<AppLogger>(() => AppLogger());
    _sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(_sl()));
    _sl.registerLazySingleton<ApiClient>(() => ApiClient(_sl(), _sl()));

    // Feature-specific dependencies
    _setupSampleFeature();
  }

  static void _setupSampleFeature() {
    // Data sources
    _sl.registerLazySingleton<SampleLocalDataSource>(() => SampleLocalDataSourceImpl(sharedPreferences: _sl()));
    _sl.registerLazySingleton<SampleRemoteDataSource>(() => SampleRemoteDataSourceImpl(apiClient: _sl()));

    // Repositories
    _sl.registerLazySingleton<SampleRepository>(
      () => SampleRepositoryImpl(
        localDataSource: _sl(),
        remoteDataSource: _sl(),
      ),
    );

    // Use cases
    _sl.registerFactory(() => GetSampleData(repository: _sl()));

    // ViewModels
    _sl.registerFactory(() => SampleViewModel(getSampleData: _sl()));
  }
}
''';
