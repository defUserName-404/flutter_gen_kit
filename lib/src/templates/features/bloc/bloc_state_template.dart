import 'package:flutter_gen_kit/src/utils/extensions/string_casing_extension.dart';

import '../../../models/gen_kit_config.dart';

String getBlocStateTemplate(String featureName, GenKitConfig config) {
  final pascalCaseName = featureName.toPascalCase();

  return '''
part of '${featureName}_bloc.dart';

sealed class ${pascalCaseName}State {}

class ${pascalCaseName}Initial extends ${pascalCaseName}State {}

class ${pascalCaseName}Loading extends ${pascalCaseName}State {}

class ${pascalCaseName}Success extends ${pascalCaseName}State {
  final dynamic data; // Replace with your data model

  ${pascalCaseName}Success(this.data);
}

class ${pascalCaseName}Failure extends ${pascalCaseName}State {
  final String message;

  ${pascalCaseName}Failure(this.message);
}
''';
}
