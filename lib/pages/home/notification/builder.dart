import 'package:auto_route/auto_route.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:core_kosmos/core_kosmos.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:twogather/controller/notification_controller.dart';
import 'package:twogather/model/color.dart';
import 'package:twogather/model/fiesta/fiesta_model.dart';
import 'package:twogather/model/notification/notification_model.dart';
import 'package:twogather/services/duration.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shimmer/shimmer.dart';
import 'package:ui_kosmos_v4/cta/cta.dart';
import 'package:ui_kosmos_v4/cta/theme.dart';

abstract class NotificationBuilder {
  static Widget buildNotification(
    BuildContext context,
    NotificationModel data,
  ) {
    Widget? child;

    String time = "";
    if (data.receivedAt != null) {
      time = DateTime.now().difference(data.receivedAt!).format();
    }

    printInDebug(data.notificationType);

    switch (data.notificationType) {
      case NotificationType.message:
        break;
      case NotificationType.friendRequest:
        child = Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            InkWell(
              onTap: () async {
                await NotificationController.handleFriendRequest(
                  FirebaseAuth.instance.currentUser!.uid,
                  data.notificationUser!.id!,
                  data.id!,
                  false,
                );
              },
              child: Text("utils.refuse".tr(), style: AppTextStyle.black(12)),
            ),
            sw(14),
            CTA.primary(
              textButton: "utils.accept".tr(),
              themeName: "main_button",
              width: formatWidth(89),
              onTap: () async {
                await NotificationController.handleFriendRequest(
                  FirebaseAuth.instance.currentUser!.uid,
                  data.notificationUser!.id!,
                  data.id!,
                  true,
                );
              },
            ),
          ],
        );
        break;
      case NotificationType.duoRequest:
        child = Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            InkWell(
              onTap: () async {
                await NotificationController.handleDuoRequest(
                  FirebaseAuth.instance.currentUser!.uid,
                  data.notificationUser!.id!,
                  data.id!,
                  false,
                );
              },
              child: Text("utils.refuse".tr(), style: AppTextStyle.black(12)),
            ),
            sw(14),
            CTA.primary(
              textButton: "utils.accept".tr(),
              themeName: "main_button",
              width: formatWidth(89),
              onTap: () async {
                await NotificationController.handleDuoRequest(
                  FirebaseAuth.instance.currentUser!.uid,
                  data.notificationUser!.id!,
                  data.id!,
                  true,
                );
              },
            ),
          ],
        );
        break;
      case NotificationType.fiestaConfirmation:
        child = Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            InkWell(
              onTap: () async {
                printInDebug(data.metadata);
                await NotificationController.handleFiestaRequest(
                  data.metadata!["duoId"],
                  FirebaseAuth.instance.currentUser!.uid,
                  data.metadata!["fiestaId"],
                  data.id!,
                  false,
                );
              },
              child: Text("utils.refuse".tr(), style: AppTextStyle.black(12)),
            ),
            sw(14),
            CTA.primary(
              textButton: "utils.accept".tr(),
              themeName: "main_button",
              width: formatWidth(89),
              onTap: () async {
                printInDebug(data.metadata);
                await NotificationController.handleFiestaRequest(
                  data.metadata!["duoId"],
                  FirebaseAuth.instance.currentUser!.uid,
                  data.metadata!["fiestaId"],
                  data.id!,
                  true,
                );
              },
            ),
          ],
        );
        break;
      case NotificationType.handleFiestaConfirmation:
        child = Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            CTA.primary(
              textButton: "app.handle-duo".tr(),
              themeName: "main_button",
              width: formatWidth(89),
              onTap: () async {
                printInDebug("pass");
                await NotificationController.setNotificationAsComplete(
                  FirebaseAuth.instance.currentUser!.uid,
                  data.id!,
                );
                if (!context.mounted) return;
                AutoRouter.of(context).navigateNamed(
                  "/dashboard/fiesta/host/${data.metadata!["fiestaId"]}",
                );
              },
            ),
          ],
        );
        break;
      case NotificationType.noteFiesta:
        child = Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            CTA.primary(
              textButton: "utils.note".tr(),
              themeName: "main_button",
              width: formatWidth(89),
              onTap: () async {
                printInDebug(data.metadata);
                final fiestaId = data.metadata!["fiestaId"];
                final fiestaHostId = data.metadata!["fiestaHostId"];
                await NotificationController.setNotificationAsComplete(
                  FirebaseAuth.instance.currentUser!.uid,
                  data.id!,
                );
                if (!context.mounted) return;
                await _noteFiesta(context, fiestaId, fiestaHostId);
              },
            ),
          ],
        );
        break;
      case NotificationType.sponsorshipRequest:
        child = Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            InkWell(
              onTap: () async {
                await NotificationController.handleSponsorshipRequest(
                  FirebaseAuth.instance.currentUser!.uid,
                  data.metadata!["sponsorshipId"],
                  data.id!,
                  false, // Refuser
                );
              },
              child: Text("utils.refuse".tr(), style: AppTextStyle.black(12)),
            ),
            sw(14),
            CTA.primary(
              textButton: "utils.accept".tr(),
              themeName: "main_button",
              width: formatWidth(89),
              onTap: () async {
                await NotificationController.handleSponsorshipRequest(
                  FirebaseAuth.instance.currentUser!.uid,
                  data.metadata!["sponsorshipId"],
                  data.id!,
                  true, // Accepter
                );
              },
            ),
          ],
        );
        break;
      default:
        break;
    }
    return Column(
      children: [
        Row(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            sw(29),
            Container(
              width: formatWidth(42),
              height: formatWidth(42),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(formatWidth(42)),
              ),
              clipBehavior: Clip.hardEdge,
              child: _buildUserProfileImage(data),
            ),
            sw(19),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "${data.notificationUser?.firstname ?? ""} ${data.notificationUser?.lastname ?? ""}",
                    style: AppTextStyle.black(15),
                  ),
                  sh(2),
                  if (data.message != null)
                    Text(
                      _buildTranslatedMessage(data),
                      style: AppTextStyle.gray(12, FontWeight.w500),
                    ),
                  if (child != null && data.isComplete != true) ...[
                    sh(9.5),
                    child,
                  ],
                ],
              ),
            ),
            sh(5.5),
            ConstrainedBox(
              constraints: BoxConstraints(maxWidth: formatWidth(35)),
              child: Text(time, style: AppTextStyle.gray(11, FontWeight.w500)),
            ),
            sw(19),
          ],
        ),
        sh(11.5),
        const Divider(),
        sh(11.5),
      ],
    );
  }

  /// Construit le message traduit avec remplacement des variables
  static String _buildTranslatedMessage(NotificationModel data) {
    final message = data.message!;

    // Pour les notifications de sponsorship, remplacer les variables par les vraies valeurs
    if (message == 'sponsorship.notification-body') {
      // Récupérer les valeurs depuis les metadata ou les données utilisateur
      final firstname =
          data.metadata?['firstname'] ?? data.notificationUser?.firstname ?? '';
      final lastname =
          data.metadata?['lastname'] ?? data.notificationUser?.lastname ?? '';

      printInDebug(
        "[NotificationBuilder] Traduction sponsorship avec firstname: '$firstname', lastname: '$lastname'",
      );

      return message.tr(
        namedArgs: {'firstname': firstname, 'lastname': lastname},
      );
    }

    // Pour les demandes d'amis, utiliser la clé de localisation
    if (message == 'friend.wants-to-become-friend') {
      printInDebug("[NotificationBuilder] Traduction demande d'ami");
      return message.tr();
    }

    // Pour les autres types de notifications, traduction simple
    return message.tr();
  }

  /// Construit l'image de profil de l'utilisateur avec gestion robuste des cas d'erreur
  static Widget _buildUserProfileImage(NotificationModel data) {
    // Récupérer l'ID de l'utilisateur pour faire une requête Firestore
    final String? userId = data.notificationUser?.id;

    if (userId == null || userId.isEmpty) {
      printInDebug(
        "[NotificationBuilder] ID utilisateur manquant pour récupérer l'image de profil",
      );
      return _buildDefaultProfileImage();
    }

    // Utiliser FutureBuilder pour récupérer l'image de profil depuis Firestore
    return FutureBuilder<String?>(
      future: _getUserProfileImageFromFirestore(userId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Afficher l'image par défaut pendant le chargement
          return _buildDefaultProfileImage();
        }

        if (snapshot.hasError) {
          printInDebug(
            "[NotificationBuilder] Erreur lors de la récupération de l'image de profil: ${snapshot.error}",
          );
          return _buildDefaultProfileImage();
        }

        final String? profilImageUrl = snapshot.data;
        final bool hasValidProfileImage =
            profilImageUrl != null && profilImageUrl.isNotEmpty;

        if (hasValidProfileImage) {
          // Afficher l'image de profil récupérée depuis Firestore
          return CachedNetworkImage(
            imageUrl: profilImageUrl,
            fit: BoxFit.cover,
            width: formatWidth(42),
            height: formatWidth(42),
            errorWidget: (context, error, stackTrace) {
              printInDebug(
                "[NotificationBuilder] Erreur lors du chargement de l'image de profil: $error",
              );
              return _buildDefaultProfileImage();
            },
            placeholder: (context, _) {
              return _buildDefaultProfileImage();
            },
          );
        } else {
          // Pas d'image de profil valide, afficher l'image par défaut
          printInDebug(
            "[NotificationBuilder] Aucune image de profil trouvée dans Firestore pour l'utilisateur: $userId",
          );
          return _buildDefaultProfileImage();
        }
      },
    );
  }

  /// Récupère l'image de profil de l'utilisateur depuis son document Firestore
  static Future<String?> _getUserProfileImageFromFirestore(
    String userId,
  ) async {
    try {
      printInDebug(
        "[NotificationBuilder] Récupération de l'image de profil pour l'utilisateur: $userId",
      );

      final doc = await FirebaseFirestore.instance
          .collection("users")
          .doc(userId)
          .get();

      if (!doc.exists) {
        printInDebug(
          "[NotificationBuilder] Document utilisateur non trouvé: $userId",
        );
        return null;
      }

      final data = doc.data();
      final String? profilImage = data?['profilImage'] as String?;

      printInDebug(
        "[NotificationBuilder] Image de profil récupérée: ${profilImage != null ? 'Trouvée' : 'Non trouvée'}",
      );
      return profilImage;
    } catch (e) {
      printInDebug(
        "[NotificationBuilder] Erreur lors de la récupération de l'image de profil: $e",
      );
      return null;
    }
  }

  /// Construit l'image de profil par défaut
  static Widget _buildDefaultProfileImage() {
    return Container(
      width: formatWidth(42),
      height: formatWidth(42),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(formatWidth(42)),
        color: Colors.grey.shade200,
      ),
      child: Image.asset(
        "assets/images/img_user_profil.png",
        fit: BoxFit.cover,
      ),
    );
  }

  static Future<void> _noteFiesta(
    BuildContext context,
    String fiestaId,
    String fiestaHostId,
  ) async {
    double note = 4.0;

    await showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(formatWidth(40)),
          topRight: Radius.circular(formatWidth(40)),
        ),
      ),
      isScrollControlled: true,
      backgroundColor: Colors.white,
      builder: (context) {
        return FutureBuilder(
          future: FirebaseFirestore.instance
              .collection("fiesta")
              .doc(fiestaId)
              .get()
              .then((e) => FiestaModel.fromJson(e.data()!).copyWith(id: e.id)),
          builder: (_, AsyncSnapshot<FiestaModel> snapshot) {
            if (snapshot.hasData && snapshot.data != null) {
              FiestaModel fiestaModel = snapshot.data!;
              bool isHost =
                  fiestaModel.host!.id ==
                  FirebaseAuth.instance.currentUser!.uid;

              return Container(
                constraints: BoxConstraints(minHeight: formatHeight(300)),
                padding: EdgeInsets.symmetric(horizontal: formatWidth(30)),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    sh(12),
                    Container(
                      width: formatWidth(47),
                      height: formatHeight(4),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(formatWidth(40)),
                        color: const Color(0xFFDDDFE2),
                      ),
                    ),
                    sh(17),
                    Text(
                      "Ton expérience Fiesta",
                      style: AppTextStyle.darkBlue(17),
                    ),
                    sh(22),
                    _buildFiestaCard(fiestaModel),
                    if (!isHost) ...[
                      sh(19),
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Container(
                            width: formatWidth(46),
                            height: formatHeight(46),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(100),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(100),
                              child: CachedNetworkImage(
                                imageUrl:
                                    fiestaModel.host!.pictures?.first ?? "",
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          sw(13),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  fiestaModel.host!.firstname ?? "",
                                  style: AppTextStyle.black(
                                    16,
                                    FontWeight.w500,
                                  ),
                                ),
                                Text(
                                  "Host de la Fiesta",
                                  style: AppTextStyle.gray(12, FontWeight.w400),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                    sh(20),
                    const Divider(),
                    sh(20),
                    SizedBox(
                      width: double.infinity,
                      child: Text(
                        "Attribuer une note",
                        style: AppTextStyle.black(17),
                      ),
                    ),
                    sh(19),
                    RatingBar.builder(
                      initialRating: 4,
                      minRating: 0,
                      direction: Axis.horizontal,
                      allowHalfRating: false,
                      itemCount: 5,
                      itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                      itemBuilder: (context, _) =>
                          Icon(Icons.star, color: AppColor.mainColor, size: 50),
                      unratedColor: AppColor.mainColor.withValues(alpha: 0.25),
                      glow: false,
                      onRatingUpdate: (rating) {
                        note = rating;
                      },
                    ),
                    sh(29),
                    const Divider(),
                    sh(26),
                    CTA.primary(
                      width: double.infinity,
                      theme: CtaThemeData(
                        borderRadius: 100,
                        backgroundColor: Colors.transparent,
                        border: Border.all(color: Colors.black, width: .5),
                        textButtonStyle: AppTextStyle.black(14),
                      ),
                      child: Center(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SvgPicture.asset(
                              "assets/svg/ic_report.svg",
                              width: formatWidth(24),
                              colorFilter: ColorFilter.mode(
                                Colors.black,
                                BlendMode.srcIn,
                              ),
                            ),
                            sw(8),
                            Text(
                              "Signaler ${isHost ? "ou recommander " : ""}des fiestars",
                              style: AppTextStyle.black(14),
                            ),
                          ],
                        ),
                      ),
                      onTap: () {
                        AutoRouter.of(context).navigateNamed(
                          "/dashboard/fiesta/$fiestaId/note/$fiestaHostId",
                        );
                        Navigator.of(context).pop();
                      },
                    ),
                    sh(36),
                    CTA.primary(
                      textButton: "Noter maintenant",
                      width: double.infinity,
                      onTap: () {
                        // Utilisation de la note sélectionnée
                        debugPrint('Note attribuée: $note');
                        Navigator.of(context).pop();
                      },
                    ),
                    sh(22),
                    SizedBox(
                      width: double.infinity,
                      child: InkWell(
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        child: Center(
                          child: Text(
                            "Noter plus tard",
                            style: AppTextStyle.black(14),
                          ),
                        ),
                      ),
                    ),
                    sh(30),
                  ],
                ),
              );
            }

            return Shimmer.fromColors(
              period: const Duration(seconds: 2),
              baseColor: const Color(0xFF02132B).withValues(alpha: 0.08),
              highlightColor: const Color(0xFF02132B).withValues(alpha: 0.00),
              child: Column(
                children: [
                  sh(12),
                  Container(
                    width: formatWidth(47),
                    height: formatHeight(4),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(formatWidth(40)),
                      color: const Color(0xFFDDDFE2),
                    ),
                  ),
                  sh(17),
                  Center(
                    child: Container(
                      width: formatWidth(180),
                      height: formatHeight(30),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white,
                      ),
                    ),
                  ),
                  sh(29),
                  Container(
                    width: double.infinity,
                    height: formatHeight(96),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white,
                    ),
                  ),
                  sh(17),
                  Container(
                    width: formatWidth(280),
                    height: formatHeight(30),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white,
                    ),
                  ),
                  sh(12),
                  Container(
                    width: formatWidth(180),
                    height: formatHeight(30),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white,
                    ),
                  ),
                  sh(30),
                ],
              ),
            );
          },
        );
      },
    );
  }

  static Widget _buildFiestaCard(FiestaModel fiestaModel) {
    return LayoutBuilder(
      builder: (_, c) {
        return Container(
          width: c.maxWidth,
          height: formatHeight(96),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: const Color(0XFFF1674B).withValues(alpha: 0.09),
                blurRadius: 35,
                spreadRadius: 4,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              Expanded(
                child: Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: CachedNetworkImage(
                        imageUrl: fiestaModel.pictures!.first,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Positioned(
                      top: formatHeight(8),
                      left: formatWidth(10),
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: formatWidth(9),
                          vertical: formatHeight(6),
                        ),
                        decoration: BoxDecoration(
                          color: AppColor.mainColor,
                          borderRadius: BorderRadius.circular(100),
                        ),
                        child: Text(
                          "Terminée",
                          style: AppTextStyle.white(7, FontWeight.w500),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: formatWidth(12),
                    vertical: formatHeight(13),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(fiestaModel.title!, style: AppTextStyle.black(11)),
                      const Spacer(),
                      Text(
                        fiestaModel.address!.formattedText,
                        style: AppTextStyle.gray(10),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
