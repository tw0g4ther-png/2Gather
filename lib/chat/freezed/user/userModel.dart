import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
part 'userModel.freezed.dart';
part 'userModel.g.dart';

@freezed
class UserModel with _$UserModel {
  const factory UserModel({
    String? firstname,
    String? lastname,
    String? pseudo,
    String? profilImage,
    @TimestampConverter() required DateTime createdAt,
    @TimestampConverter() required DateTime lastSeen,
    String? id,
  }) = _UserModel;
  factory UserModel.fromJson(Map<String, dynamic> json) => _$UserModelFromJson(json);
}

class TimestampConverter implements JsonConverter<DateTime, Timestamp> {
  const TimestampConverter();
  @override
  DateTime fromJson(Timestamp timestamp) {
    return timestamp.toDate();
  }

  @override
  Timestamp toJson(DateTime date) => Timestamp.fromDate(date);
}
