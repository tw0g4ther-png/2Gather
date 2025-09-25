import 'package:flutter/material.dart';

class TinderCardThemeData {
  final TextStyle? titleStyle;

  final double? width;
  final double? height;
  final BorderRadiusGeometry? borderRadius;

  const TinderCardThemeData({
    this.titleStyle,

    /// Theme field
    this.width,
    this.height,
    this.borderRadius,
  });
}
