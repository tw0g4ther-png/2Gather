// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$NotificationModelImpl _$$NotificationModelImplFromJson(Map json) =>
    _$NotificationModelImpl(
      id: json['id'] as String?,
      notificationUser: json['notificationUser'] == null
          ? null
          : AppUserModel.fromJson(
              Map<String, dynamic>.from(json['notificationUser'] as Map),
            ),
      message: json['message'] as String?,
      notificationType: const NotificationTypeConverter().fromJson(
        json['notificationType'] as String?,
      ),
      receivedAt: const TimestampConverter().fromJson(json['receivedAt']),
      metadata: (json['metadata'] as Map?)?.map(
        (k, e) => MapEntry(k as String, e),
      ),
      isComplete: json['isComplete'] as bool?,
      isRead: json['isRead'] as bool?,
    );

Map<String, dynamic> _$$NotificationModelImplToJson(
  _$NotificationModelImpl instance,
) => <String, dynamic>{
  if (instance.id case final value?) 'id': value,
  if (instance.notificationUser?.toJson() case final value?)
    'notificationUser': value,
  if (instance.message case final value?) 'message': value,
  if (const NotificationTypeConverter().toJson(instance.notificationType)
      case final value?)
    'notificationType': value,
  if (const TimestampConverter().toJson(instance.receivedAt) case final value?)
    'receivedAt': value,
  if (instance.metadata case final value?) 'metadata': value,
  if (instance.isComplete case final value?) 'isComplete': value,
  if (instance.isRead case final value?) 'isRead': value,
};
