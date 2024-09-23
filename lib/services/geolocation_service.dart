import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geocoding/geocoding.dart';

Future<GeoPoint?> getGeoPointFromAddress(String address) async {
  try {
    List<Location> locations = await locationFromAddress(address);

    if (locations.isEmpty) {
      throw Exception('No locationfound for the address provided.');
    }

    final location = locations.first;
    return GeoPoint(location.latitude, location.longitude);
  } catch (err) {
    final message = 'GeolocationServiceGoogle.getCoordinatesFromAddress: $err';
    log(message);
    return null;
  }
}
