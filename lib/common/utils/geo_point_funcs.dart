import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geoflutterfire2/geoflutterfire2.dart';

String createGeoPointHash(GeoPoint location) {
  final GeoFlutterFire geo = GeoFlutterFire();
  final geoPonit = geo.point(
    latitude: location.latitude,
    longitude: location.longitude,
  );

  return geoPonit.hash;
}
