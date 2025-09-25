import '../../riverpods/animations_notifier.dart';
import '../../riverpods/salon_messages_notifier.dart';
import '../../riverpods/salon_river.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:vibration/vibration.dart';
import 'package:shimmer/shimmer.dart';
import 'package:vector_math/vector_math_64.dart' as vector_math;

Widget slideToDelete(double widthToRemove) => Stack(
  children: [
    Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Shimmer.fromColors(
            baseColor: Colors.black12,
            direction: ShimmerDirection.rtl,
            highlightColor: Colors.white,
            loop: 100,
            child: Container(
              margin: EdgeInsets.only(top: 0.h),
              height: 40,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SvgPicture.asset("assets/svg/arrowLeft.svg"),
                  const SizedBox(width: 10),
                  Text(
                    'Glissez pour annuler',
                    overflow: TextOverflow.visible,
                    style: TextStyle(
                      color: const Color(0XFFC3C3C3),
                      fontSize: 15.sp,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        SizedBox(width: widthToRemove < 0 ? -widthToRemove : 0),
      ],
    ),
  ],
);
Widget lockedScreen(WidgetRef ref, {required VoidCallback stopRecording}) =>
    Stack(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Shimmer.fromColors(
                baseColor: const Color(0XFFF00B40),
                direction: ShimmerDirection.rtl,
                highlightColor: Colors.white,
                loop: 100,
                child: Container(
                  margin: EdgeInsets.only(top: 0.h),
                  height: 40,
                  child: InkWell(
                    onTap: () {
                      ref.read(animationController).play();

                      Future.delayed(const Duration(seconds: 2)).then((value) {
                        Vibration.vibrate(duration: 100);
                        stopRecording();
                        ref
                            .read(salonMessagesNotifier)
                            .setBottomBarState(BottomBarState.normal);
                        ref.read(animationController).reset();
                      });
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(width: 40.w),
                        Text(
                          'annuler',
                          style: TextStyle(
                            color: const Color(0XFFF00B40),
                            fontSize: 15.sp,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );

class WhatsAppMicAnimation extends ConsumerStatefulWidget {
  const WhatsAppMicAnimation({super.key});

  @override
  WhatsAppMicAnimationState createState() => WhatsAppMicAnimationState();
}

class WhatsAppMicAnimationState extends ConsumerState<WhatsAppMicAnimation> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _buildMicAnimation();
  }

  Widget _buildMicAnimation() {
    return Padding(
      padding: const EdgeInsets.only(left: 18.0),
      child: ref.watch(animationController).animationController != null
          ? Column(
              children: [
                AnimatedBuilder(
                  animation: ref
                      .watch(animationController)
                      .animationController!,
                  builder: (context, child) {
                    return Transform(
                      transform: Matrix4.identity()
                        ..translateByVector3(vector_math.Vector3(0.0, 10, 0.0))
                        ..translateByVector3(
                          vector_math.Vector3(
                            ref
                                .watch(animationController)
                                .micTranslateRight
                                .value,
                            0.0,
                            0.0,
                          ),
                        )
                        ..translateByVector3(
                          vector_math.Vector3(
                            ref
                                .watch(animationController)
                                .micTranslateLeft
                                .value,
                            0.0,
                            0.0,
                          ),
                        )
                        ..translateByVector3(
                          vector_math.Vector3(
                            0.0,
                            ref
                                .watch(animationController)
                                .micTranslateTop
                                .value,
                            0.0,
                          ),
                        )
                        ..translateByVector3(
                          vector_math.Vector3(
                            0.0,
                            ref
                                .watch(animationController)
                                .micTranslateDown
                                .value,
                            0.0,
                          ),
                        )
                        ..translateByVector3(
                          vector_math.Vector3(
                            0.0,
                            ref
                                .watch(animationController)
                                .micInsideTrashTranslateDown
                                .value,
                            0.0,
                          ),
                        ),
                      child: Transform.rotate(
                        angle: ref
                            .watch(animationController)
                            .micRotationFirst
                            .value,
                        child: Transform.rotate(
                          angle: ref
                              .watch(animationController)
                              .micRotationSecond
                              .value,
                          child: child,
                        ),
                      ),
                    );
                  },
                  child: SvgPicture.asset(
                    "assets/svg/mic.svg",
                    colorFilter: const ColorFilter.mode(
                      Color(0XFFF00B40),
                      BlendMode.srcIn,
                    ),
                  ),
                ),
                AnimatedBuilder(
                  animation: ref
                      .watch(animationController)
                      .trashWithCoverTranslateTop,
                  builder: (context, child) {
                    return Transform(
                      transform: Matrix4.identity()
                        ..translateByVector3(
                          vector_math.Vector3(
                            0.0,
                            ref
                                .watch(animationController)
                                .trashWithCoverTranslateTop
                                .value,
                            0.0,
                          ),
                        )
                        ..translateByVector3(
                          vector_math.Vector3(
                            0.0,
                            ref
                                .watch(animationController)
                                .trashWithCoverTranslateDown
                                .value,
                            0.0,
                          ),
                        ),
                      child: child,
                    );
                  },
                  child: Column(
                    children: [
                      AnimatedBuilder(
                        animation: ref
                            .watch(animationController)
                            .trashCoverRotationFirst,
                        builder: (context, child) {
                          return Transform(
                            transform: Matrix4.identity()
                              ..translateByVector3(
                                vector_math.Vector3(
                                  ref
                                      .watch(animationController)
                                      .trashCoverTranslateLeft
                                      .value,
                                  0.0,
                                  0.0,
                                ),
                              )
                              ..translateByVector3(
                                vector_math.Vector3(
                                  ref
                                      .watch(animationController)
                                      .trashCoverTranslateRight
                                      .value,
                                  0.0,
                                  0.0,
                                ),
                              ),
                            child: Transform.rotate(
                              angle: ref
                                  .watch(animationController)
                                  .trashCoverRotationSecond
                                  .value,
                              child: Transform.rotate(
                                angle: ref
                                    .watch(animationController)
                                    .trashCoverRotationFirst
                                    .value,
                                child: child,
                              ),
                            ),
                          );
                        },
                        child: const Image(
                          image: AssetImage('assets/png/trash_cover.png'),
                          width: 30,
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.only(top: 9),
                        child: Image(
                          image: AssetImage('assets/png/trash_container.png'),
                          width: 30,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            )
          : const SizedBox(),
    );
  }
}
