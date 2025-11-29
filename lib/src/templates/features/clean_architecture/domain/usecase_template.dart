import '../../../../models/gen_kit_config.dart';

String getGetSampleDataUseCaseTemplate(GenKitConfig config) {
  return r'''
import 'package:dartz/dartz.dart';

import '../../../../common/data/exceptions/app_exceptions.dart';
import '../entities/sample_feature_entity.dart';
import '../repositories/sample_feature_repository.dart';

class GetSampleData {
  final SampleRepository repository;

  GetSampleData({required this.repository});

  Future<Either<AppException, SampleEntity>> call() async {
    try {
      final result = await repository.getSampleData();
      return Right(result);
    } on AppException catch (e) {
      return Left(e);
    } catch (e) {
      return Left(ApiException(e.toString()));
    }
  }
}
''';
}
