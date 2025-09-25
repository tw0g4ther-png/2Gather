import 'package:twogather/model/converters.dart';
import 'package:twogather/model/user/app_user/app_user_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'notification_model.freezed.dart';
part 'notification_model.g.dart';

enum NotificationType {
  message,
  friendRequest,
  duoRequest,
  fiestaConfirmation,
  handleFiestaConfirmation,
  noteFiesta,
  sponsorshipRequest,
}

class NotificationTypeConverter
    extends JsonConverter<NotificationType?, String?> {
  const NotificationTypeConverter();

  @override
  NotificationType? fromJson(String? json) {
    for (final e in NotificationType.values) {
      if (e.toString().split(".").last == json) {
        return e;
      }
    }
    return null;
  }

  @override
  String? toJson(NotificationType? object) {
    return object?.toString().split(".").last;
  }
}

@freezed
class NotificationModel with _$NotificationModel {
  const factory NotificationModel({
    String? id,
    AppUserModel? notificationUser,
    String? message,
    @NotificationTypeConverter() NotificationType? notificationType,
    @TimestampConverter() DateTime? receivedAt,
    Map<String, dynamic>? metadata,
    bool? isComplete,
    bool? isRead,
  }) = _NotificationModel;

  factory NotificationModel.fromJson(Map<String, dynamic> json) =>
      _$NotificationModelFromJson(json);
}
