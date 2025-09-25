import 'package:core_kosmos/core_package.dart';
import 'package:twogather/model/color.dart';
import 'package:flutter/material.dart';

abstract class AlertBox {
  static Future<void> show({
    required BuildContext context,
    required String title,
    required String message,
    List<Widget Function(BuildContext)>? actions,
    bool isClosable = true,
  }) async {
    await showGeneralDialog(
      context: context,
      pageBuilder: (context, animation, secondaryAnimation) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Scaffold(
              backgroundColor: Colors.transparent,
              body: Center(
                child: Container(
                  width: formatWidth(282),
                  padding: EdgeInsets.symmetric(
                    vertical: formatHeight(28),
                    horizontal: formatWidth(34),
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(28),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          InkWell(
                            onTap: () => Navigator.pop(context),
                            child: Icon(
                              Icons.close_rounded,
                              color: const Color(0xFFCFD2D6),
                              size: formatWidth(28),
                            ),
                          ),
                        ],
                      ),
                      sh(12),
                      SizedBox(
                        width: formatWidth(200),
                        child: Text(
                          title,
                          style: AppTextStyle.darkBlue(19, FontWeight.w600),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      sh(6),
                      Text(
                        message,
                        style: AppTextStyle.gray(14, FontWeight.w500),
                        textAlign: TextAlign.center,
                      ),
                      sh(32),
                      if (actions != null)
                        ...actions.map(
                          (e) => Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [e(context), sh(8)],
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
