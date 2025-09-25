import 'package:core_kosmos/core_kosmos.dart';
import 'package:flutter/material.dart';
import 'package:ui_kosmos_v4/cta/theme.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:ui_kosmos_v4/micro_element/micro_element.dart';

abstract class CTA extends HookWidget {
  final double? height;
  final bool? isEnabled;
  final double? width;
  final double? radius;
  final Widget? child;
  final IconData? beforeIcon;
  final IconData? afterIcon;
  final IconData? backIcon;
  final String? textButton;
  final TextStyle? textButtonStyle;
  final double? distanceBetweenIconText;
  final Function? onTap;
  final VoidCallback? onDoubleTap;
  final bool circleOnTap;
  final Color? backgroundColor;
  final Icon? icon;
  final CtaThemeData? theme;
  final String? themeName;
  final List<BoxShadow>? shadows;
  final BoxBorder? border;
  final LinearGradient? gradient;
  final bool loading;
  final Color? iconColor;

  const CTA({
    this.height,
    this.isEnabled,
    this.width,
    this.radius,
    this.distanceBetweenIconText,
    this.child,
    this.beforeIcon,
    this.afterIcon,
    this.textButton,
    this.textButtonStyle,
    this.onTap,
    this.onDoubleTap,
    this.backIcon,
    this.circleOnTap = false,
    this.backgroundColor,
    this.icon,
    this.theme,
    this.themeName,
    this.border,
    this.gradient,
    this.loading = false,
    this.iconColor,
    this.shadows,
    super.key,
  });

  const factory CTA.primary({
    final double? height,
    final double? width,
    final double? radius,
    final bool? isEnabled,
    final Widget? child,
    final IconData? beforeIcon,
    final IconData? afterIcon,
    final String? textButton,
    final TextStyle? textButtonStyle,
    final double? distanceBetweenIconText,
    final Function? onTap,
    final VoidCallback? onDoubleTap,
    final Color? backgroundColor,
    final CtaThemeData? theme,
    final String? themeName,
    final BoxBorder? border,
    final LinearGradient? gradient,
    final bool loading,
    final List<BoxShadow>? shadows,
  }) = _Primary;

  const factory CTA.secondary({
    final double? height,
    final double? width,
    final double? radius,
    final Widget? child,
    final bool? isEnabled,
    final IconData? beforeIcon,
    final IconData? afterIcon,
    final String? textButton,
    final TextStyle? textButtonStyle,
    final double? distanceBetweenIconText,
    final Function? onTap,
    final VoidCallback? onDoubleTap,
    final Color? backgroundColor,
    final CtaThemeData? theme,
    final String? themeName,
    final BoxBorder? border,
    final LinearGradient? gradient,
    final bool loading,
  }) = _Secondary;

  const factory CTA.tiers({
    final double? height,
    final double? width,
    final double? radiusOnTap,
    final bool circleOnTap,
    final Function? onTap,
    final VoidCallback? onDoubleTap,
    final String? textButton,
    final TextStyle? textButtonStyle,
    final Widget? child,
    final Icon? icon,
    final Color? backgroundColor,
    final CtaThemeData? theme,
    final bool? isEnabled,
    final String? themeName,
    final BoxBorder? border,
  }) = _Tiers;

  const factory CTA.back({
    final double? height,
    final bool? isEnabled,
    final double? radius,
    final Function? onTap,
    final double? width,
    final VoidCallback? onDoubleTap,
    final IconData? backIcon,
    final Color backgroundColor,
    final CtaThemeData? theme,
    final String? themeName,
    final BoxBorder? border,
    final Color? iconColor,
  }) = _Back;

  @override
  Widget build(BuildContext context) => Container();
}

class _Primary extends CTA {
  const _Primary({
    super.height,
    super.width,
    super.radius,
    super.isEnabled,
    super.child,
    super.beforeIcon,
    super.afterIcon,
    super.textButton,
    super.textButtonStyle,
    super.distanceBetweenIconText,
    super.onTap,
    super.onDoubleTap,
    super.backgroundColor,
    super.theme,
    super.themeName,
    super.border,
    super.gradient,
    super.shadows,
    super.loading,
  });

  @override
  Widget build(BuildContext context) {
    final themeData = loadThemeData(
      theme,
      themeName ?? "primary_button",
      () => const CtaThemeData(),
    )!;
    var state = useState(false);
    bool mounted() => context.mounted;

    return Material(
      type: MaterialType.transparency,
      child: Opacity(
        opacity: isEnabled == null ? 1 : (isEnabled! ? 1 : 0.5),
        child: InkWell(
          borderRadius: BorderRadius.circular(
            radius ?? themeData.borderRadius ?? 7,
          ),
          onTap: isEnabled == null || isEnabled!
              ? () async {
                  if (state.value) return;
                  if (!mounted()) return;
                  state.value = true;
                  if (onTap != null) await onTap!();
                  if (!mounted()) return;
                  state.value = false;
                }
              : null,
          onDoubleTap: onDoubleTap,
          child: Container(
            height: formatHeight(
              height ??
                  getResponsiveValue(
                    context,
                    defaultValue: 54,
                    desktop: themeData.heightInWeb,
                    phone: themeData.heightInMobile,
                  ),
            ),
            width: formatWidth(
              width ??
                  getResponsiveValue(
                    context,
                    defaultValue: double.infinity,
                    desktop: themeData.widthInWeb,
                    phone: themeData.widthInMobile,
                  ),
            ),
            constraints: themeData.constraints,
            decoration: BoxDecoration(
              color:
                  backgroundColor ??
                  themeData.backgroundColor ??
                  (gradient != null ? null : Theme.of(context).primaryColor),
              gradient: gradient ?? themeData.gradient,
              borderRadius: BorderRadius.circular(
                radius ?? themeData.borderRadius ?? 7,
              ),
              border: border ?? themeData.border,
              boxShadow: shadows ?? themeData.shadows,
            ),
            child: Material(
              type: MaterialType.transparency,
              child: InkWell(
                borderRadius: BorderRadius.circular(
                  radius ?? themeData.borderRadius ?? 7,
                ),
                onTap: isEnabled == null || isEnabled!
                    ? () async {
                        if (!mounted()) return;
                        state.value = true;
                        if (onTap != null) await onTap!();
                        if (!mounted()) return;
                        state.value = false;
                      }
                    : null,
                onDoubleTap: onDoubleTap,
                child: state.value
                    ? Center(
                        child: LoaderClassique(
                          radius:
                              (height ??
                                  getResponsiveValue(
                                    context,
                                    defaultValue: 54,
                                    desktop: themeData.heightInWeb,
                                    phone: themeData.heightInMobile,
                                  ))! /
                              5,
                          activeColor: themeData.loaderColor,
                        ),
                      )
                    : child ??
                          (!loading
                              ? Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    beforeIcon != null
                                        ? Icon(beforeIcon, color: Colors.white)
                                        : const SizedBox(),
                                    SizedBox(
                                      width: beforeIcon != null
                                          ? distanceBetweenIconText ??
                                                themeData
                                                    .distanceBetweenIconText ??
                                                10
                                          : 0,
                                    ),
                                    Text(
                                      textButton ?? 'Button_Text',
                                      style:
                                          textButtonStyle ??
                                          themeData.textButtonStyle ??
                                          const TextStyle(color: Colors.white),
                                    ),
                                    SizedBox(
                                      width: afterIcon != null
                                          ? distanceBetweenIconText ??
                                                themeData
                                                    .distanceBetweenIconText ??
                                                10
                                          : 0,
                                    ),
                                    afterIcon != null
                                        ? Icon(afterIcon, color: Colors.white)
                                        : const SizedBox(),
                                  ],
                                )
                              : Transform.scale(
                                  scale: 0.6,
                                  child: const LoaderClassique(
                                    activeColor: Colors.white,
                                  ),
                                )),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _Secondary extends CTA {
  const _Secondary({
    super.height,
    super.width,
    super.isEnabled,
    super.radius,
    super.child,
    super.beforeIcon,
    super.afterIcon,
    super.textButton,
    super.textButtonStyle,
    super.distanceBetweenIconText,
    super.onTap,
    super.onDoubleTap,
    super.backgroundColor,
    super.theme,
    super.themeName,
    super.border,
    super.gradient,
    super.loading,
  });

  @override
  Widget build(BuildContext context) {
    final themeData = loadThemeData(
      theme,
      themeName ?? "secondary_button",
      () => const CtaThemeData(),
    )!;
    var state = useState(false);
    bool mounted() => context.mounted;

    return Material(
      type: MaterialType.transparency,
      child: Opacity(
        opacity: isEnabled == null ? 1 : (isEnabled! ? 1 : 0.5),
        child: InkWell(
          borderRadius: BorderRadius.circular(
            radius ?? themeData.borderRadius ?? 7,
          ),
          onTap: isEnabled == null || isEnabled!
              ? () async {
                  if (!mounted()) return;
                  state.value = true;
                  if (onTap != null) await onTap!();
                  if (!mounted()) return;
                  state.value = false;
                }
              : null,
          onDoubleTap: onDoubleTap,
          child: Container(
            height: formatHeight(
              height ??
                  getResponsiveValue(
                    context,
                    defaultValue: 54,
                    desktop: themeData.heightInWeb,
                    phone: themeData.heightInMobile,
                  ),
            ),
            width: formatWidth(
              width ??
                  getResponsiveValue(
                    context,
                    defaultValue: double.infinity,
                    desktop: themeData.widthInWeb,
                    phone: themeData.widthInMobile,
                  ),
            ),
            constraints: themeData.constraints,
            decoration: BoxDecoration(
              color:
                  backgroundColor ??
                  themeData.backgroundColor ??
                  Colors.grey.withValues(alpha: 0.15),
              gradient: gradient ?? themeData.gradient,
              borderRadius: BorderRadius.circular(
                radius ?? themeData.borderRadius ?? 7,
              ),
              border: border ?? themeData.border,
            ),
            child: Material(
              type: MaterialType.transparency,
              child: InkWell(
                borderRadius: BorderRadius.circular(
                  radius ?? themeData.borderRadius ?? 7,
                ),
                onTap: isEnabled == null || isEnabled!
                    ? () async {
                        if (state.value == true) return;
                        if (!mounted()) return;
                        state.value = true;
                        if (onTap != null) await onTap!();
                        if (!mounted()) return;
                        state.value = false;
                      }
                    : null,
                onDoubleTap: onDoubleTap,
                child: state.value
                    ? Center(
                        child: LoaderClassique(
                          radius:
                              (height ??
                                  getResponsiveValue(
                                    context,
                                    defaultValue: 54,
                                    desktop: themeData.heightInWeb,
                                    phone: themeData.heightInMobile,
                                  ))! /
                              5,
                          activeColor: themeData.loaderColor,
                        ),
                      )
                    : child ??
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              beforeIcon != null
                                  ? Icon(
                                      beforeIcon,
                                      color:
                                          textButtonStyle?.color ??
                                          themeData.textButtonStyle?.color ??
                                          Colors.white,
                                    )
                                  : const SizedBox(),
                              SizedBox(
                                width: beforeIcon != null
                                    ? distanceBetweenIconText ??
                                          themeData.distanceBetweenIconText ??
                                          10
                                    : 0,
                              ),
                              Text(
                                textButton ?? 'Button_Text',
                                style:
                                    textButtonStyle ??
                                    themeData.textButtonStyle ??
                                    const TextStyle(color: Colors.white),
                              ),
                              SizedBox(
                                width: afterIcon != null
                                    ? distanceBetweenIconText ??
                                          themeData.distanceBetweenIconText ??
                                          10
                                    : 0,
                              ),
                              afterIcon != null
                                  ? Icon(
                                      afterIcon,
                                      color:
                                          textButtonStyle?.color ??
                                          themeData.textButtonStyle?.color ??
                                          Colors.white,
                                    )
                                  : const SizedBox(),
                            ],
                          ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _Tiers extends CTA {
  const _Tiers({
    super.height,
    super.width,
    final double? radiusOnTap,
    super.isEnabled,
    super.circleOnTap,
    super.child,
    super.icon,
    super.onTap,
    super.onDoubleTap,
    super.textButton,
    super.textButtonStyle,
    super.backgroundColor,
    super.theme,
    super.themeName,
    super.border,
  }) : super(radius: radiusOnTap);

  @override
  Widget build(BuildContext context) {
    final themeData = loadThemeData(
      theme,
      themeName ?? "tiers_button",
      () => const CtaThemeData(),
    )!;
    return Material(
      type: MaterialType.transparency,
      child: Opacity(
        opacity: isEnabled == null ? 1 : (isEnabled! ? 1 : 0.5),
        child: InkWell(
          borderRadius: BorderRadius.circular(
            circleOnTap ? 1000 : radius ?? themeData.borderRadius ?? 14,
          ),
          onTap: isEnabled == null || isEnabled!
              ? () async {
                  if (onTap != null) await onTap!();
                }
              : null,
          onDoubleTap: onDoubleTap,
          child: Container(
            width: width,
            height: height,
            constraints: BoxConstraints(
              minHeight: formatHeight(
                height ??
                    getResponsiveValue(
                      context,
                      defaultValue: 54,
                      desktop: themeData.widthInWeb,
                      phone: themeData.widthInMobile,
                    ),
              ),
              minWidth: formatWidth(
                height ??
                    getResponsiveValue(
                      context,
                      defaultValue: 54,
                      desktop: themeData.heightInWeb,
                      phone: themeData.heightInMobile,
                    ),
              ),
            ),
            decoration: BoxDecoration(
              color:
                  backgroundColor ??
                  themeData.backgroundColor ??
                  Colors.transparent,
              gradient: gradient ?? themeData.gradient,
              border: border ?? themeData.border,
              borderRadius: BorderRadius.circular(
                circleOnTap ? 1000 : radius ?? themeData.borderRadius ?? 14,
              ),
            ),
            padding: const EdgeInsets.all(15.0),
            child: IntrinsicWidth(
              child:
                  child ??
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      icon != null ? icon! : const SizedBox(),
                      icon != null && textButton != null
                          ? const SizedBox(width: 9.5)
                          : const SizedBox(),
                      textButton != null
                          ? Text(
                              textButton!,
                              style:
                                  textButtonStyle ?? themeData.textButtonStyle,
                            )
                          : const SizedBox(),
                    ],
                  ),
            ),
          ),
        ),
      ),
    );
  }
}

class _Back extends CTA {
  const _Back({
    super.height,
    super.radius,
    super.isEnabled,
    super.width,
    super.backIcon,
    super.onTap,
    super.onDoubleTap,
    super.backgroundColor,
    super.theme,
    super.themeName,
    super.border,
    super.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    final themeData = loadThemeData(
      theme,
      themeName ?? "back_button",
      () => const CtaThemeData(),
    )!;
    return Material(
      type: MaterialType.transparency,
      child: Opacity(
        opacity: isEnabled == null ? 1 : (isEnabled! ? 1 : 0.5),
        child: InkWell(
          borderRadius: BorderRadius.circular(
            radius ?? themeData.borderRadius ?? 14,
          ),
          onTap: isEnabled == null || isEnabled!
              ? () async {
                  if (onTap != null) await onTap!();
                }
              : null,
          onDoubleTap: onDoubleTap,
          child: Container(
            height:
                (height ??
                themeData.height ??
                getResponsiveValue(
                  context,
                  defaultValue: formatWidth(50),
                  desktop: themeData.heightInWeb,
                  phone: themeData.heightInMobile,
                )),
            width:
                (height ??
                themeData.height ??
                getResponsiveValue(
                  context,
                  defaultValue: formatWidth(50),
                  desktop: themeData.widthInWeb,
                  phone: themeData.widthInMobile,
                )),
            decoration: BoxDecoration(
              color:
                  backgroundColor ??
                  themeData.backgroundColor ??
                  Colors.transparent,
              gradient: gradient ?? gradient,
              border: border ?? themeData.border,
              borderRadius: BorderRadius.circular(
                radius ?? themeData.borderRadius ?? 14,
              ),
            ),
            child: Material(
              type: MaterialType.transparency,
              child: InkWell(
                borderRadius: BorderRadius.circular(
                  radius ?? themeData.borderRadius ?? 14,
                ),
                onTap: isEnabled == null || isEnabled!
                    ? () async {
                        if (onTap != null) await onTap!();
                      }
                    : null,
                onDoubleTap: onDoubleTap,
                child: Icon(
                  backIcon ?? Icons.arrow_back_ios_new_rounded,
                  color: iconColor ?? themeData.iconColor ?? Colors.black,
                  size: themeData.iconSize ?? formatWidth(20),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
