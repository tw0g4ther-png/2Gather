import 'package:flutter/material.dart';
import 'package:permissionrequest/src/theme/permission_theme.dart';
import 'package:ui_kosmos_v4/cta/cta.dart';
import 'package:ui_kosmos_v4/cta/theme.dart';
import 'package:core_kosmos/core_kosmos.dart';

class BlankPermission extends StatefulWidget {
  const BlankPermission({
    super.key,
    required this.validateText,
    this.onBack,
    this.onSkip,
    required this.onValidate,
    this.skipText,
    this.asset,
    this.title,
    this.subtitle,
    this.isBackground = false,
    this.isSafeArea = true,
    this.backgroundColor,
    this.titleStyle,
    this.package,
    this.assetSize,
    this.subtitleStyle,
    this.validateButtonPadding,
    this.backButtonPadding,
    this.skipButtonPadding,
    this.themeBack,
    this.themeNameBack,
    this.themeSkip,
    this.themeNameSkip,
    this.themeValidate,
    this.themeNameValidate,
    this.theme,
    this.themeName,
    this.assetChild,
  }) : assert(asset != null || assetChild != null);

  final VoidCallback onValidate;
  final VoidCallback? onBack;
  final VoidCallback? onSkip;
  final String validateText;
  final String? skipText;
  final String? title;
  final String? subtitle;
  final String? asset;
  final Widget? assetChild;

  final Color? backgroundColor;
  final bool isBackground;
  final String? package;
  final bool isSafeArea;
  final EdgeInsets? validateButtonPadding;
  final EdgeInsets? backButtonPadding;
  final EdgeInsets? skipButtonPadding;
  final Size? assetSize;
  final TextStyle? titleStyle;
  final TextStyle? subtitleStyle;
  final CtaThemeData? themeBack;
  final String? themeNameBack;
  final CtaThemeData? themeValidate;
  final String? themeNameValidate;
  final CtaThemeData? themeSkip;
  final String? themeNameSkip;

  final String? themeName;
  final PermissionThemeData? theme;

  @override
  State<BlankPermission> createState() => _BlankPermissionState();
}

class _BlankPermissionState extends State<BlankPermission> {
  late final PermissionThemeData themeData;

  @override
  void initState() {
    themeData = loadThemeData(widget.theme, widget.themeName ?? "permission",
        () => const PermissionThemeData())!;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Container(
        width: double.infinity,
        height: double.infinity,
        color: widget.backgroundColor ??
            themeData.backgroundColor ??
            Colors.transparent,
        child: Stack(
          children: [
            const SizedBox(width: double.infinity, height: double.infinity),
            if (widget.isBackground)
              Positioned.fill(
                child: Image.asset(
                  widget.asset ?? "assets/images/permission_background.png",
                  package: widget.package,
                  fit: BoxFit.cover,
                ),
              ),
            SizedBox(
              width: double.infinity,
              height: double.infinity,
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  SizedBox(
                      height: MediaQuery.of(context).padding.top +
                          formatHeight(20)),
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      if (widget.onBack != null) ...[
                        InkWell(
                          onTap: widget.onBack,
                          child: Padding(
                            padding: themeData.pagePadding ??
                                EdgeInsets.symmetric(
                                    horizontal: formatWidth(14)),
                            child: CTA.back(
                              onTap: widget.onBack,
                              theme: widget.themeBack,
                              themeName: widget.themeNameBack,
                            ),
                          ),
                        )
                      ],
                      if (widget.onSkip != null) ...[
                        InkWell(
                          onTap: widget.onSkip,
                          child: Padding(
                            padding: themeData.pagePadding ??
                                EdgeInsets.symmetric(
                                    horizontal: formatWidth(14)),
                            child: CTA.tiers(
                              textButton: widget.skipText ?? "Passer",
                              onTap: widget.onSkip,
                              theme: widget.themeSkip,
                              themeName: widget.themeNameSkip,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  Expanded(
                    child: Padding(
                      padding: themeData.pagePadding ??
                          EdgeInsets.symmetric(horizontal: formatWidth(29)),
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Expanded(
                            child: Align(
                              alignment: Alignment.bottomCenter,
                              child: widget.assetChild ??
                                  Image.asset(widget.asset!),
                            ),
                          ),
                          Expanded(
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                sh(35),
                                Text(
                                  widget.title ?? "",
                                  style:
                                      widget.titleStyle ?? themeData.titleStyle,
                                  textAlign: TextAlign.center,
                                ),
                                sh(9),
                                Expanded(
                                  child: Text(
                                    widget.subtitle ?? "",
                                    style: widget.subtitleStyle ??
                                        themeData.subTitleStyle,
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                sh(25),
                              ],
                            ),
                          ),
                          CTA.primary(
                            onTap: widget.onValidate,
                            textButton: widget.validateText,
                            theme: widget.themeValidate,
                            themeName: widget.themeNameValidate,
                          ),
                          SizedBox(
                              height: formatHeight(35) +
                                  MediaQuery.of(context).padding.bottom),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
