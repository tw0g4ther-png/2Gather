import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:twogather/model/converters.dart';
import 'package:twogather/model/passion/passion_listing.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'app_user_model.freezed.dart';
part 'app_user_model.g.dart';

@freezed
class AppUserModel with _$AppUserModel {
  const factory AppUserModel({
    String? id,
    String? firstname,
    String? lastname,
    String? gender,
    double? reportPoint,
    double? level,
    List<String>? nationality,
    List<String>? languages,
    List<String>? pictures,
    String? profilImage, // Image de profil principale
    String? description,
    double? rating,
    double? note,
    double? numberNote,
    double? numberRecommandations,
    String? country,
    @TimestampConverter() DateTime? birthday,
    @GeoPointConverters() GeoPoint? position,
    String? locality,
    PassionListing? tags,
    bool? isLock,
  }) = _AppUserModel;

  factory AppUserModel.fromJson(Map<String, dynamic> json) => _$AppUserModelFromJson(json);
}
