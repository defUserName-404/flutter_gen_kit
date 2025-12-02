import '../../../../common/data/exceptions/app_exceptions.dart';
import '../../../../core/config/app_logger.dart';
import '../../domain/entities/{{feature_name}}_entity.dart';
import '../../domain/repositories/{{feature_name}}_repository.dart';
import '../datasources/{{feature_name}}_local_datasource.dart';
import '../datasources/{{feature_name}}_remote_datasource.dart';

class {{feature_pascal}}RepositoryImpl implements {{feature_pascal}}Repository {
  final {{feature_pascal}}LocalDataSource localDataSource;
  final {{feature_pascal}}RemoteDataSource remoteDataSource;
  final AppLogger logger;

  {{feature_pascal}}RepositoryImpl({
    required this.localDataSource,
    required this.remoteDataSource,
    required this.logger,
  });

  @override
  Future<{{feature_pascal}}Entity> get{{feature_pascal}}Data() async {
    try {
      final dto = await remoteDataSource.get{{feature_pascal}}Data();
      return {{feature_pascal}}EntityMapper.fromMap(dto.toMap());
    } catch (e, s) {
      logger.e('Error in {{feature_pascal}}RepositoryImpl', e, s);
      throw ServerException(e.toString());
    }
  }
}
