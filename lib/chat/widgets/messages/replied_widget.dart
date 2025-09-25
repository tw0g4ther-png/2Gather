import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:twogather/main.dart';
import '../../chatColor.dart';
import '../../chatStyle.dart';
import '../../enum/enumMessage.dart';
import '../../freezed/message/messageModel.dart';

import '../../riverpods/me_notifier.dart';
import '../../riverpods/salon_river.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

Widget repliedMessageContent(
  MessageModel messageModel,
  bool sendedByMe,
  WidgetRef ref,
) {
  switch (messageModel.type) {
    case MessageContentType.videoMessage:
      return repliedVideoMessage(messageModel, sendedByMe, ref);

    case MessageContentType.textMessage:
      return repliedTextMessage(messageModel, sendedByMe, ref);

    case MessageContentType.imageMessage:
      return repliedPictureMessage(messageModel, sendedByMe, ref);
    case MessageContentType.lockDemandMessage:
      return const SizedBox();
  }
}

Widget repliedPictureMessage(
  MessageModel messageModel,
  bool sendedByMe,
  WidgetRef ref,
) {
  return Container(
    constraints: BoxConstraints(maxWidth: 230.w),
    height: 45.h,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.all(Radius.circular(7.r)),
      color: sendedByMe
          ? ChatColor.bubble_reply_message_replied_content_right
          : ChatColor.bubble_reply_message_replied_content_left,
    ),
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
                  messageModel.sender == ref.watch(meModelChangeNotifier).myUid
                      ? "Moi"
                      : ref
                            .watch(messageFirestoreRiver)
                            .participant
                            .containsKey(messageModel.sender)
                      ? ref
                                .watch(messageFirestoreRiver)
                                .participant[messageModel.sender]!
                                .firstname ??
                            ""
                      : "",
                  style: sendedByMe
                      ? ChatStyle.repliedMessagePseudoRightStyle
                      : ChatStyle.repliedMessagePseudoLeftStyle,
                ),
                SizedBox(height: 4.h),
                Row(
                  children: [
                    SizedBox(
                      width: 12.5.w,
                      height: 12.5.h,
                      child: SvgPicture.asset(
                        "assets/svg/gallery.svg",
                        colorFilter: ColorFilter.mode(
                          sendedByMe
                              ? ChatColor
                                    .bubble_reply_message_replied_content_icon_type_right_color
                              : ChatColor
                                    .bubble_reply_message_replied_content_icon_type_left_color,
                          BlendMode.srcIn,
                        ),
                        fit: BoxFit.cover,
                      ),
                    ),
                    SizedBox(width: 5.w),
                    Text(
                      "Photo",
                      style: TextStyle(
                        fontSize: 12,
                        color:
                            (sendedByMe
                                    ? ChatColor
                                          .bubble_reply_message_replied_content_icon_type_right_color
                                    : ChatColor
                                          .bubble_reply_message_replied_content_icon_type_left_color)
                                .withValues(alpha: 0.7),
                      ),
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
          ),
        ],
      ),
    ),
  );
}

Widget repliedVideoMessage(
  MessageModel messageModel,
  bool sendedByMe,
  WidgetRef ref,
) {
  return Container(
    constraints: BoxConstraints(maxWidth: 230.w, minWidth: 100.w),
    height: 45.h,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.all(Radius.circular(7.r)),
      color: sendedByMe
          ? ChatColor.bubble_reply_message_replied_content_right
          : ChatColor.bubble_reply_message_replied_content_left,
    ),
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
                  messageModel.sender == ref.watch(meModelChangeNotifier).myUid
                      ? "Moi"
                      : ref
                            .watch(messageFirestoreRiver)
                            .participant
                            .containsKey(messageModel.sender)
                      ? ref
                                .watch(messageFirestoreRiver)
                                .participant[messageModel.sender]!
                                .firstname ??
                            ""
                      : "",
                  style: sendedByMe
                      ? ChatStyle.repliedMessagePseudoRightStyle
                      : ChatStyle.repliedMessagePseudoLeftStyle,
                ),
                SizedBox(height: 4.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 12.5.w,
                      height: 12.5.h,
                      child: SvgPicture.asset(
                        "assets/svg/play.svg",
                        fit: BoxFit.contain,
                        colorFilter: ColorFilter.mode(
                          messageModel.sender ==
                                  ref.watch(meModelChangeNotifier).myUid
                              ? Colors.white.withValues(alpha: 0.7)
                              : const Color(0XFF909090),
                          BlendMode.srcIn,
                        ),
                      ),
                    ),
                    const Text(
                      "Vidéos",
                      style: TextStyle(fontSize: 12, color: Color(0XFF909090)),
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
                              (File(
                                directory!.path +
                                    messageModel.thumbnail_relative_path!,
                              )),
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
                        colorFilter: ColorFilter.mode(
                          Colors.white,
                          BlendMode.srcIn,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

Widget repliedAudioMessage(
  MessageModel messageModel,
  bool sendedByMe,
  WidgetRef ref,
) {
  return Container(
    constraints: BoxConstraints(maxWidth: 230.w),
    height: 45.h,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.all(Radius.circular(7.r)),
      color: sendedByMe
          ? ChatColor.bubble_reply_message_replied_content_right
          : ChatColor.bubble_reply_message_replied_content_left,
    ),
    child: Row(
      children: [
        Container(
          height: 43.h,
          width: 5.w,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(7.r),
              bottomLeft: Radius.circular(7.r),
            ),
            color: sendedByMe
                ? ChatColor.bubble_reply_message_replied_content_right
                : ChatColor.bubble_reply_message_replied_content_left,
          ),
        ),
        Expanded(
          child: Padding(
            padding: EdgeInsets.only(left: 13.w, right: 6.w),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  messageModel.sender == ref.watch(meModelChangeNotifier).myUid
                      ? "Moi"
                      : ref
                            .watch(messageFirestoreRiver)
                            .participant
                            .containsKey(messageModel.sender)
                      ? ref
                                .watch(messageFirestoreRiver)
                                .participant[messageModel.sender]!
                                .firstname ??
                            ""
                      : "",
                  style: sendedByMe
                      ? ChatStyle.repliedMessagePseudoRightStyle
                      : ChatStyle.repliedMessagePseudoLeftStyle,
                ),
                SizedBox(height: 4.h),
                Row(
                  children: [
                    SizedBox(
                      width: 12.5.w,
                      height: 12.5.h,
                      child: SvgPicture.asset(
                        "assets/svg/mic.svg",
                        colorFilter: ColorFilter.mode(
                          sendedByMe
                              ? ChatColor
                                    .bubble_reply_message_replied_content_icon_type_right_color
                              : ChatColor
                                    .bubble_reply_message_replied_content_icon_type_left_color,
                          BlendMode.srcIn,
                        ),
                      ),
                    ),
                    SizedBox(width: 5.w),
                    Text(
                      messageModel.duration ?? "",
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w500,
                        color:
                            (sendedByMe
                                    ? ChatColor
                                          .bubble_reply_message_replied_content_icon_type_right_color
                                    : ChatColor
                                          .bubble_reply_message_replied_content_icon_type_left_color)
                                .withValues(alpha: 0.7),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    ),
  );
}

Widget repliedTextMessage(
  MessageModel messageModel,
  bool sendedByMe,
  WidgetRef ref,
) => Container(
  constraints: BoxConstraints(maxWidth: 230.w, minWidth: 100.w),
  height: 45.h,
  decoration: BoxDecoration(
    borderRadius: BorderRadius.all(Radius.circular(7.r)),
    color: sendedByMe
        ? ChatColor.bubble_reply_message_replied_content_right
        : ChatColor.bubble_reply_message_replied_content_left,
  ),
  child: Row(
    children: [
      Container(
        height: 43.h,
        width: 5.w,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(7.r),
            bottomLeft: Radius.circular(7.r),
          ),
          color: sendedByMe
              ? ChatColor.bubble_reply_message_replied_content_right
              : ChatColor.bubble_reply_message_replied_content_left,
        ),
      ),
      Expanded(
        child: Padding(
          padding: EdgeInsets.only(left: 13.w, right: 6.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                messageModel.sender == ref.watch(meModelChangeNotifier).myUid
                    ? "Moi"
                    : ref
                          .watch(messageFirestoreRiver)
                          .participant
                          .containsKey(messageModel.sender)
                    ? ref
                              .watch(messageFirestoreRiver)
                              .participant[messageModel.sender]!
                              .firstname ??
                          ""
                    : "",
                style: sendedByMe
                    ? ChatStyle.repliedMessagePseudoRightStyle
                    : ChatStyle.repliedMessagePseudoLeftStyle,
              ),
              SizedBox(height: 4.h),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      (messageModel.message ?? ""),
                      overflow: TextOverflow.ellipsis,
                      style: sendedByMe
                          ? ChatStyle.repliedMessageRightStyle
                          : ChatStyle.repliedMessageLeftStyle,
                    ),
                  ),
                  SizedBox(width: 60.w),
                ],
              ),
            ],
          ),
        ),
      ),
    ],
  ),
);
