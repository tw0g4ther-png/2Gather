import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get_it/get_it.dart';
import 'package:skeleton_kosmos/skeleton_kosmos.dart';

abstract class FirestoreController {
  /// Get the [DocumentReference] of the user from FirebaseFirestore.
  ///
  /// [String] id: id of the requested user
  ///
  static DocumentReference getDocumentReferenceFromId(String id) {
    return FirebaseFirestore.instance.collection(GetIt.I<ApplicationDataModel>().userCollectionPath).doc(id);
  }

  /// Get the [DocumentSnapshot] of the user from FirebaseFirestore.
  ///
  /// [String] id: id of the requested user
  ///
  static Future<DocumentSnapshot> getDocumentSnapshotFromId(String id) async {
    return await getDocumentReferenceFromId(id).get();
  }
}
