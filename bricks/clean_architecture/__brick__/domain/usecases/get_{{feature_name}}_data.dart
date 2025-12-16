import 'package:dartz/dartz.dart';

import '../../../../common/data/exceptions/app_exceptions.dart';
import '../../../../core/base/base_usecase.dart';
import '../../../../core/config/app_logger.dart';
import '../entities/{{feature_name}}_entity.dart';
import '../repositories/{{feature_name}}_repository.dart';

class Get{{feature_pascal}}Data extends BaseUseCase<{{feature_pascal}}Entity, NoParams> {
  final {{feature_pascal}}Repository repository;

  Get{{feature_pascal}}Data({required this.repository, required AppLogger logger}) : super(logger);

  @override
  Future<Either<AppException, {{feature_pascal}}Entity>> call([NoParams? params]) async {
    try {
      final result = await repository.get{{feature_pascal}}Data();
      return Right(result);
    } on AppException catch (e) {
      logger.e('AppException in Get{{feature_pascal}}Data', e);
      return Left(e);
    } catch (e, s) {
      logger.e('Exception in Get{{feature_pascal}}Data', e, s);
      return Left(ApiException(e.toString()));
    }
  }
}
