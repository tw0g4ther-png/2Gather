import 'package:auto_route/auto_route.dart';
import 'package:core_kosmos/core_kosmos.dart';
import 'package:twogather/model/color.dart';
import 'package:twogather/model/user/fiestar_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:skeleton_kosmos/skeleton_kosmos.dart';
import 'package:timelines_plus/timelines_plus.dart';

@RoutePage()
class LevelPage extends StatefulHookConsumerWidget {
  const LevelPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _LevelPageState();
}

class _LevelPageState extends ConsumerState<LevelPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: Colors.white,
      child: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: formatWidth(27)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                sh(12),
                InkWell(
                  onTap: () => AutoRouter.of(context).back(),
                  child: Icon(
                    Icons.arrow_back_ios_new_rounded,
                    color: Colors.black,
                    size: formatWidth(18),
                  ),
                ),
                sh(18),
                Text("Niveaux et avantages", style: AppTextStyle.black(24)),
                sh(18),
                const Divider(),
                sh(18),
                Text("Mon niveau actuel", style: AppTextStyle.black(15)),
                sh(11),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(
                      horizontal: formatWidth(9), vertical: formatWidth(7)),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      color: AppColor.mainColor.withValues(alpha: .07)),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Container(
                        width: formatWidth(39),
                        height: formatWidth(39),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100),
                            color: AppColor.mainColor),
                        child: Center(
                          child: SvgPicture.asset(
                            "assets/svg/ic_crown.svg",
                            colorFilter:
                                ColorFilter.mode(Colors.white, BlendMode.srcIn),
                          ),
                        ),
                      ),
                      sw(16),
                      Expanded(
                          child: Text(
                              "Niveau ${((ref.watch(userChangeNotifierProvider).userData! as FiestarUserModel).level ?? 1).toInt()}",
                              style:
                                  AppTextStyle.darkGray(14, FontWeight.w500))),
                    ],
                  ),
                ),
                sh(22),
                Text("Débloquer les prochains niveaux",
                    style: AppTextStyle.black(15)),
                sh(9),
                Row(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Stack(
                      children: [
                        SizedBox(
                          height: formatHeight(88),
                          width: formatWidth(39),
                        ),
                        Positioned(
                          bottom: 0,
                          child: SizedBox(
                            height: formatHeight(48),
                            width: formatWidth(39),
                            child: DashedLineConnector(
                              color: const Color(0xFF02132B).withValues(alpha: .26),
                            ),
                          ),
                        ),
                        Positioned(
                          top: 0,
                          bottom: 0,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: formatWidth(39),
                                height: formatWidth(39),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(100),
                                  color:
                                      ((ref.watch(userChangeNotifierProvider).userData!
                                                              as FiestarUserModel)
                                                          .level ??
                                                      1)
                                                  .toInt() >
                                              2
                                          ? AppColor.mainColor
                                          : const Color(0xFF02132B),
                                ),
                                child: Center(
                                  child: SvgPicture.asset(
                                    "assets/svg/ic_crown.svg",
                                    colorFilter: ColorFilter.mode(
                                        Colors.white, BlendMode.srcIn),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    sw(16),
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: formatWidth(17),
                            vertical: formatHeight(11)),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(7),
                            color:
                                ((ref.watch(userChangeNotifierProvider).userData!
                                                        as FiestarUserModel)
                                                    .level ??
                                                1)
                                            .toInt() >
                                        2
                                    ? AppColor.mainColor.withValues(alpha: .07)
                                    : const Color(0xFFF5F5F5).withValues(alpha: .67)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Niveau 2", style: AppTextStyle.black(14)),
                            sh(2),
                            Text(
                                ((ref.watch(userChangeNotifierProvider).userData!
                                                        as FiestarUserModel)
                                                    .level ??
                                                1)
                                            .toInt() >
                                        2
                                    ? "Tu as déjà atteint ce niveau"
                                    : "Pour atteindre le niveau 2 tu dois organiser 10 Fiestas",
                                style:
                                    AppTextStyle.darkGray(11, FontWeight.w400)),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Stack(
                      children: [
                        SizedBox(
                          height: formatHeight(88),
                          width: formatWidth(39),
                          child: DashedLineConnector(
                            color: const Color(0xFF02132B).withValues(alpha: .26),
                          ),
                        ),
                        Positioned(
                          top: 0,
                          bottom: 0,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: formatWidth(39),
                                height: formatWidth(39),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(100),
                                  color:
                                      ((ref.watch(userChangeNotifierProvider).userData!
                                                              as FiestarUserModel)
                                                          .level ??
                                                      1)
                                                  .toInt() >
                                              3
                                          ? AppColor.mainColor
                                          : const Color(0xFF02132B),
                                ),
                                child: Center(
                                  child: SvgPicture.asset(
                                    "assets/svg/ic_crown.svg",
                                    colorFilter: ColorFilter.mode(
                                        Colors.white, BlendMode.srcIn),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    sw(16),
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: formatWidth(17),
                            vertical: formatHeight(11)),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(7),
                            color:
                                ((ref.watch(userChangeNotifierProvider).userData!
                                                        as FiestarUserModel)
                                                    .level ??
                                                1)
                                            .toInt() >
                                        3
                                    ? AppColor.mainColor.withValues(alpha: .07)
                                    : const Color(0xFFF5F5F5).withValues(alpha: .67)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Niveau 3", style: AppTextStyle.black(14)),
                            sh(2),
                            Text(
                                ((ref.watch(userChangeNotifierProvider).userData!
                                                        as FiestarUserModel)
                                                    .level ??
                                                1)
                                            .toInt() >
                                        3
                                    ? "Tu as déjà atteint ce niveau"
                                    : "Pour atteindre le niveau 3 tu dois organiser 10 Fiestas",
                                style:
                                    AppTextStyle.darkGray(11, FontWeight.w400)),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Stack(
                      children: [
                        SizedBox(
                          height: formatHeight(88),
                          width: formatWidth(39),
                          child: DashedLineConnector(
                            color: const Color(0xFF02132B).withValues(alpha: .26),
                          ),
                        ),
                        Positioned(
                          top: 0,
                          bottom: 0,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: formatWidth(39),
                                height: formatWidth(39),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(100),
                                  color:
                                      ((ref.watch(userChangeNotifierProvider).userData!
                                                              as FiestarUserModel)
                                                          .level ??
                                                      1)
                                                  .toInt() >
                                              4
                                          ? AppColor.mainColor
                                          : const Color(0xFF02132B),
                                ),
                                child: Center(
                                  child: SvgPicture.asset(
                                    "assets/svg/ic_crown.svg",
                                    colorFilter: ColorFilter.mode(
                                        Colors.white, BlendMode.srcIn),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    sw(16),
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: formatWidth(17),
                            vertical: formatHeight(11)),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(7),
                            color:
                                ((ref.watch(userChangeNotifierProvider).userData!
                                                        as FiestarUserModel)
                                                    .level ??
                                                1)
                                            .toInt() >
                                        4
                                    ? AppColor.mainColor.withValues(alpha: .07)
                                    : const Color(0xFFF5F5F5).withValues(alpha: .67)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Niveau 4", style: AppTextStyle.black(14)),
                            sh(2),
                            Text(
                                ((ref.watch(userChangeNotifierProvider).userData!
                                                        as FiestarUserModel)
                                                    .level ??
                                                1)
                                            .toInt() >
                                        4
                                    ? "Tu as déjà atteint ce niveau"
                                    : "Pour atteindre le niveau 4 tu dois organiser 10 Fiestas",
                                style:
                                    AppTextStyle.darkGray(11, FontWeight.w400)),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Stack(
                      children: [
                        SizedBox(
                          height: formatHeight(88),
                          width: formatWidth(39),
                        ),
                        Positioned(
                          top: 0,
                          child: SizedBox(
                            height: formatHeight(48),
                            width: formatWidth(39),
                            child: DashedLineConnector(
                              color: const Color(0xFF02132B).withValues(alpha: .26),
                            ),
                          ),
                        ),
                        Positioned(
                          top: 0,
                          bottom: 0,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: formatWidth(39),
                                height: formatWidth(39),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(100),
                                  color:
                                      ((ref.watch(userChangeNotifierProvider).userData!
                                                              as FiestarUserModel)
                                                          .level ??
                                                      1)
                                                  .toInt() >
                                              5
                                          ? AppColor.mainColor
                                          : const Color(0xFF02132B),
                                ),
                                child: Center(
                                  child: SvgPicture.asset(
                                    "assets/svg/ic_crown.svg",
                                    colorFilter: ColorFilter.mode(
                                        Colors.white, BlendMode.srcIn),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    sw(16),
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: formatWidth(17),
                            vertical: formatHeight(11)),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(7),
                            color:
                                ((ref.watch(userChangeNotifierProvider).userData!
                                                        as FiestarUserModel)
                                                    .level ??
                                                1)
                                            .toInt() >
                                        5
                                    ? AppColor.mainColor.withValues(alpha: .07)
                                    : const Color(0xFFF5F5F5).withValues(alpha: .67)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Niveau 5", style: AppTextStyle.black(14)),
                            sh(2),
                            Text(
                                ((ref.watch(userChangeNotifierProvider).userData!
                                                        as FiestarUserModel)
                                                    .level ??
                                                1)
                                            .toInt() >
                                        5
                                    ? "Tu as déjà atteint ce niveau"
                                    : "Pour atteindre le niveau 5 tu dois organiser 10 Fiestas",
                                style:
                                    AppTextStyle.darkGray(11, FontWeight.w400)),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
