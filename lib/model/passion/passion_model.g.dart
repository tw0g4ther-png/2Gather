// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'passion_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PassionModelImpl _$$PassionModelImplFromJson(Map json) => _$PassionModelImpl(
  name: json['name'] as String?,
  tag: json['tag'] as String?,
  tags: (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList(),
);

Map<String, dynamic> _$$PassionModelImplToJson(_$PassionModelImpl instance) =>
    <String, dynamic>{
      if (instance.name case final value?) 'name': value,
      if (instance.tag case final value?) 'tag': value,
      if (instance.tags case final value?) 'tags': value,
    };
