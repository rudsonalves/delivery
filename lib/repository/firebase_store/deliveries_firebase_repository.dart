import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geoflutterfire2/geoflutterfire2.dart';

import '/common/utils/data_result.dart';
import '/common/models/delivery.dart';
import 'abstract_deliveries_repository.dart';

class DeliveriesFirebaseRepository implements AbstractDeliveriesRepository {
  final _firebase = FirebaseFirestore.instance;
  final GeoFlutterFire geo = GeoFlutterFire();

  static const keyDeliveries = 'deliveries';
  static const keyShopId = 'shopId';
  static const keyOwnerId = 'ownerId';
  static const keyClientId = 'clientId';
  static const keyStatus = 'status';
  static const keyGeoHash = 'geoHash';

  @override
  Future<DataResult<DeliveryModel>> add(DeliveryModel delivery) async {
    WriteBatch batch = _firebase.batch();

    try {
      // Get delivery reference
      final deliveryRef = _firebase.collection(keyDeliveries).doc();

      // Update the delivery object id to the return value
      delivery.id = deliveryRef.id;

      // Adjust delivery map
      final deliveryMap = delivery.toMap();
      // Removes unnecessary data
      deliveryMap.remove('id');

      // Set the server timestamps for createdAt and updatedAt
      deliveryMap['createdAt'] = FieldValue.serverTimestamp();
      deliveryMap['updatedAt'] = FieldValue.serverTimestamp();

      // Add data to batch
      batch.set(deliveryRef, deliveryMap);

      // Commit batch
      await batch.commit();

      return DataResult.success(delivery);
    } catch (err) {
      final message = 'DeliveriesFirebaseRepository.add: $err';
      log(message);
      return DataResult.failure(FireStoreFailure(
        message: message,
        code: 610,
      ));
    }
  }

  @override
  Future<DataResult<DeliveryModel>> update(DeliveryModel delivery) async {
    try {
      if (delivery.id == null) {
        const message =
            'DeliveriesFirebaseRepository.update: delivery ID cannot be null for update operation';
        log(message);
        return DataResult.failure(const GenericFailure(
          message: message,
          code: 601,
        ));
      }

      WriteBatch batch = _firebase.batch();

      // get delivey reference
      final deliveryRef = _firebase.collection(keyDeliveries).doc(delivery.id);

      // Removes unnecessary data
      final deliveryMap = delivery.toMap();
      deliveryMap.remove('id');
      deliveryMap.remove('createdAt'); // Don't overwrite createdAt

      // Set the updated timestamp
      deliveryMap['updatedAt'] = FieldValue.serverTimestamp();

      // Update shop data in the main document
      batch.set(deliveryRef, deliveryMap);

      // Commit batch
      await batch.commit();

      return DataResult.success(delivery);
    } catch (err) {
      final message = 'DeliveriesFirebaseRepository.update: $err';
      log(message);
      return DataResult.failure(FireStoreFailure(
        message: message,
        code: 611,
      ));
    }
  }

  @override
  Future<DataResult<void>> delete(String deliveryId) async {
    try {
      final deliveryDoc = _firebase.collection(keyDeliveries).doc(deliveryId);

      // Delete the delivery document
      await deliveryDoc.delete();

      return DataResult.success(null);
    } catch (err) {
      final message = 'DeliveriesFirebaseRepository.delete: $err';
      log(message);
      return DataResult.failure(FireStoreFailure(
        message: message,
        code: 612,
      ));
    }
  }

  @override
  Future<DataResult<DeliveryModel?>> get(String deliveryId) async {
    try {
      // Create DocumentReference with converter (withConverter)
      final deliveryRef = _firebase
          .collection(keyDeliveries)
          .doc(deliveryId)
          .withConverter<DeliveryModel>(
            fromFirestore: (snapshot, _) {
              final data = snapshot.data()!;
              final Timestamp createdAtTs = data['createdAt'] as Timestamp;
              final Timestamp updatedAtTs = data['updatedAt'] as Timestamp;

              data.remove('createdAt');
              data.remove('updatedAt');

              return DeliveryModel.fromMap(data).copyWith(
                id: snapshot.id,
                createdAt: createdAtTs.toDate(),
                updatedAt: updatedAtTs.toDate(),
              );
            },
            toFirestore: (delivery, _) => delivery.toMap(),
          );

      // Recover the converted document
      final deliveryDoc = await deliveryRef.get();

      // Check if document exists
      if (!deliveryDoc.exists) {
        final message =
            'ShopFirebaseRepository.get: delivery not found in $deliveryId';
        log(message);
        return DataResult.failure(GenericFailure(
          message: message,
          code: 603,
        ));
      }

      final DeliveryModel? delivery = deliveryDoc.data();

      return DataResult.success(delivery);
    } catch (err, stackTrace) {
      final message = 'ShopFirebaseRepository.get: $err';
      log(message, stackTrace: stackTrace);
      return DataResult.failure(FireStoreFailure(
        message: message,
        code: 513,
      ));
    }
  }

  @override
  Stream<List<DeliveryModel>> streamDeliveryByShopId(String shopId) {
    return _firebase
        .collection(keyDeliveries)
        .where(keyShopId, isEqualTo: shopId)
        .snapshots()
        .asyncMap((snapshot) async {
      List<DeliveryModel> deliveries = await Future.wait(snapshot.docs.map(
        (doc) async {
          try {
            final data = Map<String, dynamic>.from(doc.data());

            final createdAtTimestamp = data['createdAt'] as Timestamp?;
            final updatedAtTimestamp = data['updatedAt'] as Timestamp?;

            data.remove('createdAt');
            data.remove('updatedAt');

            final delivery = DeliveryModel.fromMap(data).copyWith(
              id: doc.id,
              createdAt: createdAtTimestamp?.toDate(),
              updatedAt: updatedAtTimestamp?.toDate(),
            );

            return delivery.copyWith(id: doc.id);
          } catch (err) {
            final message =
                'DeliveriesFirebaseRepository.streamDeliveryByShopId :$err';
            log(message);
            throw Exception(message);
          }
        },
      ));
      return deliveries;
    });
  }

  @override
  Stream<List<DeliveryModel>> getDeliveryNearby({
    required GeoPoint location,
    required double radiusInKm,
  }) {
    // Create a GeoFirePoint for the center point (delivery user location)
    GeoFirePoint center = geo.point(
      latitude: location.latitude,
      longitude: location.longitude,
    );

    // Sets the reference to the 'deliveries' collection
    final CollectionReference<Map<String, dynamic>> collectionRef =
        _firebase.collection(keyDeliveries);

    // Execute the geospatial query
    return geo
        .collection(collectionRef: collectionRef)
        .within(
          center: center,
          radius: radiusInKm,
          field: keyGeoHash,
          strictMode: true,
        )
        .asyncMap((snapshot) async {
      // Map documents to DeliveryModel
      List<DeliveryModel> deliveries = snapshot.map((doc) {
        final data = doc.data() as Map<String, dynamic>;

        // Extract timestamps
        final createdAtTimestamp = data['createdAt'] as Timestamp?;
        final updatedAtTimestamp = data['updatedAt'] as Timestamp?;

        // Remove fields
        data.remove('createdAt');
        data.remove('updatedAt');

        // Create DeliveryModel
        final delivery = DeliveryModel.fromMap(data).copyWith(
          createdAt: createdAtTimestamp?.toDate(),
          updatedAt: updatedAtTimestamp?.toDate(),
        );

        return delivery;
      }).toList();

      return deliveries;
    });
  }

  @override
  Stream<List<DeliveryModel>> streamDeliveryByOwnerId(String ownerId) {
    return _firebase
        .collection(keyDeliveries)
        .where(keyOwnerId, isEqualTo: ownerId)
        .snapshots()
        .asyncMap((snapshot) async {
      List<DeliveryModel> deliveries = await Future.wait(snapshot.docs.map(
        (doc) async {
          try {
            final data = Map<String, dynamic>.from(doc.data());

            final createdAtTimestamp = data['createdAt'] as Timestamp?;
            final updatedAtTimestamp = data['updatedAt'] as Timestamp?;

            data.remove('createdAt');
            data.remove('updatedAt');

            final delivery = DeliveryModel.fromMap(data).copyWith(
              id: doc.id,
              createdAt: createdAtTimestamp?.toDate(),
              updatedAt: updatedAtTimestamp?.toDate(),
            );

            return delivery.copyWith(id: doc.id);
          } catch (err) {
            final message =
                'DeliveriesFirebaseRepository.streamDeliveryByShopId :$err';
            log(message);
            throw Exception(message);
          }
        },
      ));
      return deliveries;
    });
  }

  @override
  Stream<List<DeliveryModel>> streamShopByName() {
    // TODO: implement streamShopByName
    throw UnimplementedError();
  }

  @override
  Future<DataResult<DeliveryModel>> updateStatus(
      DeliveryStatus deliveryStatus) {
    // TODO: implement updateStatus
    throw UnimplementedError();
  }
}
