// Exemples d'utilisation du GeolocationService
//
// Ce fichier montre comment utiliser le service de géolocalisation
// pour remplacer les fonctionnalités de geoflutterfire.

import 'package:cloud_firestore/cloud_firestore.dart';
import 'geolocation_service.dart';

class GeolocationExample {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Exemple 1: Rechercher des utilisateurs proches
  Future<List<Map<String, dynamic>>> findNearbyUsers(
    double userLat,
    double userLon,
    double radiusInKm,
  ) async {
    final usersCollection = _firestore.collection('users');

    final nearbyUsers = await GeolocationService.findNearbyPoints(
      usersCollection,
      userLat,
      userLon,
      radiusInKm,
      latitudeField: 'location.latitude',
      longitudeField: 'location.longitude',
      limit: 20,
    );

    return nearbyUsers.map((doc) {
      final data = doc.data() as Map<String, dynamic>;
      return {
        'id': doc.id,
        'name': data['name'],
        'location': data['location'],
        'distance': GeolocationService.calculateDistance(
          userLat,
          userLon,
          data['location']['latitude'],
          data['location']['longitude'],
        ),
      };
    }).toList();
  }

  /// Exemple 2: Rechercher des événements proches avec GeoPoint
  Future<List<Map<String, dynamic>>> findNearbyEvents(
    GeoPoint userLocation,
    double radiusInKm,
  ) async {
    final eventsCollection = _firestore.collection('events');

    final nearbyEvents = await GeolocationService.findNearbyPointsWithGeoPoint(
      eventsCollection,
      userLocation,
      radiusInKm,
      geoPointField: 'location',
      limit: 30,
    );

    return nearbyEvents.map((doc) {
      final data = doc.data() as Map<String, dynamic>;
      final eventLocation = data['location'] as GeoPoint;
      return {
        'id': doc.id,
        'title': data['title'],
        'location': eventLocation,
        'distance': userLocation.distanceTo(eventLocation),
      };
    }).toList();
  }

  /// Exemple 3: Sauvegarder un point avec géohash
  Future<void> saveLocationWithGeohash(
    String userId,
    double latitude,
    double longitude,
    Map<String, dynamic> additionalData,
  ) async {
    final geohash = GeolocationService.generateGeohash(latitude, longitude);
    final geoPoint = GeolocationService.createGeoPoint(latitude, longitude);

    await _firestore.collection('user_locations').doc(userId).set({
      'location': geoPoint,
      'latitude': latitude,
      'longitude': longitude,
      'geohash': geohash,
      'timestamp': FieldValue.serverTimestamp(),
      ...additionalData,
    });
  }

  /// Exemple 4: Recherche par géohash (plus efficace pour les requêtes fréquentes)
  Future<List<Map<String, dynamic>>> findNearbyByGeohash(
    double centerLat,
    double centerLon,
    double radiusInKm,
  ) async {
    final centerGeohash =
        GeolocationService.generateGeohash(centerLat, centerLon);
    final precision = _calculateGeohashPrecision(radiusInKm);

    // Prendre les premiers caractères du géohash pour la recherche
    final geohashPrefix = centerGeohash.substring(0, precision);

    final query = _firestore
        .collection('user_locations')
        .where('geohash', isGreaterThanOrEqualTo: geohashPrefix)
        .where('geohash', isLessThan: '$geohashPrefix~')
        .limit(50);

    final snapshot = await query.get();
    final results = <Map<String, dynamic>>[];

    for (final doc in snapshot.docs) {
      final data = doc.data();
      final lat = data['latitude'] as double;
      final lon = data['longitude'] as double;

      if (GeolocationService.isPointInRadius(
          centerLat, centerLon, lat, lon, radiusInKm)) {
        results.add({
          'id': doc.id,
          'data': data,
          'distance': GeolocationService.calculateDistance(
              centerLat, centerLon, lat, lon),
        });
      }
    }

    // Trier par distance
    results.sort(
        (a, b) => (a['distance'] as double).compareTo(b['distance'] as double));

    return results;
  }

  /// Exemple 5: Calculer les bornes d'une zone de recherche
  Map<String, double> getSearchBounds(
    double centerLat,
    double centerLon,
    double radiusInKm,
  ) {
    return GeolocationService.calculateBounds(centerLat, centerLon, radiusInKm);
  }

  /// Exemple 6: Vérifier si un utilisateur est dans une zone
  bool isUserInZone(
    GeoPoint userLocation,
    GeoPoint zoneCenter,
    double zoneRadiusInKm,
  ) {
    return userLocation.isInRadius(zoneCenter, zoneRadiusInKm);
  }

  /// Calcule la précision du géohash nécessaire pour un rayon donné
  int _calculateGeohashPrecision(double radiusInKm) {
    if (radiusInKm >= 1000) return 2;
    if (radiusInKm >= 100) return 3;
    if (radiusInKm >= 10) return 4;
    if (radiusInKm >= 1) return 5;
    if (radiusInKm >= 0.1) return 6;
    return 7;
  }
}

/// Exemple d'utilisation dans un widget
class LocationSearchWidget {
  final GeolocationExample _geoExample = GeolocationExample();

  Future<void> searchNearbyPlaces(double lat, double lon) async {
    // Rechercher des lieux dans un rayon de 5 km
    final nearbyPlaces = await _geoExample.findNearbyUsers(lat, lon, 5.0);

    print('Lieux trouvés: ${nearbyPlaces.length}');
    for (final place in nearbyPlaces) {
      print(
          '${place['name']} - Distance: ${(place['distance'] / 1000).toStringAsFixed(2)} km');
    }
  }

  Future<void> saveUserLocation(String userId, double lat, double lon) async {
    await _geoExample.saveLocationWithGeohash(
      userId,
      lat,
      lon,
      {
        'lastSeen': DateTime.now().toIso8601String(),
        'accuracy': 10.0, // Précision en mètres
      },
    );
  }
}
