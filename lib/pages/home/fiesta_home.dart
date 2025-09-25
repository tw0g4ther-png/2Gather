import 'dart:ui';

import 'package:auto_route/auto_route.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:core_kosmos/core_package.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:twogather/controller/date_controller.dart';
import 'package:twogather/controller/fiesta_controller.dart';
import 'package:twogather/main.dart';
import 'package:twogather/model/color.dart';
import 'package:twogather/model/fiesta/fiesta_model.dart';
import 'package:twogather/model/fiesta/tag/tag_model.dart';
import 'package:twogather/model/user/app_user/app_user_model.dart';
import 'package:twogather/model/user/fiestar_model.dart';
import 'package:twogather/pages/home/fiesta/choose_duo.dart';
import 'package:twogather/pages/home/fiesta/confirm_request.dart';
import 'package:twogather/pages/home_page.dart';
import 'package:twogather/routes/app_router.dart';
import 'package:twogather/widgets/button/core.dart';
import 'package:twogather/widgets/image_list_swipe/image_list_swipe.dart';
import 'package:twogather/widgets/slidable_card/core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get_it/get_it.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:skeleton_kosmos/skeleton_kosmos.dart';
import 'package:ui_kosmos_v4/ui_kosmos_v4.dart';

class FiestaHomePage extends StatefulHookConsumerWidget {
  const FiestaHomePage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _FiestaHomePageState();
}

class _FiestaHomePageState extends ConsumerState<FiestaHomePage> {
  final appModel = GetIt.instance<ApplicationDataModel>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          sh(12),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: formatWidth(28)),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: SizedBox(
                      height: formatWidth(60),
                      child: ImageWithSmartFormat(
                        path: appModel.appLogo,
                        type: appModel.logoFormat,
                      ),
                    ),
                  ),
                ),
                Button(
                  onTap: () async => await _showFilterFiesta(context),
                  width: formatWidth(50),
                  height: formatWidth(50),
                  child: SvgPicture.asset("assets/svg/ic_filter.svg"),
                ),
              ],
            ),
          ),
          sh(30),
          if ((ref.watch(userChangeNotifierProvider).userData
                      as FiestarUserModel?)
                  ?.fiesta !=
              null)
            _buildLockedCard(context)
          else ...[
            if (ref.watch(fiestaSwipeProvider).isLoading ||
                ref.watch(fiestaSwipeProvider).fiestas == null)
              const Expanded(child: Center(child: LoaderClassique()))
            else if (ref.watch(fiestaSwipeProvider).fiestas?.isEmpty ?? true)
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Center(
                    child: Text(
                      "Aucune Fiesta trouvé, réessayes un peu plus tard.",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                    ),
                  ),
                ),
              )
            else
              Padding(
                padding: EdgeInsets.symmetric(horizontal: formatWidth(17)),
                child: Stack(
                  clipBehavior: Clip.none,
                  children: _buildCardList(
                    context,
                    ref.watch(fiestaSwipeProvider).fiestas!,
                  ),
                ),
              ),
            sh(20),
          ],
        ],
      ),
    );
  }

  List<Widget> _buildCardList(BuildContext context, List<FiestaModel> list) {
    List<Widget> items = [const SizedBox()];

    for (var i = 0; i < list.length; i++) {
      if (i > 2) break;
      // Dimensions fixes des cartes avec décalage pour l'effet de pile
      Size size = Size(342.0 - (10.0 * i), 555.0 + (6.0 * i));

      items.add(
        Center(
          child: SlidableCard<FiestaModel>(
            size: size,
            isDraggable: i == 0,
            onSwipe: (direction, data) async {
              printInDebug("[Fiesta Card] swipe at ${direction.toString()}");

              if (direction == SwipingDirection.right) {
                ref.read(fiestaSwipeProvider.notifier).nextFiesta(data.id!);
                AppUserModel? duo =
                    (ref.read(userChangeNotifierProvider).userData
                            as FiestarUserModel?)!
                        .duo;
                final bool isWithSearch = duo == null;

                final fiestaStatus =
                    await FiestaController.checkIfCanSelectAFiestar(
                      FirebaseAuth.instance.currentUser!.uid,
                      data.id!,
                      data,
                      (ref.read(userChangeNotifierProvider).userData!
                          as FiestarUserModel),
                    );

                if (fiestaStatus) {
                  if (!context.mounted) return;
                  duo = await Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) =>
                          ChooseDuoPage(fiestaId: data.id!, data: data),
                    ),
                  );
                }
                await FiestaController.acceptFiesta(
                  FirebaseAuth.instance.currentUser!.uid,
                  data.id!,
                  data,
                  duo,
                  duo == null ? false : isWithSearch,
                );
                if (context.mounted) {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => ConfirmRequest(data: data),
                    ),
                  );
                }
              } else if (direction == SwipingDirection.left) {
                ref.read(fiestaSwipeProvider.notifier).nextFiesta(data.id!);
                await FiestaController.dismissFiesta(
                  FirebaseAuth.instance.currentUser!.uid,
                  data.id!,
                );
              }
            },
            backgroundColor: const Color(0xFFDEDEDE),
            border: Border.all(color: const Color(0xFFDEDEDE), width: 5),
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
                                ? ref.watch(fiestaSwipeProvider).actualImage
                                : 0,
                            images: data.pictures ?? [],
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Expanded(
                                child: GestureDetector(
                                  onTap: () {
                                    if (ref
                                            .read(fiestaSwipeProvider)
                                            .actualImage >
                                        0) {
                                      ref
                                          .read(fiestaSwipeProvider)
                                          .previousImage();
                                    }
                                  },
                                ),
                              ),
                              Expanded(
                                child: GestureDetector(
                                  onTap: () {
                                    if (ref
                                            .read(fiestaSwipeProvider)
                                            .actualImage <
                                        (list[i].pictures?.length ?? 0) - 1) {
                                      ref.read(fiestaSwipeProvider).nextImage();
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
                                      .read(fiestaSwipeProvider)
                                      .showPreviousCard,
                                  width: formatWidth(30),
                                  height: formatWidth(30),
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
                          Padding(
                            padding: const EdgeInsets.only(right: 23),
                            child: Column(
                              children: [
                                sh(42),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        Text(
                                          data.host!.firstname ?? "",
                                          style: AppTextStyle.white(
                                            14,
                                            FontWeight.w600,
                                          ),
                                        ),
                                        Text(
                                          "Host",
                                          style: TextStyle(
                                            color: Colors.white.withValues(
                                              alpha: .75,
                                            ),
                                            fontSize: sp(11),
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                    sw(7),
                                    Container(
                                      width: formatWidth(31),
                                      height: formatWidth(31),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(
                                          100,
                                        ),
                                      ),
                                      clipBehavior: Clip.hardEdge,
                                      child: CachedNetworkImage(
                                        imageUrl: data.host!.pictures!.first,
                                        width: formatWidth(31),
                                        height: formatWidth(31),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    sw(15),
                                    Container(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: formatWidth(8),
                                        vertical: formatHeight(7),
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.black.withValues(
                                          alpha: .3,
                                        ),
                                        borderRadius: BorderRadius.circular(
                                          100,
                                        ),
                                        border: Border.all(
                                          width: 1.3,
                                          color: const Color.fromARGB(
                                            255,
                                            244,
                                            72,
                                            29,
                                          ),
                                        ),
                                      ),
                                      child: Text(
                                        "${(data.numberOfParticipant?.toInt() ?? 0) - (data.participants?.where((element) => element.status == "accepted").toList() ?? []).length} places restantes",
                                        style: AppTextStyle.white(9),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Positioned(
                            bottom: 0,
                            child: _buildFiestaInfo(context, c.maxWidth, data),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              );
            },
            data: list[i],
          ),
        ),
      );
    }

    items = items.reversed.toList();

    return items;
  }

  Widget _buildFiestaInfo(
    BuildContext context,
    double width,
    FiestaModel data,
  ) {
    final duo =
        (ref.watch(userChangeNotifierProvider).userData! as FiestarUserModel)
            .duo;

    return Container(
      height: 250.0,
      width: width,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.black, Colors.black.withValues(alpha: 0)],
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 21.0),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                flex: 3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (duo != null) ...[
                      InkWell(
                        onTap: () =>
                            ref.read(homeControllerProvider).jumpToPage(1),
                        child: SizedBox(
                          width: 31.0,
                          height: 31.0,
                          child: Stack(
                            clipBehavior: Clip.none,
                            children: [
                              Positioned(
                                left: 0,
                                top: 0,
                                bottom: 0,
                                child: Container(
                                  width: 31.0,
                                  height: 31.0,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(100),
                                  ),
                                  clipBehavior: Clip.hardEdge,
                                  child: CachedNetworkImage(
                                    imageUrl: duo.pictures!.first,
                                    width: 31.0,
                                    height: 31.0,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              Positioned(
                                right: -8,
                                top: 8,
                                child: Container(
                                  width: 18.0,
                                  height: 18.0,
                                  constraints: const BoxConstraints(
                                    maxHeight: 18.0,
                                  ),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(100),
                                    border: Border.all(color: Colors.black),
                                    color: AppColor.mainColor,
                                  ),
                                  child: Center(
                                    child: SvgPicture.asset(
                                      "assets/svg/ic_lock.svg",
                                      width: 7.0,
                                      colorFilter: const ColorFilter.mode(
                                        Colors.white,
                                        BlendMode.srcIn,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      sh(5),
                    ] else if (_friendWantGoToSameFiesta(data) > 0) ...[
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 31.0,
                            height: 31.0,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(100),
                              color: AppColor.mainColor,
                            ),
                            clipBehavior: Clip.hardEdge,
                            child: Center(
                              child: Text(
                                "+${_friendWantGoToSameFiesta(data)}",
                                style: AppTextStyle.white(14, FontWeight.w600),
                              ),
                            ),
                          ),
                          sw(3),
                          Expanded(
                            child: Text(
                              "Utilisateurs veulent y aller",
                              style: AppTextStyle.white(14, FontWeight.w600),
                            ),
                          ),
                        ],
                      ),
                      sh(5),
                    ],
                    Text(
                      data.title ?? "",
                      style: AppTextStyle.white(26, FontWeight.bold),
                    ),
                    sh(4),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Kilomètres
                        if (data.address?.geopoint != null &&
                            ref.watch(geolocProvider).userPosition != null)
                          Row(
                            children: [
                              SvgPicture.asset(
                                "assets/svg/ic_location_outlined.svg",
                                colorFilter: ColorFilter.mode(
                                  const Color.fromARGB(255, 244, 72, 29),
                                  BlendMode.srcIn,
                                ),
                              ),
                              sw(3),
                              Text(
                                "${(Geolocator.distanceBetween(data.address!.geopoint!.latitude, data.address!.geopoint!.longitude, ref.watch(geolocProvider).userPosition!.latitude, ref.watch(geolocProvider).userPosition!.longitude) / 1000).round()}km",
                                style: TextStyle(
                                  color: const Color(
                                    0xFFFFFFFF,
                                  ).withValues(alpha: .7),
                                  fontSize: sp(13),
                                ),
                              ),
                            ],
                          ),
                        // Date
                        if (data.startAt != null) ...[
                          if (data.address?.geopoint != null &&
                              ref.watch(geolocProvider).userPosition != null)
                            sh(2),
                          Text(
                            "${data.startAt?.day.toString().padLeft(2, "0")}/${data.startAt?.month.toString().padLeft(2, "0")} ${data.startAt?.hour.toString().padLeft(2, "0")}h${data.startAt?.minute.toString().padLeft(2, "0")}",
                            style: TextStyle(
                              color: const Color(
                                0xFFFFFFFF,
                              ).withValues(alpha: .7),
                              fontSize: sp(13),
                            ),
                          ),
                        ],
                      ],
                    ),
                    sh(4),
                    Text(
                      data.description ?? "",
                      style: TextStyle(
                        color: const Color(0xFFFFFFFF).withValues(alpha: .7),
                        fontSize: sp(13),
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 5,
                    ),
                    sh(15),
                  ],
                ),
              ),
              sw(15),
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.end,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    IntrinsicWidth(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10.0,
                          vertical: 6.0,
                        ),
                        decoration: BoxDecoration(
                          border: Border.all(
                            width: 1.3,
                            color: const Color.fromARGB(255, 244, 72, 29),
                          ),
                          color: Colors.white.withValues(alpha: .09),
                          borderRadius: BorderRadius.circular(100),
                        ),
                        child: Text(
                          "+${_numbreOfTags(data.tags)}",
                          style: AppTextStyle.white(11, FontWeight.w500),
                        ),
                      ),
                    ),
                    sh(3),
                    IntrinsicWidth(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10.0,
                          vertical: 6.0,
                        ),
                        decoration: BoxDecoration(
                          border: Border.all(
                            width: 1.3,
                            color: const Color.fromARGB(255, 244, 72, 29),
                          ),
                          color: Colors.white.withValues(alpha: .09),
                          borderRadius: BorderRadius.circular(100),
                        ),
                        child: Text(
                          "app.create-fiesta-form.category-value.${data.category}"
                              .tr(),
                          style: AppTextStyle.white(11, FontWeight.w500),
                        ),
                      ),
                    ),
                    sh(3),
                    IntrinsicWidth(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10.0,
                          vertical: 6.0,
                        ),
                        decoration: BoxDecoration(
                          border: Border.all(
                            width: 1.3,
                            color: const Color.fromARGB(255, 244, 72, 29),
                          ),
                          color: Colors.white.withValues(alpha: .09),
                          borderRadius: BorderRadius.circular(100),
                        ),
                        child: Text(
                          "app.create-fiesta-form.logistic.${data.logistic}"
                              .tr(),
                          style: AppTextStyle.white(11, FontWeight.w500),
                        ),
                      ),
                    ),
                    sh(3),
                    Container(
                      width: 25.0,
                      height: 25.0,
                      decoration: BoxDecoration(
                        border: Border.all(
                          width: 1.3,
                          color: const Color.fromARGB(255, 244, 72, 29),
                        ),
                        color: Colors.white.withValues(alpha: .09),
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: Center(
                        child: SvgPicture.asset(
                          "assets/svg/ic_sound_${data.soundLevel?.toInt() ?? 1}.svg",
                          colorFilter: const ColorFilter.mode(
                            Colors.white,
                            BlendMode.srcIn,
                          ),
                          width: 8.3,
                        ),
                      ),
                    ),
                    sh(7),
                    CTA.primary(
                      width: 120.0,
                      height: 40.0,
                      textButtonStyle: AppTextStyle.white(13, FontWeight.w500),
                      textButton: "utils.more-info".tr(),
                      theme: CtaThemeData(
                        backgroundColor: const Color.fromARGB(255, 244, 72, 29),
                        borderRadius: 100,
                        height: 40.0,
                      ),
                      onTap: () {
                        AutoRouter.of(
                          context,
                        ).navigate(FiestaInfoRoute(data: data));
                      },
                    ),
                    sh(15),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  int _numbreOfTags(List<TagModel>? tags) {
    return tags?.length ?? 0;
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

  Future<void> _showFilterFiesta(BuildContext context) async {
    TextEditingController controller = TextEditingController();
    FocusNode focusNodeSearch = FocusNode();

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
      builder: (context) {
        return Consumer(
          builder: (context, ref, child) {
            return Container(
              padding: EdgeInsets.symmetric(
                horizontal: formatWidth(29),
                vertical: formatHeight(14),
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: formatWidth(47),
                      height: formatHeight(4),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(formatWidth(40)),
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
                        ref.read(fiestaSwipePrefProvider).location = location;
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
                          .watch(fiestaSwipePrefProvider)
                          .visibilty
                          .toDouble(),
                      onChanged: (p0) => ref
                          .read(fiestaSwipePrefProvider)
                          .setVisibility(p0.toInt()),
                      customSliderThumbShape: CustomSliderThumbShape(
                        stringNumber:
                            "${ref.watch(fiestaSwipePrefProvider).visibilty.toString()}km",
                      ),
                    ),
                    sh(26),
                    ModernDropdownField<String>(
                      fieldName: "Type de fiesta",
                      value: ref.watch(fiestaSwipePrefProvider).fiestaType,
                      hintText: "utils.choose".tr(),
                      onChanged: (p0) =>
                          ref.read(fiestaSwipePrefProvider).setFiestaType(p0),
                      items: [
                        DropdownMenuItem(
                          value: 'repas',
                          child: Text('app.tags.fiesta.repas'.tr()),
                        ),
                        DropdownMenuItem(
                          value: 'deguisee',
                          child: Text('app.tags.fiesta.deguisee'.tr()),
                        ),
                        DropdownMenuItem(
                          value: 'soiree',
                          child: Text('app.tags.fiesta.soiree'.tr()),
                        ),
                        DropdownMenuItem(
                          value: 'jeux-de-cartes',
                          child: Text('app.tags.fiesta.jeux-de-cartes'.tr()),
                        ),
                        DropdownMenuItem(
                          value: 'jeux-de-societe',
                          child: Text('app.tags.fiesta.jeux-de-societe'.tr()),
                        ),
                        DropdownMenuItem(
                          value: 'soiree-a-theme',
                          child: Text('app.tags.fiesta.soiree-a-theme'.tr()),
                        ),
                        DropdownMenuItem(
                          value: 'poker',
                          child: Text('app.tags.fiesta.poker'.tr()),
                        ),
                        DropdownMenuItem(
                          value: 'chill',
                          child: Text('app.tags.fiesta.chill'.tr()),
                        ),
                        DropdownMenuItem(
                          value: 'dj-set',
                          child: Text('app.tags.fiesta.dj-set'.tr()),
                        ),
                        DropdownMenuItem(
                          value: 'speciale',
                          child: Text('app.tags.fiesta.speciale'.tr()),
                        ),
                        DropdownMenuItem(
                          value: 'masquee',
                          child: Text('app.tags.fiesta.masquee'.tr()),
                        ),
                        DropdownMenuItem(
                          value: 'concert',
                          child: Text('app.tags.fiesta.concert'.tr()),
                        ),
                        DropdownMenuItem(
                          value: 'entre-potes',
                          child: Text('app.tags.fiesta.entre-potes'.tr()),
                        ),
                        DropdownMenuItem(
                          value: 'gaming',
                          child: Text('app.tags.fiesta.gaming'.tr()),
                        ),
                        DropdownMenuItem(
                          value: 'jeux-alcool',
                          child: Text('app.tags.fiesta.jeux-alcool'.tr()),
                        ),
                        DropdownMenuItem(
                          value: 'before',
                          child: Text('app.tags.fiesta.before'.tr()),
                        ),
                        DropdownMenuItem(
                          value: 'after',
                          child: Text('app.tags.fiesta.after'.tr()),
                        ),
                        DropdownMenuItem(
                          value: 'rave',
                          child: Text('app.tags.fiesta.rave'.tr()),
                        ),
                        DropdownMenuItem(
                          value: 'soiree-match',
                          child: Text('app.tags.fiesta.soiree-match'.tr()),
                        ),
                        DropdownMenuItem(
                          value: 'film',
                          child: Text('app.tags.fiesta.film'.tr()),
                        ),
                        DropdownMenuItem(
                          value: 'apero',
                          child: Text('app.tags.fiesta.apero'.tr()),
                        ),
                        DropdownMenuItem(
                          value: 'karaoke',
                          child: Text('app.tags.fiesta.karaoke'.tr()),
                        ),
                      ],
                    ),
                    sh(32),
                    CTA.primary(
                      textButton: "utils.apply".tr(),
                      onTap: () async {
                        ref.read(fiestaSwipeProvider).clear();
                        await ref
                            .read(fiestaSwipeProvider)
                            .getFiestaList(
                              ref
                                  .read(userChangeNotifierProvider)
                                  .userData!
                                  .email!,
                              metadata: ref
                                  .read(fiestaSwipePrefProvider)
                                  .getMetadata(),
                            );
                        if (!context.mounted) return;
                        Navigator.of(context).pop();
                      },
                    ),
                    sh(16),
                    TextButton(
                      onPressed: () async {
                        ref.read(fiestaSwipePrefProvider).reset();
                        ref.read(fiestaSwipeProvider).clear();
                        await ref
                            .read(fiestaSwipeProvider)
                            .getFiestaList(
                              ref
                                  .read(userChangeNotifierProvider)
                                  .userData!
                                  .email!,
                              metadata: ref
                                  .read(fiestaSwipePrefProvider)
                                  .getMetadata(),
                            );
                        if (!context.mounted) return;
                        Navigator.of(context).pop();
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

  int _friendWantGoToSameFiesta(FiestaModel data) {
    final FiestarUserModel userData =
        ref.read(userChangeNotifierProvider).userData! as FiestarUserModel;
    int i = 0;

    for (final FiestaUserModel userInFiesta in data.participants ?? []) {
      if ((userData.friends
                  ?.map((e) => (e["user"] as DocumentReference).id)
                  .toList() ??
              [])
          .contains(userInFiesta.fiestaRef)) {
        i++;
      }
    }
    return i;
  }

  Widget _buildLockedCard(BuildContext context) {
    final futureFiesta = FirebaseFirestore.instance
        .collection("fiesta")
        .doc(
          (ref.read(userChangeNotifierProvider.notifier).userData!
                  as FiestarUserModel)
              .fiesta!,
        )
        .get()
        .then((e) => FiestaModel.fromJson(e.data()!).copyWith(id: e.id));
    // Debug: Future fiesta data
    return FutureBuilder(
      future: futureFiesta,
      builder: (_, AsyncSnapshot<FiestaModel> snapshot) {
        printInDebug(snapshot.data);
        return Container(
          width: 342.0,
          height: 580.0,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: const Color(0xFFDEDEDE), width: 2),
            color: AppColor.mainColor,
          ),
          padding: const EdgeInsets.fromLTRB(36.0, 56.0, 36.0, 22.0),
          child: Column(
            children: [
              Text(
                "Le swipe est bloqué",
                style: AppTextStyle.white(22, FontWeight.w600),
              ),
              sh(5),
              Text(
                "Tu participes actuellement à une Fiesta.\n\nQuand elle sera terminée, tu pourras swiper de nouveau.",
                style: AppTextStyle.white(15, FontWeight.w400),
                textAlign: TextAlign.center,
              ),
              sh(23.5),
              Container(width: 248.0, color: Colors.white, height: 0.5),
              sh(17.5),
              Text(
                "Ta Fiesta en cours",
                style: AppTextStyle.white(13, FontWeight.w500),
              ),
              sh(24),
              Expanded(
                child: Column(
                  children: [
                    if (snapshot.hasData && snapshot.data != null) ...[
                      Text(
                        snapshot.data!.title ?? "",
                        style: AppTextStyle.white(17, FontWeight.w600),
                      ),
                      sh(9),
                      Text(
                        "Date de fin de la Fiesta",
                        style: AppTextStyle.white(12, FontWeight.w400),
                      ),
                      Text(
                        "${snapshot.data!.endAt?.day} ${DateController.getMonth(snapshot.data!.endAt?.month ?? 0)} ${snapshot.data!.endAt?.year} ${snapshot.data!.endAt?.hour.toString().padLeft(2, "0")}:${snapshot.data!.endAt?.minute.toString().padLeft(2, "0")}",
                        style: AppTextStyle.white(12, FontWeight.w500),
                      ),
                      sh(9),
                      CTA.primary(
                        themeName: "primary_border_white",
                        textButton: "Voir la Fiesta",
                        width: 181.0,
                        height: 43.0,
                        onTap: () {
                          AutoRouter.of(context).navigateNamed(
                            "/dashboard/fiesta/detail/${snapshot.data!.id}",
                          );
                        },
                      ),
                    ],
                  ],
                ),
              ),
              sh(5),
              CTA.primary(
                themeName: "primary_white",
                textButton: "Contacter le Host",
                onTap: () {
                  // Navigation vers la page de chat avec le host de la fiesta
                  final fiestaData = snapshot.data!;
                  AutoRouter.of(context).navigateNamed(
                    "/dashboard/chat/${fiestaData.host?.id ?? ""}",
                  );
                },
              ),
            ],
          ),
        );
        // return const Center(child: LoaderClassique());
      },
    );
  }
}
