import 'package:dart_mappable/dart_mappable.dart';

part '{{feature_name}}_entity.mapper.dart';

@MappableClass()
class {{feature_pascal}}Entity with {{feature_pascal}}EntityMappable {
  final String id;
  final String name;

  const {{feature_pascal}}Entity({required this.id, required this.name});
}
