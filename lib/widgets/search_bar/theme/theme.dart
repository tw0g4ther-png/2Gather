import 'package:flutter/material.dart';

class CustomSearchBarThemeData {
  final Color backgroundColor;
  final TextStyle? hintStyle;
  final TextStyle? labelStyle;
  final BoxConstraints constraints;
  final double borderRadius;
  final Color iconColor;

  const CustomSearchBarThemeData({
    this.backgroundColor = const Color(0xFFF6F6F6),
    this.hintStyle = const TextStyle(
      color: Color(0xFFBBBBBB),
      fontSize: 15,
    ),
    this.labelStyle,
    this.constraints = const BoxConstraints(
      minHeight: 50,
      maxWidth: 320,
    ),
    this.borderRadius = 7,
    this.iconColor = const Color(0xFFBBBBBB),
  });
}
