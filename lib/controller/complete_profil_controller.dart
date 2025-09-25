import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:core_kosmos/core_kosmos.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:skeleton_kosmos/skeleton_kosmos.dart';

abstract class CompleteProfilController {
  /// Vérification directe du code de confiance côté client
  static Future<bool> verifyTrustCodeDirect(String code) async {
    try {
      printInDebug(
        "[CompleteProfilController] Vérification du code de confiance: $code",
      );

      final codeQuery = await FirebaseFirestore.instance
          .collection("code")
          .where("code", isEqualTo: code)
          .get();

      final isValid = codeQuery.docs.isNotEmpty;
      printInDebug(
        "[CompleteProfilController] Code de confiance ${isValid ? 'valide' : 'invalide'}",
      );

      return isValid;
    } catch (e) {
      printInDebug(
        "[CompleteProfilController] Erreur lors de la vérification du code: $e",
      );
      return false;
    }
  }

  /// Création directe du document sponsorship côté client
  static Future<bool> createSponsorshipDirect(String code) async {
    try {
      printInDebug(
        "[CompleteProfilController] Création du document sponsorship avec code: $code",
      );

      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) {
        throw Exception("Utilisateur non connecté");
      }

      // 1. Récupérer les données de l'utilisateur actuel
      final selfDoc = await FirebaseFirestore.instance
          .collection(GetIt.instance<ApplicationDataModel>().userCollectionPath)
          .doc(currentUser.uid)
          .get();

      if (!selfDoc.exists) {
        throw Exception("Document utilisateur non trouvé");
      }

      final selfData = selfDoc.data()!;

      // 2. Trouver l'utilisateur propriétaire du code
      final codeQuery = await FirebaseFirestore.instance
          .collection("code")
          .where("code", isEqualTo: code)
          .get();

      if (codeQuery.docs.isEmpty) {
        throw Exception("Code de confiance invalide");
      }

      final userRef = codeQuery.docs.first.data()['user'] as DocumentReference;
      
      printInDebug("[CompleteProfilController] Utilisateur parrain: ${userRef.id}");

      // 3. Créer le document sponsorship avec structure simplifiée
      final sponsorshipDoc = <String, dynamic>{
        "user": <String, dynamic>{
          "id": selfDoc.id,
          "lastname": selfData['lastname'] ?? '',
          "firstname": selfData['firstname'] ?? '',
          "birthday": selfData['birthday'] is Timestamp 
              ? selfData['birthday'] 
              : (selfData['birthday'] != null 
                  ? Timestamp.fromDate(selfData['birthday'] as DateTime) 
                  : null),
        },
        "code": code,
        "isAccepted": false,
        "createdAt": DateTime.now().millisecondsSinceEpoch,
      };
      
      printInDebug("[CompleteProfilController] Données sponsorship à créer: $sponsorshipDoc");
      printInDebug("[CompleteProfilController] Chemin de création: ${userRef.path}/sponsorship");
      
      final docRef = await userRef.collection("sponsorship").add(sponsorshipDoc);
      printInDebug("[CompleteProfilController] Document créé avec ID: ${docRef.id}");

      // 4. La notification FCM sera envoyée automatiquement par le trigger Firestore
      // lors de la création du document sponsorship
      printInDebug(
        "[CompleteProfilController] Document sponsorship créé - Notification FCM sera envoyée automatiquement par le trigger",
      );

      printInDebug(
        "[CompleteProfilController] Document sponsorship créé avec succès",
      );
      return true;
    } catch (e) {
      printInDebug(
        "[CompleteProfilController] Erreur lors de la création du sponsorship: $e",
      );

      // Marquer le profil en erreur comme le faisait la cloud function
      try {
        await FirebaseFirestore.instance
            .collection(
              GetIt.instance<ApplicationDataModel>().userCollectionPath,
            )
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .update({"completeProfilStatus": "error"});
      } catch (updateError) {
        printInDebug(
          "[CompleteProfilController] Erreur lors de la mise à jour du statut: $updateError",
        );
      }

      return false;
    }
  }

  static Future<void> acceptUser(String userId, String requestId) async {
    try {
      // Marquer le document comme accepté
      await FirebaseFirestore.instance
          .collection("users")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection("sponsorship")
          .doc(requestId)
          .update({
            "isAccepted": true,
            "acceptedAt": FieldValue.serverTimestamp(),
          });

      // Activer le profil de l'utilisateur
      await FirebaseFirestore.instance.collection("users").doc(userId).update({
        "profilCompleted": true,
        "completeProfilStatus": "approved",
      });
    } catch (e) {
      printInDebug("[Except] ${e.toString()}");
    }
  }

  static Future<void> refuseUser(String userId, String requestId) async {
    try {
      await FirebaseFirestore.instance
          .collection("users")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection("sponsorship")
          .doc(requestId)
          .delete();
      await FirebaseFirestore.instance.collection("users").doc(userId).update({
        "completeProfilStatus": "error",
      });
    } catch (e) {
      printInDebug("[Except] ${e.toString()}");
    }
  }

}
