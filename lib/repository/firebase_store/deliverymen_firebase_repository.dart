// Copyright (C) 2024 Rudson Alves
//
// This file is part of delivery.
//
// delivery is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// delivery is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with delivery.  If not, see <https://www.gnu.org/licenses/>.

import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geoflutterfire_plus/geoflutterfire_plus.dart';

import '../../services/geo_location.dart';
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

  /// Updates the location of a [DeliverymenModel] with the current geolocation.
  ///
  /// Takes a [DeliverymenModel], gets the current location, and returns an updated model.
  Future<DeliverymenModel> _updateLocation(DeliverymenModel deliverymen) async {
    // Get the current location as a GeoFirePoint
    final GeoFirePoint location = await GeoLocation.getCurrentGeoFirePoint();

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
