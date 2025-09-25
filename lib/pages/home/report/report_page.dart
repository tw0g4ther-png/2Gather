import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:core_kosmos/core_kosmos.dart';
import 'package:twogather/controller/report_controller.dart';
import 'package:twogather/model/color.dart';
import 'package:twogather/model/report/report_model.dart';
import "package:flutter/material.dart";
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:skeleton_kosmos/skeleton_kosmos.dart';
import 'package:ui_kosmos_v4/ui_kosmos_v4.dart';

const List<ReportModel> profilReport = [
  ReportModel(
    tag: "picture_of_other_user",
    desc: "La photo appartient à un autre utilisateur.",
    value: 0,
    duration: Duration.zero,
  ),
  ReportModel(
    tag: "user_minor",
    desc: "Cet utilisateur est mineur.",
    value: 0,
    duration: Duration.zero,
  ),
  ReportModel(
    tag: "user_do_pub",
    desc: "Cet utilisateur fait de la publicité.",
    value: 10,
    duration: Duration(days: 21),
  ),
  ReportModel(
    tag: "user_request_money",
    desc: "Cet utilisateur m'a demandé de l'argent.",
    value: 17,
    duration: Duration(days: 21),
  ),
  ReportModel(
    tag: "user_false_profil",
    desc: "Ce profil est un faux profil.",
    value: 0,
    duration: Duration.zero,
  ),
  ReportModel(tag: "other", desc: "Autres", value: 0, duration: Duration.zero),
];

const List<ReportModel> profilPictureReport = [
  ReportModel(
    tag: "picture_nude",
    desc: "Les photos contiennent de la nudité",
    value: 0,
    duration: Duration.zero,
  ),
  ReportModel(
    tag: "picture_violent",
    desc: "Les photos est violente",
    value: 20,
    duration: Duration(days: 28),
  ),
  ReportModel(tag: "other", desc: "Autres", value: 0, duration: Duration.zero),
];

const List<ReportModel> descriptionReport = [
  ReportModel(
    tag: "description_merch",
    desc: "La description vend un produit",
    value: 17,
    duration: Duration(days: 21),
  ),
  ReportModel(
    tag: "description_sex",
    desc: "La description est sexuelle",
    value: 20,
    duration: Duration(days: 28),
  ),
  ReportModel(
    tag: "description_violent",
    desc: "La description est incitation à la haine",
    value: 20,
    duration: Duration(days: 28),
  ),
  ReportModel(tag: "other", desc: "Autres", value: 0, duration: Duration.zero),
];

const List<ReportModel> offlineReport = [
  ReportModel(
    tag: "offline_just_report",
    desc: "Je connais cette personne et souhaite la signaler",
    value: 17,
    duration: Duration(days: 21),
  ),
  ReportModel(
    tag: "offline_harassment",
    desc: "Cette personne m'a harcelé sur un autre réseau",
    value: 50,
    duration: Duration(days: 42),
  ),
  ReportModel(tag: "other", desc: "Autres", value: 0, duration: Duration.zero),
];

const List<ReportModel> chatReport = [
  ReportModel(
    tag: "chat_vulgaire",
    desc: "Cet utilisateur a été vulgaire par messagerie",
    value: 17,
    duration: Duration(days: 21),
  ),
  ReportModel(
    tag: "chat_harassment",
    desc: "Cet utilisateur me harcèle par messagerie",
    value: 17,
    duration: Duration(days: 21),
  ),
  ReportModel(
    tag: "chat_pub",
    desc: "Cet utilisateur me fait de la pub par messagerie",
    value: 10,
    duration: Duration(days: 21),
  ),
  ReportModel(
    tag: "chat_sex",
    desc: "Cet utilisateur m'envoi des messages sexuels",
    value: 20,
    duration: Duration(days: 28),
  ),
  ReportModel(
    tag: "chat_violent",
    desc: "Cet utilisateur m'envoi des messages violent",
    value: 20,
    duration: Duration(days: 28),
  ),
  ReportModel(
    tag: "chat_suspect_link",
    desc: "Cet utilisateur m'envoi des liens suspect",
    value: 10,
    duration: Duration(days: 21),
  ),
  ReportModel(tag: "other", desc: "Autres", value: 0, duration: Duration.zero),
];

const List<ReportModel> fiestaHomeReport = [
  ReportModel(
    tag: "fiesta_home_damage",
    desc: "Cet utilisateur a causé des dégats au lieu de la Fiesta",
    value: 17,
    duration: Duration(days: 28),
  ),
  ReportModel(
    tag: "fiesta_home_vol",
    desc: "Cet utilisateur a volé quelques choses pendant la Fiesta",
    value: 25,
    duration: Duration(days: 41),
  ),
  ReportModel(
    tag: "fiesta_home_no_respect",
    desc: "Cet utilisateur n'a pas respecté les règles de la Fiesta",
    value: 10,
    duration: Duration(days: 21),
  ),
  ReportModel(tag: "other", desc: "Autres", value: 0, duration: Duration.zero),
];

const List<ReportModel> fiestaReport = [
  ReportModel(
    tag: "fiesta_not_present",
    desc: "Cet utilisateur n'est pas venu à la Fiesta",
    value: 10,
    duration: Duration(days: 14),
  ),
  ReportModel(
    tag: "fiesta_late",
    desc: "Cet utilisateur est venu très en retard à la Fiesta",
    value: 10,
    duration: Duration(days: 14),
  ),
  ReportModel(
    tag: "fiesta_no_respect_voisin",
    desc: "Cet utilisateur n'a pas été respectueux avec les voisins",
    value: 10,
    duration: Duration(days: 21),
  ),
  ReportModel(
    tag: "fiesta_no_respect_theme",
    desc: "Cet utilisateur n'a pas respecté le thème de la Fiesta",
    value: 10,
    duration: Duration(days: 14),
  ),
  ReportModel(
    tag: "fiesta_bad_comportment",
    desc: "Cet utilisateur a eu un mauvais comportement / tenu",
    value: 17,
    duration: Duration(days: 21),
  ),
  ReportModel(
    tag: "fiesta_dont_leave",
    desc: "Cet utilisateur n'a pas voulu partir",
    value: 20,
    duration: Duration(days: 28),
  ),
  ReportModel(
    tag: "fiesta_high_sound",
    desc: "Cet utilisateur ne sait pas être silencieux",
    value: 10,
    duration: Duration(days: 21),
  ),
  ReportModel(
    tag: "fiesta_want_control_music",
    desc: "Cet utilisateur veut prendre le contrôle de la musique",
    value: 10,
    duration: Duration(days: 21),
  ),
  ReportModel(
    tag: "fiesta_want_add_personn",
    desc: "Cet utilisateur a voulu ajouté une ou plusieurs personnes",
    value: 20,
    duration: Duration(days: 28),
  ),
  ReportModel(
    tag: "fiesta_aggresivity",
    desc: "Cet utilisateur a eu un comporement aggressif / abusif",
    value: 20,
    duration: Duration(days: 28),
  ),
  ReportModel(
    tag: "fiesta_no_participation",
    desc: "Cet utilisateur n'a pas contribué à la Fiesta",
    value: 15,
    duration: Duration(days: 28),
  ),
  ReportModel(
    tag: "fiesta_drink_other_person",
    desc:
        "Cet utilisateur a consommé quelques choses qui ne lui appartenait pas",
    value: 15,
    duration: Duration(days: 28),
  ),
  ReportModel(
    tag: "fiesta_bad_conversation",
    desc: "Cet utilisateur a eu des propos choquants",
    value: 15,
    duration: Duration(days: 21),
  ),
  ReportModel(tag: "other", desc: "Autres", value: 0, duration: Duration.zero),
];

@RoutePage()
class ReportPage extends StatefulHookConsumerWidget {
  final String userId;
  final String? reportedSubUser;

  const ReportPage({
    super.key,
    @PathParam("userId") required this.userId,
    @QueryParam("subUserId") this.reportedSubUser,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ReportPageState();
}

class _ReportPageState extends ConsumerState<ReportPage> {
  String? desc;
  ValueNotifier<String?> motif = ValueNotifier(null);
  ValueNotifier<ReportModel?> report = ValueNotifier(null);

  File? image;

  @override
  Widget build(BuildContext context) {
    return ScrollingPage(
      useSafeArea: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          sh(12),
          CTA.back(onTap: () => AutoRouter.of(context).back()),
          sh(41),
          Text("Signaler un problème", style: AppTextStyle.black(24)),
          sh(7),
          Text(
            "Vous rencontrer un problème lors d’une Fiesta ou simplement d’un utilisateur ? Dites-le nous.",
            style: AppTextStyle.gray(13),
          ),
          sh(31),
          ValueListenableBuilder(
            valueListenable: motif,
            builder: (context, String? val, child) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ModernDropdownField<String>(
                    fieldName: "Catégorie du problème",
                    value: val,
                    onChanged: (p0) {
                      report.value = null;
                      motif.value = p0;
                    },
                    items: const [
                      DropdownMenuItem(value: "profil", child: Text("Profil")),
                      DropdownMenuItem(value: "photos", child: Text("Photos")),
                      DropdownMenuItem(
                        value: "description",
                        child: Text("Description"),
                      ),
                      DropdownMenuItem(
                        value: "offline",
                        child: Text("Hors Ligne"),
                      ),
                      DropdownMenuItem(value: "tchat", child: Text("Tchat")),
                      DropdownMenuItem(
                        value: "fiesta_home",
                        child: Text("Lieu de la Fiesta"),
                      ),
                      DropdownMenuItem(value: "fiesta", child: Text("Fiesta")),
                      DropdownMenuItem(value: "other", child: Text("Autres")),
                    ],
                  ),
                  if (val != null && val != "other") ...[
                    sh(19),
                    ValueListenableBuilder(
                      valueListenable: report,
                      builder: (context, ReportModel? active, child) {
                        return _generateReport(val, active);
                      },
                    ),
                  ],
                ],
              );
            },
          ),
          sh(19),
          TextFormUpdated.textarea(
            fieldName: "Précisez votre problème",
            hintText: "Écrivez quelques choses..",
            onChanged: (p0) => desc = p0,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(7),
              borderSide: BorderSide.none,
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(7),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(7),
              borderSide: BorderSide.none,
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(7),
              borderSide: BorderSide.none,
            ),
          ),
          sh(19),
          Input.image(
            fieldName: "Joindre des photos",
            imageMobile: image,
            onTap: () async {
              final image = await ImagePicker().pickImage(
                source: ImageSource.gallery,
              );
              if (image != null) {
                setState(() {
                  this.image = File(image.path);
                });
              }
            },
          ),
          sh(30),
          CTA.primary(
            textButton: "Soumettre le signalement",
            width: double.infinity,
            onTap: () async {
              if (report.value == null) {
                NotifBanner.showToast(
                  context: context,
                  fToast: FToast().init(context),
                  subTitle: "Veuillez choisir une catégorie et un motif",
                );
                return;
              }
              await ReportController.reportUser(
                widget.userId,
                widget.reportedSubUser,
                report.value!,
                desc,
                image,
              );
              if (!context.mounted) return;
              AutoRouter.of(context).back();
              AutoRouter.of(
                context,
              ).navigateNamed("/dashboard/report/response/success/");
            },
          ),
          sh(30),
        ],
      ),
    );
  }

  Widget _generateReport(String val, ReportModel? activeMotif) {
    if (val == "profil") {
      return ModernDropdownField<ReportModel>(
        fieldName: "Motif",
        onChanged: (p1) => report.value = p1,
        value: activeMotif,
        items: [
          for (final e in profilReport)
            DropdownMenuItem(
              value: e,
              child: Text(e.desc!, overflow: TextOverflow.ellipsis),
            ),
        ],
      );
    }
    if (val == "photos") {
      return ModernDropdownField<ReportModel>(
        fieldName: "Motif",
        onChanged: (p1) => report.value = p1,
        value: activeMotif,
        items: [
          for (final e in profilPictureReport)
            DropdownMenuItem(
              value: e,
              child: Text(e.desc!, overflow: TextOverflow.ellipsis),
            ),
        ],
      );
    }
    if (val == "description") {
      return ModernDropdownField<ReportModel>(
        fieldName: "Motif",
        onChanged: (p1) => report.value = p1,
        value: activeMotif,
        items: [
          for (final e in descriptionReport)
            DropdownMenuItem(
              value: e,
              child: Text(e.desc!, overflow: TextOverflow.ellipsis),
            ),
        ],
      );
    }
    if (val == "offline") {
      return ModernDropdownField<ReportModel>(
        fieldName: "Motif",
        onChanged: (p1) => report.value = p1,
        value: activeMotif,
        items: [
          for (final e in offlineReport)
            DropdownMenuItem(
              value: e,
              child: Text(e.desc!, overflow: TextOverflow.ellipsis),
            ),
        ],
      );
    }
    if (val == "tchat") {
      return ModernDropdownField<ReportModel>(
        fieldName: "tchat",
        onChanged: (p1) => report.value = p1,
        value: activeMotif,
        items: [
          for (final e in chatReport)
            DropdownMenuItem(
              value: e,
              child: Text(e.desc!, overflow: TextOverflow.ellipsis),
            ),
        ],
      );
    }
    if (val == "fiesta_home") {
      return ModernDropdownField<ReportModel>(
        fieldName: "tchat",
        onChanged: (p1) => report.value = p1,
        value: activeMotif,
        items: [
          for (final e in fiestaHomeReport)
            DropdownMenuItem(
              value: e,
              child: Text(e.desc!, overflow: TextOverflow.ellipsis),
            ),
        ],
      );
    }
    if (val == "fiesta") {
      return ModernDropdownField<ReportModel>(
        fieldName: "tchat",
        onChanged: (p1) => report.value = p1,
        value: activeMotif,
        items: [
          for (final e in fiestaReport)
            DropdownMenuItem(
              value: e,
              child: Text(
                e.desc!,
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
              ),
            ),
        ],
      );
    }
    return const SizedBox();
  }
}
