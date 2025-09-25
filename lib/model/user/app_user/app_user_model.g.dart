// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AppUserModelImpl _$$AppUserModelImplFromJson(Map json) => _$AppUserModelImpl(
  id: json['id'] as String?,
  firstname: json['firstname'] as String?,
  lastname: json['lastname'] as String?,
  gender: json['gender'] as String?,
  reportPoint: (json['reportPoint'] as num?)?.toDouble(),
  level: (json['level'] as num?)?.toDouble(),
  nationality: (json['nationality'] as List<dynamic>?)
      ?.map((e) => e as String)
      .toList(),
  languages: (json['languages'] as List<dynamic>?)
      ?.map((e) => e as String)
      .toList(),
  pictures: (json['pictures'] as List<dynamic>?)
      ?.map((e) => e as String)
      .toList(),
  profilImage: json['profilImage'] as String?,
  description: json['description'] as String?,
  rating: (json['rating'] as num?)?.toDouble(),
  note: (json['note'] as num?)?.toDouble(),
  numberNote: (json['numberNote'] as num?)?.toDouble(),
  numberRecommandations: (json['numberRecommandations'] as num?)?.toDouble(),
  country: json['country'] as String?,
  birthday: const TimestampConverter().fromJson(json['birthday']),
  position: const GeoPointConverters().fromJson(json['position'] as GeoPoint?),
  locality: json['locality'] as String?,
  tags: json['tags'] == null
      ? null
      : PassionListing.fromJson(Map<String, dynamic>.from(json['tags'] as Map)),
  isLock: json['isLock'] as bool?,
);

Map<String, dynamic> _$$AppUserModelImplToJson(
  _$AppUserModelImpl instance,
) => <String, dynamic>{
  if (instance.id case final value?) 'id': value,
  if (instance.firstname case final value?) 'firstname': value,
  if (instance.lastname case final value?) 'lastname': value,
  if (instance.gender case final value?) 'gender': value,
  if (instance.reportPoint case final value?) 'reportPoint': value,
  if (instance.level case final value?) 'level': value,
  if (instance.nationality case final value?) 'nationality': value,
  if (instance.languages case final value?) 'languages': value,
  if (instance.pictures case final value?) 'pictures': value,
  if (instance.profilImage case final value?) 'profilImage': value,
  if (instance.description case final value?) 'description': value,
  if (instance.rating case final value?) 'rating': value,
  if (instance.note case final value?) 'note': value,
  if (instance.numberNote case final value?) 'numberNote': value,
  if (instance.numberRecommandations case final value?)
    'numberRecommandations': value,
  if (instance.country case final value?) 'country': value,
  if (const TimestampConverter().toJson(instance.birthday) case final value?)
    'birthday': value,
  if (const GeoPointConverters().toJson(instance.position) case final value?)
    'position': value,
  if (instance.locality case final value?) 'locality': value,
  if (instance.tags?.toJson() case final value?) 'tags': value,
  if (instance.isLock case final value?) 'isLock': value,
};
