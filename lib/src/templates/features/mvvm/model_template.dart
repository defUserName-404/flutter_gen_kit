import '../../../models/gen_kit_config.dart';

String getSampleModelTemplate(GenKitConfig config) {
  return r'''
import 'package:json_annotation/json_annotation.dart';

part 'sample_feature_model.g.dart';

@JsonSerializable()
class SampleModel {
  final String id;
  final String name;

  SampleModel({required this.id, required this.name});

  factory SampleModel.fromJson(Map<String, dynamic> json) =>
      _$SampleModelFromJson(json);

  Map<String, dynamic> toJson() => _$SampleModelToJson(this);
}
''';
}
