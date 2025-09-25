// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'userModel.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

UserModel _$UserModelFromJson(Map<String, dynamic> json) {
  return _UserModel.fromJson(json);
}

/// @nodoc
mixin _$UserModel {
  String? get firstname => throw _privateConstructorUsedError;
  String? get lastname => throw _privateConstructorUsedError;
  String? get pseudo => throw _privateConstructorUsedError;
  String? get profilImage => throw _privateConstructorUsedError;
  @TimestampConverter()
  DateTime get createdAt => throw _privateConstructorUsedError;
  @TimestampConverter()
  DateTime get lastSeen => throw _privateConstructorUsedError;
  String? get id => throw _privateConstructorUsedError;

  /// Serializes this UserModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of UserModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $UserModelCopyWith<UserModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserModelCopyWith<$Res> {
  factory $UserModelCopyWith(UserModel value, $Res Function(UserModel) then) =
      _$UserModelCopyWithImpl<$Res, UserModel>;
  @useResult
  $Res call({
    String? firstname,
    String? lastname,
    String? pseudo,
    String? profilImage,
    @TimestampConverter() DateTime createdAt,
    @TimestampConverter() DateTime lastSeen,
    String? id,
  });
}

/// @nodoc
class _$UserModelCopyWithImpl<$Res, $Val extends UserModel>
    implements $UserModelCopyWith<$Res> {
  _$UserModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of UserModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? firstname = freezed,
    Object? lastname = freezed,
    Object? pseudo = freezed,
    Object? profilImage = freezed,
    Object? createdAt = null,
    Object? lastSeen = null,
    Object? id = freezed,
  }) {
    return _then(
      _value.copyWith(
            firstname: freezed == firstname
                ? _value.firstname
                : firstname // ignore: cast_nullable_to_non_nullable
                      as String?,
            lastname: freezed == lastname
                ? _value.lastname
                : lastname // ignore: cast_nullable_to_non_nullable
                      as String?,
            pseudo: freezed == pseudo
                ? _value.pseudo
                : pseudo // ignore: cast_nullable_to_non_nullable
                      as String?,
            profilImage: freezed == profilImage
                ? _value.profilImage
                : profilImage // ignore: cast_nullable_to_non_nullable
                      as String?,
            createdAt: null == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            lastSeen: null == lastSeen
                ? _value.lastSeen
                : lastSeen // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            id: freezed == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$UserModelImplCopyWith<$Res>
    implements $UserModelCopyWith<$Res> {
  factory _$$UserModelImplCopyWith(
    _$UserModelImpl value,
    $Res Function(_$UserModelImpl) then,
  ) = __$$UserModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String? firstname,
    String? lastname,
    String? pseudo,
    String? profilImage,
    @TimestampConverter() DateTime createdAt,
    @TimestampConverter() DateTime lastSeen,
    String? id,
  });
}

/// @nodoc
class __$$UserModelImplCopyWithImpl<$Res>
    extends _$UserModelCopyWithImpl<$Res, _$UserModelImpl>
    implements _$$UserModelImplCopyWith<$Res> {
  __$$UserModelImplCopyWithImpl(
    _$UserModelImpl _value,
    $Res Function(_$UserModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of UserModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? firstname = freezed,
    Object? lastname = freezed,
    Object? pseudo = freezed,
    Object? profilImage = freezed,
    Object? createdAt = null,
    Object? lastSeen = null,
    Object? id = freezed,
  }) {
    return _then(
      _$UserModelImpl(
        firstname: freezed == firstname
            ? _value.firstname
            : firstname // ignore: cast_nullable_to_non_nullable
                  as String?,
        lastname: freezed == lastname
            ? _value.lastname
            : lastname // ignore: cast_nullable_to_non_nullable
                  as String?,
        pseudo: freezed == pseudo
            ? _value.pseudo
            : pseudo // ignore: cast_nullable_to_non_nullable
                  as String?,
        profilImage: freezed == profilImage
            ? _value.profilImage
            : profilImage // ignore: cast_nullable_to_non_nullable
                  as String?,
        createdAt: null == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        lastSeen: null == lastSeen
            ? _value.lastSeen
            : lastSeen // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        id: freezed == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$UserModelImpl implements _UserModel {
  const _$UserModelImpl({
    this.firstname,
    this.lastname,
    this.pseudo,
    this.profilImage,
    @TimestampConverter() required this.createdAt,
    @TimestampConverter() required this.lastSeen,
    this.id,
  });

  factory _$UserModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$UserModelImplFromJson(json);

  @override
  final String? firstname;
  @override
  final String? lastname;
  @override
  final String? pseudo;
  @override
  final String? profilImage;
  @override
  @TimestampConverter()
  final DateTime createdAt;
  @override
  @TimestampConverter()
  final DateTime lastSeen;
  @override
  final String? id;

  @override
  String toString() {
    return 'UserModel(firstname: $firstname, lastname: $lastname, pseudo: $pseudo, profilImage: $profilImage, createdAt: $createdAt, lastSeen: $lastSeen, id: $id)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UserModelImpl &&
            (identical(other.firstname, firstname) ||
                other.firstname == firstname) &&
            (identical(other.lastname, lastname) ||
                other.lastname == lastname) &&
            (identical(other.pseudo, pseudo) || other.pseudo == pseudo) &&
            (identical(other.profilImage, profilImage) ||
                other.profilImage == profilImage) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.lastSeen, lastSeen) ||
                other.lastSeen == lastSeen) &&
            (identical(other.id, id) || other.id == id));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    firstname,
    lastname,
    pseudo,
    profilImage,
    createdAt,
    lastSeen,
    id,
  );

  /// Create a copy of UserModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UserModelImplCopyWith<_$UserModelImpl> get copyWith =>
      __$$UserModelImplCopyWithImpl<_$UserModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UserModelImplToJson(this);
  }
}

abstract class _UserModel implements UserModel {
  const factory _UserModel({
    final String? firstname,
    final String? lastname,
    final String? pseudo,
    final String? profilImage,
    @TimestampConverter() required final DateTime createdAt,
    @TimestampConverter() required final DateTime lastSeen,
    final String? id,
  }) = _$UserModelImpl;

  factory _UserModel.fromJson(Map<String, dynamic> json) =
      _$UserModelImpl.fromJson;

  @override
  String? get firstname;
  @override
  String? get lastname;
  @override
  String? get pseudo;
  @override
  String? get profilImage;
  @override
  @TimestampConverter()
  DateTime get createdAt;
  @override
  @TimestampConverter()
  DateTime get lastSeen;
  @override
  String? get id;

  /// Create a copy of UserModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UserModelImplCopyWith<_$UserModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
