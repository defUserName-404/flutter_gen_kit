import 'package:shared_preferences/shared_preferences.dart';
import '../../../../common/data/exceptions/app_exceptions.dart';
import '../dto/{{feature_name}}_dto.dart';

abstract class {{feature_pascal}}LocalDataSource {
  Future<{{feature_pascal}}Dto> get{{feature_pascal}}Data();
  Future<void> cache{{feature_pascal}}Data({{feature_pascal}}Dto dto);
}

class {{feature_pascal}}LocalDataSourceImpl implements {{feature_pascal}}LocalDataSource {
  final SharedPreferences sharedPreferences;

  {{feature_pascal}}LocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<{{feature_pascal}}Dto> get{{feature_pascal}}Data() {
    throw UnimplementedError();
  }

  @override
  Future<void> cache{{feature_pascal}}Data({{feature_pascal}}Dto dto) {
    throw UnimplementedError();
  }
}
