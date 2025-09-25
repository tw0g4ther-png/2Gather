import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import '../riverpods/salon_river.dart';
import 'image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:iconsax/iconsax.dart';

class UploadWidgetImage extends ConsumerStatefulWidget {
  final VoidCallback done;
  final String salonId;
  final bool allowModifiy;

  const UploadWidgetImage({
    super.key,
    required this.done,
    required this.salonId,
    required this.allowModifiy,
  });
  @override
  UploadWidgetImageState createState() => UploadWidgetImageState();
}

class UploadWidgetImageState extends ConsumerState<UploadWidgetImage> {
  File? _profilePicture;
  double _progress = 0;
  bool _loading = true;
  String? profilImage;
  @override
  void initState() {
    super.initState();
    getPictureUrl().then((value) {
      setState(() {
        profilImage = value;
        widget.done();
        _loading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        InkWell(
          onTap: widget.allowModifiy
              ? () {
                  getImage(
                    context: context,
                    onImageSelected: (File file) {
                      setState(() {
                        _profilePicture = file;
                      });
                      uploadPictureWithLoading(file: _profilePicture!);
                    },
                  );
                }
              : null,
          child: Center(
            child: Stack(
              children: [
                CircleAvatar(
                  radius: 46.5.r,
                  backgroundColor: const Color(0XFFE0E0E0),
                  backgroundImage:
                      (ref
                              .watch(messageFirestoreRiver)
                              .currentSalon
                              ?.salonPicture !=
                          null)
                      ? CachedNetworkImageProvider(
                          ref
                              .watch(messageFirestoreRiver)
                              .currentSalon!
                              .salonPicture!,
                        )
                      : null,
                  child:
                      (ref
                              .watch(messageFirestoreRiver)
                              .currentSalon
                              ?.salonPicture ==
                          null)
                      ? SvgPicture.asset("assets/svg/group.svg")
                      : null,
                ),
                if (widget.allowModifiy)
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.grey,
                      ),
                      child: const Padding(
                        padding: EdgeInsets.all(5.0),
                        child: Center(
                          child: Icon(
                            Iconsax.edit,
                            size: 17,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
        _loading
            ? Container(
                width: 50,
                color: Colors.white.withValues(alpha: 1 - _progress),
              )
            : const SizedBox(),
        _loading
            ? const Positioned.fill(
                bottom: 0,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(backgroundColor: Colors.grey),
                  ],
                ),
              )
            : const SizedBox(),
      ],
    );
  }

  Future<void> uploadPictureWithLoading({required File file}) async {
    setState(() {
      _loading = true;
    });
    UploadTask taskUpload = FirebaseStorage.instance
        .ref()
        .child("Salon/${widget.salonId}/salonPicture")
        .putFile(file);
    taskUpload.snapshotEvents
        .listen((event) {
          setState(() {
            _progress = event.bytesTransferred.toDouble() / event.totalBytes;
            // Progress: ${_progress.toString()}
          });
        })
        .onError((error) {
          // Upload error occurred
        });
    var task = await taskUpload;
    String urlPicture = await task.ref.getDownloadURL();
    Map<String, dynamic> data = {};
    data["salonPicture"] = urlPicture;
    FirebaseFirestore.instance
        .collection("Salons")
        .doc(widget.salonId)
        .update(data);
    setState(() {
      _loading = false;
    });
    widget.done();
  }

  Future<String?> getPictureUrl() async {
    DocumentSnapshot<Map<String, dynamic>> doc = await FirebaseFirestore
        .instance
        .collection("Salons")
        .doc(widget.salonId)
        .get();
    if (doc.exists) {
      if (doc.data()!.containsKey("salonPicture")) {
        return doc.get("salonPicture");
      }
    }
    return null;
  }
}
