import 'dart:io';

import 'package:flutter/material.dart';

class CompleteProfilProvider with ChangeNotifier {
  final PageController _pageController = PageController();
  PageController get pageController => _pageController;

  Map<String, dynamic> data = {};

  String? trustCode;

  List<File> profilImages = [];
  File? identityCard;

  int pageIndex = 0;

  void nextPage() {
    pageIndex++;
    _pageController.nextPage(duration: const Duration(milliseconds: 300), curve: Curves.easeIn);
    notifyListeners();
  }

  void prevPage() {
    pageIndex--;
    _pageController.previousPage(duration: const Duration(milliseconds: 300), curve: Curves.easeIn);
    notifyListeners();
  }

  void addFieldToData(String key, dynamic value) {
    data[key] = value;
  }

  void setTrustCode(String key) => trustCode = key;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void clear() {
    _pageController.dispose();
  }
}
