import 'package:core_kosmos/core_package.dart';

enum FormScrollBar {
  percent,
  step,
  separated,
}

abstract class FormUtils {
  static bool allFieldAreValid(Map<String, dynamic> data) {
    if (data["step"] == null) return true;

    for (final step in (data["step"] as List<dynamic>)) {
      if (step["fields"] == null) continue;
      for (final field in (step["fields"] as List<dynamic>)) {
        if (field["required"] == true && field["data"] == null) {
          printInDebug(field);
          return false;
        }
      }
    }

    return true;
  }
}
