import '../../../../models/gen_kit_config.dart';

String getSampleRemoteDataSourceTemplate(GenKitConfig config) {
  return r'''
import '../../../../core/network/api_client.dart';
import '../dto/sample_feature_dto.dart';

abstract class SampleRemoteDataSource {
  Future<SampleDto> getSampleData();
}

class SampleRemoteDataSourceImpl implements SampleRemoteDataSource {
  final ApiClient apiClient;

  SampleRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<SampleDto> getSampleData() async {
    throw UnimplementedError();
  }
}
''';
}
