import 'package:flutter/material.dart';

class MultiImagePickerThemeData {
  final Color? deleteButtonColor;
  final double? itemSpacing;
  final double? itemRunSpacing;

  final EdgeInsetsGeometry? imageBoxPadding;
  final BorderRadiusGeometry? imageBoxBorderRadius;
  final Color? imageBoxColor;
  final double? imageBoxWidth;
  final double? imageBoxHeight;

  const MultiImagePickerThemeData({
    this.deleteButtonColor,
    this.itemRunSpacing,
    this.itemSpacing,
    this.imageBoxBorderRadius,
    this.imageBoxPadding,
    this.imageBoxColor,
    this.imageBoxHeight,
    this.imageBoxWidth,
  });
}
