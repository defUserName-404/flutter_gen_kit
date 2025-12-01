import '../entities/{{feature_name}}_entity.dart';

abstract class {{feature_pascal}}Repository {
  Future<{{feature_pascal}}Entity> get{{feature_pascal}}Data();
}
