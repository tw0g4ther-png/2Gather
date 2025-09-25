import "package:flutter/material.dart";

class MultiItemSelectorThemeData {
  final TextStyle? titleStyle;
  final double? itemSpacing;
  final double? itemRunSpacing;

  final TextStyle? itemStyle;
  final TextStyle? itemActiveStyle;
  final EdgeInsetsGeometry? itemPadding;
  final BoxDecoration? itemDecoration;
  final BoxDecoration? itemActiveDecoration;

  const MultiItemSelectorThemeData({
    this.titleStyle,
    this.itemRunSpacing,
    this.itemSpacing,
    this.itemStyle,
    this.itemActiveDecoration,
    this.itemDecoration,
    this.itemActiveStyle,
    this.itemPadding,
  });
}
