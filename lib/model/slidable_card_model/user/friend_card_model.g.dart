// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'friend_card_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$FriendCardModelImpl _$$FriendCardModelImplFromJson(
  Map json,
) => _$FriendCardModelImpl(
  id: json['id'] as String?,
  name: json['name'] as String?,
  photos: (json['photos'] as List<dynamic>?)?.map((e) => e as String).toList(),
  description: json['description'] as String?,
  country: json['country'] as String?,
  birthday: const TimestampConverter().fromJson(json['birthday']),
  position: const GeoPointConverters().fromJson(json['position'] as GeoPoint?),
  tags: json['tags'] == null
      ? null
      : PassionListing.fromJson(Map<String, dynamic>.from(json['tags'] as Map)),
);

Map<String, dynamic> _$$FriendCardModelImplToJson(
  _$FriendCardModelImpl instance,
) => <String, dynamic>{
  if (instance.id case final value?) 'id': value,
  if (instance.name case final value?) 'name': value,
  if (instance.photos case final value?) 'photos': value,
  if (instance.description case final value?) 'description': value,
  if (instance.country case final value?) 'country': value,
  if (const TimestampConverter().toJson(instance.birthday) case final value?)
    'birthday': value,
  if (const GeoPointConverters().toJson(instance.position) case final value?)
    'position': value,
  if (instance.tags?.toJson() case final value?) 'tags': value,
};
