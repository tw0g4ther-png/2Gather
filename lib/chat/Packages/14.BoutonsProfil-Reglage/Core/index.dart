import '../../../appColor.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../../../appTheme.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

enum BorderRadiusType { halfRounded, rounded, slightRounded, square }

WidgetStateProperty<OutlinedBorder?>? borderShape(
    {BorderRadiusType? borderRadiusType, BorderSide? borderSide}) {
  switch (borderRadiusType) {
    case BorderRadiusType.halfRounded:
      return WidgetStateProperty.resolveWith((states) =>
          RoundedRectangleBorder(
              side: borderSide ?? BorderSide.none,
              borderRadius: BorderRadius.circular(17.r)));
    case BorderRadiusType.rounded:
      return WidgetStateProperty.resolveWith((states) =>
          RoundedRectangleBorder(
              side: borderSide ?? BorderSide.none,
              borderRadius: BorderRadius.circular(29.r)));
    case BorderRadiusType.slightRounded:
      return WidgetStateProperty.resolveWith((states) =>
          RoundedRectangleBorder(
              side: borderSide ?? BorderSide.none,
              borderRadius: BorderRadius.circular(6.r)));

    default:
      return null;
  }
}

class SettingsButton extends StatelessWidget {
  @override
  final Key? key;
  final String? title;
  final String? subtitle;
  final VoidCallback? onClick;
  final SvgPicture? svg;
  final Widget? switchNotif;
  final ImageProvider? image;
  final Icon? icon;
  final Color? backgroundColor;
  final Color? iconBackgroundColor;
  final Color? overlayColor;
  final double? radius;
  final BorderRadiusType? borderRadiusType;
  const SettingsButton(
      {this.key,
      this.radius,
      this.switchNotif,
      this.svg,
      this.iconBackgroundColor,
      this.title,
      this.subtitle,
      required this.onClick,
      this.image,
      this.icon,
      this.backgroundColor,
      this.overlayColor,
      this.borderRadiusType})
      : assert(((image != null && icon == null && svg == null) ||
            (image == null && icon != null && svg == null) ||
            (image == null && icon == null && svg != null) ||
            (image == null && icon == null && svg == null)));

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(minHeight: 60.h),
      child: TextButton(
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.resolveWith((states) =>
              backgroundColor ?? AppColor.configButtonBackgroundColor),
          overlayColor: WidgetStateProperty.resolveWith((states) =>
              overlayColor ??
              darkenOrLighten(
                  backgroundColor ?? AppColor.configButtonBackgroundColor)),
          shape: borderShape(borderRadiusType: borderRadiusType) ??
              WidgetStateProperty.resolveWith((states) =>
                  RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular((radius ?? 7).r))),
        ),
        onPressed: onClick,
        child: Row(
          children: [
            (icon != null || image != null || svg != null)
                ? Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10.w),
                    child: CircleAvatar(
                        radius: 19.5.h,
                        backgroundColor: iconBackgroundColor,
                        backgroundImage: image,
                        child: icon != null ? (icon) : svg ?? const SizedBox()))
                : SizedBox(
                    width: 13.w,
                  ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          title ?? '',
                          style: AppTheme.titleConfigButtonStyle,
                        ),
                      ),
                    ],
                  ),
                  subtitle != null
                      ? Padding(
                          padding: EdgeInsets.only(top: 0.0.h),
                          child: Text(
                            subtitle ?? "",
                            style: AppTheme.subtitleConfigButtonStyle,
                          ),
                        )
                      : const SizedBox(),
                ],
              ),
            ),
            switchNotif == null
                ? Icon(
                    CupertinoIcons.right_chevron,
                    color: AppTheme.chevronColor,
                    size: 20.h,
                  )
                : switchNotif!
          ],
        ),
      ),
    );
  }
}

Color darkenOrLighten(Color color) {
  double amount = color.computeLuminance();
  assert(amount >= 0 && amount <= 1);

  final hsl = HSLColor.fromColor(color);
  if (amount < 0.8) {
    final hslLight =
        hsl.withLightness(((hsl.lightness + amount) / 3).clamp(0.3, 1.0));
    print(hsl);

    return hslLight.toColor();
  } else {
    final hslDark =
        hsl.withLightness((hsl.lightness - amount / 4).clamp(0.0, 1.0));

    return hslDark.toColor();
  }
}
