import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:core_kosmos/core_package.dart';
import 'dart:math' as math;

/// Service qui remplace la cloud function getUserCardList
/// Implémentation directe côté client pour éviter les problèmes App Check
class UserCardService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Récupère la liste des utilisateurs pour le swipe
  /// Remplace la cloud function getUserCardList
  static Future<List<Map<String, dynamic>>> getUserCardList({
    required String email,
    required String userId,
    Map<String, dynamic>? metadata,
  }) async {
    try {
      printInDebug(
        "[UserCardService] Début getUserCardList pour utilisateur: $userId",
      );

      // Vérifier que l'utilisateur est authentifié
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) {
        throw Exception('Utilisateur non authentifié');
      }

      // Vérifier que l'utilisateur authentifié correspond à celui demandé
      if (currentUser.uid != userId) {
        throw Exception('Vous ne pouvez accéder qu\'à vos propres données');
      }

      // 1. Récupérer tous les utilisateurs sauf l'utilisateur actuel
      final usersQuery = await _firestore
          .collection("users")
          .where("email", isNotEqualTo: email)
          .get();

      var userList = usersQuery.docs;
      printInDebug("[UserCardService] ${userList.length} utilisateurs trouvés");

      // 2. Filtrer les utilisateurs sans email, email vide, ou email système
      userList = userList.where((user) {
        final data = user.data();
        final String? emailValue = (data['email'] as String?);
        if (emailValue == null || emailValue.trim().isEmpty) {
          return false;
        }
        return emailValue != "contact@fiesta.family";
      }).toList();

      // 3. Filtrer les emails des amis existants si fournis dans metadata
      if (metadata != null && metadata['friendEmailList'] != null) {
        final friendEmailList = metadata['friendEmailList'] as List<dynamic>;
        if (friendEmailList.isNotEmpty) {
          userList = userList.where((user) {
            return !friendEmailList.contains(user.data()['email']);
          }).toList();
        }
      }

      // 4. Récupérer les données de l'utilisateur actuel
      final userDoc = await _firestore.collection("users").doc(userId).get();

      if (!userDoc.exists) {
        printInDebug(
          "[UserCardService] Document utilisateur $userId n'existe pas",
        );
        return [];
      }

      final userData = userDoc.data()!;

      // Vérifier que le document n'est pas vide
      if (userData.isEmpty) {
        printInDebug("[UserCardService] Document utilisateur $userId est vide");
        return [];
      }

      // Vérifier que les champs essentiels existent
      if (userData['position'] == null) {
        printInDebug(
          "[UserCardService] Position manquante pour l'utilisateur $userId",
        );
        return [];
      }

      final userPosition = userData['position'] as GeoPoint;
      var currentPosition = userPosition;

      // Utiliser la position des metadata si fournie
      if (metadata != null && metadata['location'] != null) {
        currentPosition = metadata['location'] as GeoPoint;
      }

      // 5. Calculer les scores et filtrer les utilisateurs
      List<Map<String, dynamic>> userCardList = [];

      for (var userDoc in userList) {
        final friendId = userDoc.id;
        final friendData = userDoc.data();

        // Vérifier si on peut montrer cet utilisateur
        if (userId != friendId &&
            _isOkayToShow(
              userData['friendsDismissed'],
              userData['friends'],
              friendId,
              userData['bloquedUser'],
              userData['friendsRequest'],
            )) {
          var friendCard = Map<String, dynamic>.from(friendData);
          friendCard['id'] = friendId;

          // Calculer le score total
          int totalPoint = 0;

          // Calcul de la distance
          if (friendData['position'] != null) {
            final friendPosition = friendData['position'] as GeoPoint;
            final dist = _calculateDistance(
              currentPosition.latitude,
              currentPosition.longitude,
              friendPosition.latitude,
              friendPosition.longitude,
            );

            final maxDistance = ((metadata?['visibilty'] ?? 50) * 1000)
                .toDouble();

            if (dist < (maxDistance / 10)) {
              totalPoint += 100;
            } else if (dist < (maxDistance / 5)) {
              totalPoint += 50;
            } else if (dist < (maxDistance / 2)) {
              totalPoint += 20;
            } else if (dist < maxDistance) {
              totalPoint += 10;
            } else {
              totalPoint -= (200 + (dist - maxDistance)).toInt();
            }
          }

          // Calcul de l'âge
          if (friendData['birthday'] != null) {
            final userAge = _calculateAge(friendData['birthday'] as Timestamp);
            final maxAge = metadata?['age_max'] ?? 70;
            final minAge = metadata?['age_min'] ?? 18;

            if (userAge >= minAge && userAge <= maxAge) {
              totalPoint += 20;
            }
          }

          userCardList.add({'point': totalPoint, 'user': friendCard});
        }
      }

      // 6. Trier par score décroissant
      userCardList.sort(
        (a, b) => (b['point'] as int).compareTo(a['point'] as int),
      );

      // 7. Extraire les données utilisateur
      final result = userCardList
          .map((item) => item['user'] as Map<String, dynamic>)
          .toList();

      printInDebug(
        "[UserCardService] ${result.length} utilisateurs retournés après filtrage",
      );
      return result;
    } catch (e) {
      printInDebug("[UserCardService] Erreur getUserCardList: $e");
      rethrow;
    }
  }

  /// Vérifie si un utilisateur peut être affiché dans la liste de swipe
  static bool _isOkayToShow(
    dynamic dismissedFriends,
    dynamic friends,
    String friendId,
    dynamic blockedUsers,
    dynamic requestedFriends,
  ) {
    // Vérifier les amis rejetés (friendsDismissed)
    if (dismissedFriends is List && dismissedFriends.contains(friendId)) {
      return false;
    }

    // Vérifier les demandes d'amis en attente
    if (requestedFriends is List && requestedFriends.contains(friendId)) {
      return false;
    }

    // Vérifier les utilisateurs bloqués
    if (blockedUsers is List && blockedUsers.contains(friendId)) {
      return false;
    }

    // Vérifier les amis existants
    if (friends is List) {
      for (final friend in friends) {
        if (friend is Map && friend['user'] is DocumentReference) {
          if ((friend['user'] as DocumentReference).id == friendId) {
            return false;
          }
        }
      }
    }

    return true;
  }

  /// Calcule l'âge à partir d'un Timestamp
  static int _calculateAge(Timestamp birthTimestamp) {
    final today = DateTime.now();
    final birthDate = birthTimestamp.toDate();
    int age = today.year - birthDate.year;
    final monthDiff = today.month - birthDate.month;

    if (monthDiff < 0 || (monthDiff == 0 && today.day < birthDate.day)) {
      age--;
    }

    return age;
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
