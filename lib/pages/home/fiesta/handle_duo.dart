import 'package:auto_route/auto_route.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:core_kosmos/core_package.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:twogather/controller/fiesta_controller.dart';
import 'package:twogather/controller/recommandation_controller.dart';
import 'package:twogather/model/color.dart';
import 'package:twogather/model/fiesta/fiesta_model.dart';
import 'package:twogather/model/user/app_user/app_user_model.dart';
import 'package:twogather/widgets/button/core.dart';
import 'package:twogather/widgets/toggle_swicth/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ui_kosmos_v4/ui_kosmos_v4.dart';

@RoutePage()
class FiestaHandleDuoPage extends StatefulHookConsumerWidget {
  final String fiestaId;
  final FiestaModel? data;

  const FiestaHandleDuoPage({
    super.key,
    @PathParam("id") required this.fiestaId,
    this.data,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _FiestaHandleDuoPageState();
}

class _FiestaHandleDuoPageState extends ConsumerState<FiestaHandleDuoPage> {
  final ValueNotifier<int> _page = ValueNotifier(0);
  FiestaModel? data;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    printInDebug("rebuild and data is $data");
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: Colors.white,
      child: SafeArea(
        bottom: false,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            sh(12),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: formatWidth(22)),
              child: SizedBox(
                height: formatHeight(35),
                width: double.infinity,
                child: Stack(
                  children: [
                    Center(
                      child: Text(
                        "Participants".tr(),
                        style: AppTextStyle.black(17),
                      ),
                    ),
                    Positioned(
                      top: 0,
                      left: 0,
                      bottom: 0,
                      child: InkWell(
                        onTap: () => AutoRouter.of(context).back(),
                        child: Icon(
                          Icons.arrow_back_ios_new_rounded,
                          color: Colors.black,
                          size: formatWidth(18),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 0,
                      right: 0,
                      bottom: 0,
                      child: InkWell(
                        onTap: () => AutoRouter.of(context).navigateNamed(
                          "/dashboard/fiesta/detail/${widget.fiestaId}",
                        ),
                        child: SvgPicture.asset(
                          "assets/svg/ic_info.svg",
                          colorFilter: ColorFilter.mode(
                            AppColor.mainColor,
                            BlendMode.srcIn,
                          ),
                          width: formatWidth(18),
                          height: formatWidth(18),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            sh(21),
            if (data != null)
              FutureBuilder(
                future: FiestaController.getAppUserFromListOfParticipants(
                  widget.data!,
                ),
                builder: (_, AsyncSnapshot<List<AppUserModel>> snap) {
                  if (snap.hasData && snap.data != null) {
                    return Expanded(
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _infoBox(context, widget.data!, snap.data!),
                          sh(28),
                          Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: formatWidth(22),
                            ),
                            child: ToggleSwicth(
                              height: formatHeight(41),
                              activeGradient: AppColor.mainGradient,
                              items: [
                                ToggleItem(
                                  label: "Demandes",
                                  onTap: () => _page.value = 0,
                                ),
                                ToggleItem(
                                  label: "En attentes",
                                  onTap: () => _page.value = 1,
                                ),
                                ToggleItem(
                                  label: "Participants",
                                  onTap: () => _page.value = 2,
                                ),
                              ],
                            ),
                          ),
                          sh(21),
                          Expanded(
                            child: SingleChildScrollView(
                              physics: const BouncingScrollPhysics(),
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: formatWidth(22),
                                ),
                                child: _drawRequest(
                                  context,
                                  widget.data!,
                                  snap.data!,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  return const SizedBox();
                },
              )
            else
              FutureBuilder(
                future: FirebaseFirestore.instance
                    .collection("fiesta")
                    .doc(widget.fiestaId)
                    .get()
                    .then(
                      (value) => FiestaModel.fromJson(
                        value.data()!,
                      ).copyWith(id: value.id),
                    ),
                builder: (_, AsyncSnapshot<FiestaModel> snapshot) {
                  if (snapshot.hasData && snapshot.data != null) {
                    return FutureBuilder(
                      future: FiestaController.getAppUserFromListOfParticipants(
                        snapshot.data!,
                      ),
                      builder: (_, AsyncSnapshot<List<AppUserModel>> snap) {
                        if (snap.hasData && snap.data != null) {
                          return Expanded(
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _infoBox(context, snapshot.data!, snap.data!),
                                sh(28),
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: formatWidth(22),
                                  ),
                                  child: ToggleSwicth(
                                    height: formatHeight(41),
                                    activeGradient: AppColor.mainGradient,
                                    items: [
                                      ToggleItem(
                                        label: "Demandes",
                                        onTap: () => _page.value = 0,
                                      ),
                                      ToggleItem(
                                        label: "En attentes",
                                        onTap: () => _page.value = 1,
                                      ),
                                      ToggleItem(
                                        label: "Participants",
                                        onTap: () => _page.value = 2,
                                      ),
                                    ],
                                  ),
                                ),
                                sh(21),
                                Expanded(
                                  child: SingleChildScrollView(
                                    physics: const BouncingScrollPhysics(),
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: formatWidth(22),
                                      ),
                                      child: _drawRequest(
                                        context,
                                        snapshot.data!,
                                        snap.data!,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }

                        return const SizedBox();
                      },
                    );
                  }
                  return const Expanded(
                    child: Center(child: LoaderClassique()),
                  );
                },
              ),
            sh(30),
          ],
        ),
      ),
    );
  }

  Widget _infoBox(
    BuildContext context,
    FiestaModel data,
    List<AppUserModel> users,
  ) {
    int percentMen = 0;
    int percentWomen = 0;
    int percentOther = 0;

    if (users.isNotEmpty) {
      percentMen =
          ((users.where((element) => element.gender == "men").length /
                      users.length) *
                  100)
              .toInt();
      percentWomen =
          ((users.where((element) => element.gender == "woman").length /
                      users.length) *
                  100)
              .toInt();
      percentOther =
          ((users.where((element) => element.gender == "other").length /
                      users.length) *
                  100)
              .toInt();
    }

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: formatWidth(22)),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(
          horizontal: formatWidth(17),
          vertical: formatHeight(16),
        ),
        decoration: BoxDecoration(
          color: const Color(0xFFF5F5F5).withValues(alpha: .67),
          borderRadius: BorderRadius.circular(7),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: double.infinity,
              height: 4,
              child: Stack(
                children: [
                  Container(
                    height: 4,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: AppColor.mainColor.withValues(alpha: .19),
                    ),
                  ),
                  LayoutBuilder(
                    builder: (_, c) {
                      final percentWidth =
                          (c.maxWidth / data.numberOfParticipant!) *
                          _countNulberOfUser(data.participants);
                      return Container(
                        height: 4,
                        width: percentWidth,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: AppColor.mainColor,
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            sh(6.5),
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "${_countNulberOfUser(data.participants)} Participants".tr(),
                  style: AppTextStyle.gray(12),
                ),
                Text(
                  "${data.numberOfParticipant?.toInt()} max.",
                  style: AppTextStyle.gray(12),
                ),
              ],
            ),
            sh(12),
            SizedBox(
              width: double.infinity,
              height: 4,
              child: Stack(
                children: [
                  Container(
                    height: 4,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: AppColor.mainColor.withValues(alpha: .19),
                    ),
                  ),
                  LayoutBuilder(
                    builder: (_, c) {
                      return Container(
                        height: 4,
                        width:
                            (percentOther + percentWomen + percentMen) /
                            100 *
                            c.maxWidth,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: const Color(0xFF6ECDFF),
                        ),
                      );
                    },
                  ),
                  LayoutBuilder(
                    builder: (_, c) {
                      return Container(
                        height: 4,
                        width: (percentWomen + percentWomen) / 100 * c.maxWidth,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: const Color(0xFF0F6893),
                        ),
                      );
                    },
                  ),
                  LayoutBuilder(
                    builder: (_, c) {
                      return Container(
                        height: 4,
                        width: percentMen / 100 * c.maxWidth,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: const Color(0xFF02132B),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            sh(6.5),
            Text(
              "$percentMen% Hommes - $percentWomen% Femmes - $percentOther% Autres"
                  .tr(),
              style: AppTextStyle.gray(12),
            ),
          ],
        ),
      ),
    );
  }

  Widget _drawRequest(
    BuildContext context,
    FiestaModel fiestaModel,
    List<AppUserModel> list,
  ) {
    return ValueListenableBuilder(
      valueListenable: _page,
      builder: (context, int page, child) {
        if (page == 0) {
          // Vérifier que participants n'est pas null avant d'utiliser l'opérateur !
          if (fiestaModel.participants == null) {
            return const Column();
          }

          final pendingDuo = fiestaModel.participants!
              .where((element) => element.status == "pending")
              .toList();
          if (pendingDuo.isEmpty) {
            return const Column();
          }
          return Column(
            children: pendingDuo.map((e) {
              final firstUser = list.firstWhere(
                (element) => element.id == e.fiestaRef,
              );
              final duoUser = list.firstWhere(
                (element) => element.id == e.duoRef,
              );
              return Padding(
                padding: EdgeInsets.only(bottom: formatHeight(12)),
                child: Slidable(
                  endActionPane: ActionPane(
                    motion: const BehindMotion(),
                    children: [
                      Expanded(
                        child: Builder(
                          builder: (con) {
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Button(
                                  width: formatWidth(45),
                                  height: formatWidth(45),
                                  decoration: BoxDecoration(
                                    color: AppColor.mainColor,
                                    borderRadius: BorderRadius.circular(100),
                                  ),
                                  child: const Center(
                                    child: Icon(
                                      Icons.check_rounded,
                                      color: Colors.white,
                                    ),
                                  ),
                                  onTap: () async {
                                    Slidable.of(con)!.close(
                                      duration: const Duration(
                                        milliseconds: 300,
                                      ),
                                    );
                                    await FiestaController.acceptUserInFiesta(
                                      widget.fiestaId,
                                      firstUser.id!,
                                      duoUser.id!,
                                    );
                                    execAfterBuild(
                                      () => setState(() => data = null),
                                    );
                                  },
                                ),
                                sw(9),
                                Button(
                                  width: formatWidth(45),
                                  height: formatWidth(45),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFEB5353),
                                    borderRadius: BorderRadius.circular(100),
                                  ),
                                  child: const Center(
                                    child: Icon(
                                      Icons.close_rounded,
                                      color: Colors.white,
                                    ),
                                  ),
                                  onTap: () async {
                                    Slidable.of(con)!.close(
                                      duration: const Duration(
                                        milliseconds: 300,
                                      ),
                                    );
                                    await FiestaController.refuseUserInFiesta(
                                      widget.fiestaId,
                                      firstUser.id!,
                                      duoUser.id!,
                                    );
                                    execAfterBuild(
                                      () => setState(() => data = null),
                                    );
                                  },
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(
                      horizontal: formatWidth(13),
                      vertical: formatHeight(12),
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF5F5F5).withValues(alpha: .67),
                      borderRadius: BorderRadius.circular(7),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        SizedBox(
                          width: formatWidth(63),
                          height: formatWidth(37),
                          child: Stack(
                            children: [
                              Container(
                                width: formatWidth(37),
                                height: formatWidth(37),
                                decoration: BoxDecoration(
                                  color: AppColor.mainColor.withValues(
                                    alpha: .19,
                                  ),
                                  borderRadius: BorderRadius.circular(100),
                                  border: Border.all(
                                    color: AppColor.mainColor,
                                    width: 2,
                                  ),
                                ),
                                clipBehavior: Clip.hardEdge,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(100),
                                  child: CachedNetworkImage(
                                    imageUrl: firstUser.pictures!.first,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              Positioned(
                                right: 0,
                                child: Container(
                                  width: formatWidth(37),
                                  height: formatWidth(37),
                                  decoration: BoxDecoration(
                                    color: AppColor.mainColor.withValues(
                                      alpha: .19,
                                    ),
                                    borderRadius: BorderRadius.circular(100),
                                    border: Border.all(
                                      color: AppColor.mainColor,
                                      width: 2,
                                    ),
                                  ),
                                  clipBehavior: Clip.hardEdge,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(100),
                                    child: CachedNetworkImage(
                                      imageUrl: duoUser.pictures!.first,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        sw(17),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "${firstUser.firstname} et ${duoUser.firstname}",
                                style: AppTextStyle.darkBlue(
                                  13,
                                  FontWeight.w500,
                                ),
                              ),
                              Text(
                                "Swipe pour gérer le duo",
                                style: AppTextStyle.gray(12),
                              ),
                            ],
                          ),
                        ),
                        sw(17),
                        Container(
                          width: formatWidth(23),
                          height: formatWidth(23),
                          decoration: BoxDecoration(
                            color: AppColor.mainColor.withValues(alpha: .19),
                            borderRadius: BorderRadius.circular(100),
                          ),
                          child: Center(
                            child: SvgPicture.asset(
                              "assets/svg/ic_lock.svg",
                              colorFilter: ColorFilter.mode(
                                AppColor.mainColor,
                                BlendMode.srcIn,
                              ),
                              width: formatWidth(8),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
          );
        } else if (page == 1) {
          // Vérifier que participants n'est pas null avant d'utiliser l'opérateur !
          if (fiestaModel.participants == null) {
            return const Column();
          }

          final waitingDuo = fiestaModel.participants!
              .where((element) => element.status == "waiting")
              .toList();
          if (waitingDuo.isEmpty) {
            return const Column();
          }
          return Column(
            children: waitingDuo.map((e) {
              final firstUser = list.firstWhere(
                (element) => element.id == e.fiestaRef,
              );
              AppUserModel? duoUser;
              if (e.duoRef != null) {
                duoUser = list.firstWhere((element) => element.id == e.duoRef);
              }
              return Padding(
                padding: EdgeInsets.only(bottom: formatHeight(12)),
                child: Slidable(
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(
                      horizontal: formatWidth(13),
                      vertical: formatHeight(12),
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF5F5F5).withValues(alpha: .67),
                      borderRadius: BorderRadius.circular(7),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        SizedBox(
                          width: formatWidth(63),
                          height: formatWidth(37),
                          child: Stack(
                            children: [
                              Container(
                                width: formatWidth(37),
                                height: formatWidth(37),
                                decoration: BoxDecoration(
                                  color: AppColor.mainColor.withValues(
                                    alpha: .19,
                                  ),
                                  borderRadius: BorderRadius.circular(100),
                                  border: Border.all(
                                    color: AppColor.mainColor,
                                    width: 2,
                                  ),
                                ),
                                clipBehavior: Clip.hardEdge,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(100),
                                  child: CachedNetworkImage(
                                    imageUrl: firstUser.pictures!.first,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              if (duoUser != null)
                                Positioned(
                                  right: 0,
                                  child: Container(
                                    width: formatWidth(37),
                                    height: formatWidth(37),
                                    decoration: BoxDecoration(
                                      color: AppColor.mainColor.withValues(
                                        alpha: .19,
                                      ),
                                      borderRadius: BorderRadius.circular(100),
                                      border: Border.all(
                                        color: AppColor.mainColor,
                                        width: 2,
                                      ),
                                    ),
                                    clipBehavior: Clip.hardEdge,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(100),
                                      child: CachedNetworkImage(
                                        imageUrl: duoUser.pictures!.first,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                        sw(17),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "${firstUser.firstname} ${duoUser != null ? "et ${duoUser.firstname}" : ""}",
                                style: AppTextStyle.darkBlue(
                                  13,
                                  FontWeight.w500,
                                ),
                              ),
                              Text(
                                "En attente de confirmation du duo.",
                                style: AppTextStyle.gray(12),
                              ),
                            ],
                          ),
                        ),
                        sw(17),
                        Container(
                          width: formatWidth(23),
                          height: formatWidth(23),
                          decoration: BoxDecoration(
                            color: AppColor.mainColor.withValues(alpha: .19),
                            borderRadius: BorderRadius.circular(100),
                          ),
                          child: Center(
                            child: SvgPicture.asset(
                              "assets/svg/ic_lock.svg",
                              colorFilter: ColorFilter.mode(
                                AppColor.mainColor,
                                BlendMode.srcIn,
                              ),
                              width: formatWidth(8),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
          );
        } else if (page == 2) {
          // Vérifier que participants n'est pas null avant d'utiliser l'opérateur !
          if (fiestaModel.participants == null) {
            return const Column();
          }

          final acceptedDuo = fiestaModel.participants!
              .where((element) => element.status == "accepted")
              .toList();
          if (acceptedDuo.isEmpty) {
            return const Column();
          }
          return Column(
            children: acceptedDuo.map((e) {
              final firstUser = list.firstWhere(
                (element) => element.id == e.fiestaRef,
              );
              final duoUser = list.firstWhere(
                (element) => element.id == e.duoRef,
              );
              return Padding(
                padding: EdgeInsets.only(bottom: formatHeight(12)),
                child: Slidable(
                  endActionPane: ActionPane(
                    extentRatio: .7,
                    motion: const BehindMotion(),
                    children: [
                      Expanded(
                        child: Builder(
                          builder: (con) {
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Button(
                                  width: formatWidth(45),
                                  height: formatWidth(45),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFF6F6F6),
                                    borderRadius: BorderRadius.circular(100),
                                  ),
                                  child: Center(
                                    child: SvgPicture.asset(
                                      "assets/svg/ic_report.svg",
                                      colorFilter: const ColorFilter.mode(
                                        Colors.black,
                                        BlendMode.srcIn,
                                      ),
                                    ),
                                  ),
                                  onTap: () async {
                                    Slidable.of(con)!.close(
                                      duration: const Duration(
                                        milliseconds: 300,
                                      ),
                                    );
                                    AutoRouter.of(context).navigateNamed(
                                      "/dashboard/report/$firstUser",
                                    ); //?subUser=$duoUser
                                  },
                                ),
                                sw(9),
                                if (data?.isEnd ?? false) ...[
                                  Button(
                                    width: formatWidth(45),
                                    height: formatWidth(45),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFF6F6F6),
                                      borderRadius: BorderRadius.circular(100),
                                    ),
                                    child: Center(
                                      child: SvgPicture.asset(
                                        "assets/svg/ic_reco.svg",
                                        colorFilter: const ColorFilter.mode(
                                          Colors.black,
                                          BlendMode.srcIn,
                                        ),
                                        width: formatWidth(27),
                                      ),
                                    ),
                                    onTap: () async {
                                      Slidable.of(con)!.close(
                                        duration: const Duration(
                                          milliseconds: 300,
                                        ),
                                      );
                                      RecommandationController.recommandAGroup(
                                        firstUser.id!,
                                        duoUser.id!,
                                      );
                                      NotifBanner.showToast(
                                        context: context,
                                        fToast: FToast().init(context),
                                        title: "Merci",
                                        subTitle:
                                            "votre recommandation de ${firstUser.firstname} et ${duoUser.firstname} a bien été prise en compte",
                                        backgroundColor: const Color(
                                          0xFF0ACC73,
                                        ),
                                      );
                                    },
                                  ),
                                  sw(9),
                                ],
                                Button(
                                  width: formatWidth(45),
                                  height: formatWidth(45),
                                  decoration: BoxDecoration(
                                    color: AppColor.mainColor,
                                    borderRadius: BorderRadius.circular(100),
                                  ),
                                  child: Center(
                                    child: SvgPicture.asset(
                                      "assets/svg/ic_message.svg",
                                      colorFilter: const ColorFilter.mode(
                                        Colors.white,
                                        BlendMode.srcIn,
                                      ),
                                      width: formatWidth(24),
                                    ),
                                  ),
                                  onTap: () async {
                                    Slidable.of(con)!.close(
                                      duration: const Duration(
                                        milliseconds: 300,
                                      ),
                                    );
                                    // await FiestaController.acceptUserInFiesta(widget.fiestaId, firstUser.id!, duoUser.id!);
                                    execAfterBuild(
                                      () => setState(() => data = null),
                                    );
                                    // Navigation vers le chat avec le duo accepté
                                    AutoRouter.of(context).navigateNamed(
                                      "/dashboard/chat/${duoUser.id}",
                                    );
                                  },
                                ),
                                sw(9),
                                Button(
                                  width: formatWidth(45),
                                  height: formatWidth(45),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFEB5353),
                                    borderRadius: BorderRadius.circular(100),
                                  ),
                                  child: Center(
                                    child: SvgPicture.asset(
                                      "assets/svg/ic_delete.svg",
                                      colorFilter: const ColorFilter.mode(
                                        Colors.white,
                                        BlendMode.srcIn,
                                      ),
                                      width: formatWidth(24),
                                    ),
                                  ),
                                  onTap: () async {
                                    Slidable.of(con)!.close(
                                      duration: const Duration(
                                        milliseconds: 300,
                                      ),
                                    );
                                    await FiestaController.deleteUserInFiesta(
                                      widget.fiestaId,
                                      firstUser.id!,
                                      duoUser.id!,
                                    );
                                    execAfterBuild(
                                      () => setState(() => data = null),
                                    );
                                  },
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(
                      horizontal: formatWidth(13),
                      vertical: formatHeight(12),
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF5F5F5).withValues(alpha: .67),
                      borderRadius: BorderRadius.circular(7),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        SizedBox(
                          width: formatWidth(63),
                          height: formatWidth(37),
                          child: Stack(
                            children: [
                              InkWell(
                                onTap: () => AutoRouter.of(context).pushNamed(
                                  "/dashboard/user/profil/${firstUser.id}",
                                ),
                                child: Container(
                                  width: formatWidth(37),
                                  height: formatWidth(37),
                                  decoration: BoxDecoration(
                                    color: AppColor.mainColor.withValues(
                                      alpha: .19,
                                    ),
                                    borderRadius: BorderRadius.circular(100),
                                    border: Border.all(
                                      color: AppColor.mainColor,
                                      width: 2,
                                    ),
                                  ),
                                  clipBehavior: Clip.hardEdge,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(100),
                                    child: CachedNetworkImage(
                                      imageUrl: firstUser.pictures!.first,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                right: 0,
                                child: InkWell(
                                  onTap: () => AutoRouter.of(context).pushNamed(
                                    "/dashboard/user/profil/${duoUser.id}",
                                  ),
                                  child: Container(
                                    width: formatWidth(37),
                                    height: formatWidth(37),
                                    decoration: BoxDecoration(
                                      color: AppColor.mainColor.withValues(
                                        alpha: .19,
                                      ),
                                      borderRadius: BorderRadius.circular(100),
                                      border: Border.all(
                                        color: AppColor.mainColor,
                                        width: 2,
                                      ),
                                    ),
                                    clipBehavior: Clip.hardEdge,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(100),
                                      child: CachedNetworkImage(
                                        imageUrl: duoUser.pictures!.first,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        sw(17),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "${firstUser.firstname} et ${duoUser.firstname}",
                                style: AppTextStyle.darkBlue(
                                  13,
                                  FontWeight.w500,
                                ),
                              ),
                              Text("À rejoint", style: AppTextStyle.gray(12)),
                            ],
                          ),
                        ),
                        sw(17),
                        Container(
                          width: formatWidth(23),
                          height: formatWidth(23),
                          decoration: BoxDecoration(
                            color: AppColor.mainColor.withValues(alpha: .19),
                            borderRadius: BorderRadius.circular(100),
                          ),
                          child: Center(
                            child: SvgPicture.asset(
                              "assets/svg/ic_lock.svg",
                              colorFilter: ColorFilter.mode(
                                AppColor.mainColor,
                                BlendMode.srcIn,
                              ),
                              width: formatWidth(8),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
          );
        }
        return const SizedBox();
      },
    );
  }

  int _countNulberOfUser(List<FiestaUserModel>? participants) {
    int i = 0;
    for (final FiestaUserModel e in (participants?.toList() ?? [])) {
      if (e.duoRef != null) i++;
      if (e.fiestaRef != null) i++;
    }
    return i;
  }
}
