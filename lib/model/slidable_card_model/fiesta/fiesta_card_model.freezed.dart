// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'fiesta_card_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

FiestaCardModel _$FiestaCardModelFromJson(Map<String, dynamic> json) {
  return _FiestaCardModel.fromJson(json);
}

/// @nodoc
mixin _$FiestaCardModel {
  String? get id => throw _privateConstructorUsedError;
  AppUserModel? get host => throw _privateConstructorUsedError;

  /// Data of fiesta
  double? get totalPlace => throw _privateConstructorUsedError;
  double? get remainingPlace => throw _privateConstructorUsedError;
  @TimestampConverter()
  DateTime? get date => throw _privateConstructorUsedError;
  String? get name => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  List<String>? get photos => throw _privateConstructorUsedError;
  List<TagModel>? get tags => throw _privateConstructorUsedError;

  /// Serializes this FiestaCardModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of FiestaCardModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $FiestaCardModelCopyWith<FiestaCardModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FiestaCardModelCopyWith<$Res> {
  factory $FiestaCardModelCopyWith(
    FiestaCardModel value,
    $Res Function(FiestaCardModel) then,
  ) = _$FiestaCardModelCopyWithImpl<$Res, FiestaCardModel>;
  @useResult
  $Res call({
    String? id,
    AppUserModel? host,
    double? totalPlace,
    double? remainingPlace,
    @TimestampConverter() DateTime? date,
    String? name,
    String? description,
    List<String>? photos,
    List<TagModel>? tags,
  });

  $AppUserModelCopyWith<$Res>? get host;
}

/// @nodoc
class _$FiestaCardModelCopyWithImpl<$Res, $Val extends FiestaCardModel>
    implements $FiestaCardModelCopyWith<$Res> {
  _$FiestaCardModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of FiestaCardModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? host = freezed,
    Object? totalPlace = freezed,
    Object? remainingPlace = freezed,
    Object? date = freezed,
    Object? name = freezed,
    Object? description = freezed,
    Object? photos = freezed,
    Object? tags = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: freezed == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String?,
            host: freezed == host
                ? _value.host
                : host // ignore: cast_nullable_to_non_nullable
                      as AppUserModel?,
            totalPlace: freezed == totalPlace
                ? _value.totalPlace
                : totalPlace // ignore: cast_nullable_to_non_nullable
                      as double?,
            remainingPlace: freezed == remainingPlace
                ? _value.remainingPlace
                : remainingPlace // ignore: cast_nullable_to_non_nullable
                      as double?,
            date: freezed == date
                ? _value.date
                : date // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            name: freezed == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String?,
            description: freezed == description
                ? _value.description
                : description // ignore: cast_nullable_to_non_nullable
                      as String?,
            photos: freezed == photos
                ? _value.photos
                : photos // ignore: cast_nullable_to_non_nullable
                      as List<String>?,
            tags: freezed == tags
                ? _value.tags
                : tags // ignore: cast_nullable_to_non_nullable
                      as List<TagModel>?,
          )
          as $Val,
    );
  }

  /// Create a copy of FiestaCardModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $AppUserModelCopyWith<$Res>? get host {
    if (_value.host == null) {
      return null;
    }

    return $AppUserModelCopyWith<$Res>(_value.host!, (value) {
      return _then(_value.copyWith(host: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$FiestaCardModelImplCopyWith<$Res>
    implements $FiestaCardModelCopyWith<$Res> {
  factory _$$FiestaCardModelImplCopyWith(
    _$FiestaCardModelImpl value,
    $Res Function(_$FiestaCardModelImpl) then,
  ) = __$$FiestaCardModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String? id,
    AppUserModel? host,
    double? totalPlace,
    double? remainingPlace,
    @TimestampConverter() DateTime? date,
    String? name,
    String? description,
    List<String>? photos,
    List<TagModel>? tags,
  });

  @override
  $AppUserModelCopyWith<$Res>? get host;
}

/// @nodoc
class __$$FiestaCardModelImplCopyWithImpl<$Res>
    extends _$FiestaCardModelCopyWithImpl<$Res, _$FiestaCardModelImpl>
    implements _$$FiestaCardModelImplCopyWith<$Res> {
  __$$FiestaCardModelImplCopyWithImpl(
    _$FiestaCardModelImpl _value,
    $Res Function(_$FiestaCardModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of FiestaCardModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? host = freezed,
    Object? totalPlace = freezed,
    Object? remainingPlace = freezed,
    Object? date = freezed,
    Object? name = freezed,
    Object? description = freezed,
    Object? photos = freezed,
    Object? tags = freezed,
  }) {
    return _then(
      _$FiestaCardModelImpl(
        id: freezed == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String?,
        host: freezed == host
            ? _value.host
            : host // ignore: cast_nullable_to_non_nullable
                  as AppUserModel?,
        totalPlace: freezed == totalPlace
            ? _value.totalPlace
            : totalPlace // ignore: cast_nullable_to_non_nullable
                  as double?,
        remainingPlace: freezed == remainingPlace
            ? _value.remainingPlace
            : remainingPlace // ignore: cast_nullable_to_non_nullable
                  as double?,
        date: freezed == date
            ? _value.date
            : date // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        name: freezed == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String?,
        description: freezed == description
            ? _value.description
            : description // ignore: cast_nullable_to_non_nullable
                  as String?,
        photos: freezed == photos
            ? _value._photos
            : photos // ignore: cast_nullable_to_non_nullable
                  as List<String>?,
        tags: freezed == tags
            ? _value._tags
            : tags // ignore: cast_nullable_to_non_nullable
                  as List<TagModel>?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$FiestaCardModelImpl implements _FiestaCardModel {
  const _$FiestaCardModelImpl({
    this.id,
    this.host,
    this.totalPlace,
    this.remainingPlace,
    @TimestampConverter() this.date,
    this.name,
    this.description,
    final List<String>? photos,
    final List<TagModel>? tags,
  }) : _photos = photos,
       _tags = tags;

  factory _$FiestaCardModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$FiestaCardModelImplFromJson(json);

  @override
  final String? id;
  @override
  final AppUserModel? host;

  /// Data of fiesta
  @override
  final double? totalPlace;
  @override
  final double? remainingPlace;
  @override
  @TimestampConverter()
  final DateTime? date;
  @override
  final String? name;
  @override
  final String? description;
  final List<String>? _photos;
  @override
  List<String>? get photos {
    final value = _photos;
    if (value == null) return null;
    if (_photos is EqualUnmodifiableListView) return _photos;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  final List<TagModel>? _tags;
  @override
  List<TagModel>? get tags {
    final value = _tags;
    if (value == null) return null;
    if (_tags is EqualUnmodifiableListView) return _tags;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  String toString() {
    return 'FiestaCardModel(id: $id, host: $host, totalPlace: $totalPlace, remainingPlace: $remainingPlace, date: $date, name: $name, description: $description, photos: $photos, tags: $tags)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FiestaCardModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.host, host) || other.host == host) &&
            (identical(other.totalPlace, totalPlace) ||
                other.totalPlace == totalPlace) &&
            (identical(other.remainingPlace, remainingPlace) ||
                other.remainingPlace == remainingPlace) &&
            (identical(other.date, date) || other.date == date) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.description, description) ||
                other.description == description) &&
            const DeepCollectionEquality().equals(other._photos, _photos) &&
            const DeepCollectionEquality().equals(other._tags, _tags));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    host,
    totalPlace,
    remainingPlace,
    date,
    name,
    description,
    const DeepCollectionEquality().hash(_photos),
    const DeepCollectionEquality().hash(_tags),
  );

  /// Create a copy of FiestaCardModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$FiestaCardModelImplCopyWith<_$FiestaCardModelImpl> get copyWith =>
      __$$FiestaCardModelImplCopyWithImpl<_$FiestaCardModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$FiestaCardModelImplToJson(this);
  }
}

abstract class _FiestaCardModel implements FiestaCardModel {
  const factory _FiestaCardModel({
    final String? id,
    final AppUserModel? host,
    final double? totalPlace,
    final double? remainingPlace,
    @TimestampConverter() final DateTime? date,
    final String? name,
    final String? description,
    final List<String>? photos,
    final List<TagModel>? tags,
  }) = _$FiestaCardModelImpl;

  factory _FiestaCardModel.fromJson(Map<String, dynamic> json) =
      _$FiestaCardModelImpl.fromJson;

  @override
  String? get id;
  @override
  AppUserModel? get host;

  /// Data of fiesta
  @override
  double? get totalPlace;
  @override
  double? get remainingPlace;
  @override
  @TimestampConverter()
  DateTime? get date;
  @override
  String? get name;
  @override
  String? get description;
  @override
  List<String>? get photos;
  @override
  List<TagModel>? get tags;

  /// Create a copy of FiestaCardModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$FiestaCardModelImplCopyWith<_$FiestaCardModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
