import 'package:core_kosmos/core_kosmos.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:twogather/model/color.dart';
import 'package:twogather/widgets/multi_image_picker.dart/core.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ui_kosmos_v4/ui_kosmos_v4.dart';
import 'dart:io';

/// Page complète pour choisir des images de profil
/// Basée sur la structure de choose_passion.dart
class ChooseImagesPage extends StatefulHookConsumerWidget {
  final Future<void> Function(List<File>)? onSubmit;
  final List<File>? initialImages;

  const ChooseImagesPage({super.key, this.onSubmit, this.initialImages});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ChooseImagesPageState();
}

class _ChooseImagesPageState extends ConsumerState<ChooseImagesPage> {
  final GlobalKey<MultiImagePickerState> _multiImagePickerKey = GlobalKey();

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
                sh(11),
                Text(
                  "app.add-photo".tr(),
                  style: AppTextStyle.gray(13, FontWeight.w600),
                ),
                sh(11),
                MultiImagePicker(
                  key: _multiImagePickerKey,
                  initialValue: widget.initialImages ?? [],
                  maxItem: 4,
                ),
                sh(70),
                CTA.primary(
                  textButton: "utils.next".tr(),
                  onTap: () async {
                    final images = _multiImagePickerKey.currentState
                        ?.getPickedImages();

                    if (images == null || images.isEmpty) {
                      NotifBanner.showToast(
                        context: context,
                        fToast: FToast().init(context),
                        title: "Attention !",
                        subTitle:
                            "Vous devez entrer au moins 1 photo de profil.",
                      );
                      return;
                    }

                    if (widget.onSubmit != null) {
                      await widget.onSubmit!(images);
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
