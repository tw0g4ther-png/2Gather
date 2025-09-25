import 'dart:io';

import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';
part 'itemOfassets.freezed.dart';

enum MediaType { image, video }

@freezed
class ItemOfAssets with _$ItemOfAssets {
  const factory ItemOfAssets({
    required AssetEntity assetEntity,
    String? messge,
    required GlobalKey globalKey,
    File? file,
    required MediaType mediaType,
  }) = _ItemOfAssets;
}
