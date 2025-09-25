import 'messageModel.dart';
import '../../riverpods/me_notifier.dart';
import '../../riverpods/salon_river.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:vibration/vibration.dart';

class ReleaseToResponse extends ConsumerStatefulWidget {
  final Widget child;
  final MessageModel messageModel;
  const ReleaseToResponse(
      {super.key, required this.child, required this.messageModel});

  @override
  ReleaseToResponseState createState() => ReleaseToResponseState();
}

class ReleaseToResponseState extends ConsumerState<ReleaseToResponse> {
  @override
  void initState() {
    super.initState();
  }

  Offset _currentOffest = const Offset(0, 0);

  @override
  Widget build(BuildContext context) {
    bool meSender =
        widget.messageModel.sender == ref.read(meModelChangeNotifier).myUid;
    return Stack(children: [
      Positioned(
          bottom: 0,
          child: Transform.translate(
              offset: meSender
                  ? Offset(((_currentOffest.dx / 1.8) - 180).w, 0)
                  : Offset(
                      ((_currentOffest.dx / 2) - 160 < 40
                              ? (_currentOffest.dx / 2) - 200
                              : 40)
                          .w,
                      0),
              child: Column(
                children: [
                  const Icon(Icons.reply),
                  Text(
                    'Relâchez pour répondre',
                    style: TextStyle(fontSize: 12.sp),
                  ),
                ],
              ))),
      Row(
        children: [
          Expanded(
              child: GestureDetector(
            onHorizontalDragEnd: ((details) {
              if (_currentOffest.dx > 0) {
                Vibration.vibrate(duration: 100);
                ref
                    .read(salonMessagesNotifier)
                    .setRepliedMessage(widget.messageModel);
                setState(() {
                  _currentOffest = Offset.zero;
                });
              }
            }),
            onHorizontalDragUpdate: (details) {
              if (details.delta.dx > 0) {
                setState(() {
                  _currentOffest = Offset(details.localPosition.dx, 0);
                });
              }
            },
            child: Transform.translate(
              offset: meSender
                  ? Offset(_currentOffest.dx / 2.9, 0)
                  : Offset(_currentOffest.dx / 2, 0),
              child: widget.child,
            ),
          )),
        ],
      ),
    ]);
  }
}

Widget repliedTo(
  MessageModel messageModel, {
  required Widget child,
  required WidgetRef ref,
}) {
  return ReleaseToResponse(messageModel: messageModel, child: child);
}
