// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_fiesta_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

UserFiestaModel _$UserFiestaModelFromJson(Map<String, dynamic> json) {
  return _UserFiestaModel.fromJson(json);
}

/// @nodoc
mixin _$UserFiestaModel {
  String? get id => throw _privateConstructorUsedError;
  String? get fiestaId => throw _privateConstructorUsedError;
  String? get title => throw _privateConstructorUsedError;
  @LocationConverters()
  LocationModel? get address => throw _privateConstructorUsedError;
  @TimestampConverter()
  DateTime? get startAt => throw _privateConstructorUsedError;
  @TimestampConverter()
  DateTime? get endAt => throw _privateConstructorUsedError;
  List<String>? get pictures => throw _privateConstructorUsedError;
  bool? get visibleAfter => throw _privateConstructorUsedError;

  /// Serializes this UserFiestaModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of UserFiestaModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $UserFiestaModelCopyWith<UserFiestaModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserFiestaModelCopyWith<$Res> {
  factory $UserFiestaModelCopyWith(
    UserFiestaModel value,
    $Res Function(UserFiestaModel) then,
  ) = _$UserFiestaModelCopyWithImpl<$Res, UserFiestaModel>;
  @useResult
  $Res call({
    String? id,
    String? fiestaId,
    String? title,
    @LocationConverters() LocationModel? address,
    @TimestampConverter() DateTime? startAt,
    @TimestampConverter() DateTime? endAt,
    List<String>? pictures,
    bool? visibleAfter,
  });
}

/// @nodoc
class _$UserFiestaModelCopyWithImpl<$Res, $Val extends UserFiestaModel>
    implements $UserFiestaModelCopyWith<$Res> {
  _$UserFiestaModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of UserFiestaModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? fiestaId = freezed,
    Object? title = freezed,
    Object? address = freezed,
    Object? startAt = freezed,
    Object? endAt = freezed,
    Object? pictures = freezed,
    Object? visibleAfter = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: freezed == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String?,
            fiestaId: freezed == fiestaId
                ? _value.fiestaId
                : fiestaId // ignore: cast_nullable_to_non_nullable
                      as String?,
            title: freezed == title
                ? _value.title
                : title // ignore: cast_nullable_to_non_nullable
                      as String?,
            address: freezed == address
                ? _value.address
                : address // ignore: cast_nullable_to_non_nullable
                      as LocationModel?,
            startAt: freezed == startAt
                ? _value.startAt
                : startAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            endAt: freezed == endAt
                ? _value.endAt
                : endAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            pictures: freezed == pictures
                ? _value.pictures
                : pictures // ignore: cast_nullable_to_non_nullable
                      as List<String>?,
            visibleAfter: freezed == visibleAfter
                ? _value.visibleAfter
                : visibleAfter // ignore: cast_nullable_to_non_nullable
                      as bool?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$UserFiestaModelImplCopyWith<$Res>
    implements $UserFiestaModelCopyWith<$Res> {
  factory _$$UserFiestaModelImplCopyWith(
    _$UserFiestaModelImpl value,
    $Res Function(_$UserFiestaModelImpl) then,
  ) = __$$UserFiestaModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String? id,
    String? fiestaId,
    String? title,
    @LocationConverters() LocationModel? address,
    @TimestampConverter() DateTime? startAt,
    @TimestampConverter() DateTime? endAt,
    List<String>? pictures,
    bool? visibleAfter,
  });
}

/// @nodoc
class __$$UserFiestaModelImplCopyWithImpl<$Res>
    extends _$UserFiestaModelCopyWithImpl<$Res, _$UserFiestaModelImpl>
    implements _$$UserFiestaModelImplCopyWith<$Res> {
  __$$UserFiestaModelImplCopyWithImpl(
    _$UserFiestaModelImpl _value,
    $Res Function(_$UserFiestaModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of UserFiestaModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? fiestaId = freezed,
    Object? title = freezed,
    Object? address = freezed,
    Object? startAt = freezed,
    Object? endAt = freezed,
    Object? pictures = freezed,
    Object? visibleAfter = freezed,
  }) {
    return _then(
      _$UserFiestaModelImpl(
        id: freezed == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String?,
        fiestaId: freezed == fiestaId
            ? _value.fiestaId
            : fiestaId // ignore: cast_nullable_to_non_nullable
                  as String?,
        title: freezed == title
            ? _value.title
            : title // ignore: cast_nullable_to_non_nullable
                  as String?,
        address: freezed == address
            ? _value.address
            : address // ignore: cast_nullable_to_non_nullable
                  as LocationModel?,
        startAt: freezed == startAt
            ? _value.startAt
            : startAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        endAt: freezed == endAt
            ? _value.endAt
            : endAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        pictures: freezed == pictures
            ? _value._pictures
            : pictures // ignore: cast_nullable_to_non_nullable
                  as List<String>?,
        visibleAfter: freezed == visibleAfter
            ? _value.visibleAfter
            : visibleAfter // ignore: cast_nullable_to_non_nullable
                  as bool?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$UserFiestaModelImpl implements _UserFiestaModel {
  const _$UserFiestaModelImpl({
    this.id,
    this.fiestaId,
    this.title,
    @LocationConverters() this.address,
    @TimestampConverter() this.startAt,
    @TimestampConverter() this.endAt,
    final List<String>? pictures,
    this.visibleAfter,
  }) : _pictures = pictures;

  factory _$UserFiestaModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$UserFiestaModelImplFromJson(json);

  @override
  final String? id;
  @override
  final String? fiestaId;
  @override
  final String? title;
  @override
  @LocationConverters()
  final LocationModel? address;
  @override
  @TimestampConverter()
  final DateTime? startAt;
  @override
  @TimestampConverter()
  final DateTime? endAt;
  final List<String>? _pictures;
  @override
  List<String>? get pictures {
    final value = _pictures;
    if (value == null) return null;
    if (_pictures is EqualUnmodifiableListView) return _pictures;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  final bool? visibleAfter;

  @override
  String toString() {
    return 'UserFiestaModel(id: $id, fiestaId: $fiestaId, title: $title, address: $address, startAt: $startAt, endAt: $endAt, pictures: $pictures, visibleAfter: $visibleAfter)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UserFiestaModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.fiestaId, fiestaId) ||
                other.fiestaId == fiestaId) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.address, address) || other.address == address) &&
            (identical(other.startAt, startAt) || other.startAt == startAt) &&
            (identical(other.endAt, endAt) || other.endAt == endAt) &&
            const DeepCollectionEquality().equals(other._pictures, _pictures) &&
            (identical(other.visibleAfter, visibleAfter) ||
                other.visibleAfter == visibleAfter));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    fiestaId,
    title,
    address,
    startAt,
    endAt,
    const DeepCollectionEquality().hash(_pictures),
    visibleAfter,
  );

  /// Create a copy of UserFiestaModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UserFiestaModelImplCopyWith<_$UserFiestaModelImpl> get copyWith =>
      __$$UserFiestaModelImplCopyWithImpl<_$UserFiestaModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$UserFiestaModelImplToJson(this);
  }
}

abstract class _UserFiestaModel implements UserFiestaModel {
  const factory _UserFiestaModel({
    final String? id,
    final String? fiestaId,
    final String? title,
    @LocationConverters() final LocationModel? address,
    @TimestampConverter() final DateTime? startAt,
    @TimestampConverter() final DateTime? endAt,
    final List<String>? pictures,
    final bool? visibleAfter,
  }) = _$UserFiestaModelImpl;

  factory _UserFiestaModel.fromJson(Map<String, dynamic> json) =
      _$UserFiestaModelImpl.fromJson;

  @override
  String? get id;
  @override
  String? get fiestaId;
  @override
  String? get title;
  @override
  @LocationConverters()
  LocationModel? get address;
  @override
  @TimestampConverter()
  DateTime? get startAt;
  @override
  @TimestampConverter()
  DateTime? get endAt;
  @override
  List<String>? get pictures;
  @override
  bool? get visibleAfter;

  /// Create a copy of UserFiestaModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UserFiestaModelImplCopyWith<_$UserFiestaModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
