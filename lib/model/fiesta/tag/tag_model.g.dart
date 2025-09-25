// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tag_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TagModelImpl _$$TagModelImplFromJson(Map json) => _$TagModelImpl(
  id: json['id'] as String?,
  name: json['name'] as String?,
  asset: json['asset'] as String?,
);

Map<String, dynamic> _$$TagModelImplToJson(_$TagModelImpl instance) =>
    <String, dynamic>{
      if (instance.id case final value?) 'id': value,
      if (instance.name case final value?) 'name': value,
      if (instance.asset case final value?) 'asset': value,
    };
