import '../../../../models/gen_kit_config.dart';

String getSampleRemoteDataSourceTemplate(GenKitConfig config) {
  return r'''
import '../../../../core/network/api_client.dart';
import '../models/sample_feature_model.dart';

abstract class SampleRemoteDataSource {
  Future<SampleModel> getSampleData();
}

class SampleRemoteDataSourceImpl implements SampleRemoteDataSource {
  final ApiClient apiClient;

  SampleRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<SampleModel> getSampleData() async {
    throw UnimplementedError();
  }
}
''';
}
