// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'passion_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

PassionModel _$PassionModelFromJson(Map<String, dynamic> json) {
  return _PassionModel.fromJson(json);
}

/// @nodoc
mixin _$PassionModel {
  String? get name => throw _privateConstructorUsedError;
  String? get tag => throw _privateConstructorUsedError;
  List<String>? get tags => throw _privateConstructorUsedError;

  /// Serializes this PassionModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PassionModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PassionModelCopyWith<PassionModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PassionModelCopyWith<$Res> {
  factory $PassionModelCopyWith(
    PassionModel value,
    $Res Function(PassionModel) then,
  ) = _$PassionModelCopyWithImpl<$Res, PassionModel>;
  @useResult
  $Res call({String? name, String? tag, List<String>? tags});
}

/// @nodoc
class _$PassionModelCopyWithImpl<$Res, $Val extends PassionModel>
    implements $PassionModelCopyWith<$Res> {
  _$PassionModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PassionModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = freezed,
    Object? tag = freezed,
    Object? tags = freezed,
  }) {
    return _then(
      _value.copyWith(
            name: freezed == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String?,
            tag: freezed == tag
                ? _value.tag
                : tag // ignore: cast_nullable_to_non_nullable
                      as String?,
            tags: freezed == tags
                ? _value.tags
                : tags // ignore: cast_nullable_to_non_nullable
                      as List<String>?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$PassionModelImplCopyWith<$Res>
    implements $PassionModelCopyWith<$Res> {
  factory _$$PassionModelImplCopyWith(
    _$PassionModelImpl value,
    $Res Function(_$PassionModelImpl) then,
  ) = __$$PassionModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String? name, String? tag, List<String>? tags});
}

/// @nodoc
class __$$PassionModelImplCopyWithImpl<$Res>
    extends _$PassionModelCopyWithImpl<$Res, _$PassionModelImpl>
    implements _$$PassionModelImplCopyWith<$Res> {
  __$$PassionModelImplCopyWithImpl(
    _$PassionModelImpl _value,
    $Res Function(_$PassionModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of PassionModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = freezed,
    Object? tag = freezed,
    Object? tags = freezed,
  }) {
    return _then(
      _$PassionModelImpl(
        name: freezed == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String?,
        tag: freezed == tag
            ? _value.tag
            : tag // ignore: cast_nullable_to_non_nullable
                  as String?,
        tags: freezed == tags
            ? _value._tags
            : tags // ignore: cast_nullable_to_non_nullable
                  as List<String>?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$PassionModelImpl implements _PassionModel {
  const _$PassionModelImpl({this.name, this.tag, final List<String>? tags})
    : _tags = tags;

  factory _$PassionModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$PassionModelImplFromJson(json);

  @override
  final String? name;
  @override
  final String? tag;
  final List<String>? _tags;
  @override
  List<String>? get tags {
    final value = _tags;
    if (value == null) return null;
    if (_tags is EqualUnmodifiableListView) return _tags;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  String toString() {
    return 'PassionModel(name: $name, tag: $tag, tags: $tags)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PassionModelImpl &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.tag, tag) || other.tag == tag) &&
            const DeepCollectionEquality().equals(other._tags, _tags));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    name,
    tag,
    const DeepCollectionEquality().hash(_tags),
  );

  /// Create a copy of PassionModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PassionModelImplCopyWith<_$PassionModelImpl> get copyWith =>
      __$$PassionModelImplCopyWithImpl<_$PassionModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PassionModelImplToJson(this);
  }
}

abstract class _PassionModel implements PassionModel {
  const factory _PassionModel({
    final String? name,
    final String? tag,
    final List<String>? tags,
  }) = _$PassionModelImpl;

  factory _PassionModel.fromJson(Map<String, dynamic> json) =
      _$PassionModelImpl.fromJson;

  @override
  String? get name;
  @override
  String? get tag;
  @override
  List<String>? get tags;

  /// Create a copy of PassionModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PassionModelImplCopyWith<_$PassionModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
