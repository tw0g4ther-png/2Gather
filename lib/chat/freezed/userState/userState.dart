import 'package:freezed_annotation/freezed_annotation.dart';
part 'userState.freezed.dart';
part 'userState.g.dart';

enum StateOfUser { online, offline }

@freezed
class UserState with _$UserState {
  const factory UserState({
    required String idUser,
    required StateOfUser state,
    required DateTime lastUpdate,
  }) = _UserState;
  factory UserState.fromJson(Map<String, dynamic> json) => _$UserStateFromJson(json);
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
