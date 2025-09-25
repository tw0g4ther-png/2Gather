import 'package:twogather/widgets/slidable_card/core.dart';
import 'package:flutter/material.dart';

class CardAnimationProvider with ChangeNotifier {
  Offset initialPosition = const Offset(0, 0);
  double dx = 0.0;
  double dy = 0.0;
  SwipingDirection direction = SwipingDirection.none;

  void initDrag(Offset position) {
    initialPosition = position;
    notifyListeners();
  }

  void updatePosition(Offset newPosition) {
    dx = newPosition.dx - initialPosition.dx;
    dy = newPosition.dy - initialPosition.dy;
    if (dx > 0) {
      direction = SwipingDirection.right;
    } else if (dx < 0) {
      direction = SwipingDirection.left;
    }
    notifyListeners();
  }

  void resetPosition() async {
    if (dx > initialPosition.dx) {
      while (dx > 0) {
        await Future.delayed(const Duration(microseconds: 800), () {
          dx = dx - 1;
          notifyListeners();
        });
      }
    } else if (dx < initialPosition.dx) {
      while (dx < 0) {
        await Future.delayed(const Duration(microseconds: 800), () {
          dx = dx + 1;
          notifyListeners();
        });
      }
    }

    if (dy > initialPosition.dy) {
      while (dy > 0) {
        await Future.delayed(const Duration(microseconds: 800), () {
          dy = dy - 1;
          notifyListeners();
        });
      }
    } else if (dy < initialPosition.dy) {
      while (dy < 0) {
        await Future.delayed(const Duration(microseconds: 800), () {
          dy = dy + 1;
          notifyListeners();
        });
      }
    }
    dy = 0;
    dx = 0;
    notifyListeners();
  }
}
