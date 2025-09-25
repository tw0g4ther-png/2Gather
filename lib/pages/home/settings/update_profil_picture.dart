import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:core_kosmos/core_kosmos.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:twogather/model/color.dart';
import 'package:twogather/model/user/fiestar_model.dart';
import 'package:twogather/services/storage.dart';
import 'package:twogather/widgets/multi_image_picker.dart/core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:skeleton_kosmos/skeleton_kosmos.dart';
import 'package:ui_kosmos_v4/ui_kosmos_v4.dart';

class UpdateProfilPictures extends StatefulHookConsumerWidget {
  const UpdateProfilPictures({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _UpdateProfilPicturesState();
}

class _UpdateProfilPicturesState extends ConsumerState<UpdateProfilPictures> {
  final GlobalKey<MultiImagePickerState> _multiImagePickerKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              sh(12),
              SizedBox(
                height: formatHeight(35),
                width: double.infinity,
                child: Stack(
                  children: [
                    Center(
                      child: Text(
                        "app.profil_pictures".tr(),
                        style: AppTextStyle.black(17),
                      ),
                    ),
                    Positioned(
                      top: 0,
                      left: 0,
                      bottom: 0,
                      child: InkWell(
                        onTap: () => AutoRouter.of(context).back(),
                        child: Icon(
                          Icons.arrow_back_ios_new_rounded,
                          color: Colors.black,
                          size: formatWidth(18),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              sh(50),
              FutureBuilder(
                future: _getProfileImages(),
                builder: (context, AsyncSnapshot<List<File>?> snapshot) {
                  if (snapshot.hasData) {
                    return Column(
                      children: [
                        MultiImagePicker(
                          key: _multiImagePickerKey,
                          initialValue: snapshot.data!,
                          initialImageUrls:
                              (ref.read(userChangeNotifierProvider).userData!
                                      as FiestarUserModel)
                                  .profilImages,
                          onImageDeleted: _deleteImageFromStorage,
                          maxItem: 4,
                        ),
                        sh(70),
                        CTA.primary(
                          width: double.infinity,
                          textButton: "utils.save".tr(),
                          onTap: () async {
                            final images = _multiImagePickerKey.currentState
                                ?.getPickedImages();

                            if (images == null || images.isEmpty) {
                              if (!mounted) {
                                return; // Éviter l'usage de context si démonté
                              }
                              NotifBanner.showToast(
                                context: context,
                                fToast: FToast().init(context),
                                title: "Attention !",
                                subTitle:
                                    "Vous devez entrer au moins 1 photo de profil.",
                              );
                              return;
                            }

                            // Capturer le router avant l'await pour éviter d'utiliser le BuildContext après un gap async
                            final router = AutoRouter.of(context);
                            await _updateProfilePictures(images);
                            if (!mounted) return;
                            router.back();
                          },
                        ),
                      ],
                    );
                  }
                  return const Center(child: LoaderClassique());
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<List<File>?> _getProfileImages() async {
    List<File> files = [];

    for (final e
        in (ref.read(userChangeNotifierProvider).userData! as FiestarUserModel)
                .profilImages ??
            []) {
      files.add(await StorageController.fileFromImageUrl(e));
    }
    return files;
  }

  /// Supprime une image de Firebase Storage lors du clic sur le bouton de suppression
  Future<void> _deleteImageFromStorage(String imageUrl) async {
    try {
      // Extraire le chemin du fichier depuis l'URL pour respecter les règles de sécurité
      final uri = Uri.parse(imageUrl);
      final pathSegments = uri.pathSegments;

      // Trouver l'index de 'o' dans le chemin pour extraire le chemin du fichier
      final oIndex = pathSegments.indexOf('o');
      if (oIndex != -1 && oIndex + 1 < pathSegments.length) {
        // Reconstruire le chemin en décodant les %2F
        final encodedPath = pathSegments.sublist(oIndex + 1).join('/');
        final decodedPath = Uri.decodeComponent(encodedPath);

        // Utiliser la référence directe avec le chemin décodé
        final ref = FirebaseStorage.instance.ref(decodedPath);
        await ref.delete();
        printInDebug("Image supprimée du Storage: $decodedPath");
      } else {
        printInDebug("Impossible d'extraire le chemin depuis l'URL: $imageUrl");
      }
    } catch (e) {
      printInDebug("Erreur lors de la suppression Storage pour $imageUrl: $e");
    }
  }

  Future<void> _updateProfilePictures(List<File> images) async {
    try {
      final List<String> urls = [];
      final List<String> uploadedImagePaths = []; // Pour le rollback
      // Images actuellement enregistrées côté Firestore (avant modifications)
      final List<String> existingImages =
          (ref.read(userChangeNotifierProvider).userData! as FiestarUserModel)
              .profilImages ??
          [];

      for (final imageFile in images) {
        try {
          final fileName = imageFile.path.split("/").last;

          // Recherche d'une correspondance basée sur le nom de fichier
          final existingImageList = existingImages.where((url) {
            try {
              final urlFileName = url
                  .split("/")
                  .last
                  .split("?")
                  .first; // Enlever les paramètres de requête
              return urlFileName == fileName;
            } catch (e) {
              return false;
            }
          }).toList();
          final existingImage = existingImageList.isNotEmpty
              ? existingImageList.first
              : null;

          if (existingImage != null) {
            // L'image existe déjà, on garde l'URL existante
            urls.add(existingImage);
          } else {
            // Nouvelle image, on l'upload
            final url = await StorageController.uploadToStorage(
              imageFile,
              "users/${FirebaseAuth.instance.currentUser!.uid}/profil/",
            );
            if (url == null) {
              throw Exception("Échec de l'upload de l'image");
            }
            urls.add(url);
            uploadedImagePaths.add(
              "users/${FirebaseAuth.instance.currentUser!.uid}/profil/$fileName",
            );
          }
        } catch (e) {
          // Rollback des images déjà uploadées
          await _rollbackUploadedImages(uploadedImagePaths);
          if (!mounted) return; // Éviter l'usage de context si démonté
          NotifBanner.showToast(
            context: context,
            fToast: FToast().init(context),
            title: "Erreur d'upload !",
            subTitle: "Impossible d'uploader les images. Veuillez réessayer.",
          );
          return;
        }
      }

      // Note: La suppression des images de Storage se fait maintenant directement
      // lors du clic sur le bouton de suppression dans MultiImagePicker

      // Mise à jour des données utilisateur
      final updateData = {
        "profilImages": urls,
        "profilImage": urls.isNotEmpty
            ? urls.first
            : null, // La première image devient l'image principale
        "lastSeen": DateTime.now(),
      };

      await FirebaseFirestore.instance
          .collection(GetIt.instance<ApplicationDataModel>().userCollectionPath)
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .update(updateData);

      // Les données seront automatiquement mises à jour via le stream Firestore
    } catch (e) {
      if (!mounted) return; // Éviter l'usage de context si démonté
      NotifBanner.showToast(
        context: context,
        fToast: FToast().init(context),
        title: "Erreur !",
        subTitle: "Une erreur inattendue s'est produite. Veuillez réessayer.",
      );
      printInDebug("Erreur lors de la mise à jour des photos de profil: $e");
    }
  }

  /// Supprime les images uploadées en cas d'échec partiel
  Future<void> _rollbackUploadedImages(List<String> imagePaths) async {
    try {
      for (final path in imagePaths) {
        try {
          await FirebaseStorage.instance.ref(path).delete();
          printInDebug("Image supprimée avec succès: $path");
        } catch (e) {
          printInDebug("Erreur lors de la suppression de l'image $path: $e");
        }
      }
    } catch (e) {
      printInDebug("Erreur lors du rollback des images: $e");
    }
  }
}
