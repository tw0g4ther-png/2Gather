import 'package:flutter/material.dart';

class ResumedThemeData {
  final double? verticalTitleSpacing;
  final double? verticalFieldSpacing;

  /// Modify button
  final TextStyle? modifyTextStyle;
  final String? modifyIconPath;
  final Color? modifyIconColor;

  /// Title
  final TextStyle? titleStyle;
  final String? dateFormat;
  final TextStyle? dateStyle;

  /// Box Padding
  final EdgeInsets? sectionPadding;
  final double? verticalSectionSpacing;

  /// Main border
  final Color? borderColor;
  final double? borderWidth;

  final Color? backgroundColor;
  final TextStyle? stepTitleStyle;
  final BorderRadiusGeometry? borderRadius;

  final TextStyle? fieldTitleStyle;
  final TextStyle? fieldStyle;
  final TextStyle? fieldErrorStyle;

  final TextStyle? buttonStyle;

  const ResumedThemeData({
    this.borderColor,
    this.verticalFieldSpacing,
    this.borderWidth,
    this.sectionPadding,
    this.verticalSectionSpacing,
    this.verticalTitleSpacing,
    this.modifyTextStyle,
    this.modifyIconColor,
    this.modifyIconPath,
    this.titleStyle,
    this.dateFormat,
    this.dateStyle,
    this.backgroundColor,
    this.stepTitleStyle,
    this.borderRadius,
    this.fieldStyle,
    this.fieldTitleStyle,
    this.fieldErrorStyle,
    this.buttonStyle,
  });
}
