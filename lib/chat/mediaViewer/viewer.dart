import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';

import 'package:twogather/main.dart';

import '../enum/enumMessage.dart';
import '../freezed/assetItem/itemOfassets.dart';
import '../freezed/message/messageModel.dart';
import '../freezed/salon/salonModel.dart';
import '../freezed/user/userModel.dart';
import 'imageItem.dart';
import 'videoItem.dart';
import '../repertoire/indexRepertoire.dart';
import '../riverpods/me_notifier.dart';
import '../riverpods/salon_river.dart';
import '../riverpods/selected_assets.dart';
import '../services/storage/index.dart';
import '../utils/loader_ios.dart';
import '../widgets/bottomInput/text_input_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import '../../widgets/keyboard_footer_layout.dart';
// import 'package:video_compress/video_compress.dart'; // Supprimé - pas compatible null safety

class MediaViewer extends ConsumerStatefulWidget {
  final SalonModel salonModel;
  final UserModel? userModel;
  const MediaViewer({super.key, required this.salonModel, this.userModel});

  @override
  ConsumerState<MediaViewer> createState() => _MediaViewerState();
}

class _MediaViewerState extends ConsumerState<MediaViewer> {
  bool loading = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      ref.read(selectedAssets).setPainter(false);
      // Debug: Vérifier les assets
      final assets = ref.read(selectedAssets).mapAssets;
      debugPrint("[MediaViewer] Nombre d'assets: ${assets.length}");
      for (var entry in assets.entries) {
        debugPrint(
          "[MediaViewer] Asset ${entry.key}: ${entry.value.mediaType} - ${entry.value.assetEntity.type}",
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          FooterLayout(
            footer: _footer(),
            child: Stack(
              children: [
                Positioned.fill(
                  child: SingleChildScrollView(
                    physics: const NeverScrollableScrollPhysics(),
                    child: SizedBox(
                      height: 812.h,
                      child: Center(
                        child: PageView(
                          controller: ref.watch(selectedAssets).pageController,
                          onPageChanged: (index) =>
                              ref.read(selectedAssets).setIndex(index),
                          physics: ref.watch(selectedAssets).inPainting
                              ? const NeverScrollableScrollPhysics()
                              : const BouncingScrollPhysics(),
                          children: ref
                              .watch(selectedAssets)
                              .mapAssets
                              .entries
                              .map(
                                (e) => e.value.mediaType == MediaType.image
                                    ? KeepAlivePage(
                                        child: ImageItem(
                                          asset: e.value,
                                          clearAsset: () {
                                            ref
                                                .read(selectedAssets)
                                                .removeFromAssets(e.key);
                                          },
                                          index: e.key,
                                        ),
                                      )
                                    : KeepAlivePage(
                                        child: VideoItem(
                                          item: e.value,
                                          clearAsset: () {
                                            ref
                                                .read(selectedAssets)
                                                .removeFromAssets(e.key);
                                          },
                                        ),
                                      ),
                              )
                              .toList(),
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned.fill(
                  child: Column(children: [SizedBox(height: 40.h)]),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _footer() {
    return Container(
      color: Colors.transparent,
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: 18.w,
        ).copyWith(bottom: 20.h, top: 10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    minLines: 1,
                    maxLines: 5,
                    onChanged: (val) {
                      ref.read(selectedAssets).modifyCurrentMediaText(val);
                    },
                    controller: ref.watch(selectedAssets).textEditingController,
                    textInputAction: TextInputAction.newline,
                    decoration: InputDecoration(
                      hintText: "Ajouter une légende",
                      fillColor: Colors.white,
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 20.w,
                      ).copyWith(bottom: 20.h),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(29.r),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(29.r),
                      ),
                      filled: true,
                    ),
                  ),
                ),
                SizedBox(width: 10.w),
                Container(
                  decoration: const BoxDecoration(
                    color: Colors.blue,
                    shape: BoxShape.circle,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: IconButton(
                      onPressed: () async {
                        setState(() {
                          loading = true;
                        });
                        for (ItemOfAssets element
                            in ref.read(selectedAssets).mapAssets.values) {
                          File? file = element.file;
                          file ??= await element.assetEntity.file;

                          var id = uuid.v4();
                          switch (element.mediaType) {
                            case MediaType.image:
                              final boundary =
                                  element.globalKey.currentContext
                                          ?.findRenderObject()
                                      as RenderRepaintBoundary?;
                              if (boundary != null) {
                                var value = await boundary.toImage();
                                var byteData = await value.toByteData(
                                  format: ImageByteFormat.png,
                                );

                                file =
                                    await File(
                                      '${directory!.path}/${DateTime.now().millisecondsSinceEpoch}.png',
                                    ).writeAsBytes(
                                      byteData!.buffer.asUint8List(
                                        byteData.offsetInBytes,
                                        byteData.lengthInBytes,
                                      ),
                                    );
                              }

                              MessageModel msg0 = MessageModel(
                                sender: ref.read(meModelChangeNotifier).myUid!,
                                createdAt: DateTime.now(),
                                message: element.messge,
                                temporaryPath: file!.path,
                                type: MessageContentType.imageMessage,
                              ).copyWith(id: id);
                              ref
                                  .read(salonMessagesNotifier)
                                  .addMessage(messageModel: msg0);
                              unawaited(
                                sendImage(
                                  picture: file,
                                  messageModel: msg0,
                                  assetEntity: element.assetEntity,
                                  salonId: ref
                                      .read(messageFirestoreRiver)
                                      .idSalon!,
                                ),
                              );
                              break;
                            case MediaType.video:
                              var id = uuid.v4();

                              File? video = await element.assetEntity.file;
                              if (video != null) {
                                // Utilisation du thumbnail de l'AssetEntity au lieu de VideoCompress
                                Uint8List? thumb =
                                    await element.assetEntity.thumbnailData;
                                String? relativePath =
                                    "/thumbnail_${DateTime.now().millisecondsSinceEpoch}.png";

                                if (thumb != null) {
                                  File thumbFile = await File(
                                    directory!.path + relativePath,
                                  ).writeAsBytes(thumb);
                                  MessageModel msg = MessageModel(
                                    sender: ref
                                        .read(meModelChangeNotifier)
                                        .myUid!,
                                    temporaryPath: video.path,
                                    createdAt: DateTime.now(),
                                    message: element.messge,
                                    thumbnail_relative_path: relativePath,
                                    thumbnail_temporary_path: thumbFile.path,
                                    type: MessageContentType.videoMessage,
                                  ).copyWith(id: id);
                                  ref
                                      .read(salonMessagesNotifier)
                                      .addMessage(messageModel: msg);
                                  unawaited(
                                    sendVideo(
                                      thumbnail: thumbFile,
                                      videoFile: video,
                                      thumbnailRelativePathImage: relativePath,
                                      messageModel: msg,
                                      salonId: ref
                                          .read(messageFirestoreRiver)
                                          .idSalon!,
                                    ),
                                  );
                                }
                              }

                              break;
                          }
                        }
                        // ref.read(selectedAssets).mapAssets.values.forEach((element) async {

                        // });
                        setState(() {
                          loading = false;
                        });
                        if (!mounted) return;
                        Navigator.pop(context);
                      },
                      icon: loading
                          ? const LoaderClassique(radius: 10)
                          : SvgPicture.asset(
                              "assets/svg/send.svg",
                              colorFilter: ColorFilter.mode(
                                Colors.white,
                                BlendMode.srcIn,
                              ),
                            ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            SizedBox(
              height: 50.h,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: ref
                    .watch(selectedAssets)
                    .mapAssets
                    .entries
                    .map(
                      (e) => e.value.mediaType == MediaType.image
                          ? KeepAlivePage(
                              child: selectedImage(
                                e.value.assetEntity.file,
                                ref.watch(selectedAssets).indexOfPageView ==
                                    e.key,
                                onClick: () {
                                  ref.read(selectedAssets).setPageIndex(e.key);
                                },
                              ),
                            )
                          : KeepAlivePage(
                              child: selectedVideo(
                                e.value.assetEntity.thumbnailData,
                                ref.watch(selectedAssets).indexOfPageView ==
                                    e.key,
                                onClick: () {
                                  ref.read(selectedAssets).setPageIndex(e.key);
                                },
                              ),
                            ),
                    )
                    .toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Widget selectedImage(
  Future<File?> futureFile,
  bool current, {
  required VoidCallback onClick,
}) {
  return FutureBuilder(
    future: futureFile,
    builder: (context, AsyncSnapshot<File?> file) {
      if (file.hasData) {
        return InkWell(
          onTap: onClick,
          child: AnimatedContainer(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: current
                  ? Border.all(color: Colors.blueAccent, width: 2)
                  : null,
            ),
            duration: const Duration(milliseconds: 400),
            margin: EdgeInsets.only(right: 10.w),
            width: 50.w,
            height: 50.h,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(7),
              child: Image.file(file.data!, fit: BoxFit.cover),
            ),
          ),
        );
      } else {
        return const LoaderClassique();
      }
    },
  );
}

Widget selectedVideo(
  Future<Uint8List?> futureImage,
  bool current, {
  required VoidCallback onClick,
}) {
  return FutureBuilder(
    future: futureImage,
    builder: (context, AsyncSnapshot<Uint8List?> image) {
      if (image.hasData) {
        return InkWell(
          onTap: onClick,
          child: Stack(
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 400),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: current
                      ? Border.all(color: Colors.blueAccent, width: 2)
                      : null,
                ),
                margin: EdgeInsets.only(right: 10.w),
                width: 50.w,
                height: 50.h,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(7),
                  child: Image.memory(image.data!, fit: BoxFit.cover),
                ),
              ),
              Positioned(
                bottom: 0,
                top: 0,
                left: 0,
                right: 8.w,
                child: Padding(
                  padding: EdgeInsets.all(15.w),
                  child: SvgPicture.asset("assets/svg/play.svg"),
                ),
              ),
            ],
          ),
        );
      } else {
        return const LoaderClassique();
      }
    },
  );
}
