// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sponsorship_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SponsorshipModelImpl _$$SponsorshipModelImplFromJson(Map json) =>
    _$SponsorshipModelImpl(
      id: json['id'] as String?,
      user: json['user'] == null
          ? null
          : AppUserModel.fromJson(
              Map<String, dynamic>.from(json['user'] as Map),
            ),
      code: json['code'] as String?,
      isAccepted: json['isAccepted'] as bool? ?? false,
    );

Map<String, dynamic> _$$SponsorshipModelImplToJson(
  _$SponsorshipModelImpl instance,
) => <String, dynamic>{
  if (instance.id case final value?) 'id': value,
  if (instance.user?.toJson() case final value?) 'user': value,
  if (instance.code case final value?) 'code': value,
  'isAccepted': instance.isAccepted,
};
