import '../../../../models/gen_kit_config.dart';

String getSampleRepositoryImplTemplate(GenKitConfig config) {
  return r'''
import '../../../../common/data/exceptions/app_exceptions.dart';
import '../../domain/entities/sample_feature_entity.dart';
import '../../domain/repositories/sample_feature_repository.dart';
import '../datasources/sample_feature_local_datasource.dart';
import '../datasources/sample_feature_remote_datasource.dart';

class SampleRepositoryImpl implements SampleRepository {
  final SampleLocalDataSource localDataSource;
  final SampleRemoteDataSource remoteDataSource;

  SampleRepositoryImpl({
    required this.localDataSource,
    required this.remoteDataSource,
  });

  @override
  Future<SampleEntity> getSampleData() async {
    try {
      final dto = await remoteDataSource.getSampleData();
      return SampleEntityMapper.fromMap(dto.toMap());
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}
''';
}
