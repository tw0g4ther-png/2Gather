import 'package:freezed_annotation/freezed_annotation.dart';
part 'userAction.freezed.dart';
part 'userAction.g.dart';

enum UserAction { typing, recording, normal }

@freezed
class ActionUser with _$ActionUser {
  const factory ActionUser({
    required UserAction action,
    required String idUser,
    required DateTime dateTime,
  }) = _ActionUser;
  factory ActionUser.fromJson(Map<String, dynamic> json) => _$ActionUserFromJson(json);
}

class TimestampConverter implements JsonConverter<DateTime, int> {
  const TimestampConverter();
  @override
  DateTime fromJson(int timestamp) {
    return DateTime.fromMillisecondsSinceEpoch(timestamp);
  }

  @override
  int toJson(DateTime date) => date.millisecondsSinceEpoch;
}
