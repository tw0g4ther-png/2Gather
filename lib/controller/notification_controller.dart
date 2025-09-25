import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:core_kosmos/core_kosmos.dart';
import 'package:twogather/chat/enum/enumMessage.dart';
import 'package:twogather/chat/freezed/salon/salonModel.dart';
import 'package:twogather/chat/services/firestore/index.dart';
import 'package:get_it/get_it.dart';
import 'package:skeleton_kosmos/skeleton_kosmos.dart';

abstract class NotificationController {
  static Future<void> setAllNotificationAsRead(String userId) async {
    try {
      final list = await FirebaseFirestore.instance
          .collection(GetIt.I<ApplicationDataModel>().userCollectionPath)
          .doc(userId)
          .collection("notifications")
          .get();
      for (final doc in list.docs) {
        await doc.reference.update({"isRead": true});
      }
    } catch (e) {
      printInDebug("[Except] ${e.toString()}");
    }
  }

  static Future<void> setNotificationAsComplete(
    String userId,
    String notifId,
  ) async {
    try {
      await FirebaseFirestore.instance
          .collection(GetIt.I<ApplicationDataModel>().userCollectionPath)
          .doc(userId)
          .collection("notifications")
          .doc(notifId)
          .update({"isComplete": true});
    } catch (e) {
      printInDebug("[Except] ${e.toString()}");
    }
  }

  static Future<void> handleFriendRequest(
    String userId,
    String friendId,
    String notifId,
    bool accepted,
  ) async {
    try {
      await setNotificationAsComplete(userId, notifId);
      if (!accepted) {
        // Refus: nettoyer la demande sortante côté émetteur si existante
        final String usersPath =
            GetIt.I<ApplicationDataModel>().userCollectionPath;
        final friendRef = FirebaseFirestore.instance
            .collection(usersPath)
            .doc(friendId);
        await friendRef.update({
          "friendsRequest": FieldValue.arrayRemove([userId]),
        });
        return;
      }

      final String usersPath =
          GetIt.I<ApplicationDataModel>().userCollectionPath;
      final userRef = FirebaseFirestore.instance
          .collection(usersPath)
          .doc(userId);
      final friendRef = FirebaseFirestore.instance
          .collection(usersPath)
          .doc(friendId);

      // Accepter: créer l'amitié des deux côtés de manière atomique
      await FirebaseFirestore.instance.runTransaction((tx) async {
        final userSnap = await tx.get(userRef);
        final friendSnap = await tx.get(friendRef);
        final Map<String, dynamic> userData =
            userSnap.data() ?? <String, dynamic>{};
        final Map<String, dynamic> friendData =
            friendSnap.data() ?? <String, dynamic>{};

        final List<dynamic> userFriends =
            (userData['friends'] as List<dynamic>?) ?? <dynamic>[];
        final List<dynamic> friendFriends =
            (friendData['friends'] as List<dynamic>?) ?? <dynamic>[];

        final bool alreadyFriendsForUser = userFriends.any((e) {
          try {
            return (e is Map &&
                (e['user'] as DocumentReference).id == friendId);
          } catch (_) {
            return false;
          }
        });
        final bool alreadyFriendsForFriend = friendFriends.any((e) {
          try {
            return (e is Map && (e['user'] as DocumentReference).id == userId);
          } catch (_) {
            return false;
          }
        });

        final Map<String, dynamic> newFriendForUser = {
          "type": "connexion",
          "user": friendRef,
        };
        final Map<String, dynamic> newFriendForFriend = {
          "type": "connexion",
          "user": userRef,
        };

        // Nettoyage des demandes pendantes dans les deux sens
        tx.update(userRef, {
          "friendsRequest": FieldValue.arrayRemove([friendId]),
          if (!alreadyFriendsForUser)
            "friends": FieldValue.arrayUnion([newFriendForUser]),
        });
        tx.update(friendRef, {
          "friendsRequest": FieldValue.arrayRemove([userId]),
          if (!alreadyFriendsForFriend)
            "friends": FieldValue.arrayUnion([newFriendForFriend]),
        });
      });
    } catch (e) {
      printInDebug("[Except] ${e.toString()}");
    }
  }

  static Future<void> handleDuoRequest(
    String userId,
    String friendId,
    String? notifId,
    bool accepted, {
    bool? notUseNotif,
  }) async {
    // Check if discussion Exists
    String? salonId = await FirestoreQuery.existSalonOneToOneWithGivenUsers(
      uid1: friendId,
      uid2: userId,
    );
    if (salonId == null) {
      // If not create one for sending Messaging
      salonId = userId + friendId;
      await FirebaseFirestore.instance
          .collection("Salons")
          .doc(salonId)
          .set(
            SalonModel(
              type: SalonType.oneToOne,
              users: [userId, friendId],
            ).toJson(),
          );
    }
    try {
      if (notUseNotif == null) {
        await setNotificationAsComplete(userId, notifId!);
      }
      if (!accepted) return;
      final callable = FirebaseFunctions.instance.httpsCallable(
        "confirmDuoRequest",
      );
      final result = await callable.call({
        "userId": userId,
        "friendId": friendId,
        "accepted": accepted,
      });
      if (result.data != true) {
        throw Exception(result.data);
      }
      SalonModel doc = SalonModel.fromJson(
        (await FirebaseFirestore.instance
                .collection("Salons")
                .doc(salonId)
                .get())
            .data()!,
      );
      await FirebaseFirestore.instance.collection("Salons").doc(salonId).update(
        {"lock": "locked"},
      );
      await FirebaseFirestore.instance
          .collection("Salons")
          .doc(salonId)
          .collection("Messages")
          .doc(doc.lastLockedDemand)
          .update({"state": "accepted"});
    } catch (e) {
      printInDebug("[Except] ${e.toString()}");
    }
  }

  static Future<void> handleFiestaRequest(
    String userId,
    String duoId,
    String fiestaId,
    String notifId,
    bool accepted,
  ) async {
    try {
      await setNotificationAsComplete(duoId, notifId);
      if (!accepted) {
        return;
      }
      await FirebaseFirestore.instance
          .collection("fiesta")
          .doc(fiestaId)
          .update({
            "participants": FieldValue.arrayRemove([
              {"fiestaRef": duoId, "duoRef": null, "status": "waiting"},
            ]),
          });
      final callable = FirebaseFunctions.instance.httpsCallable("joinFiesta");
      final result = await callable.call({
        "fiestaId": fiestaId,
        "userId": userId,
        "fiestaRef": userId,
        "duoRef": duoId,
        "status": "pending",
      });
      if (result.data != true) {
        throw Exception(result.data);
      }
    } catch (e) {
      printInDebug("[Except] ${e.toString()}");
    }
  }

  static Future<void> handleSponsorshipRequest(
    String userId,
    String sponsorshipId,
    String notifId,
    bool accepted,
  ) async {
    try {
      printInDebug(
        "[NotificationController] Gestion demande sponsorship - ID: $sponsorshipId, accepté: $accepted",
      );

      // Marquer la notification comme complète
      await setNotificationAsComplete(userId, notifId);

      // Mettre à jour le document sponsorship avec le statut d'acceptation
      await FirebaseFirestore.instance
          .collection(GetIt.I<ApplicationDataModel>().userCollectionPath)
          .doc(userId)
          .collection("sponsorship")
          .doc(sponsorshipId)
          .update({
            "isAccepted": accepted,
            "processedAt": FieldValue.serverTimestamp(),
          });

      printInDebug(
        "[NotificationController] Demande sponsorship ${accepted ? 'acceptée' : 'refusée'} avec succès",
      );
    } catch (e) {
      printInDebug(
        "[NotificationController] Erreur lors de la gestion de la demande sponsorship: $e",
      );
    }
  }
}
