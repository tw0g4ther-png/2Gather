// ignore_for_file: unnecessary_null_in_if_null_operators

import 'dart:io';

import 'package:core_kosmos/src/theme/app_theme.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

T execInCaseOfPlatfom<T>(Function fnWeb, Function fnMobile) {
  if (!kIsWeb && (Platform.isAndroid || Platform.isIOS)) {
    return fnMobile();
  } else {
    return fnWeb();
  }
}

T? getValueForPlatform<T>(T? val1, T? val2) => execInCaseOfPlatfom(() => val1, () => val2);

void printInDebug(dynamic obj) {
  if (kDebugMode) {
    debugPrint(obj.toString());
  }
}

void execAfterBuild(Function fn) => WidgetsBinding.instance.addPostFrameCallback((_) => fn());

T? loadThemeData<T>(T? theme, String themeName, T Function() constructor) {
  return theme ?? (GetIt.instance.isRegistered<AppTheme>() ? GetIt.instance<AppTheme>().fetchTheme<T>(themeName) : null) ?? constructor() ?? theme;
}

String? enumToString<T>(T actual) {
  return actual.toString().split(".").last;
}
