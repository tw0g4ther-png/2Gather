import 'dart:io';

import 'package:blurhash_dart/blurhash_dart.dart';
import 'package:twogather/main.dart';
import '../../freezed/message/messageModel.dart';
import '../../isolate/isolateSendImage.dart';

import '../firestore/index.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';
import 'package:image/image.dart' as img;

Future sendImage({
  required File picture,
  required AssetEntity assetEntity,
  required MessageModel messageModel,
  required String salonId,
}) async {
  uploadFileToFirebase(picture.path, (val) async {
    assetEntity.thumbnailData.then((value) {
      final image = img.decodeImage(value!);
      var blurHash = BlurHash.encode(image!, numCompX: 2, numCompY: 2);
      FirestoreQuery.setMessage(
        messageModel.copyWith(
          temporaryPath: null,
          blur_hash: blurHash.hash,
          urlMediaContent: val,
        ),
        salonId: salonId,
      );
    });
  });
}

Future<void>? sendVideo({
  required File thumbnail,
  required File videoFile,
  required String thumbnailRelativePathImage,
  required MessageModel messageModel,
  required String salonId,
}) async {
  // Envoi direct de la vidéo sans compression
  uploadFileToFirebase(thumbnail.path, (urlThubmnail) async {
    uploadFileToFirebase(videoFile.path, (urlVideo) async {
      FirestoreQuery.setMessage(
        messageModel.copyWith(
          temporaryPath: null,
          urlMediaContent: urlVideo,
          thumbnail_relative_path: thumbnailRelativePathImage,
          thumbnail: urlThubmnail,
        ),
        salonId: salonId,
      );
    });
  });
}

Future sendAudio({
  required String relativePath,
  required MessageModel messageModel,
  required String salonId,
}) async {
  uploadFileToFirebase(directory!.path + relativePath, (val) async {
    FirestoreQuery.setMessage(
      messageModel.copyWith(temporaryPath: null, urlMediaContent: val),
      salonId: salonId,
    );
  });
}
