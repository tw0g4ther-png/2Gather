import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final meModelChangeNotifier = ChangeNotifierProvider<MeModel>((ref) {
  return MeModel();
});

class MeModel with ChangeNotifier {
  String? _myUid;

  String? get myUid => _myUid;
  void setMyUid(String myUid) {
    _myUid = myUid;
    notifyListeners();
  }
}
