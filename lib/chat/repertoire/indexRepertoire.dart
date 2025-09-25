// ignore_for_file: file_names, unused_import

import 'package:cached_network_image/cached_network_image.dart';
import 'package:core_kosmos/core_kosmos.dart';
import 'package:twogather/model/color.dart';
import 'package:twogather/widgets/toggle_swicth/core.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../Packages/24.Text/index.dart';
import '../chatColor.dart';
import '../chatPage/indexChatPage.dart';
import '../chatStyle.dart';
import '../enum/enumMessage.dart';
import '../freezed/salon/salonModel.dart';
import '../freezed/user/userModel.dart';
import '../riverpods/me_notifier.dart';
import '../riverpods/salon_river.dart';
import '../services/firestore/index.dart';
import '../utils/loader_ios.dart';
import '../widgets/repertoire/repertoireWidget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:vibration/vibration.dart';
import 'package:iconsax/iconsax.dart';
import 'package:tab_indicator_styler/tab_indicator_styler.dart';
import 'package:intrinsic_grid_view/intrinsic_grid_view.dart';

class IndexRepertoire extends ConsumerStatefulWidget {
  final String meId;
  const IndexRepertoire({super.key, required this.meId});

  @override
  IndexRepertoireState createState() => IndexRepertoireState();
}

class IndexRepertoireState extends ConsumerState<IndexRepertoire>
    with TickerProviderStateMixin {
  late TabController tabController;
  late PageController pageController;
  int? _pendingPageIndex;

  @override
  void initState() {
    tabController = TabController(length: 2, vsync: this);
    // Définir l'index initial sur 1 (groupes) au lieu de 0 (one-to-one)
    tabController.index = 1;
    // Initialiser le PageController avec l'index 1 (groupes)
    pageController = PageController(initialPage: 1);
    super.initState();
  }

  void goToIndex(int index) {
    setState(() {
      tabController.animateTo(index);
    });
  }

  void _animateToPageSafe(int page) {
    // Pourquoi: éviter l'assertion lorsque le PageController n'est pas encore attaché
    if (pageController.hasClients) {
      pageController.animateToPage(
        page,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeIn,
      );
    } else {
      _pendingPageIndex = page;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (pageController.hasClients && _pendingPageIndex != null) {
          pageController.jumpToPage(_pendingPageIndex!);
          _pendingPageIndex = null;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: formatWidth(20)),
      child: Column(
        children: [
          sh(60),
          Padding(
            padding: EdgeInsets.only(right: 20.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('chat.header'.tr(), style: AppTextStyle.black(16)),
              ],
            ),
          ),
          sh(27),
          ToggleSwicth(
            height: formatHeight(41),
            activeGradient: AppColor.mainGradient,
            items: [
              ToggleItem(
                label: "chat.event-room".tr(),
                onTap: () => _animateToPageSafe(1),
              ),
              ToggleItem(
                label: "chat.private-discussions".tr(),
                onTap: () => _animateToPageSafe(0),
              ),
            ],
          ),
          Expanded(
            child: KeepAlivePage(
              child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection("Salons")
                    .where("users", arrayContains: widget.meId)
                    .snapshots(),
                builder:
                    (
                      _,
                      AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                      snapshot,
                    ) {
                      if (snapshot.hasData && snapshot.data != null) {
                        if (snapshot.data!.docs.isEmpty) {
                          return Padding(
                            padding: EdgeInsets.only(right: 20.h),
                            child: Center(child: Text("chat.no-message".tr())),
                          );
                        } else {
                          final listSalon = snapshot.data!.docs.map((e) {
                            return SalonModel.fromJson(
                              e.data(),
                            ).copyWith(id: e.id);
                          }).toList();

                          final oToSalon = listSalon
                              .where((e) => e.type == SalonType.oneToOne)
                              .toList();

                          oToSalon.sort((a, b) {
                            if (a.lastMessageContent == null &&
                                b.lastMessageContent == null) {
                              return 0;
                            } else if (a.lastMessageContent == null) {
                              return 1;
                            } else if (b.lastMessageContent == null) {
                              return -1;
                            } else {
                              return b.lastMessageContent!.createdAt.compareTo(
                                a.lastMessageContent!.createdAt,
                              );
                            }
                          });

                          final groupSalon = listSalon
                              .where((e) => e.type == SalonType.group)
                              .toList();

                          groupSalon.sort((a, b) {
                            if (a.lastMessageContent == null &&
                                b.lastMessageContent == null) {
                              return 0;
                            } else if (a.lastMessageContent == null) {
                              return 1;
                            } else if (b.lastMessageContent == null) {
                              return -1;
                            } else {
                              return b.lastMessageContent!.createdAt.compareTo(
                                a.lastMessageContent!.createdAt,
                              );
                            }
                          });

                          return PageView(
                            physics: const NeverScrollableScrollPhysics(),
                            onPageChanged: (x) => goToIndex(x),
                            controller: pageController,
                            children: [
                              // Page 0: One-to-one
                              oToSalon.isEmpty
                                  ? Center(
                                      child: Text(
                                        "chat.no-private".tr(),
                                        style: AppTextStyle.gray(14),
                                      ),
                                    )
                                  : ListView(
                                      physics: const BouncingScrollPhysics(),
                                      children: oToSalon
                                          .map((e) => rowContact(e))
                                          .toList(),
                                    ),
                              // Page 1: Groupes
                              groupSalon.isEmpty
                                  ? Center(
                                      child: Text(
                                        "chat.no-group".tr(),
                                        style: AppTextStyle.gray(14),
                                      ),
                                    )
                                  : ListView(
                                      physics: const BouncingScrollPhysics(),
                                      children: groupSalon
                                          .map((e) => rowContact(e))
                                          .toList(),
                                    ),
                            ],
                          );
                        }
                      }
                      return const Center(child: LoaderClassique());
                    },
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    tabController.dispose();
    pageController.dispose();
    super.dispose();
  }

  Widget cardAllSalon(SalonModel salonModel, String meId) => InkWell(
    onTap: () async {
      if (salonModel.users.isNotEmpty && salonModel.users.contains(meId)) {
        ref.read(salonMessagesNotifier).init();
        ref
            .read(messageFirestoreRiver)
            .init(
              idSalon: salonModel.id!,
              userUid: ref.read(meModelChangeNotifier).myUid!,
            );
        ref.read(messageFirestoreRiver).initMessages(salonId: salonModel.id!);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => IndexChatPage(
              salonType: salonModel.type,
              meId: widget.meId,
              salonId: salonModel.id!,
            ),
          ),
        );
      } else {
        showModalBottomSheet(
          context: context,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
          ),
          builder: (BuildContext context) {
            return Container(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Que souhaitez-vous faire ?',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  ListTile(
                    leading: const Icon(Icons.group_add, color: Colors.blue),
                    title: const Text(
                      'Devenir membre',
                      style: TextStyle(color: Colors.blue),
                    ),
                    onTap: () {
                      Navigator.pop(context);

                      FirebaseFirestore.instance
                          .collection("Salons")
                          .doc(salonModel.id)
                          .update({
                            "users": FieldValue.arrayUnion([meId]),
                          });

                      ref.read(salonMessagesNotifier).init();
                      ref
                          .read(messageFirestoreRiver)
                          .init(
                            idSalon: salonModel.id!,
                            userUid: ref.read(meModelChangeNotifier).myUid!,
                          );

                      ref
                          .read(messageFirestoreRiver)
                          .initMessages(salonId: salonModel.id!);

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => IndexChatPage(
                            salonType: salonModel.type,
                            meId: widget.meId,
                            salonId: salonModel.id!,
                          ),
                        ),
                      );
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.close, color: Colors.red),
                    title: const Text(
                      'Fermer',
                      style: TextStyle(color: Colors.red),
                    ),
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
            );
          },
        );
      }
      ref.read(salonMessagesNotifier).init();
      ref
          .read(messageFirestoreRiver)
          .init(
            idSalon: salonModel.id!,
            userUid: ref.read(meModelChangeNotifier).myUid!,
          );

      ref.read(messageFirestoreRiver).initMessages(salonId: salonModel.id!);
    },
    child: Container(
      width: 147.w,
      decoration: BoxDecoration(
        color: const Color(0XFFF6F6F6),
        borderRadius: BorderRadius.circular(13.r),
      ),
      child: Padding(
        padding: EdgeInsets.only(top: 31.h, bottom: 17.h),
        child: Column(
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
            SizedBox(height: 22.h),
            Text(salonModel.nom!, style: ChatStyle.contactListAllGroupName),
            SizedBox(height: 22.h),
            Text(
              salonModel.users.isEmpty
                  ? "Nouveau"
                  : ("${salonModel.users.length} membre${salonModel.users.length > 1 ? "s" : ""}"),
              style: ChatStyle.contactListAllGroupMember,
            ),
          ],
        ),
      ),
    ),
  );

  Widget rowContact(SalonModel salonModel) => InkWell(
    onTap: () async {
      ref.read(salonMessagesNotifier).init();
      ref
          .read(messageFirestoreRiver)
          .init(
            idSalon: salonModel.id!,
            userUid: ref.read(meModelChangeNotifier).myUid!,
          );

      ref.read(messageFirestoreRiver).initMessages(salonId: salonModel.id!);

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => IndexChatPage(
            salonType: salonModel.type,
            meId: widget.meId,
            salonId: salonModel.id!,
          ),
        ),
      );
    },
    child: Slidable(
      endActionPane: ActionPane(
        motion: const ScrollMotion(),
        children: [
          Expanded(
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InkWell(
                  onTap: () {
                    // Gestion de l'événement pour le premier bouton du répertoire
                    // Implémentation spécifique selon le contexte
                  },
                  child: Container(
                    width: 45.w,
                    height: 45.h,
                    decoration: BoxDecoration(
                      color: const Color(0XFFF6F6F6),
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: const Icon(
                      Icons.more_horiz_rounded,
                      color: Colors.grey,
                    ),
                  ),
                ),
                SizedBox(width: 10.w),
                InkWell(
                  onTap: () {
                    // Gestion de l'événement pour le bouton de suppression
                    // Implémentation spécifique selon le contexte
                  },
                  child: Container(
                    width: 45.w,
                    height: 45.h,
                    decoration: BoxDecoration(
                      color: const Color(0xFFEB5353),
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: Center(
                      child: SvgPicture.asset(
                        "assets/svg/ic_delete.svg",
                        colorFilter: ColorFilter.mode(
                          Colors.white,
                          BlendMode.srcIn,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),

      // The child of the Slidable is what the user sees when the
      // component is not dragged.
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(vertical: 7.h).copyWith(right: 20.w),
            child: salonModel.type == SalonType.oneToOne
                ? salonOneToOneUser(salonModel, widget.meId)
                : salonGroup(salonModel, widget.meId),
          ),
          Divider(
            indent: 67.w,
            color: const Color(0XFF001A39).withValues(alpha: 0.14),
            thickness: 0.5,
          ),
        ],
      ),
    ),
  );
}

class KeepAlivePage extends StatefulWidget {
  const KeepAlivePage({super.key, required this.child});

  final Widget child;

  @override
  State<KeepAlivePage> createState() => _KeepAlivePageState();
}

class _KeepAlivePageState extends State<KeepAlivePage>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    /// Dont't forget this
    super.build(context);

    return widget.child;
  }

  @override
  bool get wantKeepAlive => true;
}
