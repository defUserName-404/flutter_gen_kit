import '../models/{{feature_name}}_model.dart';

class {{feature_pascal}}Repository {
  Future<{{feature_pascal}}Model> get{{feature_pascal}}Data() async {
    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));
    return {{feature_pascal}}Model(id: '1', name: 'MVVM Data');
  }
}
