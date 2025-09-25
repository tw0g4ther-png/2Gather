// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'notification_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

NotificationModel _$NotificationModelFromJson(Map<String, dynamic> json) {
  return _NotificationModel.fromJson(json);
}

/// @nodoc
mixin _$NotificationModel {
  String? get id => throw _privateConstructorUsedError;
  AppUserModel? get notificationUser => throw _privateConstructorUsedError;
  String? get message => throw _privateConstructorUsedError;
  @NotificationTypeConverter()
  NotificationType? get notificationType => throw _privateConstructorUsedError;
  @TimestampConverter()
  DateTime? get receivedAt => throw _privateConstructorUsedError;
  Map<String, dynamic>? get metadata => throw _privateConstructorUsedError;
  bool? get isComplete => throw _privateConstructorUsedError;
  bool? get isRead => throw _privateConstructorUsedError;

  /// Serializes this NotificationModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of NotificationModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $NotificationModelCopyWith<NotificationModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $NotificationModelCopyWith<$Res> {
  factory $NotificationModelCopyWith(
    NotificationModel value,
    $Res Function(NotificationModel) then,
  ) = _$NotificationModelCopyWithImpl<$Res, NotificationModel>;
  @useResult
  $Res call({
    String? id,
    AppUserModel? notificationUser,
    String? message,
    @NotificationTypeConverter() NotificationType? notificationType,
    @TimestampConverter() DateTime? receivedAt,
    Map<String, dynamic>? metadata,
    bool? isComplete,
    bool? isRead,
  });

  $AppUserModelCopyWith<$Res>? get notificationUser;
}

/// @nodoc
class _$NotificationModelCopyWithImpl<$Res, $Val extends NotificationModel>
    implements $NotificationModelCopyWith<$Res> {
  _$NotificationModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of NotificationModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? notificationUser = freezed,
    Object? message = freezed,
    Object? notificationType = freezed,
    Object? receivedAt = freezed,
    Object? metadata = freezed,
    Object? isComplete = freezed,
    Object? isRead = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: freezed == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String?,
            notificationUser: freezed == notificationUser
                ? _value.notificationUser
                : notificationUser // ignore: cast_nullable_to_non_nullable
                      as AppUserModel?,
            message: freezed == message
                ? _value.message
                : message // ignore: cast_nullable_to_non_nullable
                      as String?,
            notificationType: freezed == notificationType
                ? _value.notificationType
                : notificationType // ignore: cast_nullable_to_non_nullable
                      as NotificationType?,
            receivedAt: freezed == receivedAt
                ? _value.receivedAt
                : receivedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            metadata: freezed == metadata
                ? _value.metadata
                : metadata // ignore: cast_nullable_to_non_nullable
                      as Map<String, dynamic>?,
            isComplete: freezed == isComplete
                ? _value.isComplete
                : isComplete // ignore: cast_nullable_to_non_nullable
                      as bool?,
            isRead: freezed == isRead
                ? _value.isRead
                : isRead // ignore: cast_nullable_to_non_nullable
                      as bool?,
          )
          as $Val,
    );
  }

  /// Create a copy of NotificationModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $AppUserModelCopyWith<$Res>? get notificationUser {
    if (_value.notificationUser == null) {
      return null;
    }

    return $AppUserModelCopyWith<$Res>(_value.notificationUser!, (value) {
      return _then(_value.copyWith(notificationUser: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$NotificationModelImplCopyWith<$Res>
    implements $NotificationModelCopyWith<$Res> {
  factory _$$NotificationModelImplCopyWith(
    _$NotificationModelImpl value,
    $Res Function(_$NotificationModelImpl) then,
  ) = __$$NotificationModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String? id,
    AppUserModel? notificationUser,
    String? message,
    @NotificationTypeConverter() NotificationType? notificationType,
    @TimestampConverter() DateTime? receivedAt,
    Map<String, dynamic>? metadata,
    bool? isComplete,
    bool? isRead,
  });

  @override
  $AppUserModelCopyWith<$Res>? get notificationUser;
}

/// @nodoc
class __$$NotificationModelImplCopyWithImpl<$Res>
    extends _$NotificationModelCopyWithImpl<$Res, _$NotificationModelImpl>
    implements _$$NotificationModelImplCopyWith<$Res> {
  __$$NotificationModelImplCopyWithImpl(
    _$NotificationModelImpl _value,
    $Res Function(_$NotificationModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of NotificationModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? notificationUser = freezed,
    Object? message = freezed,
    Object? notificationType = freezed,
    Object? receivedAt = freezed,
    Object? metadata = freezed,
    Object? isComplete = freezed,
    Object? isRead = freezed,
  }) {
    return _then(
      _$NotificationModelImpl(
        id: freezed == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String?,
        notificationUser: freezed == notificationUser
            ? _value.notificationUser
            : notificationUser // ignore: cast_nullable_to_non_nullable
                  as AppUserModel?,
        message: freezed == message
            ? _value.message
            : message // ignore: cast_nullable_to_non_nullable
                  as String?,
        notificationType: freezed == notificationType
            ? _value.notificationType
            : notificationType // ignore: cast_nullable_to_non_nullable
                  as NotificationType?,
        receivedAt: freezed == receivedAt
            ? _value.receivedAt
            : receivedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        metadata: freezed == metadata
            ? _value._metadata
            : metadata // ignore: cast_nullable_to_non_nullable
                  as Map<String, dynamic>?,
        isComplete: freezed == isComplete
            ? _value.isComplete
            : isComplete // ignore: cast_nullable_to_non_nullable
                  as bool?,
        isRead: freezed == isRead
            ? _value.isRead
            : isRead // ignore: cast_nullable_to_non_nullable
                  as bool?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$NotificationModelImpl implements _NotificationModel {
  const _$NotificationModelImpl({
    this.id,
    this.notificationUser,
    this.message,
    @NotificationTypeConverter() this.notificationType,
    @TimestampConverter() this.receivedAt,
    final Map<String, dynamic>? metadata,
    this.isComplete,
    this.isRead,
  }) : _metadata = metadata;

  factory _$NotificationModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$NotificationModelImplFromJson(json);

  @override
  final String? id;
  @override
  final AppUserModel? notificationUser;
  @override
  final String? message;
  @override
  @NotificationTypeConverter()
  final NotificationType? notificationType;
  @override
  @TimestampConverter()
  final DateTime? receivedAt;
  final Map<String, dynamic>? _metadata;
  @override
  Map<String, dynamic>? get metadata {
    final value = _metadata;
    if (value == null) return null;
    if (_metadata is EqualUnmodifiableMapView) return _metadata;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  final bool? isComplete;
  @override
  final bool? isRead;

  @override
  String toString() {
    return 'NotificationModel(id: $id, notificationUser: $notificationUser, message: $message, notificationType: $notificationType, receivedAt: $receivedAt, metadata: $metadata, isComplete: $isComplete, isRead: $isRead)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$NotificationModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.notificationUser, notificationUser) ||
                other.notificationUser == notificationUser) &&
            (identical(other.message, message) || other.message == message) &&
            (identical(other.notificationType, notificationType) ||
                other.notificationType == notificationType) &&
            (identical(other.receivedAt, receivedAt) ||
                other.receivedAt == receivedAt) &&
            const DeepCollectionEquality().equals(other._metadata, _metadata) &&
            (identical(other.isComplete, isComplete) ||
                other.isComplete == isComplete) &&
            (identical(other.isRead, isRead) || other.isRead == isRead));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    notificationUser,
    message,
    notificationType,
    receivedAt,
    const DeepCollectionEquality().hash(_metadata),
    isComplete,
    isRead,
  );

  /// Create a copy of NotificationModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$NotificationModelImplCopyWith<_$NotificationModelImpl> get copyWith =>
      __$$NotificationModelImplCopyWithImpl<_$NotificationModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$NotificationModelImplToJson(this);
  }
}

abstract class _NotificationModel implements NotificationModel {
  const factory _NotificationModel({
    final String? id,
    final AppUserModel? notificationUser,
    final String? message,
    @NotificationTypeConverter() final NotificationType? notificationType,
    @TimestampConverter() final DateTime? receivedAt,
    final Map<String, dynamic>? metadata,
    final bool? isComplete,
    final bool? isRead,
  }) = _$NotificationModelImpl;

  factory _NotificationModel.fromJson(Map<String, dynamic> json) =
      _$NotificationModelImpl.fromJson;

  @override
  String? get id;
  @override
  AppUserModel? get notificationUser;
  @override
  String? get message;
  @override
  @NotificationTypeConverter()
  NotificationType? get notificationType;
  @override
  @TimestampConverter()
  DateTime? get receivedAt;
  @override
  Map<String, dynamic>? get metadata;
  @override
  bool? get isComplete;
  @override
  bool? get isRead;

  /// Create a copy of NotificationModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$NotificationModelImplCopyWith<_$NotificationModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
