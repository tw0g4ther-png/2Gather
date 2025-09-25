import 'package:core_kosmos/core_package.dart';
import 'package:twogather/model/user/app_user/app_user_model.dart';
import 'package:twogather/services/user_card_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UserSwipeProvider with ChangeNotifier {
  List<AppUserModel>? users;
  AppUserModel? previousUsers;

  int actualImage = 0;

  Future getUsersList(String email, {Map<String, dynamic>? metadata}) async {
    actualImage = 0;
    printInDebug("getCardList");
    
    // Capturer l'UID de l'utilisateur au début pour détecter les changements
    final initialUserId = FirebaseAuth.instance.currentUser?.uid;
    if (initialUserId == null) {
      printInDebug("Utilisateur non connecté - Abandon getUsersList");
      users = [];
      notifyListeners();
      return;
    }
    
    // Préparer les paramètres en filtrant les valeurs nulles
    final Map<String, dynamic> parameters = {
      "userId": initialUserId,
      "email": email,
    };

    // Ajouter metadata seulement s'il n'est pas null
    if (metadata != null) {
      parameters["metadata"] = metadata;
    }

    // Appel unique sans retry
    const Duration timeout = Duration(seconds: 10);

    // Vérifier que l'utilisateur n'a pas changé avant l'appel
    if (FirebaseAuth.instance.currentUser?.uid != initialUserId) {
      printInDebug("Utilisateur changé pendant getUsersList ($initialUserId → ${FirebaseAuth.instance.currentUser?.uid}) - Arrêt");
      users = [];
      notifyListeners();
      return;
    }
    
    try {
      printInDebug("Appel direct UserCardService.getUserCardList");
        
      // Appel direct au service sans cloud function
      final result = await UserCardService.getUserCardList(
        email: email,
        userId: initialUserId,
        metadata: metadata,
      ).timeout(timeout);
      
      // Vérifier si la liste est vide
      if (result.isEmpty) {
        printInDebug("Liste vide retournée par UserCardService");
        users = [];
        notifyListeners();
        return;
      }

      // Convertir les données en AppUserModel
      users = result.map((userData) {
        Map<String, dynamic> map = Map<String, dynamic>.from(userData);
        
        // Traitement des tags (favorite)
        if (map.containsKey("favorite") && map["favorite"] != null) {
          Map<String, dynamic> sections = {};
          final favoriteData = map["favorite"] as Map;
          for (final section in favoriteData.keys) {
            final List sectionList = favoriteData[section] as List;
            List processedList = [];
            for (final item in sectionList) {
              if (item is Map) {
                Map<String, dynamic> processedItem = {};
                for (final key in item.keys) {
                  processedItem[key] = item[key];
                }
                processedList.add(processedItem);
              }
            }
            sections[section] = processedList;
          }
          map["tags"] = sections;
        } else {
          map["tags"] = null;
        }
        
        // Les données viennent déjà avec les bons types depuis Firestore
        return AppUserModel.fromJson(map).copyWith(
          pictures: map["profilImages"] != null 
            ? (map["profilImages"] as List).map((e) => e as String).toList()
            : null
        );
      }).toList();
        
      printInDebug("Succès pour UserCardService - ${users!.length} utilisateurs");
      notifyListeners();
      return;
        
      } catch (e) {
        printInDebug("Erreur pour getUserCardList: $e");
        
        // Vérifier si c'est une erreur de connectivité
        final isConnectivityError = e.toString().contains('UNAVAILABLE') || 
            e.toString().contains('Unable to resolve host') ||
            e.toString().contains('No address associated with hostname') ||
            e.toString().contains('timeout') ||
            e.toString().contains('connection') ||
            e.toString().contains('network');
        
        if (isConnectivityError) {
          printInDebug("Erreur de connectivité détectée pour getUserCardList");
        }
        
        printInDebug("Abandon pour getUserCardList");
        users = [];
        notifyListeners();
        return;
      }
  }

  void nextCard(String id) {
    actualImage = 0;
    previousUsers = users?.firstWhere((element) => element.id == id);
    users?.removeWhere((element) => element.id == id);
    notifyListeners();
  }

  void showPreviousCard() {
    if (previousUsers != null) {
      actualImage = 0;
      users?.insert(0, previousUsers!);
      previousUsers = null;
      notifyListeners();
    }
  }

  void clear() {
    actualImage = 0;
    users?.clear();
    previousUsers = null;
    notifyListeners();
  }

  /// Initialise le provider avec une liste vide pour éviter l'état null
  void initializeEmpty() {
    users = [];
    previousUsers = null;
    actualImage = 0;
    notifyListeners();
  }

  void nextImage() {
    actualImage++;
    notifyListeners();
  }

  void previousImage() {
    actualImage--;
    notifyListeners();
  }
}
