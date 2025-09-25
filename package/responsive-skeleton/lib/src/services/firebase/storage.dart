import 'dart:async';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import "package:image_picker/image_picker.dart";

/// Contrôleur Firebase Storage pour la gestion des fichiers et images
/// Fournit des méthodes pour upload, download et gestion des médias

class FirebaseStorageController {
  final FirebaseStorage instance = FirebaseStorage.instance;

  Future<String> loadImage(String path) async {
    if (path.isEmpty) return "";
    return await instance.ref(path).getDownloadURL();
  }

  Future<String?> uploadUserImage(String userId) async {
    if (kIsWeb) {
      // MediaInfo? mediaInfo = await ImagePickerWeb.getImageInfo;
      final ImagePicker imagePicker = ImagePicker();
      XFile? image = await imagePicker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        await image.readAsBytes();
        // setState(() {
        //   _file = File("a");
        //   webImage = f;
        // });
      } else {
        // showToast("No file selected");
      }
    } else {
      // showToast("Permission not granted");
    }

    //   if (mediaInfo != null) {
    //     String? mimeType = mime(basename(mediaInfo.fileName!));
    //     //change fileName
    //     Reference ref = FirebaseStorage.instance.ref().child('users/$userId/profil/').child('/profil-picture.png');

    //     final metadata = SettableMetadata(
    //       contentType: mimeType,
    //     );
    //     UploadTask uploadTask = ref.putData(mediaInfo.data!, metadata);
    //     var task = await uploadTask;
    //     String urlPicture = await task.ref.getDownloadURL();
    //     return urlPicture;
    //   }
    // }
    return null;
  }
}
