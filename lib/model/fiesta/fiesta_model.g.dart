// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fiesta_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$FiestaModelImpl _$$FiestaModelImplFromJson(Map json) => _$FiestaModelImpl(
  id: json['id'] as String?,
  isEnd: json['isEnd'] as bool?,
  host: json['host'] == null
      ? null
      : AppUserModel.fromJson(Map<String, dynamic>.from(json['host'] as Map)),
  title: json['title'] as String?,
  category: json['category'] as String?,
  soundLevel: (json['soundLevel'] as num?)?.toDouble(),
  tags: (json['tags'] as List<dynamic>?)
      ?.map((e) => TagModel.fromJson(Map<String, dynamic>.from(e as Map)))
      .toList(),
  description: json['description'] as String?,
  visibleAfter: json['visibleAfter'] as bool?,
  pictures: (json['pictures'] as List<dynamic>?)
      ?.map((e) => e as String)
      .toList(),
  address: const LocationConverters().fromJson(
    json['address'] as Map<String, dynamic>?,
  ),
  startAt: const TimestampConverter().fromJson(json['startAt']),
  endAt: const TimestampConverter().fromJson(json['endAt']),
  numberOfParticipant: (json['numberOfParticipant'] as num?)?.toDouble(),
  logistic: json['logistic'] as String?,
  thingToBring: (json['thingToBring'] as List<dynamic>?)
      ?.map((e) => TagModel.fromJson(Map<String, dynamic>.from(e as Map)))
      .toList(),
  visibilityRadius: (json['visibilityRadius'] as num?)?.toDouble(),
  visibleByFirstCircle: json['visibleByFirstCircle'] as bool?,
  visibleByFiestar: json['visibleByFiestar'] as bool?,
  visibleByConnexion: json['visibleByConnexion'] as bool?,
  participants: (json['participants'] as List<dynamic>?)
      ?.map(
        (e) => FiestaUserModel.fromJson(Map<String, dynamic>.from(e as Map)),
      )
      .toList(),
);

Map<String, dynamic> _$$FiestaModelImplToJson(
  _$FiestaModelImpl instance,
) => <String, dynamic>{
  if (instance.id case final value?) 'id': value,
  if (instance.isEnd case final value?) 'isEnd': value,
  if (instance.host?.toJson() case final value?) 'host': value,
  if (instance.title case final value?) 'title': value,
  if (instance.category case final value?) 'category': value,
  if (instance.soundLevel case final value?) 'soundLevel': value,
  if (instance.tags?.map((e) => e.toJson()).toList() case final value?)
    'tags': value,
  if (instance.description case final value?) 'description': value,
  if (instance.visibleAfter case final value?) 'visibleAfter': value,
  if (instance.pictures case final value?) 'pictures': value,
  if (const LocationConverters().toJson(instance.address) case final value?)
    'address': value,
  if (const TimestampConverter().toJson(instance.startAt) case final value?)
    'startAt': value,
  if (const TimestampConverter().toJson(instance.endAt) case final value?)
    'endAt': value,
  if (instance.numberOfParticipant case final value?)
    'numberOfParticipant': value,
  if (instance.logistic case final value?) 'logistic': value,
  if (instance.thingToBring?.map((e) => e.toJson()).toList() case final value?)
    'thingToBring': value,
  if (instance.visibilityRadius case final value?) 'visibilityRadius': value,
  if (instance.visibleByFirstCircle case final value?)
    'visibleByFirstCircle': value,
  if (instance.visibleByFiestar case final value?) 'visibleByFiestar': value,
  if (instance.visibleByConnexion case final value?)
    'visibleByConnexion': value,
  if (instance.participants?.map((e) => e.toJson()).toList() case final value?)
    'participants': value,
};

_$FiestaUserModelImpl _$$FiestaUserModelImplFromJson(Map json) =>
    _$FiestaUserModelImpl(
      fiestaRef: json['fiestaRef'] as String?,
      duoRef: json['duoRef'] as String?,
      status: json['status'] as String?,
    );

Map<String, dynamic> _$$FiestaUserModelImplToJson(
  _$FiestaUserModelImpl instance,
) => <String, dynamic>{
  if (instance.fiestaRef case final value?) 'fiestaRef': value,
  if (instance.duoRef case final value?) 'duoRef': value,
  if (instance.status case final value?) 'status': value,
};
