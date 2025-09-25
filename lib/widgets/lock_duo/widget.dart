import 'package:auto_route/auto_route.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:core_kosmos/core_package.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:twogather/controller/friend_controller.dart';
import 'package:twogather/model/color.dart';
import 'package:twogather/model/user/app_user/app_user_model.dart';
import 'package:twogather/model/user/fiestar_model.dart';
import 'package:twogather/widgets/alert/core.dart';
import 'package:twogather/widgets/button/core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shimmer/shimmer.dart';
import 'package:skeleton_kosmos/skeleton_kosmos.dart';
import 'package:ui_kosmos_v4/ui_kosmos_v4.dart';

class LockDuoWidget extends ConsumerStatefulWidget {
  final AppUserModel? duo;

  const LockDuoWidget({super.key, this.duo});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _LockDuoWidgetState();
}

class _LockDuoWidgetState extends ConsumerState<LockDuoWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        vertical: formatHeight(11),
        horizontal: formatWidth(15),
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(100),
        color: AppColor.mainColor.withValues(alpha: .07),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          Expanded(child: _buildDuoInfo(context)),
          sw(12),
          if (widget.duo == null) ...[
            Button(
              height: formatWidth(35),
              width: formatWidth(35),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(formatWidth(35)),
                color: AppColor.mainColor,
              ),
              onTap: () async {
                printInDebug("[LockDuo] Choose new lock duo");
                await _chooseNewLockDuo(
                  context,
                  (ref.read(userChangeNotifierProvider).userData!
                              as FiestarUserModel)
                          .friends
                          ?.where(
                            (element) =>
                                element["type"] == "1_circle" ||
                                element["type"] == "fiestar",
                          )
                          .toList() ??
                      [],
                );
              },
              child: const Icon(Icons.add_rounded, color: Colors.white),
            ),
          ] else ...[
            Button(
              height: formatWidth(35),
              width: formatWidth(35),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(formatWidth(35)),
                color: AppColor.mainColor,
              ),
              onTap: () {
                // Navigation vers le chat du duo
                AutoRouter.of(
                  context,
                ).navigateNamed("/dashboard/chat/duo_${widget.duo?.id ?? ""}");
              },
              child: SvgPicture.asset(
                "assets/svg/ic_speech_bubble.svg",
                colorFilter: const ColorFilter.mode(
                  Colors.white,
                  BlendMode.srcIn,
                ),
              ),
            ),
            sw(12),
            InkWell(
              onTap: () async {
                await AlertBox.show(
                  context: context,
                  title: "app.end-duo".tr(),
                  message: "app.end-duo-desc".tr(
                    namedArgs: {"name": widget.duo!.firstname!},
                  ),
                  actions: [
                    (_) => CTA.primary(
                      textButton: "app.end-duo".tr(),
                      width: formatWidth(207),
                      textButtonStyle: AppTextStyle.white(14, FontWeight.w600),
                      onTap: () async {
                        await FriendController.stopLockDuo(
                          FirebaseAuth.instance.currentUser!.uid,
                          widget.duo!.id!,
                        );
                        if (!context.mounted) return;
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                );
              },
              child: SvgPicture.asset(
                "assets/svg/ic_lock.svg",
                colorFilter: ColorFilter.mode(
                  AppColor.mainColor,
                  BlendMode.srcIn,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildDuoInfo(BuildContext context) {
    if (widget.duo == null) {
      return Text(
        "app.dont-have-duo".tr(),
        style: TextStyle(
          color: Colors.black.withValues(alpha: .65),
          fontSize: sp(14),
          fontWeight: FontWeight.w500,
        ),
      );
    }
    return Row(
      mainAxisSize: MainAxisSize.max,
      children: [
        if (widget.duo!.pictures != null &&
            widget.duo!.pictures!.isNotEmpty) ...[
          Container(
            clipBehavior: Clip.hardEdge,
            width: formatWidth(39),
            height: formatWidth(39),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(formatWidth(39)),
            ),
            child: CachedNetworkImage(
              imageUrl: widget.duo!.pictures!.first,
              fit: BoxFit.cover,
            ),
          ),
        ],
        sw(9),
        if (widget.duo!.firstname != null) ...[
          Text(widget.duo!.firstname!, style: AppTextStyle.black(14)),
        ],
      ],
    );
  }

  Future<void> _chooseNewLockDuo(
    BuildContext context,
    List<Map<String, dynamic>> friendsEnabled,
  ) async {
    printInDebug("[LockDuo] Choose new lock duo inside $friendsEnabled");

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
      builder: (_) {
        String? selectedFiestars;
        bool isLoading = false;

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
                              if (isLoading) {
                                return;
                              }
                              isLoading = true;
                              if (selectedFiestars == null) {
                                Navigator.of(context).pop();
                                return;
                              }
                              Navigator.of(context).pop();
                              final rep =
                                  await FriendController.requestNewLockDuo(
                                    FirebaseAuth.instance.currentUser!.uid,
                                    selectedFiestars!,
                                    null,
                                  );
                              if (!context.mounted) return;
                              if (rep) {
                                NotifBanner.showToast(
                                  context: context,
                                  fToast: FToast().init(context),
                                  subTitle: "utils.error-msg".tr(),
                                );
                              } else {
                                NotifBanner.showToast(
                                  context: context,
                                  fToast: FToast().init(context),
                                  backgroundColor: const Color(0xFF0ACC73),
                                  subTitle: "app.success-msg-duo-sent".tr(),
                                );
                              }
                              isLoading = false;
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
                      ...friendsEnabled.map(
                        (e) => FutureBuilder(
                          future: (e["user"] as DocumentReference).get(),
                          builder: (_, AsyncSnapshot<DocumentSnapshot> snapshot) {
                            if (snapshot.hasData &&
                                snapshot.data != null &&
                                snapshot.data!.exists &&
                                snapshot.data!.data() != null) {
                              final Map<String, dynamic> raw =
                                  snapshot.data!.data()!
                                      as Map<String, dynamic>;
                              final data = AppUserModel.fromJson(raw).copyWith(
                                id: snapshot.data!.id,
                                pictures:
                                    (raw["profilImages"] as List<dynamic>?)
                                        ?.map((e) => e as String)
                                        .toList(),
                              );
                              if (data.isLock == true) {
                                return const SizedBox();
                              }
                              final String safeId =
                                  data.id ?? snapshot.data!.id;
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
                                            image: _getProfileImage(
                                              data.pictures,
                                            ),
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                      sw(13.5),
                                      Expanded(
                                        child: Text(
                                          "${data.firstname ?? ""} ${data.lastname != null && data.lastname!.isNotEmpty ? data.lastname!.replaceRange(1, data.lastname!.length, "") : ""}.",
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
                                        isChecked: selectedFiestars == safeId,
                                        onTap: () {
                                          if (selectedFiestars == safeId) {
                                            selectedFiestars = null;
                                          } else {
                                            selectedFiestars = safeId;
                                          }
                                          newState(() {});
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

  /// Retourne l'image de profil appropriée selon les données utilisateur
  ImageProvider _getProfileImage(List<String>? pictures) {
    if (pictures?.isNotEmpty ?? false) {
      return CachedNetworkImageProvider(pictures!.first);
    }
    return const AssetImage("assets/images/img_user_profil.png");
  }
}
