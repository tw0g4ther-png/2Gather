import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final geolocProvider = ChangeNotifierProvider<GeolocProvider>((ref) {
  return GeolocProvider();
});

class GeolocProvider with ChangeNotifier {
  GeoPoint? _geoloc;
  GeoPoint? get geoloc => _geoloc;

  StreamSubscription<Position>? _positionStream;
  StreamSubscription<Position>? get positionStream => _positionStream;

  bool _serviceEnabled = false;
  LocationPermission _permissionStatus = LocationPermission.denied;

  GeolocProvider();

  Future<void> init() async {
    try {
      await checkPermission();

      if (_serviceEnabled && (_permissionStatus == LocationPermission.whileInUse || _permissionStatus == LocationPermission.always)) {
        _positionStream = Geolocator.getPositionStream().listen((event) {
          _geoloc = GeoPoint(event.latitude, event.longitude);
          notifyListeners();
        });
      }
    } catch (e) {
      _positionStream?.cancel();
      _geoloc = null;
      notifyListeners();
      rethrow;
    }
  }

  Future<void> checkPermission() async {
    _serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!_serviceEnabled) {
      throw Exception("localizations-service-disabled");
    }

    _permissionStatus = await Geolocator.checkPermission();
    if (_permissionStatus == LocationPermission.denied) {
      _permissionStatus = await Geolocator.requestPermission();
      if (_permissionStatus == LocationPermission.denied) {
        throw Exception('localizations-autorisations-refused');
      }
    }

    if (_permissionStatus == LocationPermission.deniedForever) {
      throw Exception("localizations-autorisations-refused-forever");
    }
  }

  void addListenerToStream(void Function(Position?) listener) {
    if (_positionStream == null) throw Exception("localizations-stream-not-init");
    _positionStream!.onData(listener);
  }

  @override
  void dispose() {
    _positionStream?.cancel();
    super.dispose();
  }
}
