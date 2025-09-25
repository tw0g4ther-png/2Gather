import 'package:twogather/model/passion/passion_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'passion_listing.freezed.dart';
part 'passion_listing.g.dart';

@freezed
class PassionListing with _$PassionListing {
  const factory PassionListing({
    final List<PassionModel>? drink,
    final List<PassionModel>? fiesta,
    final List<PassionModel>? music,
    final List<PassionModel>? passion,
  }) = _PassionListing;

  factory PassionListing.fromJson(Map<String, dynamic> json) =>
      _$PassionListingFromJson(json);
}
