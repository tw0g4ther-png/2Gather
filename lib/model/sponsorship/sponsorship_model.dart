import 'package:twogather/model/user/app_user/app_user_model.dart';
import "package:freezed_annotation/freezed_annotation.dart";

part 'sponsorship_model.freezed.dart';
part 'sponsorship_model.g.dart';

@freezed
class SponsorshipModel with _$SponsorshipModel {
  const factory SponsorshipModel({
    String? id,
    AppUserModel? user,
    String? code,
    @Default(false) bool isAccepted,
  }) = _SponsorshipModel;

  factory SponsorshipModel.fromJson(Map<String, dynamic> json) => _$SponsorshipModelFromJson(json);
}
