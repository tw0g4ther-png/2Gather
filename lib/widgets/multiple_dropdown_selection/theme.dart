import 'package:flutter/material.dart';

class DropDownMultiSelectThemeData {
  final BoxDecoration? childActiveDecoration;
  final BoxDecoration? childDecoration;
  final Color? checkedColor;
  final IconData? checkedIcon;
  final TextStyle? childTextStyle;
  final TextStyle? childActiveTextStyle;

  const DropDownMultiSelectThemeData({
    this.childActiveDecoration,
    this.childDecoration,
    this.checkedColor,
    this.checkedIcon,
    this.childTextStyle,
    this.childActiveTextStyle,
  });
}
