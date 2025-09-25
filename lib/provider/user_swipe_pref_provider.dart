import 'package:core_kosmos/core_package.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:skeleton_kosmos/skeleton_kosmos.dart';

class UserSwipePrefProvider with ChangeNotifier {
  Tuple2<int, int> age = const Tuple2(18, 28);
  int visibilty = 50;
  LocationModel? location;

  void init() {}

  void setAge(int min, int max) {
    age = Tuple2(min, max);
    notifyListeners();
  }

  void setVisibility(int value) {
    printInDebug(value);
    visibilty = value;
    notifyListeners();
  }

  Map<String, dynamic> getMetadata() {
    return {
      "age_min": age.value1,
      "age_max": age.value2,
      "visibility": visibilty,
      "location": location?.geopoint,
    };
  }

  void reset() {
    age = const Tuple2(18, 28);
    visibilty = 50;
    location = null;
    notifyListeners();
  }
}
