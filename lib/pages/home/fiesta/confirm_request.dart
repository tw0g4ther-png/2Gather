import 'package:cached_network_image/cached_network_image.dart';
import 'package:core_kosmos/core_package.dart';
import 'package:twogather/model/color.dart';
import 'package:twogather/model/fiesta/fiesta_model.dart';
import 'package:twogather/widgets/button/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ui_kosmos_v4/ui_kosmos_v4.dart';

class ConfirmRequest extends StatefulHookConsumerWidget {
  final FiestaModel data;

  const ConfirmRequest({super.key, required this.data});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ConfirmRequestState();
}

class _ConfirmRequestState extends ConsumerState<ConfirmRequest> {
  @override
  Widget build(BuildContext context) {
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
                                  imageUrl: widget.data.pictures!.first,
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
                              "Demande envoyée",
                              style: AppTextStyle.white(27, FontWeight.bold),
                            ),
                            sh(7),
                            Text(
                              "Ta demande de participation a bien été enviée au Host.\nIl te répondra au plus vite.",
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
                      textButton: "Terminer",
                      onTap: () {
                        Navigator.of(context).pop();
                      },
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
