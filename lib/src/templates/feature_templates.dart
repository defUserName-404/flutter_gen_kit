import '../models/gen_kit_config.dart';

const String sampleFeatureDirectoryName = 'sample_feature';

// --- Domain Layer Templates ---

String getSampleEntityTemplate(GenKitConfig config) {
  return r'''
import 'package:equatable/equatable.dart';

class SampleEntity extends Equatable {
  final String id;
  final String name;

  const SampleEntity({required this.id, required this.name});

  @override
  List<Object?> get props => [id, name];
}
''';
}

String getSampleRepositoryTemplate(GenKitConfig config) {
  return r'''
import '../entities/sample_feature_entity.dart';

abstract class SampleRepository {
  Future<SampleEntity> getSampleData();
}
''';
}

String getGetSampleDataUseCaseTemplate(GenKitConfig config) {
  return r'''
import 'package:dartz/dartz.dart';

import '../../../../common/data/exceptions/app_exceptions.dart';
import '../entities/sample_feature_entity.dart';
import '../repositories/sample_feature_repository.dart';

class GetSampleData {
  final SampleRepository repository;

  GetSampleData({required this.repository});

  Future<Either<AppException, SampleEntity>> call() async {
    try {
      final result = await repository.getSampleData();
      return Right(result);
    } on AppException catch (e) {
      return Left(e);
    } catch (e) {
      return Left(ApiException(e.toString()));
    }
  }
}
''';
}

// --- Data Layer Templates ---

String getSampleDtoTemplate(GenKitConfig config) {
  return r'''
import 'package:json_annotation/json_annotation.dart';

part 'sample_feature_dto.g.dart';

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
}

String getSampleLocalDataSourceTemplate(GenKitConfig config) {
  return r'''
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../common/data/exceptions/app_exceptions.dart';
import '../models/sample_feature_model.dart';

abstract class SampleLocalDataSource {
  Future<SampleModel> getSampleData();
  Future<void> cacheSampleData(SampleModel model);
}

class SampleLocalDataSourceImpl implements SampleLocalDataSource {
  final SharedPreferences sharedPreferences;

  SampleLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<SampleModel> getSampleData() {
    throw UnimplementedError();
  }

  @override
  Future<void> cacheSampleData(SampleModel model) {
    throw UnimplementedError();
  }
}
''';
}

String getSampleRemoteDataSourceTemplate(GenKitConfig config) {
  return r'''
import '../../../../core/network/api_client.dart';
import '../models/sample_feature_model.dart';

abstract class SampleRemoteDataSource {
  Future<SampleModel> getSampleData();
}

class SampleRemoteDataSourceImpl implements SampleRemoteDataSource {
  final ApiClient apiClient;

  SampleRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<SampleModel> getSampleData() async {
    throw UnimplementedError();
  }
}
''';
}

String getSampleRepositoryImplTemplate(GenKitConfig config) {
  return r'''
import '../../../../common/data/exceptions/app_exceptions.dart';
import '../../domain/entities/sample_feature_entity.dart';
import '../../domain/repositories/sample_feature_repository.dart';
import '../datasources/sample_feature_local_datasource.dart';
import '../datasources/sample_feature_remote_datasource.dart';

class SampleRepositoryImpl implements SampleRepository {
  final SampleLocalDataSource localDataSource;
  final SampleRemoteDataSource remoteDataSource;

  SampleRepositoryImpl({
    required this.localDataSource,
    required this.remoteDataSource,
  });

  @override
  Future<SampleEntity> getSampleData() async {
    throw UnimplementedError();
  }
}
''';
}

// --- Presentation Layer Templates ---

String getSampleViewModelTemplate(GenKitConfig config) {
  if (config.stateManagement == StateManagement.riverpod) {
    return r'''
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/sample_feature_entity.dart';
import '../../domain/usecases/get_sample_feature_data.dart';

final sampleViewModelProvider = StateNotifierProvider<SampleViewModel, AsyncValue<SampleEntity?>>((ref) {
  return SampleViewModel(getSampleData: ref.read(getSampleDataProvider));
});

class SampleViewModel extends StateNotifier<AsyncValue<SampleEntity?>> {
  final GetSampleData getSampleData;

  SampleViewModel({required this.getSampleData}) : super(const AsyncValue.data(null));

  Future<void> fetchSampleData() async {
    state = const AsyncValue.loading();
    final result = await getSampleData();
    result.fold(
      (failure) => state = AsyncValue.error(failure.message, StackTrace.current),
      (data) => state = AsyncValue.data(data),
    );
  }
}
''';
  }

  // Default Provider
  return r'''
import '../../../../core/base/base_viewmodel.dart';
import '../../domain/usecases/get_sample_feature_data.dart';
import '../../domain/entities/sample_feature_entity.dart';

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
}

String getSampleScreenTemplate(GenKitConfig config) {
  if (config.stateManagement == StateManagement.riverpod) {
    return r'''
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../viewmodels/sample_feature_viewmodel.dart';

class SampleScreen extends ConsumerStatefulWidget {
  const SampleScreen({super.key});

  @override
  ConsumerState<SampleScreen> createState() => _SampleScreenState();
}

class _SampleScreenState extends ConsumerState<SampleScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(sampleViewModelProvider.notifier).fetchSampleData();
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(sampleViewModelProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Sample Feature')),
      body: state.when(
        data: (data) {
          if (data == null) return const Center(child: Text('Press button'));
          return Center(child: Text('Data: ${data.name}'));
        },
        error: (err, stack) => Center(child: Text('Error: $err')),
        loading: () => const Center(child: CircularProgressIndicator()),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => ref.read(sampleViewModelProvider.notifier).fetchSampleData(),
        child: const Icon(Icons.refresh),
      ),
    );
  }
}
''';
  }

  // Default Provider
  return r'''
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../common/widgets/loading_indicator.dart';
import '../viewmodels/sample_feature_viewmodel.dart';

class SampleScreen extends StatefulWidget {
  const SampleScreen({super.key});

  @override
  State<SampleScreen> createState() => _SampleScreenState();
}

}
''';
}

// --- MVVM Templates ---

String getSampleModelTemplate(GenKitConfig config) {
  return r'''
import 'package:json_annotation/json_annotation.dart';

part 'sample_feature_model.g.dart';

@JsonSerializable
(
)

class SampleModel {
  final String id;
  final String name;

  SampleModel({required this.id, required this.name});

  factory SampleModel.fromJson(Map<String, dynamic> json) =>
      _$SampleModelFromJson(json);

  Map<String, dynamic> toJson() => _$SampleModelToJson(this);
}
  ''';
}

String getSampleMVVMRepositoryTemplate(GenKitConfig config) {
  return r'''
import '../models/sample_feature_model.dart';

class SampleRepository {
  Future<SampleModel> getSampleData() async {
    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));
    return SampleModel(id: '1', name: 'MVVM Data');
  }
}
  ''';
}

String getSampleMVVMViewModelTemplate(GenKitConfig config) {
  if (config.stateManagement == StateManagement.riverpod) {
    return r'''
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/sample_feature_model.dart';
import '../repositories/sample_feature_repository.dart';

final sampleRepositoryProvider = Provider((ref) => SampleRepository());

final sampleViewModelProvider = StateNotifierProvider<
    SampleViewModel,
    AsyncValue<SampleModel?>>((ref) {
  return SampleViewModel(repository: ref.read(sampleRepositoryProvider));
});

class SampleViewModel extends StateNotifier<AsyncValue<SampleModel?>> {
  final SampleRepository repository;

  SampleViewModel({required this.repository})
      : super(const AsyncValue.data(null));

  Future<void> fetchSampleData() async {
    state = const AsyncValue.loading();
    try {
      final data = await repository.getSampleData();
      state = AsyncValue.data(data);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}
  ''';
  }

  // Default Provider
  return r'''
import 'package:flutter/material.dart';
import '../models/sample_feature_model.dart';
import '../repositories/sample_feature_repository.dart';

class SampleViewModel extends ChangeNotifier {
  final SampleRepository repository;

  SampleViewModel({required this.repository});

  SampleModel? _sampleData;

  SampleModel? get sampleData => _sampleData;

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  String? _errorMessage;

  String? get errorMessage => _errorMessage;

  Future<void> fetchSampleData() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _sampleData = await repository.getSampleData();
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
  ''';
}

String getSampleMVVMScreenTemplate(GenKitConfig config) {
  if (config.stateManagement == StateManagement.riverpod) {
    return r'''
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../viewmodels/sample_feature_viewmodel.dart';

class SampleScreen extends ConsumerStatefulWidget {
  const SampleScreen({super.key});

  @override
  ConsumerState<SampleScreen> createState() => _SampleScreenState();
}

class _SampleScreenState extends ConsumerState<SampleScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(sampleViewModelProvider.notifier).fetchSampleData();
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(sampleViewModelProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('MVVM Feature')),
      body: state.when(
        data: (data) {
          if (data == null) return const Center(child: Text('Press button'));
          return Center(child: Text('Data: ${data.name}'));
        },
        error: (err, stack) => Center(child: Text('Error: $err')),
        loading: () => const Center(child: CircularProgressIndicator()),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () =>
            ref.read(sampleViewModelProvider.notifier).fetchSampleData(),
        child: const Icon(Icons.refresh),
      ),
    );
  }
}
  ''';
  }

  // Default Provider
  return r'''
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/sample_feature_viewmodel.dart';

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
        title: const Text('MVVM Feature'),
      ),
      body: Consumer<SampleViewModel>(
        builder: (context, viewModel, child) {
          if (viewModel.isLoading) {
            return const Center(child: CircularProgressIndicator());
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
}
