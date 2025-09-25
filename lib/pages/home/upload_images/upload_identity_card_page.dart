import 'dart:io';

import 'package:core_kosmos/core_kosmos.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:twogather/model/color.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ui_kosmos_v4/ui_kosmos_v4.dart';

/// Page complète pour uploader une carte d'identité
/// Basée sur la structure de choose_passion.dart
class UploadIdentityCardPage extends StatefulHookConsumerWidget {
  final Future<void> Function(File)? onSubmit;
  final File? initialImage;

  const UploadIdentityCardPage({super.key, this.onSubmit, this.initialImage});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _UploadIdentityCardPageState();
}

class _UploadIdentityCardPageState
    extends ConsumerState<UploadIdentityCardPage> {
  File? image;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          primary: false,
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: EdgeInsets.all(formatWidth(20)),
            child: Column(
              children: [
                SizedBox(
                  width: double.infinity,
                  child: Center(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: SizedBox(
                        width: 90,
                        height: 90,
                        child: Image.asset(
                          "assets/images/img_logo.png",
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                ),
                // Contenu principal calqué sur l'ancienne page CompleteProfil
                Text("app.create-profil".tr(), style: AppTextStyle.black(23)),
                sh(7),
                Text(
                  "app.ic-exemple".tr(),
                  style: AppTextStyle.gray(13, FontWeight.w600),
                ),
                sh(11),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset(
                      "assets/images/img_identity_card.png",
                      fit: BoxFit.cover,
                      width: formatWidth(311),
                      height: formatHeight(198),
                    ),
                  ],
                ),
                sh(16),
                Input.image(
                  imageMobile: image ?? widget.initialImage,
                  fieldName: "app.ic-your".tr(),
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
                sh(33),
                CTA.primary(
                  textButton: "utils.next".tr(),
                  onTap: () async {
                    if (image == null) {
                      NotifBanner.showToast(
                        context: context,
                        fToast: FToast().init(context),
                        title: "Attention !",
                        subTitle:
                            "Vous devez entrer une photo de votre carte d'identité.",
                      );
                      return;
                    }

                    if (widget.onSubmit != null) {
                      await widget.onSubmit!(image!);
                    }
                  },
                ),
                sh(12),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
