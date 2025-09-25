// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'sponsorship_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

SponsorshipModel _$SponsorshipModelFromJson(Map<String, dynamic> json) {
  return _SponsorshipModel.fromJson(json);
}

/// @nodoc
mixin _$SponsorshipModel {
  String? get id => throw _privateConstructorUsedError;
  AppUserModel? get user => throw _privateConstructorUsedError;
  String? get code => throw _privateConstructorUsedError;
  bool get isAccepted => throw _privateConstructorUsedError;

  /// Serializes this SponsorshipModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SponsorshipModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SponsorshipModelCopyWith<SponsorshipModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SponsorshipModelCopyWith<$Res> {
  factory $SponsorshipModelCopyWith(
    SponsorshipModel value,
    $Res Function(SponsorshipModel) then,
  ) = _$SponsorshipModelCopyWithImpl<$Res, SponsorshipModel>;
  @useResult
  $Res call({String? id, AppUserModel? user, String? code, bool isAccepted});

  $AppUserModelCopyWith<$Res>? get user;
}

/// @nodoc
class _$SponsorshipModelCopyWithImpl<$Res, $Val extends SponsorshipModel>
    implements $SponsorshipModelCopyWith<$Res> {
  _$SponsorshipModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SponsorshipModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? user = freezed,
    Object? code = freezed,
    Object? isAccepted = null,
  }) {
    return _then(
      _value.copyWith(
            id: freezed == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String?,
            user: freezed == user
                ? _value.user
                : user // ignore: cast_nullable_to_non_nullable
                      as AppUserModel?,
            code: freezed == code
                ? _value.code
                : code // ignore: cast_nullable_to_non_nullable
                      as String?,
            isAccepted: null == isAccepted
                ? _value.isAccepted
                : isAccepted // ignore: cast_nullable_to_non_nullable
                      as bool,
          )
          as $Val,
    );
  }

  /// Create a copy of SponsorshipModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $AppUserModelCopyWith<$Res>? get user {
    if (_value.user == null) {
      return null;
    }

    return $AppUserModelCopyWith<$Res>(_value.user!, (value) {
      return _then(_value.copyWith(user: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$SponsorshipModelImplCopyWith<$Res>
    implements $SponsorshipModelCopyWith<$Res> {
  factory _$$SponsorshipModelImplCopyWith(
    _$SponsorshipModelImpl value,
    $Res Function(_$SponsorshipModelImpl) then,
  ) = __$$SponsorshipModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String? id, AppUserModel? user, String? code, bool isAccepted});

  @override
  $AppUserModelCopyWith<$Res>? get user;
}

/// @nodoc
class __$$SponsorshipModelImplCopyWithImpl<$Res>
    extends _$SponsorshipModelCopyWithImpl<$Res, _$SponsorshipModelImpl>
    implements _$$SponsorshipModelImplCopyWith<$Res> {
  __$$SponsorshipModelImplCopyWithImpl(
    _$SponsorshipModelImpl _value,
    $Res Function(_$SponsorshipModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of SponsorshipModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? user = freezed,
    Object? code = freezed,
    Object? isAccepted = null,
  }) {
    return _then(
      _$SponsorshipModelImpl(
        id: freezed == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String?,
        user: freezed == user
            ? _value.user
            : user // ignore: cast_nullable_to_non_nullable
                  as AppUserModel?,
        code: freezed == code
            ? _value.code
            : code // ignore: cast_nullable_to_non_nullable
                  as String?,
        isAccepted: null == isAccepted
            ? _value.isAccepted
            : isAccepted // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$SponsorshipModelImpl implements _SponsorshipModel {
  const _$SponsorshipModelImpl({
    this.id,
    this.user,
    this.code,
    this.isAccepted = false,
  });

  factory _$SponsorshipModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$SponsorshipModelImplFromJson(json);

  @override
  final String? id;
  @override
  final AppUserModel? user;
  @override
  final String? code;
  @override
  @JsonKey()
  final bool isAccepted;

  @override
  String toString() {
    return 'SponsorshipModel(id: $id, user: $user, code: $code, isAccepted: $isAccepted)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SponsorshipModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.user, user) || other.user == user) &&
            (identical(other.code, code) || other.code == code) &&
            (identical(other.isAccepted, isAccepted) ||
                other.isAccepted == isAccepted));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, user, code, isAccepted);

  /// Create a copy of SponsorshipModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SponsorshipModelImplCopyWith<_$SponsorshipModelImpl> get copyWith =>
      __$$SponsorshipModelImplCopyWithImpl<_$SponsorshipModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$SponsorshipModelImplToJson(this);
  }
}

abstract class _SponsorshipModel implements SponsorshipModel {
  const factory _SponsorshipModel({
    final String? id,
    final AppUserModel? user,
    final String? code,
    final bool isAccepted,
  }) = _$SponsorshipModelImpl;

  factory _SponsorshipModel.fromJson(Map<String, dynamic> json) =
      _$SponsorshipModelImpl.fromJson;

  @override
  String? get id;
  @override
  AppUserModel? get user;
  @override
  String? get code;
  @override
  bool get isAccepted;

  /// Create a copy of SponsorshipModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SponsorshipModelImplCopyWith<_$SponsorshipModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
