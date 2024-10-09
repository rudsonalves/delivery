import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:delivery/common/models/delivery_men.dart';
import 'package:geoflutterfire2/geoflutterfire2.dart';
import 'package:geolocator/geolocator.dart';

import '../common/utils/data_result.dart';

const geoHashLength = 5;

class LocationService {
  final FirebaseFirestore _firebase = FirebaseFirestore.instance;
  final GeoFlutterFire _geo = GeoFlutterFire();

  static const keyDeliverymen = 'deliverymen';
  static const keyGeoPoint = 'geopoint';
  static const keyGeohash = 'geohash';
  static const keyCreatedAt = 'createdAt';
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
  Future<DataResult<DeliverymenModel>> updateLocation(
      DeliverymenModel deliverymen) async {
    try {
      final newDelivermen = deliverymen.copyWith();

      GeoPoint geopoint;
      String geohash;
      (geopoint, geohash) = await _getCurrentGeoFirePoint();

      newDelivermen.geopoint = geopoint;
      newDelivermen.geohash = geohash;

      final map = newDelivermen.toMap();
      map[keyUpdatedAt] = FieldValue.serverTimestamp();
      map.remove('id');

      // Update the location in Firebase
      await _firebase.collection(keyDeliverymen).doc(deliverymen.id).set(
            map,
            SetOptions(merge: true),
          );

      return DataResult.success(newDelivermen);
    } catch (err) {
      final message = 'LocationService.updateLocation: $err';
      log(message);
      return DataResult.failure(GenericFailure(message: message));
    }
  }

  // Create location
  Future<DataResult<DeliverymenModel>> createLocation(
      DeliverymenModel deliverymen) async {
    try {
      GeoPoint geopoint;
      String geohash;
      (geopoint, geohash) = await _getCurrentGeoFirePoint();

      deliverymen.geopoint = geopoint;
      deliverymen.geohash = geohash;

      final deliveryMap = deliverymen.toMap();
      deliveryMap[keyCreatedAt] = FieldValue.serverTimestamp();
      deliveryMap[keyUpdatedAt] = FieldValue.serverTimestamp();
      deliveryMap.remove('id');

      // Created the location in Firebase
      await _firebase.collection(keyDeliverymen).doc(deliverymen.id).set(
            deliveryMap,
            SetOptions(merge: true),
          );

      return DataResult.success(deliverymen.copyWith());
    } catch (err) {
      final message = 'LocationService.createLocation: $err';
      log(message);
      return DataResult.failure(GenericFailure(message: message));
    }
  }

  Future<(GeoPoint, String)> _getCurrentGeoFirePoint() async {
    try {
      Position? position = await getCurrentLocation();
      if (position == null) {
        throw Exception(
            'LocationService._getCurrentGeoFirePoint: Can not generate geolocation!');
      }

      GeoFirePoint geoFirePojnt = _geo.point(
        latitude: position.latitude,
        longitude: position.longitude,
      );

      return (
        geoFirePojnt.geoPoint,
        geoFirePojnt.hash.substring(0, geoHashLength)
      );
    } catch (err) {
      throw Exception(
          'LocationService._getCurrentGeoFirePoint: Can not generate geolocation!');
    }
  }
}
