import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:twogather/model/converters.dart';
import 'package:twogather/model/passion/passion_listing.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'friend_card_model.freezed.dart';
part 'friend_card_model.g.dart';

@freezed
class FriendCardModel with _$FriendCardModel {
  const factory FriendCardModel({
    String? id,
    String? name,
    List<String>? photos,
    String? description,
    String? country,
    @TimestampConverter() DateTime? birthday,
    @GeoPointConverters() GeoPoint? position,
    PassionListing? tags,
  }) = _FriendCardModel;

  factory FriendCardModel.fromJson(Map<String, dynamic> json) =>
      _$FriendCardModelFromJson(json);
}
