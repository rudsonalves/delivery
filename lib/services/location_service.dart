import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geoflutterfire2/geoflutterfire2.dart';
import 'package:geolocator/geolocator.dart';

class LocationService {
  final FirebaseFirestore _firebase = FirebaseFirestore.instance;
  final GeoFlutterFire _geo = GeoFlutterFire();

  static const keyDeliverymen = 'deliverymen';
  static const keyLocation = 'location';
  static const keyGeoHash = 'geoHash';
  static const keyUpdatedAt = 'updatedAt';

  // Function to check and request permissions
  Future<bool> _handleLocationPermission() async {
    try {
      // Check if location services are enable
      final bool serviceEnable = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnable) {
        // Location services are disabled
        return false;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        // Request permisson
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          // Permission denied
          return false;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        // Permission denied forever
        return false;
      }

      return true;
    } catch (err) {
      log('_handleLocationPermission: $err');
      return false;
    }
  }

  // Function to get current location
  Future<Position?> getCurrentLocation() async {
    bool hasPermission = await _handleLocationPermission();
    if (!hasPermission) return null;

    return await Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
      ),
    );
  }

  // Function to update location in Firestore
  Future<Position?> updateLocation(String userId) async {
    Position? position = await getCurrentLocation();
    if (position == null) return null; // Unable to get location

    GeoFirePoint geoPoint = _geo.point(
      latitude: position.latitude,
      longitude: position.longitude,
    );

    // Update the location in Firebase
    await _firebase.collection(keyDeliverymen).doc(userId).set({
      keyLocation: geoPoint.geoPoint,
      keyGeoHash: geoPoint.hash,
      keyUpdatedAt: FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));

    return position;
  }
}
