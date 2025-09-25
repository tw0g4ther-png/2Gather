// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'passion_listing.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PassionListingImpl _$$PassionListingImplFromJson(
  Map json,
) => _$PassionListingImpl(
  drink: (json['drink'] as List<dynamic>?)
      ?.map((e) => PassionModel.fromJson(Map<String, dynamic>.from(e as Map)))
      .toList(),
  fiesta: (json['fiesta'] as List<dynamic>?)
      ?.map((e) => PassionModel.fromJson(Map<String, dynamic>.from(e as Map)))
      .toList(),
  music: (json['music'] as List<dynamic>?)
      ?.map((e) => PassionModel.fromJson(Map<String, dynamic>.from(e as Map)))
      .toList(),
  passion: (json['passion'] as List<dynamic>?)
      ?.map((e) => PassionModel.fromJson(Map<String, dynamic>.from(e as Map)))
      .toList(),
);

Map<String, dynamic> _$$PassionListingImplToJson(
  _$PassionListingImpl instance,
) => <String, dynamic>{
  if (instance.drink?.map((e) => e.toJson()).toList() case final value?)
    'drink': value,
  if (instance.fiesta?.map((e) => e.toJson()).toList() case final value?)
    'fiesta': value,
  if (instance.music?.map((e) => e.toJson()).toList() case final value?)
    'music': value,
  if (instance.passion?.map((e) => e.toJson()).toList() case final value?)
    'passion': value,
};
