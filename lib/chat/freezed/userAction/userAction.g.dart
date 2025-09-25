// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'userAction.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ActionUserImpl _$$ActionUserImplFromJson(Map json) => _$ActionUserImpl(
  action: $enumDecode(_$UserActionEnumMap, json['action']),
  idUser: json['idUser'] as String,
  dateTime: DateTime.parse(json['dateTime'] as String),
);

Map<String, dynamic> _$$ActionUserImplToJson(_$ActionUserImpl instance) =>
    <String, dynamic>{
      'action': _$UserActionEnumMap[instance.action]!,
      'idUser': instance.idUser,
      'dateTime': instance.dateTime.toIso8601String(),
    };

const _$UserActionEnumMap = {
  UserAction.typing: 'typing',
  UserAction.recording: 'recording',
  UserAction.normal: 'normal',
};
