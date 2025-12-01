import '../../../../core/network/api_client.dart';
import '../dto/{{feature_name}}_dto.dart';

abstract class {{feature_pascal}}RemoteDataSource {
  Future<{{feature_pascal}}Dto> get{{feature_pascal}}Data();
}

class {{feature_pascal}}RemoteDataSourceImpl implements {{feature_pascal}}RemoteDataSource {
  final ApiClient apiClient;

  {{feature_pascal}}RemoteDataSourceImpl({required this.apiClient});

  @override
  Future<{{feature_pascal}}Dto> get{{feature_pascal}}Data() async {
    throw UnimplementedError();
  }
}
