import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'permission_theme.freezed.dart';

@freezed
class PermissionThemeData with _$PermissionThemeData {
  const factory PermissionThemeData({
    final Size? assetSize,
    final TextStyle? titleStyle,
    final TextStyle? subTitleStyle,
    final Color? backgroundColor,
    final EdgeInsetsGeometry? pagePadding,
    // final Color? backButtonColor,
    // final TextStyle laterStyle,
    // final 
  }) = _PermissionThemeData;
}