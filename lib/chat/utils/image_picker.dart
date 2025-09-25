import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:crop_your_image/crop_your_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:image_picker/image_picker.dart';

final ImagePicker _picker = ImagePicker();

Future<File?> _getImage(BuildContext context, ImageSource source) async {
  XFile? image = await _picker.pickImage(source: source);
  if (!context.mounted) return null;
  return (await _cropImage(context, image));
}

Future<File?> _cropImage(BuildContext context, XFile? image) async {
  if (image != null) {
    final imageBytes = await image.readAsBytes();

    if (!context.mounted) return null;

    final croppedData = await Navigator.push<Uint8List>(
      context,
      MaterialPageRoute(
        builder: (context) => _CropImagePage(imageData: imageBytes),
      ),
    );

    if (croppedData != null) {
      // Créer un fichier temporaire avec les données recadrées
      final tempDir = Directory.systemTemp;
      final tempFile = File(
        '${tempDir.path}/cropped_${DateTime.now().millisecondsSinceEpoch}.jpg',
      );
      await tempFile.writeAsBytes(croppedData);
      return tempFile;
    }
  }
  return null;
}

void getImage({
  required BuildContext context,
  required Function(File image) onImageSelected,
}) {
  showModalBottomSheet(
    context: context,
    builder: (context) => Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text("chat.choose-image".tr(), style: const TextStyle(fontSize: 20)),
          const SizedBox(height: 20),
          ListTile(
            title: Text(
              "chat.gallery".tr(),
              style: const TextStyle(color: Colors.blue),
            ),
            onTap: () async {
              Navigator.pop(context); // Fermer le modal d'abord
              File? croppedImage = await _getImage(
                context,
                ImageSource.gallery,
              );
              if ((croppedImage) != null) {
                onImageSelected(croppedImage);
              }
            },
          ),
          ListTile(
            title: Text(
              "chat.camera".tr(),
              style: const TextStyle(color: Colors.blue),
            ),
            onTap: () async {
              Navigator.pop(context); // Fermer le modal d'abord
              File? croppedImage = await _getImage(context, ImageSource.camera);
              if ((croppedImage) != null) {
                onImageSelected(croppedImage);
              }
            },
          ),
          ListTile(
            title: Text(
              'chat.cancel'.tr(),
              style: const TextStyle(color: Colors.grey),
            ),
            onTap: () => Navigator.pop(context),
          ),
        ],
      ),
    ),
  );
}

class _CropImagePage extends StatefulWidget {
  final Uint8List imageData;

  const _CropImagePage({required this.imageData});

  @override
  State<_CropImagePage> createState() => _CropImagePageState();
}

class _CropImagePageState extends State<_CropImagePage> {
  final _cropController = CropController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('chat.crop-image'.tr()),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: () {
              _cropController.crop();
            },
          ),
        ],
      ),
      body: Container(
        color: Colors.black,
        child: Crop(
          image: widget.imageData,
          controller: _cropController,
          onCropped: (croppedData) {
            Navigator.pop(context, croppedData);
          },
          aspectRatio: null, // Permet un recadrage libre
          maskColor: Colors.black.withValues(alpha: 0.8),
          cornerDotBuilder: (size, edgeAlignment) =>
              const DotControl(color: Colors.blue),
          interactive: true,
        ),
      ),
    );
  }
}
