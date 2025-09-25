import 'dart:ui';

import 'package:auto_route/auto_route.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:core_kosmos/core_kosmos.dart';
import 'package:cupertino_will_pop_scope/cupertino_will_pop_scope.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:twogather/chat/chatPage/indexChatPage.dart';
import 'package:twogather/chat/enum/enumMessage.dart';
import 'package:twogather/chat/freezed/salon/salonModel.dart';
import 'package:twogather/chat/riverpods/me_notifier.dart';
import 'package:twogather/chat/riverpods/salon_river.dart';
import 'package:twogather/chat/services/firestore/index.dart';
import 'package:twogather/controller/friend_controller.dart';
import 'package:twogather/model/color.dart';
import 'package:twogather/model/fiesta/user_fiesta_model.dart';
import 'package:twogather/model/passion/passion_listing.dart';
import 'package:twogather/model/passion/passion_model.dart';
import 'package:twogather/model/user/app_user/app_user_model.dart';
import 'package:twogather/widgets/button/core.dart';
import 'package:twogather/widgets/data_card/core.dart';
import 'package:twogather/widgets/toggle_swicth/core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import "package:flutter/material.dart";
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shimmer/shimmer.dart';
import 'package:skeleton_kosmos/skeleton_kosmos.dart';
import 'package:ui_kosmos_v4/ui_kosmos_v4.dart';

@RoutePage()
class FriendProfilPage extends StatefulHookConsumerWidget {
  final String id;
  final AppUserModel? userModel;

  const FriendProfilPage({
    super.key,
    @PathParam("id") required this.id,
    this.userModel,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _FriendProfilPageState();
}

class _FriendProfilPageState extends ConsumerState<FriendProfilPage> {
  final ValueNotifier<int> page = ValueNotifier<int>(0);

  late Future<List<UserFiestaModel>?> userFiestaCreated;
  late Future<List<UserFiestaModel>?> userParticipatedFiesta;

  @override
  void initState() {
    userFiestaCreated = FriendController.getFiestaOfFriend(
      widget.id,
      "created-fiesta",
    );
    userParticipatedFiesta = FriendController.getFiestaOfFriend(
      widget.id,
      "participated-fiesta",
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ConditionalWillPopScope(
      onWillPop: () async {
        AutoRouter.of(context).back();
        return true;
      },
      shouldAddCallback: true,
      child: ScrollingPage(
        useSafeArea: true,
        safeAreaBottom: false,
        child: Column(
          children: [
            sh(12),
            _buildPrincipalData(context),
            sh(2),
            Center(
              child: Wrap(
                alignment: WrapAlignment.center,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  if (widget.userModel?.locality != null) ...[
                    Text(
                      widget.userModel?.locality ?? "",
                      style: AppTextStyle.darkGray(14),
                    ),
                  ],
                  if (widget.userModel!.rating != null) ...[
                    Row(
                      children: [
                        Text(" -  ", style: AppTextStyle.darkGray(14)),
                        Text(
                          widget.userModel!.rating!.toStringAsFixed(1),
                          style: AppTextStyle.darkGray(14),
                        ),
                        sw(1),
                        SvgPicture.asset(
                          "assets/svg/ic_star.svg",
                          colorFilter: ColorFilter.mode(
                            const Color(0xFF02132B).withValues(alpha: .65),
                            BlendMode.srcIn,
                          ),
                          width: formatWidth(12),
                        ),
                        sw(1),
                      ],
                    ),
                  ],
                  if (widget.userModel!.numberRecommandations != null) ...[
                    Row(
                      children: [
                        Text(" -  ", style: AppTextStyle.darkGray(14)),
                        SvgPicture.asset(
                          "assets/svg/ic_star.svg",
                          colorFilter: ColorFilter.mode(
                            const Color(0xFF02132B).withValues(alpha: .65),
                            BlendMode.srcIn,
                          ),
                          width: formatWidth(12),
                        ),
                        sw(1),
                        Text(
                          "${widget.userModel!.numberRecommandations!.toInt().toString()} ${"utils.recommandation".plural(widget.userModel!.numberRecommandations!.toInt())}",
                          style: AppTextStyle.darkGray(14),
                        ),
                        sw(1),
                      ],
                    ),
                  ],
                ],
              ),
            ),
            sh(5),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: formatWidth(22)),
              child: SizedBox(
                width: double.infinity,
                child: Text(
                  widget.userModel!.description ?? "",
                  style: AppTextStyle.darkGray(11),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            sh(14),
            _buildSignaletmentBox(context),
            sh(14),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: formatWidth(34)),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        SvgPicture.asset(
                          "assets/svg/ic_global.svg",
                          colorFilter: ColorFilter.mode(
                            AppColor.mainColor,
                            BlendMode.srcIn,
                          ),
                          width: formatWidth(19),
                        ),
                        sw(6),
                        Expanded(
                          child: Wrap(
                            alignment: WrapAlignment.start,
                            children:
                                widget.userModel!.nationality?.map((e) {
                                  final isLast =
                                      widget.userModel!.nationality!.last == e;
                                  return Text(
                                    "${"utils.language.$e".tr()}${isLast ? "" : ", "}",
                                    style: AppTextStyle.darkGray(11),
                                  );
                                }).toList() ??
                                [],
                          ),
                        ),
                      ],
                    ),
                  ),
                  sw(10),
                  Expanded(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        SvgPicture.asset(
                          "assets/svg/ic_speak.svg",
                          colorFilter: ColorFilter.mode(
                            AppColor.mainColor,
                            BlendMode.srcIn,
                          ),
                          width: formatWidth(17.5),
                        ),
                        sw(6),
                        Expanded(
                          child: Wrap(
                            alignment: WrapAlignment.start,
                            children:
                                widget.userModel!.languages?.map((e) {
                                  final isLast =
                                      widget.userModel!.languages!.last == e;
                                  return Text(
                                    "${"utils.language.$e".tr()}${isLast ? "" : ", "}",
                                    style: AppTextStyle.darkGray(11),
                                  );
                                }).toList() ??
                                [],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            sh(22),
            _buildPassion(context),
            sh(22),
            const Divider(),
            sh(14),
            _buildFiestData(context),
            sh(14),
            const Divider(),
            sh(22),
            ToggleSwicth(
              height: formatHeight(41),
              activeGradient: AppColor.mainGradient,
              items: [
                ToggleItem(
                  label: "app.fiesta-created".tr(),
                  onTap: () => page.value = 0,
                ),
                ToggleItem(
                  label: "app.fiesta-involvement".tr(),
                  onTap: () => page.value = 1,
                ),
              ],
            ),
            sh(22),
            ValueListenableBuilder(
              valueListenable: page,
              builder: (context, int val, child) {
                if (val == 0) {
                  return FutureBuilder(
                    future: userFiestaCreated,
                    builder: (context, AsyncSnapshot<List<UserFiestaModel>?> snapshot) {
                      if (snapshot.hasData) {
                        if (snapshot.data == null || snapshot.data!.isEmpty) {
                          return Center(
                            child: Text(
                              "app.no-fiesta-created-for-this-user".tr(),
                              style: AppTextStyle.darkGray(14),
                              textAlign: TextAlign.center,
                            ),
                          );
                        } else {
                          return Column(
                            children: [
                              Text(
                                "Soirées créées par ${widget.userModel!.firstname} (${snapshot.data!.length})",
                                style: AppTextStyle.black(15),
                                textAlign: TextAlign.center,
                              ),
                              sh(15),
                              Wrap(
                                alignment: WrapAlignment.start,
                                runSpacing: formatWidth(10),
                                spacing: formatWidth(10),
                                children: snapshot.data!
                                    .map(
                                      (e) => DataCardWidget(
                                        width: formatWidth(156),
                                        tag: Container(
                                          padding: EdgeInsets.all(
                                            formatWidth(6),
                                          ),
                                          decoration: BoxDecoration(
                                            color: AppColor.mainColor,
                                            borderRadius: BorderRadius.circular(
                                              formatWidth(50),
                                            ),
                                          ),
                                          child: Text(
                                            "${e.startAt?.day.toString().padLeft(2, "0")}.${e.startAt?.month.toString().padLeft(2, "0")}.${e.startAt?.year} ${e.startAt?.month.toString().padLeft(2, "0")}:${e.startAt?.minute.toString().padLeft(2, "0")}",
                                            style: AppTextStyle.white(
                                              7,
                                              FontWeight.w500,
                                            ),
                                          ),
                                        ),
                                        widthImage: formatWidth(156),
                                        heightImage: formatHeight(96),
                                        image: ClipRRect(
                                          borderRadius: BorderRadius.circular(
                                            10,
                                          ),
                                          child: CachedNetworkImage(
                                            imageUrl:
                                                (e.pictures?.isNotEmpty ??
                                                    false)
                                                ? e.pictures!.first
                                                : "",
                                            fit: BoxFit.cover,
                                            errorWidget:
                                                (context, error, stackTrace) {
                                                  return Container(
                                                    color: Colors.grey.shade200,
                                                    child: Icon(
                                                      Icons.image_not_supported,
                                                      color: Colors.grey,
                                                    ),
                                                  );
                                                },
                                          ),
                                        ),
                                        child: Padding(
                                          padding: EdgeInsets.symmetric(
                                            vertical: formatHeight(10),
                                            horizontal: formatWidth(17),
                                          ),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                e.title!,
                                                style: AppTextStyle.black(
                                                  12,
                                                  FontWeight.w600,
                                                ),
                                              ),
                                              sh(8),
                                              Text(
                                                e.address?.city ?? "",
                                                style: AppTextStyle.gray(
                                                  10,
                                                  FontWeight.w400,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    )
                                    .toList(),
                              ),
                            ],
                          );
                        }
                      }
                      return Wrap(
                        alignment: WrapAlignment.start,
                        runSpacing: formatWidth(10),
                        spacing: formatWidth(10),
                        children: List.generate(
                          3,
                          (index) => Shimmer.fromColors(
                            period: const Duration(seconds: 2),
                            baseColor: const Color(
                              0xFF02132B,
                            ).withValues(alpha: .08),
                            highlightColor: const Color(
                              0xFF02132B,
                            ).withValues(alpha: .0),
                            child: DataCardWidget(
                              width: formatWidth(156),
                              height: formatHeight(212),
                            ),
                          ),
                        ),
                      );
                    },
                  );
                } else {
                  return FutureBuilder(
                    future: userParticipatedFiesta,
                    builder: (_, AsyncSnapshot<List<UserFiestaModel>?> snapshot) {
                      if (snapshot.hasData) {
                        if (snapshot.data == null || snapshot.data!.isEmpty) {
                          return Center(
                            child: Text(
                              "app.no-fiesta-participated-for-this-user".tr(),
                              style: AppTextStyle.darkGray(14),
                              textAlign: TextAlign.center,
                            ),
                          );
                        } else {
                          return Column(
                            children: [
                              Text(
                                "Participations passées (${snapshot.data!.length})",
                                style: AppTextStyle.black(15),
                                textAlign: TextAlign.center,
                              ),
                              Wrap(
                                alignment: WrapAlignment.start,
                                runSpacing: formatWidth(10),
                                spacing: formatWidth(10),
                                children: snapshot.data!
                                    .map(
                                      (e) => DataCardWidget(
                                        width: formatWidth(156),
                                        tag: Container(
                                          padding: EdgeInsets.all(
                                            formatWidth(6),
                                          ),
                                          decoration: BoxDecoration(
                                            color: AppColor.mainColor,
                                            borderRadius: BorderRadius.circular(
                                              formatWidth(50),
                                            ),
                                          ),
                                          child: Text(
                                            "${e.startAt?.day.toString().padLeft(2, "0")}.${e.startAt?.month.toString().padLeft(2, "0")}.${e.startAt?.year} ${e.startAt?.month.toString().padLeft(2, "0")}:${e.startAt?.minute.toString().padLeft(2, "0")}",
                                            style: AppTextStyle.white(
                                              7,
                                              FontWeight.w500,
                                            ),
                                          ),
                                        ),
                                        widthImage: formatWidth(156),
                                        heightImage: formatHeight(96),
                                        image: ClipRRect(
                                          borderRadius: BorderRadius.circular(
                                            10,
                                          ),
                                          child: CachedNetworkImage(
                                            imageUrl:
                                                (e.pictures?.isNotEmpty ??
                                                    false)
                                                ? e.pictures!.first
                                                : "",
                                            fit: BoxFit.cover,
                                            errorWidget:
                                                (context, error, stackTrace) {
                                                  return Container(
                                                    color: Colors.grey.shade200,
                                                    child: Icon(
                                                      Icons.image_not_supported,
                                                      color: Colors.grey,
                                                    ),
                                                  );
                                                },
                                          ),
                                        ),
                                        child: Padding(
                                          padding: EdgeInsets.symmetric(
                                            vertical: formatHeight(10),
                                            horizontal: formatWidth(17),
                                          ),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                e.title!,
                                                style: AppTextStyle.black(
                                                  12,
                                                  FontWeight.w600,
                                                ),
                                              ),
                                              sh(8),
                                              Text(
                                                e.address?.city ?? "",
                                                style: AppTextStyle.gray(
                                                  10,
                                                  FontWeight.w400,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    )
                                    .toList(),
                              ),
                            ],
                          );
                        }
                      }
                      return Wrap(
                        alignment: WrapAlignment.start,
                        runSpacing: formatWidth(10),
                        spacing: formatWidth(10),
                        children: List.generate(
                          3,
                          (index) => Shimmer.fromColors(
                            period: const Duration(seconds: 2),
                            baseColor: const Color(
                              0xFF02132B,
                            ).withValues(alpha: .08),
                            highlightColor: const Color(
                              0xFF02132B,
                            ).withValues(alpha: .0),
                            child: DataCardWidget(
                              width: formatWidth(156),
                              height: formatHeight(212),
                            ),
                          ),
                        ),
                      );
                    },
                  );
                }
              },
            ),
            sh(20),
          ],
        ),
      ),
    );
  }

  Widget _buildSignaletmentBox(BuildContext context) {
    if (((widget.userModel)?.reportPoint ?? 0) < 50) return const SizedBox();
    final isRedFlag = ((widget.userModel)?.reportPoint ?? 0) >= 100;
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: formatWidth(7),
        vertical: formatHeight(3.5),
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(formatWidth(50)),
        color: isRedFlag ? const Color(0xFFF42424) : const Color(0xFFFFDD24),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.asset(
            "assets/svg/ic_note.svg",
            colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
            width: formatWidth(20),
          ),
          sw(3),
          Text(
            isRedFlag ? "utils.red-flag".tr() : "utils.yellow-flag".tr(),
            style: AppTextStyle.white(10, FontWeight.w500),
          ),
        ],
      ),
    );
  }

  Widget _buildPrincipalData(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            sh(10),
            CTA.back(
              backgroundColor: Colors.transparent,
              width: null,
              onTap: () => AutoRouter.of(context).back(),
            ),
          ],
        ),
        sw(8),
        Expanded(
          child: Column(
            children: [
              sh(10),
              SizedBox(
                height: formatWidth(103),
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Center(
                      child: Container(
                        width: formatWidth(103),
                        height: formatWidth(103),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(formatWidth(103)),
                          color: Colors.transparent,
                        ),
                        clipBehavior: Clip.hardEdge,
                        child: CachedNetworkImage(
                          imageUrl:
                              (widget.userModel!.pictures?.isNotEmpty ?? false)
                              ? widget.userModel!.pictures!.first
                              : "",
                          fit: BoxFit.cover,
                          width: formatWidth(103),
                          height: formatWidth(103),
                          errorWidget: (context, error, stackTrace) {
                            return Container(
                              width: formatWidth(103),
                              height: formatWidth(103),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(
                                  formatWidth(103),
                                ),
                                color: Colors.grey.shade200,
                              ),
                              child: Image.asset(
                                "assets/images/img_user_profil.png",
                                fit: BoxFit.cover,
                              ),
                            );
                          },
                          placeholder: (context, _) {
                            return Container(
                              width: formatWidth(103),
                              height: formatWidth(103),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(
                                  formatWidth(103),
                                ),
                                color: Colors.grey.shade200,
                              ),
                              child: Image.asset(
                                "assets/images/img_user_profil.png",
                                fit: BoxFit.cover,
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    Positioned(
                      left: 0,
                      right: 0,
                      bottom: -3,
                      child: _buildLevelButton(context),
                    ),
                  ],
                ),
              ),
              sh(4),
              Text(
                "${widget.userModel!.firstname ?? ""} ${widget.userModel!.lastname ?? ""}",
                style: AppTextStyle.darkBlue(28, FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
        sw(8),
        Column(
          children: [
            Button(
              width: formatWidth(53),
              height: formatWidth(53),
              decoration: BoxDecoration(
                gradient: AppColor.mainGradient,
                borderRadius: BorderRadius.circular(formatWidth(50)),
              ),
              child: SvgPicture.asset(
                "assets/svg/ic_tchat.svg",
                height: formatHeight(22),
                colorFilter: const ColorFilter.mode(
                  Colors.white,
                  BlendMode.srcIn,
                ),
              ),
              onTap: () async {
                String? existSalon =
                    await FirestoreQuery.existSalonOneToOneWithGivenUsers(
                      uid1: FirebaseAuth.instance.currentUser!.uid,
                      uid2: widget.id,
                    );

                if (existSalon != null) {
                  ref.read(salonMessagesNotifier).init();

                  ref
                      .read(messageFirestoreRiver)
                      .init(
                        idSalon: existSalon,
                        userUid: ref.read(meModelChangeNotifier).myUid!,
                      );
                  ref
                      .read(messageFirestoreRiver)
                      .initMessages(salonId: existSalon);
                  if (!context.mounted) return;
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => IndexChatPage(
                        salonType: SalonType.oneToOne,
                        meId: FirebaseAuth.instance.currentUser!.uid,
                        salonId: existSalon,
                      ),
                    ),
                  );
                } else {
                  SalonModel salonModel = SalonModel(
                    type: SalonType.oneToOne,
                    users: [FirebaseAuth.instance.currentUser!.uid, widget.id],
                  );
                  await FirestoreQuery.addSalonOneToOne(
                    salonModel: salonModel,
                    myUid: FirebaseAuth.instance.currentUser!.uid,
                    otherUid: widget.id,
                  );
                  ref.read(salonMessagesNotifier).init();
                  ref
                      .read(messageFirestoreRiver)
                      .init(
                        idSalon:
                            FirebaseAuth.instance.currentUser!.uid + widget.id,
                        userUid: FirebaseAuth.instance.currentUser!.uid,
                      );
                  ref
                      .read(messageFirestoreRiver)
                      .initMessages(
                        salonId:
                            FirebaseAuth.instance.currentUser!.uid + widget.id,
                      );
                  if (!context.mounted) return;
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => IndexChatPage(
                        salonType: SalonType.oneToOne,
                        meId: FirebaseAuth.instance.currentUser!.uid,
                        salonId:
                            FirebaseAuth.instance.currentUser!.uid + widget.id,
                      ),
                    ),
                  );
                }
              },
            ),
            sh(8),
            Button(
              width: formatWidth(53),
              height: formatWidth(53),
              decoration: BoxDecoration(
                gradient: AppColor.mainGradient,
                borderRadius: BorderRadius.circular(formatWidth(50)),
              ),
              child: SvgPicture.asset(
                "assets/svg/ic_lock.svg",
                height: formatHeight(22),
                colorFilter: const ColorFilter.mode(
                  Colors.white,
                  BlendMode.srcIn,
                ),
              ),
            ),
            sh(8),
            Button(
              width: formatWidth(53),
              height: formatWidth(33),
              decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(formatWidth(50)),
              ),
              child: Icon(
                Icons.more_vert_rounded,
                color: const Color(0xFF9199A7),
                size: formatHeight(30),
              ),
              onTap: () async => await _friendEvent(),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildLevelButton(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(formatWidth(50)),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
            child: Container(
              height: formatHeight(25),
              padding: EdgeInsets.symmetric(
                horizontal: formatWidth(8),
                vertical: formatHeight(2),
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(formatWidth(50)),
                color: Colors.black.withValues(alpha: .1),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    "assets/svg/ic_crown.svg",
                    width: formatWidth(16),
                  ),
                  sw(5),
                  Text(
                    "Niv. ${widget.userModel!.level?.toInt() ?? 1}",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: formatHeight(12),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _friendEvent() async {
    await showCupertinoModalPopup(
      context: context,
      builder: (modalContext) {
        return CupertinoActionSheet(
          title: Text("utils.what-want-do".tr()),
          actions: [
            CupertinoActionSheetAction(
              child: Text("utils.report-user".tr()),
              onPressed: () {
                Navigator.pop(modalContext);
                // Utiliser le contexte parent pour la navigation
                AutoRouter.of(
                  context,
                ).navigateNamed("/dashboard/report/${widget.id}");
              },
            ),
            CupertinoActionSheetAction(
              isDestructiveAction: true,
              child: Text("utils.delete-friend".tr()),
              onPressed: () {
                Navigator.pop(modalContext);
                // Utiliser le contexte parent pour la navigation
                AutoRouter.of(context).back();
                FriendController.deleteFriend(
                  FirebaseAuth.instance.currentUser!.uid,
                  widget.id,
                );
              },
            ),
          ],
          cancelButton: CupertinoActionSheetAction(
            child: Text("utils.cancel".tr()),
            onPressed: () {
              Navigator.pop(modalContext);
            },
          ),
        );
      },
    );
  }

  Widget _buildPassion(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.center,
      spacing: formatWidth(9),
      runSpacing: formatWidth(9),
      children:
          (transformPassionInTags(
                widget.userModel!.tags ?? const PassionListing(),
              ))
              .map(
                (e) => Container(
                  padding: EdgeInsets.symmetric(
                    vertical: formatHeight(5.5),
                    horizontal: formatWidth(8.5),
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    border: Border.all(
                      color: AppColor.mainColor,
                      width: formatWidth(1),
                    ),
                  ),
                  child: Text(
                    e.name ?? "",
                    style: TextStyle(
                      color: AppColor.mainColor,
                      fontSize: formatHeight(11),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              )
              .toList(),
    );
  }

  List<PassionModel> transformPassionInTags(PassionListing passions) {
    List<PassionModel> ret = [];

    passions.drink?.forEach((element) => ret.add(element));
    passions.music?.forEach((element) => ret.add(element));
    passions.passion?.forEach((element) => ret.add(element));
    passions.fiesta?.forEach((element) => ret.add(element));

    return ret;
  }

  Widget _buildFiestData(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: formatWidth(22)),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          Expanded(
            child: Column(
              children: [
                FutureBuilder(
                  future: userFiestaCreated,
                  builder: (_, AsyncSnapshot<List<UserFiestaModel>?> snapshot) {
                    return Text(
                      (snapshot.hasData && snapshot.data != null)
                          ? snapshot.data!.length.toString()
                          : "0",
                      style: AppTextStyle.darkGray(16, FontWeight.w600),
                    );
                  },
                ),
                sh(3),
                Text(
                  "app.fiesta-created-desc".tr(),
                  style: AppTextStyle.gray(11, FontWeight.w500),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          sw(15),
          Expanded(
            child: Column(
              children: [
                FutureBuilder(
                  future: userParticipatedFiesta,
                  builder: (_, AsyncSnapshot<List<UserFiestaModel>?> snapshot) {
                    return Text(
                      (snapshot.hasData && snapshot.data != null)
                          ? snapshot.data!.length.toString()
                          : "0",
                      style: AppTextStyle.darkGray(16, FontWeight.w600),
                    );
                  },
                ),
                sh(3),
                Text(
                  "app.fiesta-involvement-desc".tr(),
                  style: AppTextStyle.gray(11, FontWeight.w500),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
