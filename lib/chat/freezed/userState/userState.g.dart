// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'userState.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UserStateImpl _$$UserStateImplFromJson(Map json) => _$UserStateImpl(
  idUser: json['idUser'] as String,
  state: $enumDecode(_$StateOfUserEnumMap, json['state']),
  lastUpdate: DateTime.parse(json['lastUpdate'] as String),
);

Map<String, dynamic> _$$UserStateImplToJson(_$UserStateImpl instance) =>
    <String, dynamic>{
      'idUser': instance.idUser,
      'state': _$StateOfUserEnumMap[instance.state]!,
      'lastUpdate': instance.lastUpdate.toIso8601String(),
    };

const _$StateOfUserEnumMap = {
  StateOfUser.online: 'online',
  StateOfUser.offline: 'offline',
};
