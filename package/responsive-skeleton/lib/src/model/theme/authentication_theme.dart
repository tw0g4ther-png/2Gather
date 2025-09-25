import 'package:flutter/material.dart';

/// This class is used to create a [ThemeData] for the [AuthenticationPage] (login, create account, login with phone, ...).
///
/// {@category Theme}
class AuthenticationPageThemeData {
  /// Text style for the title of the page.
  /// @Nullable
  final TextStyle? titleStyle;

  /// Text style for the subtitle / text of the page.
  /// @Nullable
  final TextStyle? subTitleStyle;

  /// Text style for hint of text button.
  /// @Nullable
  final TextStyle? richTextStyle;

  /// Text style for text button.
  /// @Nullable
  final TextStyle? cliquableTextStyle;

  /// Spacing betweenn title and form
  /// @Nullable
  final double? titleSpacing;

  final double? formWidth;
  final double? popupRadius;

  final Color? resetPasswordEncocheColor;
  final Color? verifyNumberBox;
  final TextStyle? verifyNumberStyle;

  const AuthenticationPageThemeData({
    this.titleStyle,
    this.subTitleStyle,
    this.cliquableTextStyle,
    this.richTextStyle,
    this.titleSpacing,
    this.formWidth,
    this.resetPasswordEncocheColor,
    this.verifyNumberBox,
    this.popupRadius,
    this.verifyNumberStyle,
  });
}
