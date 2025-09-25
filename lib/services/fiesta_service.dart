import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:core_kosmos/core_package.dart';
import 'dart:math' as math;

/// Service qui remplace la cloud function getFiestaList
/// Implémentation directe côté client pour éviter les problèmes App Check
class FiestaService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Récupère la liste des fiestas pour le swipe
  /// Remplace la cloud function getFiestaList
  static Future<List<Map<String, dynamic>>> getFiestaList({
    required String userId,
    Map<String, dynamic>? metadata,
  }) async {
    try {
      // Vérifier que l'utilisateur est authentifié
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) {
        throw Exception('Utilisateur non authentifié');
      }

      printInDebug(
        "[FiestaService] Début getFiestaList pour utilisateur: ${currentUser.uid}",
      );

      // 1. Récupérer les données de l'utilisateur connecté (utiliser l'UID, pas l'email)
      final userDoc = await _firestore
          .collection("users")
          .doc(currentUser.uid)
          .get();

      if (!userDoc.exists) {
        printInDebug(
          "[FiestaService] Document utilisateur ${currentUser.uid} n'existe pas",
        );
        throw Exception('Document utilisateur non trouvé');
      }

      final userData = userDoc.data()!;
      printInDebug("[FiestaService] Données utilisateur récupérées");

      // 2. Déterminer la position de l'utilisateur
      GeoPoint? userPosition;
      if (userData['position'] != null) {
        userPosition = userData['position'] as GeoPoint;
      }
      if (metadata != null && metadata['location'] != null) {
        userPosition = metadata['location'] as GeoPoint;
      }

      // 3. Récupérer toutes les fiestas actives (non terminées)
      // Récupérer toutes les fiestas et filtrer côté client pour plus de flexibilité
      final fiestaQuery = await _firestore.collection("fiesta").get();

      printInDebug(
        "[FiestaService] ${fiestaQuery.docs.length} fiestas trouvées",
      );

      // 4. Calculer les scores et filtrer les fiestas
      List<Map<String, dynamic>> fiestaCardList = [];
      int activeFiestasCount = 0;

      for (final fiestaDoc in fiestaQuery.docs) {
        final fiestaId = fiestaDoc.id;
        final fiestaData = fiestaDoc.data();

        // Log détaillé de chaque fiesta
        printInDebug("[FiestaService] === FIESTA $fiestaId ===");
        printInDebug("[FiestaService] Données complètes: $fiestaData");
        printInDebug(
          "[FiestaService] endAt: ${fiestaData['endAt']} (type: ${fiestaData['endAt']?.runtimeType})",
        );
        printInDebug(
          "[FiestaService] isEnd: ${fiestaData['isEnd']} (type: ${fiestaData['isEnd']?.runtimeType})",
        );
        printInDebug("[FiestaService] host: ${fiestaData['host']}");
        printInDebug(
          "[FiestaService] participants: ${fiestaData['participants']}",
        );
        printInDebug(
          "[FiestaService] visibleByConnexion: ${fiestaData['visibleByConnexion']}",
        );
        printInDebug(
          "[FiestaService] visibleByFiestar: ${fiestaData['visibleByFiestar']}",
        );
        printInDebug(
          "[FiestaService] visibleByFirstCircle: ${fiestaData['visibleByFirstCircle']}",
        );

        // Vérifier si la fiesta est active (non terminée)
        final now = Timestamp.now();
        bool isFiestaActive = false;

        if (fiestaData['endAt'] != null && fiestaData['endAt'] is Timestamp) {
          // Si endAt existe, vérifier qu'elle est dans le futur
          final endAt = fiestaData['endAt'] as Timestamp;
          isFiestaActive = endAt.compareTo(now) > 0;
        } else if (fiestaData['isEnd'] != null) {
          // Sinon, utiliser isEnd comme fallback
          isFiestaActive = fiestaData['isEnd'] == false;
        } else {
          // Si aucun champ n'existe, considérer comme active par défaut
          isFiestaActive = true;
        }

        printInDebug(
          "[FiestaService] Fiesta $fiestaId est active: $isFiestaActive",
        );

        if (!isFiestaActive) {
          printInDebug("[FiestaService] Fiesta $fiestaId ignorée car terminée");
          continue; // Ignorer les fiestas terminées
        }

        activeFiestasCount++;
        printInDebug(
          "[FiestaService] Fiesta $fiestaId ajoutée aux fiestas actives",
        );

        // Vérifier si on peut montrer cette fiesta à l'utilisateur
        final canShow = _canShowFiestaForUser(
          currentUser.uid,
          userData,
          fiestaId,
          fiestaData,
        );
        final visibilityOk = await _fiestaVisibilityIsOkay(
          currentUser.uid,
          userData,
          fiestaId,
          fiestaData,
        );

        printInDebug(
          "[FiestaService] Fiesta $fiestaId - canShow: $canShow, visibilityOk: $visibilityOk",
        );

        if (canShow && visibilityOk) {
          int totalPoint = 0;

          printInDebug(
            "[FiestaService] Fiesta $fiestaId autorisée - Calcul du score",
          );
          printInDebug(
            "[FiestaService] Address: ${fiestaData['address']} (type: ${fiestaData['address']?.runtimeType})",
          );

          // Calcul de la distance
          try {
            if (fiestaData['address'] != null &&
                fiestaData['address'] is Map &&
                fiestaData['address']['geopoint'] != null &&
                userPosition != null) {
              printInDebug(
                "[FiestaService] Calcul de distance pour fiesta $fiestaId",
              );
              final fiestaPosition =
                  fiestaData['address']['geopoint'] as GeoPoint;
              final dist = _calculateDistance(
                userPosition.latitude,
                userPosition.longitude,
                fiestaPosition.latitude,
                fiestaPosition.longitude,
              );

              final maxDistance = ((metadata?['visibility'] ?? 50) * 1000)
                  .toDouble();

              if (dist < (maxDistance / 10)) {
                totalPoint += (100 + (maxDistance - dist)).toInt();
              } else if (dist < (maxDistance / 5)) {
                totalPoint += (50 + (maxDistance - dist)).toInt();
              } else if (dist < (maxDistance / 2)) {
                totalPoint += (20 + (maxDistance - dist)).toInt();
              } else if (dist < maxDistance) {
                totalPoint += (10 + (maxDistance - dist)).toInt();
              } else {
                totalPoint -= (200 + (dist - maxDistance)).toInt();
              }
              printInDebug(
                "[FiestaService] Distance calculée: $dist, Points distance: $totalPoint",
              );
            } else {
              printInDebug(
                "[FiestaService] Pas de calcul de distance - address non compatible ou userPosition null",
              );
            }
          } catch (e) {
            printInDebug(
              "[FiestaService] Erreur lors du calcul de distance: $e",
            );
            // Continuer sans calcul de distance
          }

          // Vérifier la catégorie de la fiesta
          if (metadata != null &&
              fiestaData['category'] != null &&
              fiestaData['category'] == metadata['category']) {
            totalPoint += 20;
          }

          // Créer l'objet fiesta avec l'ID
          try {
            final fiestaWithId = Map<String, dynamic>.from(fiestaData);
            fiestaWithId['id'] = fiestaId;

            fiestaCardList.add({'fiesta': fiestaWithId, 'point': totalPoint});
            printInDebug(
              "[FiestaService] Fiesta $fiestaId ajoutée à la liste finale avec $totalPoint points",
            );
          } catch (e) {
            printInDebug(
              "[FiestaService] Erreur lors de l'ajout de la fiesta $fiestaId: $e",
            );
          }
        } else {
          printInDebug(
            "[FiestaService] Fiesta $fiestaId rejetée par les filtres de visibilité",
          );
        }
      }

      // 5. Trier par score décroissant
      fiestaCardList.sort(
        (a, b) => (b['point'] as int).compareTo(a['point'] as int),
      );

      // 6. Extraire les données des fiestas
      final result = fiestaCardList
          .map((item) => item['fiesta'] as Map<String, dynamic>)
          .toList();

      printInDebug(
        "[FiestaService] $activeFiestasCount fiestas actives trouvées, ${result.length} fiestas retournées après filtrage",
      );
      return result;
    } catch (e) {
      printInDebug("[FiestaService] Erreur getFiestaList: $e");
      rethrow;
    }
  }

  /// Vérifie si une fiesta peut être affichée à l'utilisateur
  static bool _canShowFiestaForUser(
    String userId,
    Map<String, dynamic> userData,
    String fiestaId,
    Map<String, dynamic> fiestaData,
  ) {
    // Vérifier si la fiesta a été rejetée
    if (userData['fiestaDismissed'] != null &&
        userData['fiestaDismissed'] is List &&
        (userData['fiestaDismissed'] as List).contains(fiestaId)) {
      return false;
    }

    // Vérifier si l'utilisateur est l'hôte
    if (fiestaData['host'] != null &&
        fiestaData['host'] is DocumentReference &&
        (fiestaData['host'] as DocumentReference).id == userId) {
      return false;
    }

    // Vérifier les participants
    final participants = fiestaData['participants'];
    if (participants != null && participants is List) {
      for (final participant in participants) {
        if (participant is Map) {
          // Vérifier les utilisateurs bloqués
          if (userData['bloquedUser'] != null &&
              userData['bloquedUser'] is List) {
            final blockedUsers = userData['bloquedUser'] as List;
            if (participant['userRef'] != null &&
                blockedUsers.contains(participant['userRef'])) {
              return false;
            }
            if (participant['duoRef'] != null &&
                blockedUsers.contains(participant['duoRef'])) {
              return false;
            }
          }

          // Vérifier si l'utilisateur participe déjà
          if (participant['userRef'] == userId ||
              participant['duoRef'] == userId) {
            return false;
          }
        }
      }
    }

    return true;
  }

  /// Vérifie la visibilité de la fiesta selon les paramètres de l'hôte
  static Future<bool> _fiestaVisibilityIsOkay(
    String userId,
    Map<String, dynamic> userData,
    String fiestaId,
    Map<String, dynamic> fiestaData,
  ) async {
    try {
      final visibleByConnexion = fiestaData['visibleByConnexion'] ?? true;
      final visibleByFiestar = fiestaData['visibleByFiestar'] ?? true;
      final visibleByFirstCircle = fiestaData['visibleByFirstCircle'] ?? true;

      // Récupérer les données de l'hôte
      String? hostId;

      if (fiestaData['host'] == null) {
        return false;
      }

      // Gérer les deux formats de host : DocumentReference ou objet avec id
      if (fiestaData['host'] is DocumentReference) {
        final hostRef = fiestaData['host'] as DocumentReference;
        hostId = hostRef.id;
      } else if (fiestaData['host'] is Map &&
          fiestaData['host']['id'] != null) {
        hostId = fiestaData['host']['id'] as String;
      } else {
        printInDebug(
          "[FiestaService] Format de host non supporté: ${fiestaData['host']}",
        );
        return false;
      }

      final hostDoc = await _firestore.collection("users").doc(hostId).get();

      if (!hostDoc.exists) {
        return false;
      }

      final hostData = hostDoc.data()!;

      printInDebug(
        "[FiestaService] Vérification visibilité pour fiesta $fiestaId",
      );
      printInDebug("[FiestaService] Hôte: $hostId, Utilisateur: $userId");
      printInDebug(
        "[FiestaService] visibleByFiestar: $visibleByFiestar, visibleByConnexion: $visibleByConnexion, visibleByFirstCircle: $visibleByFirstCircle",
      );

      // Vérifier les amis de l'hôte
      if (hostData['friends'] != null && hostData['friends'] is List) {
        final friends = hostData['friends'] as List;
        printInDebug("[FiestaService] Hôte a ${friends.length} amis");

        bool userFoundInFriends = false;
        String? userFriendType;

        for (int i = 0; i < friends.length; i++) {
          final friend = friends[i];
          printInDebug("[FiestaService] Ami $i: $friend");

          if (friend is Map &&
              friend['user'] != null &&
              friend['user'] is DocumentReference &&
              (friend['user'] as DocumentReference).id == userId) {
            userFoundInFriends = true;
            userFriendType = friend['type'] as String?;
            printInDebug(
              "[FiestaService] Utilisateur trouvé dans les amis avec type: $userFriendType",
            );

            if (userFriendType == 'fiestar' && visibleByFiestar) {
              printInDebug("[FiestaService] Accès autorisé via fiestar");
              return true;
            }
            if (userFriendType == 'connexion' && visibleByConnexion) {
              printInDebug("[FiestaService] Accès autorisé via connexion");
              return true;
            }
            if (userFriendType == '1_circle' && visibleByFirstCircle) {
              printInDebug("[FiestaService] Accès autorisé via 1_circle");
              return true;
            }

            // Utilisateur trouvé mais type non autorisé
            printInDebug(
              "[FiestaService] Utilisateur trouvé mais type '$userFriendType' non autorisé pour cette fiesta",
            );
            break; // Sortir de la boucle car on a trouvé l'utilisateur
          }
        }

        if (!userFoundInFriends) {
          printInDebug(
            "[FiestaService] Utilisateur $userId non trouvé dans les amis de l'hôte $hostId",
          );
        }
      } else {
        printInDebug(
          "[FiestaService] Hôte $hostId n'a pas d'amis ou le champ friends n'est pas une liste",
        );
      }

      printInDebug("[FiestaService] Accès refusé - utilisateur non autorisé");
      return false;
    } catch (e) {
      printInDebug("[FiestaService] Erreur dans _fiestaVisibilityIsOkay: $e");
      return false;
    }
  }

  /// Calcule la distance entre deux points géographiques en kilomètres
  static double _calculateDistance(
    double lat1,
    double lon1,
    double lat2,
    double lon2,
  ) {
    if (lat1 == lat2 && lon1 == lon2) {
      return 0;
    }

    const double radiusEarth = 6371; // Rayon de la Terre en kilomètres
    final double radLat1 = lat1 * math.pi / 180;
    final double radLat2 = lat2 * math.pi / 180;
    final double deltaLat = (lat2 - lat1) * math.pi / 180;
    final double deltaLon = (lon2 - lon1) * math.pi / 180;

    final double a =
        math.sin(deltaLat / 2) * math.sin(deltaLat / 2) +
        math.cos(radLat1) *
            math.cos(radLat2) *
            math.sin(deltaLon / 2) *
            math.sin(deltaLon / 2);

    final double c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));
    final double distance = radiusEarth * c;

    return distance;
  }
}
