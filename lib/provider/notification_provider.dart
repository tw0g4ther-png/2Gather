import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:core_kosmos/core_package.dart';

import 'package:twogather/model/notification/notification_model.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:skeleton_kosmos/skeleton_kosmos.dart';

class NotificationProvider with ChangeNotifier {
  List<NotificationModel> notifications = [];

  StreamSubscription<QuerySnapshot<Map<String, dynamic>>>? _notificationSubscription;

  /// Retourne le nombre de notifications non lues
  /// 
  /// Compte les notifications où isRead est false ou null
  int get unreadCount {
    return notifications.where((notification) => 
      notification.isRead == false || notification.isRead == null
    ).length;
  }

  Future init(String userId) async {
    if (_notificationSubscription != null) return;
    notifications.clear();
    _notificationSubscription = FirebaseFirestore.instance.collection(GetIt.I<ApplicationDataModel>().userCollectionPath).doc(userId).collection('notifications').snapshots().listen((snapshot) {
      for (final e in snapshot.docChanges) {
        switch (e.type) {
          case DocumentChangeType.added:
            printInDebug("[NotificationProvider] Added");
            notifications.add(NotificationModel.fromJson(e.doc.data()!).copyWith(id: e.doc.id));
            break;
          case DocumentChangeType.modified:
            printInDebug("[NotificationProvider] Modified");
            int? index = notifications.indexWhere((element) => element.id == e.doc.id);
            if (index == -1) continue;
            notifications[index] = NotificationModel.fromJson(e.doc.data()!).copyWith(id: e.doc.id);
            break;
          case DocumentChangeType.removed:
            printInDebug("[NotificationProvider] Removed");
            notifications.removeWhere((notification) => notification.id == e.doc.id);
            break;
        }
        notifications.sort((a, b) {
          final val = a.receivedAt!.compareTo(b.receivedAt!);
          if (val < 0) return 1;
          if (val > 0) return -1;
          return 0;
        });
        printInDebug(notifications);
        notifyListeners();
      }
    });
  }

  /// Nettoie les données et annule les listeners
  void clear() {
    notifications.clear();
    _notificationSubscription?.cancel();
    _notificationSubscription = null;
    notifyListeners();
  }

  @override
  void dispose() {
    _notificationSubscription?.cancel();
    super.dispose();
  }
}
