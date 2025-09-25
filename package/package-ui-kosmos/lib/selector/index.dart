import 'package:core_kosmos/core_kosmos.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:ui_kosmos_v4/checkbox/checkbox.dart';

import 'theme.dart';

class Selector extends HookWidget {
  final SelectorThemeData? theme;
  final String? content;
  final bool defaultChecked;
  final VoidCallback? onTap;
  final String? themeName;
  final Function(bool)? onChanged;

  const Selector({
    super.key,
    this.onChanged,
    this.theme,
    this.content,
    this.defaultChecked = false,
    this.onTap,
    this.themeName,
  });

  @override
  Widget build(BuildContext context) {
    var state = useState<bool>(defaultChecked);
    final themeData = loadThemeData(
      theme,
      themeName ?? "selector",
      () => const SelectorThemeData(),
    )!;

    return InkWell(
      onTap: () {
        state.value = !state.value;
        if (onChanged != null) onChanged!(state.value);
      },
      child: Container(
        width: double.infinity,
        constraints: BoxConstraints(
          maxWidth: getValueForPlatform(
            themeData.webMaxWidth,
            themeData.phoneMaxWidth,
          )!,
        ),
        child: Row(
          children: [
            CustomCheckbox.square(
              isChecked: state.value,
              theme: themeData.checkboxTheme,
            ),
            sw(themeData.spacing),
            Expanded(
              child: Text(
                content ?? "",
                style:
                    themeData.contentStyle ??
                    TextStyle(
                      fontSize: sp(11),
                      color: const Color(0xFF02132B).withValues(alpha: .6),
                    ),
                maxLines: themeData.maxLine,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
