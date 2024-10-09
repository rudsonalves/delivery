import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geoflutterfire2/geoflutterfire2.dart';

GeoFirePoint mapToGeoFirePoint(Map<String, dynamic> map) {
  final location = map['geopoint'];
  if (location is GeoPoint) {
    return GeoFirePoint(
      location.latitude,
      location.longitude,
    );
  } else {
    return GeoFirePoint(
      location['latitude'] as double,
      location['longitude'] as double,
    );
  }
}
