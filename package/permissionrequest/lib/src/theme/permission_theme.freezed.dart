// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'permission_theme.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$PermissionThemeData {
  Size? get assetSize => throw _privateConstructorUsedError;
  TextStyle? get titleStyle => throw _privateConstructorUsedError;
  TextStyle? get subTitleStyle => throw _privateConstructorUsedError;
  Color? get backgroundColor => throw _privateConstructorUsedError;
  EdgeInsetsGeometry? get pagePadding => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $PermissionThemeDataCopyWith<PermissionThemeData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PermissionThemeDataCopyWith<$Res> {
  factory $PermissionThemeDataCopyWith(
          PermissionThemeData value, $Res Function(PermissionThemeData) then) =
      _$PermissionThemeDataCopyWithImpl<$Res>;
  $Res call(
      {Size? assetSize,
      TextStyle? titleStyle,
      TextStyle? subTitleStyle,
      Color? backgroundColor,
      EdgeInsetsGeometry? pagePadding});
}

/// @nodoc
class _$PermissionThemeDataCopyWithImpl<$Res>
    implements $PermissionThemeDataCopyWith<$Res> {
  _$PermissionThemeDataCopyWithImpl(this._value, this._then);

  final PermissionThemeData _value;
  // ignore: unused_field
  final $Res Function(PermissionThemeData) _then;

  @override
  $Res call({
    Object? assetSize = freezed,
    Object? titleStyle = freezed,
    Object? subTitleStyle = freezed,
    Object? backgroundColor = freezed,
    Object? pagePadding = freezed,
  }) {
    return _then(_value.copyWith(
      assetSize: assetSize == freezed
          ? _value.assetSize
          : assetSize // ignore: cast_nullable_to_non_nullable
              as Size?,
      titleStyle: titleStyle == freezed
          ? _value.titleStyle
          : titleStyle // ignore: cast_nullable_to_non_nullable
              as TextStyle?,
      subTitleStyle: subTitleStyle == freezed
          ? _value.subTitleStyle
          : subTitleStyle // ignore: cast_nullable_to_non_nullable
              as TextStyle?,
      backgroundColor: backgroundColor == freezed
          ? _value.backgroundColor
          : backgroundColor // ignore: cast_nullable_to_non_nullable
              as Color?,
      pagePadding: pagePadding == freezed
          ? _value.pagePadding
          : pagePadding // ignore: cast_nullable_to_non_nullable
              as EdgeInsetsGeometry?,
    ));
  }
}

/// @nodoc
abstract class _$$_PermissionThemeDataCopyWith<$Res>
    implements $PermissionThemeDataCopyWith<$Res> {
  factory _$$_PermissionThemeDataCopyWith(_$_PermissionThemeData value,
          $Res Function(_$_PermissionThemeData) then) =
      __$$_PermissionThemeDataCopyWithImpl<$Res>;
  @override
  $Res call(
      {Size? assetSize,
      TextStyle? titleStyle,
      TextStyle? subTitleStyle,
      Color? backgroundColor,
      EdgeInsetsGeometry? pagePadding});
}

/// @nodoc
class __$$_PermissionThemeDataCopyWithImpl<$Res>
    extends _$PermissionThemeDataCopyWithImpl<$Res>
    implements _$$_PermissionThemeDataCopyWith<$Res> {
  __$$_PermissionThemeDataCopyWithImpl(_$_PermissionThemeData _value,
      $Res Function(_$_PermissionThemeData) _then)
      : super(_value, (v) => _then(v as _$_PermissionThemeData));

  @override
  _$_PermissionThemeData get _value => super._value as _$_PermissionThemeData;

  @override
  $Res call({
    Object? assetSize = freezed,
    Object? titleStyle = freezed,
    Object? subTitleStyle = freezed,
    Object? backgroundColor = freezed,
    Object? pagePadding = freezed,
  }) {
    return _then(_$_PermissionThemeData(
      assetSize: assetSize == freezed
          ? _value.assetSize
          : assetSize // ignore: cast_nullable_to_non_nullable
              as Size?,
      titleStyle: titleStyle == freezed
          ? _value.titleStyle
          : titleStyle // ignore: cast_nullable_to_non_nullable
              as TextStyle?,
      subTitleStyle: subTitleStyle == freezed
          ? _value.subTitleStyle
          : subTitleStyle // ignore: cast_nullable_to_non_nullable
              as TextStyle?,
      backgroundColor: backgroundColor == freezed
          ? _value.backgroundColor
          : backgroundColor // ignore: cast_nullable_to_non_nullable
              as Color?,
      pagePadding: pagePadding == freezed
          ? _value.pagePadding
          : pagePadding // ignore: cast_nullable_to_non_nullable
              as EdgeInsetsGeometry?,
    ));
  }
}

/// @nodoc

class _$_PermissionThemeData implements _PermissionThemeData {
  const _$_PermissionThemeData(
      {this.assetSize,
      this.titleStyle,
      this.subTitleStyle,
      this.backgroundColor,
      this.pagePadding});

  @override
  final Size? assetSize;
  @override
  final TextStyle? titleStyle;
  @override
  final TextStyle? subTitleStyle;
  @override
  final Color? backgroundColor;
  @override
  final EdgeInsetsGeometry? pagePadding;

  @override
  String toString() {
    return 'PermissionThemeData(assetSize: $assetSize, titleStyle: $titleStyle, subTitleStyle: $subTitleStyle, backgroundColor: $backgroundColor, pagePadding: $pagePadding)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_PermissionThemeData &&
            const DeepCollectionEquality().equals(other.assetSize, assetSize) &&
            const DeepCollectionEquality()
                .equals(other.titleStyle, titleStyle) &&
            const DeepCollectionEquality()
                .equals(other.subTitleStyle, subTitleStyle) &&
            const DeepCollectionEquality()
                .equals(other.backgroundColor, backgroundColor) &&
            const DeepCollectionEquality()
                .equals(other.pagePadding, pagePadding));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(assetSize),
      const DeepCollectionEquality().hash(titleStyle),
      const DeepCollectionEquality().hash(subTitleStyle),
      const DeepCollectionEquality().hash(backgroundColor),
      const DeepCollectionEquality().hash(pagePadding));

  @JsonKey(ignore: true)
  @override
  _$$_PermissionThemeDataCopyWith<_$_PermissionThemeData> get copyWith =>
      __$$_PermissionThemeDataCopyWithImpl<_$_PermissionThemeData>(
          this, _$identity);
}

abstract class _PermissionThemeData implements PermissionThemeData {
  const factory _PermissionThemeData(
      {final Size? assetSize,
      final TextStyle? titleStyle,
      final TextStyle? subTitleStyle,
      final Color? backgroundColor,
      final EdgeInsetsGeometry? pagePadding}) = _$_PermissionThemeData;

  @override
  Size? get assetSize;
  @override
  TextStyle? get titleStyle;
  @override
  TextStyle? get subTitleStyle;
  @override
  Color? get backgroundColor;
  @override
  EdgeInsetsGeometry? get pagePadding;
  @override
  @JsonKey(ignore: true)
  _$$_PermissionThemeDataCopyWith<_$_PermissionThemeData> get copyWith =>
      throw _privateConstructorUsedError;
}
