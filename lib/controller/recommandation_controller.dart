import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:core_kosmos/core_kosmos.dart';
import 'package:twogather/model/user/app_user/app_user_model.dart';
import 'package:get_it/get_it.dart';
import 'package:skeleton_kosmos/skeleton_kosmos.dart';

abstract class RecommandationController {
  static Future<bool> recommandAGroup(String firstUserId, String? secondUserId) async {
    try {
      await FirebaseFirestore.instance.collection(GetIt.I<ApplicationDataModel>().userCollectionPath).doc(firstUserId).update({
        "numberRecommandations": FieldValue.increment(1),
      });

      if (secondUserId != null) {
        await FirebaseFirestore.instance.collection(GetIt.I<ApplicationDataModel>().userCollectionPath).doc(secondUserId).update({
          "numberRecommandations": FieldValue.increment(1),
        });
      }

      return true;
    } catch (e) {
      printInDebug("[Except] ${e.toString()}");
      return false;
    }
  }

  static Future<void> noteUser(String userId, double note) async {
    try {
      final docData = AppUserModel.fromJson((await FirebaseFirestore.instance.collection("users").doc(userId).get()).data()!);

      final numberNote = (docData.numberNote ?? 0) + 1;
      final totalNote = (docData.note ?? 0) + note;
      final rating = totalNote / numberNote;

      await FirebaseFirestore.instance.collection("users").doc(userId).update({
        "numberNote": numberNote,
        "rating": rating,
        "note": totalNote,
      });
    } catch (e) {
      printInDebug("[Except] ${e.toString()}");
    }
  }

  static Future<void> noteFiesta(String fiestaId, double note) async {
    try {
      final docData = AppUserModel.fromJson((await FirebaseFirestore.instance.collection("fiesta").doc(fiestaId).get()).data()!);

      final numberNote = (docData.numberNote ?? 0) + 1;
      final totalNote = (docData.note ?? 0) + note;
      final rating = totalNote / numberNote;

      await FirebaseFirestore.instance.collection("fiesta").doc(fiestaId).update({
        "numberNote": numberNote,
        "rating": rating,
        "note": totalNote,
      });
    } catch (e) {
      printInDebug("[Except] ${e.toString()}");
    }
  }
}
