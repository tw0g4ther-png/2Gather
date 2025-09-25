import 'package:twogather/model/converters.dart';
import 'package:twogather/model/fiesta/tag/tag_model.dart';
import 'package:twogather/model/user/app_user/app_user_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:skeleton_kosmos/skeleton_kosmos.dart';

part 'fiesta_model.freezed.dart';
part 'fiesta_model.g.dart';

enum FiestaUserStatus { accepted, declined, pending }

@freezed
class FiestaModel with _$FiestaModel {
  const factory FiestaModel({
    String? id,
    bool? isEnd,
    AppUserModel? host,
    String? title,
    String? category,
    double? soundLevel,
    List<TagModel>? tags,
    String? description,
    bool? visibleAfter,
    List<String>? pictures,
    @LocationConverters() LocationModel? address,
    @TimestampConverter() DateTime? startAt,
    @TimestampConverter() DateTime? endAt,
    double? numberOfParticipant,
    String? logistic,
    List<TagModel>? thingToBring,
    double? visibilityRadius,
    bool? visibleByFirstCircle,
    bool? visibleByFiestar,
    bool? visibleByConnexion,
    List<FiestaUserModel>? participants,
  }) = _FiestaModel;

  factory FiestaModel.fromJson(Map<String, dynamic> json) =>
      _$FiestaModelFromJson(json);
}

@freezed
class FiestaUserModel with _$FiestaUserModel {
  const factory FiestaUserModel({
    String? fiestaRef,
    String? duoRef,
    @FiestaUserStatusConverter() String? status,
  }) = _FiestaUserModel;

  factory FiestaUserModel.fromJson(Map<String, dynamic> json) =>
      _$FiestaUserModelFromJson(json);
}

class FiestaUserStatusConverter
    implements JsonConverter<FiestaUserStatus, String> {
  const FiestaUserStatusConverter();

  @override
  FiestaUserStatus fromJson(String json) {
    switch (json) {
      case 'accepted':
        return FiestaUserStatus.accepted;
      case 'declined':
        return FiestaUserStatus.declined;
      case 'pending':
        return FiestaUserStatus.pending;
      default:
        return FiestaUserStatus.pending;
    }
  }

  @override
  String toJson(FiestaUserStatus object) {
    switch (object) {
      case FiestaUserStatus.accepted:
        return 'accepted';
      case FiestaUserStatus.declined:
        return 'declined';
      case FiestaUserStatus.pending:
        return 'pending';
    }
  }
}
