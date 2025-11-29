import '../../../../models/gen_kit_config.dart';

String getSampleLocalDataSourceTemplate(GenKitConfig config) {
  return r'''
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../common/data/exceptions/app_exceptions.dart';
import '../dto/sample_feature_dto.dart';

abstract class SampleLocalDataSource {
  Future<SampleDto> getSampleData();
  Future<void> cacheSampleData(SampleDto dto);
}

class SampleLocalDataSourceImpl implements SampleLocalDataSource {
  final SharedPreferences sharedPreferences;

  SampleLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<SampleDto> getSampleData() {
    throw UnimplementedError();
  }

  @override
  Future<void> cacheSampleData(SampleDto dto) {
    throw UnimplementedError();
  }
}
''';
}
