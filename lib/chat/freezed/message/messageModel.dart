import '../../enum/enumMessage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
part 'messageModel.freezed.dart';
part 'messageModel.g.dart';

enum MessageLockButtonState { notYet, accepted }

@freezed
class MessageModel with _$MessageModel {
  const factory MessageModel({
    required String sender,
    String? relative_path,
    String? blur_hash,
    String? duration,
    String? temporaryPath,
    String? message,
    String? thumbnail,
    String? thumbnail_relative_path,
    String? thumbnail_temporary_path,
    String? urlMediaContent,
    List<String?>? seenBy,
    List<String?>? readedBy,
    bool? sended,
    List<String?>? userDeleteMessage,
    String? lastMessageId,
    @Default(MessageLockButtonState.notYet) MessageLockButtonState? state,
    String? id,
    MessageModel? replyTo,
    @TimestampConverter() required DateTime createdAt,
    @TimestampServerConverter() DateTime? timeStamp,
    required MessageContentType type,
  }) = _MessageModel;

  factory MessageModel.fromJson(Map<String, dynamic> json) => _$MessageModelFromJson(json);
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

class TimestampServerConverter implements JsonConverter<DateTime?, Timestamp?> {
  const TimestampServerConverter();

  @override
  DateTime? fromJson(Timestamp? timestamp) {
    return timestamp?.toDate();
  }

  @override
  Timestamp? toJson(DateTime? date) => date != null ? Timestamp.fromDate(date) : null;
}
