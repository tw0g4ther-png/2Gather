// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_fiesta_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UserFiestaModelImpl _$$UserFiestaModelImplFromJson(Map json) =>
    _$UserFiestaModelImpl(
      id: json['id'] as String?,
      fiestaId: json['fiestaId'] as String?,
      title: json['title'] as String?,
      address: const LocationConverters().fromJson(
        json['address'] as Map<String, dynamic>?,
      ),
      startAt: const TimestampConverter().fromJson(json['startAt']),
      endAt: const TimestampConverter().fromJson(json['endAt']),
      pictures: (json['pictures'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      visibleAfter: json['visibleAfter'] as bool?,
    );

Map<String, dynamic> _$$UserFiestaModelImplToJson(
  _$UserFiestaModelImpl instance,
) => <String, dynamic>{
  if (instance.id case final value?) 'id': value,
  if (instance.fiestaId case final value?) 'fiestaId': value,
  if (instance.title case final value?) 'title': value,
  if (const LocationConverters().toJson(instance.address) case final value?)
    'address': value,
  if (const TimestampConverter().toJson(instance.startAt) case final value?)
    'startAt': value,
  if (const TimestampConverter().toJson(instance.endAt) case final value?)
    'endAt': value,
  if (instance.pictures case final value?) 'pictures': value,
  if (instance.visibleAfter case final value?) 'visibleAfter': value,
};
