import '../../../models/gen_kit_config.dart';

String getSampleModelTemplate(GenKitConfig config) {
  return r'''
import 'package:dart_mappable/dart_mappable.dart';

part 'sample_feature_model.mapper.dart';

@MappableClass()
class SampleModel with SampleModelMappable {
  final String id;
  final String name;

  const SampleModel({required this.id, required this.name});

  static const fromMap = SampleModelMapper.fromMap;
  static const fromJson = SampleModelMapper.fromJson;
}
''';
}
