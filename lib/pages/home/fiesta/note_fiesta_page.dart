import 'package:auto_route/auto_route.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:core_kosmos/core_kosmos.dart';
import 'package:twogather/controller/fiesta_controller.dart';
import 'package:twogather/controller/recommandation_controller.dart';
import 'package:twogather/model/color.dart';
import 'package:twogather/model/fiesta/fiesta_model.dart';
import 'package:twogather/model/user/app_user/app_user_model.dart';
import 'package:twogather/widgets/button/core.dart';
import "package:flutter/material.dart";
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shimmer/shimmer.dart';
import 'package:skeleton_kosmos/skeleton_kosmos.dart';
import 'package:ui_kosmos_v4/ui_kosmos_v4.dart';

@RoutePage()
class NoteFiestaPage extends StatefulHookConsumerWidget {
  final String fiestaId;
  final String hostId;

  const NoteFiestaPage({
    super.key,
    @PathParam("fiestaId") required this.fiestaId,
    @PathParam("hostId") required this.hostId,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _NoteFiestaPageState();
}

class _NoteFiestaPageState extends ConsumerState<NoteFiestaPage> {
  late Future<FiestaModel?> fiesta;
  late Future<List<AppUserModel>?> fiestasUsers;

  @override
  void initState() {
    fiesta = FirebaseFirestore.instance
        .collection("fiesta")
        .doc(widget.fiestaId)
        .get()
        .then((value) {
          final model = FiestaModel.fromJson(
            value.data()!,
          ).copyWith(id: value.id);
          return model;
        });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Slidable.of(
        context,
      )?.close(duration: const Duration(milliseconds: 300)),
      child: ScrollingPage(
        useSafeArea: true,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: formatHeight(35),
              width: double.infinity,
              child: Stack(
                children: [
                  Center(
                    child: Text("Participants", style: AppTextStyle.black(17)),
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
                ],
              ),
            ),
            sh(30),
            FutureBuilder(
              future: fiesta,
              builder: (_, AsyncSnapshot<FiestaModel?> snapshot) {
                if (snapshot.hasData && snapshot.data != null) {
                  bool isHost = snapshot.data!.host!.id == widget.hostId;

                  return FutureBuilder(
                    future: FiestaController.getAppUserFromListOfParticipants(
                      snapshot.data!,
                    ),
                    builder: (_, AsyncSnapshot<List<AppUserModel>?> snap) {
                      if (snap.hasData && snap.data != null) {
                        return Column(
                          children: [
                            Container(
                              width: double.infinity,
                              constraints: BoxConstraints(
                                minHeight: formatHeight(60),
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(7),
                                color: const Color(
                                  0xFFF5F5F5,
                                ).withValues(alpha: .67),
                              ),
                              padding: EdgeInsets.symmetric(
                                horizontal: formatWidth(13),
                                vertical: formatHeight(11.5),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(100),
                                    child: CachedNetworkImage(
                                      imageUrl:
                                          snapshot.data!.host!.pictures!.first,
                                      fit: BoxFit.cover,
                                      width: formatWidth(37),
                                      height: formatWidth(37),
                                    ),
                                  ),
                                  sw(13),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "${snapshot.data!.host!.firstname} ${snapshot.data!.host!.lastname}",
                                        style: AppTextStyle.mainColor(
                                          13,
                                          FontWeight.w500,
                                        ),
                                      ),
                                      Text(
                                        "Host de la Fiesta",
                                        style: AppTextStyle.gray(12),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            sh(7),
                            ...snap.data!.map(
                              (e) => _buildSlidableUserBox(e, isHost),
                            ),
                          ],
                        );
                      }
                      return Shimmer.fromColors(
                        period: const Duration(seconds: 2),
                        baseColor: const Color(
                          0xFF02132B,
                        ).withValues(alpha: .08),
                        highlightColor: const Color(
                          0xFF02132B,
                        ).withValues(alpha: .0),
                        child: Column(
                          children: [
                            for (var i = 0; i < 5; i++) ...[
                              Container(
                                width: double.infinity,
                                height: formatHeight(60),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(7),
                                  color: Colors.white,
                                ),
                              ),
                              sh(7),
                            ],
                          ],
                        ),
                      );
                    },
                  );
                }
                return Shimmer.fromColors(
                  period: const Duration(seconds: 2),
                  baseColor: const Color(0xFF02132B).withValues(alpha: .08),
                  highlightColor: const Color(0xFF02132B).withValues(alpha: .0),
                  child: Column(
                    children: [
                      for (var i = 0; i < 7; i++) ...[
                        Container(
                          width: double.infinity,
                          height: formatHeight(60),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(7),
                            color: Colors.white,
                          ),
                        ),
                        sh(7),
                      ],
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSlidableUserBox(AppUserModel e, bool isHost) {
    return Column(
      children: [
        Slidable(
          endActionPane: ActionPane(
            extentRatio: isHost ? .6 : .25,
            motion: const BehindMotion(),
            children: [
              Expanded(
                child: Builder(
                  builder: (con) {
                    return Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (isHost) ...[
                          InkWell(
                            onTap: () async {
                              await _noteUser(e.firstname, e.id);
                            },
                            child: Row(
                              children: [
                                sw(23),
                                const Text(
                                  "noter",
                                  style: TextStyle(
                                    color: Color(0xFFFF7102),
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                sw(23),
                              ],
                            ),
                          ),
                        ],
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
                              colorFilter: ColorFilter.mode(
                                Colors.black,
                                BlendMode.srcIn,
                              ),
                            ),
                          ),
                          onTap: () async {
                            Slidable.of(con)?.close(
                              duration: const Duration(milliseconds: 300),
                            );
                            AutoRouter.of(
                              context,
                            ).navigateNamed("/dashboard/report/${e.id}");
                          },
                        ),
                        if (isHost) ...[
                          sw(9),
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
                                colorFilter: ColorFilter.mode(
                                  Colors.black,
                                  BlendMode.srcIn,
                                ),
                                width: formatWidth(27),
                              ),
                            ),
                            onTap: () async {
                              Slidable.of(con)!.close(
                                duration: const Duration(milliseconds: 300),
                              );
                              RecommandationController.recommandAGroup(
                                e.id!,
                                null,
                              );
                              NotifBanner.showToast(
                                context: context,
                                fToast: FToast().init(context),
                                title: "Merci !",
                                subTitle:
                                    "votre recommandation de ${e.firstname} a bien été prise en compte",
                                backgroundColor: const Color(0xFF0ACC73),
                              );
                            },
                          ),
                        ],
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
          child: Container(
            width: double.infinity,
            constraints: BoxConstraints(minHeight: formatHeight(60)),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(7),
              color: const Color(0xFFF5F5F5).withValues(alpha: .67),
            ),
            padding: EdgeInsets.symmetric(
              horizontal: formatWidth(13),
              vertical: formatHeight(11.5),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(100),
                  child: CachedNetworkImage(
                    imageUrl: e.pictures!.first,
                    fit: BoxFit.cover,
                    width: formatWidth(37),
                    height: formatWidth(37),
                  ),
                ),
                sw(13),
                Text(
                  "${e.firstname} ${e.lastname}",
                  style: AppTextStyle.darkBlue(13, FontWeight.w500),
                ),
              ],
            ),
          ),
        ),
        sh(7),
      ],
    );
  }

  Future<void> _noteUser(String? firstname, String? id) async {
    double note = 4;

    await showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(formatWidth(40)),
          topRight: Radius.circular(formatWidth(40)),
        ),
      ),
      isScrollControlled: true,
      backgroundColor: Colors.white,
      builder: (_) {
        return Container(
          constraints: BoxConstraints(minHeight: formatHeight(300)),
          padding: EdgeInsets.symmetric(horizontal: formatWidth(30)),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              sh(12),
              Container(
                width: formatWidth(47),
                height: formatHeight(4),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(formatWidth(40)),
                  color: const Color(0xFFDDDFE2),
                ),
              ),
              sh(17),
              Text("Noter $firstname", style: AppTextStyle.darkBlue(17)),
              sh(30),
              RatingBar.builder(
                initialRating: 4,
                minRating: 0,
                direction: Axis.horizontal,
                allowHalfRating: false,
                itemCount: 5,
                itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                itemBuilder: (context, _) =>
                    Icon(Icons.star, color: AppColor.mainColor, size: 50),
                unratedColor: AppColor.mainColor.withValues(alpha: .25),
                glow: false,
                onRatingUpdate: (rating) {
                  note = rating;
                },
              ),
              sh(70),
              CTA.primary(
                width: double.infinity,
                textButton: "Noter maintenant",
                onTap: () async {
                  RecommandationController.noteUser(id!, note);
                  NotifBanner.showToast(
                    context: context,
                    fToast: FToast().init(context),
                    title: "Merci !",
                    subTitle: "Nous avons bien pris en compte votre retour.",
                    backgroundColor: const Color(0xFF0ACC73),
                  );
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
