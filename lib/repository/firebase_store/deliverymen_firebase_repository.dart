import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geoflutterfire_plus/geoflutterfire_plus.dart';
import 'package:geolocator/geolocator.dart';

import '/common/models/delivery_men.dart';
import '../../common/utils/data_result.dart';
import 'abstract_deliverymen_repository.dart';

class DeliverymenFirebaseRepository implements AbstractDeliverymenRepository {
  final FirebaseFirestore _firebase = FirebaseFirestore.instance;

  // Keys used for database in Firestore
  static const keyDeliverymen = 'deliverymen';
  static const keyGeoPoint = 'geopoint';
  static const keyCreatedAt = 'createdAt';
  static const keyUpdatedAt = 'updatedAt';

  /// Function to add a new deliveryman location in Firestore.
  ///
  /// Takes a [DeliverymenModel] and adds it to Firestore.
  /// Returns a [DataResult] indicating success or failure.
  @override
  Future<DataResult<DeliverymenModel>> set(DeliverymenModel deliverymen) async {
    try {
      // Get the current location and update the model with it
      final updatedDeliverymen = await _updateLocation(deliverymen);

      // Get the DocumentReference with the updated model ID
      final deliverymenRef = _deliverymenReference(updatedDeliverymen.id);

      // Create a new document in Firestore
      await deliverymenRef.set(updatedDeliverymen);

      return DataResult.success(updatedDeliverymen);
    } catch (err) {
      final message = 'LocationService.createLocation: $err';
      log(message);
      return DataResult.failure(GenericFailure(message: message));
    }
  }

  /// Retrieves a deliveryman document from Firestore by its [id].
  ///
  /// Returns a [DataResult] containing a [DeliverymenModel] if successful, otherwise an error.
  @override
  Future<DataResult<DeliverymenModel?>> get(String id) async {
    try {
      // Create DocumentReference with converter (withConverter)
      final deliveryRef = _deliverymenReference(id);

      // Recover the converted document
      final deliveryDoc = await deliveryRef.get();

      // Check if document exists
      if (!deliveryDoc.exists) {
        final message =
            'DeliverymenFirebaseRepository.get: delivery not found in $id';
        log(message);
        return DataResult.failure(GenericFailure(
          message: message,
          code: 703,
        ));
      }

      final DeliverymenModel? deliverymen = deliveryDoc.data();

      return DataResult.success(deliverymen);
    } catch (err, stackTrace) {
      final message = 'DeliverymenFirebaseRepository.get: $err';
      log(message, stackTrace: stackTrace);
      return DataResult.failure(FireStoreFailure(
        message: message,
        code: 713,
      ));
    }
  }

  /// Deletes a deliveryman document from Firestore by its [id].
  ///
  /// Returns a [DataResult] indicating success or failure.
  @override
  Future<DataResult<void>> delete(String id) async {
    try {
      // Get the DocumentReference for the given id
      final deliverymenRef = _deliverymenReference(id);

      // Delete the document from Firestore
      await deliverymenRef.delete();

      return DataResult.success(null);
    } catch (err, stackTrace) {
      final message = 'DeliverymenFirebaseRepository.delete: $err';
      log(message, stackTrace: stackTrace);
      return DataResult.failure(FireStoreFailure(
        message: message,
        code: 715,
      ));
    }
  }

  /// Function to update the location of a deliveryman in Firestore.
  ///
  /// Takes a [DeliverymenModel] and updates its location in Firestore.
  /// Returns a [DataResult] indicating success or failure.
  @override
  Future<DataResult<DeliverymenModel>> updateLocation(
      DeliverymenModel deliverymen) async {
    try {
      // Get the current location and update it in the model
      final updatedDeliverymen = await _updateLocation(deliverymen);

      // Convert model to a map to be saved in Firestore
      final map = updatedDeliverymen.toMap();
      // Set the update timestamp to be managed by Firestore
      map[keyUpdatedAt] = FieldValue.serverTimestamp();
      // Remove the ID as it is not needed in the document
      map.remove('id');

      // Update the document in Firestore with merge to avoid overwriting the entire document
      await _firebase
          .collection(keyDeliverymen)
          .doc(deliverymen.id)
          .set(map, SetOptions(merge: true));

      return DataResult.success(updatedDeliverymen);
    } catch (err) {
      final message = 'LocationService.updateLocation: $err';
      log(message);
      return DataResult.failure(GenericFailure(message: message));
    }
  }

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

      // Check and request location permissions
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          return false;
        }
      }

      // If permission is denied forever, location access is not possible
      if (permission == LocationPermission.deniedForever) {
        return false;
      }

      return true;
    } catch (err) {
      log('_handleLocationPermission: $err');
      return false;
    }
  }

  /// Function to get the current location as a [GeoFirePoint].
  ///
  /// Returns a [GeoFirePoint] representing the current location.
  /// Throws an exception if the location cannot be generated.
  @override
  Future<GeoFirePoint> getCurrentGeoFirePoint() async {
    try {
      // Handle location permissions
      bool hasPermission = await _handleLocationPermission();
      if (!hasPermission) {
        throw Exception(
            'LocationService._getCurrentGeoFirePoint: Unable to get geolocation!');
      }

      // Get the current position with high accuracy
      Position? position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
        ),
      );

      // Create and return a GeoFirePoint with the current location coordinates
      return GeoFirePoint(GeoPoint(position.latitude, position.longitude));
    } catch (err) {
      throw Exception(
          'LocationService._getCurrentGeoFirePoint: Unable to generate geolocation!');
    }
  }

  /// Updates the location of a [DeliverymenModel] with the current geolocation.
  ///
  /// Takes a [DeliverymenModel], gets the current location, and returns an updated model.
  Future<DeliverymenModel> _updateLocation(DeliverymenModel deliverymen) async {
    // Get the current location as a GeoFirePoint
    final GeoFirePoint location = await getCurrentGeoFirePoint();

    // Create a copy of the DeliverymenModel object with the new location
    return deliverymen.copyWith(
      location: location,
      updatedAt: DateTime.now(),
    );
  }

  /// Returns a [DocumentReference] for a [DeliverymenModel] with a given [id].
  ///
  /// Uses Firestore's [withConverter] to convert between Firestore data and [DeliverymenModel].
  DocumentReference<DeliverymenModel> _deliverymenReference(String id) {
    return _firebase
        .collection(keyDeliverymen)
        .doc(id)
        .withConverter<DeliverymenModel>(
      fromFirestore: (snapshot, _) {
        // Extract Firestore data and convert to [DeliverymenModel]
        final data = snapshot.data()!;
        final Timestamp createdAt = data[keyCreatedAt] as Timestamp;
        final Timestamp updatedAt = data[keyUpdatedAt] as Timestamp;

        // Remove timestamps from map to avoid duplication
        data.remove(keyCreatedAt);
        data.remove(keyUpdatedAt);

        return DeliverymenModel.fromMap(data).copyWith(
          id: snapshot.id,
          createdAt: createdAt.toDate(),
          updatedAt: updatedAt.toDate(),
        );
      },
      toFirestore: (deliverymen, _) {
        // Convert [DeliverymenModel] to Firestore data map
        final deliveryMap = deliverymen.toMap();
        deliveryMap[keyUpdatedAt] = FieldValue.serverTimestamp();
        // Remove the ID, as it should not be saved in Firestore
        deliveryMap.remove('id');
        return deliveryMap;
      },
    );
  }
}
