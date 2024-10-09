import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geoflutterfire_plus/geoflutterfire_plus.dart';

import '/common/utils/data_result.dart';
import '/common/models/delivery.dart';
import 'abstract_deliveries_repository.dart';

class DeliveriesFirebaseRepository implements AbstractDeliveriesRepository {
  final _firebase = FirebaseFirestore.instance;

  static const keyDeliveries = 'deliveries';
  static const keyShopId = 'shopId';
  static const keyOwnerId = 'ownerId';
  static const keyClientId = 'clientId';
  static const keyStatus = 'status';
  // static const keyGeohash = 'geohash';
  static const keyShopLocation = 'shopLocation';
  static const keyManagerId = 'managerId';
  static const keyUpdatedAt = 'updatedAt';

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
  Future<DataResult<void>> updateManagerId(
      String shopId, String managerId) async {
    try {
      // get delivey reference
      final deliveryRef = _firebase.collection(keyDeliveries);

      // filter deliveries by shopId
      final deliverySnapshot =
          await deliveryRef.where(keyShopId, isEqualTo: shopId).get();

      // update managerId
      WriteBatch batch = _firebase.batch();
      for (final doc in deliverySnapshot.docs) {
        batch.update(doc.reference, {
          keyManagerId: managerId,
          keyUpdatedAt: FieldValue.serverTimestamp(),
        });
      }

      // Commit batch
      await batch.commit();

      return DataResult.success(null);
    } catch (err) {
      final message =
          'DeliveriesFirebaseRepository.updateDeliveriesManagerId: $err';
      log(message);
      return DataResult.failure(GenericFailure(
        message: message,
        code: 615,
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
        code: 613,
      ));
    }
  }

  @override
  Stream<List<DeliveryModel>> getByShopId(String shopId) {
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
                'DeliveriesFirebaseRepository.getDeliveryByShopId :$err';
            log(message);
            throw Exception(message);
          }
        },
      ));
      return deliveries;
    });
  }

  @override
  Stream<List<DeliveryModel>> getByManagerId(String managerId) {
    return _firebase
        .collection(keyDeliveries)
        .where(keyManagerId, isEqualTo: managerId)
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
                'DeliveriesFirebaseRepository.getDeliveryByManagerId :$err';
            log(message);
            throw Exception(message);
          }
        },
      ));
      return deliveries;
    });
  }

  @override
  Stream<List<DeliveryModel>> getNearby({
    required GeoPoint geopoint,
    required double radiusInKm,
    int limit = 50,
  }) {
    // Create a GeoFirePoint for the center point (delivery user location)
    final GeoFirePoint center =
        GeoFirePoint(GeoPoint(geopoint.latitude, geopoint.longitude));

    // Set the reference to the 'deliveries' collection
    final collectionReference = _firebase.collection(keyDeliveries);

    // Function to get GeoPoint instance from Firestore document data
    GeoPoint geopointFrom(Map<String, dynamic> data) =>
        (data[keyShopLocation] as Map<String, dynamic>)['geopoint'] as GeoPoint;

    // Execute the geospatial query using geoflutterfire_plus
    return GeoCollectionReference<Map<String, dynamic>>(collectionReference)
        .subscribeWithin(
      center: center,
      radiusInKm: radiusInKm,
      field: keyShopLocation,
      geopointFrom: geopointFrom,
    )
        .asyncMap((snapshot) async {
      // Log the number of documents returned
      log('Número de documentos retornados: ${snapshot.length}');

      // Map documents to DeliveryModel
      List<DeliveryModel> deliveries = snapshot
          .map((doc) {
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
          })
          .take(limit)
          .toList();

      // Log the number of deliveries processed
      log('Número de deliveries processadas: ${deliveries.length}');
      return deliveries;
    });
  }

  @override
  Stream<List<DeliveryModel>> getByOwnerId(String ownerId) {
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
                'DeliveriesFirebaseRepository.getDeliveryByOwnerId :$err';
            log(message);
            throw Exception(message);
          }
        },
      ));
      return deliveries;
    });
  }

  @override
  Stream<List<DeliveryModel>> getAll() {
    return _firebase
        .collection(keyDeliveries)
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
                'DeliveriesFirebaseRepository.getDeliveryByOwnerId :$err';
            log(message);
            throw Exception(message);
          }
        },
      ));
      log('Número de entregas retornadas após processamento: ${deliveries.length}');
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
