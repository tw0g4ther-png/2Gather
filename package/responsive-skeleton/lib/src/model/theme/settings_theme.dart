import 'package:flutter/material.dart';

class ResponsiveSettingsThemeData {
  final TextStyle? nameStyle;
  final TextStyle? subTitleStyle;
  final double verticalSpacing;
  final double verticalSectionSpacing;

  final double? cardBorderRadius;
  final double? cardWidth;

  final double? settingsLeftSpacing;
  final double? settingsRightSpacing;
  final double? settingsVeriticalSpacing;

  const ResponsiveSettingsThemeData({
    this.nameStyle,
    this.subTitleStyle,
    this.verticalSpacing = 7,
    this.verticalSectionSpacing = 17,
    this.cardBorderRadius,
    this.cardWidth,
    this.settingsLeftSpacing,
    this.settingsVeriticalSpacing,
    this.settingsRightSpacing,
  });
}
