import 'dart:async';

import '../freezed/lastDeleteCompos/lastDeleteCompos.dart';
import '../freezed/message/messageModel.dart';
import '../freezed/salon/salonModel.dart';
import '../freezed/user/userModel.dart';
import 'salon_river.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SalonNotifier with ChangeNotifier {
  SalonModel? _currentSalon;
  LastDeleteCompos? lastDeleteCompos;
  SalonModel? get currentSalon => _currentSalon;
  Map<String, UserModel> _participant = {};
  Map<String, UserModel> get participant => _participant;
  StreamSubscription<DocumentSnapshot<Map<String, dynamic>>>? _streamSubSalon;
  StreamSubscription<DocumentSnapshot<Map<String, dynamic>>>?
  _streamSubscriptionLastDeletedUser;
  StreamSubscription<QuerySnapshot<Map<String, dynamic>>>? _streamSubMessage;
  Stream<QuerySnapshot<Map<String, dynamic>>>? _streamMessage;
  Ref providerRef;
  String? idSalon;
  void removeFromParticipants(String uid) {
    _participant.remove(uid);
    notifyListeners();
  }

  void addToParticipants(List<UserModel> list) {
    _participant.addAll(
      list.asMap().map<String, UserModel>(
        (key, value) => MapEntry(value.id!, value),
      ),
    );
    notifyListeners();
  }

  void _initSalonParticipant() {
    if (_participant.isEmpty) {
      for (String? element in _currentSalon!.users) {
        if (element != null) {
          FirebaseFirestore.instance
              .collection("users")
              .doc(element)
              .get()
              .then((DocumentSnapshot<Map<String, dynamic>> doc) {
                if (doc.exists) {
                  _participant[doc.id] = (UserModel.fromJson(
                    doc.data()!,
                  ).copyWith(id: doc.id));
                  notifyListeners();
                }
              });
        }
      }
    }
  }

  int limit = 20;

  SalonNotifier({required this.providerRef});
  void init({required String idSalon, required String userUid}) async {
    _participant = {};
    limit = 20;
    this.idSalon = idSalon;
    lastDeleteCompos = null;
    notifyListeners();

    await _streamSubSalon?.cancel();
    await _streamSubscriptionLastDeletedUser?.cancel();
    _streamSubscriptionLastDeletedUser = FirebaseFirestore.instance
        .collection("LastDeletedCompos")
        .doc(idSalon + userUid)
        .snapshots()
        .listen((last) {
          if (last.exists && last.data() != null) {
            lastDeleteCompos = LastDeleteCompos.fromJson(last.data()!);
            notifyListeners();
          }
        });
    _streamSubSalon = FirebaseFirestore.instance
        .collection('Salons')
        .doc(idSalon)
        .snapshots()
        .listen((salon) {
          if (salon.data() != null) {
            _currentSalon = SalonModel.fromJson(
              salon.data()!,
            ).copyWith(id: idSalon);
            notifyListeners();
            _initSalonParticipant();
          }
        });
    notifyListeners();
  }

  void _handleChange(QuerySnapshot<Map<String, dynamic>> event) {
    for (DocumentChange<Map<String, dynamic>> element in event.docChanges) {
      switch (element.type) {
        case DocumentChangeType.added:
        case DocumentChangeType.modified:
          debugPrint("Add||Update===========>${element.doc.id}");
          providerRef
              .read(salonMessagesNotifier)
              .addMessage(
                messageModel: MessageModel.fromJson(
                  element.doc.data()!,
                ).copyWith(id: element.doc.id),
              );
          break;
        case DocumentChangeType.removed:
          debugPrint("Remove===========>${element.doc.id}");

          providerRef
              .read(salonMessagesNotifier)
              .deleteMessage(messageModelID: element.doc.id);
          break;
      }
    }
  }

  Future<void> removeListnerToSalon() async {
    debugPrint("[SalonNotifier] Suspension de l'écoute des messages...");

    // Annuler seulement l'écoute des messages, pas les autres listeners
    await _streamSubMessage?.cancel();
    _streamSubMessage = null;

    // Nettoyer seulement les participants, garder les autres données
    _participant.clear();

    debugPrint("[SalonNotifier] ✓ Écoute des messages suspendue");
    notifyListeners();
  }

  void initMessages({required String salonId}) {
    // FirebaseFirestore.instance.collection("LastDeletedCompos").doc(salonId+ )
    _streamMessage = FirebaseFirestore.instance
        .collection('Salons')
        .doc(salonId)
        .collection("Messages")
        .orderBy("timeStamp", descending: true)
        .limit(limit)
        .snapshots();
    notifyListeners();
    _streamSubMessage = _streamMessage!.listen(_handleChange);
    notifyListeners();
  }

  void loadMore() {
    limit = limit + 20;
    notifyListeners();
    _streamMessage = FirebaseFirestore.instance
        .collection('Salons')
        .doc(idSalon)
        .collection("Messages")
        .orderBy("timeStamp", descending: true)
        .limit(limit)
        .snapshots();

    _streamSubMessage?.cancel();

    _streamSubMessage = _streamMessage!.listen(_handleChange);
    notifyListeners();
  }

  /// Nettoie complètement tous les listeners et données (utilisé uniquement lors de la déconnexion)
  void clear() {
    debugPrint("[SalonNotifier] Début du nettoyage complet des listeners...");

    // Annuler tous les listeners de manière asynchrone pour éviter les erreurs
    try {
      _streamSubSalon?.cancel();
      _streamSubMessage?.cancel();
      _streamSubscriptionLastDeletedUser?.cancel();
      debugPrint("[SalonNotifier] ✓ Listeners annulés avec succès");
    } catch (e) {
      debugPrint(
        "[SalonNotifier] ⚠️ Erreur lors de l'annulation des listeners: $e",
      );
    }

    // Réinitialiser toutes les variables
    _streamSubSalon = null;
    _streamSubMessage = null;
    _streamSubscriptionLastDeletedUser = null;
    _streamMessage = null;
    _currentSalon = null;
    lastDeleteCompos = null;
    _participant.clear();
    idSalon = null;

    debugPrint(
      "[SalonNotifier] ✓ Tous les listeners Firestore ont été annulés",
    );
    notifyListeners();
  }

  /// Suspension temporaire des listeners (utilisé lors de la navigation)
  void pauseListeners() {
    debugPrint("[SalonNotifier] Suspension temporaire des listeners...");

    // Suspendre seulement l'écoute des messages
    _streamSubMessage?.cancel();
    _streamSubMessage = null;

    debugPrint("[SalonNotifier] ✓ Listeners suspendus temporairement");
    notifyListeners();
  }

  /// Reprise des listeners après suspension
  void resumeListeners() {
    debugPrint("[SalonNotifier] Reprise des listeners...");

    // Réinitialiser les messages seulement si le listener n'est pas déjà actif
    if (idSalon != null && _streamSubMessage == null) {
      initMessages(salonId: idSalon!);
      debugPrint("[SalonNotifier] ✓ Écoute des messages reprise");
    } else if (_streamSubMessage != null) {
      debugPrint("[SalonNotifier] ✓ Écoute des messages déjà active");
    }

    notifyListeners();
  }

  @override
  void dispose() {
    _streamSubSalon?.cancel();
    _streamSubMessage?.cancel();
    _streamSubscriptionLastDeletedUser?.cancel();
    super.dispose();
  }
}
