import 'package:auto_route/auto_route.dart';
import 'package:core_kosmos/core_kosmos.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:twogather/controller/notification_controller.dart';
import 'package:twogather/main.dart';
import 'package:twogather/model/color.dart';
import 'package:twogather/pages/home/notification/builder.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

@RoutePage()
class NotificationPage extends StatefulHookConsumerWidget {
  const NotificationPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _NotificationPageState();
}

class _NotificationPageState extends ConsumerState<NotificationPage> {
  @override
  void initState() {
    NotificationController.setAllNotificationAsRead(
        FirebaseAuth.instance.currentUser!.uid);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    printInDebug(ref.watch(notificationProvider).notifications.length);
    return SafeArea(
      bottom: false,
      child: Container(
        color: Theme.of(context).scaffoldBackgroundColor,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              sh(12),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: formatWidth(22)),
                child: SizedBox(
                  height: formatHeight(35),
                  width: double.infinity,
                  child: Stack(
                    children: [
                      Center(
                        child: Text(
                          "utils.notifs".tr(),
                          style: AppTextStyle.black(17),
                        ),
                      ),
                      Positioned(
                        top: 0,
                        left: 0,
                        bottom: 0,
                        child: InkWell(
                          onTap: () => AutoRouter.of(context).back(),
                          child: Icon(
                            Icons.arrow_back_ios_new_rounded,
                            color: Colors.black,
                            size: formatWidth(18),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              sh(50),
              ...ref.watch(notificationProvider).notifications.map(
                  (e) => NotificationBuilder.buildNotification(context, e)),
            ],
          ),
        ),
      ),
    );
  }
}
