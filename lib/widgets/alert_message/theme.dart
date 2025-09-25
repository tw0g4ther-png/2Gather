import 'package:flutter/material.dart';

enum AlertMessageType {
  warning,
  info,
  success,
  error,
}

class AlertMessageThemeData {
  final Color? backgroundColor;
  final TextStyle? textStyle;
  final Color? iconColor;
  final BorderRadiusGeometry? borderRadius;
  final BoxConstraints? constraints;
  final List<BoxShadow>? shadows;
  final EdgeInsetsGeometry? padding;
  final TextAlign? textAlign;

  const AlertMessageThemeData({
    this.backgroundColor,
    this.borderRadius,
    this.constraints,
    this.iconColor,
    this.padding,
    this.shadows,
    this.textStyle,
    this.textAlign,
  });
}
