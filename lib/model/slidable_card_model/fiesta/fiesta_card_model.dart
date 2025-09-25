import 'package:twogather/model/converters.dart';
import 'package:twogather/model/fiesta/tag/tag_model.dart';
import 'package:twogather/model/user/app_user/app_user_model.dart';
import 'package:twogather/widgets/slidable_card/model/slidable_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'fiesta_card_model.freezed.dart';
part 'fiesta_card_model.g.dart';

@freezed
class FiestaCardModel extends SlidableModel with _$FiestaCardModel {
  const factory FiestaCardModel({
    String? id,
    AppUserModel? host,

    /// Data of fiesta
    double? totalPlace,
    double? remainingPlace,
    @TimestampConverter() DateTime? date,
    String? name,
    String? description,
    List<String>? photos,
    List<TagModel>? tags,
  }) = _FiestaCardModel;

  factory FiestaCardModel.fromJson(Map<String, dynamic> json) =>
      _$FiestaCardModelFromJson(json);
}
