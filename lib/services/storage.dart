import 'dart:io';

import 'package:core_kosmos/core_package.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

abstract class StorageController {
  static Future<String?> uploadToStorage(File? file, [String? path]) async {
    if (file == null) {
      return null;
    }

    // Vérifier que l'utilisateur est authentifié
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      printInDebug("Erreur: Utilisateur non authentifié pour l'upload");
      throw Exception("Utilisateur non authentifié");
    }

    // Diagnostics d'authentification
    printInDebug("Utilisateur authentifié: ${currentUser.uid}");
    printInDebug("Email: ${currentUser.email}");
    printInDebug("Token valide: ${await currentUser.getIdToken()}");

    try {
      final fileName = file.path.split("/").last;
      final storagePath = path ?? "users/${currentUser.uid}/profil/";

      final fileSizeBytes = await file.length();
      printInDebug("Upload vers: $storagePath$fileName");
      printInDebug("Taille du fichier: $fileSizeBytes bytes");

      final ref = FirebaseStorage.instance.ref(storagePath).child(fileName);

      // Détecter le type de contenu basé sur l'extension
      String contentType = "image/jpeg";
      final extension = fileName.toLowerCase().split('.').last;
      switch (extension) {
        case 'png':
          contentType = "image/png";
          break;
        case 'jpg':
        case 'jpeg':
          contentType = "image/jpeg";
          break;
        case 'webp':
          contentType = "image/webp";
          break;
        case 'heic':
        case 'heif':
          // iOS peut fournir HEIC/HEIF; Storage accepte un contentType explicite
          contentType = "image/heif";
          break;
      }

      final fullPath = ref.fullPath;
      printInDebug("Référence Storage: $fullPath (contentType=$contentType)");

      await ref.putFile(file, SettableMetadata(contentType: contentType));
      printInDebug("$fileName uploadé avec succès vers FirebaseStorage");

      return await ref.getDownloadURL();
    } catch (e) {
      printInDebug("Erreur lors de l'upload: $e");
      rethrow;
    }
  }

  static Future<File> fileFromImageUrl(String uri) async {
    final response = await http.get(Uri.parse(uri));

    final documentDirectory = await getApplicationDocumentsDirectory();

    // Extraire le nom de fichier de l'URL Firebase Storage
    // Format: .../profil%2F1000015142.jpg?alt=media&token=...
    String fileName = '';

    if (uri.contains('%2F')) {
      // Extraire après le dernier %2F (équivalent de /)
      final parts = uri.split('%2F');
      final lastPart = parts.last;
      // Prendre tout avant le premier ? (paramètres de requête)
      fileName = lastPart.split('?').first;
    } else {
      // Fallback: utiliser un nom générique avec timestamp
      fileName = 'image_${DateTime.now().millisecondsSinceEpoch}.jpg';
    }

    // S'assurer que le nom de fichier est valide
    fileName = fileName.replaceAll(RegExp(r'[<>:"/\\|?*]'), '_');

    final file = File(join(documentDirectory.path, fileName));

    await file.writeAsBytes(response.bodyBytes);

    return file;
  }
}
