import 'dart:async';
import 'package:core_kosmos/core_kosmos.dart';
import 'package:flutter/material.dart';

abstract class MessageBox {
  static Future<void> show({
    required BuildContext context,
    required String title,
    required String message,
    List<Widget Function(BuildContext)>? actions,
    bool isClosable = true,
  }) async {
    await showGeneralDialog(
      context: context,
      pageBuilder: (_, _, _) {
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
                          style: TextStyle(
                            fontSize: sp(19),
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF02132B),
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      sh(6),
                      Text(
                        message,
                        style: TextStyle(
                          fontSize: sp(14),
                          fontWeight: FontWeight.w500,
                          color: const Color(0xFF02132B).withValues(alpha: .65),
                        ),
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
