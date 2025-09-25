// ignore_for_file: avoid_returning_null_for_void

import 'package:auto_route/auto_route.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:core_kosmos/core_kosmos.dart';
import 'package:dartz/dartz.dart' as dz;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:settings_kosmos/settings_kosmos.dart';
import 'package:skeleton_kosmos/skeleton_kosmos.dart';

@RoutePage()
class SettingsPage extends ConsumerWidget {
  SettingsPage({super.key});

  final appModel = GetIt.instance<ApplicationDataModel>();

  List<dz.Tuple2<String, List<SettingsNode>>> _checkUserData(WidgetRef ref) {
    List<dz.Tuple2<String, List<SettingsNode>>> ret = [];
    for (var section in appModel.applicationConfig.settingsNodes) {
      List<SettingsNode> nodes = [];
      for (final node in section.value2) {
        if (node.type == SettingsType.personnalData && node.data == null) {
          nodes.add(
            node.copyWith(
              data: SettingsData(
                title:
                    "${ref.watch(userChangeNotifierProvider).userData?.firstname != null ? ref.watch(userChangeNotifierProvider).userData!.firstname! : ""} ${ref.watch(userChangeNotifierProvider).userData?.lastname != null ? ref.watch(userChangeNotifierProvider).userData!.lastname! : ""}",
                subTitle:
                    ref.watch(userChangeNotifierProvider).userData?.email !=
                        null
                    ? ref.watch(userChangeNotifierProvider).userData!.email!
                    : "",
                prefix:
                    ref
                            .watch(userChangeNotifierProvider)
                            .userData!
                            .profilImage !=
                        null
                    ? CachedNetworkImage(
                        imageUrl: ref
                            .watch(userChangeNotifierProvider)
                            .userData!
                            .profilImage!,
                        fit: BoxFit.cover,
                        width: formatWidth(103),
                        height: formatWidth(103),
                        errorWidget: (context, _, _) {
                          return Container(
                            width: formatWidth(103),
                            height: formatWidth(103),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(
                                formatWidth(103),
                              ),
                              color: Colors.grey.shade200,
                            ),
                            child: Image.asset(
                              "assets/images/img_user_profil.png",
                              package: "skeleton_kosmos",
                              fit: BoxFit.cover,
                            ),
                          );
                        },
                        placeholder: (context, _) {
                          return Container(
                            width: formatWidth(103),
                            height: formatWidth(103),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(
                                formatWidth(103),
                              ),
                              color: Colors.grey.shade200,
                            ),
                            child: Image.asset(
                              "assets/images/img_user_profil.png",
                              package: "skeleton_kosmos",
                              fit: BoxFit.cover,
                            ),
                          );
                        },
                      )
                    : Container(
                        width: formatWidth(103),
                        height: formatWidth(103),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(formatWidth(103)),
                          color: Colors.grey.shade200,
                        ),
                        child: Image.asset(
                          "assets/images/img_user_profil.png",
                          package: "skeleton_kosmos",
                          fit: BoxFit.cover,
                        ),
                      ),
              ),
            ),
          );
        } else {
          nodes.add(node);
        }
      }
      section = section.copyWith(value2: nodes);
      ret.add(section);
    }
    return ret;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final nodes = _checkUserData(ref);
    final themeData = loadThemeData(
      null,
      "responsive_settings",
      () => const ResponsiveSettingsThemeData(),
    )!;

    final Widget c = ResponsiveSettings(
      nodes: nodes,
      userEmail: GetIt.instance<ApplicationDataModel>().showEmailInProfile
          ? ref.watch(userChangeNotifierProvider).userData!.email
          : null,
      userName:
          "${ref.watch(userChangeNotifierProvider).userData!.firstname} ${ref.watch(userChangeNotifierProvider).userData!.lastname}",
      userImage: ref.watch(userChangeNotifierProvider).userData!.profilImage,
      showUserProfil: GetIt.instance<ApplicationDataModel>().showUserImage,
      showEditedBy: true,
      showEditImageProfil:
          GetIt.instance<ApplicationDataModel>().showEditImageProfil,
      logoutFunction: (_, _) async {
        if (GetIt.instance<ApplicationDataModel>().logoutFunction != null) {
          return GetIt.instance<ApplicationDataModel>().logoutFunction!(
            context,
            ref,
          );
        }
        // Nettoyage de l'état utilisateur
        ref.read(userChangeNotifierProvider).clear();
        // Déconnexion de l'utilisateur puis reset de la pile de navigation vers /login
        final rootRouter = AutoRouter.of(context).root;
        await FirebaseAuth.instance.signOut();
        rootRouter.popUntilRoot();
        rootRouter.replaceNamed("/login");
      },
      deleteAccountFunction: (_, _) async {
        if (GetIt.instance<ApplicationDataModel>().deleteAccountFunction !=
            null) {
          return GetIt.instance<ApplicationDataModel>().deleteAccountFunction!(
            context,
            ref,
          );
        }
        // Suppression du compte côté backend, puis nettoyage et redirection vers /login
        final uid = FirebaseAuth.instance.currentUser?.uid;
        if (uid != null) {
          FirebaseFunctions.instance.httpsCallable("deleteUser").call({
            "userId": uid,
            "uid": uid,
          });
        }
        ref.read(userChangeNotifierProvider).clear();
        final rootRouter = AutoRouter.of(context).root;
        await FirebaseAuth.instance.signOut();
        rootRouter.popUntilRoot();
        rootRouter.replaceNamed("/login");
      },
      showUserImage: appModel.applicationConfig.showUserImageOnSettings,
    );

    return GestureDetector(
      onTap: () => ref.read(settingsProvider).clear(),
      child: SafeArea(
        bottom: false,
        child: Container(
          color: Theme.of(context).scaffoldBackgroundColor,
          width: double.infinity,
          height: double.infinity,
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Padding(
              padding: getResponsiveValue(
                context,
                defaultValue: EdgeInsets.zero,
                tablet: EdgeInsets.symmetric(horizontal: formatWidth(30)),
                phone: EdgeInsets.symmetric(horizontal: formatWidth(22)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  sh(themeData.settingsVeriticalSpacing ?? 40),
                  getResponsiveValue(
                        context,
                        defaultValue: true,
                        tablet: false,
                        phone: false,
                      )
                      ? SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          primary: false,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (!appModel
                                  .applicationConfig
                                  .showSideBarOrDrawerOnWeb) ...[
                                sw(themeData.settingsLeftSpacing ?? 240),
                              ],
                              InkWell(
                                mouseCursor: MouseCursor.uncontrolled,
                                onTap: () => null,
                                child: CustomCard(
                                  maxWidth: themeData.cardWidth ?? 390,
                                  horizontalPadding: 28,
                                  verticalPadding: 24,
                                  borderRadius:
                                      themeData.cardBorderRadius ?? 12,
                                  child: c,
                                ),
                              ),
                              ...ref
                                  .watch(settingsProvider)
                                  .activeNodes
                                  .map(
                                    (e) => Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        sw(20),
                                        InkWell(
                                          mouseCursor: MouseCursor.uncontrolled,
                                          onTap: () => null,
                                          child: CustomCard(
                                            maxWidth:
                                                themeData.cardWidth ?? 390,
                                            borderRadius:
                                                themeData.cardBorderRadius ??
                                                12,
                                            horizontalPadding: 28,
                                            verticalPadding: 24,
                                            child: NodePage(
                                              nodeTag: e.value2,
                                              nodes: nodes,
                                              level: e.value1 + 1,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                              sw(themeData.settingsRightSpacing ?? 40),
                            ],
                          ),
                        )
                      : c,
                  sh(themeData.settingsVeriticalSpacing ?? 40),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
