import 'dart:io';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

/// Demande les permissions de média nécessaires
Future<void> requestMediaPermissions(BuildContext context) async {
  try {
    // Vérifier et demander les permissions de caméra seulement si nécessaire
    final cameraStatus = await Permission.camera.status;
    if (cameraStatus.isDenied) {
      debugPrint("[MediaPermissions] Demande de permission caméra");
      await Permission.camera.request();
    } else {
      debugPrint("[MediaPermissions] Permission caméra déjà accordée");
    }

    // Vérifier et demander les permissions de stockage seulement si nécessaire
    final storageStatus = await Permission.storage.status;
    if (storageStatus.isDenied) {
      debugPrint("[MediaPermissions] Demande de permission stockage");
      await Permission.storage.request();
    } else {
      debugPrint("[MediaPermissions] Permission stockage déjà accordée");
    }

    // Pour Android 13+, vérifier et demander les nouvelles permissions seulement si nécessaire
    if (Platform.isAndroid) {
      final photosStatus = await Permission.photos.status;
      if (photosStatus.isDenied) {
        debugPrint("[MediaPermissions] Demande de permission photos");
        await Permission.photos.request();
      } else {
        debugPrint("[MediaPermissions] Permission photos déjà accordée");
      }

      final videosStatus = await Permission.videos.status;
      if (videosStatus.isDenied) {
        debugPrint("[MediaPermissions] Demande de permission vidéos");
        await Permission.videos.request();
      } else {
        debugPrint("[MediaPermissions] Permission vidéos déjà accordée");
      }
    }
  } catch (e) {
    debugPrint(
      "[MediaPermissions] Erreur lors de la demande de permissions: $e",
    );
  }
}

/// Affiche un dialogue quand les permissions sont refusées
void showPermissionDeniedDialog(BuildContext context, String permissionType) {
  // Vérifier si le contexte est toujours valide
  if (!context.mounted) {
    debugPrint(
      "[MediaPermissions] Contexte invalide, impossible d'afficher le dialogue",
    );
    return;
  }

  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Permission requise'),
      content: Text(
        'Pour utiliser la $permissionType, veuillez autoriser l\'accès dans les paramètres de l\'application.',
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Annuler'),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
            openAppSettings();
          },
          child: const Text('Paramètres'),
        ),
      ],
    ),
  );
}
