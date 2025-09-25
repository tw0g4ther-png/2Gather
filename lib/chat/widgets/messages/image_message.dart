import 'dart:io';

import 'package:bubble/bubble.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../chatColor.dart';
import '../../chatStyle.dart';
import '../../enum/enumMessage.dart';
import '../../freezed/message/messageModel.dart';
import '../../freezed/message/replyWrapper.dart';
import '../../riverpods/me_notifier.dart';
import '../../riverpods/salon_river.dart';
import 'media_show.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blurhash/flutter_blurhash.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:readmore/readmore.dart';
import 'package:timeago_flutter/timeago_flutter.dart';

class SimpleImage extends ConsumerStatefulWidget {
  const SimpleImage({super.key, required this.messageModel});
  final MessageModel messageModel;

  @override
  ConsumerState<SimpleImage> createState() => _SimpleImageState();
}

class _SimpleImageState extends ConsumerState<SimpleImage> {
  @override
  Widget build(BuildContext context) {
    return repliedTo(
      widget.messageModel,
      ref: ref,
      child: Bubble(
        color:
            ref.watch(meModelChangeNotifier).myUid == widget.messageModel.sender
                ? ChatColor.bubble_color_right
                : ChatColor.bubble_color_left,
        radius: const Radius.circular(10),
        borderColor:
            ref.watch(meModelChangeNotifier).myUid == widget.messageModel.sender
                ? ChatColor.bubble_border_right_color
                : ChatColor.bubble_border_left_color,
        borderWidth: 0.5,
        alignment:
            ref.watch(meModelChangeNotifier).myUid == widget.messageModel.sender
                ? Alignment.centerRight
                : Alignment.centerLeft,
        child: Container(
          constraints: BoxConstraints(
            maxWidth: 266.w,
            minWidth: 182.26.w,
          ),
          child: Column(
            children: [
              Container(
                height: 200.h,
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(8.r)),

                // constraints: BoxConstraints(maxHeight: 230.h),
                child: widget.messageModel.temporaryPath != null
                    ? GestureDetector(
                        onTap: ref
                                .watch(salonMessagesNotifier)
                                .listMessageSelectedMessage
                                .isEmpty
                            ? () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: ((context) => ShowMedia(
                                              source: MediaSource.file,
                                              file: File(
                                                widget.messageModel
                                                    .temporaryPath!,
                                              ),
                                            ))));
                              }
                            : null,
                        child: Container(
                          width: double.infinity,
                          clipBehavior: Clip.hardEdge,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8.r)),
                          child: Image.file(
                            File(
                              widget.messageModel.temporaryPath!,
                            ),
                            fit: BoxFit.cover,
                          ),
                        ),
                      )
                    : widget.messageModel.urlMediaContent != null
                        ? Stack(
                            children: [
                              Container(
                                constraints: BoxConstraints(
                                  maxWidth: 266.w,
                                  minWidth: 182.26.w,
                                ),
                                child: InkWell(
                                  onTap: ref
                                          .watch(salonMessagesNotifier)
                                          .listMessageSelectedMessage
                                          .isEmpty
                                      ? () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: ((context) => ShowMedia(
                                                      source: MediaSource.url,
                                                      mediaUrl: widget
                                                          .messageModel
                                                          .urlMediaContent))));
                                        }
                                      : null,
                                  child: Center(
                                    child: CachedNetworkImage(
                                      errorWidget: (context, url, error) =>
                                          const Icon(Icons.error),
                                      placeholder: (context, url) {
                                        return BlurHash(
                                            hash: widget
                                                    .messageModel.blur_hash ??
                                                "L5H2EC=PM+yV0g-mq.wG9c010J}I");
                                      },
                                      imageUrl:
                                          widget.messageModel.urlMediaContent!,
                                      imageBuilder: (context, imageProvider) =>
                                          Container(
                                        constraints: BoxConstraints(
                                          maxWidth: 266.w,
                                          minWidth: 182.26.w,
                                        ),
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(8.r),
                                            image: DecorationImage(
                                              image: imageProvider,
                                              fit: BoxFit.cover,
                                            )),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          )
                        : Image.network(
                            "https://img-4.linternaute.com/s7f6qUEDIMpFEY9bBya5ZmFVAE8=/620x/smart/685fdd5cfcf444e08d3ff22cde5d1581/ccmcms-linternaute/2377659.jpg",
                            fit: BoxFit.cover,
                          ),
              ),
              if (widget.messageModel.message != null &&
                  widget.messageModel.message!.isNotEmpty)
                const SizedBox(height: 8.7),
              if (widget.messageModel.message != null &&
                  widget.messageModel.message!.isNotEmpty)
                Row(
                  children: [
                    Expanded(
                      child: ReadMoreText(widget.messageModel.message!,
                          trimLines: 3,
                          trimMode: TrimMode.Line,
                          textAlign: TextAlign.left,
                          trimCollapsedText: 'Voir plus',
                          trimExpandedText: '',
                          colorClickableText:
                              ref.watch(meModelChangeNotifier).myUid ==
                                      widget.messageModel.sender
                                  ? ChatColor.bubble_color_left
                                  : ChatColor.bubble_color_right,
                          style: ref.watch(meModelChangeNotifier).myUid ==
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
                    ref.watch(messageFirestoreRiver).currentSalon?.type !=
                            SalonType.oneToOne
                        ? Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              widget.messageModel.sender !=
                                          ref
                                              .watch(meModelChangeNotifier)
                                              .myUid &&
                                      ref
                                          .watch(messageFirestoreRiver)
                                          .participant
                                          .containsKey(
                                              widget.messageModel.sender)
                                  ? Text(
                                      "${ref.watch(messageFirestoreRiver).participant[widget.messageModel.sender]!.firstname ?? ""} ${ref.watch(messageFirestoreRiver).participant[widget.messageModel.sender]!.lastname ?? ""}",
                                      style: ChatStyle.pseudoMessageStyle,
                                    )
                                  : widget.messageModel.sender !=
                                          ref.watch(meModelChangeNotifier).myUid
                                      ? Text(
                                          "Utilisateur n'existe plus",
                                          style: ChatStyle
                                              .pseudoMessageUtilisateurLeaveStyle,
                                        )
                                      : const SizedBox(),
                              SizedBox(
                                width: 5.w,
                              ),
                            ],
                          )
                        : const SizedBox(),
                    Timeago(
                      builder: (_, value) => Padding(
                        padding: const EdgeInsets.only(right: 5.0),
                        child: Text(
                          value,
                          style: ref.watch(meModelChangeNotifier).myUid ==
                                  widget.messageModel.sender
                              ? ChatStyle.messageTimeagoRightStyle
                              : ChatStyle.messageTimeagoLeftStyle,
                        ),
                      ),
                      date: widget.messageModel.createdAt,
                      locale: 'fr',
                      allowFromNow: true,
                    ),

                    ref.watch(meModelChangeNotifier).myUid ==
                            widget.messageModel.sender
                        ? SizedBox(
                            width: 12.56.w,
                            child: SvgPicture.asset(
                              "assets/svg/read.svg",
                              colorFilter: ColorFilter.mode(
                                  (widget.messageModel.seenBy?.length ?? 0) > 0
                                      ? Colors.white
                                      : Colors.white.withValues(alpha: 0.5),
                                  BlendMode.srcIn),
                              fit: BoxFit.cover,
                            ))
                        : const SizedBox(),
                    // new Text(timeago.format(DateTime.now()), style: TextStyle()),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
