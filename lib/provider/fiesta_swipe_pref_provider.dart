import 'package:flutter/material.dart';
import 'package:skeleton_kosmos/skeleton_kosmos.dart';

class FiestaSwipePrefProvider with ChangeNotifier {
  int visibilty = 50;
  LocationModel? location;
  String? fiestaType;

  void init() {}

  void setAge(int min, int max) {
    notifyListeners();
  }

  void setVisibility(int value) {
    visibilty = value;
    notifyListeners();
  }

  Map<String, dynamic> getMetadata() {
    return {
      "visibility": visibilty,
      "location": location?.toMap(),
      "fiesta_type": fiestaType,
    };
  }

  void reset() {
    visibilty = 50;
    location = null;
    fiestaType = null;
    notifyListeners();
  }

  void setFiestaType(String? value) {
    fiestaType = value;
    notifyListeners();
  }
}
