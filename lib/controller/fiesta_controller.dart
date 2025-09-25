import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:core_kosmos/core_kosmos.dart';
import 'package:twogather/chat/enum/enumMessage.dart';
import 'package:twogather/chat/freezed/salon/salonModel.dart';
import 'package:twogather/chat/services/firestore/index.dart';
import 'package:twogather/model/fiesta/fiesta_model.dart';
import 'package:twogather/model/user/app_user/app_user_model.dart';
import 'package:twogather/model/user/fiestar_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:skeleton_kosmos/skeleton_kosmos.dart';

abstract class FiestaController {
  static Future<bool> createNewFiesta(
    Map<String, dynamic> fiestaData,
    Map<String, dynamic> fiestaUserData,
  ) async {
    try {
      printInDebug("[FiestaController] Début de la création de fiesta");
      
      // Vérification d'authentification
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) {
        printInDebug("[FiestaController] Erreur: Utilisateur non authentifié");
        return true; // true = erreur
      }
      
      // Validation des champs obligatoires
      final requiredFields = [
        'title', 'category', 'soundLevel', 'description', 'visibleAfter',
        'pictures', 'address', 'startAt', 'endAt', 'numberOfParticipant',
        'logistic', 'visibilityRadius'
      ];
      
      for (final field in requiredFields) {
        if (fiestaData[field] == null) {
          printInDebug("[FiestaController] Erreur: Champ obligatoire manquant: $field");
          return true; // true = erreur
        }
      }
      
      // Validation des données spécifiques
      if (fiestaData['pictures'] is List && (fiestaData['pictures'] as List).isEmpty) {
        printInDebug("[FiestaController] Erreur: Aucune photo fournie");
        return true;
      }
      
      if (fiestaData['startAt'] != null && fiestaData['endAt'] != null) {
        final startAt = fiestaData['startAt'] as DateTime;
        final endAt = fiestaData['endAt'] as DateTime;
        if (startAt.isAfter(endAt)) {
          printInDebug("[FiestaController] Erreur: Date de début après date de fin");
          return true;
        }
        if (startAt.isBefore(DateTime.now())) {
          printInDebug("[FiestaController] Erreur: Date de début dans le passé");
          return true;
        }
      }
      
      printInDebug("[FiestaController] Validation réussie, création du document...");
      // Ajouter des métadonnées supplémentaires
      final enrichedFiestaData = {
        ...fiestaData,
        'createdBy': currentUser.uid,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
        'isEnd': false,
        'participants': [], // Initialiser la liste des participants
      };
      
      final docRef = await FirebaseFirestore.instance
          .collection("fiesta")
          .add(enrichedFiestaData);
      
      printInDebug("[FiestaController] Document fiesta créé avec ID: ${docRef.id}");

      // Enrichir les données utilisateur
      final enrichedUserData = {
        ...fiestaUserData,
        "fiestaRef": docRef,
        "fiestaId": docRef.id,
        "createdAt": FieldValue.serverTimestamp(),
      };
      
      await FirebaseFirestore.instance
          .collection(GetIt.I<ApplicationDataModel>().userCollectionPath)
          .doc(currentUser.uid)
          .collection("created-fiesta")
          .add(enrichedUserData);
      
      printInDebug("[FiestaController] Document created-fiesta ajouté pour l'utilisateur");

      // Appel de la cloud function pour les points
      try {
        final call = FirebaseFunctions.instance.httpsCallable(
          "createFiestaPoint",
        );
        await call.call({"userId": currentUser.uid});
        printInDebug("[FiestaController] Points fiesta attribués");
      } catch (e) {
        printInDebug("[FiestaController] Erreur lors de l'attribution des points: $e");
        // Ne pas faire échouer la création pour un problème de points
      }

      // Création du salon de chat
      try {
        SalonModel salonModel = SalonModel(
          type: SalonType.group,
          nom: fiestaData['title'] ?? 'Fiesta',
          users: [currentUser.uid],
          adminId: currentUser.uid,
          id: docRef.id,
        );
        await FirestoreQuery.addSalon(salonModel: salonModel);
        printInDebug("[FiestaController] Salon de chat créé");
      } catch (e) {
        printInDebug("[FiestaController] Erreur lors de la création du salon: $e");
        // Ne pas faire échouer la création pour un problème de salon
      }
      
      printInDebug("[FiestaController] Fiesta créée avec succès - ID: ${docRef.id}");
      return false; // false = succès
    } on FirebaseException catch (e) {
      printInDebug("[Except] ${e.toString()}");
      return true;
    }
  }

  static Future<bool> updateFiesta(
    String id,
    Map<String, dynamic> fiestaData,
    Map<String, dynamic> fiestaUserData,
  ) async {
    try {
      await FirebaseFirestore.instance
          .collection("fiesta")
          .doc(id)
          .update(fiestaData);

      await (await FirebaseFirestore.instance
              .collection(GetIt.I<ApplicationDataModel>().userCollectionPath)
              .doc(FirebaseAuth.instance.currentUser!.uid)
              .collection("created-fiesta")
              .where("fiestaId", isEqualTo: id)
              .get())
          .docs
          .first
          .reference
          .update({...fiestaUserData});
      return false;
    } on FirebaseException catch (e) {
      printInDebug("[Except] ${e.toString()}");
      return true;
    }
  }

  static Future<void> dismissFiesta(String userId, String fiestaId) async {
    await FirebaseFirestore.instance
        .collection(GetIt.I<ApplicationDataModel>().userCollectionPath)
        .doc(userId)
        .update({
          "dismissed-fiesta": FieldValue.arrayUnion([fiestaId]),
        });
  }

  static Future<void> acceptFiesta(
    String userId,
    String fiestaId,
    FiestaModel model, [
    AppUserModel? duo,
    bool isWithSearch = false,
  ]) async {
    try {
      await FirebaseFirestore.instance
          .collection(GetIt.I<ApplicationDataModel>().userCollectionPath)
          .doc(userId)
          .update({
            "requested-fiesta": FieldValue.arrayUnion([fiestaId]),
          });
      HttpsCallable? call;
      if (isWithSearch) {
        call = FirebaseFunctions.instance.httpsCallable(
          "requestADuoToGoFiesta",
        );
      } else {
        call = FirebaseFunctions.instance.httpsCallable("joinFiesta");
        await FirebaseFirestore.instance
            .collection("fiesta")
            .doc(fiestaId)
            .update({
              "participants": FieldValue.arrayRemove([
                {"fiestaRef": duo?.id, "duoRef": null, "status": "waiting"},
              ]),
            });
      }
      printInDebug("[] ${duo?.id}");
      final rep = await call.call({
        "fiestaId": fiestaId,
        "userId": userId,
        "fiestaRef": userId,
        "duoRef": duo?.id,
        "status": duo == null ? "waiting" : "pending",
      });

      printInDebug("[Fiesta Join]: ${rep.data}");
    } catch (e) {
      printInDebug("[Except] ${e.toString()}");
    }
  }

  static Future<bool> checkIfCanSelectAFiestar(
    String userId,
    String fiestaId,
    FiestaModel data,
    FiestarUserModel userData,
  ) async {
    if (userData.duo != null) return false;

    for (final FiestaUserModel userInFiesta in data.participants ?? []) {
      if (userInFiesta.duoRef == null &&
          (userData.friends
                      ?.map((e) => (e["user"] as DocumentReference).id)
                      .toList() ??
                  [])
              .contains(userInFiesta.fiestaRef)) {
        return true;
      }
    }
    return false;
  }

  static Future<List<AppUserModel>> getFriendUserForSameFiesta(
    String userId,
    String fiestaId,
    FiestarUserModel userData,
    FiestaModel data,
  ) async {
    List<AppUserModel> users = [];

    for (final FiestaUserModel userInFiesta in data.participants ?? []) {
      if (userInFiesta.duoRef == null &&
          (userData.friends
                      ?.map((e) => (e["user"] as DocumentReference).id)
                      .toList() ??
                  [])
              .contains(userInFiesta.fiestaRef)) {
        final user = await FirebaseFirestore.instance
            .collection(GetIt.I<ApplicationDataModel>().userCollectionPath)
            .doc(userInFiesta.fiestaRef)
            .get();
        users.add(
          AppUserModel.fromJson(user.data() ?? {}).copyWith(
            id: user.id,
            pictures: (user.data()?["profilImages"] as List<dynamic>?)
                ?.map((e) => e as String)
                .toList(),
          ),
        );
      }
    }

    return users;
  }

  static Future<void> deleteFiesta(String userId, String fiestaId) async {
    try {
      final call = FirebaseFunctions.instance.httpsCallable("deleteFiesta");
      await call.call({"fiestaId": fiestaId, "userId": userId});
    } catch (e) {
      printInDebug("[Except] ${e.toString()}");
    }
  }

  static Future<List<AppUserModel>> getAppUserFromListOfParticipants(
    FiestaModel data,
  ) async {
    List<AppUserModel> ret = [];

    for (final FiestaUserModel userInFiesta in data.participants ?? []) {
      final user = await FirebaseFirestore.instance
          .collection(GetIt.I<ApplicationDataModel>().userCollectionPath)
          .doc(userInFiesta.fiestaRef)
          .get();
      ret.add(
        AppUserModel.fromJson(user.data() ?? {}).copyWith(
          id: user.id,
          pictures: (user.data()?["profilImages"] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList(),
        ),
      );
      if (userInFiesta.duoRef == null) continue;
      final duo = await FirebaseFirestore.instance
          .collection(GetIt.I<ApplicationDataModel>().userCollectionPath)
          .doc(userInFiesta.duoRef)
          .get();
      ret.add(
        AppUserModel.fromJson(duo.data() ?? {}).copyWith(
          id: duo.id,
          pictures: (duo.data()?["profilImages"] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList(),
        ),
      );
    }

    return ret;
  }

  static Future<void> refuseUserInFiesta(
    String fiestaId,
    String userRef,
    String duoRef,
  ) async {
    try {
      await FirebaseFirestore.instance
          .collection("fiesta")
          .doc(fiestaId)
          .update({
            "participants": FieldValue.arrayRemove([
              {"fiestaRef": userRef, "duoRef": duoRef, "status": "pending"},
            ]),
          });
      FirebaseFunctions.instance.httpsCallable("refuseUserNotify").call({
        "fiestaId": fiestaId,
        "userId": userRef,
        "duoRef": duoRef,
      });
    } catch (e) {
      printInDebug("[Except] ${e.toString()}");
    }
  }

  static Future<void> deleteUserInFiesta(
    String fiestaId,
    String userRef,
    String duoRef,
  ) async {
    try {
      await FirebaseFirestore.instance
          .collection("fiesta")
          .doc(fiestaId)
          .update({
            "participants": FieldValue.arrayRemove([
              {"fiestaRef": userRef, "duoRef": duoRef, "status": "accepted"},
            ]),
          });
      await FirebaseFirestore.instance.collection("users").doc(userRef).update({
        "fiesta": null,
      });
      await FirebaseFirestore.instance.collection("users").doc(duoRef).update({
        "fiesta": null,
      });
    } catch (e) {
      printInDebug("[Except] ${e.toString()}");
    }
  }

  static Future<void> acceptUserInFiesta(
    String fiestaId,
    String userRef,
    String duoRef,
  ) async {
    try {
      await FirebaseFirestore.instance
          .collection("fiesta")
          .doc(fiestaId)
          .update({
            "participants": FieldValue.arrayRemove([
              {"fiestaRef": userRef, "duoRef": duoRef, "status": "pending"},
            ]),
          });
      await FirebaseFirestore.instance
          .collection("fiesta")
          .doc(fiestaId)
          .update({
            "participants": FieldValue.arrayUnion([
              {"fiestaRef": userRef, "duoRef": duoRef, "status": "accepted"},
            ]),
          });
      await FirebaseFirestore.instance.collection("users").doc(userRef).update({
        "fiesta": fiestaId,
      });
      await FirebaseFirestore.instance.collection("users").doc(duoRef).update({
        "fiesta": fiestaId,
      });
    } catch (e) {
      printInDebug("[Except] ${e.toString()}");
    }
  }
}
