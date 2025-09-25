import 'package:bubble/bubble.dart';
import 'package:twogather/chat/chatColor.dart';
import 'package:twogather/chat/chatStyle.dart';
import 'package:twogather/chat/freezed/message/messageModel.dart';
import 'package:twogather/chat/freezed/user/userModel.dart';
import 'package:twogather/chat/riverpods/salon_river.dart';
import 'package:twogather/controller/notification_controller.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import "package:flutter/material.dart";
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:timeago_flutter/timeago_flutter.dart';
import 'package:ui_kosmos_v4/ui_kosmos_v4.dart';

class LockedMessage extends ConsumerStatefulWidget {
  final MessageModel messageModel;
  const LockedMessage({required this.messageModel, super.key});

  @override
  ConsumerState<LockedMessage> createState() => _LockedMessageState();
}

class _LockedMessageState extends ConsumerState<LockedMessage> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15.w).copyWith(bottom: 8.h),
      child: Bubble(
        color: ChatColor.bubble_color_left,
        radius: const Radius.circular(10),
        borderWidth: 0.5,
        borderColor: ChatColor.bubble_border_left_color,
        elevation: 0,
        alignment: Alignment.centerLeft,
        child: Padding(
          padding: const EdgeInsets.only(right: .0),
          child: Container(
            constraints: const BoxConstraints(
              maxWidth: 200,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [],
                ),
                userlockSender(),
                SizedBox(
                  height: 8.h,
                ),
                CTA.secondary(
                  width: 158.w,
                  height: 38.h,
                  radius: 7.r,
                  onTap: widget.messageModel.state ==
                          MessageLockButtonState.accepted
                      ? null
                      : () async {
                          String otherUserId = ref
                              .read(messageFirestoreRiver)
                              .participant
                              .keys
                              .firstWhere((element) =>
                                  element !=
                                  FirebaseAuth.instance.currentUser!.uid);
                          await NotificationController.handleDuoRequest(
                              otherUserId,
                              FirebaseAuth.instance.currentUser!.uid,
                              null,
                              true,
                              notUseNotif: true);
                        },
                  textButton:
                      widget.messageModel.state == MessageLockButtonState.notYet
                          ? "Accepter le Lock Duo"
                          : "Déjà accepté",
                  textButtonStyle: TextStyle(
                    fontSize: 11.sp,
                    color: widget.messageModel.state ==
                            MessageLockButtonState.notYet
                        ? const Color(0XFFEF561D)
                        : const Color(0XFFEF561D)
                            .withValues(alpha: 0.54),
                    fontWeight: FontWeight.w600,
                  ),
                  border: Border.all(
                      width: 0.2,
                      color: const Color(0XFF707070)
                          .withValues(alpha: .28)),
                ),
                Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 5.w).copyWith(top: 8.h),
                  constraints: BoxConstraints(
                    maxWidth:
                        widget.messageModel.replyTo != null ? 240.w : 240.w,
                    minWidth:
                        widget.messageModel.replyTo != null ? 240.w : 100.0.w,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      SizedBox(
                        width: 5.w,
                      ),
                      const Spacer(),
                      Timeago(
                        builder: (_, value) => Text(
                          value,
                          style: ChatStyle.messageTimeagoLeftStyle,
                        ),
                        date: widget.messageModel.createdAt,
                        locale: 'fr',
                        allowFromNow: true,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget userlockSender() {
    try {
      String otherId = ref
          .read(messageFirestoreRiver)
          .participant
          .keys
          .firstWhere(
              (element) => element != FirebaseAuth.instance.currentUser!.uid);
      UserModel? other = ref.read(messageFirestoreRiver).participant[otherId];
      if (other == null) return const SizedBox();

      return RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: "${other.firstname} ",
              style: TextStyle(
                  color: const Color(0XFF02132B),
                  fontSize: 11.5.sp,
                  fontWeight: FontWeight.w500),
            ),
            TextSpan(
              text: "te propose un Lock Duo.",
              style: TextStyle(
                  color: const Color(0XFF02132B),
                  fontSize: 11.5.sp,
                  fontWeight: FontWeight.w400),
            ),
          ],
        ),
        textAlign: TextAlign.center,
      );
    } catch (e) {
      return const SizedBox();
    }
  }
}
