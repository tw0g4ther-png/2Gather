import 'package:flutter/material.dart';

class ToggleSwitchThemeData {
  final Color? backgroundColor;
  final double? height;
  final EdgeInsetsGeometry? padding;
  final double? borderRadius;
  final Color? activeColor;
  final List<BoxShadow>? shadows;
  final TextStyle? itemStyle;
  final TextStyle? itemActiveStyle;

  const ToggleSwitchThemeData({
    this.backgroundColor,
    this.height,
    this.activeColor,
    this.borderRadius,
    this.padding,
    this.itemActiveStyle,
    this.itemStyle,
    this.shadows,
  });
}
