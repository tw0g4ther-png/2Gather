// ignore_for_file: must_be_immutable, use_build_context_synchronously

import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:core_kosmos/core_package.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:dartz/dartz.dart' as dz;
import 'package:image_picker/image_picker.dart';
import 'package:settings_kosmos/src/widget/alert.dart';
import 'package:ui_kosmos_v4/ui_kosmos_v4.dart';
import '../src/services/firebase/storage.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../settings_kosmos.dart';

final settingsProvider = ChangeNotifierProvider<SettingsProvider>((ref) {
  return SettingsProvider();
});

class ResponsiveSettings extends HookConsumerWidget {
  final List<dz.Tuple2<String, List<SettingsNode>>> nodes;
  final Function(BuildContext, WidgetRef)? deleteAccountFunction;
  final Function(BuildContext, WidgetRef)? logoutFunction;
  final Function(BuildContext)? onChangedProfilPictureFunction;
  final Widget Function(BuildContext, WidgetRef)? subProfilBuilder;

  File? profilPicture;

  final SettingsThemeData? theme;
  final String? themeName;

  final bool showUserProfil;
  final bool showUserImage;
  final bool showEditedBy;
  final bool showEditImageProfil;

  final String? userName;
  final String? userEmail;
  final String? userImage;

  ResponsiveSettings({
    super.key,
    required this.nodes,
    this.profilPicture,
    this.theme,
    this.themeName,
    this.deleteAccountFunction,
    this.logoutFunction,
    this.showUserImage = true,
    this.showUserProfil = true,
    this.showEditedBy = true,
    this.showEditImageProfil = true,
    this.userEmail,
    this.subProfilBuilder,
    this.userImage,
    this.userName,
    this.onChangedProfilPictureFunction,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final SettingsThemeData? themeData = loadThemeData(
      theme,
      themeName ?? "settings",
      () => const SettingsThemeData(),
    );

    if (getResponsiveValue(
      context,
      defaultValue: false,
      tablet: false,
      phone: true,
    )) {
      execAfterBuild(() => ref.read(settingsProvider).clear());
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // AppBar personnalisée pour tous les supports
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Bouton retour stylisé
            InkWell(
              onTap: () {
                if (Navigator.of(context).canPop()) {
                  Navigator.of(context).pop();
                } else {
                  AutoRouter.of(context).navigateNamed("/dashboard/home");
                }
              },
              borderRadius: BorderRadius.circular(formatWidth(25)),
              child: Icon(
                Icons.arrow_back_ios_new_rounded,
                color: themeData?.actionIconColor ?? Colors.black,
                size: formatWidth(18),
              ),
            ),
            // Bouton menu (3 points)
            InkWell(
              onTap: () async {
                final showBoxAlertToDeleteAccount = await showCupertinoModalPopup(
                  context: context,
                  builder: (context) {
                    return CupertinoActionSheet(
                      cancelButton: CupertinoActionSheetAction(
                        onPressed: () {
                          Navigator.of(context).pop(false);
                        },
                        child: Text(
                          "utils.cancel".tr(),
                          style: TextStyle(
                            color: const Color(0xFF007AFF),
                            fontSize: sp(20),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      actions: [
                        CupertinoActionSheetAction(
                          onPressed: () async {
                            printInDebug(
                              "[Settings] ========== DÉCONNEXION DEMANDÉE ==========",
                            );
                            printInDebug(
                              "[Settings] Context monté avant fermeture popup: ${context.mounted}",
                            );
                            printInDebug(
                              "[Settings] Type de widget context: ${context.widget.runtimeType}",
                            );

                            // Fermer le popup d'abord
                            Navigator.of(context).pop();
                            printInDebug("[Settings] ✓ Popup fermé");

                            // Attendre un frame pour que le popup soit complètement fermé
                            await Future.delayed(Duration(milliseconds: 100));
                            printInDebug(
                              "[Settings] Context monté après fermeture popup: ${context.mounted}",
                            );

                            if (logoutFunction != null) {
                              printInDebug(
                                "[Settings] Appel de la logoutFunction personnalisée...",
                              );
                              try {
                                await logoutFunction!.call(context, ref);
                                printInDebug(
                                  "[Settings] ✓ logoutFunction terminée avec succès",
                                );
                              } catch (logoutError) {
                                printInDebug(
                                  "[Settings] ❌ Erreur dans logoutFunction: $logoutError",
                                );
                                printInDebug(
                                  "[Settings] Type d'erreur: ${logoutError.runtimeType}",
                                );

                                // Fallback en cas d'erreur de la logoutFunction
                                if (context.mounted) {
                                  printInDebug(
                                    "[Settings] Fallback: redirection directe vers /login",
                                  );
                                  try {
                                    AutoRouter.of(
                                      context,
                                    ).replaceNamed("/login");
                                    printInDebug(
                                      "[Settings] ✓ Fallback réussi",
                                    );
                                  } catch (fallbackError) {
                                    printInDebug(
                                      "[Settings] ❌ Fallback échoué: $fallbackError",
                                    );
                                  }
                                } else {
                                  printInDebug(
                                    "[Settings] ❌ Context non monté pour le fallback",
                                  );
                                }
                              }
                            } else {
                              printInDebug(
                                "[Settings] Pas de logoutFunction - utilisation du fallback par défaut",
                              );
                              if (context.mounted) {
                                try {
                                  AutoRouter.of(context).replaceNamed("/login");
                                  printInDebug(
                                    "[Settings] ✓ Fallback par défaut réussi",
                                  );
                                } catch (defaultError) {
                                  printInDebug(
                                    "[Settings] ❌ Fallback par défaut échoué: $defaultError",
                                  );
                                }
                              } else {
                                printInDebug(
                                  "[Settings] ❌ Context non monté pour le fallback par défaut",
                                );
                              }
                            }

                            printInDebug(
                              "[Settings] ========== FIN DÉCONNEXION SETTINGS ==========",
                            );
                          },
                          child: Text(
                            "settings.logout".tr(),
                            style: TextStyle(
                              color: const Color(0xFFFF3B30),
                              fontSize: sp(20),
                            ),
                          ),
                        ),
                        CupertinoActionSheetAction(
                          isDestructiveAction: true,
                          onPressed: () {
                            Navigator.of(context).pop(true);
                          },
                          child: Text(
                            "settings.delete-profil".tr(),
                            style: TextStyle(
                              color: const Color(0xFFFF3B30),
                              fontSize: sp(20),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                );
                if (showBoxAlertToDeleteAccount == true) {
                  final rep = await AlertBox.show<bool>(
                    context: context,
                    backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                    titleStyle: themeData?.sectionStyle?.copyWith(
                      fontSize: sp(22),
                      fontWeight: FontWeight.w600,
                    ),
                    title: "settings.delete-account".tr(),
                    message: "settings.delete-account-confirm".tr(),
                    actions: [
                      (_) => CTA.primary(
                        textButton: "utils.yes".tr(),
                        width: formatWidth(207),
                        onTap: () => Navigator.of(context).pop(true),
                      ),
                      (_) => CTA.secondary(
                        textButton: "utils.no".tr(),
                        border: Border.all(color: Colors.transparent),
                        width: formatWidth(207),
                        onTap: () => Navigator.of(context).pop(false),
                      ),
                    ],
                  );
                  if (rep == true) {
                    if (deleteAccountFunction != null) {
                      return await deleteAccountFunction!(context, ref);
                    }
                    AutoRouter.of(context).replaceNamed("/logout");
                  }
                }
              },
              borderRadius: BorderRadius.circular(formatWidth(25)),
              child: Icon(
                Icons.more_horiz,
                color: themeData?.actionIconColor ?? Colors.black,
                size: formatWidth(20),
              ),
            ),
          ],
        ),

        sh(10),
        const SizedBox(width: double.infinity, height: .1),
        if (showUserProfil) ...[
          Center(
            child: Column(
              children: [
                if (showUserImage) ...[
                  InkWell(
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    // overlayColor intentionally omitted to avoid SDK compatibility issue
                    onTap: (!showEditImageProfil)
                        ? null
                        : () async {
                            if (onChangedProfilPictureFunction != null) {
                              onChangedProfilPictureFunction!.call(context);
                              return;
                            }
                            await showCupertinoModalPopup(
                              context: context,
                              builder: (_) {
                                return CupertinoActionSheet(
                                  cancelButton: CupertinoActionSheetAction(
                                    onPressed: () {
                                      Navigator.of(context).pop(false);
                                    },
                                    child: Text(
                                      "utils.cancel".tr(),
                                      style: TextStyle(
                                        color: const Color(0xFF007AFF),
                                        fontSize: sp(20),
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                  title: Text(
                                    "settings.what-you-want-do".tr(),
                                    style: TextStyle(
                                      fontSize: sp(13),
                                      color: const Color(0xFF8F8F8F),
                                      fontWeight: FontWeight.w600,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  actions: [
                                    CupertinoActionSheetAction(
                                      isDestructiveAction: true,
                                      onPressed: () async {
                                        final file = await ImagePicker()
                                            .pickImage(
                                              source: ImageSource.camera,
                                            );
                                        if (file != null) {
                                          profilPicture = File(file.path);

                                          /// Upload files to firebase storage
                                          await FirebaseStorageController()
                                              .downloadUrl(
                                                profilPicture!,
                                                FirebaseAuth
                                                    .instance
                                                    .currentUser!
                                                    .uid,
                                              );
                                          Navigator.of(context).pop(true);
                                        }
                                      },
                                      child: Text(
                                        "settings.take-picture".tr(),
                                        style: TextStyle(
                                          color: const Color(0xFF007AFF),
                                          fontSize: sp(20),
                                        ),
                                      ),
                                    ),
                                    //Bibliothèque
                                    CupertinoActionSheetAction(
                                      isDestructiveAction: true,
                                      onPressed: () async {
                                        File? image =
                                            await FirebaseStorageController()
                                                .selectFile(
                                                  FirebaseAuth
                                                      .instance
                                                      .currentUser!
                                                      .uid,
                                                );
                                        if (image != null) {
                                          profilPicture = image;
                                        }
                                        Navigator.of(context).pop(true);
                                      },
                                      child: Text(
                                        "settings.modify-picture".tr(),
                                        style: TextStyle(
                                          color: const Color(0xFF007AFF),
                                          fontSize: sp(20),
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              },
                            );
                            // if (showBoxAlertToModifyProfilPicture == true) {
                            //   final rep = await AlertBox.show<bool>(
                            //     context: context,
                            //     title: "settings.modify-picture".tr(),
                            //     message: "settings.modify-picture-confirm".tr(),
                            //     actions: [
                            //       (_) => CTA.primary(
                            //             textButton: "utils.yes".tr(),
                            //             width: formatWidth(207),
                            //             textButtonStyle: TextStyle(color: Colors.white, fontSize: sp(14)),
                            //             onTap: () => Navigator.of(_).pop(true),
                            //           ),
                            //       (_) => CTA.secondary(
                            //             textButton: "utils.non".tr(),
                            //             width: formatWidth(207),
                            //             textButtonStyle: TextStyle(color: Colors.black, fontSize: sp(14)),
                            //             onTap: () => Navigator.of(_).pop(false),
                            //           ),
                            //     ],
                            //   );
                            //   if (rep == true) {
                            //     if (deleteAccountFunction != null) await deleteAccountFunction!();
                            //     AutoRouter.of(context).replaceNamed("/logout");
                            //   }
                            // }
                          },
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        userImage != null
                            ? Container(
                                width: formatWidth(92),
                                height: formatWidth(92),
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                ),
                                clipBehavior: Clip.antiAliasWithSaveLayer,
                                child: CachedNetworkImage(
                                  imageUrl: userImage!,
                                  placeholder: (_, __) => Image.asset(
                                    "assets/images/img_default_user.png",
                                    package: "settings_kosmos",
                                    fit: BoxFit.cover,
                                  ),
                                  errorWidget: (_, __, ___) => Image.asset(
                                    "assets/images/img_default_user.png",
                                    package: "settings_kosmos",
                                    fit: BoxFit.cover,
                                  ),
                                  fit: BoxFit.cover,
                                ),
                              )
                            : Container(
                                width: formatWidth(92),
                                height: formatWidth(92),
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                ),
                                clipBehavior: Clip.antiAliasWithSaveLayer,
                                child: Image.asset(
                                  "assets/images/img_default_user.png",
                                  package: "settings_kosmos",
                                  fit: BoxFit.cover,
                                ),
                              ),
                        if (showEditImageProfil)
                          Positioned(
                            right: 0,
                            left: 0,
                            bottom: -10,
                            child: SvgPicture.asset(
                              'assets/svg/pen.svg',
                              package: "settings_kosmos",
                              height: 30,
                            ),
                          ),
                      ],
                    ),
                  ),
                  if (showEditImageProfil) sh(4),
                  sh(5.4),
                ],
                if (userName != null) ...[
                  Text(
                    userName!,
                    style:
                        themeData?.nameStyle ??
                        TextStyle(
                          fontSize: sp(20),
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                    textAlign: TextAlign.center,
                  ),
                ],
                if (userEmail != null) ...[
                  Text(
                    userEmail!,
                    style:
                        themeData?.emailStyle ??
                        TextStyle(
                          fontSize: sp(13),
                          fontWeight: FontWeight.w500,
                          color: const Color(0xFFA7ADB5),
                        ),
                    textAlign: TextAlign.center,
                  ),
                ],
                if (subProfilBuilder != null) ...[
                  sh(6.6),
                  subProfilBuilder!(context, ref),
                ],
              ],
            ),
          ),
        ],
        if (showUserProfil) ...[sh(13), const Divider(height: .5)],
        ...nodes.map((e) => _buildSettingsSection(context, e, themeData, ref)),

        SizedBox(
          height: MediaQuery.of(context).padding.bottom + formatHeight(12),
        ),
      ],
    );
  }

  _buildSettingsSection(
    BuildContext context,
    dz.Tuple2<String, List<SettingsNode>> node,
    SettingsThemeData? themeData,
    WidgetRef ref,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        sh(15),
        Text(
          node.value1.tr(),
          style:
              themeData?.sectionStyle ??
              TextStyle(
                fontSize: sp(16),
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
        ),
        sh(3),
        ...node.value2.map(
          (e) => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [sh(7), buildSettingsItem(context, e, themeData, ref)],
          ),
        ),
      ],
    );
  }
}

/// Node builder
buildSettingsItem(
  BuildContext context,
  SettingsNode e,
  SettingsThemeData? themeData,
  WidgetRef ref, [
  int level = 0,
]) {
  switch (e.type) {
    case SettingsType.personnalData:
      if (e.data!.builder != null) {
        return e.data!.builder!(context, ref, () async {
          if (e.data?.onTap != null) {
            await e.data!.onTap!(context, ref);
          } else if (e.children != null) {
            if (getResponsiveValue(
              context,
              defaultValue: true,
              phone: false,
              tablet: false,
            )) {
              ref.read(settingsProvider).updateNode(level, e.tag);
            } else {
              AutoRouter.of(
                context,
              ).navigateNamed("/dashboard/profile/settings/${e.tag}");
            }
          } else if (e.data?.childBuilder != null) {
            if (getResponsiveValue(
              context,
              defaultValue: true,
              phone: false,
              tablet: false,
            )) {
              ref.read(settingsProvider).updateNode(level, e.tag);
            } else {
              AutoRouter.of(
                context,
              ).navigateNamed("/dashboard/profile/settings/${e.tag}");
            }
          }
        });
      } else {
        return SettingsCellule(
          isActive:
              getResponsiveValue(
                context,
                defaultValue: true,
                phone: false,
                tablet: false,
              )
              ? ref.watch(settingsProvider).isActive(e.tag)
              : false,
          onClick: () async {
            if (e.data?.onTap != null) {
              await e.data!.onTap!(context, ref);
            } else if (e.children != null) {
              if (getResponsiveValue(
                context,
                defaultValue: true,
                phone: false,
                tablet: false,
              )) {
                ref.read(settingsProvider).updateNode(level, e.tag);
              } else {
                AutoRouter.of(
                  context,
                ).navigateNamed("/dashboard/profile/settings/${e.tag}");
              }
            } else if (e.data?.childBuilder != null) {
              if (getResponsiveValue(
                context,
                defaultValue: true,
                phone: false,
                tablet: false,
              )) {
                ref.read(settingsProvider).updateNode(level, e.tag);
              } else {
                AutoRouter.of(
                  context,
                ).navigateNamed("/dashboard/profile/settings/${e.tag}");
              }
            }
          },
          title: e.data!.title,
          titleStyle: themeData?.titleStyle,
          subtitle: e.data!.subTitle,
          subtitleStyle: themeData?.subTitleStyle,
          icon: e.data!.prefix,
          activeIcon: e.data?.activePrefix,
        );
      }
    case SettingsType.security:
      return SettingsCellule(
        isActive:
            getResponsiveValue(
              context,
              defaultValue: true,
              phone: false,
              tablet: false,
            )
            ? ref.watch(settingsProvider).isActive(e.tag)
            : false,
        onClick: () async {
          if (e.data?.onTap != null) {
            await e.data!.onTap!(context, ref);
          } else if (e.children != null) {
            if (getResponsiveValue(
              context,
              defaultValue: true,
              phone: false,
              tablet: false,
            )) {
              ref.read(settingsProvider).updateNode(level, e.tag);
            } else {
              AutoRouter.of(
                context,
              ).navigateNamed("/dashboard/profile/settings/${e.tag}");
            }
          } else if (e.data?.childBuilder != null) {
            if (getResponsiveValue(
              context,
              defaultValue: true,
              phone: false,
              tablet: false,
            )) {
              ref.read(settingsProvider).updateNode(level, e.tag);
            } else {
              AutoRouter.of(
                context,
              ).navigateNamed("/dashboard/profile/settings/${e.tag}");
            }
          }
        },
        icon: Center(
          child: SvgPicture.asset(
            "assets/svg/lock.svg",
            package: "settings_kosmos",
            width: themeData?.iconSize ?? formatWidth(16),
            colorFilter: ColorFilter.mode(
              themeData?.iconColor ?? Colors.white,
              BlendMode.srcIn,
            ),
          ),
        ),
        activeIcon: Center(
          child: SvgPicture.asset(
            "assets/svg/lock.svg",
            package: "settings_kosmos",
            width: themeData?.iconSize ?? formatWidth(16),
            colorFilter: ColorFilter.mode(
              themeData?.activeIconColor ?? Colors.white,
              BlendMode.srcIn,
            ),
          ),
        ),
        title: "settings.security.title".tr(),
        titleStyle: themeData?.titleStyle,
        subtitle: "settings.security.subTitle".tr(),
        subtitleStyle: themeData?.subTitleStyle,
      );
    case SettingsType.payment:
      return SettingsCellule(
        isActive:
            getResponsiveValue(
              context,
              defaultValue: true,
              phone: false,
              tablet: false,
            )
            ? ref.watch(settingsProvider).isActive(e.tag)
            : false,
        onClick: () async {
          if (e.data?.onTap != null) {
            await e.data!.onTap!(context, ref);
          } else if (e.children != null) {
            if (getResponsiveValue(
              context,
              defaultValue: true,
              phone: false,
              tablet: false,
            )) {
              ref.read(settingsProvider).updateNode(level, e.tag);
            } else {
              AutoRouter.of(
                context,
              ).navigateNamed("/dashboard/profile/settings/${e.tag}");
            }
          } else if (e.data?.childBuilder != null) {
            if (getResponsiveValue(
              context,
              defaultValue: true,
              phone: false,
              tablet: false,
            )) {
              ref.read(settingsProvider).updateNode(level, e.tag);
            } else {
              AutoRouter.of(
                context,
              ).navigateNamed("/dashboard/profile/settings/${e.tag}");
            }
          }
        },
        icon: Center(
          child: SvgPicture.asset(
            "assets/svg/credit-card.svg",
            package: "settings_kosmos",
            width: themeData?.iconSize ?? formatWidth(16),
            colorFilter: ColorFilter.mode(
              themeData?.iconColor ?? Colors.white,
              BlendMode.srcIn,
            ),
          ),
        ),
        activeIcon: Center(
          child: SvgPicture.asset(
            "assets/svg/credit-card.svg",
            package: "settings_kosmos",
            width: themeData?.iconSize ?? formatWidth(16),
            colorFilter: ColorFilter.mode(
              themeData?.activeIconColor ?? Colors.white,
              BlendMode.srcIn,
            ),
          ),
        ),
        title: "settings.payment.title".tr(),
        titleStyle: themeData?.titleStyle,
        subtitle: "settings.payment.subTitle".tr(),
        subtitleStyle: themeData?.subTitleStyle,
      );
    case SettingsType.share:
      return SettingsCellule(
        isActive:
            getResponsiveValue(
              context,
              defaultValue: true,
              phone: false,
              tablet: false,
            )
            ? ref.watch(settingsProvider).isActive(e.tag)
            : false,
        onClick: () async {
          if (e.data?.onTap != null) {
            await e.data!.onTap!(context, ref);
          } else if (e.children != null) {
            if (getResponsiveValue(
              context,
              defaultValue: true,
              phone: false,
              tablet: false,
            )) {
              ref.read(settingsProvider).updateNode(level, e.tag);
            } else {
              AutoRouter.of(
                context,
              ).navigateNamed("/dashboard/profile/settings/${e.tag}");
            }
          } else if (e.data?.childBuilder != null) {
            if (getResponsiveValue(
              context,
              defaultValue: true,
              phone: false,
              tablet: false,
            )) {
              ref.read(settingsProvider).updateNode(level, e.tag);
            } else {
              AutoRouter.of(
                context,
              ).navigateNamed("/dashboard/profile/settings/${e.tag}");
            }
          }
        },
        icon: Center(
          child: SvgPicture.asset(
            "assets/svg/share.svg",
            package: "settings_kosmos",
            width: themeData?.iconSize ?? formatWidth(16),
            colorFilter: ColorFilter.mode(
              themeData?.iconColor ?? Colors.white,
              BlendMode.srcIn,
            ),
          ),
        ),
        activeIcon: Center(
          child: SvgPicture.asset(
            "assets/svg/share.svg",
            package: "settings_kosmos",
            width: themeData?.iconSize ?? formatWidth(16),
            colorFilter: ColorFilter.mode(
              themeData?.activeIconColor ?? Colors.white,
              BlendMode.srcIn,
            ),
          ),
        ),
        title: "settings.share.title".tr(),
        titleStyle: themeData?.titleStyle,
        subtitle: "settings.share.subTitle".tr(),
        subtitleStyle: themeData?.subTitleStyle,
      );
    case SettingsType.help:
      return SettingsCellule(
        isActive:
            getResponsiveValue(
              context,
              defaultValue: true,
              phone: false,
              tablet: false,
            )
            ? ref.watch(settingsProvider).isActive(e.tag)
            : false,
        onClick: () async {
          if (e.data?.onTap != null) {
            await e.data!.onTap!(context, ref);
          } else if (e.children != null) {
            if (getResponsiveValue(
              context,
              defaultValue: true,
              phone: false,
              tablet: false,
            )) {
              ref.read(settingsProvider).updateNode(level, e.tag);
            } else {
              AutoRouter.of(
                context,
              ).navigateNamed("/dashboard/profile/settings/${e.tag}");
            }
          } else if (e.data?.childBuilder != null) {
            if (getResponsiveValue(
              context,
              defaultValue: true,
              phone: false,
              tablet: false,
            )) {
              ref.read(settingsProvider).updateNode(level, e.tag);
            } else {
              AutoRouter.of(
                context,
              ).navigateNamed("/dashboard/profile/settings/${e.tag}");
            }
          }
        },
        icon: Center(
          child: SvgPicture.asset(
            "assets/svg/help.svg",
            package: "settings_kosmos",
            width: themeData?.iconSize ?? formatWidth(16),
            colorFilter: ColorFilter.mode(
              themeData?.iconColor ?? Colors.white,
              BlendMode.srcIn,
            ),
          ),
        ),
        activeIcon: Center(
          child: SvgPicture.asset(
            "assets/svg/help.svg",
            package: "settings_kosmos",
            width: themeData?.iconSize ?? formatWidth(16),
            colorFilter: ColorFilter.mode(
              themeData?.activeIconColor ?? Colors.white,
              BlendMode.srcIn,
            ),
          ),
        ),
        title: "settings.help.title".tr(),
        titleStyle: themeData?.titleStyle,
        subtitle: "settings.help.subTitle".tr(),
        subtitleStyle: themeData?.subTitleStyle,
      );
    case SettingsType.link:
      return SettingsCellule(
        isActive:
            getResponsiveValue(
              context,
              defaultValue: true,
              phone: false,
              tablet: false,
            )
            ? ref.watch(settingsProvider).isActive(e.tag)
            : false,
        onClick: () async {
          if (e.data?.onTap != null) {
            await e.data!.onTap!(context, ref);
          } else if (e.children != null) {
            if (getResponsiveValue(
              context,
              defaultValue: true,
              phone: false,
              tablet: false,
            )) {
              ref.read(settingsProvider).updateNode(level, e.tag);
            } else {
              AutoRouter.of(
                context,
              ).navigateNamed("/dashboard/profile/settings/${e.tag}");
            }
          } else if (e.data?.childBuilder != null) {
            if (getResponsiveValue(
              context,
              defaultValue: true,
              phone: false,
              tablet: false,
            )) {
              ref.read(settingsProvider).updateNode(level, e.tag);
            } else {
              AutoRouter.of(
                context,
              ).navigateNamed("/dashboard/profile/settings/${e.tag}");
            }
          }
        },
        icon: e.data?.prefix,
        activeIcon: e.data?.prefix,
        title: e.data?.title?.tr(),
        titleStyle: themeData?.titleStyle,
      );
    case SettingsType.custom:
      if (e.data?.builder != null) {
        return e.data!.builder!(context, ref, () async {
          if (e.data?.onTap != null) {
            await e.data!.onTap!(context, ref);
          } else if (e.children != null) {
            if (getResponsiveValue(
              context,
              defaultValue: true,
              phone: false,
              tablet: false,
            )) {
              ref.read(settingsProvider).updateNode(level, e.tag);
            } else {
              AutoRouter.of(
                context,
              ).navigateNamed("/dashboard/profile/settings/${e.tag}");
            }
          } else if (e.data?.childBuilder != null) {
            if (getResponsiveValue(
              context,
              defaultValue: true,
              phone: false,
              tablet: false,
            )) {
              ref.read(settingsProvider).updateNode(level, e.tag);
            } else {
              AutoRouter.of(
                context,
              ).navigateNamed("/dashboard/profile/settings/${e.tag}");
            }
          }
        });
      } else {
        return SettingsCellule(
          isActive:
              getResponsiveValue(
                context,
                defaultValue: true,
                phone: false,
                tablet: false,
              )
              ? ref.watch(settingsProvider).isActive(e.tag)
              : false,
          onClick: () async {
            if (e.data?.onTap != null) {
              await e.data!.onTap!(context, ref);
            } else if (e.children != null) {
              if (getResponsiveValue(
                context,
                defaultValue: true,
                phone: false,
                tablet: false,
              )) {
                ref.read(settingsProvider).updateNode(level, e.tag);
              } else {
                AutoRouter.of(
                  context,
                ).navigateNamed("/dashboard/profile/settings/${e.tag}");
              }
            } else if (e.data?.childBuilder != null) {
              if (getResponsiveValue(
                context,
                defaultValue: true,
                phone: false,
                tablet: false,
              )) {
                ref.read(settingsProvider).updateNode(level, e.tag);
              } else {
                AutoRouter.of(
                  context,
                ).navigateNamed("/dashboard/profile/settings/${e.tag}");
              }
            }
          },
          title: e.data!.title?.tr(),
          titleStyle: themeData?.titleStyle,
          subtitle: e.data!.subTitle?.tr(),
          subtitleStyle: themeData?.subTitleStyle,
          icon: e.data!.prefix,
          activeIcon: e.data!.activePrefix,
        );
      }
    case SettingsType.instagram:
      return SettingsCellule(
        onClick: () async {
          if (e.data?.onTap != null) {
            await e.data!.onTap!(context, ref);
          }
        },
        icon: SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: Center(
            child: SvgPicture.asset(
              "assets/svg/instaLink.svg",
              package: "settings_kosmos",
              fit: BoxFit.cover,
            ),
          ),
        ),
        title: "settings.instagram.title".tr(),
        titleStyle: themeData?.titleStyle,
      );
    case SettingsType.tiktok:
      return SettingsCellule(
        onClick: () async {
          if (e.data?.onTap != null) {
            await e.data!.onTap!(context, ref);
          }
        },
        icon: SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: Center(
            child: SvgPicture.asset(
              "assets/svg/tiktokLink.svg",
              package: "settings_kosmos",
              fit: BoxFit.cover,
            ),
          ),
        ),
        title: "settings.tiktok.title".tr(),
        titleStyle: themeData?.titleStyle,
      );
    case SettingsType.switcher:
      if (e.data?.builder != null) {
        return e.data!.builder!(context, ref, () {});
      } else {
        return SettingsCellule(
          switchNotif: CupertinoSwitch(
            activeTrackColor: e.data!.activeSwitchColor,
            value: e.data!.switchValue!(ref),
            onChanged: (val) async {
              if (e.data?.onSwicth != null) {
                await e.data!.onSwicth!(context, ref, val);
              }
            },
          ),
          isActive:
              getResponsiveValue(
                context,
                defaultValue: true,
                phone: false,
                tablet: false,
              )
              ? ref.watch(settingsProvider).isActive(e.tag)
              : false,
          onClick: () async {
            if (e.data?.onSwicth != null) {
              await e.data!.onSwicth!(context, ref, !e.data!.switchValue!(ref));
            }
          },
          title: e.data!.title?.tr(),
          titleStyle: themeData?.titleStyle,
          subtitle: e.data!.subTitle?.tr(),
          subtitleStyle: themeData?.subTitleStyle,
          icon: e.data!.prefix,
          activeIcon: e.data?.prefix,
        );
      }
  }
}

class NodePage extends ConsumerWidget {
  final String nodeTag;
  final List<dz.Tuple2<String, List<SettingsNode>>> nodes;

  final SettingsThemeData? theme;
  final String? themeName;

  final int level;

  NodePage({
    super.key,
    required this.nodeTag,
    required this.nodes,
    this.themeName,
    this.theme,
    this.level = 1,
  }) {
    node = _catchNode(nodes);
  }

  late SettingsNode? node;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final SettingsThemeData? themeData = loadThemeData(
      theme,
      themeName ?? "settings",
      () => const SettingsThemeData(),
    );

    if (node != null && node!.data?.childBuilder != null) {
      return Padding(
        padding:
            themeData?.nodePagePadding ??
            getResponsiveValue(
              context,
              defaultValue: EdgeInsets.symmetric(horizontal: formatWidth(22)),
              phone: EdgeInsets.symmetric(horizontal: formatWidth(29)),
            ),
        child: node!.data!.childBuilder!(context, ref),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (node != null) ...[
          ...node!.children!.map(
            (e) => _buildSettingsSection(context, e, themeData, ref),
          ),
        ] else ...[
          Text(
            "settings.node.noNode".tr(),
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ],
      ],
    );
  }

  _buildSettingsSection(
    BuildContext context,
    dz.Tuple2<String, List<SettingsNode>> node,
    SettingsThemeData? themeData,
    WidgetRef ref,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: double.infinity,
          height: formatHeight(50),
          child: Stack(
            children: [
              Center(
                child: Text(
                  node.value1.tr(),
                  style:
                      themeData?.sectionStyle ??
                      TextStyle(
                        fontSize: sp(16),
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                  left: themeData?.paddingLeftIcon ?? 10,
                ),
                child: CTA.back(
                  width: formatWidth(50),
                  height: formatWidth(50),
                  onTap: () {
                    if (Navigator.of(context).canPop()) {
                      Navigator.of(context).pop();
                    } else {
                      AutoRouter.of(context).navigateNamed("/dashboard/home");
                    }
                  },
                ),
              ),
            ],
          ),
        ),
        sh(10),
        ...node.value2.map(
          (e) => Padding(
            padding: getResponsiveValue(
              context,
              defaultValue: EdgeInsets.symmetric(horizontal: formatWidth(22)),
              phone: EdgeInsets.symmetric(horizontal: formatWidth(29)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                sh(7),
                buildSettingsItem(context, e, themeData, ref, level),
              ],
            ),
          ),
        ),
      ],
    );
  }

  SettingsNode? _catchNode(List<dz.Tuple2<String, List<SettingsNode>>> nodes) {
    for (var e in nodes) {
      for (final i in e.value2) {
        if (i.tag == nodeTag) {
          return i;
        } else if (i.children != null) {
          var j = _catchNode(i.children!);
          if (j != null) return j;
        }
      }
    }
    return null;
  }
}
