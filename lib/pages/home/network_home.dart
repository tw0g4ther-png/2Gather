import 'package:auto_route/auto_route.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:core_kosmos/core_kosmos.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:twogather/chat/chatPage/indexChatPage.dart';
import 'package:twogather/chat/enum/enumMessage.dart';
import 'package:twogather/chat/freezed/salon/salonModel.dart';
import 'package:twogather/chat/riverpods/me_notifier.dart';
import 'package:twogather/chat/riverpods/salon_river.dart';
import 'package:twogather/chat/services/firestore/index.dart';
import 'package:twogather/controller/friend_controller.dart';
import 'package:twogather/model/color.dart';
import 'package:twogather/model/passion/passion_listing.dart';
import 'package:twogather/model/user/app_user/app_user_model.dart';
import 'package:twogather/model/user/fiestar_model.dart';
import 'package:twogather/provider/geoloc_provider.dart';
import 'package:twogather/main.dart';
import 'package:twogather/routes/app_router.dart';
import 'package:twogather/services/birthday.dart';
import 'package:twogather/widgets/badge/notification_badge.dart';
import 'package:twogather/widgets/button/core.dart';
import 'package:twogather/widgets/lock_duo/widget.dart';
import 'package:twogather/widgets/toggle_swicth/core.dart';
import 'package:twogather/widgets/user_card/widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shimmer/shimmer.dart';
import 'package:skeleton_kosmos/skeleton_kosmos.dart';
import 'package:ui_kosmos_v4/ui_kosmos_v4.dart';

class NetworkHomePage extends StatefulHookConsumerWidget {
  const NetworkHomePage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _NetworkHomePageState();
}

class _NetworkHomePageState extends ConsumerState<NetworkHomePage> {
  ValueNotifier<int> page = ValueNotifier<int>(0);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: formatWidth(22)),
          child: Column(
            children: [
              sh(12),
              Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const GeolocWidget(),
                        sh(3),
                        Text(
                          "utils.my-network".tr(),
                          style: AppTextStyle.darkBlue(22, FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                  sw(20),
                  Button(
                    width: formatWidth(50),
                    height: formatWidth(50),
                    onTap: () {
                      AutoRouter.of(
                        context,
                      ).navigateNamed("/dashboard/network/search");
                    },
                    child: SvgPicture.asset("assets/svg/ic_search.svg"),
                  ),
                  sw(8),
                  NotificationBadge(
                    count: ref.watch(notificationProvider).unreadCount,
                    child: Button(
                      width: formatWidth(50),
                      height: formatWidth(50),
                      onTap: () {
                        AutoRouter.of(
                          context,
                        ).navigateNamed("/dashboard/notif");
                      },
                      child: SvgPicture.asset("assets/svg/ic_ring.svg"),
                    ),
                  ),
                ],
              ),
              sh(10),
              Row(
                children: [
                  Text(
                    "app.my-lock-duo".tr(),
                    style: AppTextStyle.black(15, FontWeight.bold),
                  ),
                  sw(6),
                  SvgPicture.asset(
                    'assets/svg/ic_info.svg',
                    width: formatWidth(17),
                    colorFilter: ColorFilter.mode(
                      AppColor.mainColor,
                      BlendMode.srcIn,
                    ),
                  ),
                ],
              ),
              sh(8),
              LockDuoWidget(
                duo:
                    (ref.watch(userChangeNotifierProvider).userData
                            as FiestarUserModel?)
                        ?.duo,
              ),
              sh(15),
              Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Expanded(
                    child: Text(
                      "app.circle".tr(),
                      style: AppTextStyle.black(15),
                    ),
                  ),
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        AutoRouter.of(
                          context,
                        ).navigateNamed("/dashboard/network/request");
                      },
                      child: Text(
                        "app.sended-demand".tr(),
                        style: AppTextStyle.mainColor(12.5),
                        textAlign: TextAlign.end,
                      ),
                    ),
                  ),
                ],
              ),
              sh(6),
              ToggleSwicth(
                height: formatHeight(41),
                customColors: const [
                  Color(0xFFFFDB12),
                  Color(0xFF5FEC69),
                  Color(0xFF5C81FF),
                ],
                items: [
                  ToggleItem(
                    label: "app.first-circle".tr(),
                    onTap: () => page.value = 0,
                  ),
                  ToggleItem(
                    label: "app.my-fiestar".tr(),
                    onTap: () => page.value = 1,
                  ),
                  ToggleItem(
                    label: "app.my-connexion".tr(),
                    onTap: () => page.value = 2,
                  ),
                ],
              ),
              ValueListenableBuilder(
                valueListenable: page,
                builder: (context, int val, child) {
                  return val == 0
                      ? _buildFirstCircle()
                      : val == 1
                      ? _buildMyFiestar()
                      : _buildMyConnexion();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFirstCircle() {
    return Column(
      children: [
        sh(12),
        InkWell(
          onTap: () {
            _selectFirstCircle(
              (ref.watch(userChangeNotifierProvider).userData
                          as FiestarUserModel?)
                      ?.friends
                      ?.where((element) => element["type"] == "fiestar")
                      .toList() ??
                  [],
            );
          },
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.add_rounded, color: Color(0xFF5C81FF)),
              Text(
                "app.add-fiestar-to-fav".tr(),
                style: TextStyle(
                  color: const Color(0xFF5C81FF),
                  fontSize: sp(13),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
        sh(15),
        _buildListOfAppUser(
          (ref.watch(userChangeNotifierProvider).userData as FiestarUserModel?)
                  ?.friends
                  ?.where((element) => element["type"] == "1_circle")
                  .toList() ??
              [],
          true,
        ),
        sh(20),
      ],
    );
  }

  Widget _buildMyFiestar() {
    return Column(
      children: [
        sh(15),
        _buildListOfAppUser(
          (ref.watch(userChangeNotifierProvider).userData as FiestarUserModel?)
                  ?.friends
                  ?.where((element) => element["type"] == "fiestar")
                  .toList() ??
              [],
          true,
        ),
        sh(20),
      ],
    );
  }

  Widget _buildMyConnexion() {
    return Column(
      children: [
        sh(15),
        _buildListOfAppUser(
          (ref.watch(userChangeNotifierProvider).userData as FiestarUserModel?)
                  ?.friends
                  ?.where((element) => element["type"] == "connexion")
                  .toList() ??
              [],
        ),
        sh(20),
      ],
    );
  }

  Widget _buildListOfAppUser(
    List<Map<String, dynamic>> users, [
    bool enableChat = false,
  ]) {
    return AnimationLimiter(
      child: GridView.count(
        crossAxisCount: 2,
        crossAxisSpacing: formatWidth(12),
        mainAxisSpacing: formatWidth(12),
        childAspectRatio: formatWidth(154) / formatHeight(185),
        controller: ScrollController(keepScrollOffset: false),
        shrinkWrap: true,
        scrollDirection: Axis.vertical,
        children: users.map((e) {
          final index = users.indexOf(e);
          return AnimationConfiguration.staggeredGrid(
            position: index,
            duration: const Duration(milliseconds: 375),
            columnCount: 2,
            child: ScaleAnimation(
              child: FadeInAnimation(
                child: FutureBuilder<DocumentSnapshot>(
                  future: (e["user"] as DocumentReference).get(),
                  builder: (_, AsyncSnapshot<DocumentSnapshot> snapshot) {
                    if (snapshot.hasData &&
                        snapshot.data != null &&
                        snapshot.data!.exists &&
                        snapshot.data!.data() != null) {
                      final Map<String, dynamic> raw =
                          snapshot.data!.data()! as Map<String, dynamic>;
                      final data = AppUserModel.fromJson(raw).copyWith(
                        id: snapshot.data!.id,
                        pictures: (raw["profilImages"] as List<dynamic>?)
                            ?.map((e) => e as String)
                            .toList(),
                        // Mapper le champ 'favorite' vers 'tags' pour l'affichage des favoris
                        tags: raw["favorite"] != null
                            ? PassionListing.fromJson(raw["favorite"])
                            : raw["tags"] != null
                            ? PassionListing.fromJson(raw["tags"])
                            : null,
                      );
                      return UserCardWidget(
                        onLongPress: data.id == "B8drnR5SpphFShASN2rGoQJFGL32"
                            ? () {}
                            : null,
                        onTap: () {
                          printInDebug("[Friend] go to profil of ${data.id}");
                          AutoRouter.of(context).navigate(
                            FriendProfilRoute(
                              id: data.id ?? snapshot.data!.id,
                              userModel: data,
                            ),
                          );
                        },
                        image: data.pictures?.isNotEmpty ?? false
                            ? data.pictures!.first
                            : "",
                        title: data.firstname ?? "",
                        id: data.id ?? snapshot.data!.id,
                        subTitle:
                            "${data.birthday != null ? "${DateTime.now().difference(data.birthday!).formatToGetAge()} ans" : ""}${data.locality != null && (data.locality?.isNotEmpty ?? false) ? (data.birthday != null ? " • ${data.locality}" : data.locality!) : ""}",
                        isLock: data.isLock ?? false,
                        topRightAction: (!(data.isLock ?? false)) && enableChat
                            ? Button(
                                // Bouton pour ouvrir le chat avec l'utilisateur
                                width: formatWidth(32),
                                height: formatWidth(32),
                                decoration: BoxDecoration(
                                  color: const Color(
                                    0xFF838383,
                                  ).withValues(alpha: .2),
                                  borderRadius: BorderRadius.circular(100),
                                ),
                                onTap: () async {
                                  String? existSalon =
                                      await FirestoreQuery.existSalonOneToOneWithGivenUsers(
                                        uid1: FirebaseAuth
                                            .instance
                                            .currentUser!
                                            .uid,
                                        uid2: data.id ?? snapshot.data!.id,
                                      );

                                  if (existSalon != null) {
                                    ref.read(salonMessagesNotifier).init();

                                    ref
                                        .read(messageFirestoreRiver)
                                        .init(
                                          idSalon: existSalon,
                                          userUid: ref
                                              .read(meModelChangeNotifier)
                                              .myUid!,
                                        );
                                    ref
                                        .read(messageFirestoreRiver)
                                        .initMessages(salonId: existSalon);
                                    if (!mounted) return;
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => IndexChatPage(
                                          salonType: SalonType.oneToOne,
                                          meId: FirebaseAuth
                                              .instance
                                              .currentUser!
                                              .uid,
                                          salonId: existSalon,
                                        ),
                                      ),
                                    );
                                  } else {
                                    SalonModel salonModel = SalonModel(
                                      type: SalonType.oneToOne,
                                      users: [
                                        FirebaseAuth.instance.currentUser!.uid,
                                        data.id,
                                      ],
                                    );
                                    await FirestoreQuery.addSalonOneToOne(
                                      salonModel: salonModel,
                                      myUid: FirebaseAuth
                                          .instance
                                          .currentUser!
                                          .uid,
                                      otherUid: data.id,
                                    );
                                    ref.read(salonMessagesNotifier).init();
                                    ref
                                        .read(messageFirestoreRiver)
                                        .init(
                                          idSalon:
                                              FirebaseAuth
                                                  .instance
                                                  .currentUser!
                                                  .uid +
                                              (data.id ?? snapshot.data!.id),
                                          userUid: FirebaseAuth
                                              .instance
                                              .currentUser!
                                              .uid,
                                        );
                                    ref
                                        .read(messageFirestoreRiver)
                                        .initMessages(
                                          salonId:
                                              FirebaseAuth
                                                  .instance
                                                  .currentUser!
                                                  .uid +
                                              (data.id ?? snapshot.data!.id),
                                        );

                                    if (!mounted) return;
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => IndexChatPage(
                                          salonType: SalonType.oneToOne,
                                          meId: FirebaseAuth
                                              .instance
                                              .currentUser!
                                              .uid,
                                          salonId:
                                              FirebaseAuth
                                                  .instance
                                                  .currentUser!
                                                  .uid +
                                              (data.id ?? snapshot.data!.id),
                                        ),
                                      ),
                                    );
                                  }
                                },
                                child: SvgPicture.asset(
                                  "assets/svg/ic_tchat.svg",
                                  colorFilter: ColorFilter.mode(
                                    Colors.white,
                                    BlendMode.srcIn,
                                  ),
                                ),
                              )
                            : null,
                      );
                    }
                    return Shimmer.fromColors(
                      period: const Duration(seconds: 2),
                      baseColor: const Color(0xFF02132B).withValues(alpha: .08),
                      highlightColor: const Color(
                        0xFF02132B,
                      ).withValues(alpha: .0),
                      child: Container(
                        height: formatHeight(185),
                        width: formatWidth(154),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.black,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Future<void> _selectFirstCircle(List<Map<String, dynamic>> fiestars) async {
    await showModalBottomSheet(
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(45),
          topRight: Radius.circular(45),
        ),
      ),
      context: context,
      builder: (context) {
        List<String> selectedFiestars = [];

        return StatefulBuilder(
          builder: (context, newState) {
            return AnimationLimiter(
              child: Container(
                constraints: BoxConstraints(
                  minHeight: formatHeight(300),
                  maxHeight: formatHeight(650),
                ),
                padding: EdgeInsets.only(left: formatWidth(22.5)),
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(45),
                    topRight: Radius.circular(45),
                  ),
                  color: Colors.white,
                ),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      sh(11),
                      Container(
                        height: 4,
                        width: formatWidth(35),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          color: const Color(0xFFC9C9C9),
                        ),
                      ),
                      sh(12),
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Expanded(
                            child: Text(
                              "Choisis des fiestars à ajouter dans ton “1er cercle”",
                              style: AppTextStyle.black(16),
                            ),
                          ),
                          sw(15),
                          InkWell(
                            onTap: () async {
                              final currentContext = context;
                              final rep =
                                  await FriendController.addToFirstCircle(
                                    (ref
                                                    .read(
                                                      userChangeNotifierProvider,
                                                    )
                                                    .userData
                                                as FiestarUserModel?)
                                            ?.friends ??
                                        [],
                                    selectedFiestars,
                                  );
                              if (!currentContext.mounted) return;
                              if (rep) {
                                NotifBanner.showToast(
                                  context: currentContext,
                                  fToast: FToast().init(currentContext),
                                  subTitle: "utils.error-msg".tr(),
                                );
                              }
                              if (mounted) {
                                Navigator.of(context).pop();
                              }
                            },
                            child: Text(
                              "utils.save".tr(),
                              style: AppTextStyle.mainColor(
                                14,
                                FontWeight.w600,
                              ),
                            ),
                          ),
                          sw(22.5),
                        ],
                      ),
                      sh(20),
                      ...fiestars.map(
                        (e) => FutureBuilder(
                          future: (e["user"] as DocumentReference).get(),
                          builder: (_, AsyncSnapshot<DocumentSnapshot> snapshot) {
                            if (snapshot.hasData && snapshot.data != null) {
                              final data =
                                  AppUserModel.fromJson(
                                    snapshot.data!.data()!
                                        as Map<String, dynamic>,
                                  ).copyWith(
                                    id: snapshot.data!.id,
                                    pictures:
                                        ((snapshot.data!.data()!
                                                    as Map)["profilImages"]
                                                as List<dynamic>?)
                                            ?.map((e) => e as String)
                                            .toList(),
                                  );
                              return Column(
                                children: [
                                  Row(
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      Container(
                                        width: formatWidth(40.5),
                                        height: formatWidth(40.5),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                            100,
                                          ),
                                          image: DecorationImage(
                                            image:
                                                (data.pictures?.isNotEmpty ??
                                                    false)
                                                ? CachedNetworkImageProvider(
                                                    data.pictures!.first,
                                                  )
                                                : const AssetImage(
                                                        "assets/images/img_user_profil.png",
                                                      )
                                                      as ImageProvider,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                      sw(13.5),
                                      Expanded(
                                        child: Text(
                                          "${data.firstname} ${data.lastname?.replaceRange(1, data.lastname?.length, "")}.",
                                          style: AppTextStyle.black(
                                            16,
                                            FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                      sw(13.5),
                                      CustomCheckbox.square(
                                        borderRadius: 100,
                                        selectedColor: AppColor.mainColor,
                                        isChecked: selectedFiestars.contains(
                                          data.id!,
                                        ),
                                        onTap: () {
                                          if (!selectedFiestars.contains(
                                            data.id!,
                                          )) {
                                            newState(() {
                                              selectedFiestars.add(data.id!);
                                            });
                                          } else {
                                            newState(() {
                                              selectedFiestars.remove(data.id!);
                                            });
                                          }
                                        },
                                      ),
                                      sw(19),
                                    ],
                                  ),
                                  sh(4.5),
                                  Row(
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      sw(44),
                                      const Expanded(child: Divider()),
                                    ],
                                  ),
                                  sh(9),
                                ],
                              );
                            }
                            return Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Shimmer.fromColors(
                                  period: const Duration(seconds: 2),
                                  baseColor: const Color(
                                    0xFF02132B,
                                  ).withValues(alpha: .08),
                                  highlightColor: const Color(
                                    0xFF02132B,
                                  ).withValues(alpha: .0),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      Container(
                                        width: formatWidth(40.5),
                                        height: formatWidth(40.5),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                            100,
                                          ),
                                          color: Colors.black,
                                        ),
                                      ),
                                      sw(13.5),
                                      Container(
                                        width: formatWidth(145),
                                        height: formatWidth(28),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                            28,
                                          ),
                                          color: const Color(0xFFF5F5F5),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                sh(4.5),
                                Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    sw(44),
                                    const Expanded(child: Divider()),
                                  ],
                                ),
                                sh(9),
                              ],
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
