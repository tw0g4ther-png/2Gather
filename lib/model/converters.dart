import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:core_kosmos/core_package.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:skeleton_kosmos/skeleton_kosmos.dart';

class DocumentReferenceJsonConverter implements JsonConverter<DocumentReference?, Object?> {
  const DocumentReferenceJsonConverter();

  @override
  DocumentReference? fromJson(Object? json) {
    printInDebug(json);
    return (json as DocumentReference?);
  }

  @override
  Object? toJson(DocumentReference? documentReference) => documentReference;
}

class ToIntJsonConverter implements JsonConverter<int, num> {
  const ToIntJsonConverter();

  @override
  int fromJson(num json) {
    return json.toInt();
  }

  @override
  num toJson(int object) {
    return object;
  }
}

class TimestampConverter implements JsonConverter<DateTime?, Object?> {
  const TimestampConverter();

  @override
  DateTime? fromJson(Object? json) {
    if (json == null) return null;
    
    // Si c'est déjà un Timestamp, le convertir en DateTime
    if (json is Timestamp) {
      return json.toDate();
    }
    
    // Si c'est une String, essayer de la parser en DateTime
    if (json is String) {
      try {
        return DateTime.parse(json);
      } catch (e) {
        printInDebug("[TimestampConverter] Erreur lors du parsing de la String '$json': $e");
        return null;
      }
    }
    
    // Si c'est un int (milliseconds depuis epoch)
    if (json is int) {
      try {
        return DateTime.fromMillisecondsSinceEpoch(json);
      } catch (e) {
        printInDebug("[TimestampConverter] Erreur lors de la conversion de l'int $json: $e");
        return null;
      }
    }
    
    printInDebug("[TimestampConverter] Type non supporté: ${json.runtimeType}, valeur: $json");
    return null;
  }

  @override
  Timestamp? toJson(DateTime? object) {
    return object != null ? Timestamp.fromDate(object) : null;
  }
}

class GeoPointConverters implements JsonConverter<GeoPoint?, GeoPoint?> {
  const GeoPointConverters();

  @override
  GeoPoint? fromJson(GeoPoint? geoPoint) {
    return geoPoint;
  }

  @override
  GeoPoint? toJson(GeoPoint? geoPoint) => geoPoint;
}

class LocationConverters implements JsonConverter<LocationModel?, Map<String, dynamic>?> {
  const LocationConverters();

  @override
  LocationModel? fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return null;
    }
    return LocationModel.fromMap(json);
  }

  @override
  Map<String, dynamic>? toJson(LocationModel? object) {
    return object?.toMap();
  }
}
