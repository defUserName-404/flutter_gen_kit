import '../../../../models/gen_kit_config.dart';

String getSampleRepositoryTemplate(GenKitConfig config) {
  return r'''
import '../entities/sample_feature_entity.dart';

abstract class SampleRepository {
  Future<SampleEntity> getSampleData();
}
''';
}
