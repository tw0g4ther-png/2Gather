import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:core_kosmos/core_kosmos.dart';
import 'package:get_it/get_it.dart';
import 'package:skeleton_kosmos/skeleton_kosmos.dart';

abstract class HostController {
  static Future<bool> setToHost(String userId) async {
    try {
      FirebaseFirestore.instance.collection(GetIt.I<ApplicationDataModel>().userCollectionPath).doc(userId).update({
        "isHost": true,
      });
      return false;
    } on FirebaseException catch (e) {
      printInDebug("[Except] ${e.toString()}");
      return true;
    }
  }
}
