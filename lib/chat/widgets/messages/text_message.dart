import '../../chatColor.dart';
import '../../chatStyle.dart';
import '../../enum/enumMessage.dart';
import '../../freezed/message/messageModel.dart';
import '../../freezed/message/replyWrapper.dart';
import '../../riverpods/me_notifier.dart';
import '../../riverpods/salon_river.dart';

import 'replied_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:readmore/readmore.dart';
import 'package:bubble/bubble.dart';

import 'package:timeago_flutter/timeago_flutter.dart';

Widget textMessage(MessageModel messageModel, WidgetRef ref) => repliedTo(
  messageModel,
  ref: ref,
  child: Bubble(
    color: ref.watch(meModelChangeNotifier).myUid == messageModel.sender
        ? ChatColor.bubble_color_right
        : ChatColor.bubble_color_left,
    radius: const Radius.circular(10),
    borderWidth: 0.5,
    borderColor: ref.watch(meModelChangeNotifier).myUid == messageModel.sender
        ? ChatColor.bubble_border_right_color
        : ChatColor.bubble_border_left_color,
    elevation: 0,
    alignment: ref.watch(meModelChangeNotifier).myUid == messageModel.sender
        ? Alignment.centerRight
        : Alignment.centerLeft,
    child: Container(
      constraints: const BoxConstraints(maxWidth: 254),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              ref.watch(messageFirestoreRiver).currentSalon?.type !=
                      SalonType.oneToOne
                  ? messageModel.sender !=
                                ref.watch(meModelChangeNotifier).myUid &&
                            ref
                                .watch(messageFirestoreRiver)
                                .participant
                                .containsKey(messageModel.sender)
                        ? Text(
                            "${ref.watch(messageFirestoreRiver).participant[messageModel.sender]!.firstname ?? ""} ${ref.watch(messageFirestoreRiver).participant[messageModel.sender]!.lastname ?? ""}",
                            style: ChatStyle.pseudoMessageStyle,
                          )
                        : messageModel.sender !=
                              ref.watch(meModelChangeNotifier).myUid
                        ? Text(
                            "Utilisateur n'existe plus",
                            style: ChatStyle.pseudoMessageUtilisateurLeaveStyle,
                          )
                        : const SizedBox()
                  : const SizedBox(),
            ],
          ),
          messageModel.replyTo != null
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(width: 5.w),
                    Flexible(
                      child: repliedMessageContent(
                        messageModel.replyTo!,
                        ref.watch(meModelChangeNotifier).myUid ==
                            messageModel.sender,
                        ref,
                      ),
                    ),
                  ],
                )
              : const SizedBox(),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 5.w).copyWith(top: 8.h),
            constraints: BoxConstraints(
              maxWidth: messageModel.replyTo != null ? 240.w : 240.w,
              minWidth: messageModel.replyTo != null ? 240.w : 100.0.w,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Padding(
                    padding: EdgeInsets.only(bottom: 5.h),
                    child: ReadMoreText(
                      messageModel.message ?? "",
                      trimLines: 15,
                      trimMode: TrimMode.Line,
                      textAlign: TextAlign.left,
                      trimCollapsedText: 'Voir plus',
                      trimExpandedText: '',
                      colorClickableText: Colors.pink,
                      style:
                          ref.watch(meModelChangeNotifier).myUid ==
                              messageModel.sender
                          ? ChatStyle.messageRightStyle
                          : ChatStyle.messageLeftStyle,
                    ),
                  ),
                ),
                SizedBox(width: 5.w),
                Timeago(
                  builder: (_, value) => Text(
                    value,
                    style:
                        ref.watch(meModelChangeNotifier).myUid ==
                            messageModel.sender
                        ? ChatStyle.messageTimeagoRightStyle
                        : ChatStyle.messageTimeagoLeftStyle,
                  ),
                  date: messageModel.createdAt,
                  locale: 'fr',
                  allowFromNow: true,
                ),
                Row(
                  children: [
                    SizedBox(width: 3.w),
                    ref.watch(meModelChangeNotifier).myUid ==
                            messageModel.sender
                        ? SizedBox(
                            width: 12.56.w,
                            child: SvgPicture.asset(
                              "assets/svg/read.svg",
                              colorFilter: ColorFilter.mode(
                                (messageModel.seenBy?.length ?? 0) > 0
                                    ? Colors.white
                                    : Colors.white.withValues(alpha: 0.5),
                                BlendMode.srcIn,
                              ),
                              fit: BoxFit.cover,
                            ),
                          )
                        : const SizedBox(),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  ),
);

class FrShortMessagesKosmos implements LookupMessages {
  @override
  String prefixAgo() => '';
  @override
  String prefixFromNow() => "";
  @override
  String suffixAgo() => '';
  @override
  String suffixFromNow() => '';
  @override
  String lessThanOneMinute(int seconds) => "A l’instant";
  @override
  String aboutAMinute(int minutes) => '1 min';
  @override
  String minutes(int minutes) => '$minutes min';
  @override
  String aboutAnHour(int minutes) => '1 h';
  @override
  String hours(int hours) => '$hours h';
  @override
  String aDay(int hours) => '1 j';
  @override
  String days(int days) => '$days j';
  @override
  String aboutAMonth(int days) => '1 m';
  @override
  String months(int months) => '$months m';
  @override
  String aboutAYear(int year) => '1 an';
  @override
  String years(int years) => '$years ans';
  @override
  String wordSeparator() => ' ';
}
