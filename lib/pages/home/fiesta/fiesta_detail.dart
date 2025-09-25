import 'package:auto_route/auto_route.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:core_kosmos/core_package.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:twogather/controller/fiesta_controller.dart';
import 'package:twogather/model/color.dart';
import 'package:twogather/model/fiesta/fiesta_model.dart';
import 'package:twogather/pages/home_page.dart';
import 'package:twogather/routes/app_router.dart';
import 'package:twogather/widgets/button/core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import "package:flutter/material.dart";
import 'package:flutter_svg/svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:ui_kosmos_v4/cta/cta.dart';
import 'package:ui_kosmos_v4/cta/theme.dart';
import 'package:ui_kosmos_v4/micro_element/micro_element.dart';

@RoutePage()
class FiestaDetailPage extends StatefulHookConsumerWidget {
  final String fiestaId;

  const FiestaDetailPage({super.key, @PathParam("id") required this.fiestaId});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _FiestaDetailPageState();
}

class _FiestaDetailPageState extends ConsumerState<FiestaDetailPage> {
  late final Future<FiestaModel> _fiestaFuture;

  final PageController _pageController = PageController();
  int page = 0;

  @override
  void initState() {
    _fiestaFuture = FirebaseFirestore.instance
        .collection("fiesta")
        .doc(widget.fiestaId)
        .get()
        .then(
          (value) => FiestaModel.fromJson(value.data()!).copyWith(id: value.id),
        );
    _pageController.addListener(() {
      setState(() {
        page = _pageController.page?.round() ?? 0;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: Colors.white,
      child: FutureBuilder(
        future: _fiestaFuture,
        builder: (_, AsyncSnapshot<FiestaModel> snap) {
          final isHost = snap.data != null
              ? FirebaseAuth.instance.currentUser?.uid == snap.data!.host!.id
              : false;
          if (snap.hasData && snap.data != null) {
            return Stack(
              children: [
                SlidingUpPanel(
                  minHeight: MediaQuery.of(context).size.height * .55,
                  maxHeight: MediaQuery.of(context).size.height * .85,
                  body: Column(
                    children: [
                      SizedBox(
                        width: double.infinity,
                        height: MediaQuery.of(context).size.height * .6,
                        child: PageView(
                          controller: _pageController,
                          children: [
                            ...snap.data!.pictures?.map(
                                  (e) => CachedNetworkImage(
                                    imageUrl: e,
                                    fit: BoxFit.cover,
                                    width: double.infinity,
                                    height:
                                        MediaQuery.of(context).size.height * .8,
                                  ),
                                ) ??
                                [],
                          ],
                        ),
                      ),
                    ],
                  ),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(40),
                    topRight: Radius.circular(40),
                  ),
                  panelBuilder: (sc) {
                    return SingleChildScrollView(
                      controller: sc,
                      physics: const BouncingScrollPhysics(),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: formatWidth(30),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            sh(12.4),
                            Center(
                              child: Container(
                                width: formatWidth(40),
                                height: formatHeight(5),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFDDDFE2),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                            sh(15.6),
                            Text(
                              snap.data!.title ?? "",
                              style: AppTextStyle.black(23, FontWeight.bold),
                            ),
                            sh(6.6),
                            Row(
                              children: [
                                SvgPicture.asset(
                                  "assets/svg/ic_location_outlined.svg",
                                  colorFilter: const ColorFilter.mode(
                                    Color(0xFF5A6575),
                                    BlendMode.srcIn,
                                  ),
                                ),
                                sw(3),
                                Text(
                                  snap.data!.address?.geopoint != null &&
                                          ref
                                                  .watch(geolocProvider)
                                                  .userPosition !=
                                              null
                                      ? "${(Geolocator.distanceBetween(snap.data!.address!.geopoint!.latitude, snap.data!.address!.geopoint!.longitude, ref.watch(geolocProvider).userPosition!.latitude, ref.watch(geolocProvider).userPosition!.longitude) / 1000).round()}km"
                                      : "",
                                  style: TextStyle(
                                    color: const Color(0xFF5A6575),
                                    fontSize: sp(13),
                                  ),
                                ),
                                sw(3),
                                SvgPicture.asset(
                                  "assets/svg/ic_point.svg",
                                  colorFilter: const ColorFilter.mode(
                                    Color(0xFF5A6575),
                                    BlendMode.srcIn,
                                  ),
                                ),
                                sw(3),
                                SvgPicture.asset(
                                  "assets/svg/ic_human.svg",
                                  colorFilter: const ColorFilter.mode(
                                    Color(0xFF5A6575),
                                    BlendMode.srcIn,
                                  ),
                                ),
                                sw(3),
                                Text(
                                  "${(snap.data!.participants?.where((element) => element.status == "accepted").toList() ?? []).length * 2} / ${snap.data!.numberOfParticipant?.toInt() ?? 0} participants",
                                  style: TextStyle(
                                    color: const Color(0xFF5A6575),
                                    fontSize: sp(13),
                                  ),
                                ),
                                sw(3),
                              ],
                            ),
                            sh(3),
                            Row(
                              children: [
                                SvgPicture.asset(
                                  "assets/svg/ic_sound.svg",
                                  colorFilter: const ColorFilter.mode(
                                    Color(0xFF5A6575),
                                    BlendMode.srcIn,
                                  ),
                                ),
                                sw(3),
                                Text(
                                  "utils.sound.${(snap.data!.soundLevel ?? 1).toInt()}"
                                      .tr(),
                                  style: TextStyle(
                                    color: const Color(0xFF5A6575),
                                    fontSize: sp(13),
                                  ),
                                ),
                              ],
                            ),
                            sh(20),
                            const Divider(),
                            sh(11.5),
                            Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: Text(
                                    "Type de Fiesta",
                                    style: AppTextStyle.black(
                                      15,
                                      FontWeight.bold,
                                    ),
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: formatWidth(22),
                                    vertical: formatHeight(9),
                                  ),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(100),
                                    border: Border.all(
                                      color: AppColor.mainColor,
                                      width: 1,
                                    ),
                                  ),
                                  child: Text(
                                    "app.tags.fiesta.${snap.data!.category}"
                                        .tr(),
                                    style: AppTextStyle.mainColor(
                                      15,
                                      FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Text(
                              "Tags",
                              style: AppTextStyle.gray(12, FontWeight.w400),
                            ),
                            sh(4.5),
                            Wrap(
                              spacing: formatWidth(8),
                              runSpacing: formatHeight(8),
                              children:
                                  snap.data!.tags
                                      ?.map(
                                        (e) => Container(
                                          padding: EdgeInsets.symmetric(
                                            horizontal: formatWidth(12),
                                            vertical: formatHeight(5),
                                          ),
                                          constraints: BoxConstraints(
                                            maxWidth: formatWidth(110),
                                          ),
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(
                                              100,
                                            ),
                                            border: Border.all(
                                              width: 1,
                                              color: AppColor.mainColor,
                                            ),
                                          ),
                                          child: Text(
                                            e.name ?? "",
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            textAlign: TextAlign.center,
                                            style: AppTextStyle.mainColor(
                                              11,
                                              FontWeight.w500,
                                            ),
                                          ),
                                        ),
                                      )
                                      .toList() ??
                                  [],
                            ),
                            sh(12),
                            Text(
                              snap.data!.description ?? "",
                              style: AppTextStyle.gray(15, FontWeight.w400),
                            ),
                            sh(12),
                            Text(
                              "Organisateur",
                              style: AppTextStyle.black(15, FontWeight.bold),
                            ),
                            sh(12),
                            Row(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Container(
                                  width: formatWidth(46),
                                  height: formatHeight(46),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(100),
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(100),
                                    child: CachedNetworkImage(
                                      imageUrl:
                                          snap.data!.host!.pictures?.first ??
                                          "",
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                sw(13),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        isHost
                                            ? "Moi"
                                            : snap.data!.host!.firstname ?? "",
                                        style: AppTextStyle.black(
                                          16,
                                          FontWeight.w500,
                                        ),
                                      ),
                                      Text(
                                        "Host de la Fiesta",
                                        style: AppTextStyle.gray(
                                          12,
                                          FontWeight.w400,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            sh(20),
                            const Divider(),
                            sh(20),
                            Text(
                              "Date",
                              style: AppTextStyle.gray(12, FontWeight.w400),
                            ),
                            RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: "du ",
                                    style: AppTextStyle.gray(
                                      13,
                                      FontWeight.w400,
                                    ),
                                  ),
                                  TextSpan(
                                    text:
                                        "${snap.data!.startAt?.day.toString().padLeft(2, "0")}/${snap.data!.startAt?.month.toString().padLeft(2, "0")}/${snap.data!.startAt?.year.toString().padLeft(2, "0")} ${snap.data!.startAt?.hour.toString().padLeft(2, "0")}:${snap.data!.startAt?.minute.toString().padLeft(2, "0")}",
                                    style: AppTextStyle.darkGray(
                                      13,
                                      FontWeight.w600,
                                    ),
                                  ),
                                  TextSpan(
                                    text: " au ",
                                    style: AppTextStyle.gray(
                                      13,
                                      FontWeight.w400,
                                    ),
                                  ),
                                  TextSpan(
                                    text:
                                        "${snap.data!.startAt?.day.toString().padLeft(2, "0")}/${snap.data!.startAt?.month.toString().padLeft(2, "0")}/${snap.data!.startAt?.year.toString().padLeft(2, "0")} ${snap.data!.startAt?.hour.toString().padLeft(2, "0")}:${snap.data!.startAt?.minute.toString().padLeft(2, "0")}",
                                    style: AppTextStyle.darkGray(
                                      13,
                                      FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            sh(7),
                            Text(
                              "Adresse",
                              style: AppTextStyle.gray(12, FontWeight.w400),
                            ),
                            Text(
                              snap.data!.address?.formattedText ?? "",
                              style: AppTextStyle.darkGray(14, FontWeight.w600),
                            ),
                            sh(20),
                            const Divider(),
                            sh(20),
                            Text(
                              "Participants",
                              style: AppTextStyle.gray(12, FontWeight.w400),
                            ),
                            Text(
                              "${(snap.data!.participants?.where((element) => element.status == "accepted").toList() ?? []).length} duos participent à l'événement",
                              style: AppTextStyle.darkGray(14, FontWeight.w600),
                            ),
                            sh(12),
                            Row(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                if (isHost)
                                  Expanded(
                                    child: CTA.primary(
                                      theme: CtaThemeData(
                                        width: double.infinity,
                                        borderRadius: 100,
                                        backgroundColor: Colors.transparent,
                                        border: Border.all(
                                          color: Colors.black,
                                          width: .5,
                                        ),
                                        textButtonStyle: AppTextStyle.black(
                                          14,
                                          FontWeight.w500,
                                        ),
                                      ),
                                      textButton: "Gérer les duos",
                                      onTap: () {
                                        AutoRouter.of(context).navigate(
                                          FiestaHandleDuoRoute(
                                            fiestaId: widget.fiestaId,
                                            data: snap.data!,
                                          ),
                                        );
                                      },
                                    ),
                                  )
                                else
                                  const Spacer(),
                                sw(11),
                                Expanded(
                                  child: CTA.primary(
                                    theme: CtaThemeData(
                                      width: double.infinity,
                                      borderRadius: 100,
                                      backgroundColor: Colors.transparent,
                                      border: Border.all(
                                        color: Colors.black,
                                        width: .5,
                                      ),
                                      textButtonStyle: AppTextStyle.black(
                                        14,
                                        FontWeight.w500,
                                      ),
                                    ),
                                    child: Center(
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          SvgPicture.asset(
                                            "assets/svg/ic_message.svg",
                                          ),
                                          sw(6.6),
                                          Text(
                                            "Tchatter",
                                            style: AppTextStyle.black(
                                              14,
                                              FontWeight.w500,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    onTap: () {},
                                  ),
                                ),
                              ],
                            ),
                            sh(40),
                          ],
                        ),
                      ),
                    );
                  },
                ),
                Positioned(
                  top: formatHeight(60),
                  left: 22,
                  child: Button(
                    decoration: BoxDecoration(
                      color: const Color(0xFF021119).withValues(alpha: .5),
                      borderRadius: BorderRadius.circular(28),
                    ),
                    onTap: () => AutoRouter.of(context).back(),
                    height: formatWidth(46),
                    width: formatWidth(46),
                    child: Center(
                      child: SvgPicture.asset("assets/svg/ic_back.svg"),
                    ),
                  ),
                ),
                if (isHost)
                  Positioned(
                    top: formatHeight(60),
                    right: 22,
                    child: Button(
                      decoration: BoxDecoration(
                        color: const Color(0xFF021119).withValues(alpha: .5),
                        borderRadius: BorderRadius.circular(28),
                      ),
                      onTap: () async =>
                          await _fiestaEvent(context, snap.data!),
                      height: formatWidth(46),
                      width: formatWidth(46),
                      child: const Center(
                        child: Icon(
                          Icons.more_horiz_rounded,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
              ],
            );
          }
          return const Center(child: LoaderClassique());
        },
      ),
    );
  }

  Future<void> _fiestaEvent(
    BuildContext context,
    FiestaModel fiestaModel,
  ) async {
    await showCupertinoModalPopup(
      context: context,
      builder: (_) {
        return CupertinoActionSheet(
          title: Text("utils.what-want-do".tr()),
          actions: [
            if (fiestaModel.isEnd != false)
              CupertinoActionSheetAction(
                child: const Text("Modifier la Fiesta"),
                onPressed: () {
                  Navigator.pop(context);
                  AutoRouter.of(
                    context,
                  ).navigate(FiestaUpdateFormRoute(fiestaId: widget.fiestaId));
                },
              ),
            CupertinoActionSheetAction(
              child: const Text("Gérer les duos"),
              onPressed: () {
                Navigator.pop(context);
                AutoRouter.of(context).back();
                AutoRouter.of(context).navigate(
                  FiestaHandleDuoRoute(
                    fiestaId: widget.fiestaId,
                    data: fiestaModel,
                  ),
                );
              },
            ),
            CupertinoActionSheetAction(
              isDestructiveAction: true,
              child: const Text("Supprimer la Fiesta"),
              onPressed: () {
                FiestaController.deleteFiesta(
                  FirebaseAuth.instance.currentUser!.uid,
                  widget.fiestaId,
                );
                Navigator.pop(context);
                AutoRouter.of(context).back();
              },
            ),
          ],
          cancelButton: CupertinoActionSheetAction(
            child: Text("utils.cancel".tr()),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        );
      },
    );
  }
}
