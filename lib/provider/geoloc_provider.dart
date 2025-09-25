import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:core_kosmos/core_kosmos.dart';
import 'package:twogather/model/color.dart';
import 'package:twogather/pages/home_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get_it/get_it.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:skeleton_kosmos/skeleton_kosmos.dart';

class GeolocProvider with ChangeNotifier {
  Position? userPosition;
  String? _locality;

  StreamSubscription<Position>? _streamSubscription;

  String? get locality => _locality;

  set locality(String? value) {
    _locality = value;
    notifyListeners();
  }

  Future<void> loadPosition() async {
    // Pourquoi: éviter l'exception si l'utilisateur refuse la permission
    // et fournir un flux UX prévisible en demandant la permission sans rediriger vers les paramètres.
    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      if (permission == LocationPermission.deniedForever) {
        // Permission bloquée: ne pas ouvrir les paramètres, sortir proprement
        printInDebug("[GeolocProvider] Permission bloquée définitivement - continuer sans redirection");
        return;
      }
      if (permission == LocationPermission.denied) {
        // Refus simple: ne pas crasher, simplement sortir
        return;
      }

      final Position position = await Geolocator.getCurrentPosition();
      userPosition = position;

      final List<Placemark> placemarks = await placemarkFromCoordinates(
        userPosition!.latitude,
        userPosition!.longitude,
      );
      if (placemarks.isEmpty) return;

      locality = "${placemarks.first.locality}, ${placemarks.first.country}";
      await FirebaseFirestore.instance
          .collection(GetIt.I<ApplicationDataModel>().userCollectionPath)
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .update({
        'position': GeoPoint(userPosition!.latitude, userPosition!.longitude),
        'country': placemarks.first.country,
        'locality': locality,
      });
      notifyListeners();
    } catch (e) {
      // En cas d'erreur (ex: services désactivés), ne pas faire échouer l'app
      // On pourrait afficher un feedback utilisateur ailleurs selon le design.
      return;
    }
  }

  @override
  void dispose() {
    _streamSubscription?.cancel();
    super.dispose();
  }
}

class GeolocWidget extends ConsumerWidget {
  const GeolocWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SvgPicture.asset('assets/svg/ic_location.svg'),
        sw(5.5),
        if (ref.watch(geolocProvider)._locality != null) ...[
          Text(
            ref.watch(geolocProvider)._locality ?? "",
            style: AppTextStyle.darkGray(11.5),
          ),
        ],
      ],
    );
  }
}
