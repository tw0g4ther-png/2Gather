import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:twogather/main.dart';
import '../chatStyle.dart';
import '../enum/enumMessage.dart';
import '../freezed/message/messageModel.dart';

import '../riverpods/salon_river.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:animated/animated.dart';
import 'package:flutter_svg/svg.dart';

Widget replyToWidget(MessageModel? messageModel, WidgetRef ref) => Stack(
      children: [
        Transform.translate(
            offset: Offset(0, 50.h),
            child: Container(
              width: double.infinity,
              height: 100,
              color: Colors.white,
            )),
        Container(
          width: double.infinity,
          height: 85.h,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(35.r),
                  topRight: Radius.circular(35.r)),
              boxShadow: [
                BoxShadow(
                    blurRadius: 30,
                    offset: const Offset(0, -10),
                    color: Colors.black.withValues(alpha: 0.04))
              ],
              color: Colors.white),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              messageModel!.type == MessageContentType.textMessage
                  ? repliedText(messageModel, ref)
                  : messageModel.type == MessageContentType.imageMessage
                          ? repliedPicture(messageModel, ref)
                          : messageModel.type == MessageContentType.videoMessage
                              ? repliedVideo(messageModel, ref)
                              : const SizedBox(),
              IconButton(
                  onPressed: () {
                    ref.read(salonMessagesNotifier).setRepliedMessage(null);
                  },
                  icon: const Icon(
                    Icons.clear,
                    color: Color(0XFF949494),
                    size: 28,
                  ))
            ],
          ),
        ),
      ],
    );
Widget repliedPicture(MessageModel? messageModel, WidgetRef ref) {
  return Container(
    width: 256.w,
    height: 45.h,
    decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(7.r)),
        color: const Color(0XFFF6F6F6)),
    child: Padding(
      padding: EdgeInsets.only(left: 13.w, right: 6.w),
      child: Row(
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  ref
                          .watch(messageFirestoreRiver)
                          .participant
                          .containsKey(messageModel!.sender)
                      ? ref
                              .watch(messageFirestoreRiver)
                              .participant[messageModel.sender]!
                              .firstname ??
                          ""
                      : "",
                  style: ChatStyle.repliedMessagePseudoLeftStyle,
                ),
                SizedBox(
                  height: 4.h,
                ),
                Row(
                  children: [
                    SizedBox(
                        width: 12.5.w,
                        height: 12.5.h,
                        child: SvgPicture.asset(
                          "assets/svg/gallery.svg",
                          colorFilter: const ColorFilter.mode(
                              Color(0XFF919191), BlendMode.srcIn),
                          fit: BoxFit.cover,
                        )),
                    SizedBox(
                      width: 5.w,
                    ),
                    const Text(
                      "Photo",
                      style: TextStyle(fontSize: 12, color: Color(0XFF939393)),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 4.h).copyWith(right: 6.w),
            child: SizedBox(
              width: 35.w,
              height: 35,
              child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(4.r)),
                child: messageModel.temporaryPath != null
                    ? Image.file(
                        (File(messageModel.temporaryPath!)),
                        fit: BoxFit.cover,
                      )
                    : CachedNetworkImage(
                        imageUrl: messageModel.urlMediaContent!,
                        fit: BoxFit.cover,
                      ),
              ),
            ),
          )
        ],
      ),
    ),
  );
}

Widget repliedVideo(MessageModel? messageModel, WidgetRef ref) {
  return Container(
    width: 256.w,
    height: 45.h,
    decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(7.r)),
        color: const Color(0XFFF6F6F6)),
    child: Padding(
      padding: EdgeInsets.only(left: 13.w, right: 6.w),
      child: Row(
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  ref
                          .watch(messageFirestoreRiver)
                          .participant
                          .containsKey(messageModel!.sender)
                      ? ref
                              .watch(messageFirestoreRiver)
                              .participant[messageModel.sender]!
                              .firstname ??
                          ""
                      : "",
                  style: ChatStyle.repliedMessagePseudoLeftStyle,
                ),
                SizedBox(
                  height: 4.h,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 12.5.w,
                      height: 12.5.h,
                      child: SvgPicture.asset(
                        "assets/svg/play.svg",
                        fit: BoxFit.contain,
                        colorFilter: const ColorFilter.mode(
                            Color(0XFF909090), BlendMode.srcIn),
                      ),
                    ),
                    const Text(
                      "Vidéos",
                      style: TextStyle(fontSize: 12, color: Color(0XFF939393)),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 4.h).copyWith(right: 6.w),
            child: SizedBox(
              width: 35.w,
              height: 35.h,
              child: Stack(
                children: [
                  Positioned.fill(
                    child: ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(4.r)),
                      child: messageModel.thumbnail_relative_path != null
                          ? Image.file(
                              (File(directory!.path +
                                  messageModel.thumbnail_relative_path!)),
                              fit: BoxFit.cover,
                            )
                          : CachedNetworkImage(
                              imageUrl: messageModel.thumbnail!,
                              fit: BoxFit.cover,
                            ),
                    ),
                  ),
                  Center(
                    child: SizedBox(
                      width: 12.5.w,
                      height: 12.5.h,
                      child: SvgPicture.asset(
                        "assets/svg/play.svg",
                        fit: BoxFit.contain,
                        colorFilter: const ColorFilter.mode(
                            Colors.white, BlendMode.srcIn),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    ),
  );
}

Widget repliedAudio(MessageModel? messageModel, WidgetRef ref) {
  return Container(
    width: 256.w,
    height: 45.h,
    decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(7.r)),
        color: const Color(0XFFF6F6F6)),
    child: Padding(
      padding: EdgeInsets.only(left: 13.w, right: 6.w),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            ref
                    .watch(messageFirestoreRiver)
                    .participant
                    .containsKey(messageModel!.sender)
                ? ref
                        .watch(messageFirestoreRiver)
                        .participant[messageModel.sender]!
                        .firstname ??
                    ""
                : "",
            style: ChatStyle.repliedMessagePseudoLeftStyle,
          ),
          SizedBox(
            height: 4.h,
          ),
          Row(
            children: [
              SizedBox(
                width: 12.5.w,
                height: 12.5.h,
                child: SvgPicture.asset(
                  "assets/svg/mic.svg",
                  colorFilter: const ColorFilter.mode(
                      Color(0XFF909090), BlendMode.srcIn),
                ),
              ),
              SizedBox(width: 5.w),
              Text(messageModel.duration ?? "",
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w500,
                      color: const Color(0XFF919191)))
            ],
          ),
        ],
      ),
    ),
  );
}

Widget repliedText(MessageModel? messageModel, WidgetRef ref) {
  return Container(
    width: 256.w,
    height: 45.h,
    decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(7.r)),
        color: const Color(0XFFF6F6F6)),
    child: Padding(
      padding: EdgeInsets.only(left: 13.w, right: 6.w),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            ref
                    .watch(messageFirestoreRiver)
                    .participant
                    .containsKey(messageModel!.sender)
                ? ref
                        .watch(messageFirestoreRiver)
                        .participant[messageModel.sender]!
                        .firstname ??
                    ""
                : "",
            style: ChatStyle.repliedMessagePseudoLeftStyle,
          ),
          SizedBox(
            height: 4.h,
          ),
          Row(
            children: [
              Expanded(
                  child: Text(messageModel.message ?? "",
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontSize: 12.sp))),
              SizedBox(
                width: 60.w,
              )
            ],
          ),
        ],
      ),
    ),
  );
}

class RepliedWidget extends ConsumerStatefulWidget {
  @override
  RepliedWidgetState createState() => RepliedWidgetState();
}

class RepliedWidgetState extends ConsumerState<RepliedWidget> {
  bool scaled = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          scaled = !scaled;
        });
      },
      child: Animated(
          value:
              ref.watch(salonMessagesNotifier).repliedMessage != null ? 1 : 0,
          curve: Curves.fastOutSlowIn,
          duration: const Duration(milliseconds: 1000),
          builder: (context, child, animation) => Transform.scale(
                scale: animation.value,
                child: child,
              ),
          child: replyToWidget(
              ref.watch(salonMessagesNotifier).repliedMessage, ref)),
    );
  }
}
