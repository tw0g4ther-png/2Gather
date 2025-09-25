import 'package:core_kosmos/src/utils/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:responsive_framework/responsive_framework.dart';

////////////////////////////////////////////////////
////////////////////////////////////////////////////
///////////// Methodes UI / Responsive /////////////
////////////////////////////////////////////////////
////////////////////////////////////////////////////

/// Permet de créer une SizedBox responsive en [height]
///
Widget sh(double value) =>
    SizedBox(height: execInCaseOfPlatfom<double>(() => value, () => value.h));

/// Permet de créer une SizedBox responsive en [width]
///
Widget sw(double value) =>
    SizedBox(width: execInCaseOfPlatfom<double>(() => value, () => value.w));

/// Permet de récupérer une [fontSize] en responsive
///
double sp(double value) =>
    execInCaseOfPlatfom<double>(() => value, () => value.sp);

/// Permet de récupérer un [radius] en responsive
///
double r(double value) =>
    execInCaseOfPlatfom<double>(() => value, () => value.r);

/// Permet de récupérer une [height] en responsive
///
double formatHeight(double value) =>
    execInCaseOfPlatfom<double>(() => value, () => value.h);

/// Permet de récupérer une [width] en responsive
///
double formatWidth(double value) =>
    execInCaseOfPlatfom<double>(() => value, () => value.w);

T getResponsiveValue<T>(BuildContext context,
        {required T defaultValue, T? desktop, T? tablet, T? phone}) =>
    ResponsiveValue<T>(context, defaultValue: defaultValue, conditionalValues: [
      if (phone != null) Condition.smallerThan(name: PHONE, value: phone),
      if (tablet != null) Condition.smallerThan(name: TABLET, value: tablet),
      if (desktop != null) Condition.smallerThan(name: DESKTOP, value: desktop),
    ]).value;

////
///
class ResponsiveBuilder extends StatelessWidget {
  final Widget child;
  final Widget? phoneChild;
  final Widget? tabletChild;

  const ResponsiveBuilder({
    super.key,
    required this.child,
    this.phoneChild,
    this.tabletChild,
  });

  @override
  Widget build(BuildContext context) {
    if (ResponsiveValue(context, conditionalValues: [
      const Condition.smallerThan(name: PHONE, value: true),
    ]).value) {
      return phoneChild ?? tabletChild ?? child;
    } else if (ResponsiveValue(context, conditionalValues: [
      const Condition.smallerThan(name: TABLET, value: true),
    ]).value) {
      return tabletChild ?? child;
    }
    return child;
  }
}
