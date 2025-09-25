import 'package:auto_route/auto_route.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:core_kosmos/core_kosmos.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:twogather/model/color.dart';
import 'package:twogather/model/fiesta/fiesta_model.dart';
import 'package:twogather/pages/home_page.dart';
import 'package:twogather/widgets/button/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

@RoutePage()
class FiestaInfoPage extends StatefulHookConsumerWidget {
  final FiestaModel data;
  final bool showAdress;

  const FiestaInfoPage({
    super.key,
    required this.data,
    this.showAdress = false,
  });

  @override
  ConsumerState<FiestaInfoPage> createState() => _FiestaInfoPageState();
}

class _FiestaInfoPageState extends ConsumerState<FiestaInfoPage> {
  final PageController _pageController = PageController();
  int page = 0;

  @override
  void initState() {
    _pageController.addListener(() {
      setState(() {
        page = _pageController.page?.round() ?? 0;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: SlidingUpPanel(
            color: Colors.transparent,
            minHeight: formatHeight(380),
            maxHeight: formatHeight(600),
            body: Stack(
              children: [
                SizedBox(
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height * .8,
                  child: PageView(
                    controller: _pageController,
                    children: [
                      ...widget.data.pictures?.map(
                            (e) => CachedNetworkImage(
                              imageUrl: e,
                              fit: BoxFit.cover,
                              width: double.infinity,
                              height: MediaQuery.of(context).size.height * .8,
                            ),
                          ) ??
                          [],
                    ],
                  ),
                ),
                Positioned(
                  bottom: formatWidth(400),
                  left: 0,
                  right: 0,
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      for (
                        var i = 0;
                        i < (widget.data.pictures?.length ?? 0);
                        i++
                      )
                        Row(
                          children: [
                            AnimatedContainer(
                              width: 5,
                              height: 5,
                              duration: const Duration(milliseconds: 200),
                              decoration: BoxDecoration(
                                color: page == i
                                    ? Colors.white
                                    : Colors.white.withValues(alpha: .65),
                                borderRadius: BorderRadius.circular(50),
                              ),
                            ),
                            if (i !=
                                (widget.data.pictures?.length.round() ?? 0) - 1)
                              sw(3),
                          ],
                        ),
                    ],
                  ),
                ),
              ],
            ),
            panelBuilder: (sc) => Container(
              padding: EdgeInsets.symmetric(
                vertical: formatHeight(14),
                horizontal: formatWidth(30),
              ),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(28),
                  topRight: Radius.circular(28),
                ),
              ),
              child: SingleChildScrollView(
                controller: sc,
                physics: const ClampingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Container(
                        width: formatWidth(39),
                        height: formatHeight(4),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          color: const Color(0xFFDDDFE2),
                        ),
                      ),
                    ),
                    sh(15.6),
                    Text(
                      widget.data.title ?? "",
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
                          widget.data.address?.geopoint != null &&
                                  ref.watch(geolocProvider).userPosition != null
                              ? "${(Geolocator.distanceBetween(widget.data.address!.geopoint!.latitude, widget.data.address!.geopoint!.longitude, ref.watch(geolocProvider).userPosition!.latitude, ref.watch(geolocProvider).userPosition!.longitude) / 1000).round()}km"
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
                          "${(widget.data.participants?.where((element) => element.status == "accepted").toList() ?? []).length} / ${widget.data.numberOfParticipant?.toInt() ?? 0} participants",
                          style: TextStyle(
                            color: const Color(0xFF5A6575),
                            fontSize: sp(13),
                          ),
                        ),
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
                          "utils.sound.${(widget.data.soundLevel ?? 1).toInt()}"
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
                            style: AppTextStyle.black(15, FontWeight.bold),
                          ),
                        ),
                        Flexible(
                          child: Container(
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
                              "app.create-fiesta-form.category-value.${widget.data.category}"
                                  .tr(),
                              style: AppTextStyle.mainColor(
                                15,
                                FontWeight.w500,
                              ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Text("Tags", style: AppTextStyle.gray(12, FontWeight.w400)),
                    sh(4.5),
                    Wrap(
                      spacing: formatWidth(8),
                      runSpacing: formatHeight(8),
                      children:
                          widget.data.tags
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
                                    borderRadius: BorderRadius.circular(100),
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
                      widget.data.description ?? "",
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
                              imageUrl: widget.data.host!.pictures?.first ?? "",
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        sw(13),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.data.host!.firstname ?? "",
                                style: AppTextStyle.black(16, FontWeight.w500),
                              ),
                              Text(
                                "Host de la Fiesta",
                                style: AppTextStyle.gray(12, FontWeight.w400),
                              ),
                            ],
                          ),
                        ),
                        sw(13),

                        // Bouton pour ouvrir le chat de la fiesta
                        InkWell(
                          onTap: () {
                            AutoRouter.of(context).navigateNamed(
                              "/dashboard/chat/fiesta_${widget.data.id}",
                            );
                          },
                          child: SvgPicture.asset("assets/svg/ic_message.svg"),
                        ),
                      ],
                    ),
                    sh(20),
                    const Divider(),
                    sh(20),
                    Text("Date", style: AppTextStyle.gray(12, FontWeight.w400)),
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: "du ",
                            style: AppTextStyle.gray(13, FontWeight.w400),
                          ),
                          TextSpan(
                            text:
                                "${widget.data.startAt?.day.toString().padLeft(2, "0")}/${widget.data.startAt?.month.toString().padLeft(2, "0")}/${widget.data.startAt?.year.toString().padLeft(2, "0")} ${widget.data.startAt?.hour.toString().padLeft(2, "0")}:${widget.data.startAt?.minute.toString().padLeft(2, "0")}",
                            style: AppTextStyle.darkGray(13, FontWeight.w600),
                          ),
                          TextSpan(
                            text: " au ",
                            style: AppTextStyle.gray(13, FontWeight.w400),
                          ),
                          TextSpan(
                            text:
                                "${widget.data.startAt?.day.toString().padLeft(2, "0")}/${widget.data.startAt?.month.toString().padLeft(2, "0")}/${widget.data.startAt?.year.toString().padLeft(2, "0")} ${widget.data.startAt?.hour.toString().padLeft(2, "0")}:${widget.data.startAt?.minute.toString().padLeft(2, "0")}",
                            style: AppTextStyle.darkGray(13, FontWeight.w600),
                          ),
                        ],
                      ),
                    ),
                    if (widget.showAdress) ...[
                      sh(7),
                      Text(
                        "Adresse",
                        style: AppTextStyle.gray(12, FontWeight.w400),
                      ),
                      Text(
                        widget.data.address?.formattedText ?? "",
                        style: AppTextStyle.darkGray(14, FontWeight.w600),
                      ),
                    ],
                    sh(7),
                    Text(
                      "Nombre de participants max.",
                      style: AppTextStyle.gray(12, FontWeight.w400),
                    ),
                    Text(
                      widget.data.numberOfParticipant?.toInt().toString() ?? "",
                      style: AppTextStyle.darkGray(14, FontWeight.w600),
                    ),
                    sh(7),
                    Text(
                      "Niveau sonore",
                      style: AppTextStyle.gray(12, FontWeight.w400),
                    ),
                    Text(
                      "utils.sound.${widget.data.soundLevel?.toInt() ?? 1}"
                          .tr(),
                      style: AppTextStyle.darkGray(14, FontWeight.w600),
                    ),
                    sh(7),
                    if (widget.data.thingToBring != null &&
                        widget.data.thingToBring!.isNotEmpty) ...[
                      Text(
                        "List des choses à ramener",
                        style: AppTextStyle.gray(12, FontWeight.w400),
                      ),
                      Wrap(
                        spacing: formatWidth(8),
                        runSpacing: formatHeight(8),
                        children:
                            widget.data.thingToBring
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
                                      borderRadius: BorderRadius.circular(100),
                                      color: AppColor.mainColor.withValues(
                                        alpha: .11,
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
                    ],
                  ],
                ),
              ),
            ),
          ),
        ),
        SafeArea(
          child: Column(
            children: [
              sh(10),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: formatWidth(26)),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Button(
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
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
