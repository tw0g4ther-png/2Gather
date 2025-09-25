import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:core_kosmos/core_package.dart';
import 'package:twogather/model/report/report_model.dart';
import 'package:twogather/services/storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:skeleton_kosmos/skeleton_kosmos.dart';

abstract class ReportController {
  static Future<void> reportUser(String id, String? subId, ReportModel report, String? message, File? image) async {
    try {
      await FirebaseFirestore.instance.collection(GetIt.I<ApplicationDataModel>().userCollectionPath).doc(id).update({
        "reportPoint": FieldValue.increment(report.value ?? 0),
      });
      await FirebaseFirestore.instance.collection(GetIt.I<ApplicationDataModel>().userCollectionPath).doc(id).collection("reports").add({
        ...report.toJson(),
        "setAt": DateTime.now(),
        "from": FirebaseAuth.instance.currentUser!.uid,
        "message": message,
      });
      if (subId != null) {
        await FirebaseFirestore.instance.collection(GetIt.I<ApplicationDataModel>().userCollectionPath).doc(subId).update({
          "reportPoint": FieldValue.increment(report.value ?? 0),
        });
        await FirebaseFirestore.instance.collection(GetIt.I<ApplicationDataModel>().userCollectionPath).doc(subId).collection("reports").add({
          ...report.toJson(),
          "setAt": DateTime.now(),
          "from": FirebaseAuth.instance.currentUser!.uid,
          "message": message,
        });
      }
      await FirebaseFirestore.instance.collection("reports").add({
        "setAt": DateTime.now(),
        "from": FirebaseAuth.instance.currentUser!.uid,
        "to": id,
        "subId": subId,
        "message": message,
        "image": image != null ? await StorageController.uploadToStorage(image, "reports/") : null,
        ...report.toJson(),
      });
    } catch (e) {
      printInDebug("[Except] ReportController: ${e.toString()}");
    }
  }
}
