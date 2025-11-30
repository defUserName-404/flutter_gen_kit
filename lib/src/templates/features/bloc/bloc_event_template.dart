import 'package:flutter_gen_kit/src/utils/extensions/string_casing_extension.dart';

import '../../../models/gen_kit_config.dart';

String getBlocEventTemplate(String featureName, GenKitConfig config) {
  final pascalCaseName = featureName.toPascalCase();

  return '''
part of '${featureName}_bloc.dart';

sealed class ${pascalCaseName}Event {}

class ${pascalCaseName}Started extends ${pascalCaseName}Event {}
''';
}
