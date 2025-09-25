import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:core_kosmos/core_kosmos.dart';
import 'package:twogather/model/sponsorship/sponsorship_model.dart';
import 'package:twogather/pages/home/sponsorship/accept_user_page.dart';
import 'package:flutter/material.dart';

class SponsorshipProvider with ChangeNotifier {
  StreamSubscription<Object>? _subscription;
  List<SponsorshipModel> demand = [];
  bool _isInitialLoad = true;

  Future<void> init(String userId, BuildContext context) async {
    if (_subscription != null) {
      return;
    }
    
    printInDebug("[SponsorshipProvider] Initialisation du listener pour l'utilisateur: $userId");
    
    _subscription = FirebaseFirestore.instance
        .collection("users")
        .doc(userId)
        .collection("sponsorship")
        .snapshots()
        .listen((snapshot) {
          printInDebug("[SponsorshipProvider] Snapshot reçu avec ${snapshot.docChanges.length} changements");
          
          for (final e in snapshot.docChanges) {
            switch (e.type) {
              case DocumentChangeType.added:
                final docData = e.doc.data()!;
                
                final model = SponsorshipModel.fromJson(docData).copyWith(id: e.doc.id);
                
                printInDebug("[SponsorshipProvider] Document ajouté - ID: ${model.id}, isAccepted: ${model.isAccepted}, données brutes: ${docData['isAccepted']}");

                // Ajouter le document à la liste dans tous les cas
                demand.add(model);
                
                // Afficher AcceptUserPage seulement pour les documents non acceptés
                if (model.isAccepted == false) {
                  if (_isInitialLoad) {
                    printInDebug("[SponsorshipProvider] Document existant non accepté - Affichage d'AcceptUserPage: ${model.id}");
                  } else {
                    printInDebug("[SponsorshipProvider] Nouveau document non accepté - Affichage d'AcceptUserPage: ${model.id}");
                  }
                  
                  if (!context.mounted) return;
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => AcceptUserPage(user: model),
                    ),
                  );
                } else {
                  if (_isInitialLoad) {
                    printInDebug("[SponsorshipProvider] Document existant déjà accepté (${model.isAccepted}) - Pas d'affichage: ${model.id}");
                  } else {
                    printInDebug("[SponsorshipProvider] Nouveau document déjà accepté (${model.isAccepted}) - Pas d'affichage: ${model.id}");
                  }
                }
                break;
              case DocumentChangeType.modified:
                printInDebug("[SponsorshipProvider] Modified");
                int? index = demand.indexWhere(
                  (element) => element.id == e.doc.id,
                );
                if (index == -1) continue;
                demand[index] = SponsorshipModel.fromJson(
                  e.doc.data()!,
                ).copyWith(id: e.doc.id);
                break;
              case DocumentChangeType.removed:
                printInDebug("[SponsorshipProvider] Removed");
                demand.removeWhere(
                  (notification) => notification.id == e.doc.id,
                );
                break;
            }
          }
          
          // Marquer la fin du chargement initial après le premier snapshot
          if (_isInitialLoad) {
            _isInitialLoad = false;
            printInDebug("[SponsorshipProvider] Chargement initial terminé - ${demand.length} documents existants");
          }
        });
  }

  void clear() {
    printInDebug("[SponsorshipProvider] Nettoyage du provider");
    _subscription?.cancel();
    _subscription = null;
    demand = [];
    _isInitialLoad = true; // Réinitialiser pour la prochaine initialisation
  }
}
