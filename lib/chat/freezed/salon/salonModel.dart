import '../../enum/enumMessage.dart';
import '../message/messageModel.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
part 'salonModel.freezed.dart';
part 'salonModel.g.dart';

// for lock state
enum LockState { locked, sended, notYet }

@freezed
class SalonModel with _$SalonModel {
  const factory SalonModel({
    String? nom,
    String? lastMessageId,
    MessageModel? lastMessageContent,
    String? id,
    String? lastLockedDemand,
    String? salonPicture,
    @Default(LockState.notYet) LockState? lock,
    bool? allowAllUserToUpdateInformation,
    String? adminId,
    List<String>? bloquedUser,
    required SalonType type,
    MessageContentType? lastMessageType,
    required List<String?> users,
  }) = _SalonModel;
  factory SalonModel.fromJson(Map<String, dynamic> json) => _$SalonModelFromJson(json);
}
