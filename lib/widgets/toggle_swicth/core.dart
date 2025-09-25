import 'package:core_kosmos/core_package.dart';
import 'package:twogather/widgets/toggle_swicth/theme.dart';
import 'package:flutter/material.dart';

class ToggleItem {
  final String label;
  final VoidCallback? onTap;

  const ToggleItem({required this.label, this.onTap});
}

class ToggleSwicth extends StatefulWidget {
  final List<ToggleItem> items;
  final int? defaultIndex;
  final String? themeName;
  final ToggleSwitchThemeData? theme;
  final double? height;
  final EdgeInsetsGeometry? padding;
  final double? borderRadius;
  final Color? activeColor;
  final LinearGradient? activeGradient;
  final List<BoxShadow>? shadows;
  final TextStyle? itemStyle;
  final TextStyle? itemActiveStyle;
  final Color? backgroundColor;

  final List<Color>? customColors;

  const ToggleSwicth({
    super.key,
    required this.items,
    this.defaultIndex,
    this.theme,
    this.themeName,
    this.height,
    this.activeColor,
    this.activeGradient,
    this.borderRadius,
    this.padding,
    this.itemActiveStyle,
    this.itemStyle,
    this.shadows,
    this.backgroundColor,
    this.customColors,
  }) : assert(
         customColors != null ? customColors.length == items.length : true,
       );

  @override
  State<ToggleSwicth> createState() => _ToggleSwicthState();
}

class _ToggleSwicthState extends State<ToggleSwicth> {
  late final ToggleSwitchThemeData _themeData;

  late int _selectedIndex;

  @override
  void initState() {
    _themeData = loadThemeData(
      widget.theme,
      widget.themeName ?? "toggle_switch",
      () => const ToggleSwitchThemeData(),
    )!;
    _selectedIndex = widget.defaultIndex ?? 0;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (_, c) {
        final width = c.maxWidth / widget.items.length;

        return SizedBox(
          width: double.infinity,
          height: widget.height ?? _themeData.height,
          child: Stack(
            clipBehavior: Clip.antiAlias,
            children: [
              Container(
                width: double.infinity,
                height: widget.height ?? _themeData.height,
                decoration: BoxDecoration(
                  color:
                      widget.backgroundColor ??
                      _themeData.backgroundColor ??
                      const Color(0xFF02132B).withValues(alpha: .03),
                  borderRadius: BorderRadius.circular(
                    widget.borderRadius ?? _themeData.borderRadius ?? 21,
                  ),
                  boxShadow: widget.shadows ?? _themeData.shadows,
                ),
              ),
              AnimatedPositioned(
                duration: const Duration(milliseconds: 200),
                left: _selectedIndex * width,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: width,
                  height: widget.height ?? _themeData.height,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(
                      widget.borderRadius ?? _themeData.borderRadius ?? 21,
                    ),
                    color: widget.activeGradient != null
                        ? null
                        : _getCustomColor() ??
                              widget.activeColor ??
                              _themeData.activeColor ??
                              const Color(0xFF02132B).withValues(alpha: .3),
                    gradient: widget.activeGradient,
                  ),
                ),
              ),
              Container(
                width: double.infinity,
                height: widget.height ?? _themeData.height,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(
                    widget.borderRadius ?? _themeData.borderRadius ?? 21,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: widget.items.map((e) {
                    final index = widget.items.indexOf(e);
                    return Expanded(
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            _selectedIndex = index;
                          });
                          if (e.onTap != null) {
                            e.onTap!();
                          }
                        },
                        child: SizedBox(
                          width: double.infinity,
                          height: widget.height ?? _themeData.height,
                          child: Center(
                            child: AnimatedDefaultTextStyle(
                              duration: const Duration(milliseconds: 200),
                              style: !(_selectedIndex == index)
                                  ? widget.itemStyle ??
                                        _themeData.itemStyle ??
                                        const TextStyle()
                                  : widget.itemActiveStyle ??
                                        _themeData.itemActiveStyle ??
                                        widget.itemStyle ??
                                        _themeData.itemStyle ??
                                        const TextStyle(),
                              child: Text(e.label, textAlign: TextAlign.center),
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Color? _getCustomColor() {
    if (widget.customColors != null) {
      return widget.customColors![_selectedIndex];
    }
    return null;
  }
}
