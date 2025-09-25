// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'userAction.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

ActionUser _$ActionUserFromJson(Map<String, dynamic> json) {
  return _ActionUser.fromJson(json);
}

/// @nodoc
mixin _$ActionUser {
  UserAction get action => throw _privateConstructorUsedError;
  String get idUser => throw _privateConstructorUsedError;
  DateTime get dateTime => throw _privateConstructorUsedError;

  /// Serializes this ActionUser to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ActionUser
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ActionUserCopyWith<ActionUser> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ActionUserCopyWith<$Res> {
  factory $ActionUserCopyWith(
    ActionUser value,
    $Res Function(ActionUser) then,
  ) = _$ActionUserCopyWithImpl<$Res, ActionUser>;
  @useResult
  $Res call({UserAction action, String idUser, DateTime dateTime});
}

/// @nodoc
class _$ActionUserCopyWithImpl<$Res, $Val extends ActionUser>
    implements $ActionUserCopyWith<$Res> {
  _$ActionUserCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ActionUser
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? action = null,
    Object? idUser = null,
    Object? dateTime = null,
  }) {
    return _then(
      _value.copyWith(
            action: null == action
                ? _value.action
                : action // ignore: cast_nullable_to_non_nullable
                      as UserAction,
            idUser: null == idUser
                ? _value.idUser
                : idUser // ignore: cast_nullable_to_non_nullable
                      as String,
            dateTime: null == dateTime
                ? _value.dateTime
                : dateTime // ignore: cast_nullable_to_non_nullable
                      as DateTime,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ActionUserImplCopyWith<$Res>
    implements $ActionUserCopyWith<$Res> {
  factory _$$ActionUserImplCopyWith(
    _$ActionUserImpl value,
    $Res Function(_$ActionUserImpl) then,
  ) = __$$ActionUserImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({UserAction action, String idUser, DateTime dateTime});
}

/// @nodoc
class __$$ActionUserImplCopyWithImpl<$Res>
    extends _$ActionUserCopyWithImpl<$Res, _$ActionUserImpl>
    implements _$$ActionUserImplCopyWith<$Res> {
  __$$ActionUserImplCopyWithImpl(
    _$ActionUserImpl _value,
    $Res Function(_$ActionUserImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ActionUser
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? action = null,
    Object? idUser = null,
    Object? dateTime = null,
  }) {
    return _then(
      _$ActionUserImpl(
        action: null == action
            ? _value.action
            : action // ignore: cast_nullable_to_non_nullable
                  as UserAction,
        idUser: null == idUser
            ? _value.idUser
            : idUser // ignore: cast_nullable_to_non_nullable
                  as String,
        dateTime: null == dateTime
            ? _value.dateTime
            : dateTime // ignore: cast_nullable_to_non_nullable
                  as DateTime,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ActionUserImpl implements _ActionUser {
  const _$ActionUserImpl({
    required this.action,
    required this.idUser,
    required this.dateTime,
  });

  factory _$ActionUserImpl.fromJson(Map<String, dynamic> json) =>
      _$$ActionUserImplFromJson(json);

  @override
  final UserAction action;
  @override
  final String idUser;
  @override
  final DateTime dateTime;

  @override
  String toString() {
    return 'ActionUser(action: $action, idUser: $idUser, dateTime: $dateTime)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ActionUserImpl &&
            (identical(other.action, action) || other.action == action) &&
            (identical(other.idUser, idUser) || other.idUser == idUser) &&
            (identical(other.dateTime, dateTime) ||
                other.dateTime == dateTime));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, action, idUser, dateTime);

  /// Create a copy of ActionUser
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ActionUserImplCopyWith<_$ActionUserImpl> get copyWith =>
      __$$ActionUserImplCopyWithImpl<_$ActionUserImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ActionUserImplToJson(this);
  }
}

abstract class _ActionUser implements ActionUser {
  const factory _ActionUser({
    required final UserAction action,
    required final String idUser,
    required final DateTime dateTime,
  }) = _$ActionUserImpl;

  factory _ActionUser.fromJson(Map<String, dynamic> json) =
      _$ActionUserImpl.fromJson;

  @override
  UserAction get action;
  @override
  String get idUser;
  @override
  DateTime get dateTime;

  /// Create a copy of ActionUser
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ActionUserImplCopyWith<_$ActionUserImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
