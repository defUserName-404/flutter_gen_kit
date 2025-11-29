import '../../../../models/gen_kit_config.dart';

String getSampleEntityTemplate(GenKitConfig config) {
  return r'''
import 'package:equatable/equatable.dart';

class SampleEntity extends Equatable {
  final String id;
  final String name;

  const SampleEntity({required this.id, required this.name});

  @override
  List<Object?> get props => [id, name];
}
''';
}
