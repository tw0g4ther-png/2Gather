import 'package:freezed_annotation/freezed_annotation.dart';

part 'passion_model.freezed.dart';
part 'passion_model.g.dart';

@freezed
class PassionModel with _$PassionModel {
  const factory PassionModel({
    final String? name,
    final String? tag,
    final List<String>? tags,
  }) = _PassionModel;

  factory PassionModel.fromJson(Map<String, dynamic> json) => _$PassionModelFromJson(json);
}
