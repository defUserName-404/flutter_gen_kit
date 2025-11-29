import '../../../../models/gen_kit_config.dart';

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
