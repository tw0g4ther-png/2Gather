// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'lastDeleteCompos.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$LastDeleteComposImpl _$$LastDeleteComposImplFromJson(Map json) =>
    _$LastDeleteComposImpl(
      idUser: json['idUser'] as String,
      idSalon: json['idSalon'] as String,
      lastDateDelete: DateTime.parse(json['lastDateDelete'] as String),
    );

Map<String, dynamic> _$$LastDeleteComposImplToJson(
  _$LastDeleteComposImpl instance,
) => <String, dynamic>{
  'idUser': instance.idUser,
  'idSalon': instance.idSalon,
  'lastDateDelete': instance.lastDateDelete.toIso8601String(),
};
