import 'package:cached_network_image/cached_network_image.dart';
import 'package:twogather/controller/friend_controller.dart';
import '../Packages/14.BoutonsProfil-Reglage/Core/index.dart';
import '../Packages/24.Text/index.dart';
import '../appColor.dart';
import '../chatStyle.dart';
import '../freezed/user/userModel.dart';
import '../riverpods/me_notifier.dart';
import '../riverpods/salon_river.dart';
import '../services/firestore/index.dart';
import '../utils/group_picture.dart';
import '../utils/loader_ios.dart';
import '../widgets/repertoire/repertoireWidget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:vibration/vibration.dart';
import 'package:iconsax/iconsax.dart';

class AboutSalon extends ConsumerStatefulWidget {
  const AboutSalon({super.key});
  @override
  ConsumerState<AboutSalon> createState() => _AboutSalonState();
}

class _AboutSalonState extends ConsumerState<AboutSalon> {
  bool isActif = false;
  late bool isActif2;
  bool isAuthorized = false;

  @override
  void initState() {
    super.initState();
    isActif2 =
        ref
            .read(messageFirestoreRiver)
            .currentSalon
            ?.allowAllUserToUpdateInformation ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 62.h),
              Container(
                // margin: EdgeInsets.only(top: 40),
                width: 47.w,
                height: 47.h,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14.r),
                ),
                // margin: EdgeInsets.only(top: 40),
                child: InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: const Icon(
                    Icons.keyboard_arrow_left,
                    color: Colors.black,
                  ),
                ),
              ),
              UploadWidgetImage(
                allowModifiy:
                    ref.watch(messageFirestoreRiver).currentSalon?.adminId ==
                        ref.watch(meModelChangeNotifier).myUid ||
                    isActif2,
                salonId: ref.watch(messageFirestoreRiver).currentSalon!.id!,
                done: () {
                  setState(() {});
                },
              ),
              SizedBox(height: 16.h),
              InkWell(
                onTap:
                    ref.watch(messageFirestoreRiver).currentSalon?.adminId ==
                            ref.watch(meModelChangeNotifier).myUid ||
                        isActif2
                    ? () async {
                        final controller = TextEditingController(
                          text:
                              ref
                                  .read(messageFirestoreRiver)
                                  .currentSalon
                                  ?.nom ??
                              '',
                        );
                        String? result = await showDialog<String>(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: Text('chat.group-admin'.tr()),
                            content: TextField(controller: controller),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: Text('chat.cancel'.tr()),
                              ),
                              TextButton(
                                onPressed: () =>
                                    Navigator.pop(context, controller.text),
                                child: const Text('OK'),
                              ),
                            ],
                          ),
                        );
                        List<String>? list = result != null ? [result] : null;
                        print(list);
                        if (list != null) {
                          FirestoreQuery.changeSalonName(
                            salonId: ref
                                .read(messageFirestoreRiver)
                                .currentSalon!
                                .id!,
                            name: list.first,
                          );
                        }
                      }
                    : null,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(width: 15.w),
                    Center(
                      child: Text(
                        (ref.watch(messageFirestoreRiver).currentSalon?.nom ??
                            "chat.group".tr()),
                        style: ChatStyle.pseudoAboutStyle,
                      ),
                    ),
                    SizedBox(width: 5.w),
                    if (ref
                                .watch(messageFirestoreRiver)
                                .currentSalon
                                ?.adminId ==
                            ref.watch(meModelChangeNotifier).myUid ||
                        isActif2)
                      const Icon(Iconsax.edit, size: 17, color: Colors.black),
                  ],
                ),
              ),
              Divider(height: 38.h),
              Text(("chat.group".tr()), style: ChatStyle.pseudoAboutStyle),
              SizedBox(height: 9.h),
              SettingsButton(
                onClick: () {},
                overlayColor: Colors.transparent,
                title: "chat.mute".tr(),
                iconBackgroundColor: AppColor.svgNotifColor,
                subtitle: !isActif ? "chat.enabled".tr() : "chat.disabled".tr(),
                switchNotif: Visibility(
                  replacement: Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: LoaderClassique(radius: 13.r),
                  ),
                  child: Container(
                    margin: EdgeInsets.zero,
                    child: Transform.scale(
                      // for Changing size
                      scale: 1,
                      child: CupertinoSwitch(
                        inactiveTrackColor: Colors.grey,
                        activeTrackColor: AppColor.primaryButtonColor,
                        value: isActif,
                        onChanged: (val) async {
                          setState(() {
                            isActif = !isActif;
                          });
                          if (await Vibration.hasVibrator() == true) {
                            Vibration.vibrate(duration: 100);
                          }
                        },
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 9.h),
              if (ref.watch(messageFirestoreRiver).currentSalon?.adminId ==
                  ref.watch(meModelChangeNotifier).myUid)
                SettingsButton(
                  overlayColor: Colors.transparent,
                  title: "Administration du groupe",
                  iconBackgroundColor: AppColor.svgNotifColor,
                  subtitle: isActif2 ? "Tout le monde" : "Moi uniquement",
                  switchNotif: Visibility(
                    replacement: Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: LoaderClassique(radius: 13.r),
                    ),
                    child: Container(
                      margin: EdgeInsets.zero,
                      child: Transform.scale(
                        // for Changing size
                        scale: 1,
                        child: CupertinoSwitch(
                          inactiveTrackColor: Colors.grey,
                          activeTrackColor: AppColor.primaryButtonColor,
                          value: isActif2,
                          onChanged: (val) async {
                            setState(() {
                              isActif2 = !isActif2;
                            });
                            FirestoreQuery.switchSalonAdminisatrationToAll(
                              salonId: ref
                                  .read(messageFirestoreRiver)
                                  .currentSalon!
                                  .id!,
                              allow: isActif2,
                            );

                            if (await Vibration.hasVibrator() == true) {
                              Vibration.vibrate(duration: 100);
                            }
                          },
                        ),
                      ),
                    ),
                  ),
                  onClick: () async {},
                ),
              SizedBox(height: 21.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    ("chat.participants".tr(
                      namedArgs: {
                        "count": ref
                            .watch(messageFirestoreRiver)
                            .currentSalon!
                            .users
                            .length
                            .toString(),
                      },
                    )),
                    style: ChatStyle.pseudoAboutStyle,
                  ),
                  if (ref.watch(messageFirestoreRiver).currentSalon?.adminId ==
                          ref.watch(meModelChangeNotifier).myUid ||
                      isActif2)
                    MaterialButton(
                      onPressed: () {
                        showModalBottomSheet(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(35.r),
                              topRight: Radius.circular(35.r),
                            ),
                          ),
                          context: context,
                          elevation: 3,
                          builder: (_) {
                            bool loading = false;
                            List<String> user = [];
                            return StatefulBuilder(
                              builder: (BuildContext context, StateSetter newState) {
                                return SafeArea(
                                  child: SizedBox(
                                    height: 728.h,
                                    child: Stack(
                                      children: [
                                        SingleChildScrollView(
                                          child: FutureBuilder(
                                            future: FirebaseFirestore.instance
                                                .collection("users")
                                                .get(),
                                            builder:
                                                (
                                                  context,
                                                  AsyncSnapshot<
                                                    QuerySnapshot<
                                                      Map<String, dynamic>
                                                    >
                                                  >
                                                  snapshot,
                                                ) {
                                                  if (snapshot.hasData) {
                                                    List<UserModel>
                                                    list0 = snapshot.data!.docs
                                                        .map(
                                                          (e) =>
                                                              UserModel.fromJson(
                                                                e.data(),
                                                              ).copyWith(
                                                                id: e.id,
                                                              ),
                                                        )
                                                        .toList();
                                                    list0.removeWhere(
                                                      (element) => ref
                                                          .watch(
                                                            messageFirestoreRiver,
                                                          )
                                                          .participant
                                                          .keys
                                                          .contains(element.id),
                                                    );
                                                    list0.removeWhere(
                                                      (element) =>
                                                          element.id ==
                                                          ref
                                                              .read(
                                                                meModelChangeNotifier,
                                                              )
                                                              .myUid,
                                                    );
                                                    return Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        const Divider(
                                                          indent: 170,
                                                          endIndent: 170,
                                                          thickness: 2,
                                                        ),
                                                        Row(
                                                          children: [
                                                            Padding(
                                                              padding:
                                                                  EdgeInsets.symmetric(
                                                                    horizontal:
                                                                        22.w,
                                                                    vertical:
                                                                        24.h,
                                                                  ).copyWith(
                                                                    top: 20,
                                                                  ),
                                                              child: textSizedColored(
                                                                color: Colors
                                                                    .black,
                                                                size: 15,
                                                                weight: 500,
                                                                text:
                                                                    list0
                                                                        .isEmpty
                                                                    ? "chat.none-to-add"
                                                                          .tr()
                                                                    : "chat.who-to-add"
                                                                          .tr(),
                                                              ),
                                                            ),
                                                            const Spacer(),
                                                            if (user.isNotEmpty)
                                                              InkWell(
                                                                highlightColor:
                                                                    Colors
                                                                        .transparent,
                                                                hoverColor: Colors
                                                                    .transparent,
                                                                onTap: () async {
                                                                  newState(() {
                                                                    loading =
                                                                        true;
                                                                  });
                                                                  if (await Vibration.hasVibrator() ==
                                                                      true) {
                                                                    Vibration.vibrate(
                                                                      duration:
                                                                          50,
                                                                    );
                                                                  }

                                                                  await FirestoreQuery.addUsersToSalon(
                                                                    salonId: ref
                                                                        .read(
                                                                          messageFirestoreRiver,
                                                                        )
                                                                        .currentSalon!
                                                                        .id!,
                                                                    users: user,
                                                                  );
                                                                  ref
                                                                      .read(
                                                                        messageFirestoreRiver,
                                                                      )
                                                                      .addToParticipants(
                                                                        list0
                                                                            .where(
                                                                              (
                                                                                element,
                                                                              ) => user.contains(
                                                                                element.id,
                                                                              ),
                                                                            )
                                                                            .toList(),
                                                                      );
                                                                  if (!context
                                                                      .mounted) {
                                                                    return;
                                                                  }
                                                                  Navigator.pop(
                                                                    context,
                                                                  );

                                                                  newState(() {
                                                                    loading =
                                                                        false;
                                                                  });
                                                                },
                                                                child: Padding(
                                                                  padding:
                                                                      EdgeInsets.symmetric(
                                                                        horizontal:
                                                                            22.w,
                                                                        vertical:
                                                                            24.h,
                                                                      ).copyWith(
                                                                        top: 20,
                                                                      ),
                                                                  child: textSizedColored(
                                                                    color: Colors
                                                                        .blue,
                                                                    size: 15,
                                                                    weight: 500,
                                                                    text:
                                                                        "Ajouter (${user.length})",
                                                                  ),
                                                                ),
                                                              ),
                                                          ],
                                                        ),
                                                        ...list0.map(
                                                          (e) => addUserInSalon(
                                                            e,
                                                            checked: user
                                                                .contains(e.id),
                                                            add: () async {
                                                              if (user.contains(
                                                                e.id,
                                                              )) {
                                                                newState(() {
                                                                  user.remove(
                                                                    e.id,
                                                                  );
                                                                });
                                                              } else {
                                                                newState(() {
                                                                  user.add(
                                                                    e.id!,
                                                                  );
                                                                });
                                                              }
                                                            },
                                                          ),
                                                        ),
                                                      ],
                                                    );
                                                  }
                                                  return const SizedBox();
                                                },
                                          ),
                                        ),
                                        loading
                                            ? Container(
                                                height: 728.h,
                                                color: Colors.white,
                                                child: const Center(
                                                  child: LoaderClassique(
                                                    activeColor: Colors.grey,
                                                  ),
                                                ),
                                              )
                                            : const SizedBox(),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                        );
                      },
                      child: Text(
                        ("chat.add-members".tr()),
                        style: ChatStyle.addMemberToGroup,
                      ),
                    ),
                ],
              ),
              SizedBox(height: 9.h),
              ...ref
                  .watch(messageFirestoreRiver)
                  .participant
                  .values
                  .map(
                    (user) => Padding(
                      padding: EdgeInsets.only(bottom: 7.h),
                      child: Slidable(
                        enabled:
                            ref
                                .watch(messageFirestoreRiver)
                                .currentSalon
                                ?.adminId !=
                            user.id,
                        endActionPane: ActionPane(
                          extentRatio: 0.45,
                          motion: const ScrollMotion(),
                          children: [
                            CustomSlidableAction(
                              backgroundColor: Colors.transparent,
                              flex: 1,
                              onPressed: (c) {
                                bool blocked = false;
                                if (ref
                                        .read(messageFirestoreRiver)
                                        .currentSalon!
                                        .bloquedUser
                                        ?.contains(user.id) ??
                                    false) {
                                  blocked = true;
                                }
                                showModalBottomSheet(
                                  context: context,
                                  builder: (context) => Container(
                                    padding: const EdgeInsets.all(20),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          "${user.firstname ?? ""} ${user.lastname ?? ""}",
                                          style: TextStyle(
                                            fontSize: 25.sp,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(height: 20),
                                        ListTile(
                                          title: Text(
                                            'chat.report-user'.tr(),
                                            style: TextStyle(
                                              color: Colors.blue,
                                            ),
                                          ),
                                          onTap: () {
                                            if (!context.mounted) return;
                                            Navigator.pop(context);
                                            SnackBar snackBar = SnackBar(
                                              content: Text(
                                                "chat.success".tr(),
                                              ),
                                            );
                                            ScaffoldMessenger.of(
                                              context,
                                            ).showSnackBar(snackBar);
                                          },
                                        ),
                                        if (ref
                                                .watch(messageFirestoreRiver)
                                                .currentSalon
                                                ?.adminId ==
                                            ref
                                                .watch(meModelChangeNotifier)
                                                .myUid)
                                          ListTile(
                                            title: Text(
                                              blocked
                                                  ? "chat.unblock-user".tr()
                                                  : 'chat.block-user'.tr(),
                                              style: const TextStyle(
                                                color: Colors.blue,
                                              ),
                                            ),
                                            onTap: () {
                                              if (ref
                                                      .read(
                                                        messageFirestoreRiver,
                                                      )
                                                      .currentSalon!
                                                      .bloquedUser
                                                      ?.contains(user.id) ??
                                                  false) {
                                                FirestoreQuery.removeBloquedToSalon(
                                                  salonId: ref
                                                      .read(
                                                        messageFirestoreRiver,
                                                      )
                                                      .currentSalon!
                                                      .id!,
                                                  userId: user.id!,
                                                );
                                                FriendController.unnbloqueUser(
                                                  user.id!,
                                                );
                                                if (!context.mounted) return;
                                                Navigator.pop(context);
                                              } else {
                                                FirestoreQuery.addBloquedToSalon(
                                                  salonId: ref
                                                      .read(
                                                        messageFirestoreRiver,
                                                      )
                                                      .currentSalon!
                                                      .id!,
                                                  userId: user.id!,
                                                );
                                                FriendController.bloqueUser(
                                                  user.id!,
                                                );
                                                if (!context.mounted) return;
                                                Navigator.pop(context);
                                              }
                                            },
                                          ),
                                        ListTile(
                                          title: const Text(
                                            'Annuler',
                                            style: TextStyle(
                                              color: Colors.grey,
                                            ),
                                          ),
                                          onTap: () {
                                            if (!context.mounted) return;
                                            Navigator.pop(context);
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                              child: Container(
                                width: 45.w,
                                height: 45.h,
                                decoration: BoxDecoration(
                                  color: const Color(0XFFF6F6F6),
                                  borderRadius: BorderRadius.circular(14.r),
                                ),
                                child: const Icon(
                                  Icons.more_horiz_rounded,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                            if (ref
                                    .watch(messageFirestoreRiver)
                                    .currentSalon
                                    ?.adminId ==
                                ref.watch(meModelChangeNotifier).myUid)
                              CustomSlidableAction(
                                onPressed: (ctx) async {
                                  Slidable.of(context)?.close(
                                    duration: const Duration(milliseconds: 100),
                                  );
                                  ref
                                      .read(messageFirestoreRiver)
                                      .removeFromParticipants(user.id!);
                                  await FirestoreQuery.removeUsersFromSalon(
                                    salonId: ref
                                        .read(messageFirestoreRiver)
                                        .currentSalon!
                                        .id!,
                                    users: [user.id!],
                                  );
                                },
                                backgroundColor: Colors.transparent,
                                flex: 1,
                                child: InkWell(
                                  child: Container(
                                    width: 45.w,
                                    height: 45.h,
                                    decoration: BoxDecoration(
                                      color: Colors.red,
                                      borderRadius: BorderRadius.circular(14.r),
                                    ),
                                    child: const Icon(
                                      Icons.logout,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                        child: SettingsButton(
                          switchNotif: const SizedBox(),
                          icon: null,
                          image: user.profilImage != null
                              ? CachedNetworkImageProvider(user.profilImage!)
                              : const CachedNetworkImageProvider(
                                  "https://www.tiphaine-thibert.fr/wp-content/uploads/2016/07/user.png",
                                ),
                          title:
                              "${user.firstname ?? ""} ${user.lastname ?? ""}${ref.watch(messageFirestoreRiver).currentSalon?.adminId == user.id ? " (Admin)" : ""}",
                          onClick: null,
                        ),
                      ),
                    ),
                  ),
              SizedBox(height: 16.h),
              Text(("utils.other".tr()), style: ChatStyle.pseudoAboutStyle),
              SizedBox(height: 16.h),
              InkWell(
                onTap: () async {
                  await FirestoreQuery.setLastDeleteAdd(
                    salonId:
                        ref.read(messageFirestoreRiver).idSalon ??
                        ref.read(messageFirestoreRiver).currentSalon!.id!,
                    userId: ref.read(meModelChangeNotifier).myUid,
                  );
                  SnackBar snackBar = SnackBar(
                    content: Text('chat.delete-conversation-success'.tr()),
                  );
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  }
                },
                child: Container(
                  width: double.infinity,
                  height: 60.h,
                  decoration: BoxDecoration(
                    color: const Color(0XFFF5F5F5).withValues(alpha: 0.67),
                    borderRadius: BorderRadius.circular(7.r),
                  ),
                  child: Center(
                    child: Text(
                      "chat.delete-conversation".tr(),
                      style: TextStyle(
                        color: const Color(0XFF0BBBF0),
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 6.h),
              ref.watch(messageFirestoreRiver).currentSalon?.adminId ==
                      ref.watch(meModelChangeNotifier).myUid
                  ? InkWell(
                      onTap: () async {
                        await FirestoreQuery.deleteSalon(
                          salonId: ref.read(messageFirestoreRiver).idSalon!,
                        );
                        if (!context.mounted) return;
                        Navigator.pop(context);
                        Navigator.pop(context);
                      },
                      child: Container(
                        width: double.infinity,
                        height: 60.h,
                        decoration: BoxDecoration(
                          color: const Color(
                            0XFFF5F5F5,
                          ).withValues(alpha: 0.67),
                          borderRadius: BorderRadius.circular(7.r),
                        ),
                        child: Center(
                          child: Text(
                            "chat.delete-group".tr(),
                            style: TextStyle(
                              color: const Color(0XFFEF4552),
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    )
                  : InkWell(
                      onTap: () async {
                        await FirestoreQuery.leaveSalon(
                          userId: ref.read(meModelChangeNotifier).myUid,
                          salonId: ref.read(messageFirestoreRiver).idSalon!,
                        );
                        if (!context.mounted) return;
                        Navigator.pop(context);
                        Navigator.pop(context);
                      },
                      child: Container(
                        width: double.infinity,
                        height: 60.h,
                        decoration: BoxDecoration(
                          color: const Color(
                            0XFFF5F5F5,
                          ).withValues(alpha: 0.67),
                          borderRadius: BorderRadius.circular(7.r),
                        ),
                        child: Center(
                          child: Text(
                            "chat.leave-group".tr(),
                            style: TextStyle(
                              color: const Color(0XFFEF4552),
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ),
              SizedBox(height: 60.h),
            ],
          ),
        ),
      ),
    );
  }
}
