// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'salonModel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SalonModelImpl _$$SalonModelImplFromJson(Map json) => _$SalonModelImpl(
  nom: json['nom'] as String?,
  lastMessageId: json['lastMessageId'] as String?,
  lastMessageContent: json['lastMessageContent'] == null
      ? null
      : MessageModel.fromJson(
          Map<String, dynamic>.from(json['lastMessageContent'] as Map),
        ),
  id: json['id'] as String?,
  lastLockedDemand: json['lastLockedDemand'] as String?,
  salonPicture: json['salonPicture'] as String?,
  lock:
      $enumDecodeNullable(_$LockStateEnumMap, json['lock']) ?? LockState.notYet,
  allowAllUserToUpdateInformation:
      json['allowAllUserToUpdateInformation'] as bool?,
  adminId: json['adminId'] as String?,
  bloquedUser: (json['bloquedUser'] as List<dynamic>?)
      ?.map((e) => e as String)
      .toList(),
  type: $enumDecode(_$SalonTypeEnumMap, json['type']),
  lastMessageType: $enumDecodeNullable(
    _$MessageContentTypeEnumMap,
    json['lastMessageType'],
  ),
  users: (json['users'] as List<dynamic>).map((e) => e as String?).toList(),
);

Map<String, dynamic> _$$SalonModelImplToJson(
  _$SalonModelImpl instance,
) => <String, dynamic>{
  if (instance.nom case final value?) 'nom': value,
  if (instance.lastMessageId case final value?) 'lastMessageId': value,
  if (instance.lastMessageContent?.toJson() case final value?)
    'lastMessageContent': value,
  if (instance.id case final value?) 'id': value,
  if (instance.lastLockedDemand case final value?) 'lastLockedDemand': value,
  if (instance.salonPicture case final value?) 'salonPicture': value,
  if (_$LockStateEnumMap[instance.lock] case final value?) 'lock': value,
  if (instance.allowAllUserToUpdateInformation case final value?)
    'allowAllUserToUpdateInformation': value,
  if (instance.adminId case final value?) 'adminId': value,
  if (instance.bloquedUser case final value?) 'bloquedUser': value,
  'type': _$SalonTypeEnumMap[instance.type]!,
  if (_$MessageContentTypeEnumMap[instance.lastMessageType] case final value?)
    'lastMessageType': value,
  'users': instance.users,
};

const _$LockStateEnumMap = {
  LockState.locked: 'locked',
  LockState.sended: 'sended',
  LockState.notYet: 'notYet',
};

const _$SalonTypeEnumMap = {
  SalonType.oneToOne: 'oneToOne',
  SalonType.group: 'group',
  SalonType.all: 'all',
};

const _$MessageContentTypeEnumMap = {
  MessageContentType.textMessage: 'textMessage',
  MessageContentType.imageMessage: 'imageMessage',
  MessageContentType.videoMessage: 'videoMessage',
  MessageContentType.lockDemandMessage: 'lockDemandMessage',
};
