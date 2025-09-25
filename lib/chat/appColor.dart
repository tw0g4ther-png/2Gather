import 'package:flutter/material.dart';

abstract class AppColor {
  // Text

  static const Color primaryTextColor = Color(0XFF020E1A);
  static Color secondaryTextColor = const Color(0XFF02132B).withValues(alpha: 0.62);
  static const Color thirdTextColor = Color(0XFF939AA5);

  // Form
  // ignore this line if your input TextFormField are bordered
  static const Color formFillColor = Color(0XFFF6F6F6);
  //------------------------------------------------------
  static const Color placeholderColor = Color(0XFFDBDBDB);
  static const Color fieldNameColor = Color(0XFF02132B);
  static const Color postFieldColor = Color(0XFF020E1A);
  static const Color hintTextColor = Color(0XFFBBBBBB);
  static const Color formTextColor = Color(0XFFBBBBBB);
  static const Color focusColor = Color(0XFF02132B);
  static const Color errorColor = Colors.red;
  //Primary Button
  static const Color primaryButtonColor = Color(0XFF02132B);
  static const Color primaryTextButtonColor = Colors.white;
  // Secondary Button
  static const Color secondaryButtonTextColor = Colors.black;
  static const Color secondaryButtonBorderColor = Color(0XFFCCCCCC);
  // Notif Banner
  static const Color notifBannerErrorColor = Color(0XFFEB5353);
  static const Color notifBannerTitleColor = Colors.white;
  static const Color notifBannerSubtitleColor = Colors.white;
  static Color notifBannerSuccessColor = Colors.white.withValues(alpha: 0.75);

  // Divider Color
  static const Color dividerColor = Colors.white;

  // Settings Color
  static Color configButtonBackgroundColor = const Color(0XFFF5F5F5).withValues(alpha: 0.67);
  static const Color svgSecurityColor = Color(0XFF02132B);
  static const Color svgPayementColor = Color(0XFF02132B);
  static const Color svgNotifColor = Color(0XFF02132B);
  static const Color svgAideColor = Color(0XFF02132B);
  static const Color svgShareColor = Color(0XFF02132B);
  static const MaterialColor swatch = MaterialColor(0XFF02132B, {
    50: Color.fromRGBO(2, 19, 43, .1),
    100: Color.fromRGBO(2, 19, 43, .2),
    200: Color.fromRGBO(2, 19, 43, .3),
    300: Color.fromRGBO(2, 19, 43, .4),
    400: Color.fromRGBO(2, 19, 43, .5),
    500: Color.fromRGBO(2, 19, 43, .6),
    600: Color.fromRGBO(2, 19, 43, .7),
    700: Color.fromRGBO(2, 19, 43, .8),
    800: Color.fromRGBO(2, 19, 43, .9),
    900: Color.fromRGBO(2, 19, 43, 1),
  });
}
