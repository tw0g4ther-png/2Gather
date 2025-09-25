// Service de géolocalisation moderne utilisant les fonctionnalités natives de Firestore
// Remplace geoflutterfire par une solution plus moderne et compatible
// avec les versions récentes de cloud_firestore.
// Fonctionnalités :
// - Requêtes géospatiales avec Firestore
// - Calcul de distance entre points
// - Recherche de points dans un rayon donné
// - Support des requêtes géohash

import 'dart:math' as math;
import 'package:cloud_firestore/cloud_firestore.dart';

class GeolocationService {
  static const double _earthRadius = 6371000; // Rayon de la Terre en mètres

  /// Calcule la distance entre deux points géographiques (formule de Haversine)
  static double calculateDistance(
    double lat1,
    double lon1,
    double lat2,
    double lon2,
  ) {
    final dLat = _degreesToRadians(lat2 - lat1);
    final dLon = _degreesToRadians(lon2 - lon1);

    final a = math.sin(dLat / 2) * math.sin(dLat / 2) +
        math.cos(_degreesToRadians(lat1)) *
            math.cos(_degreesToRadians(lat2)) *
            math.sin(dLon / 2) *
            math.sin(dLon / 2);

    final c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));
    return _earthRadius * c; // Distance en mètres
  }

  /// Convertit les degrés en radians
  static double _degreesToRadians(double degrees) {
    return degrees * (math.pi / 180);
  }

  /// Génère un géohash pour un point géographique
  static String generateGeohash(double latitude, double longitude,
      {int precision = 10}) {
    final latRange = [-90.0, 90.0];
    final lonRange = [-180.0, 180.0];

    String geohash = '';
    bool isEven = true;
    int bit = 0;
    int ch = 0;

    while (geohash.length < precision) {
      if (isEven) {
        final mid = (lonRange[0] + lonRange[1]) / 2;
        if (longitude >= mid) {
          ch |= (1 << (4 - bit));
          lonRange[0] = mid;
        } else {
          lonRange[1] = mid;
        }
      } else {
        final mid = (latRange[0] + latRange[1]) / 2;
        if (latitude >= mid) {
          ch |= (1 << (4 - bit));
          latRange[0] = mid;
        } else {
          latRange[1] = mid;
        }
      }

      isEven = !isEven;

      if (bit < 4) {
        bit++;
      } else {
        geohash += _base32[ch];
        bit = 0;
        ch = 0;
      }
    }

    return geohash;
  }

  /// Trouve les points dans un rayon donné autour d'une position
  static Future<List<QueryDocumentSnapshot>> findNearbyPoints(
    CollectionReference collection,
    double centerLat,
    double centerLon,
    double radiusInKm, {
    String latitudeField = 'latitude',
    String longitudeField = 'longitude',
    int limit = 50,
  }) async {
    // Calculer les bornes de la zone de recherche
    final latDelta = radiusInKm / 111.0; // Approximation : 1 degré ≈ 111 km
    final lonDelta =
        radiusInKm / (111.0 * math.cos(_degreesToRadians(centerLat)));

    final minLat = centerLat - latDelta;
    final maxLat = centerLat + latDelta;
    final minLon = centerLon - lonDelta;
    final maxLon = centerLon + lonDelta;

    // Requête Firestore avec les bornes
    final query = collection
        .where(latitudeField, isGreaterThanOrEqualTo: minLat)
        .where(latitudeField, isLessThanOrEqualTo: maxLat)
        .where(longitudeField, isGreaterThanOrEqualTo: minLon)
        .where(longitudeField, isLessThanOrEqualTo: maxLon)
        .limit(limit);

    final snapshot = await query.get();
    final results = <QueryDocumentSnapshot>[];

    // Filtrer par distance exacte
    for (final doc in snapshot.docs) {
      final data = doc.data() as Map<String, dynamic>;
      final lat = data[latitudeField] as double?;
      final lon = data[longitudeField] as double?;

      if (lat != null && lon != null) {
        final distance = calculateDistance(centerLat, centerLon, lat, lon);
        if (distance <= radiusInKm * 1000) {
          // Convertir km en mètres
          results.add(doc);
        }
      }
    }

    // Trier par distance
    results.sort((a, b) {
      final dataA = a.data() as Map<String, dynamic>;
      final dataB = b.data() as Map<String, dynamic>;
      final latA = dataA[latitudeField] as double;
      final lonA = dataA[longitudeField] as double;
      final latB = dataB[latitudeField] as double;
      final lonB = dataB[longitudeField] as double;

      final distanceA = calculateDistance(centerLat, centerLon, latA, lonA);
      final distanceB = calculateDistance(centerLat, centerLon, latB, lonB);

      return distanceA.compareTo(distanceB);
    });

    return results;
  }

  /// Trouve les points dans un rayon donné en utilisant GeoPoint
  static Future<List<QueryDocumentSnapshot>> findNearbyPointsWithGeoPoint(
    CollectionReference collection,
    GeoPoint center,
    double radiusInKm, {
    String geoPointField = 'location',
    int limit = 50,
  }) async {
    return findNearbyPoints(
      collection,
      center.latitude,
      center.longitude,
      radiusInKm,
      latitudeField: '$geoPointField.latitude',
      longitudeField: '$geoPointField.longitude',
      limit: limit,
    );
  }

  /// Crée un GeoPoint à partir de latitude et longitude
  static GeoPoint createGeoPoint(double latitude, double longitude) {
    return GeoPoint(latitude, longitude);
  }

  /// Vérifie si un point est dans un rayon donné
  static bool isPointInRadius(
    double centerLat,
    double centerLon,
    double pointLat,
    double pointLon,
    double radiusInKm,
  ) {
    final distance =
        calculateDistance(centerLat, centerLon, pointLat, pointLon);
    return distance <= radiusInKm * 1000; // Convertir km en mètres
  }

  /// Calcule les bornes d'une zone rectangulaire autour d'un point
  static Map<String, double> calculateBounds(
    double centerLat,
    double centerLon,
    double radiusInKm,
  ) {
    final latDelta = radiusInKm / 111.0;
    final lonDelta =
        radiusInKm / (111.0 * math.cos(_degreesToRadians(centerLat)));

    return {
      'minLat': centerLat - latDelta,
      'maxLat': centerLat + latDelta,
      'minLon': centerLon - lonDelta,
      'maxLon': centerLon + lonDelta,
    };
  }

  /// Constante pour la conversion base32
  static const String _base32 = '0123456789bcdefghjkmnpqrstuvwxyz';
}

// Extension pour faciliter l'utilisation avec GeoPoint
extension GeoPointExtension on GeoPoint {
  /// Calcule la distance entre ce GeoPoint et un autre
  double distanceTo(GeoPoint other) {
    return GeolocationService.calculateDistance(
      latitude,
      longitude,
      other.latitude,
      other.longitude,
    );
  }

  /// Vérifie si ce point est dans un rayon donné d'un centre
  bool isInRadius(GeoPoint center, double radiusInKm) {
    return GeolocationService.isPointInRadius(
      center.latitude,
      center.longitude,
      latitude,
      longitude,
      radiusInKm,
    );
  }

  /// Génère un géohash pour ce point
  String toGeohash({int precision = 10}) {
    return GeolocationService.generateGeohash(latitude, longitude,
        precision: precision);
  }
}
