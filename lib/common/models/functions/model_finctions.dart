import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geoflutterfire_plus/geoflutterfire_plus.dart';

GeoFirePoint mapToGeoFirePoint(Map<String, dynamic> map) {
  final location = map['geopoint'];
  if (location is GeoPoint) {
    return GeoFirePoint(location);
  } else {
    return GeoFirePoint(
      GeoPoint(
        location['latitude'] as double,
        location['longitude'] as double,
      ),
    );
  }
}
