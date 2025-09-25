// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'friend_card_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

FriendCardModel _$FriendCardModelFromJson(Map<String, dynamic> json) {
  return _FriendCardModel.fromJson(json);
}

/// @nodoc
mixin _$FriendCardModel {
  String? get id => throw _privateConstructorUsedError;
  String? get name => throw _privateConstructorUsedError;
  List<String>? get photos => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  String? get country => throw _privateConstructorUsedError;
  @TimestampConverter()
  DateTime? get birthday => throw _privateConstructorUsedError;
  @GeoPointConverters()
  GeoPoint? get position => throw _privateConstructorUsedError;
  PassionListing? get tags => throw _privateConstructorUsedError;

  /// Serializes this FriendCardModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of FriendCardModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $FriendCardModelCopyWith<FriendCardModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FriendCardModelCopyWith<$Res> {
  factory $FriendCardModelCopyWith(
    FriendCardModel value,
    $Res Function(FriendCardModel) then,
  ) = _$FriendCardModelCopyWithImpl<$Res, FriendCardModel>;
  @useResult
  $Res call({
    String? id,
    String? name,
    List<String>? photos,
    String? description,
    String? country,
    @TimestampConverter() DateTime? birthday,
    @GeoPointConverters() GeoPoint? position,
    PassionListing? tags,
  });

  $PassionListingCopyWith<$Res>? get tags;
}

/// @nodoc
class _$FriendCardModelCopyWithImpl<$Res, $Val extends FriendCardModel>
    implements $FriendCardModelCopyWith<$Res> {
  _$FriendCardModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of FriendCardModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? name = freezed,
    Object? photos = freezed,
    Object? description = freezed,
    Object? country = freezed,
    Object? birthday = freezed,
    Object? position = freezed,
    Object? tags = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: freezed == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String?,
            name: freezed == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String?,
            photos: freezed == photos
                ? _value.photos
                : photos // ignore: cast_nullable_to_non_nullable
                      as List<String>?,
            description: freezed == description
                ? _value.description
                : description // ignore: cast_nullable_to_non_nullable
                      as String?,
            country: freezed == country
                ? _value.country
                : country // ignore: cast_nullable_to_non_nullable
                      as String?,
            birthday: freezed == birthday
                ? _value.birthday
                : birthday // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            position: freezed == position
                ? _value.position
                : position // ignore: cast_nullable_to_non_nullable
                      as GeoPoint?,
            tags: freezed == tags
                ? _value.tags
                : tags // ignore: cast_nullable_to_non_nullable
                      as PassionListing?,
          )
          as $Val,
    );
  }

  /// Create a copy of FriendCardModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $PassionListingCopyWith<$Res>? get tags {
    if (_value.tags == null) {
      return null;
    }

    return $PassionListingCopyWith<$Res>(_value.tags!, (value) {
      return _then(_value.copyWith(tags: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$FriendCardModelImplCopyWith<$Res>
    implements $FriendCardModelCopyWith<$Res> {
  factory _$$FriendCardModelImplCopyWith(
    _$FriendCardModelImpl value,
    $Res Function(_$FriendCardModelImpl) then,
  ) = __$$FriendCardModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String? id,
    String? name,
    List<String>? photos,
    String? description,
    String? country,
    @TimestampConverter() DateTime? birthday,
    @GeoPointConverters() GeoPoint? position,
    PassionListing? tags,
  });

  @override
  $PassionListingCopyWith<$Res>? get tags;
}

/// @nodoc
class __$$FriendCardModelImplCopyWithImpl<$Res>
    extends _$FriendCardModelCopyWithImpl<$Res, _$FriendCardModelImpl>
    implements _$$FriendCardModelImplCopyWith<$Res> {
  __$$FriendCardModelImplCopyWithImpl(
    _$FriendCardModelImpl _value,
    $Res Function(_$FriendCardModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of FriendCardModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? name = freezed,
    Object? photos = freezed,
    Object? description = freezed,
    Object? country = freezed,
    Object? birthday = freezed,
    Object? position = freezed,
    Object? tags = freezed,
  }) {
    return _then(
      _$FriendCardModelImpl(
        id: freezed == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String?,
        name: freezed == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String?,
        photos: freezed == photos
            ? _value._photos
            : photos // ignore: cast_nullable_to_non_nullable
                  as List<String>?,
        description: freezed == description
            ? _value.description
            : description // ignore: cast_nullable_to_non_nullable
                  as String?,
        country: freezed == country
            ? _value.country
            : country // ignore: cast_nullable_to_non_nullable
                  as String?,
        birthday: freezed == birthday
            ? _value.birthday
            : birthday // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        position: freezed == position
            ? _value.position
            : position // ignore: cast_nullable_to_non_nullable
                  as GeoPoint?,
        tags: freezed == tags
            ? _value.tags
            : tags // ignore: cast_nullable_to_non_nullable
                  as PassionListing?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$FriendCardModelImpl implements _FriendCardModel {
  const _$FriendCardModelImpl({
    this.id,
    this.name,
    final List<String>? photos,
    this.description,
    this.country,
    @TimestampConverter() this.birthday,
    @GeoPointConverters() this.position,
    this.tags,
  }) : _photos = photos;

  factory _$FriendCardModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$FriendCardModelImplFromJson(json);

  @override
  final String? id;
  @override
  final String? name;
  final List<String>? _photos;
  @override
  List<String>? get photos {
    final value = _photos;
    if (value == null) return null;
    if (_photos is EqualUnmodifiableListView) return _photos;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  final String? description;
  @override
  final String? country;
  @override
  @TimestampConverter()
  final DateTime? birthday;
  @override
  @GeoPointConverters()
  final GeoPoint? position;
  @override
  final PassionListing? tags;

  @override
  String toString() {
    return 'FriendCardModel(id: $id, name: $name, photos: $photos, description: $description, country: $country, birthday: $birthday, position: $position, tags: $tags)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FriendCardModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            const DeepCollectionEquality().equals(other._photos, _photos) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.country, country) || other.country == country) &&
            (identical(other.birthday, birthday) ||
                other.birthday == birthday) &&
            (identical(other.position, position) ||
                other.position == position) &&
            (identical(other.tags, tags) || other.tags == tags));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    name,
    const DeepCollectionEquality().hash(_photos),
    description,
    country,
    birthday,
    position,
    tags,
  );

  /// Create a copy of FriendCardModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$FriendCardModelImplCopyWith<_$FriendCardModelImpl> get copyWith =>
      __$$FriendCardModelImplCopyWithImpl<_$FriendCardModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$FriendCardModelImplToJson(this);
  }
}

abstract class _FriendCardModel implements FriendCardModel {
  const factory _FriendCardModel({
    final String? id,
    final String? name,
    final List<String>? photos,
    final String? description,
    final String? country,
    @TimestampConverter() final DateTime? birthday,
    @GeoPointConverters() final GeoPoint? position,
    final PassionListing? tags,
  }) = _$FriendCardModelImpl;

  factory _FriendCardModel.fromJson(Map<String, dynamic> json) =
      _$FriendCardModelImpl.fromJson;

  @override
  String? get id;
  @override
  String? get name;
  @override
  List<String>? get photos;
  @override
  String? get description;
  @override
  String? get country;
  @override
  @TimestampConverter()
  DateTime? get birthday;
  @override
  @GeoPointConverters()
  GeoPoint? get position;
  @override
  PassionListing? get tags;

  /// Create a copy of FriendCardModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$FriendCardModelImplCopyWith<_$FriendCardModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
