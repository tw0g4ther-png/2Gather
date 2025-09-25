import 'dart:ui';

import 'package:auto_route/auto_route.dart';
import 'package:core_kosmos/core_kosmos.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:twogather/controller/friend_controller.dart';
import 'package:twogather/main.dart';
import 'package:twogather/model/color.dart';
import 'package:twogather/model/passion/passion_model.dart';
import 'package:twogather/pages/home/friend/is_match_page.dart';
import 'package:twogather/routes/app_router.dart';
import 'package:twogather/services/birthday.dart';

import 'package:twogather/model/slidable_card_model/user/friend_card_model.dart';
import 'package:twogather/model/user/app_user/app_user_model.dart';
import 'package:twogather/provider/geoloc_provider.dart';
import 'package:twogather/widgets/button/core.dart';
import 'package:twogather/widgets/image_list_swipe/image_list_swipe.dart';
import 'package:twogather/widgets/slidable_card/core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:skeleton_kosmos/skeleton_kosmos.dart';
import 'package:ui_kosmos_v4/ui_kosmos_v4.dart';

class FriendHomePage extends StatefulHookConsumerWidget {
  const FriendHomePage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _FriendHomePageState();
}

class _FriendHomePageState extends ConsumerState<FriendHomePage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          sh(12),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: formatWidth(22)),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const GeolocWidget(),
                      sh(3),
                      Text(
                        "app.fiestars-around".tr(),
                        style: AppTextStyle.darkBlue(18, FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                sw(20),
                Button(
                  onTap: () async {
                    await _showFilterDialog(context);
                  },
                  width: 50.0,
                  height: 50.0,
                  child: SvgPicture.asset("assets/svg/ic_filter.svg"),
                ),
              ],
            ),
          ),
          sh(25),
          Builder(
            builder: (context) {
              final users = ref.watch(userSwipeProvider).users;

              if (users == null) {
                return const Expanded(child: Center(child: LoaderClassique()));
              } else if (users.isEmpty) {
                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Center(
                      child: Text(
                        "Aucun utilisateur trouvé, réessayes un peu plus tard.",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                      ),
                    ),
                  ),
                );
              } else {
                return Padding(
                  padding: EdgeInsets.symmetric(horizontal: formatWidth(17)),
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: _buildCardList(context, users),
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }

  List<Widget> _buildCardList(BuildContext context, List<AppUserModel> users) {
    List<Widget> items = [];

    for (int i = 0; i < users.length; i++) {
      if (i > 2) break;
      // Dimensions fixes des cartes avec décalage pour l'effet de pile
      Size size = Size(342.0 - (10.0 * i), 555.0 + (6.0 * i));
      items.add(
        Center(
          child: SlidableCard<FriendCardModel>(
            size: size,
            isDraggable: i == 0,
            backgroundColor: const Color(0xFFDEDEDE),
            border: Border.all(color: const Color(0xFFDEDEDE), width: 5),
            onSwipe: (direction, data) async {
              final user = users[i];
              ref.read(userSwipeProvider).nextCard(data.id!);
              if (direction == SwipingDirection.right) {
                final isAMatch =
                    await FriendController.checkMatchWithFriendAdded(
                      FirebaseAuth.instance.currentUser!.uid,
                      user.id!,
                    );

                if (isAMatch) {
                  Future.delayed(const Duration(milliseconds: 1250), () async {
                    if (!context.mounted) return;
                    await Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => IsMatchPage(user: user),
                      ),
                    );
                  });
                }
                await FriendController.addFriendWithSwipe(
                  FirebaseAuth.instance.currentUser!.uid,
                  user.id!,
                );
              } else if (direction == SwipingDirection.left) {
                await FriendController.dismissFriendWithSwipe(
                  FirebaseAuth.instance.currentUser!.uid,
                  user.id!,
                );
              }
            },
            cardBuilder: (context, child, data) {
              return Container(
                width: double.infinity,
                height: double.infinity,
                clipBehavior: Clip.hardEdge,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(13),
                ),
                child: LayoutBuilder(
                  builder: (_, c) {
                    return SizedBox(
                      width: c.maxWidth,
                      height: c.maxHeight,
                      child: Stack(
                        children: [
                          ImageListSwipe(
                            activeImage: i == 0
                                ? ref.watch(userSwipeProvider).actualImage
                                : 0,
                            images: data.photos ?? [],
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Expanded(
                                child: GestureDetector(
                                  onTap: () {
                                    if (ref
                                            .read(userSwipeProvider)
                                            .actualImage >
                                        0) {
                                      ref
                                          .read(userSwipeProvider)
                                          .previousImage();
                                    }
                                  },
                                ),
                              ),
                              Expanded(
                                child: GestureDetector(
                                  onTap: () {
                                    if (ref
                                            .read(userSwipeProvider)
                                            .actualImage <
                                        (users[i].pictures?.length ?? 0) - 1) {
                                      ref.read(userSwipeProvider).nextImage();
                                    }
                                  },
                                ),
                              ),
                            ],
                          ),
                          Positioned(
                            top: 35,
                            left: 23,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(100),
                              child: BackdropFilter(
                                filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
                                child: Button(
                                  onTap: ref
                                      .read(userSwipeProvider)
                                      .showPreviousCard,
                                  width: 30.0,
                                  height: 30.0,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(100),
                                    border: Border.all(
                                      color: Colors.black.withValues(
                                        alpha: .09,
                                      ),
                                      width: .5,
                                    ),
                                  ),
                                  child: Center(
                                    child: Transform.rotate(
                                      angle: -20,
                                      child: SvgPicture.asset(
                                        "assets/svg/ic_refresh.svg",
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 0,
                            child: Container(
                              width: c.maxWidth,
                              height: 170.0,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16.0,
                                vertical: 19.0,
                              ),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Colors.black,
                                    Colors.black.withValues(alpha: 0),
                                  ],
                                  begin: Alignment.bottomCenter,
                                  end: Alignment.topCenter,
                                ),
                                borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(13),
                                  bottomRight: Radius.circular(13),
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        Text(
                                          data.name ?? "",
                                          style: AppTextStyle.white(
                                            23,
                                            FontWeight.bold,
                                          ),
                                        ),
                                        sh(5),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            // Âge
                                            Text(
                                              "${(DateTime.now().difference(data.birthday ?? DateTime.now())).formatToGetAge()} ans",
                                              style: AppTextStyle.white(
                                                14,
                                                FontWeight.w500,
                                              ),
                                            ),
                                          ],
                                        ),
                                        if (data.description != null) ...[
                                          sh(5),
                                          Expanded(
                                            child: Text(
                                              data.description!,
                                              maxLines: 3,
                                              style: AppTextStyle.white(
                                                13,
                                                FontWeight.w400,
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ],
                                      ],
                                    ),
                                  ),
                                  sw(10),
                                  Column(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      ..._getThreeTags(data).map(
                                        (tag) => Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 10.0,
                                            vertical: 6.0,
                                          ),
                                          margin: const EdgeInsets.only(
                                            bottom: 4.0,
                                          ),
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                              width: 1.3,
                                              color: const Color.fromARGB(
                                                255,
                                                244,
                                                72,
                                                29,
                                              ),
                                            ),
                                            color: Colors.white.withValues(
                                              alpha: .09,
                                            ),
                                            borderRadius: BorderRadius.circular(
                                              100,
                                            ),
                                          ),
                                          child: Text(
                                            tag.name ?? "",
                                            style: AppTextStyle.white(
                                              11,
                                              FontWeight.w500,
                                            ),
                                          ),
                                        ),
                                      ),
                                      CTA.primary(
                                        width: 120.0,
                                        height: 40.0,
                                        textButtonStyle: AppTextStyle.white(
                                          13,
                                          FontWeight.w500,
                                        ),
                                        textButton: "utils.see-profil".tr(),
                                        theme: CtaThemeData(
                                          backgroundColor: const Color.fromARGB(
                                            255,
                                            244,
                                            72,
                                            29,
                                          ),
                                          borderRadius: 100,
                                          height: 40.0,
                                        ),
                                        onTap: () {
                                          AutoRouter.of(context).navigate(
                                            FriendInfoRoute(user: users[i]),
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              );
            },
            data: FriendCardModel(
              id: users[i].id,
              name: users[i].firstname,
              description: users[i].description,
              photos: users[i].pictures,
              tags: users[i].tags,
              birthday: users[i].birthday,
            ),
          ),
        ),
      );
    }

    items = items.reversed.toList();

    return items;
  }

  List<PassionModel> _getThreeTags(FriendCardModel data) {
    List<PassionModel> items = [];

    if (data.tags?.passion?.isNotEmpty ?? false) {
      for (final item in data.tags!.passion!) {
        if (items.length == 2) break;
        items.add(item);
      }
    }

    if (data.tags?.drink?.isNotEmpty ?? false) {
      for (final item in data.tags!.drink!) {
        if (items.length == 2) break;
        items.add(item);
      }
    }

    if (data.tags?.music?.isNotEmpty ?? false) {
      for (final item in data.tags!.music!) {
        if (items.length == 2) break;
        items.add(item);
      }
    }

    if (data.tags?.fiesta?.isNotEmpty ?? false) {
      for (final item in data.tags!.fiesta!) {
        if (items.length == 2) break;
        items.add(item);
      }
    }

    return items;
  }

  /// Widget de suggestions manuel avec Google Places
  Widget _buildLocationFieldWithSuggestions(
    BuildContext context,
    TextEditingController controller,
    FocusNode focusNode,
    Function(LocationModel) onLocationSelected,
  ) {
    final ValueNotifier<List<LocationModel>> suggestions =
        ValueNotifier<List<LocationModel>>([]);
    final ValueNotifier<bool> showSuggestions = ValueNotifier<bool>(false);

    return Column(
      children: [
        TextField(
          focusNode: focusNode,
          controller: controller,
          onChanged: (value) async {
            if (value.length < 3) {
              suggestions.value = [];
              showSuggestions.value = false;
              return;
            }

            try {
              final formattedQuery = value.replaceAllMapped(' ', (m) => '+');
              final results = await placeAutocomplete(formattedQuery, "fr");
              suggestions.value = results;
              showSuggestions.value = results.isNotEmpty;
            } catch (e) {
              suggestions.value = [];
              showSuggestions.value = false;
            }
          },
          decoration: InputDecoration(
            suffixIcon: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "utils.change".tr(),
                      style: AppTextStyle.mainColor(12.5),
                    ),
                    sw(8),
                  ],
                ),
              ],
            ),
            errorStyle: const TextStyle(fontSize: 12, height: 0),
            filled: true,
            fillColor: const Color(0xFF02132B).withValues(alpha: 0.03),
            contentPadding: const EdgeInsets.fromLTRB(9.5, 17.5, 9.5, 17.5),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6),
              borderSide: const BorderSide(color: Colors.redAccent, width: 0.5),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6),
              borderSide: const BorderSide(color: Colors.red, width: 0.5),
            ),
            focusedBorder: UnderlineInputBorder(
              borderRadius: BorderRadius.circular(100),
              borderSide: BorderSide.none,
            ),
            border: UnderlineInputBorder(
              borderRadius: BorderRadius.circular(100),
              borderSide: BorderSide.none,
            ),
            hintText: "app.around-me".tr(),
            hintStyle: const TextStyle(
              color: Color(0xFF9299A4),
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        // Affichage des suggestions
        ValueListenableBuilder(
          valueListenable: showSuggestions,
          builder: (context, bool show, child) {
            if (!show) return const SizedBox.shrink();

            return ValueListenableBuilder(
              valueListenable: suggestions,
              builder: (context, List<LocationModel> suggestionsList, child) {
                return Container(
                  margin: const EdgeInsets.only(top: 4),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.1),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxHeight: 200),
                    child: ListView.builder(
                      padding: EdgeInsets.zero,
                      shrinkWrap: true,
                      itemCount: suggestionsList.length,
                      itemBuilder: (context, index) {
                        final location = suggestionsList[index];
                        return Container(
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                color: Colors.grey.withValues(alpha: 0.2),
                                width: 0.5,
                              ),
                            ),
                          ),
                          child: ListTile(
                            dense: true,
                            leading: Icon(
                              Icons.location_on,
                              color: AppColor.mainColor,
                              size: 20,
                            ),
                            title: Text(
                              location.mainText ?? "",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: sp(14),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            subtitle: location.secondaryText != null
                                ? Text(
                                    location.secondaryText!,
                                    style: TextStyle(
                                      color: Colors.grey[600],
                                      fontSize: sp(12),
                                    ),
                                  )
                                : null,
                            onTap: () {
                              onLocationSelected(location);
                              showSuggestions.value = false;
                              focusNode.unfocus();
                            },
                          ),
                        );
                      },
                    ),
                  ),
                );
              },
            );
          },
        ),
      ],
    );
  }

  Future _showFilterDialog(BuildContext context) async {
    TextEditingController controller = TextEditingController();
    FocusNode focusNodeSearch = FocusNode();

    await showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: const Radius.circular(40.0),
          topRight: const Radius.circular(40.0),
        ),
      ),
      isScrollControlled: true,
      backgroundColor: Colors.white,
      builder: (context) {
        return Consumer(
          builder: (context, ref, child) {
            return Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 29.0,
                vertical: 14.0,
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 47.0,
                      height: 4.0,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(40.0),
                        color: const Color(0xFFDDDFE2),
                      ),
                    ),
                    sh(17),
                    Text(
                      "app.settings-up-user-swipe".tr(),
                      style: AppTextStyle.black(17),
                      textAlign: TextAlign.center,
                    ),
                    sh(14),
                    SizedBox(
                      width: double.infinity,
                      child: Text(
                        "utils.localisation".tr(),
                        style: AppTextStyle.black(12, FontWeight.w500),
                        textAlign: TextAlign.left,
                      ),
                    ),
                    sh(6),
                    _buildLocationFieldWithSuggestions(
                      context,
                      controller,
                      focusNodeSearch,
                      (location) {
                        ref.read(userSwipePrefProvider).location = location;
                        controller.text = location.formattedText;
                        focusNodeSearch.unfocus();
                      },
                    ),
                    sh(14.5),
                    SizedBox(
                      width: double.infinity,
                      child: Text(
                        "utils.visibility-ray".tr(),
                        style: AppTextStyle.black(12, FontWeight.w500),
                      ),
                    ),
                    CustomSlider.slider(
                      min: 5,
                      max: 70,
                      theme: SliderThemeData(
                        thumbColor: AppColor.mainColor,
                        activeTrackColor: AppColor.mainColor,
                      ),
                      value: ref
                          .watch(userSwipePrefProvider)
                          .visibilty
                          .toDouble(),
                      onChanged: (p0) => ref
                          .read(userSwipePrefProvider)
                          .setVisibility(p0.toInt()),
                      customSliderThumbShape: CustomSliderThumbShape(
                        stringNumber:
                            "${ref.watch(userSwipePrefProvider).visibilty.toString()}km",
                      ),
                    ),
                    sh(26),
                    SizedBox(
                      width: double.infinity,
                      child: Text(
                        "utils.age-range".tr(),
                        style: AppTextStyle.black(12, FontWeight.w500),
                      ),
                    ),
                    CustomSlider.range(
                      min: 10,
                      max: 70,
                      theme: SliderThemeData(
                        thumbColor: AppColor.mainColor,
                        activeTrackColor: AppColor.mainColor,
                      ),
                      rangeValue: RangeValues(
                        ref.watch(userSwipePrefProvider).age.value1.toDouble(),
                        ref.watch(userSwipePrefProvider).age.value2.toDouble(),
                      ),
                      onChanged: (p0) => ref
                          .read(userSwipePrefProvider)
                          .setAge(
                            (p0 as RangeValues).start.toInt(),
                            p0.end.toInt(),
                          ),
                    ),
                    sh(32),
                    CTA.primary(
                      textButton: "utils.apply".tr(),
                      onTap: () async {
                        ref.read(userSwipeProvider).clear();
                        await ref
                            .read(userSwipeProvider)
                            .getUsersList(
                              ref
                                  .read(userChangeNotifierProvider)
                                  .userData!
                                  .email!,
                              metadata: ref
                                  .read(userSwipePrefProvider)
                                  .getMetadata(),
                            );
                        if (!context.mounted) return;
                        Navigator.of(context).pop();
                      },
                    ),
                    TextButton(
                      onPressed: () async {
                        ref.read(userSwipeProvider).clear();
                        ref.read(userSwipePrefProvider).reset();
                        await ref
                            .read(userSwipeProvider)
                            .getUsersList(
                              ref
                                  .read(userChangeNotifierProvider)
                                  .userData!
                                  .email!,
                              metadata: ref
                                  .read(userSwipePrefProvider)
                                  .getMetadata(),
                            );
                      },
                      child: Text(
                        "utils.reinit".tr(),
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
