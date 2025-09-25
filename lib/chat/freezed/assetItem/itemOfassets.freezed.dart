// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'itemOfassets.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$ItemOfAssets {
  AssetEntity get assetEntity => throw _privateConstructorUsedError;
  String? get messge => throw _privateConstructorUsedError;
  GlobalKey<State<StatefulWidget>> get globalKey =>
      throw _privateConstructorUsedError;
  File? get file => throw _privateConstructorUsedError;
  MediaType get mediaType => throw _privateConstructorUsedError;

  /// Create a copy of ItemOfAssets
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ItemOfAssetsCopyWith<ItemOfAssets> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ItemOfAssetsCopyWith<$Res> {
  factory $ItemOfAssetsCopyWith(
    ItemOfAssets value,
    $Res Function(ItemOfAssets) then,
  ) = _$ItemOfAssetsCopyWithImpl<$Res, ItemOfAssets>;
  @useResult
  $Res call({
    AssetEntity assetEntity,
    String? messge,
    GlobalKey<State<StatefulWidget>> globalKey,
    File? file,
    MediaType mediaType,
  });
}

/// @nodoc
class _$ItemOfAssetsCopyWithImpl<$Res, $Val extends ItemOfAssets>
    implements $ItemOfAssetsCopyWith<$Res> {
  _$ItemOfAssetsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ItemOfAssets
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? assetEntity = null,
    Object? messge = freezed,
    Object? globalKey = null,
    Object? file = freezed,
    Object? mediaType = null,
  }) {
    return _then(
      _value.copyWith(
            assetEntity: null == assetEntity
                ? _value.assetEntity
                : assetEntity // ignore: cast_nullable_to_non_nullable
                      as AssetEntity,
            messge: freezed == messge
                ? _value.messge
                : messge // ignore: cast_nullable_to_non_nullable
                      as String?,
            globalKey: null == globalKey
                ? _value.globalKey
                : globalKey // ignore: cast_nullable_to_non_nullable
                      as GlobalKey<State<StatefulWidget>>,
            file: freezed == file
                ? _value.file
                : file // ignore: cast_nullable_to_non_nullable
                      as File?,
            mediaType: null == mediaType
                ? _value.mediaType
                : mediaType // ignore: cast_nullable_to_non_nullable
                      as MediaType,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ItemOfAssetsImplCopyWith<$Res>
    implements $ItemOfAssetsCopyWith<$Res> {
  factory _$$ItemOfAssetsImplCopyWith(
    _$ItemOfAssetsImpl value,
    $Res Function(_$ItemOfAssetsImpl) then,
  ) = __$$ItemOfAssetsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    AssetEntity assetEntity,
    String? messge,
    GlobalKey<State<StatefulWidget>> globalKey,
    File? file,
    MediaType mediaType,
  });
}

/// @nodoc
class __$$ItemOfAssetsImplCopyWithImpl<$Res>
    extends _$ItemOfAssetsCopyWithImpl<$Res, _$ItemOfAssetsImpl>
    implements _$$ItemOfAssetsImplCopyWith<$Res> {
  __$$ItemOfAssetsImplCopyWithImpl(
    _$ItemOfAssetsImpl _value,
    $Res Function(_$ItemOfAssetsImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ItemOfAssets
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? assetEntity = null,
    Object? messge = freezed,
    Object? globalKey = null,
    Object? file = freezed,
    Object? mediaType = null,
  }) {
    return _then(
      _$ItemOfAssetsImpl(
        assetEntity: null == assetEntity
            ? _value.assetEntity
            : assetEntity // ignore: cast_nullable_to_non_nullable
                  as AssetEntity,
        messge: freezed == messge
            ? _value.messge
            : messge // ignore: cast_nullable_to_non_nullable
                  as String?,
        globalKey: null == globalKey
            ? _value.globalKey
            : globalKey // ignore: cast_nullable_to_non_nullable
                  as GlobalKey<State<StatefulWidget>>,
        file: freezed == file
            ? _value.file
            : file // ignore: cast_nullable_to_non_nullable
                  as File?,
        mediaType: null == mediaType
            ? _value.mediaType
            : mediaType // ignore: cast_nullable_to_non_nullable
                  as MediaType,
      ),
    );
  }
}

/// @nodoc

class _$ItemOfAssetsImpl implements _ItemOfAssets {
  const _$ItemOfAssetsImpl({
    required this.assetEntity,
    this.messge,
    required this.globalKey,
    this.file,
    required this.mediaType,
  });

  @override
  final AssetEntity assetEntity;
  @override
  final String? messge;
  @override
  final GlobalKey<State<StatefulWidget>> globalKey;
  @override
  final File? file;
  @override
  final MediaType mediaType;

  @override
  String toString() {
    return 'ItemOfAssets(assetEntity: $assetEntity, messge: $messge, globalKey: $globalKey, file: $file, mediaType: $mediaType)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ItemOfAssetsImpl &&
            (identical(other.assetEntity, assetEntity) ||
                other.assetEntity == assetEntity) &&
            (identical(other.messge, messge) || other.messge == messge) &&
            (identical(other.globalKey, globalKey) ||
                other.globalKey == globalKey) &&
            (identical(other.file, file) || other.file == file) &&
            (identical(other.mediaType, mediaType) ||
                other.mediaType == mediaType));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, assetEntity, messge, globalKey, file, mediaType);

  /// Create a copy of ItemOfAssets
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ItemOfAssetsImplCopyWith<_$ItemOfAssetsImpl> get copyWith =>
      __$$ItemOfAssetsImplCopyWithImpl<_$ItemOfAssetsImpl>(this, _$identity);
}

abstract class _ItemOfAssets implements ItemOfAssets {
  const factory _ItemOfAssets({
    required final AssetEntity assetEntity,
    final String? messge,
    required final GlobalKey<State<StatefulWidget>> globalKey,
    final File? file,
    required final MediaType mediaType,
  }) = _$ItemOfAssetsImpl;

  @override
  AssetEntity get assetEntity;
  @override
  String? get messge;
  @override
  GlobalKey<State<StatefulWidget>> get globalKey;
  @override
  File? get file;
  @override
  MediaType get mediaType;

  /// Create a copy of ItemOfAssets
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ItemOfAssetsImplCopyWith<_$ItemOfAssetsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
