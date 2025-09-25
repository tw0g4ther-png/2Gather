import 'dart:io';

import '../freezed/assetItem/itemOfassets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

final selectedAssets = ChangeNotifierProvider<SelectedAssets>((ref) {
  return SelectedAssets();
});

class SelectedAssets with ChangeNotifier {
  Map<int, ItemOfAssets> mapAssets = {};

  bool inPainting = false;
  int _index = 0;
  int get indexOfPageView => _index;

  final TextEditingController _textEditingController = TextEditingController();
  final PageController _pageController = PageController();
  PageController get pageController => _pageController;
  TextEditingController get textEditingController => _textEditingController;
  //
  void setIndex(int index) {
    _index = index;
    textEditingController.text = mapAssets[index]?.messge ?? "";
    notifyListeners();
  }

  void setPageIndex(int index) {
    setIndex(index);
    pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeIn,
    );
    notifyListeners();
  }

  void modifyCurrentMediaText(String val) {
    mapAssets[_index] = mapAssets[_index]!.copyWith(messge: val);
    notifyListeners();
  }

  void setPainter(bool inPaintinig) {
    inPainting = inPaintinig;
    notifyListeners();
  }

  void removeFromAssets(int index) {
    mapAssets.remove(index);
    mapAssets = mapAssets.values.toList().asMap().map(
      (key, value) => MapEntry(key, value),
    );
    notifyListeners();
  }

  void addFileToAssets(int index, {required File file}) {
    mapAssets[index] = mapAssets[index]!.copyWith(file: file);
    notifyListeners();
  }

  void setAssets(List<AssetEntity>? list) {
    debugPrint(
      "[SelectedAssets] setAssets appelé avec ${list?.length ?? 0} assets",
    );
    mapAssets =
        list?.asMap().map((key, value) {
          final mediaType = value.type == AssetType.image
              ? MediaType.image
              : MediaType.video;
          debugPrint(
            "[SelectedAssets] Asset $key: ${value.type} -> $mediaType",
          );
          return MapEntry(
            key,
            ItemOfAssets(
              assetEntity: value,
              globalKey: GlobalKey(),
              mediaType: mediaType,
            ),
          );
        }) ??
        {};
    debugPrint(
      "[SelectedAssets] mapAssets final: ${mapAssets.length} éléments",
    );
    notifyListeners();
  }
}
