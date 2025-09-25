import 'package:flutter/material.dart';

class MultiItemSelectorItem {
  final String name;
  final String tag;
  final Function(BuildContext)? onTap;
  final List<String>? tags;

  MultiItemSelectorItem({
    required this.name,
    required this.tag,
    this.tags,
    this.onTap,
  });
}
