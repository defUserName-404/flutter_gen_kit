import 'package:flutter_gen_kit/src/utils/extensions/string_casing_extension.dart';

import '../../../models/gen_kit_config.dart';

String getBlocTemplate(String featureName, GenKitConfig config) {
  final pascalCaseName = featureName.toPascalCase();

  return '''
import 'package:flutter_bloc/flutter_bloc.dart';

part '${featureName}_event.dart';
part '${featureName}_state.dart';

class ${pascalCaseName}Bloc extends Bloc<${pascalCaseName}Event, ${pascalCaseName}State> {
  ${pascalCaseName}Bloc() : super(${pascalCaseName}Initial()) {
    on<${pascalCaseName}Started>(_onStarted);
  }

  Future<void> _onStarted(${pascalCaseName}Started event, Emitter<${pascalCaseName}State> emit) async {
    emit(${pascalCaseName}Loading());
    try {
      // TODO: Implement logic
      await Future.delayed(const Duration(seconds: 1));
      emit(${pascalCaseName}Success('Data loaded'));
    } catch (e) {
      emit(${pascalCaseName}Failure(e.toString()));
    }
  }
}
''';
}
