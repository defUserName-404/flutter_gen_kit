import '../../../../models/gen_kit_config.dart';

String getSampleDtoTemplate(GenKitConfig config) {
  return r'''
import 'package:json_annotation/json_annotation.dart';

part 'sample_feature_dto.g.dart';

@JsonSerializable()
class SampleDto {
  @JsonKey(name: 'id')
  final String id;
  @JsonKey(name: 'name')
  final String name;

  SampleDto({required this.id, required this.name});

  factory SampleDto.fromJson(Map<String, dynamic> json) => _$SampleDtoFromJson(json);
  Map<String, dynamic> toJson() => _$SampleDtoToJson(this);
}
''';
}
