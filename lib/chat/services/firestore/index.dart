import '../../freezed/lastDeleteCompos/lastDeleteCompos.dart';
import '../../freezed/salon/salonModel.dart';

import '../../freezed/message/messageModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

abstract class FirestoreQuery {
  static Future<void> changeSalonName({
    required String salonId,
    required String name,
  }) async {
    await FirebaseFirestore.instance.collection('Salons').doc(salonId).update({
      "nom": name,
    });
  }

  static Future<void> addUsersToSalon({
    required String salonId,
    required List<String> users,
  }) async {
    await FirebaseFirestore.instance.collection('Salons').doc(salonId).update({
      "users": FieldValue.arrayUnion(users),
    });
  }

  static Future removeUsersFromSalon({
    required String salonId,
    required List<String> users,
  }) async {
    return await FirebaseFirestore.instance
        .collection('Salons')
        .doc(salonId)
        .update({"users": FieldValue.arrayRemove(users)});
  }

  static Future<void> addBloquedToSalon({
    required String salonId,
    required String userId,
  }) async {
    await FirebaseFirestore.instance.collection('Salons').doc(salonId).update({
      'bloquedUser': FieldValue.arrayUnion([userId]),
    });
  }

  static Future<void> switchSalonAdminisatrationToAll({
    required String salonId,
    required bool allow,
  }) async {
    await FirebaseFirestore.instance.collection('Salons').doc(salonId).update({
      "allowAllUserToUpdateInformation": allow,
    });
  }

  static Future<void> removeBloquedToSalon({
    required String salonId,
    required String userId,
  }) async {
    await FirebaseFirestore.instance.collection('Salons').doc(salonId).update({
      'bloquedUser': FieldValue.arrayRemove([userId]),
    });
  }

  static Future<void> addMessage(
    MessageModel messageModel, {
    required String salonId,
  }) async {
    if (messageModel.id == null) {
      DocumentReference<Map<String, dynamic>> ref = await FirebaseFirestore
          .instance
          .collection('Salons')
          .doc(salonId)
          .collection("Messages")
          .add({
            ...messageModel.toJson(),
            "timeStamp": FieldValue.serverTimestamp(),
          });
      _lastMessageToSalon(messageModel.copyWith(id: ref.id), salonId: salonId);
    } else {
      await FirebaseFirestore.instance
          .collection('Salons')
          .doc(salonId)
          .collection("Messages")
          .doc(messageModel.id)
          .set({
            ...messageModel.toJson(),
            "timeStamp": FieldValue.serverTimestamp(),
          });
      _lastMessageToSalon(messageModel, salonId: salonId);
    }
  }

  static void setMessage(MessageModel messageModel, {required String salonId}) {
    FirebaseFirestore.instance
        .collection('Salons')
        .doc(salonId)
        .collection("Messages")
        .doc(messageModel.id)
        .set({
          ...messageModel.toJson(),
          "timeStamp": FieldValue.serverTimestamp(),
        });
    _lastMessageToSalon(messageModel, salonId: salonId);
  }

  static Future<void> _lastMessageToSalon(
    MessageModel messageModel, {
    required String salonId,
  }) async {
    await FirebaseFirestore.instance.collection('Salons').doc(salonId).update({
      "lastMessageContent": messageModel.toJson(),
      "lastMessageType": messageModel.toJson()['type'],
      "lastMessageId": messageModel.id,
    });
  }

  static Future<void> leaveSalon({
    required String salonId,
    required userId,
  }) async {
    await FirebaseFirestore.instance.collection('Salons').doc(salonId).update({
      "users": FieldValue.arrayRemove([userId]),
    });
  }

  static Future<void> deleteSalon({required String salonId}) async {
    await FirebaseFirestore.instance.collection('Salons').doc(salonId).delete();
  }

  static Future<void> setLastDeleteAdd({
    required String salonId,
    required userId,
  }) async {
    await FirebaseFirestore.instance
        .collection("LastDeletedCompos")
        .doc(salonId + userId)
        .set(
          LastDeleteCompos(
            idUser: userId,
            idSalon: salonId,
            lastDateDelete: DateTime.now(),
          ).toJson(),
        );
  }

  static void playAudioMessage({
    required String idSalon,
    required String idAudio,
    required String playedBy,
  }) {
    FirebaseFirestore.instance
        .collection('Salons')
        .doc(idSalon)
        .collection("Messages")
        .doc(idAudio)
        .update({
          "readedBy": FieldValue.arrayUnion([playedBy]),
        });
  }

  static Future<String?> existSalonOneToOneWithGivenUsers({
    required String uid1,
    required String uid2,
  }) async {
    DocumentSnapshot doc1 = await FirebaseFirestore.instance
        .collection("Salons")
        .doc(uid1 + uid2)
        .get();
    if (doc1.exists) return uid1 + uid2;
    DocumentSnapshot doc2 = await FirebaseFirestore.instance
        .collection("Salons")
        .doc(uid2 + uid1)
        .get();
    if (doc2.exists) return uid2 + uid1;

    return null;
  }

  static Future<void> addSalon({required SalonModel salonModel}) async {
    await FirebaseFirestore.instance
        .collection("Salons")
        .doc(salonModel.id)
        .set(salonModel.toJson());
  }

  static Future<String> addSalonOneToOne({
    required SalonModel salonModel,
    required String myUid,
    required otherUid,
  }) async {
    FirebaseFirestore.instance
        .collection("Salons")
        .doc(otherUid + myUid)
        .set(salonModel.toJson());
    return otherUid + myUid;
  }
}
