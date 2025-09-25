import 'package:core_kosmos/core_kosmos.dart';
import 'package:twogather/widgets/button/theme.dart';
import 'package:flutter/material.dart';

class Button extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;

  final BoxDecoration? decoration;
  final EdgeInsetsGeometry? padding;
  final BoxConstraints? constraints;
  final double? width;
  final double? height;

  final String? themeName;
  final CustomButtonThemeData? theme;

  const Button({
    super.key,
    required this.child,
    this.onTap,
    this.onLongPress,
    this.decoration,
    this.padding,
    this.constraints,
    this.width,
    this.height,
    this.themeName,
    this.theme,
  });

  @override
  State<Button> createState() => _ButtonState();
}

class _ButtonState extends State<Button> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    final themeData = loadThemeData(
      widget.theme,
      widget.themeName ?? "custom_buttonn",
      () => const CustomButtonThemeData(),
    );

    return InkWell(
      onTap: () {
        if (isLoading) return;
        isLoading = true;
        if (widget.onTap != null) {
          widget.onTap!();
        }
        isLoading = false;
      },
      onLongPress: widget.onLongPress,
      child: Container(
        decoration:
            widget.decoration ??
            themeData?.decoration ??
            BoxDecoration(
              borderRadius: BorderRadius.circular(formatWidth(50)),
              color: const Color(0xFFF0F0F0),
            ),
        padding: widget.padding ?? themeData?.padding,
        constraints: widget.constraints ?? themeData?.constraints,
        width: widget.width ?? themeData?.width,
        height: widget.height ?? themeData?.height,
        child: Center(child: widget.child),
      ),
    );
  }
}
