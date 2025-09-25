import 'dart:ui';
import 'package:auto_route/auto_route.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:core_kosmos/core_kosmos.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:twogather/main.dart';
import 'package:twogather/model/color.dart';
import 'package:twogather/model/fiesta/user_fiesta_model.dart';
import 'package:twogather/model/passion/passion_listing.dart';
import 'package:twogather/model/passion/passion_model.dart';
import 'package:twogather/model/user/fiestar_model.dart';
import 'package:twogather/pages/home_page.dart';
import 'package:twogather/routes/app_router.dart';
import 'package:twogather/widgets/button/core.dart';
import 'package:twogather/widgets/data_card/core.dart';
import 'package:twogather/widgets/toggle_swicth/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:skeleton_kosmos/skeleton_kosmos.dart';
import 'package:ui_kosmos_v4/cta/cta.dart';

class ProfilHomePage extends StatefulHookConsumerWidget {
  const ProfilHomePage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ProfilHomePageState();
}

class _ProfilHomePageState extends ConsumerState<ProfilHomePage> {
  final ValueNotifier<int> page = ValueNotifier<int>(0);
  final ValueNotifier<String?> participationType = ValueNotifier<String?>(null);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: SingleChildScrollView(
        primary: false,
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: formatWidth(22)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              sh(12),
              _buildPrincipalData(context),
              sh(4),
              Center(
                child: Wrap(
                  alignment: WrapAlignment.center,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Text(
                      (ref.watch(userChangeNotifierProvider).userData
                                  as FiestarUserModel?)
                              ?.locality ??
                          "",
                      style: AppTextStyle.darkGray(14),
                    ),
                    if ((ref.watch(userChangeNotifierProvider).userData
                                as FiestarUserModel?)
                            ?.rating !=
                        null) ...[
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(" -  ", style: AppTextStyle.darkGray(14)),
                          Text(
                            (ref.watch(userChangeNotifierProvider).userData
                                        as FiestarUserModel?)
                                    ?.rating
                                    ?.toStringAsFixed(1) ??
                                "0.0",
                            style: AppTextStyle.darkGray(14),
                          ),
                          sw(1),
                          SvgPicture.asset(
                            "assets/svg/ic_star.svg",
                            colorFilter: ColorFilter.mode(
                              Color(0xFF02132B).withValues(alpha: .65),
                              BlendMode.srcIn,
                            ),
                            width: formatWidth(12),
                          ),
                          sw(1),
                        ],
                      ),
                    ],
                    if ((ref.watch(userChangeNotifierProvider).userData
                                as FiestarUserModel?)
                            ?.numberRecommandations !=
                        null) ...[
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(" -  ", style: AppTextStyle.darkGray(14)),
                          SvgPicture.asset(
                            "assets/svg/ic_star.svg",
                            colorFilter: ColorFilter.mode(
                              Color(0xFF02132B).withValues(alpha: .65),
                              BlendMode.srcIn,
                            ),
                            width: formatWidth(12),
                          ),
                          sw(1),
                          Text(
                            "${(ref.watch(userChangeNotifierProvider).userData as FiestarUserModel?)?.numberRecommandations?.toInt().toString() ?? "0"} ${"utils.recommandation".plural((ref.watch(userChangeNotifierProvider).userData as FiestarUserModel?)?.numberRecommandations?.toInt() ?? 0)}",
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
                    (ref.watch(userChangeNotifierProvider).userData
                                as FiestarUserModel?)
                            ?.description ??
                        "",
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
                                  (ref
                                              .watch(userChangeNotifierProvider)
                                              .userData
                                          as FiestarUserModel?)
                                      ?.nationality
                                      ?.map((e) {
                                        final isLast =
                                            (ref
                                                        .read(
                                                          userChangeNotifierProvider,
                                                        )
                                                        .userData
                                                    as FiestarUserModel?)
                                                ?.nationality
                                                ?.last ==
                                            e;
                                        return Text(
                                          "${"utils.language.${e!}".tr()}${isLast ? "" : ", "}",
                                          style: AppTextStyle.darkGray(11),
                                        );
                                      })
                                      .toList() ??
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
                                  (ref
                                              .watch(userChangeNotifierProvider)
                                              .userData
                                          as FiestarUserModel?)
                                      ?.languages
                                      ?.map((e) {
                                        final isLast =
                                            (ref
                                                        .read(
                                                          userChangeNotifierProvider,
                                                        )
                                                        .userData
                                                    as FiestarUserModel?)
                                                ?.languages
                                                ?.last ==
                                            e;
                                        return Text(
                                          "${"utils.language.${e!}".tr()}${isLast ? "" : ", "}",
                                          style: AppTextStyle.darkGray(11),
                                        );
                                      })
                                      .toList() ??
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
                    if ((ref.watch(userChangeNotifierProvider).userData
                                as FiestarUserModel?)
                            ?.isHost ??
                        false) {
                      final fiestas = ref
                          .watch(userFiestaProvider)
                          .createdFiesta;

                      if ((fiestas?.length ?? 0) > 0) {
                        return _buildCreatedFiestaList(fiestas);
                      }
                      return SizedBox(
                        width: double.infinity,
                        child: _buildFiestaSection(
                          title: "app.no-fiesta-created".tr(),
                          message: "app.create-first-fiesta".tr(),
                          textButton: "app.create-first-fiesta-button".tr(),
                          onTap: () {
                            AutoRouter.of(
                              context,
                            ).navigateNamed("/dashboard/fiesta/form");
                          },
                        ),
                      );
                    }
                    return _buildFiestaSection(
                      title: "app.not-host".tr(),
                      message: "app.not-host-desc".tr(),
                      textButton: "app.became-host".tr(),
                      onTap: () {
                        AutoRouter.of(
                          context,
                        ).navigateNamed("/dashboard/host/form");
                      },
                    );
                  } else {
                    final fiestas = ref
                        .watch(userFiestaProvider)
                        .userFiestaParticipatedList;

                    if ((fiestas?.length ?? 0) > 0) {
                      return _buildParticipedFiestaList(fiestas);
                    }
                    return Center(
                      child: _buildFiestaSection(
                        title: "utils.warning".tr(),
                        message: "app.no-participated-desc".tr(),
                        textButton: "app.swipe-fiesta".tr(),
                        onTap: () {
                          // Naviguer vers la page des événements (index 2)
                          ref.read(homeControllerProvider).jumpToPage(2);

                          // Mettre à jour le bottom navigation bar pour afficher l'index 2 comme actif
                          // et remettre l'icône de l'index 4 (profil) par défaut
                          ref
                                  .read(bottomNavigationIndexProvider.notifier)
                                  .state =
                              2;
                        },
                      ),
                    );
                  }
                },
              ),
              sh(20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLevelButton(BuildContext context) {
    return InkWell(
      onTap: () => AutoRouter.of(context).navigateNamed("/dashboard/leveling"),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          !((ref.watch(userChangeNotifierProvider).userData
                          as FiestarUserModel?)
                      ?.superHost ??
                  false)
              ? ClipRRect(
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
                            "assets/svg/ic_${(ref.watch(userChangeNotifierProvider).userData as FiestarUserModel?)?.superHost ?? false ? "super_star" : "crown"}.svg",
                            width: formatWidth(16),
                          ),
                          sw(5),
                          Text(
                            "${(ref.watch(userChangeNotifierProvider).userData as FiestarUserModel?)?.superHost ?? false ? "Super Host - " : ""} ${"utils.lvl".tr()}. ${(ref.watch(userChangeNotifierProvider).userData as FiestarUserModel?)?.level?.toInt() ?? 1}",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: formatHeight(12),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              : Container(
                  height: formatHeight(25),
                  padding: EdgeInsets.symmetric(
                    horizontal: formatWidth(8),
                    vertical: formatHeight(2),
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(formatWidth(50)),
                    gradient: AppColor.mainGradient,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgPicture.asset(
                        "assets/svg/ic_${(ref.watch(userChangeNotifierProvider).userData as FiestarUserModel?)?.superHost ?? false ? "super_star" : "crown"}.svg",
                        width: formatWidth(16),
                      ),
                      sw(5),
                      Text(
                        "${(ref.watch(userChangeNotifierProvider).userData as FiestarUserModel?)?.superHost ?? false ? "Super Host - " : ""} ${"utils.lvl".tr()}. ${(ref.watch(userChangeNotifierProvider).userData as FiestarUserModel?)?.level?.toInt() ?? 1}",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: formatHeight(12),
                        ),
                      ),
                    ],
                  ),
                ),
        ],
      ),
    );
  }

  Widget _buildPrincipalData(BuildContext context) {
    return Stack(
      children: [
        // Contenu principal centré
        Center(
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
                        child:
                            ref
                                    .watch(userChangeNotifierProvider)
                                    .userData
                                    ?.profilImage !=
                                null
                            ? CachedNetworkImage(
                                imageUrl:
                                    ref
                                        .watch(userChangeNotifierProvider)
                                        .userData
                                        ?.profilImage ??
                                    '',
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
                              )
                            : Container(
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
                "${ref.watch(userChangeNotifierProvider).userData?.firstname ?? ""} ${ref.watch(userChangeNotifierProvider).userData?.lastname ?? ""}",
                style: AppTextStyle.darkBlue(28, FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
        // Boutons positionnés de manière absolue
        Positioned(
          top: formatHeight(10),
          right: 0,
          child: Column(
            children: [
              Button(
                width: formatWidth(48),
                height: formatWidth(48),
                decoration: BoxDecoration(
                  gradient: AppColor.mainGradient,
                  borderRadius: BorderRadius.circular(formatWidth(50)),
                ),
                child: SvgPicture.asset(
                  "assets/svg/ic_settings.svg",
                  height: formatHeight(22),
                  colorFilter: ColorFilter.mode(Colors.white, BlendMode.srcIn),
                ),
                onTap: () => AutoRouter.of(
                  context,
                ).navigateNamed("/dashboard/profile/settings"),
              ),
              sh(8),
              Button(
                width: formatWidth(48),
                height: formatWidth(48),
                decoration: BoxDecoration(
                  color: const Color(0xFFFEECE5),
                  borderRadius: BorderRadius.circular(formatWidth(50)),
                ),
                child: SvgPicture.asset(
                  "assets/svg/ic_edit.svg",
                  height: formatHeight(22),
                  colorFilter: ColorFilter.mode(
                    AppColor.mainColor,
                    BlendMode.srcIn,
                  ),
                ),
                onTap: () => AutoRouter.of(
                  context,
                ).navigateNamed("/dashboard/profile/settings/personnnal"),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPassion(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.center,
      spacing: formatWidth(9),
      runSpacing: formatWidth(9),
      children:
          (transformPassionInTags(
                (ref.watch(userChangeNotifierProvider).userData
                            as FiestarUserModel?)
                        ?.favorite ??
                    const PassionListing(),
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

  Widget _buildSignaletmentBox(BuildContext context) {
    if (((ref.watch(userChangeNotifierProvider).userData as FiestarUserModel?)
                ?.reportPoint ??
            0) <
        50) {
      return const SizedBox();
    }
    final isRedFlag =
        ((ref.watch(userChangeNotifierProvider).userData as FiestarUserModel?)
                ?.reportPoint ??
            0) >=
        100;
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
            colorFilter: ColorFilter.mode(Colors.white, BlendMode.srcIn),
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

  Widget _buildFiestData(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: formatWidth(22)),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          Expanded(
            child: Column(
              children: [
                Text(
                  ((ref.watch(userChangeNotifierProvider).userData
                                  as FiestarUserModel?)
                              ?.numberFiestaCreated
                              ?.toInt() ??
                          0)
                      .toString(),
                  style: AppTextStyle.darkGray(16, FontWeight.w600),
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
                Text(
                  ((ref.watch(userChangeNotifierProvider).userData
                                  as FiestarUserModel?)
                              ?.numberFiesta
                              ?.toInt() ??
                          0)
                      .toString(),
                  style: AppTextStyle.darkGray(16, FontWeight.w600),
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

  Widget _buildFiestaSection({
    required String title,
    required String message,
    required String textButton,
    required Function onTap,
  }) {
    return Column(
      children: [
        Text(
          title,
          style: AppTextStyle.black(19, FontWeight.w600),
          textAlign: TextAlign.center,
        ),
        sh(9),
        Text(
          message,
          style: AppTextStyle.gray(11, FontWeight.w500),
          textAlign: TextAlign.center,
        ),
        sh(25),
        CTA.primary(
          textButton: textButton,
          onTap: onTap,
          width: formatWidth(208),
        ),
      ],
    );
  }

  Widget _buildCreatedFiestaList(List<UserFiestaModel>? fiestas) {
    return SizedBox(
      width: double.infinity,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CTA.primary(
            width: double.infinity,
            onTap: () {
              AutoRouter.of(context).navigateNamed("/dashboard/fiesta/form");
            },
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.add_rounded,
                  color: Colors.white,
                  size: formatWidth(30),
                ),
                sw(5),
                Text(
                  "app.create-first-fiesta-button".tr(),
                  style: AppTextStyle.white(14, FontWeight.w600),
                ),
              ],
            ),
          ),
          sh(19),
          SizedBox(
            width: double.infinity,
            child: Text(
              "Mes fiestas créées (${fiestas?.length ?? 0})",
              style: AppTextStyle.black(15),
            ),
          ),
          sh(16),
          SizedBox(
            width: double.infinity,
            child: Wrap(
              alignment: WrapAlignment.start,
              runSpacing: formatWidth(10),
              spacing: formatWidth(10),
              children:
                  fiestas
                      ?.map(
                        (e) => InkWell(
                          onTap: () => AutoRouter.of(context).navigateNamed(
                            "/dashboard/fiesta/detail/${e.fiestaId!}",
                          ),
                          child: DataCardWidget(
                            width: formatWidth(156),
                            tag: Container(
                              padding: EdgeInsets.all(formatWidth(6)),
                              decoration: BoxDecoration(
                                color: AppColor.mainColor,
                                borderRadius: BorderRadius.circular(
                                  formatWidth(50),
                                ),
                              ),
                              child: Text(
                                "${e.startAt?.day.toString().padLeft(2, "0")}.${e.startAt?.month.toString().padLeft(2, "0")}.${e.startAt?.year} ${e.startAt?.month.toString().padLeft(2, "0")}:${e.startAt?.minute.toString().padLeft(2, "0")}",
                                style: AppTextStyle.white(7, FontWeight.w500),
                              ),
                            ),
                            widthImage: formatWidth(156),
                            heightImage: formatHeight(96),
                            image: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: CachedNetworkImage(
                                imageUrl: e.pictures!.first,
                                fit: BoxFit.cover,
                              ),
                            ),
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                vertical: formatHeight(10),
                                horizontal: formatWidth(17),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
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
                                  if (e.startAt!.isAfter(DateTime.now())) ...[
                                    sh(11),
                                    CTA.primary(
                                      height: formatHeight(30),
                                      textButton: "app.handle-duo".tr(),
                                      textButtonStyle: AppTextStyle.white(
                                        11,
                                        FontWeight.w600,
                                      ),
                                      onTap: () {
                                        AutoRouter.of(context).navigate(
                                          FiestaHandleDuoRoute(
                                            fiestaId: e.fiestaId!,
                                          ),
                                        );
                                      },
                                    ),
                                  ],
                                ],
                              ),
                            ),
                          ),
                        ),
                      )
                      .toList() ??
                  [],
            ),
          ),
          sh(12),
        ],
      ),
    );
  }

  Widget _buildParticipedFiestaList(List<UserFiestaModel>? fiestas) {
    return SizedBox(
      width: double.infinity,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // sh(22.5),
          // SelectForm<String>(
          //   fieldName: "app.participated-tri".tr(),
          //   hintText: "utils.all".tr(),
          //   items: [
          //     DropdownMenuItem<String>(value: "next", child: const Text("Prochaines participations")),
          //     DropdownMenuItem<String>(value: "waiting", child: const Text("à")),
          //     DropdownMenuItem<String>(value: "old", child: const Text("Prochaines participations")),
          //   ],
          // ),
          sh(19),
          SizedBox(
            width: double.infinity,
            child: Text(
              "Mes participations (${fiestas?.length ?? 0})",
              style: AppTextStyle.black(15),
            ),
          ),
          sh(16),
          SizedBox(
            width: double.infinity,
            child: Wrap(
              alignment: WrapAlignment.start,
              runSpacing: formatWidth(10),
              spacing: formatWidth(10),
              children:
                  fiestas
                      ?.map(
                        (e) => InkWell(
                          onTap: () => AutoRouter.of(context).navigateNamed(
                            "/dashboard/fiesta/detail/${e.fiestaId!}",
                          ),
                          child: DataCardWidget(
                            width: formatWidth(156),
                            tag: Container(
                              padding: EdgeInsets.all(formatWidth(6)),
                              decoration: BoxDecoration(
                                color: AppColor.mainColor,
                                borderRadius: BorderRadius.circular(
                                  formatWidth(50),
                                ),
                              ),
                              child: Text(
                                "${e.startAt?.day.toString().padLeft(2, "0")}.${e.startAt?.month.toString().padLeft(2, "0")}.${e.startAt?.year} ${e.startAt?.month.toString().padLeft(2, "0")}:${e.startAt?.minute.toString().padLeft(2, "0")}",
                                style: AppTextStyle.white(7, FontWeight.w500),
                              ),
                            ),
                            widthImage: formatWidth(156),
                            heightImage: formatHeight(96),
                            image: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: CachedNetworkImage(
                                imageUrl: e.pictures!.first,
                                fit: BoxFit.cover,
                              ),
                            ),
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                vertical: formatHeight(10),
                                horizontal: formatWidth(17),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
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
                        ),
                      )
                      .toList() ??
                  [],
            ),
          ),
          sh(12),
        ],
      ),
    );
  }
}
