// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fiesta_card_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$FiestaCardModelImpl _$$FiestaCardModelImplFromJson(
  Map json,
) => _$FiestaCardModelImpl(
  id: json['id'] as String?,
  host: json['host'] == null
      ? null
      : AppUserModel.fromJson(Map<String, dynamic>.from(json['host'] as Map)),
  totalPlace: (json['totalPlace'] as num?)?.toDouble(),
  remainingPlace: (json['remainingPlace'] as num?)?.toDouble(),
  date: const TimestampConverter().fromJson(json['date']),
  name: json['name'] as String?,
  description: json['description'] as String?,
  photos: (json['photos'] as List<dynamic>?)?.map((e) => e as String).toList(),
  tags: (json['tags'] as List<dynamic>?)
      ?.map((e) => TagModel.fromJson(Map<String, dynamic>.from(e as Map)))
      .toList(),
);

Map<String, dynamic> _$$FiestaCardModelImplToJson(
  _$FiestaCardModelImpl instance,
) => <String, dynamic>{
  if (instance.id case final value?) 'id': value,
  if (instance.host?.toJson() case final value?) 'host': value,
  if (instance.totalPlace case final value?) 'totalPlace': value,
  if (instance.remainingPlace case final value?) 'remainingPlace': value,
  if (const TimestampConverter().toJson(instance.date) case final value?)
    'date': value,
  if (instance.name case final value?) 'name': value,
  if (instance.description case final value?) 'description': value,
  if (instance.photos case final value?) 'photos': value,
  if (instance.tags?.map((e) => e.toJson()).toList() case final value?)
    'tags': value,
};
