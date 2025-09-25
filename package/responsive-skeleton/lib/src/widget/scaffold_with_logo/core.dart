import 'package:auto_route/auto_route.dart';
import 'package:core_kosmos/core_package.dart';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:skeleton_kosmos/skeleton_kosmos.dart';
import 'package:ui_kosmos_v4/cta/cta.dart';

/// Widget créant un scaffold avec le logo de l'application (path défini dans [ApplicationModel]).
/// Le logo est centré dans le cas d'une taille d'écran inférieur à une tablette ou dans une application mobile.
/// Sinon, il est par défaut positionner en [Alignment.topLeft]
///
/// {@category Widget}
class ScaffoldWithLogo extends ConsumerWidget {
  final bool showLogo;
  final Widget child;
  final Color? color;
  final VoidCallback? onBackButtonPressed;

  final bool showBackButton;

  final bool isChildCenter;

  const ScaffoldWithLogo({
    super.key,
    required this.showLogo,
    required this.child,
    this.color,
    this.onBackButtonPressed,
    this.isChildCenter = true,
    this.showBackButton = true,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final width = loadThemeData<double>(
      null,
      getResponsiveValue(
        context,
        defaultValue: "skeleton_icon_size_web_width",
        phone: "skeleton_icon_size_phone_width",
      ),
      () => 80,
    )!;
    final appModel = GetIt.instance<ApplicationDataModel>();

    return Scaffold(
      backgroundColor: color,
      bottomNavigationBar:
          (appModel.applicationConfig.bottomBarOnAuthenticationPage)
          ? WebParentCore.buildBottomBar(context, ref)
          : null,
      body: SafeArea(
        child: Padding(
          padding: getResponsiveValue(
            context,
            defaultValue: EdgeInsets.zero,
            phone: loadThemeData(
              null,
              "skeleton_page_padding_phone",
              () => EdgeInsets.zero,
            )!,
            tablet: loadThemeData(
              null,
              "skeleton_page_padding_tablet",
              () => EdgeInsets.zero,
            )!,
          ),
          child:
              getResponsiveValue(
                context,
                defaultValue: true,
                tablet: false,
                phone: false,
              )
              ? Stack(
                  children: [
                    if (showLogo)
                      Positioned(
                        top: 10,
                        left: 20,
                        child: SizedBox(
                          width: width,
                          child: ImageWithSmartFormat(
                            type: appModel.logoFormat,
                            path: appModel.appLogo,
                            width: width,
                            boxFit: BoxFit.fitWidth,
                          ),
                        ),
                      ),
                    SizedBox(
                      width: double.infinity,
                      height: double.infinity,
                      child: isChildCenter
                          ? Center(child: SingleChildScrollView(child: child))
                          : SingleChildScrollView(child: child),
                    ),
                  ],
                )
              : SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  primary: false,
                  child: Column(
                    children: [
                      sh(10),
                      Stack(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 30),
                            child: Center(
                              child: showLogo
                                  ? ImageWithSmartFormat(
                                      type: appModel.logoFormat,
                                      path: appModel.appLogo,
                                      width: formatWidth(width),
                                    )
                                  : const SizedBox(),
                            ),
                          ),
                          if (showBackButton)
                            Positioned(
                              left: 0,
                              top: 0,
                              child: execInCaseOfPlatfom(
                                () => const SizedBox(),
                                () => CTA.back(
                                  height: 50,
                                  onTap: () {
                                    if (onBackButtonPressed != null) {
                                      return onBackButtonPressed!();
                                    }
                                    AutoRouter.of(context).navigate(
                                      GetIt.I<ApplicationDataModel>().mainRoute,
                                    );
                                  },
                                ),
                              ),
                            ),
                        ],
                      ),
                      child,
                    ],
                  ),
                ),
        ),
      ),
    );
  }

  /// Retourne le même widget mais avec le logo contenu dans une appBar.
  const factory ScaffoldWithLogo.withBar({
    required bool showLogo,
    required Widget child,
    bool? showBackButton,
    Color? color,
  }) = _WithBar;
}

class _WithBar extends ScaffoldWithLogo {
  const _WithBar({
    required super.showLogo,
    required super.child,
    super.color,
    bool? showBackButton,
  }) : super(showBackButton: showBackButton ?? true);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: ResponsiveAppBar.blank(
        size: Size.fromHeight(
          loadThemeData<ResponsiveAppBarThemeData>(
            null,
            "skeleton_app_bar",
            () => const ResponsiveAppBarThemeData(),
          )!.height,
        ),
        ref: ref,
      ),
      bottomNavigationBar:
          (GetIt.instance<ApplicationDataModel>()
              .applicationConfig
              .bottomBarOnAuthenticationPage)
          ? WebParentCore.buildBottomBar(context, ref)
          : null,
      backgroundColor: color,
      body: Padding(
        padding: getResponsiveValue(
          context,
          defaultValue: EdgeInsets.zero,
          phone: loadThemeData(
            null,
            "skeleton_page_padding_phone",
            () => EdgeInsets.zero,
          )!,
          tablet: loadThemeData(
            null,
            "skeleton_page_padding_tablet",
            () => EdgeInsets.zero,
          )!,
        ),
        child: child,
      ),
    );
  }
}
