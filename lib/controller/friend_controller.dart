import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:core_kosmos/core_package.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:twogather/chat/enum/enumMessage.dart';
import 'package:twogather/chat/freezed/message/messageModel.dart';
import 'package:twogather/chat/freezed/salon/salonModel.dart';
import 'package:twogather/chat/services/firestore/index.dart';
import 'package:twogather/model/fiesta/user_fiesta_model.dart';
import 'package:twogather/model/user/app_user/app_user_model.dart';
import 'package:twogather/model/user/fiestar_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:skeleton_kosmos/skeleton_kosmos.dart';

abstract class FriendController {
  static Future<bool> checkMatchWithFriendAdded(
    String userId,
    String friendId,
  ) async {
    final list = FiestarUserModel.fromJson(
      (await FirebaseFirestore.instance.collection("users").doc(friendId).get())
          .data()!,
    ).friendsRequest;

    return list != null && list.contains(userId);
  }

  static Future<bool> addFriendWithSwipe(String userId, String friendId) async {
    try {
      if (await checkMatchWithFriendAdded(userId, friendId)) {
        await FirebaseFirestore.instance.collection("users").doc(userId).update(
          {
            "friendsRequest": FieldValue.arrayRemove([friendId]),
          },
        );
        await FirebaseFirestore.instance
            .collection("users")
            .doc(friendId)
            .update({
              "friendsRequest": FieldValue.arrayRemove([userId]),
            });

        await FirebaseFirestore.instance.collection("users").doc(userId).update(
          {
            "friends": FieldValue.arrayUnion([
              {
                "type": "connexion",
                "user": FirebaseFirestore.instance
                    .collection("users")
                    .doc(friendId),
              },
            ]),
          },
        );
        await FirebaseFirestore.instance
            .collection("users")
            .doc(friendId)
            .update({
              "friends": FieldValue.arrayUnion([
                {
                  "type": "connexion",
                  "user": FirebaseFirestore.instance
                      .collection("users")
                      .doc(userId),
                },
              ]),
            });
      } else {
        await FirebaseFirestore.instance.collection("users").doc(userId).update(
          {
            "friendsRequest": FieldValue.arrayUnion([friendId]),
          },
        );
      }

      // final callable = FirebaseFunctions.instance.httpsCallable("addFriendWithSwipe");
      // final result = await callable.call({"userId": userId, "friendId": friendId});
      // if (result.data != true) {
      //   throw Exception(result.data);
      // }
      return true;
    } catch (e) {
      printInDebug("[Except] ${e.toString()}");
      return false;
    }
  }

  static Future<void> dismissFriendWithSwipe(
    String userId,
    String friendId,
  ) async {
    try {
      final callable = FirebaseFunctions.instance.httpsCallable(
        "dismissFriendWithSwipe",
      );
      final result = await callable.call({
        "userId": userId,
        "friendId": friendId,
      });
      if (result.data != true) {
        throw Exception(result.data);
      }
    } catch (e) {
      printInDebug("[Except] ${e.toString()}");
    }
  }

  static Future<void> deleteFriend(String userId, String friendId) async {
    try {
      final callable = FirebaseFunctions.instance.httpsCallable("deleteFriend");
      final result = await callable.call({
        "userId": userId,
        "friendId": friendId,
      });
      if (result.data != true) {
        throw Exception(result.data);
      }
    } catch (e) {
      printInDebug("[Except] ${e.toString()}");
    }
  }

  static Future<void> cancelFriendRequest(
    List<String> friendsRequest,
    String friendId,
  ) async {
    try {
      friendsRequest.removeWhere((element) => element == friendId);
      await FirebaseFirestore.instance
          .collection(GetIt.I<ApplicationDataModel>().userCollectionPath)
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .update({"friendsRequest": friendsRequest});
    } catch (e) {
      printInDebug("[Except] ${e.toString()}");
    }
  }

  /// Promote user's friend provided to 1st circle.
  ///
  /// [List] friends: all friends of user (generaly from userChangeNotifierProvider).
  /// [List] ids: list of friend's id that user want to promote to 1st Circle.
  ///
  static Future<bool> addToFirstCircle(
    List<Map<String, dynamic>> friends,
    List<String> ids,
  ) async {
    try {
      for (final item in friends) {
        if (item["type"] == "fiestar" &&
            ids.contains((item["user"] as DocumentReference).id)) {
          item["type"] = "1_circle";
        }
      }

      await FirebaseFirestore.instance
          .collection(GetIt.I<ApplicationDataModel>().userCollectionPath)
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .update({"friends": friends});

      return false;
    } on FirebaseException catch (e) {
      printInDebug("[Except] ${e.toString()}");
      return true;
    }
  }

  static Future<List<AppUserModel>?> getUserListExceptMe() async {
    try {
      final users = await FirebaseFirestore.instance
          .collection(GetIt.I<ApplicationDataModel>().userCollectionPath)
          .get();
      final list = users.docs
          .where(
            (element) =>
                element.id != FirebaseAuth.instance.currentUser!.uid && true,
          )
          .toList();
      List<AppUserModel>? ret = [];

      for (final item in list) {
        final Map<String, dynamic> raw = item.data();
        // Pourquoi: certains documents peuvent ne pas avoir d'email ou avoir un email vide.
        // On exclut ces utilisateurs de l'affichage pour éviter des entrées invalides.
        final String? email = (raw["email"] as String?);
        if (email == null || email.trim().isEmpty) {
          continue;
        }
        final List<String> pictures =
            (raw["profilImages"] as List<dynamic>?)
                ?.map((e) => e as String)
                .toList() ??
            [];

        ret.add(
          AppUserModel.fromJson(raw).copyWith(pictures: pictures, id: item.id),
        );
      }

      return ret;
    } catch (e) {
      printInDebug("[Except] ${e.toString()}");
      return null;
    }
  }

  static bool userHaveThisPersonInFriends(
    List<Map<String, dynamic>> friends,
    String personId,
  ) {
    return friends.any((element) => element["user"].id == personId);
  }

  static Future<void> addFriend(String userId, String friendId) async {
    try {
      final String usersPath =
          GetIt.I<ApplicationDataModel>().userCollectionPath;

      // Enregistre la demande sortante côté demandeur
      await FirebaseFirestore.instance.collection(usersPath).doc(userId).update(
        {
          "friendsRequest": FieldValue.arrayUnion([friendId]),
        },
      );

      // Récupère les documents user et friend
      final userRef = FirebaseFirestore.instance
          .collection(usersPath)
          .doc(userId);
      final friendRef = FirebaseFirestore.instance
          .collection(usersPath)
          .doc(friendId);
      final userSnap = await userRef.get();
      final friendSnap = await friendRef.get();

      final Map<String, dynamic>? friendData = friendSnap.data();
      final Map<String, dynamic>? userData = userSnap.data();

      final List<dynamic> friendIncomingRequests =
          (friendData?['friendsRequest'] as List<dynamic>?) ?? [];

      // Si l'autre a déjà envoyé une demande → créer l'amitié des deux côtés
      final bool isMutual = friendIncomingRequests.contains(userId);
      if (isMutual) {
        await friendRef.update({
          "friendsRequest": FieldValue.arrayRemove([userId]),
          "friends": FieldValue.arrayUnion([
            {"type": "connexion", "user": userRef},
          ]),
        });

        await userRef.update({
          "friendsRequest": FieldValue.arrayRemove([friendId]),
          "friends": FieldValue.arrayUnion([
            {"type": "connexion", "user": friendRef},
          ]),
        });
        return;
      }

      // Sinon, créer une notification chez le destinataire
      await friendRef.collection("notifications").add({
        "notificationType": "friendRequest",
        "isComplete": false,
        "isRead": false,
        "message": "friend.wants-to-become-friend".tr(),
        "notificationUser": {
          "id": userRef.id,
          "firstname": userData?['firstname'],
          "lastname": userData?['lastname'],
          "pictures": userData?['profilImages'],
        },
        "receivedAt": FieldValue.serverTimestamp(),
      });
    } catch (e) {
      await FirebaseFirestore.instance
          .collection(GetIt.I<ApplicationDataModel>().userCollectionPath)
          .doc(userId)
          .update({
            "friendsRequest": FieldValue.arrayRemove([friendId]),
          });
      printInDebug("[Except] ${e.toString()}");
    }
  }

  static Future<bool> requestNewLockDuo(
    String userId,
    String friendId,
    String? salonId,
  ) async {
    salonId ??= await FirestoreQuery.existSalonOneToOneWithGivenUsers(
      uid1: userId,
      uid2: friendId,
    );
    if (salonId == null) {
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
      final callable = FirebaseFunctions.instance.httpsCallable(
        "requestNewLockDuo",
      );
      final result = await callable.call({
        "userId": userId,
        "friendId": friendId,
      });
      if (result.data != true) {
        throw Exception(result.data);
      }
      Map<String, dynamic> message = MessageModel(
        sender: userId,
        createdAt: DateTime.now(),
        type: MessageContentType.lockDemandMessage,
      ).toJson();
      message.remove("timeStamp");

      DocumentReference<Map<String, dynamic>> ref = await FirebaseFirestore
          .instance
          .collection('Salons')
          .doc(salonId)
          .collection("Messages")
          .add({...message, "timeStamp": FieldValue.serverTimestamp()});
      await FirebaseFirestore.instance.collection("Salons").doc(salonId).update(
        {"lock": "sended", "lastLockedDemand": ref.id},
      );
      return false;
    } catch (e) {
      printInDebug("[Except] ${e.toString()}");
      return true;
    }
  }

  static Future<bool> stopLockDuo(
    String userId,
    String friendId, {
    String? salonId,
  }) async {
    salonId ??= await FirestoreQuery.existSalonOneToOneWithGivenUsers(
      uid1: userId,
      uid2: friendId,
    );
    if (salonId == null) {
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
      final callable = FirebaseFunctions.instance.httpsCallable("stopLockDuo");
      final result = await callable.call({
        "userId": userId,
        "friendId": friendId,
      });
      if (result.data != true) {
        throw Exception(result.data);
      }
      await FirebaseFirestore.instance.collection("Salons").doc(salonId).update(
        {"lock": "notYet"},
      );
      return false;
    } catch (e) {
      printInDebug("[Except] ${e.toString()}");
      return true;
    }
  }

  static Future<List<UserFiestaModel>?> getFiestaOfFriend(
    String friendId,
    String fiestaCollection,
  ) async {
    try {
      final fiestas = await FirebaseFirestore.instance
          .collection(GetIt.I<ApplicationDataModel>().userCollectionPath)
          .doc(friendId)
          .collection(fiestaCollection)
          .get();
      List<UserFiestaModel> ret = [];
      for (final doc in fiestas.docs) {
        ret.add(UserFiestaModel.fromJson(doc.data()));
      }
      return ret;
    } catch (e) {
      printInDebug("[Except] ${e.toString()}");
      return null;
    }
  }

  static Future<void> bloqueUser(String userId) async {
    try {
      await FirebaseFirestore.instance
          .collection(GetIt.I<ApplicationDataModel>().userCollectionPath)
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .update({
            "bloquedUser": FieldValue.arrayUnion([userId]),
          });
    } catch (e) {
      printInDebug("[Except] ${e.toString()}");
    }
  }

  static Future<void> unnbloqueUser(String userId) async {
    try {
      await FirebaseFirestore.instance
          .collection(GetIt.I<ApplicationDataModel>().userCollectionPath)
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .update({
            "bloquedUser": FieldValue.arrayRemove([userId]),
          });
    } catch (e) {
      printInDebug("[Except] ${e.toString()}");
    }
  }
}
