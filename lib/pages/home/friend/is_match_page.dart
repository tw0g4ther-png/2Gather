import 'package:auto_route/auto_route.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:core_kosmos/core_package.dart';
import 'package:twogather/model/color.dart';
import 'package:twogather/model/user/app_user/app_user_model.dart';
import 'package:twogather/pages/home_page.dart';
import 'package:twogather/widgets/button/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ui_kosmos_v4/cta/cta.dart';

@RoutePage()
class IsMatchPage extends ConsumerWidget {
  final AppUserModel user;

  const IsMatchPage({super.key, required this.user});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: AppColor.mainColor,
        body: SafeArea(
          child: Stack(
            children: [
              const SizedBox(width: double.infinity, height: double.infinity),
              Positioned(
                top: formatHeight(20),
                right: formatWidth(29),
                child: Button(
                  onTap: () => Navigator.of(context).pop(),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    color: const Color(0xFF02132B).withValues(alpha: .13),
                  ),
                  width: formatWidth(47),
                  height: formatWidth(47),
                  child: SvgPicture.asset("assets/svg/ic_close.svg"),
                ),
              ),
              Center(
                child: Transform.translate(
                  offset: Offset(0, formatHeight(-80)),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        width: formatWidth(250),
                        height: formatHeight(226),
                        child: Stack(
                          children: [
                            Image.asset(
                              "assets/images/img_match_bg.png",
                              width: formatWidth(250),
                              height: formatHeight(226),
                              fit: BoxFit.cover,
                            ),
                            Center(
                              child: Container(
                                width: formatWidth(183),
                                height: formatWidth(183),
                                clipBehavior: Clip.hardEdge,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(
                                    formatWidth(183),
                                  ),
                                ),
                                child: CachedNetworkImage(
                                  imageUrl: user.pictures!.first,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      sh(35),
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: formatWidth(39),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              "Connexion !",
                              style: AppTextStyle.white(27, FontWeight.bold),
                            ),
                            sh(7),
                            Text(
                              "Tu as une nouvelle connexion.\nElle pourra t’être proposée dans la partie swipe Fiesta !",
                              style: AppTextStyle.white(13, FontWeight.w400),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                bottom: formatHeight(30),
                left: 0,
                right: 0,
                child: Column(
                  children: [
                    CTA.primary(
                      themeName: "primary_white",
                      textButton: "Swipper des Fiestas",
                      onTap: () {
                        ref.read(homeControllerProvider).jumpToPage(2);
                        Navigator.of(context).pop();
                      },
                    ),
                    sh(10),
                    CTA.primary(
                      themeName: "primary_border_white",
                      textButton: "Continuer de Swiper",
                      onTap: () => Navigator.of(context).pop(),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
