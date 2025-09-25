import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

enum MediaSource { file, url }

class ShowMedia extends StatelessWidget {
  const ShowMedia({super.key, this.file, required this.source, this.mediaUrl});
  final MediaSource source;
  final String? mediaUrl;
  final File? file;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          InteractiveViewer(
            minScale: 0.1,
            maxScale: 4,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    height: 100.h,
                  ),
                  source == MediaSource.file
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              height: 700,
                              width: 350.w,
                              child: Image.file(
                                file!,
                                fit: BoxFit.contain,
                              ),
                            ),
                          ],
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              height: 700,
                              width: 350.w,
                              child: CachedNetworkImage(
                                imageUrl: mediaUrl!,
                                fit: BoxFit.contain,
                              ),
                            ),
                          ],
                        ),
                ],
              ),
            ),
          ),
          SizedBox(
            width: double.infinity,
            height: 100,
            child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
              InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Container(
                  width: 47.w,
                  height: 47.h,
                  margin: const EdgeInsets.only(top: 40),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(14.r),
                  ),
                  child: const Icon(
                    Icons.close,
                    color: Colors.white,
                  ),
                ),
              ),
              SizedBox(
                width: 30.w,
              ),
            ]),
          ),
        ],
      ),
    );
  }
}
