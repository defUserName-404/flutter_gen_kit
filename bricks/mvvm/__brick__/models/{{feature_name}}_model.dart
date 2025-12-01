import 'package:dart_mappable/dart_mappable.dart';

part '{{feature_name}}_model.mapper.dart';

@MappableClass()
class {{feature_pascal}}Model with {{feature_pascal}}ModelMappable {
  final String id;
  final String name;

  const {{feature_pascal}}Model({required this.id, required this.name});

  static const fromMap = {{feature_pascal}}ModelMapper.fromMap;
  static const fromJson = {{feature_pascal}}ModelMapper.fromJson;
}
