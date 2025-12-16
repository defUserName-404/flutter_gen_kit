import 'package:dartz/dartz.dart';

import '../../common/data/exceptions/app_exceptions.dart';
import '../config/app_logger.dart';

abstract class BaseUseCase<Type, Params> {
  final AppLogger logger;

  BaseUseCase(this.logger);

  Future<Either<AppException, Type>> call(Params params);
}

class NoParams {}
