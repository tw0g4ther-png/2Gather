import 'package:auto_route/auto_route.dart';
import 'package:core_kosmos/core_package.dart';
import 'package:twogather/model/color.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:skeleton_kosmos/skeleton_kosmos.dart';
import 'package:ui_kosmos_v4/cta/cta.dart';

@RoutePage()
class ReportSuccessPage extends HookConsumerWidget {
  const ReportSuccessPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ClampingPage(
      useSafeArea: true,
      child: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: Stack(
          children: [
            SizedBox(
              width: double.infinity,
              height: double.infinity,
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: formatWidth(50),
                    height: formatWidth(50),
                    decoration: BoxDecoration(
                      color: AppColor.mainColor,
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: Center(
                      child: Icon(
                        Icons.check_rounded,
                        color: Colors.white,
                        size: formatWidth(30),
                      ),
                    ),
                  ),
                  sh(20),
                  Text("Envoyé",
                      textAlign: TextAlign.center,
                      style: AppTextStyle.black(24)),
                  sh(8),
                  Text(
                    "Ton signalement a bien été envoyé.",
                    style: AppTextStyle.darkGray(13, FontWeight.w400),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            Positioned(
              bottom: formatHeight(30),
              left: 0,
              right: 0,
              child: CTA.primary(
                textButton: "Terminer",
                width: formatWidth(317),
                onTap: () => AutoRouter.of(context).back(),
              ),
            ),
            Positioned(
              top: formatHeight(20),
              child: CTA.back(onTap: () => AutoRouter.of(context).back()),
            ),
          ],
        ),
      ),
    );
  }
}
