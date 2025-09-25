// ignore_for_file: file_names

import 'package:cached_network_image/cached_network_image.dart';
import 'package:core_kosmos/core_package.dart';
import '../../Packages/24.Text/index.dart';
import '../../chatColor.dart';
import '../../chatStyle.dart';
import '../../enum/enumMessage.dart';
import '../../freezed/lastDeleteCompos/lastDeleteCompos.dart';
import '../../freezed/message/messageModel.dart';
import '../../freezed/salon/salonModel.dart';
import '../../freezed/user/userModel.dart';
import '../../freezed/userAction/userAction.dart';
import '../../services/realtimeDatabse/database_service.dart';
import 'helper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shimmer/shimmer.dart';
import 'package:timeago_flutter/timeago_flutter.dart';

Widget salonAll(SalonModel salonModel, String myUid) => Row(
  children: [
    Stack(
      children: [
        CircleAvatar(
          radius: 26.r,
          backgroundImage: CachedNetworkImageProvider(
            salonModel.salonPicture ??
                "https://cdn.pixabay.com/photo/2016/08/08/09/17/avatar-1577909_640.png",
          ),
          child: CircleAvatar(
            backgroundColor: Colors.black.withValues(alpha: 0.4),
            radius: 26.r,
          ),
        ),
      ],
    ),
    SizedBox(width: 16.w),
    Expanded(
      child: salonInfoGroup(salonModel, myUid, action: UserAction.normal),
    ),
  ],
);

Widget salonGroup(SalonModel salonModel, String myUid) =>
    // ignore: unnecessary_null_comparison
    salonModel.users != null && salonModel.users.isNotEmpty
    ? Row(
        children: [
          Container(
            width: formatWidth(51),
            height: formatWidth(51),
            clipBehavior: Clip.hardEdge,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(100),
              gradient: const LinearGradient(
                colors: [Color(0xFFC4C4C4), Color(0xFFE0E0E0)],
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
              ),
            ),
            child: Center(
              child: SvgPicture.asset("assets/svg/ic_chat_group.svg"),
            ),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: StreamBuilder(
              stream: RealtimeDatabaseQuery.streamSalon(
                idSalon: salonModel.id!,
              ),
              builder: (context, AsyncSnapshot<DatabaseEvent> snapshot) {
                if (snapshot.hasData) {
                  return salonInfoGroup(
                    salonModel,
                    myUid,
                    action: getStateOfContactRow(
                      snapshot.data!.snapshot.children,
                      myUid,
                    ),
                  );
                }
                if (snapshot.hasError) {
                  return const SizedBox();
                }
                return loadingRowContact();
              },
            ),
          ),
        ],
      )
    : Row(
        children: [
          Stack(
            children: [
              CircleAvatar(
                radius: 26.r,
                backgroundImage: CachedNetworkImageProvider(
                  salonModel.salonPicture ??
                      "https://cdn.pixabay.com/photo/2016/08/08/09/17/avatar-1577909_640.png",
                ),
                child: CircleAvatar(
                  backgroundColor: Colors.black.withValues(alpha: 0.4),
                  radius: 26.r,
                ),
              ),
            ],
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: salonInfoGroup(salonModel, myUid, action: UserAction.normal),
          ),
        ],
      );

/// Génère le nom du salon one-to-one basé sur l'utilisateur distant
String generateSalonOneToOneName(UserModel otherUser) {
  final firstName = otherUser.firstname ?? '';
  final lastName = otherUser.lastname ?? '';

  if (firstName.isEmpty) {
    return 'Utilisateur';
  }

  if (lastName.isEmpty) {
    return firstName;
  }

  // Prénom + première lettre du nom
  final firstLetterLastName = lastName.isNotEmpty
      ? lastName[0].toUpperCase()
      : '';

  final salonName = '$firstName $firstLetterLastName';

  return salonName;
}

Widget salonOneToOneUser(SalonModel salonModel, String myUid) {
  final otherUserId = salonModel.users.firstWhere(
    (element) => element != myUid,
  );

  return FutureBuilder(
    future: FirebaseFirestore.instance
        .collection("users")
        .doc(otherUserId)
        .get(),
    builder:
        (
          context,
          AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> snapshot,
        ) {
          if (snapshot.hasData && snapshot.data != null) {
            UserModel other = UserModel.fromJson(snapshot.data!.data()!);

            return Row(
              children: [
                CircleAvatar(
                  radius: 26.r,
                  backgroundImage: CachedNetworkImageProvider(
                    other.profilImage ??
                        "https://cdn.pixabay.com/photo/2016/08/08/09/17/avatar-1577909_640.png",
                  ),
                ),
                SizedBox(width: 16.w),
                Expanded(
                  child: salonInfoOneToOne(
                    salonModel,
                    other,
                    myUid,
                    action: UserAction.normal,
                  ),
                ),
              ],
            );
          }

          return const SizedBox();
        },
  );
}

Widget salonInfoOneToOne(
  SalonModel salonModel,
  UserModel other,
  String myUid, {
  required UserAction action,
}) {
  // Génération du nom du salon basé sur l'utilisateur distant
  final generatedSalonName = generateSalonOneToOneName(other);

  return StreamBuilder(
    stream: FirebaseFirestore.instance
        .collection("Salons")
        .doc(salonModel.id)
        .collection("Messages")
        .orderBy("createdAt", descending: true)
        .limit(1)
        .snapshots(),
    builder:
        (
          BuildContext context,
          AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot,
        ) {
          if (snapshot.hasData) {
            if (snapshot.data!.docs.isNotEmpty) {
              MessageModel messageModel = MessageModel.fromJson(
                snapshot.data!.docs.first.data(),
              );
              return Stack(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              generatedSalonName,
                              style: ChatStyle.contactUsernameStyle,
                            ),
                            SizedBox(height: 6.h),
                            (salonModel.lastMessageId != null)
                                ? messageModel.sender == myUid
                                      ? stateOfOneToOneSalonFromMe(
                                          messageModel,
                                          action,
                                        )
                                      : stateOfOneToOneSalonFromOther(
                                          messageModel,
                                          action,
                                        )
                                : Text("chat.start-discuss".tr()),
                          ],
                        ),
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              (!(messageModel.seenBy?.contains(myUid) ??
                                          false)) &&
                                      messageModel.sender != myUid
                                  ? Container(
                                      margin: EdgeInsets.symmetric(
                                        horizontal: 12.w,
                                      ),
                                      width: 11.w,
                                      height: 11.w,
                                      decoration: const BoxDecoration(
                                        color: Color(0xFFEF561D),
                                        shape: BoxShape.circle,
                                      ),
                                    )
                                  : const SizedBox(),
                              const Icon(
                                CupertinoIcons.chevron_right,
                                color: Colors.grey,
                                size: 14,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                  Positioned(
                    right: 5.w,
                    top: 0,
                    child: Transform.translate(
                      offset: Offset(0, -6.1.h),
                      child: Timeago(
                        builder: (_, value) => Text(value),
                        date: messageModel.createdAt,
                        locale: 'fr',
                        allowFromNow: true,
                      ),
                    ),
                  ),
                ],
              );
            } else {
              return Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          generatedSalonName,
                          style: ChatStyle.contactUsernameStyle,
                        ),
                        SizedBox(height: 6.h),
                        Text("chat.start-discuss".tr()),
                      ],
                    ),
                  ),
                  const Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            CupertinoIcons.chevron_right,
                            color: Colors.grey,
                            size: 14,
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              );
            }
          }
          if (snapshot.hasError) return const SizedBox();

          return Shimmer.fromColors(
            baseColor: Colors.grey,
            highlightColor: Colors.grey,
            child: SizedBox(height: 45.h, width: 200),
          );
        },
  );
}

Widget salonInfoGroup(
  SalonModel salonModel,
  String myUid, {
  required UserAction action,
}) {
  print('👥 [SALON_INFO_GROUP] Affichage info salon groupe');
  print('   - Salon: ${salonModel.nom} (${salonModel.id})');
  print('   - Action: $action');

  return StreamBuilder(
    stream: FirebaseFirestore.instance
        .collection("Salons")
        .doc(salonModel.id)
        .collection("Messages")
        .orderBy("createdAt", descending: true)
        .limit(1)
        .snapshots(),
    builder:
        (
          BuildContext context,
          AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot,
        ) {
          if (snapshot.hasData) {
            if (snapshot.data!.docs.isNotEmpty) {
              MessageModel messageModel = MessageModel.fromJson(
                snapshot.data!.docs.first.data(),
              );
              return Stack(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              salonModel.nom ?? "Groupe",
                              style: ChatStyle.contactUsernameStyle,
                            ),
                            SizedBox(height: 6.h),
                            StreamBuilder(
                              stream: FirebaseFirestore.instance
                                  .collection("LastDeletedCompos")
                                  .doc(salonModel.id! + myUid)
                                  .snapshots(),
                              builder:
                                  (
                                    context,
                                    AsyncSnapshot<
                                      DocumentSnapshot<Map<String, dynamic>>
                                    >
                                    snap,
                                  ) {
                                    if (snap.hasData) {
                                      if (snap.data!.exists) {
                                        LastDeleteCompos last =
                                            LastDeleteCompos.fromJson(
                                              snap.data!.data()!,
                                            );
                                        return (salonModel.lastMessageId !=
                                                    null &&
                                                0 <
                                                    salonModel
                                                        .lastMessageContent!
                                                        .createdAt
                                                        .compareTo(
                                                          last.lastDateDelete,
                                                        ))
                                            ? messageModel.sender == myUid
                                                  ? stateOfOneToOneSalonFromMe(
                                                      messageModel,
                                                      action,
                                                    )
                                                  : stateOfOneToOneSalonFromOther(
                                                      messageModel,
                                                      action,
                                                    )
                                            : Text("chat.start-discuss".tr());
                                      } else {
                                        return (salonModel.lastMessageId !=
                                                null)
                                            ? messageModel.sender == myUid
                                                  ? stateOfOneToOneSalonFromMe(
                                                      messageModel,
                                                      action,
                                                    )
                                                  : stateOfOneToOneSalonFromOther(
                                                      messageModel,
                                                      action,
                                                    )
                                            : Text("chat.start-discuss".tr());
                                      }
                                    }
                                    return const SizedBox();
                                  },
                            ),
                          ],
                        ),
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              (!(messageModel.seenBy?.contains(myUid) ??
                                          false)) &&
                                      messageModel.sender != myUid
                                  ? Container(
                                      margin: EdgeInsets.symmetric(
                                        horizontal: 12.w,
                                      ),
                                      width: 11.w,
                                      height: 11.w,
                                      decoration: const BoxDecoration(
                                        color: Color(0xFFEF561D),
                                        shape: BoxShape.circle,
                                      ),
                                    )
                                  : const SizedBox(),
                              const Icon(
                                CupertinoIcons.chevron_right,
                                color: Colors.grey,
                                size: 14,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                  Positioned(
                    right: 5.w,
                    top: 0,
                    child: Transform.translate(
                      offset: Offset(0, -6.1.h),
                      child: Timeago(
                        builder: (_, value) => Text(value),
                        date: messageModel.createdAt,
                        locale: 'fr',
                        allowFromNow: true,
                      ),
                    ),
                  ),
                ],
              );
            } else {
              return Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          salonModel.nom ?? "groupe_${salonModel.id}",
                          style: ChatStyle.contactUsernameStyle,
                        ),
                        SizedBox(height: 6.h),
                        Text("chat.start-discuss".tr()),
                      ],
                    ),
                  ),
                  const Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            CupertinoIcons.chevron_right,
                            color: Colors.grey,
                            size: 14,
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              );
            }
          }
          if (snapshot.hasError) return const SizedBox();

          return Shimmer.fromColors(
            baseColor: Colors.grey,
            highlightColor: Colors.grey,
            child: SizedBox(height: 45.h, width: 200),
          );
        },
  );
}

Widget stateOfOneToOneSalonFromOther(
  MessageModel messageModel,
  UserAction action,
) {
  if (messageModel.replyTo != null) {
    return const Text('A répondu à votre message');
  }
  if (action == UserAction.normal) {
    switch (messageModel.type) {
      case MessageContentType.textMessage:
        return FutureBuilder(
          future: FirebaseFirestore.instance
              .collection("users")
              .doc(messageModel.sender)
              .get(),
          builder:
              (
                context,
                AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> snapshot,
              ) {
                if (snapshot.hasData && snapshot.data!.exists) {
                  UserModel userModel = UserModel.fromJson(
                    snapshot.data!.data()!,
                  );

                  return Row(
                    children: [
                      Text(
                        "${userModel.firstname ?? ""} : ",
                        style: ChatStyle.contactListFromTextStyle,
                      ),
                      Expanded(
                        child: Text(
                          messageModel.message ?? "",
                          maxLines: 1,
                          style: const TextStyle(
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                    ],
                  );
                }
                return Text(messageModel.message ?? "");
              },
        );
      case MessageContentType.videoMessage:
        return Row(
          children: [
            FutureBuilder(
              future: FirebaseFirestore.instance
                  .collection("users")
                  .doc(messageModel.sender)
                  .get(),
              builder:
                  (
                    context,
                    AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>>
                    snapshot,
                  ) {
                    if (snapshot.hasData && snapshot.data!.exists) {
                      UserModel userModel = UserModel.fromJson(
                        snapshot.data!.data()!,
                      );

                      return Row(
                        children: [Text("${userModel.firstname ?? ""} : ")],
                      );
                    }
                    return const SizedBox();
                  },
            ),
            SvgPicture.asset(
              "assets/svg/play.svg",
              colorFilter: ColorFilter.mode(
                ChatColor.contact_list_type_messageIcon,
                BlendMode.srcIn,
              ),
              width: 8.w,
            ),
            SizedBox(width: 5.w),
            Text("Video", style: ChatStyle.contactListTypeTextStyle),
          ],
        );
      case MessageContentType.imageMessage:
        return Row(
          children: [
            FutureBuilder(
              future: FirebaseFirestore.instance
                  .collection("users")
                  .doc(messageModel.sender)
                  .get(),
              builder:
                  (
                    context,
                    AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>>
                    snapshot,
                  ) {
                    if (snapshot.hasData && snapshot.data!.exists) {
                      UserModel userModel = UserModel.fromJson(
                        snapshot.data!.data()!,
                      );

                      return Row(
                        children: [
                          Text(
                            "${userModel.firstname ?? ""} : ",
                            style: ChatStyle.contactListFromTextStyle,
                          ),
                        ],
                      );
                    }
                    return const SizedBox();
                  },
            ),
            SvgPicture.asset(
              "assets/svg/gallery.svg",
              colorFilter: ColorFilter.mode(
                ChatColor.contact_list_type_messageIcon,
                BlendMode.srcIn,
              ),
              width: 12.w,
            ),
            SizedBox(width: 5.w),
            Text("Image", style: ChatStyle.contactListTypeTextStyle),
          ],
        );
      case MessageContentType.lockDemandMessage:
        return Row(
          children: [
            FutureBuilder(
              future: FirebaseFirestore.instance
                  .collection("users")
                  .doc(messageModel.sender)
                  .get(),
              builder:
                  (
                    context,
                    AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>>
                    snapshot,
                  ) {
                    if (snapshot.hasData && snapshot.data!.exists) {
                      UserModel userModel = UserModel.fromJson(
                        snapshot.data!.data()!,
                      );

                      return Row(
                        children: [
                          Text(
                            "${userModel.firstname ?? ""} : ",
                            style: ChatStyle.contactListFromTextStyle,
                          ),
                        ],
                      );
                    }
                    return const SizedBox();
                  },
            ),
            SvgPicture.asset(
              "assets/svg/ic_lock.svg",
              colorFilter: ColorFilter.mode(
                ChatColor.contact_list_type_messageIcon,
                BlendMode.srcIn,
              ),
              width: 12.w,
            ),
            SizedBox(width: 5.w),
            Text("demande lock", style: ChatStyle.contactListTypeTextStyle),
          ],
        );
    }
  } else {
    switch (action) {
      case UserAction.recording:
        return Text(
          'enregistrement d’un audio..',
          style: ChatStyle.contactListRowTypingOrRecordingTextStyle,
        );

      case UserAction.typing:
        return Text(
          'écrit..',
          style: ChatStyle.contactListRowTypingOrRecordingTextStyle,
        );
      default:
        return const SizedBox();
    }
  }
}

Widget stateOfOneToOneSalonFromMe(
  MessageModel messageModel,
  UserAction action,
) {
  if (messageModel.replyTo != null) return const Text('Vous avez répondu');
  if (action == UserAction.normal) {
    switch (messageModel.type) {
      case MessageContentType.textMessage:
        return Row(
          children: [
            Text("Vous : ", style: ChatStyle.contactListFromTextStyle),
            Expanded(
              child: Text(
                messageModel.message ?? "",
                maxLines: 1,
                style: const TextStyle(overflow: TextOverflow.ellipsis),
              ),
            ),
          ],
        );
      case MessageContentType.videoMessage:
        return Row(
          children: [
            Text("Vous : ", style: ChatStyle.contactListFromTextStyle),
            SvgPicture.asset(
              "assets/svg/play.svg",
              width: 8.w,
              colorFilter: ColorFilter.mode(
                ChatColor.contact_list_type_messageIcon,
                BlendMode.srcIn,
              ),
            ),
            SizedBox(width: 2.w),
            Text("Video", style: ChatStyle.contactListTypeTextStyle),
          ],
        );
      case MessageContentType.imageMessage:
        return Row(
          children: [
            Text("Vous : ", style: ChatStyle.contactListFromTextStyle),
            SvgPicture.asset("assets/svg/gallery.svg", width: 12.w),
            SizedBox(width: 5.w),
            Text("Image", style: ChatStyle.contactListTypeTextStyle),
          ],
        );
      case MessageContentType.lockDemandMessage:
        return Row(
          children: [
            Text("Vous : ", style: ChatStyle.contactListFromTextStyle),
            SvgPicture.asset("assets/svg/ic_lock.svg", width: 12.w),
            SizedBox(width: 5.w),
            Text("demande lock", style: ChatStyle.contactListTypeTextStyle),
          ],
        );
    }
  }
  return const SizedBox();
}

bool isGroup(List<dynamic> list) {
  if (list.length > 2) {
    return true;
  }
  return false;
}

Widget loadingRowContact() => Shimmer.fromColors(
  baseColor: Colors.grey[100]!,
  highlightColor: Colors.grey[500]!,
  child: SizedBox(
    height: 45.h,
    child: Row(
      children: [
        CircleAvatar(radius: 26.r),
        SizedBox(width: 16.w),
        Expanded(
          child: Container(
            width: double.infinity,
            height: 25,
            color: Colors.black,
          ),
        ),
      ],
    ),
  ),
);
Widget addUserRow(UserModel user, {required VoidCallback add}) {
  return InkWell(
    onTap: add,
    child: Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 18.w),
          child: Row(
            children: [
              CircleAvatar(
                radius: 20.75.w,
                backgroundImage: CachedNetworkImageProvider(user.profilImage!),
              ),
              SizedBox(width: 13.w),
              textSizedColored(
                text: "${user.firstname ?? ""} ${user.lastname ?? ""}",
                size: 16,
                weight: 600,
                color: ChatColor.pseudoHeader_color,
              ),
              const Spacer(),
              const Icon(Icons.keyboard_arrow_right),
            ],
          ),
        ),
        Divider(indent: 75.6.w, height: 18, color: const Color(0XFFCBCBCB)),
      ],
    ),
  );
}

Widget addUserInSalon(
  UserModel user, {
  required VoidCallback add,
  required bool checked,
}) {
  return InkWell(
    onTap: add,
    child: Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 18.w),
          child: Row(
            children: [
              CircleAvatar(
                radius: 20.75.w,
                backgroundImage: CachedNetworkImageProvider(user.profilImage!),
              ),
              SizedBox(width: 13.w),
              textSizedColored(
                text: "${user.firstname ?? ""} ${user.lastname ?? ""}",
                size: 16,
                weight: 600,
                color: ChatColor.pseudoHeader_color,
              ),
              const Spacer(),
              Transform.scale(
                scale: 1.3,
                child: Checkbox(
                  value: checked,
                  onChanged: (val) {
                    add();
                  },
                  shape: const CircleBorder(),
                ),
              ),
            ],
          ),
        ),
        Divider(indent: 75.6.w, height: 18, color: const Color(0XFFCBCBCB)),
      ],
    ),
  );
}
