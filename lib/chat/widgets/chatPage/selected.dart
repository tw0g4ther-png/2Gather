import '../../riverpods/salon_river.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vibration/vibration.dart';

Widget selected({required WidgetRef ref, required child, required String childId}) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 8.0),
    child: GestureDetector(
      onTap: ref.watch(salonMessagesNotifier).listMessageSelectedMessage.isEmpty
          ? null
          : () {
              ref.read(salonMessagesNotifier).tapOnMessage(childId);
            },
      onLongPress: () async {
        if (await Vibration.hasVibrator() == true) {
          Vibration.vibrate(duration: 100);
          ref.read(salonMessagesNotifier).tapOnMessage(childId);
        }
      },
      child: Stack(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 15.w),
            child: child,
          ),
          ref.read(salonMessagesNotifier).listMessageSelectedMessage.contains(childId)
              ? Positioned.fill(
                  child: Container(
                  width: 875.w,
                  color: Colors.blue.withValues(alpha: 0.2),
                ))
              : const SizedBox()
        ],
      ),
    ),
  );
}
