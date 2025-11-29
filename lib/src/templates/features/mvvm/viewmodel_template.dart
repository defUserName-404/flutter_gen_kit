import '../../../models/gen_kit_config.dart';

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
