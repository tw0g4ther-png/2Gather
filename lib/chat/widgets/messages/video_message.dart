import 'dart:io';

import 'package:bubble/bubble.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:twogather/main.dart';
import '../../chatColor.dart';
import '../../chatStyle.dart';
import '../../enum/enumMessage.dart';
import '../../freezed/message/messageModel.dart';
import '../../freezed/message/replyWrapper.dart';

import '../../riverpods/me_notifier.dart';
import '../../riverpods/salon_river.dart';
import '../../utils/loader_ios.dart';
import '../stream_media.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:readmore/readmore.dart';
import 'package:timeago_flutter/timeago_flutter.dart';

class SimpleVideo extends ConsumerStatefulWidget {
  final MessageModel messageModel;
  const SimpleVideo({super.key, required this.messageModel});

  @override
  SimpleVideoState createState() => SimpleVideoState();
}

class SimpleVideoState extends ConsumerState<SimpleVideo> {
  @override
  Widget build(BuildContext context) {
    return repliedTo(
      widget.messageModel,
      ref: ref,
      child: Padding(
          padding: EdgeInsets.only(bottom: 11.3.h),
          child: Bubble(
              color: ref.watch(meModelChangeNotifier).myUid ==
                      widget.messageModel.sender
                  ? ChatColor.bubble_color_right
                  : ChatColor.bubble_color_left,
              radius: const Radius.circular(10),
              borderWidth: 0.5,
              borderColor: ref.watch(meModelChangeNotifier).myUid ==
                      widget.messageModel.sender
                  ? ChatColor.bubble_border_right_color
                  : ChatColor.bubble_border_left_color,
              alignment: ref.watch(meModelChangeNotifier).myUid ==
                      widget.messageModel.sender
                  ? Alignment.centerRight
                  : Alignment.centerLeft,
              child: InkWell(
                onTap: ref
                        .watch(salonMessagesNotifier)
                        .listMessageSelectedMessage
                        .isEmpty
                    ? () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => VideoPlayerChat(
                                      messageModel: widget.messageModel,
                                    )));
                      }
                    : null,
                child: Container(
                  constraints: BoxConstraints(
                    maxWidth: 266.w,
                    minWidth: 182.26.w,
                  ),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        SizedBox(
                          width: 266.26.w,
                          height: 186.84.h,
                          child: Stack(
                            children: [
                              Positioned.fill(
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(5.r),
                                  child: (File(directory!.path +
                                              widget.messageModel
                                                  .thumbnail_relative_path!)
                                          .existsSync())
                                      ? Image.file(
                                          File(directory!.path +
                                              widget.messageModel
                                                  .thumbnail_relative_path!),
                                          fit: BoxFit.cover,
                                        )
                                      : widget.messageModel.thumbnail != null
                                          ? CachedNetworkImage(
                                              imageUrl: widget
                                                  .messageModel.thumbnail!,
                                              fit: BoxFit.cover,
                                            )
                                          : const Center(
                                              child: LoaderClassique(),
                                            ),
                                ),
                              ),
                              Center(
                                child: Container(
                                    width: 40.w,
                                    height: 40.w,
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.black.withValues(alpha: 0.4)),
                                    child: const Icon(
                                      Icons.play_arrow_rounded,
                                      color: Colors.white,
                                      size: 38,
                                    )),
                              )
                            ],
                          ),
                        ),
                        const SizedBox(height: 8.7),
                        if (widget.messageModel.message != null)
                          Row(
                            children: [
                              Expanded(
                                child: ReadMoreText(
                                    widget.messageModel.message!,
                                    trimLines: 2,
                                    trimMode: TrimMode.Line,
                                    textAlign: TextAlign.left,
                                    trimCollapsedText: 'Voir plus',
                                    trimExpandedText: '',
                                    colorClickableText: ref
                                                .watch(meModelChangeNotifier)
                                                .myUid ==
                                            widget.messageModel.sender
                                        ? ChatColor.bubble_color_left
                                        : ChatColor.bubble_color_right,
                                    style: ref
                                                .watch(meModelChangeNotifier)
                                                .myUid ==
                                            widget.messageModel.sender
                                        ? ChatStyle.messageRightStyle
                                        : ChatStyle.messageLeftStyle),
                              ),
                            ],
                          ),
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 8.h),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              widget.messageModel.sender !=
                                          ref
                                              .watch(meModelChangeNotifier)
                                              .myUid &&
                                      ref
                                              .watch(messageFirestoreRiver)
                                              .currentSalon
                                              ?.type !=
                                          SalonType.oneToOne
                                  ? Row(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        widget.messageModel.sender !=
                                                    ref
                                                        .watch(
                                                            meModelChangeNotifier)
                                                        .myUid &&
                                                ref
                                                    .watch(
                                                        messageFirestoreRiver)
                                                    .participant
                                                    .containsKey(widget
                                                        .messageModel.sender)
                                            ? Text(
                                                "${ref.watch(messageFirestoreRiver).participant[widget.messageModel.sender]!.firstname ?? ""} ${ref.watch(messageFirestoreRiver).participant[widget.messageModel.sender]!.lastname ?? ""}",
                                                style: ChatStyle
                                                    .pseudoMessageStyle,
                                              )
                                            : Text(
                                                "Utilsateur n'existe plus",
                                                style: ChatStyle
                                                    .pseudoMessageUtilisateurLeaveStyle,
                                              ),
                                        SizedBox(
                                          width: 5.w,
                                        ),
                                      ],
                                    )
                                  : const SizedBox(),
                              Timeago(
                                builder: (_, value) => Text(
                                  value,
                                  style:
                                      ref.watch(meModelChangeNotifier).myUid ==
                                              widget.messageModel.sender
                                          ? ChatStyle.messageTimeagoRightStyle
                                          : ChatStyle.messageTimeagoLeftStyle,
                                ),
                                date: widget.messageModel.createdAt,
                                locale: 'fr',
                                allowFromNow: true,
                              ),
                              SizedBox(
                                width: 5.w,
                              ),
                              ref.watch(meModelChangeNotifier).myUid ==
                                      widget.messageModel.sender
                                  ? widget.messageModel.urlMediaContent == null
                                      ? const LoaderClassique(
                                          radius: 7,
                                        )
                                      : SizedBox(
                                          width: 12.56.w,
                                          child: SvgPicture.asset(
                                            "assets/svg/read.svg",
                                            colorFilter: ColorFilter.mode(
                                                (widget.messageModel.seenBy
                                                            ?.length ??
                                                        0) >
                                                    0
                                                ? Colors.white
                                                : Colors.white.withValues(alpha: 0.5),
                                                BlendMode.srcIn),
                                            fit: BoxFit.cover,
                                          ))
                                  : const SizedBox()

                              // new Text(timeago.format(DateTime.now()), style: TextStyle()),
                            ],
                          ),
                        )
                      ]),
                ),
              ))),
    );
  }
}
