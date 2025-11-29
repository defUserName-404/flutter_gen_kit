import '../../../../models/gen_kit_config.dart';

String getSampleLocalDataSourceTemplate(GenKitConfig config) {
  return r'''
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../common/data/exceptions/app_exceptions.dart';
import '../models/sample_feature_model.dart';

abstract class SampleLocalDataSource {
  Future<SampleModel> getSampleData();
  Future<void> cacheSampleData(SampleModel model);
}

class SampleLocalDataSourceImpl implements SampleLocalDataSource {
  final SharedPreferences sharedPreferences;

  SampleLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<SampleModel> getSampleData() {
    throw UnimplementedError();
  }

  @override
  Future<void> cacheSampleData(SampleModel model) {
    throw UnimplementedError();
  }
}
''';
}
