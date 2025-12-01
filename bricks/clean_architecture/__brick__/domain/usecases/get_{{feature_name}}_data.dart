import 'package:fpdart/fpdart.dart';

import '../../../../common/data/exceptions/app_exceptions.dart';
import '../entities/{{feature_name}}_entity.dart';
import '../repositories/{{feature_name}}_repository.dart';

class Get{{feature_pascal}}Data {
  final {{feature_pascal}}Repository repository;

  Get{{feature_pascal}}Data({required this.repository});

  Future<Either<AppException, {{feature_pascal}}Entity>> call() async {
    try {
      final result = await repository.get{{feature_pascal}}Data();
      return Right(result);
    } on AppException catch (e) {
      return Left(e);
    } catch (e) {
      return Left(ApiException(e.toString()));
    }
  }
}
