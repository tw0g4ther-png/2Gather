import 'package:auto_route/auto_route.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:core_kosmos/core_kosmos.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:twogather/controller/firestore_controller.dart';
import 'package:twogather/controller/friend_controller.dart';
import 'package:twogather/model/color.dart';
import 'package:twogather/model/user/app_user/app_user_model.dart';
import 'package:twogather/model/user/fiestar_model.dart';
import 'package:twogather/services/birthday.dart';
import 'package:twogather/widgets/alert/core.dart';
import 'package:twogather/widgets/user_card/widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shimmer/shimmer.dart';
import 'package:skeleton_kosmos/skeleton_kosmos.dart';
import 'package:ui_kosmos_v4/cta/cta.dart';

@RoutePage()
class RequestNetworkPage extends StatefulHookConsumerWidget {
  const RequestNetworkPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _RequestNetworkPageState();
}

class _RequestNetworkPageState extends ConsumerState<RequestNetworkPage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ScrollingPage(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            sh(20),
            SizedBox(
              width: MediaQuery.of(context).size.width,
              height: formatHeight(30),
              child: Stack(
                children: [
                  Center(
                    child: Text(
                      "app.request".tr(),
                      style: AppTextStyle.black(16),
                    ),
                  ),
                  CTA.back(
                    onTap: () => AutoRouter.of(context).back(),
                    backgroundColor: Colors.transparent,
                  ),
                ],
              ),
            ),
            sh(36),
            AnimationLimiter(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: formatWidth(12),
                mainAxisSpacing: formatWidth(12),
                childAspectRatio: formatWidth(154) / formatHeight(185),
                controller: ScrollController(keepScrollOffset: false),
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                children:
                    (ref.watch(userChangeNotifierProvider).userData
                            as FiestarUserModel)
                        .friendsRequest
                        ?.map((e) {
                          final index =
                              (ref.read(userChangeNotifierProvider).userData
                                      as FiestarUserModel)
                                  .friendsRequest!
                                  .indexOf(e);
                          return AnimationConfiguration.staggeredGrid(
                            position: index,
                            duration: const Duration(milliseconds: 375),
                            columnCount: 2,
                            child: ScaleAnimation(
                              child: FadeInAnimation(
                                child: FutureBuilder(
                                  future:
                                      FirestoreController.getDocumentSnapshotFromId(
                                        e,
                                      ),
                                  builder: (_, AsyncSnapshot<DocumentSnapshot> snapshot) {
                                    if (snapshot.hasData &&
                                        snapshot.data != null) {
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
                                      return UserCardWidget(
                                        image:
                                            data.pictures?.isNotEmpty ?? false
                                            ? data.pictures!.first
                                            : "",
                                        title: data.firstname ?? "",
                                        id: data.id!,
                                        subTitle:
                                            "${DateTime.now().difference(data.birthday!).formatToGetAge()} ans${data.locality != null ? " • ${data.locality}" : ""}",
                                        topRightAction: InkWell(
                                          onTap: () async {
                                            await AlertBox.show(
                                              context: context,
                                              title: "app.delete".tr(),
                                              message: "app.cancel-invit".tr(
                                                namedArgs: {
                                                  "name": data.firstname ?? "",
                                                },
                                              ),
                                              actions: [
                                                (_) => CTA.primary(
                                                  themeName: "red_button",
                                                  textButton: "utils.delete"
                                                      .tr(),
                                                  width: formatWidth(207),
                                                  textButtonStyle:
                                                      AppTextStyle.white(
                                                        14,
                                                        FontWeight.w600,
                                                      ),
                                                  onTap: () async {
                                                    await FriendController.cancelFriendRequest(
                                                      (ref
                                                                      .read(
                                                                        userChangeNotifierProvider,
                                                                      )
                                                                      .userData
                                                                  as FiestarUserModel?)!
                                                              .friendsRequest ??
                                                          [],
                                                      data.id!,
                                                    );
                                                    if (!context.mounted) {
                                                      return;
                                                    }
                                                    Navigator.of(context).pop();
                                                  },
                                                ),
                                              ],
                                            );
                                          },
                                          child: Container(
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(100),
                                              color: const Color(0xFF2C2C2B),
                                            ),
                                            padding: EdgeInsets.symmetric(
                                              horizontal: formatWidth(7.5),
                                              vertical: formatHeight(7),
                                            ),
                                            child: Text(
                                              "Annuler la demande",
                                              style: AppTextStyle.white(
                                                9,
                                                FontWeight.w500,
                                              ),
                                            ),
                                          ),
                                        ),
                                        isFriend: false,
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
                                      child: Container(
                                        height: formatHeight(185),
                                        width: formatWidth(154),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                            10,
                                          ),
                                          color: Colors.black,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                          );
                        })
                        .toList() ??
                    [],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
