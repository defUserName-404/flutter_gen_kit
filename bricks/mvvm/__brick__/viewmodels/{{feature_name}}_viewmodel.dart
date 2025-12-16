{{#riverpod}}import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/{{feature_name}}_model.dart';
import '../repositories/{{feature_name}}_repository.dart';

final {{feature_camel}}RepositoryProvider = Provider((ref) => {{feature_pascal}}Repository());

final {{feature_camel}}ViewModelProvider = StateNotifierProvider<
    {{feature_pascal}}ViewModel,
    AsyncValue<{{feature_pascal}}Model?>>((ref) {
  return {{feature_pascal}}ViewModel(repository: ref.read({{feature_camel}}RepositoryProvider));
});

class {{feature_pascal}}ViewModel extends StateNotifier<AsyncValue<{{feature_pascal}}Model?>> {
  final {{feature_pascal}}Repository repository;

  {{feature_pascal}}ViewModel({required this.repository})
      : super(const AsyncValue.data(null));

  Future<void> fetch{{feature_pascal}}Data() async {
    state = const AsyncValue.loading();
    try {
      final data = await repository.get{{feature_pascal}}Data();
      state = AsyncValue.data(data);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}
{{/riverpod}}{{^riverpod}}import '../../../../core/base/base_viewmodel.dart';
import '../../../../core/config/app_logger.dart';
import '../models/{{feature_name}}_model.dart';
import '../repositories/{{feature_name}}_repository.dart';

class {{feature_pascal}}ViewModel extends BaseViewModel {
  final {{feature_pascal}}Repository repository;

  {{feature_pascal}}ViewModel({
    required this.repository,
    required AppLogger logger,
  }) : super(logger);

  {{feature_pascal}}Model? _{{feature_camel}}Data;

  {{feature_pascal}}Model? get {{feature_camel}}Data => _{{feature_camel}}Data;

  Future<void> fetch{{feature_pascal}}Data() async {
    await runCatching(() async {
      _{{feature_camel}}Data = await repository.get{{feature_pascal}}Data();
    });
  }
}
{{/riverpod}}
