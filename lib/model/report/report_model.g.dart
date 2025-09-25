// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'report_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ReportModelImpl _$$ReportModelImplFromJson(Map json) => _$ReportModelImpl(
  tag: json['tag'] as String?,
  desc: json['desc'] as String?,
  value: (json['value'] as num?)?.toInt(),
  duration: json['duration'] == null
      ? null
      : Duration(microseconds: (json['duration'] as num).toInt()),
);

Map<String, dynamic> _$$ReportModelImplToJson(
  _$ReportModelImpl instance,
) => <String, dynamic>{
  if (instance.tag case final value?) 'tag': value,
  if (instance.desc case final value?) 'desc': value,
  if (instance.value case final value?) 'value': value,
  if (instance.duration?.inMicroseconds case final value?) 'duration': value,
};
