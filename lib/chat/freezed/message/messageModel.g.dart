// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'messageModel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$MessageModelImpl _$$MessageModelImplFromJson(Map json) => _$MessageModelImpl(
  sender: json['sender'] as String,
  relative_path: json['relative_path'] as String?,
  blur_hash: json['blur_hash'] as String?,
  duration: json['duration'] as String?,
  temporaryPath: json['temporaryPath'] as String?,
  message: json['message'] as String?,
  thumbnail: json['thumbnail'] as String?,
  thumbnail_relative_path: json['thumbnail_relative_path'] as String?,
  thumbnail_temporary_path: json['thumbnail_temporary_path'] as String?,
  urlMediaContent: json['urlMediaContent'] as String?,
  seenBy: (json['seenBy'] as List<dynamic>?)?.map((e) => e as String?).toList(),
  readedBy: (json['readedBy'] as List<dynamic>?)
      ?.map((e) => e as String?)
      .toList(),
  sended: json['sended'] as bool?,
  userDeleteMessage: (json['userDeleteMessage'] as List<dynamic>?)
      ?.map((e) => e as String?)
      .toList(),
  lastMessageId: json['lastMessageId'] as String?,
  state:
      $enumDecodeNullable(_$MessageLockButtonStateEnumMap, json['state']) ??
      MessageLockButtonState.notYet,
  id: json['id'] as String?,
  replyTo: json['replyTo'] == null
      ? null
      : MessageModel.fromJson(
          Map<String, dynamic>.from(json['replyTo'] as Map),
        ),
  createdAt: const TimestampConverter().fromJson(
    json['createdAt'] as Timestamp,
  ),
  timeStamp: const TimestampServerConverter().fromJson(
    json['timeStamp'] as Timestamp?,
  ),
  type: $enumDecode(_$MessageContentTypeEnumMap, json['type']),
);

Map<String, dynamic> _$$MessageModelImplToJson(
  _$MessageModelImpl instance,
) => <String, dynamic>{
  'sender': instance.sender,
  if (instance.relative_path case final value?) 'relative_path': value,
  if (instance.blur_hash case final value?) 'blur_hash': value,
  if (instance.duration case final value?) 'duration': value,
  if (instance.temporaryPath case final value?) 'temporaryPath': value,
  if (instance.message case final value?) 'message': value,
  if (instance.thumbnail case final value?) 'thumbnail': value,
  if (instance.thumbnail_relative_path case final value?)
    'thumbnail_relative_path': value,
  if (instance.thumbnail_temporary_path case final value?)
    'thumbnail_temporary_path': value,
  if (instance.urlMediaContent case final value?) 'urlMediaContent': value,
  if (instance.seenBy case final value?) 'seenBy': value,
  if (instance.readedBy case final value?) 'readedBy': value,
  if (instance.sended case final value?) 'sended': value,
  if (instance.userDeleteMessage case final value?) 'userDeleteMessage': value,
  if (instance.lastMessageId case final value?) 'lastMessageId': value,
  if (_$MessageLockButtonStateEnumMap[instance.state] case final value?)
    'state': value,
  if (instance.id case final value?) 'id': value,
  if (instance.replyTo?.toJson() case final value?) 'replyTo': value,
  'createdAt': const TimestampConverter().toJson(instance.createdAt),
  if (const TimestampServerConverter().toJson(instance.timeStamp)
      case final value?)
    'timeStamp': value,
  'type': _$MessageContentTypeEnumMap[instance.type]!,
};

const _$MessageLockButtonStateEnumMap = {
  MessageLockButtonState.notYet: 'notYet',
  MessageLockButtonState.accepted: 'accepted',
};

const _$MessageContentTypeEnumMap = {
  MessageContentType.textMessage: 'textMessage',
  MessageContentType.imageMessage: 'imageMessage',
  MessageContentType.videoMessage: 'videoMessage',
  MessageContentType.lockDemandMessage: 'lockDemandMessage',
};
