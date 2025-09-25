import 'package:flutter/material.dart';
import 'package:form_kosmos/src/utils.dart';
import 'package:ui_kosmos_v4/micro_element/theme.dart';

class FormWidgetThemeData {
  final FormScrollBar progressbarType;

  final TextStyle? titleStyle;
  final TextStyle? laterStyle;

  final ProgressBarThemeData? progressbarTheme;
  final double? progressBarHeight;

  const FormWidgetThemeData({
    this.progressbarType = FormScrollBar.separated,
    this.laterStyle,
    this.titleStyle,
    this.progressbarTheme,
    this.progressBarHeight,
  });
}
