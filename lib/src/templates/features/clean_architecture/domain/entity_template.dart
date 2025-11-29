import '../../../../models/gen_kit_config.dart';

String getSampleEntityTemplate(GenKitConfig config) {
  return r'''
import 'package:dart_mappable/dart_mappable.dart';

part 'sample_feature_entity.mapper.dart';

@MappableClass()
class SampleEntity with SampleEntityMappable {
  final String id;
  final String name;

  const SampleEntity({required this.id, required this.name});
}
''';
}
