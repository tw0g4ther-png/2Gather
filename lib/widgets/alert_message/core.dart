import 'package:core_kosmos/core_package.dart';
import 'package:twogather/widgets/alert_message/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AlertMessage extends StatelessWidget {
  /// Core
  final AlertMessageType type;
  final String message;
  final String icon;

  /// Theme
  final Color? backgroundColor;
  final TextStyle? textStyle;
  final Color? iconColor;
  final BorderRadiusGeometry? borderRadius;
  final BoxConstraints? constraints;
  final List<BoxShadow>? shadows;
  final EdgeInsetsGeometry? padding;
  final TextAlign? textAlign;

  final AlertMessageThemeData? theme;
  final String? themeName;

  const AlertMessage({
    super.key,
    this.backgroundColor,
    this.borderRadius,
    this.constraints,
    this.iconColor,
    this.padding,
    this.shadows,
    this.textStyle,
    this.textAlign,
    this.icon = "assets/svg/ic_info.svg",
    this.type = AlertMessageType.info,
    required this.message,
    this.themeName,
    this.theme,
  });

  @override
  Widget build(BuildContext context) {
    final AlertMessageThemeData? themeData = loadThemeData(
      theme,
      themeName ?? "alert_message",
      () => const AlertMessageThemeData(),
    );

    final activeColor = _getColorFromType();

    return Container(
      constraints: constraints ?? themeData?.constraints,
      clipBehavior: Clip.hardEdge,
      padding:
          padding ??
          themeData?.padding ??
          EdgeInsets.symmetric(
            vertical: formatHeight(10),
            horizontal: formatWidth(13),
          ),
      width: double.infinity,
      decoration: BoxDecoration(
        color:
            backgroundColor ??
            themeData?.backgroundColor ??
            activeColor.withValues(alpha: .13),
        borderRadius: borderRadius ?? themeData?.borderRadius,
        boxShadow: shadows ?? themeData?.shadows,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          SvgPicture.asset(
            icon,
            colorFilter: ColorFilter.mode(
              iconColor ?? themeData?.iconColor ?? activeColor,
              BlendMode.srcIn,
            ),
            height: formatHeight(14),
            width: formatWidth(14),
          ),
          sw(13),
          Expanded(
            child: Text(
              message,
              style:
                  textStyle ??
                  themeData?.textStyle ??
                  TextStyle(
                    color: activeColor,
                    fontSize: sp(11),
                    fontWeight: FontWeight.w500,
                  ),
              textAlign: textAlign ?? themeData?.textAlign,
            ),
          ),
        ],
      ),
    );
  }

  Color _getColorFromType() {
    switch (type) {
      case AlertMessageType.info:
        return Colors.blueAccent;
      case AlertMessageType.success:
        return Colors.green;
      case AlertMessageType.error:
        return Colors.red;
      case AlertMessageType.warning:
        return const Color(0xFFF4A629);
    }
  }
}
