import 'package:twogather/model/fiesta/fiesta_model.dart';
import 'package:twogather/services/fiesta_service.dart';
import 'package:core_kosmos/core_package.dart';
import 'package:flutter/material.dart';

class FiestaSwipeProvider with ChangeNotifier {
  List<FiestaModel>? fiestas;
  FiestaModel? previousFiesta;
  bool isLoading = false;

  int actualImage = 0;

  Future<void> getFiestaList(
    String userId, {
    Map<String, dynamic>? metadata,
  }) async {
    actualImage = 0;
    isLoading = true;
    notifyListeners();

    // Appel unique sans retry
    const Duration timeout = Duration(seconds: 10);

    try {
      printInDebug("Appel direct FiestaService.getFiestaList");

      // Appel direct au service sans cloud function
      final result = await FiestaService.getFiestaList(
        userId: userId,
        metadata: metadata,
      ).timeout(timeout);

      // Vérifier si la liste est vide
      if (result.isEmpty) {
        printInDebug("Liste vide retournée par FiestaService");
        fiestas = [];
        isLoading = false;
        notifyListeners();
        return;
      }

      // Convertir les données en FiestaModel
      fiestas = result.map((fiestaData) {
        Map<String, dynamic> map = Map<String, dynamic>.from(fiestaData);

        // Les données viennent déjà avec les bons types depuis Firestore
        // Pas besoin de conversion complexe comme avec les cloud functions

        return FiestaModel.fromJson(map).copyWith(id: map["id"] ?? "");
      }).toList();

      printInDebug("Succès pour FiestaService - ${fiestas!.length} fiestas");
      isLoading = false;
      notifyListeners();
      return;
    } catch (e) {
      printInDebug("Erreur pour getFiestaList: $e");

      // Vérifier si c'est une erreur de connectivité
      final isConnectivityError =
          e.toString().contains('UNAVAILABLE') ||
          e.toString().contains('Unable to resolve host') ||
          e.toString().contains('No address associated with hostname') ||
          e.toString().contains('timeout') ||
          e.toString().contains('connection') ||
          e.toString().contains('network');

      if (isConnectivityError) {
        printInDebug("Erreur de connectivité détectée pour getFiestaList");
      }

      printInDebug("Abandon pour getFiestaList");
      fiestas = [];
      isLoading = false;
      notifyListeners();
      return;
    }
  }

  void nextFiesta(String id) {
    actualImage = 0;
    previousFiesta = fiestas?.firstWhere((element) {
      return element.id == id;
    });
    fiestas?.removeWhere((element) => element.id == id);
    notifyListeners();
  }

  void nextImage() {
    actualImage++;
    notifyListeners();
  }

  void clear() {
    fiestas?.clear();
    fiestas = null;
    previousFiesta = null;
    actualImage = 0;
    isLoading = false;
    notifyListeners();
  }

  /// Initialise le provider avec un état neutre pour éviter l'affichage prématuré
  void initializeEmpty() {
    fiestas = null;
    previousFiesta = null;
    actualImage = 0;
    isLoading = false;
    notifyListeners();
  }

  void previousImage() {
    actualImage--;
    notifyListeners();
  }

  void showPreviousCard() {
    if (previousFiesta != null) {
      actualImage = 0;
      fiestas?.insert(0, previousFiesta!);
      previousFiesta = null;
      notifyListeners();
    }
  }
}
