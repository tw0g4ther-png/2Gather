import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final animationController = ChangeNotifierProvider<AnimationControllerNotif>((ref) {
  return AnimationControllerNotif();
});

class AnimationControllerNotif with ChangeNotifier {
  AnimationController? animationController;
  late Animation<double> micTranslateTop;
  late Animation<double> micRotationFirst;
  late Animation<double> micTranslateRight;
  late Animation<double> micTranslateLeft;
  late Animation<double> micRotationSecond;
  late Animation<double> micTranslateDown;
  late Animation<double> micInsideTrashTranslateDown;
  //Trash Can
  late Animation<double> trashWithCoverTranslateTop;
  late Animation<double> trashCoverRotationFirst;
  late Animation<double> trashCoverTranslateLeft;
  late Animation<double> trashCoverRotationSecond;
  late Animation<double> trashCoverTranslateRight;
  late Animation<double> trashWithCoverTranslateDown;

  void init(TickerProvider vsync) {
    animationController = AnimationController(
      vsync: vsync,
      duration: const Duration(milliseconds: 2500),
    );

    //Mic

    micTranslateTop = Tween(begin: 0.0, end: -150.0).animate(
      CurvedAnimation(
        parent: animationController!,
        curve: const Interval(0.0, 0.45, curve: Curves.easeOut),
      ),
    );

    micRotationFirst = Tween(begin: 0.0, end: pi).animate(
      CurvedAnimation(
        parent: animationController!,
        curve: const Interval(0.0, 0.2),
      ),
    );

    micTranslateRight = Tween(begin: 0.0, end: 13.0).animate(
      CurvedAnimation(
        parent: animationController!,
        curve: const Interval(0.0, 0.1),
      ),
    );

    micTranslateLeft = Tween(begin: 0.0, end: -13.0).animate(
      CurvedAnimation(
        parent: animationController!,
        curve: const Interval(0.1, 0.2),
      ),
    );

    micRotationSecond = Tween(begin: 0.0, end: pi).animate(
      CurvedAnimation(
        parent: animationController!,
        curve: const Interval(0.2, 0.45),
      ),
    );

    micTranslateDown = Tween(begin: 0.0, end: 150.0).animate(
      CurvedAnimation(
        parent: animationController!,
        curve: const Interval(0.45, 0.79, curve: Curves.easeInOut),
      ),
    );

    micInsideTrashTranslateDown = Tween(begin: 0.0, end: 55.0).animate(
      CurvedAnimation(
        parent: animationController!,
        curve: const Interval(0.95, 1.0, curve: Curves.easeInOut),
      ),
    );

    //Trash Can

    trashWithCoverTranslateTop = Tween(begin: 30.0, end: -25.0).animate(
      CurvedAnimation(
        parent: animationController!,
        curve: const Interval(0.45, 0.6),
      ),
    );

    trashCoverRotationFirst = Tween(begin: 0.0, end: -pi / 3).animate(
      CurvedAnimation(
        parent: animationController!,
        curve: const Interval(0.6, 0.7),
      ),
    );

    trashCoverTranslateLeft = Tween(begin: 0.0, end: -18.0).animate(
      CurvedAnimation(
        parent: animationController!,
        curve: const Interval(0.6, 0.7),
      ),
    );

    trashCoverRotationSecond = Tween(begin: 0.0, end: pi / 3).animate(
      CurvedAnimation(
        parent: animationController!,
        curve: const Interval(0.8, 0.9),
      ),
    );

    trashCoverTranslateRight = Tween(begin: 0.0, end: 18.0).animate(
      CurvedAnimation(
        parent: animationController!,
        curve: const Interval(0.8, 0.9),
      ),
    );

    trashWithCoverTranslateDown = Tween(begin: 0.0, end: 55.0).animate(
      CurvedAnimation(
        parent: animationController!,
        curve: const Interval(0.95, 1.0, curve: Curves.easeInOut),
      ),
    );
    notifyListeners();
  }

  void play() async {
    await animationController!.forward();
  }

  void reset() {
    animationController!.reset();
  }

  @override
  void dispose() {
    animationController!.dispose();
    super.dispose();
  }
}
