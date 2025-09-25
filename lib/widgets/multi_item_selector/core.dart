import 'package:core_kosmos/core_package.dart';
import 'package:twogather/widgets/multi_item_selector/model/item.dart';
import 'package:twogather/widgets/multi_item_selector/theme.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class MultiItemSelector extends StatefulHookConsumerWidget {
  final String? title;
  final List<MultiItemSelectorItem> items;
  final List<Map<String, dynamic>>? defaultActive;
  final Function(bool, String, List<String>)? onTapOnItem;

  /// Theme
  final TextStyle? titleStyle;
  final double? itemSpacing;
  final double? itemRunSpacing;
  final TextStyle? itemStyle;
  final TextStyle? itemActiveStyle;
  final EdgeInsetsGeometry? itemPadding;
  final BoxDecoration? itemDecoration;
  final BoxDecoration? itemActiveDecoration;

  final String? themeName;
  final MultiItemSelectorThemeData? theme;

  const MultiItemSelector({
    super.key,
    this.defaultActive,
    required this.items,
    this.title,
    this.onTapOnItem,
    this.titleStyle,
    this.theme,
    this.themeName,
    this.itemSpacing,
    this.itemRunSpacing,
    this.itemStyle,
    this.itemActiveStyle,
    this.itemPadding,
    this.itemDecoration,
    this.itemActiveDecoration,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      MultiItemSelectorState();
}

class MultiItemSelectorState extends ConsumerState<MultiItemSelector> {
  late final MultiItemSelectorThemeData _themeData;

  List<String> activeItem = [];

  @override
  void initState() {
    _themeData = loadThemeData(
      widget.theme,
      widget.themeName ?? "multi_item_selector",
      () => const MultiItemSelectorThemeData(),
    )!;
    activeItem =
        (widget.defaultActive?.map((e) => e["tag"] as String).toList()) ?? [];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.title != null) ...[
          Text(
            widget.title!,
            style:
                widget.titleStyle ??
                _themeData.titleStyle ??
                TextStyle(
                  fontSize: sp(12),
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                ),
          ),
          sh(7),
        ],
        SizedBox(
          width: double.infinity,
          child: Wrap(
            alignment: WrapAlignment.start,
            spacing: widget.itemSpacing ?? _themeData.itemSpacing ?? 0,
            runSpacing: widget.itemRunSpacing ?? _themeData.itemRunSpacing ?? 0,
            children: widget.items.map((item) {
              final isActive = activeItem.contains(item.tag);
              return InkWell(
                focusColor: Colors.transparent,
                hoverColor: Colors.transparent,
                splashColor: Colors.transparent,
                overlayColor: WidgetStateProperty.resolveWith(
                  (states) => Colors.transparent,
                ),
                highlightColor: Colors.transparent,
                onTap: () async {
                  if (activeItem.contains(item.tag)) {
                    setState(() => activeItem.remove(item.tag));
                    if (widget.onTapOnItem != null) {
                      widget.onTapOnItem!(false, item.tag, activeItem);
                    }
                  } else {
                    setState(() => activeItem.add(item.tag));
                    if (widget.onTapOnItem != null) {
                      widget.onTapOnItem!(true, item.tag, activeItem);
                    }
                  }
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: widget.itemPadding ?? _themeData.itemPadding,
                  decoration: isActive
                      ? widget.itemActiveDecoration ??
                            _themeData.itemActiveDecoration
                      : widget.itemDecoration ?? _themeData.itemDecoration,
                  child: Text(
                    item.name,
                    style: isActive
                        ? widget.itemActiveStyle ?? _themeData.itemActiveStyle
                        : widget.itemStyle ?? _themeData.itemStyle,
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  List<Map<String, dynamic>> getActiveItems() {
    List<Map<String, dynamic>> result = [];

    for (final e in activeItem) {
      // Vérifier que l'item existe encore dans la liste actuelle (filtrée)
      final item = widget.items.where((item) => item.tag == e).firstOrNull;
      if (item != null) {
        result.add({"tag": e, "name": item.name, "tags": item.tags});
      }
    }

    return result;
  }
}
