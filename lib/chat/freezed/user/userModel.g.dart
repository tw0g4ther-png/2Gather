// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'userModel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UserModelImpl _$$UserModelImplFromJson(Map json) => _$UserModelImpl(
  firstname: json['firstname'] as String?,
  lastname: json['lastname'] as String?,
  pseudo: json['pseudo'] as String?,
  profilImage: json['profilImage'] as String?,
  createdAt: const TimestampConverter().fromJson(
    json['createdAt'] as Timestamp,
  ),
  lastSeen: const TimestampConverter().fromJson(json['lastSeen'] as Timestamp),
  id: json['id'] as String?,
);

Map<String, dynamic> _$$UserModelImplToJson(_$UserModelImpl instance) =>
    <String, dynamic>{
      if (instance.firstname case final value?) 'firstname': value,
      if (instance.lastname case final value?) 'lastname': value,
      if (instance.pseudo case final value?) 'pseudo': value,
      if (instance.profilImage case final value?) 'profilImage': value,
      'createdAt': const TimestampConverter().toJson(instance.createdAt),
      'lastSeen': const TimestampConverter().toJson(instance.lastSeen),
      if (instance.id case final value?) 'id': value,
    };
