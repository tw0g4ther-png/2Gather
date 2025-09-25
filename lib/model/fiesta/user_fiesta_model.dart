import 'package:twogather/model/converters.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:skeleton_kosmos/skeleton_kosmos.dart';

part 'user_fiesta_model.freezed.dart';
part 'user_fiesta_model.g.dart';

@freezed
class UserFiestaModel with _$UserFiestaModel {
  const factory UserFiestaModel({
    String? id,
    String? fiestaId,
    String? title,
    @LocationConverters() LocationModel? address,
    @TimestampConverter() DateTime? startAt,
    @TimestampConverter() DateTime? endAt,
    List<String>? pictures,
    bool? visibleAfter,
  }) = _UserFiestaModel;

  factory UserFiestaModel.fromJson(Map<String, dynamic> json) =>
      _$UserFiestaModelFromJson(json);
}
