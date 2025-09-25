// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'lastDeleteCompos.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

LastDeleteCompos _$LastDeleteComposFromJson(Map<String, dynamic> json) {
  return _LastDeleteCompos.fromJson(json);
}

/// @nodoc
mixin _$LastDeleteCompos {
  String get idUser => throw _privateConstructorUsedError;
  String get idSalon => throw _privateConstructorUsedError;
  DateTime get lastDateDelete => throw _privateConstructorUsedError;

  /// Serializes this LastDeleteCompos to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of LastDeleteCompos
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $LastDeleteComposCopyWith<LastDeleteCompos> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LastDeleteComposCopyWith<$Res> {
  factory $LastDeleteComposCopyWith(
    LastDeleteCompos value,
    $Res Function(LastDeleteCompos) then,
  ) = _$LastDeleteComposCopyWithImpl<$Res, LastDeleteCompos>;
  @useResult
  $Res call({String idUser, String idSalon, DateTime lastDateDelete});
}

/// @nodoc
class _$LastDeleteComposCopyWithImpl<$Res, $Val extends LastDeleteCompos>
    implements $LastDeleteComposCopyWith<$Res> {
  _$LastDeleteComposCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of LastDeleteCompos
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? idUser = null,
    Object? idSalon = null,
    Object? lastDateDelete = null,
  }) {
    return _then(
      _value.copyWith(
            idUser: null == idUser
                ? _value.idUser
                : idUser // ignore: cast_nullable_to_non_nullable
                      as String,
            idSalon: null == idSalon
                ? _value.idSalon
                : idSalon // ignore: cast_nullable_to_non_nullable
                      as String,
            lastDateDelete: null == lastDateDelete
                ? _value.lastDateDelete
                : lastDateDelete // ignore: cast_nullable_to_non_nullable
                      as DateTime,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$LastDeleteComposImplCopyWith<$Res>
    implements $LastDeleteComposCopyWith<$Res> {
  factory _$$LastDeleteComposImplCopyWith(
    _$LastDeleteComposImpl value,
    $Res Function(_$LastDeleteComposImpl) then,
  ) = __$$LastDeleteComposImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String idUser, String idSalon, DateTime lastDateDelete});
}

/// @nodoc
class __$$LastDeleteComposImplCopyWithImpl<$Res>
    extends _$LastDeleteComposCopyWithImpl<$Res, _$LastDeleteComposImpl>
    implements _$$LastDeleteComposImplCopyWith<$Res> {
  __$$LastDeleteComposImplCopyWithImpl(
    _$LastDeleteComposImpl _value,
    $Res Function(_$LastDeleteComposImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of LastDeleteCompos
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? idUser = null,
    Object? idSalon = null,
    Object? lastDateDelete = null,
  }) {
    return _then(
      _$LastDeleteComposImpl(
        idUser: null == idUser
            ? _value.idUser
            : idUser // ignore: cast_nullable_to_non_nullable
                  as String,
        idSalon: null == idSalon
            ? _value.idSalon
            : idSalon // ignore: cast_nullable_to_non_nullable
                  as String,
        lastDateDelete: null == lastDateDelete
            ? _value.lastDateDelete
            : lastDateDelete // ignore: cast_nullable_to_non_nullable
                  as DateTime,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$LastDeleteComposImpl implements _LastDeleteCompos {
  const _$LastDeleteComposImpl({
    required this.idUser,
    required this.idSalon,
    required this.lastDateDelete,
  });

  factory _$LastDeleteComposImpl.fromJson(Map<String, dynamic> json) =>
      _$$LastDeleteComposImplFromJson(json);

  @override
  final String idUser;
  @override
  final String idSalon;
  @override
  final DateTime lastDateDelete;

  @override
  String toString() {
    return 'LastDeleteCompos(idUser: $idUser, idSalon: $idSalon, lastDateDelete: $lastDateDelete)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LastDeleteComposImpl &&
            (identical(other.idUser, idUser) || other.idUser == idUser) &&
            (identical(other.idSalon, idSalon) || other.idSalon == idSalon) &&
            (identical(other.lastDateDelete, lastDateDelete) ||
                other.lastDateDelete == lastDateDelete));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, idUser, idSalon, lastDateDelete);

  /// Create a copy of LastDeleteCompos
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$LastDeleteComposImplCopyWith<_$LastDeleteComposImpl> get copyWith =>
      __$$LastDeleteComposImplCopyWithImpl<_$LastDeleteComposImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$LastDeleteComposImplToJson(this);
  }
}

abstract class _LastDeleteCompos implements LastDeleteCompos {
  const factory _LastDeleteCompos({
    required final String idUser,
    required final String idSalon,
    required final DateTime lastDateDelete,
  }) = _$LastDeleteComposImpl;

  factory _LastDeleteCompos.fromJson(Map<String, dynamic> json) =
      _$LastDeleteComposImpl.fromJson;

  @override
  String get idUser;
  @override
  String get idSalon;
  @override
  DateTime get lastDateDelete;

  /// Create a copy of LastDeleteCompos
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$LastDeleteComposImplCopyWith<_$LastDeleteComposImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
