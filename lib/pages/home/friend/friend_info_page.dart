import 'package:auto_route/auto_route.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:core_kosmos/core_package.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:twogather/model/color.dart';
import 'package:twogather/model/passion/passion_listing.dart';
import 'package:twogather/model/passion/passion_model.dart';
import 'package:twogather/model/user/app_user/app_user_model.dart';
import 'package:twogather/pages/home_page.dart';
import 'package:twogather/services/birthday.dart';
import 'package:twogather/widgets/button/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

@RoutePage()
class FriendInfoPage extends StatefulHookConsumerWidget {
  final AppUserModel user;

  const FriendInfoPage({super.key, required this.user});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _FriendInfoPageState();
}

class _FriendInfoPageState extends ConsumerState<FriendInfoPage> {
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
            body: Stack(
              children: [
                SizedBox(
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height * .8,
                  child: PageView(
                    controller: _pageController,
                    children: [
                      ...widget.user.pictures?.map(
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
                  bottom: formatWidth(300),
                  left: 0,
                  right: 0,
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      for (
                        var i = 0;
                        i < (widget.user.pictures?.length ?? 0);
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
                                (widget.user.pictures?.length.round() ?? 0) - 1)
                              sw(3),
                          ],
                        ),
                    ],
                  ),
                ),
              ],
            ),
            color: Colors.transparent,
            minHeight: formatHeight(280),
            maxHeight: formatHeight(600),
            panel: Container(
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
                      widget.user.firstname ?? "",
                      style: AppTextStyle.black(23, FontWeight.bold),
                    ),
                    Text(
                      "${widget.user.position != null && ref.watch(geolocProvider).userPosition != null ? "${(Geolocator.distanceBetween(widget.user.position!.latitude, widget.user.position!.longitude, ref.watch(geolocProvider).userPosition!.latitude, ref.watch(geolocProvider).userPosition!.longitude) / 1000).round()}km - " : ""}${widget.user.country != null ? "${widget.user.country!} - " : ""}${(DateTime.now().difference(widget.user.birthday ?? DateTime.now())).formatToGetAge()} ans",
                      style: AppTextStyle.darkBlue(14, FontWeight.w500),
                    ),
                    sh(15.6),
                    const Divider(),
                    sh(14),
                    Text("utils.details".tr(), style: AppTextStyle.black(15)),
                    sh(6.5),
                    Text(
                      "utils.tags".tr(),
                      style: AppTextStyle.gray(12, FontWeight.w400),
                    ),
                    sh(4.5),
                    Wrap(
                      spacing: formatWidth(8),
                      runSpacing: formatHeight(8),
                      children: _getListOfTags(widget.user.tags)
                          .map(
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
                          .toList(),
                    ),
                    sh(12.7),
                    Text(
                      widget.user.description ?? "",
                      style: AppTextStyle.gray(13, FontWeight.w400),
                    ),
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
                    Button(
                      decoration: BoxDecoration(
                        color: const Color(0xFF021119).withValues(alpha: .5),
                        borderRadius: BorderRadius.circular(28),
                      ),
                      onTap: () => AutoRouter.of(
                        context,
                      ).navigateNamed("/dashboard/report/${widget.user.id!}"),
                      height: formatWidth(46),
                      width: formatWidth(46),
                      child: Center(
                        child: SvgPicture.asset("assets/svg/ic_report.svg"),
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

  List<PassionModel> _getListOfTags(PassionListing? tags) {
    List<PassionModel> ret = [];
    tags?.drink?.forEach((element) => ret.add(element));
    tags?.fiesta?.forEach((element) => ret.add(element));
    tags?.music?.forEach((element) => ret.add(element));
    tags?.passion?.forEach((element) => ret.add(element));
    return ret;
  }
}
