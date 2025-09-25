import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:twogather/model/fiesta/user_fiesta_model.dart';
import "package:flutter/material.dart";
import 'package:get_it/get_it.dart';
import 'package:skeleton_kosmos/skeleton_kosmos.dart';

class UserFiestaProvider with ChangeNotifier {
  /// Created Fiesta
  List<UserFiestaModel>? createdFiesta;
  StreamSubscription<QuerySnapshot>? _createdFiestaSubscription;

  /// Participated Fiesta
  List<UserFiestaModel>? userFiestaParticipatedList;
  StreamSubscription<QuerySnapshot>? _streamSubscriptionParticipated;

  Future<void> init(String userId) async {
    _createdFiestaSubscription = FirebaseFirestore.instance
        .collection(GetIt.I<ApplicationDataModel>().userCollectionPath)
        .doc(userId)
        .collection("created-fiesta")
        .snapshots()
        .listen((snapshot) {
      createdFiesta = snapshot.docs
          .map((doc) =>
              UserFiestaModel.fromJson(doc.data()).copyWith(id: doc.id))
          .toList();
      notifyListeners();
    }, onError: (Object error, StackTrace stack) {
      // Pourquoi: éviter l'exception non gérée si les règles refusent l'accès
      createdFiesta = const [];
      notifyListeners();
    });

    _streamSubscriptionParticipated = FirebaseFirestore.instance
        .collection(GetIt.I<ApplicationDataModel>().userCollectionPath)
        .doc(userId)
        .collection("participated-fiesta")
        .snapshots()
        .listen((snapshot) {
      userFiestaParticipatedList = snapshot.docs
          .map((doc) =>
              UserFiestaModel.fromJson(doc.data()).copyWith(id: doc.id))
          .toList();
      notifyListeners();
    }, onError: (Object error, StackTrace stack) {
      // Pourquoi: éviter l'exception non gérée si les règles refusent l'accès
      userFiestaParticipatedList = const [];
      notifyListeners();
    });
  }

  @override
  void dispose() {
    _createdFiestaSubscription?.cancel();
    _streamSubscriptionParticipated?.cancel();
    super.dispose();
  }

  void clear() {
    createdFiesta = null;
    userFiestaParticipatedList = null;
    _createdFiestaSubscription?.cancel();
    _streamSubscriptionParticipated?.cancel();
  }
}
