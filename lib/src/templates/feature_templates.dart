// feature_templates.dart

const String sampleFeatureDirectoryName = 'sample_feature';

// --- Domain Layer Templates ---
const String sampleEntityTemplate = r'''
import 'package:equatable/equatable.dart';

class SampleEntity extends Equatable {
  final String id;
  final String name;

  const SampleEntity({required this.id, required this.name});

  @override
  List<Object?> get props => [id, name];
}
''';

const String sampleRepositoryTemplate = r'''
import '../entities/sample_entity.dart';

abstract class SampleRepository {
  Future<SampleEntity> getSampleData();
}
''';

const String getSampleDataUseCaseTemplate = r'''
import 'package:dartz/dartz.dart';

import '../../../../common/data/exceptions/app_exceptions.dart';
import '../../../../common/data/remote/network_info.dart'; // For checking network
import '../entities/sample_entity.dart';
import '../repositories/sample_repository.dart';

class GetSampleData {
  final SampleRepository repository;

  GetSampleData({required this.repository});

  Future<Either<AppException, SampleEntity>> call() async {
    // Example of network check in usecase
    // if (!(await NetworkInfo.instance.isConnected)) {
    //   return Left(ConnectionException('No internet connection'));
    // }
    try {
      final result = await repository.getSampleData();
      return Right(result);
    } on AppException catch (e) {
      return Left(e);
    } catch (e) {
      return Left(ApiException(e.toString())); // General API exception
    }
  }
}
''';

// --- Data Layer Templates ---
const String sampleDtoTemplate = r'''
import 'package:json_annotation/json_annotation.dart';

part 'sample_dto.g.dart';

@JsonSerializable()
class SampleDto {
  @JsonKey(name: 'id')
  final String id;
  @JsonKey(name: 'name')
  final String name;

  SampleDto({required this.id, required this.name});

  factory SampleDto.fromJson(Map<String, dynamic> json) => _$SampleDtoFromJson(json);
  Map<String, dynamic> toJson() => _$SampleDtoToJson(this);
}
''';

const String sampleLocalDataSourceTemplate = r'''
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../common/data/exceptions/app_exceptions.dart';
import '../models/sample_model.dart'; // Assuming DTO is also the model for this layer

abstract class SampleLocalDataSource {
  Future<SampleModel> getSampleData();
  Future<void> cacheSampleData(SampleModel model);
}

class SampleLocalDataSourceImpl implements SampleLocalDataSource {
  final SharedPreferences sharedPreferences;

  SampleLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<SampleModel> getSampleData() {
    final cachedData = sharedPreferences.getString('cached_sample_data');
    if (cachedData != null) {
      // return Future.value(SampleModel.fromJson(json.decode(cachedData)));
      throw UnimplementedError('Decoding from cache not implemented'); // Placeholder
    } else {
      throw CacheException('No local data found');
    }
  }

  @override
  Future<void> cacheSampleData(SampleModel model) {
    // return sharedPreferences.setString('cached_sample_data', json.encode(model.toJson()));
    throw UnimplementedError('Caching not implemented'); // Placeholder
  }
}
''';

const String sampleRemoteDataSourceTemplate = r'''
import '../../../../core/network/api_client.dart';
import '../models/sample_model.dart'; // Assuming DTO is also the model for this layer

abstract class SampleRemoteDataSource {
  Future<SampleModel> getSampleData();
}

class SampleRemoteDataSourceImpl implements SampleRemoteDataSource {
  final ApiClient apiClient;

  SampleRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<SampleModel> getSampleData() async {
    try {
      final response = await apiClient.get('/sample-endpoint');
      // return SampleModel.fromJson(response.data);
      throw UnimplementedError('Mapping from API response not implemented'); // Placeholder
    } catch (e) {
      rethrow; // Re-throw exceptions handled by ApiClient
    }
  }
}
''';

const String sampleRepositoryImplTemplate = r'''
import '../../../../common/data/exceptions/app_exceptions.dart';
import '../../domain/entities/sample_entity.dart';
import '../../domain/repositories/sample_repository.dart';
import '../datasources/sample_local_datasource.dart';
import '../datasources/sample_remote_datasource.dart';
import '../models/sample_model.dart'; // Assuming DTO is also the model for this layer

class SampleRepositoryImpl implements SampleRepository {
  final SampleLocalDataSource localDataSource;
  final SampleRemoteDataSource remoteDataSource;

  SampleRepositoryImpl({
    required this.localDataSource,
    required this.remoteDataSource,
  });

  @override
  Future<SampleEntity> getSampleData() async {
    try {
      final remoteData = await remoteDataSource.getSampleData();
      localDataSource.cacheSampleData(remoteData); // Cache the data
      // return SampleModel.toEntity(remoteData);
      throw UnimplementedError('Mapping from DTO to Entity not implemented'); // Placeholder
    } on CacheException {
      final localData = await localDataSource.getSampleData();
      // return SampleModel.toEntity(localData);
      throw UnimplementedError('Mapping from DTO to Entity not implemented'); // Placeholder
    }
  }
}
''';

// --- Presentation Layer Templates ---
const String sampleViewModelTemplate = r'''
import '../../../../core/base/base_viewmodel.dart';
import '../../domain/usecases/get_sample_data.dart';
import '../../domain/entities/sample_entity.dart';

class SampleViewModel extends BaseViewModel {
  final GetSampleData getSampleData;

  SampleViewModel({required this.getSampleData});

  SampleEntity? _sampleData;
  SampleEntity? get sampleData => _sampleData;

  Future<void> fetchSampleData() async {
    await runCatching(() async {
      final result = await getSampleData();
      result.fold(
        (failure) => setErrorMessage(failure.message),
        (data) => _sampleData = data,
      );
    });
  }
}
''';

const String sampleScreenTemplate = r'''
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../common/widgets/loading_indicator.dart';
import '../viewmodels/sample_viewmodel.dart';

class SampleScreen extends StatefulWidget {
  const SampleScreen({super.key});

  @override
  State<SampleScreen> createState() => _SampleScreenState();
}

class _SampleScreenState extends State<SampleScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<SampleViewModel>().fetchSampleData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sample Feature'),
      ),
      body: Consumer<SampleViewModel>(
        builder: (context, viewModel, child) {
          if (viewModel.isLoading) {
            return const LoadingIndicator();
          } else if (viewModel.errorMessage != null) {
            return Center(
              child: Text('Error: ${viewModel.errorMessage}'),
            );
          } else if (viewModel.sampleData != null) {
            return Center(
              child: Text('Data: ${viewModel.sampleData!.name}'),
            );
          }
          return const Center(
            child: Text('Press the button to fetch data.'),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.read<SampleViewModel>().fetchSampleData(),
        child: const Icon(Icons.refresh),
      ),
    );
  }
}
''';
