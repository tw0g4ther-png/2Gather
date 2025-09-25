import 'package:core_kosmos/src/utils/core.dart';
import 'package:flutter/material.dart';

class AppTheme {
  Map<String, dynamic> theme = {};

  void addTheme<T>(String themeName, T newTheme) {
    if (theme[themeName] != null) {
      printInDebug("[Warning] theme $themeName already exist and will be override.");
    }
    theme[themeName] = newTheme;
  }

  T? fetchTheme<T>(String themeName) => theme[themeName];

  final ThemeData? themeData;

  AppTheme({this.themeData});
}
