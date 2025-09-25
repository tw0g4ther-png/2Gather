import 'package:flutter/material.dart';

class SlidableCardThemeData {
  final BorderRadiusGeometry? borderRadius;
  final Color? backgroundColor;
  final List<BoxShadow>? shadows;
  final BoxBorder? border;

  const SlidableCardThemeData({
    this.borderRadius,
    this.backgroundColor,
    this.shadows,
    this.border,
  });
}
