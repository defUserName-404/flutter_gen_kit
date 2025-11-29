import '../../../models/gen_kit_config.dart';

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
