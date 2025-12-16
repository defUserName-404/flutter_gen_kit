{{#riverpod}}import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/{{feature_name}}_entity.dart';
import '../../domain/usecases/get_{{feature_name}}_data.dart';

final {{feature_camel}}ViewModelProvider = StateNotifierProvider<{{feature_pascal}}ViewModel, AsyncValue<{{feature_pascal}}Entity?>>((ref) {
  return {{feature_pascal}}ViewModel(get{{feature_pascal}}Data: ref.read(get{{feature_pascal}}DataProvider));
});

class {{feature_pascal}}ViewModel extends StateNotifier<AsyncValue<{{feature_pascal}}Entity?>> {
  final Get{{feature_pascal}}Data get{{feature_pascal}}Data;

  {{feature_pascal}}ViewModel({required this.get{{feature_pascal}}Data}) : super(const AsyncValue.data(null));

  Future<void> fetch{{feature_pascal}}Data() async {
    state = const AsyncValue.loading();
    final result = await get{{feature_pascal}}Data();
    result.fold(
      (failure) => state = AsyncValue.error(failure.message, StackTrace.current),
      (data) => state = AsyncValue.data(data),
    );
  }
}
{{/riverpod}}{{^riverpod}}import '../../../../core/base/base_viewmodel.dart';
import '../../../../core/config/app_logger.dart';
import '../../domain/usecases/get_{{feature_name}}_data.dart';
import '../../domain/entities/{{feature_name}}_entity.dart';

class {{feature_pascal}}ViewModel extends BaseViewModel {
  final Get{{feature_pascal}}Data get{{feature_pascal}}Data;

  {{feature_pascal}}ViewModel({
    required this.get{{feature_pascal}}Data,
    required AppLogger logger,
  }) : super(logger);

  {{feature_pascal}}Entity? _{{feature_camel}}Data;
  {{feature_pascal}}Entity? get {{feature_camel}}Data => _{{feature_camel}}Data;

  Future<void> fetch{{feature_pascal}}Data() async {
    await runCatching(() async {
      final result = await get{{feature_pascal}}Data();
      result.fold(
        (failure) => setErrorMessage(failure.message),
        (data) => _{{feature_camel}}Data = data,
      );
    });
  }
}
{{/riverpod}}
