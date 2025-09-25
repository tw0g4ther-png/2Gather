import 'package:core_kosmos/core_package.dart';
import 'package:flutter/material.dart';
import 'package:skeleton_kosmos/src/widget/custom_card/theme.dart';

/// Créer une card (Équivalent de [Card] de flutter) avec un style personnalisé et entièrement customisable.
///
/// {@category Widget}
///
/// Exemple:
///
/// ```dart
/// CustomCard(
///  maxWidth: 300,
///  shadowColor: Colors.black.withValues(alpha: .1),
///  child: Text('Hello World'),
/// ),
/// ```
class CustomCard extends StatelessWidget {
  final double? maxWidth;
  final double? maxHeight;
  final double? verticalPadding;
  final double? horizontalPadding;
  final double? blurRadius;
  final double? spreadRadius;
  final double? borderRadius;
  final Color? backgroundColor;
  final Color? shadowColor;
  final Offset? offset;

  final String? themeName;
  final CustomCardThemeData? theme;

  final bool useIntrisict;
  final bool isCenter;

  final Clip cardClip;

  final Widget child;

  const CustomCard({
    super.key,
    required this.child,
    this.maxWidth,
    this.maxHeight,
    this.verticalPadding,
    this.horizontalPadding,
    this.blurRadius,
    this.spreadRadius,
    this.borderRadius,
    this.backgroundColor,
    this.shadowColor,
    this.isCenter = true,
    this.useIntrisict = true,
    this.theme,
    this.themeName,
    this.cardClip = Clip.hardEdge,
    this.offset,
  });

  @override
  Widget build(BuildContext context) {
    final themeData = loadThemeData(
      theme,
      themeName ?? "custom_card",
      () => const CustomCardThemeData(),
    )!;

    return Container(
      clipBehavior: cardClip,
      width: maxWidth ?? themeData.maxWidth,
      constraints: BoxConstraints(
        maxWidth: maxWidth ?? themeData.maxWidth ?? double.infinity,
        maxHeight: maxHeight ?? themeData.maxHeight ?? double.infinity,
      ),
      padding: EdgeInsets.symmetric(
        vertical: formatHeight(
          verticalPadding ?? themeData.verticalPadding ?? 0,
        ),
        horizontal: formatWidth(
          horizontalPadding ?? themeData.horizontalPadding ?? 0,
        ),
      ),
      decoration: BoxDecoration(
        color:
            backgroundColor ??
            themeData.backgroundColor ??
            loadThemeData(
              null,
              "custom_card_background_color",
              () => Theme.of(context).cardColor,
            ),
        borderRadius: BorderRadius.circular(
          borderRadius ?? themeData.radius ?? 0,
        ),
      ),
      child: useIntrisict
          ? IntrinsicWidth(
              child: Column(
                crossAxisAlignment: isCenter
                    ? CrossAxisAlignment.center
                    : CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [isCenter ? Center(child: child) : child],
              ),
            )
          : Column(
              crossAxisAlignment: isCenter
                  ? CrossAxisAlignment.center
                  : CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [isCenter ? Center(child: child) : child],
            ),
    );
  }
}
