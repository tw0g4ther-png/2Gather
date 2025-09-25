import 'package:core_kosmos/core_kosmos.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:twogather/model/color.dart';
import 'package:twogather/pages/complete_profil/complete_profil.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ui_kosmos_v4/cta/cta.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FiestChart extends StatefulHookConsumerWidget {
  final Function? onSubmit;

  const FiestChart({super.key, this.onSubmit});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _FiestChartState();
}

class _FiestChartState extends ConsumerState<FiestChart> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text("app.create-profil".tr(), style: AppTextStyle.black(23)),
        sh(7),
        Text("app.chart.title".tr(), style: AppTextStyle.black(26)),
        sh(22),
        _buildSection(1, "app.chart.adult".tr()),
        sh(6),
        _buildSection(2, "app.chart.respect".tr()),
        sh(6),
        _buildSection(3, "app.chart.no-drugs".tr()),
        sh(6),
        _buildSection(4, "app.chart.neighbors".tr()),
        sh(6),
        _buildSection(5, "app.chart.no-surprise".tr()),
        sh(6),
        _buildSection(6, "app.chart.no-grief".tr()),
        sh(6),
        _buildSection(7, "app.chart.do-as-i-am-told".tr()),
        sh(6),
        _buildSection(8, "app.chart.sanction".tr()),
        sh(6),
        _buildSection(9, "app.chart.share".tr()),
        sh(6),
        _buildSection(10, "app.chart.no-photo".tr()),
        sh(43),
        CTA.primary(
          textButton: "app.chart.accept".tr(),
          onTap: () async {
            // Enregistrer l'acceptation de la charte
            ref
                .read(completeProfilProvider)
                .addFieldToData("chartAccepted", true);

            // Sauvegarder immédiatement toutes les données utilisateur dans Firestore
            try {
              // Utiliser le chemin de collection standard
              await FirebaseFirestore.instance
                  .collection("users")
                  .doc(FirebaseAuth.instance.currentUser!.uid)
                  .update({
                    ...ref.read(completeProfilProvider).data,
                    "createdAt": DateTime.now(),
                    "lastSeen": DateTime.now(),
                  });

              printInDebug(
                "[FiestChart] Données utilisateur sauvegardées avec succès",
              );
            } catch (e) {
              printInDebug("[FiestChart] Erreur lors de la sauvegarde: $e");
              // On continue même en cas d'erreur pour ne pas bloquer l'utilisateur
            }

            if (widget.onSubmit != null) {
              await widget.onSubmit!();
            }
          },
        ),
      ],
    );
  }

  Widget _buildSection(int number, String message) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      children: [
        Container(
          width: formatWidth(20),
          height: formatWidth(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: AppColor.mainColor,
          ),
          child: Center(
            child: Text(
              number.toString(),
              style: AppTextStyle.white(13, FontWeight.w600),
            ),
          ),
        ),
        sw(12),
        Expanded(child: Text(message, style: AppTextStyle.darkGray(13))),
      ],
    );
  }
}
