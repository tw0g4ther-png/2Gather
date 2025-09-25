import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Widget textSized({required String text, required double size, required int weight, bool? center}) {
  return Text(
    text,
    textAlign: (center != null && center) ? TextAlign.center : TextAlign.start,
    style: TextStyle(
        fontSize: size.sp,
        fontWeight: (weight == 400)
            ? FontWeight.w400
            : (weight == 500)
                ? FontWeight.w500
                : (weight == 300)
                    ? FontWeight.w300
                    : (weight == 700)
                        ? FontWeight.w700
                        : FontWeight.w600),
  );
}

Widget textSizedColored({
  required String text,
  required double size,
  required int weight,
  double? height,
  required Color color,
  bool? center,
  int? maxline,
  bool? underline,
}) {
  return Text(
    text,
    maxLines: maxline,
    textAlign: center == null ? TextAlign.start : TextAlign.center,
    style: TextStyle(
        color: color,
        fontSize: size.sp,
        height: height,
        decoration: underline == true ? TextDecoration.underline : null,
        fontWeight: (weight == 400)
            ? FontWeight.w400
            : (weight == 500)
                ? FontWeight.w500
                : (weight == 300)
                    ? FontWeight.w300
                    : (weight == 700)
                        ? FontWeight.w700
                        : (weight == 600)
                            ? FontWeight.w600
                            : FontWeight.w100),
  );
}
