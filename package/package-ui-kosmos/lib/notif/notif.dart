import 'package:core_kosmos/core_kosmos.dart';
import 'package:flutter/material.dart';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:iconsax/iconsax.dart';
import 'package:ui_kosmos_v4/notif/theme.dart';

enum NotifBannerPosition { center, top, bottom }

abstract class NotifBanner {
  static void showToast({
    required BuildContext context,
    required FToast fToast,
    NotifBannerPosition notifBannerPosition = NotifBannerPosition.top,
    Duration? duration,
    Icon? icon,
    Color? backgroundColor,
    String? title,
    String? subTitle,
    TextStyle? titleStyle,
    TextStyle? subTitleStyle,
    double? radius,
    NotifBannerThemeData? theme,
    String? themeName,
  }) {
    final themeData = loadThemeData(
      theme,
      themeName ?? "notif_banner",
      () => const NotifBannerThemeData(),
    )!;

    Widget toast = Padding(
      padding: const EdgeInsets.symmetric(horizontal: 29.0),
      child: Container(
        constraints: getResponsiveValue(
          context,
          defaultValue: BoxConstraints(
            minWidth: formatWidth(317),
            maxWidth: formatWidth(317),
            minHeight: formatHeight(77),
          ),
          desktop: themeData.webConstraints,
          phone: themeData.phoneConstraints,
        ),
        decoration: BoxDecoration(
          boxShadow:
              themeData.shadow ??
              [
                BoxShadow(
                  blurRadius: 30,
                  offset: const Offset(0, 3),
                  color: backgroundColor != null
                      ? backgroundColor.withValues(alpha: 0.21)
                      : const Color(0XFFEB5353).withValues(alpha: 0.21),
                ),
              ],
          borderRadius: BorderRadius.circular(radius ?? themeData.radius ?? 7),
          color:
              backgroundColor ??
              themeData.backgroundColor ??
              const Color(0xFFEB5353),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: formatWidth(themeData.horizontalPadding ?? 20),
            vertical: formatHeight(themeData.verticalPadding ?? 0),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (title != null) ...[
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style:
                      titleStyle ??
                      themeData.titleStyle ??
                      const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                      ),
                ),
                sh(6),
              ],
              if (subTitle != null)
                Text(
                  subTitle,
                  textAlign: TextAlign.center,
                  style:
                      subTitleStyle ??
                      themeData.subtitleStyle ??
                      const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                        fontSize: 12.5,
                      ),
                ),
            ],
          ),
        ),
      ),
    );

    fToast.showToast(
      child: postionChild(child: toast, position: notifBannerPosition),
      fadeDuration: Duration(
        milliseconds: themeData.fadeDuration?.inMilliseconds ?? 300,
      ),
      toastDuration:
          duration ?? themeData.duration ?? const Duration(seconds: 3),
    );
  }

  static void showMessage({
    required BuildContext context,
    required FToast fToast,
    NotifBannerPosition notifBannerPosition = NotifBannerPosition.top,
    Duration? duration,
    Icon? icon,
    Color? backgroundColor,
    Icon? customIcon,
    String? title,
    TextStyle? titleStyle,
    TextStyle? subTitleStyle,
    double? radius,
    NotifBannerThemeData? theme,
    String? themeName,
  }) {
    final themeData = loadThemeData(
      theme,
      themeName ?? "message_bannel",
      () => const NotifBannerThemeData(),
    )!;

    Widget toast = Padding(
      padding: const EdgeInsets.symmetric(horizontal: 29.0),
      child: Container(
        constraints: getResponsiveValue(
          context,
          defaultValue: BoxConstraints(
            minWidth: formatWidth(317),
            maxWidth: formatWidth(317),
            minHeight: formatHeight(77),
          ),
          desktop: themeData.webConstraints,
          phone: themeData.phoneConstraints,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(radius ?? themeData.radius ?? 7),
          color:
              backgroundColor ??
              themeData.backgroundColor ??
              const Color(0xFFD9FFEE),
          boxShadow: themeData.shadow,
        ),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              customIcon ??
                  Icon(
                    Iconsax.info_circle,
                    size: 14,
                    color:
                        subTitleStyle?.color ??
                        themeData.subtitleStyle?.color ??
                        const Color(0xFF30DE8F),
                  ),
              sw(12),
              Expanded(
                child: Text(
                  title ??
                      'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Fusce a nibh ac purus fermentum fermentum id vitae mauris.',
                  textAlign: TextAlign.left,
                  style:
                      subTitleStyle ??
                      themeData.subtitleStyle ??
                      const TextStyle(
                        color: Color(0xFF30DE8F),
                        fontWeight: FontWeight.w500,
                        fontSize: 12.5,
                      ),
                ),
              ),
            ],
          ),
        ),
      ),
    );

    fToast.showToast(
      child: postionChild(child: toast, position: notifBannerPosition),
      fadeDuration: Duration(
        milliseconds: themeData.fadeDuration?.inMilliseconds ?? 300,
      ),
      toastDuration:
          duration ?? themeData.duration ?? const Duration(seconds: 3),
    );
  }

  static void customChild({
    required FToast fToast,
    NotifBannerPosition notifBannerPosition = NotifBannerPosition.top,
    Duration duration = const Duration(seconds: 2),
    required Widget child,
    Color? backgroundColor,
    double radius = 7,
  }) {
    fToast.showToast(
      child: postionChild(child: child, position: notifBannerPosition),
      fadeDuration: const Duration(milliseconds: 300),
      toastDuration: const Duration(seconds: 3),
    );
  }
}

Widget postionChild({NotifBannerPosition? position, dynamic child}) {
  switch (position) {
    case NotifBannerPosition.center:
      return Center(child: child);
    case NotifBannerPosition.top:
      return Padding(
        padding: const EdgeInsets.only(top: 40),
        child: Align(
          alignment: Alignment.topCenter,
          child: child,
        ),
      );
    case NotifBannerPosition.bottom:
      return Padding(
        padding: const EdgeInsets.only(bottom: 30),
        child: Align(
          alignment: Alignment.bottomCenter,
          child: child,
        ),
      );
    default:
      return Padding(
        padding: const EdgeInsets.only(top: 40),
        child: Align(
          alignment: Alignment.topCenter,
          child: child,
        ),
      );
  }
}
