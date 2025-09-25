import 'package:cached_network_image/cached_network_image.dart';
import 'package:core_kosmos/core_kosmos.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:twogather/controller/friend_controller.dart';
import 'package:twogather/model/color.dart';
import 'package:twogather/widgets/alert/core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:ui_kosmos_v4/ui_kosmos_v4.dart';

class UserCardWidget extends StatelessWidget {
  final String image;
  final String id;
  final String title;
  final String? subTitle;
  final bool isLock;
  final VoidCallback? onTap;
  final Widget? topRightAction;
  final bool isFriend;
  final Function? onLongPress;

  const UserCardWidget({
    super.key,
    required this.image,
    required this.id,
    required this.title,
    this.isLock = false,
    this.subTitle,
    this.onTap,
    this.topRightAction,
    this.isFriend = true,
    this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (onTap != null) {
          onTap!();
        }
      },
      onLongPress: () async {
        if (!isFriend) return;
        if (onLongPress != null) {
          onLongPress!();
        } else {
          await AlertBox.show(
            context: context,
            title: "app.delete".tr(),
            message: "app.delete-desc".tr(namedArgs: {"name": title}),
            actions: [
              (_) => CTA.primary(
                themeName: "red_button",
                textButton: "utils.delete".tr(),
                width: formatWidth(207),
                textButtonStyle: AppTextStyle.white(14, FontWeight.w600),
                onTap: () async {
                  await FriendController.deleteFriend(
                    FirebaseAuth.instance.currentUser!.uid,
                    id,
                  );
                  if (!context.mounted) return;
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        }
      },
      child: SizedBox(
        width: formatWidth(154),
        height: formatHeight(185),
        child: Stack(
          clipBehavior: Clip.hardEdge,
          children: [
            Container(
              width: formatWidth(154),
              height: formatHeight(185),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                image: DecorationImage(
                  image: (image.isNotEmpty)
                      ? CachedNetworkImageProvider(image)
                      : const AssetImage("assets/images/img_user_profil.png")
                            as ImageProvider,
                  fit: BoxFit.cover,
                ),
              ),
              clipBehavior: Clip.hardEdge,
              padding: EdgeInsets.fromLTRB(
                formatWidth(17),
                formatHeight(9),
                formatWidth(9),
                formatHeight(15),
              ),
            ),
            Container(
              width: formatWidth(154),
              height: formatHeight(185),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.black.withValues(alpha: .5),
              ),
              clipBehavior: Clip.hardEdge,
              padding: EdgeInsets.fromLTRB(
                formatWidth(17),
                formatHeight(9),
                formatWidth(9),
                formatHeight(15),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [if (topRightAction != null) topRightAction!],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: AppTextStyle.white(16, FontWeight.bold),
                      ),
                      if (subTitle != null)
                        Text(
                          subTitle!,
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: .5),
                            fontSize: sp(9),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
            if (isLock) ...[
              Container(
                width: formatWidth(154),
                height: formatHeight(185),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: AppColor.mainColor.withValues(alpha: .6),
                ),
                clipBehavior: Clip.hardEdge,
                padding: EdgeInsets.fromLTRB(
                  formatWidth(17),
                  formatHeight(9),
                  formatWidth(9),
                  formatHeight(15),
                ),
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SvgPicture.asset(
                        "assets/svg/ic_lock.svg",
                        colorFilter: const ColorFilter.mode(
                          Colors.white,
                          BlendMode.srcIn,
                        ),
                      ),
                      sh(5),
                      Text(
                        "app.actually-in-duo".tr(),
                        style: AppTextStyle.white(17, FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
