import 'package:auto_route/auto_route.dart';
import 'package:core_kosmos/core_kosmos.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:twogather/controller/friend_controller.dart';
import 'package:twogather/model/color.dart';
import 'package:twogather/model/user/app_user/app_user_model.dart';
import 'package:twogather/model/user/fiestar_model.dart';
import 'package:twogather/services/birthday.dart';
import 'package:twogather/widgets/alert/core.dart';
import 'package:twogather/widgets/button/core.dart';
import 'package:twogather/widgets/search_bar/core.dart';
import 'package:twogather/widgets/search_bar/theme/theme.dart';
import 'package:twogather/widgets/user_card/widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shimmer/shimmer.dart';
import 'package:skeleton_kosmos/skeleton_kosmos.dart';
import 'package:ui_kosmos_v4/ui_kosmos_v4.dart';

@RoutePage()
class SearchNetworkPage extends StatefulHookConsumerWidget {
  const SearchNetworkPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _SearchNetworkPageState();
}

class _SearchNetworkPageState extends ConsumerState<SearchNetworkPage> {
  final ValueNotifier<String?> _search = ValueNotifier<String?>(null);

  late Future<List<AppUserModel>?> _usersLoaded;

  @override
  void initState() {
    _usersLoaded = FriendController.getUserListExceptMe();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
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
                        "app.search-fiestar".tr(),
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
                  ],
                ),
              ),
            ),
            sh(30),
            CustomSearchBar(
              theme: CustomSearchBarThemeData(
                constraints: BoxConstraints(
                  maxWidth: formatWidth(316),
                  maxHeight: formatHeight(50),
                  minHeight: formatHeight(50),
                ),
              ),
              options: const [],
              onSearchChanged: (value) => _search.value = value,
            ),
            sh(20),
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: formatWidth(22)),
                child: FutureBuilder(
                  future: _usersLoaded,
                  builder: (context, AsyncSnapshot<List<AppUserModel>?> snapshot) {
                    if (snapshot.hasData &&
                        snapshot.data != null &&
                        snapshot.data!.isNotEmpty) {
                      return AnimationLimiter(
                        child: ValueListenableBuilder(
                          valueListenable: _search,
                          builder: (context, String? val, child) {
                            List<AppUserModel>? filtered = snapshot.data!;
                            if (val != null) {
                              final query = val.toLowerCase();
                              filtered = snapshot.data!
                                  .where(
                                    (user) =>
                                        (user.firstname ?? "")
                                            .toLowerCase()
                                            .startsWith(query) ||
                                        (user.lastname ?? "")
                                            .toLowerCase()
                                            .startsWith(query),
                                  )
                                  .toList();
                            }
                            return GridView.count(
                              crossAxisCount: 2,
                              crossAxisSpacing: formatWidth(12),
                              mainAxisSpacing: formatWidth(12),
                              childAspectRatio:
                                  formatWidth(154) / formatHeight(185),
                              controller: ScrollController(
                                keepScrollOffset: false,
                              ),
                              shrinkWrap: true,
                              scrollDirection: Axis.vertical,
                              children: filtered.map((e) {
                                final userModel =
                                    (ref
                                            .watch(userChangeNotifierProvider)
                                            .userData
                                        as FiestarUserModel?);
                                final friends = userModel?.friends ?? [];
                                final friendsRequest =
                                    userModel?.friendsRequest ?? [];

                                bool isFriend =
                                    FriendController.userHaveThisPersonInFriends(
                                      friends,
                                      e.id!,
                                    );
                                bool isRequest = friendsRequest.contains(e.id!);
                                return UserCardWidget(
                                  image: e.pictures?.isNotEmpty ?? false
                                      ? e.pictures!.first
                                      : "",
                                  title: e.firstname ?? "",
                                  id: e.id!,
                                  subTitle: (() {
                                    final hasBirthday = e.birthday != null;
                                    final ageText = hasBirthday
                                        ? "${DateTime.now().difference(e.birthday!).formatToGetAge()} ans"
                                        : "";
                                    final hasLocality =
                                        (e.locality != null &&
                                        (e.locality?.isNotEmpty ?? false));
                                    final localityText = hasLocality
                                        ? (ageText.isNotEmpty
                                              ? " • ${e.locality}"
                                              : e.locality!)
                                        : "";
                                    return "$ageText$localityText";
                                  })(),
                                  isLock: (e.isLock ?? false) && isFriend,
                                  topRightAction: !isFriend
                                      ? isRequest
                                            ? InkWell(
                                                onTap: () async {
                                                  await AlertBox.show(
                                                    context: context,
                                                    title: "app.delete".tr(),
                                                    message: "app.cancel-invit"
                                                        .tr(
                                                          namedArgs: {
                                                            "name":
                                                                e.firstname ??
                                                                "",
                                                          },
                                                        ),
                                                    actions: [
                                                      (_) => CTA.primary(
                                                        themeName: "red_button",
                                                        textButton:
                                                            "utils.delete".tr(),
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
                                                            e.id!,
                                                          );
                                                          if (!context
                                                              .mounted) {
                                                            return;
                                                          }
                                                          Navigator.of(
                                                            context,
                                                          ).pop();
                                                        },
                                                      ),
                                                    ],
                                                  );
                                                },
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          100,
                                                        ),
                                                    color: const Color(
                                                      0xFF2C2C2B,
                                                    ),
                                                  ),
                                                  padding: EdgeInsets.symmetric(
                                                    horizontal: formatWidth(
                                                      7.5,
                                                    ),
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
                                              )
                                            : Button(
                                                width: formatWidth(32),
                                                height: formatWidth(32),
                                                onTap: () async =>
                                                    await FriendController.addFriend(
                                                      FirebaseAuth
                                                          .instance
                                                          .currentUser!
                                                          .uid,
                                                      e.id!,
                                                    ),
                                                decoration: BoxDecoration(
                                                  color: AppColor.mainColor,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                        100,
                                                      ),
                                                ),
                                                child: SvgPicture.asset(
                                                  "assets/svg/ic_add_friend.svg",
                                                  colorFilter: ColorFilter.mode(
                                                    Colors.white,
                                                    BlendMode.srcIn,
                                                  ),
                                                ),
                                              )
                                      : (!(e.isLock ?? false))
                                      ? Button(
                                          width: formatWidth(32),
                                          height: formatWidth(32),
                                          decoration: BoxDecoration(
                                            color: const Color(
                                              0xFF838383,
                                            ).withValues(alpha: .2),
                                            borderRadius: BorderRadius.circular(
                                              100,
                                            ),
                                          ),
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
                              }).toList(),
                            );
                          },
                        ),
                      );
                    }
                    return GridView.count(
                      crossAxisCount: 2,
                      crossAxisSpacing: formatWidth(12),
                      mainAxisSpacing: formatWidth(12),
                      childAspectRatio: formatWidth(154) / formatHeight(185),
                      controller: ScrollController(keepScrollOffset: false),
                      shrinkWrap: true,
                      scrollDirection: Axis.vertical,
                      children: List.generate(5, (index) {
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
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.white,
                            ),
                          ),
                        );
                      }),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
