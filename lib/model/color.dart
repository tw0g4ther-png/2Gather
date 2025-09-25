import 'package:core_kosmos/core_kosmos.dart';
import 'package:flutter/material.dart';

abstract class AppColor {
  static Color mainColor = const Color(0xFFEF561D);

  static LinearGradient mainGradient = const LinearGradient(
    colors: [
      Color(0xFFF9A205),
      Color(0xFFFF6D01),
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}

abstract class AppTextStyle {
  static TextStyle mainColor(double size, [FontWeight weight = FontWeight.w600]) => TextStyle(
        fontSize: sp(size),
        fontWeight: weight,
        color: AppColor.mainColor,
      );

  static TextStyle black(double size, [FontWeight weight = FontWeight.w600]) => TextStyle(
        fontSize: sp(size),
        fontWeight: weight,
        color: Colors.black,
      );

  static TextStyle gray(double size, [FontWeight weight = FontWeight.w400]) => TextStyle(
        fontSize: sp(size),
        fontWeight: weight,
        color: const Color(0xFF737D8A),
      );

  static TextStyle white(double size, [FontWeight weight = FontWeight.w400]) => TextStyle(
        fontSize: sp(size),
        fontWeight: weight,
        color: Colors.white,
      );

  static TextStyle darkGray(double size, [FontWeight weight = FontWeight.w500]) => TextStyle(
        fontSize: sp(size),
        fontWeight: weight,
        color: const Color(0xFF02132B).withValues(alpha: .65),
      );

  static TextStyle darkBlue(double size, [FontWeight weight = FontWeight.w500]) => TextStyle(
        fontSize: sp(size),
        fontWeight: weight,
        color: const Color(0xFF02132B),
      );
}
