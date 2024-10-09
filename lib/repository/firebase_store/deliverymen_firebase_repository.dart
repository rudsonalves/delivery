import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:delivery/common/models/delivery_men.dart';
import 'package:geoflutterfire_plus/geoflutterfire_plus.dart';
import 'package:geolocator/geolocator.dart';

import '../../common/utils/data_result.dart';
import 'abstract_deliverymen_repository.dart';

class DeliverymenFirebaseRepository implements AbstractDeliverymenRepository {
  final FirebaseFirestore _firebase = FirebaseFirestore.instance;

  // Keys used for database in Firestore
  static const keyDeliverymen = 'deliverymen';
  static const keyGeoPoint = 'geopoint';
  static const keyCreatedAt = 'createdAt';
  static const keyUpdatedAt = 'updatedAt';

  /// Function to check and request location permissions.
  ///
  /// Returns `true` if the permissions are granted, otherwise `false`.
  Future<bool> _handleLocationPermission() async {
    try {
      // Check if location services are enabled
      final bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        return false;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          return false;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        return false;
      }

      return true;
    } catch (err) {
      log('_handleLocationPermission: $err');
      return false;
    }
  }

  /// Function to get the current location of the user.
  ///
  /// Returns the current [Position] if permission is granted, otherwise `null`.
  @override
  Future<Position?> getCurrentLocation() async {
    bool hasPermission = await _handleLocationPermission();
    if (!hasPermission) return null;

    return await Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
      ),
    );
  }

  /// Function to update the location of a deliveryman in Firestore.
  ///
  /// Takes a [DeliverymenModel] and updates its location in Firestore.
  /// Returns a [DataResult] indicating success or failure.
  @override
  Future<DataResult<DeliverymenModel>> updateLocation(
      DeliverymenModel deliverymen) async {
    try {
      // Get the current location as a GeoFirePoint
      final GeoFirePoint location = await _getCurrentGeoFirePoint();

      // Create a copy of the DeliverymenModel object with the new location
      final updatedDeliverymen = deliverymen.copyWith(
        location: location,
        updatedAt: DateTime.now(),
      );

      // Map the model to a map to be saved in Firestore
      final map = updatedDeliverymen.toMap();
      map[keyUpdatedAt] = FieldValue.serverTimestamp(); // Update timestamp
      map.remove('id'); // Remove the ID, as it is not needed in the document

      // Update the location in Firebase
      await _firebase.collection(keyDeliverymen).doc(deliverymen.id).set(
            map,
            SetOptions(
                merge: true), // Merge to avoid overwriting the entire document
          );

      return DataResult.success(updatedDeliverymen);
    } catch (err) {
      final message = 'LocationService.updateLocation: $err';
      log(message);
      return DataResult.failure(GenericFailure(message: message));
    }
  }

  /// Function to add a new deliveryman location in Firestore.
  ///
  /// Takes a [DeliverymenModel] and adds it to Firestore.
  /// Returns a [DataResult] indicating success or failure.
  @override
  Future<DataResult<DeliverymenModel>> add(DeliverymenModel deliverymen) async {
    try {
      // Get the current location as a GeoFirePoint
      final GeoFirePoint location = await _getCurrentGeoFirePoint();

      // Create a copy of the DeliverymenModel object with the new location
      final newDeliverymen = deliverymen.copyWith(location: location);

      // Create a map of the DeliverymenModel to be saved in Firestore
      final deliveryMap = newDeliverymen.toMap();
      deliveryMap[keyCreatedAt] =
          FieldValue.serverTimestamp(); // Set creation timestamp
      deliveryMap[keyUpdatedAt] =
          FieldValue.serverTimestamp(); // Set update timestamp
      deliveryMap
          .remove('id'); // Remove the ID, as it is not needed in the document

      // Create the new location in Firebase
      await _firebase.collection(keyDeliverymen).doc(deliverymen.id).set(
            deliveryMap,
            SetOptions(
                merge: true), // Merge to avoid overwriting the entire document
          );

      return DataResult.success(newDeliverymen);
    } catch (err) {
      final message = 'LocationService.createLocation: $err';
      log(message);
      return DataResult.failure(GenericFailure(message: message));
    }
  }

  /// Function to get the current location as a [GeoFirePoint].
  ///
  /// Returns a [GeoFirePoint] representing the current location.
  /// Throws an exception if the location cannot be generated.
  Future<GeoFirePoint> _getCurrentGeoFirePoint() async {
    try {
      Position? position = await getCurrentLocation();
      if (position == null) {
        throw Exception(
            'LocationService._getCurrentGeoFirePoint: Unable to get geolocation!');
      }

      // Create a GeoFirePoint with the current location
      return GeoFirePoint(GeoPoint(position.latitude, position.longitude));
    } catch (err) {
      throw Exception(
          'LocationService._getCurrentGeoFirePoint: Unable to generate geolocation!');
    }
  }
}
