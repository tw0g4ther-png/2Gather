// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'passion_listing.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

PassionListing _$PassionListingFromJson(Map<String, dynamic> json) {
  return _PassionListing.fromJson(json);
}

/// @nodoc
mixin _$PassionListing {
  List<PassionModel>? get drink => throw _privateConstructorUsedError;
  List<PassionModel>? get fiesta => throw _privateConstructorUsedError;
  List<PassionModel>? get music => throw _privateConstructorUsedError;
  List<PassionModel>? get passion => throw _privateConstructorUsedError;

  /// Serializes this PassionListing to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PassionListing
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PassionListingCopyWith<PassionListing> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PassionListingCopyWith<$Res> {
  factory $PassionListingCopyWith(
    PassionListing value,
    $Res Function(PassionListing) then,
  ) = _$PassionListingCopyWithImpl<$Res, PassionListing>;
  @useResult
  $Res call({
    List<PassionModel>? drink,
    List<PassionModel>? fiesta,
    List<PassionModel>? music,
    List<PassionModel>? passion,
  });
}

/// @nodoc
class _$PassionListingCopyWithImpl<$Res, $Val extends PassionListing>
    implements $PassionListingCopyWith<$Res> {
  _$PassionListingCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PassionListing
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? drink = freezed,
    Object? fiesta = freezed,
    Object? music = freezed,
    Object? passion = freezed,
  }) {
    return _then(
      _value.copyWith(
            drink: freezed == drink
                ? _value.drink
                : drink // ignore: cast_nullable_to_non_nullable
                      as List<PassionModel>?,
            fiesta: freezed == fiesta
                ? _value.fiesta
                : fiesta // ignore: cast_nullable_to_non_nullable
                      as List<PassionModel>?,
            music: freezed == music
                ? _value.music
                : music // ignore: cast_nullable_to_non_nullable
                      as List<PassionModel>?,
            passion: freezed == passion
                ? _value.passion
                : passion // ignore: cast_nullable_to_non_nullable
                      as List<PassionModel>?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$PassionListingImplCopyWith<$Res>
    implements $PassionListingCopyWith<$Res> {
  factory _$$PassionListingImplCopyWith(
    _$PassionListingImpl value,
    $Res Function(_$PassionListingImpl) then,
  ) = __$$PassionListingImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    List<PassionModel>? drink,
    List<PassionModel>? fiesta,
    List<PassionModel>? music,
    List<PassionModel>? passion,
  });
}

/// @nodoc
class __$$PassionListingImplCopyWithImpl<$Res>
    extends _$PassionListingCopyWithImpl<$Res, _$PassionListingImpl>
    implements _$$PassionListingImplCopyWith<$Res> {
  __$$PassionListingImplCopyWithImpl(
    _$PassionListingImpl _value,
    $Res Function(_$PassionListingImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of PassionListing
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? drink = freezed,
    Object? fiesta = freezed,
    Object? music = freezed,
    Object? passion = freezed,
  }) {
    return _then(
      _$PassionListingImpl(
        drink: freezed == drink
            ? _value._drink
            : drink // ignore: cast_nullable_to_non_nullable
                  as List<PassionModel>?,
        fiesta: freezed == fiesta
            ? _value._fiesta
            : fiesta // ignore: cast_nullable_to_non_nullable
                  as List<PassionModel>?,
        music: freezed == music
            ? _value._music
            : music // ignore: cast_nullable_to_non_nullable
                  as List<PassionModel>?,
        passion: freezed == passion
            ? _value._passion
            : passion // ignore: cast_nullable_to_non_nullable
                  as List<PassionModel>?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$PassionListingImpl implements _PassionListing {
  const _$PassionListingImpl({
    final List<PassionModel>? drink,
    final List<PassionModel>? fiesta,
    final List<PassionModel>? music,
    final List<PassionModel>? passion,
  }) : _drink = drink,
       _fiesta = fiesta,
       _music = music,
       _passion = passion;

  factory _$PassionListingImpl.fromJson(Map<String, dynamic> json) =>
      _$$PassionListingImplFromJson(json);

  final List<PassionModel>? _drink;
  @override
  List<PassionModel>? get drink {
    final value = _drink;
    if (value == null) return null;
    if (_drink is EqualUnmodifiableListView) return _drink;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  final List<PassionModel>? _fiesta;
  @override
  List<PassionModel>? get fiesta {
    final value = _fiesta;
    if (value == null) return null;
    if (_fiesta is EqualUnmodifiableListView) return _fiesta;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  final List<PassionModel>? _music;
  @override
  List<PassionModel>? get music {
    final value = _music;
    if (value == null) return null;
    if (_music is EqualUnmodifiableListView) return _music;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  final List<PassionModel>? _passion;
  @override
  List<PassionModel>? get passion {
    final value = _passion;
    if (value == null) return null;
    if (_passion is EqualUnmodifiableListView) return _passion;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  String toString() {
    return 'PassionListing(drink: $drink, fiesta: $fiesta, music: $music, passion: $passion)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PassionListingImpl &&
            const DeepCollectionEquality().equals(other._drink, _drink) &&
            const DeepCollectionEquality().equals(other._fiesta, _fiesta) &&
            const DeepCollectionEquality().equals(other._music, _music) &&
            const DeepCollectionEquality().equals(other._passion, _passion));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    const DeepCollectionEquality().hash(_drink),
    const DeepCollectionEquality().hash(_fiesta),
    const DeepCollectionEquality().hash(_music),
    const DeepCollectionEquality().hash(_passion),
  );

  /// Create a copy of PassionListing
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PassionListingImplCopyWith<_$PassionListingImpl> get copyWith =>
      __$$PassionListingImplCopyWithImpl<_$PassionListingImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$PassionListingImplToJson(this);
  }
}

abstract class _PassionListing implements PassionListing {
  const factory _PassionListing({
    final List<PassionModel>? drink,
    final List<PassionModel>? fiesta,
    final List<PassionModel>? music,
    final List<PassionModel>? passion,
  }) = _$PassionListingImpl;

  factory _PassionListing.fromJson(Map<String, dynamic> json) =
      _$PassionListingImpl.fromJson;

  @override
  List<PassionModel>? get drink;
  @override
  List<PassionModel>? get fiesta;
  @override
  List<PassionModel>? get music;
  @override
  List<PassionModel>? get passion;

  /// Create a copy of PassionListing
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PassionListingImplCopyWith<_$PassionListingImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
