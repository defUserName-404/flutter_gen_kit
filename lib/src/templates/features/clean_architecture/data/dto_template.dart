import '../../../../models/gen_kit_config.dart';

String getSampleDtoTemplate(GenKitConfig config) {
  return r'''
import 'package:dart_mappable/dart_mappable.dart';
import '../../domain/entities/sample_feature_entity.dart';

part 'sample_feature_dto.mapper.dart';

@MappableClass()
class SampleDto with SampleDtoMappable {
  final String id;
  final String name;

  const SampleDto({required this.id, required this.name});

  static const fromMap = SampleDtoMapper.fromMap;
  static const fromJson = SampleDtoMapper.fromJson;
}
''';
}
