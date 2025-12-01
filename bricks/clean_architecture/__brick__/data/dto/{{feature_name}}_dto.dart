import 'package:dart_mappable/dart_mappable.dart';
import '../../domain/entities/{{feature_name}}_entity.dart';

part '{{feature_name}}_dto.mapper.dart';

@MappableClass()
class {{feature_pascal}}Dto with {{feature_pascal}}DtoMappable {
  final String id;
  final String name;

  const {{feature_pascal}}Dto({required this.id, required this.name});

  static const fromMap = {{feature_pascal}}DtoMapper.fromMap;
  static const fromJson = {{feature_pascal}}DtoMapper.fromJson;
}
