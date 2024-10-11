import 'dart:developer';
import 'dart:math' as math;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geoflutterfire_plus/geoflutterfire_plus.dart';

import '/common/utils/data_result.dart';
import '/common/models/delivery.dart';
import 'abstract_deliveries_repository.dart';

class DeliveriesFirebaseRepository implements AbstractDeliveriesRepository {
  final FirebaseFirestore _firebase = FirebaseFirestore.instance;
  final CollectionReference<Map<String, dynamic>> deliveriesCollectionRef =
      FirebaseFirestore.instance.collection(keyDeliveries);

  static const keyDeliveries = 'deliveries';
  static const keyShopId = 'shopId';
  static const keyOwnerId = 'ownerId';
  static const keyDeliveryId = 'deliveryId';
  static const keyDeliveryName = 'deliveryName';
  static const keyDeliveryPhone = 'deliveryPhone';
  static const keyClientId = 'clientId';
  static const keyStatus = 'status';
  static const keyShopLocation = 'shopLocation';
  static const keyManagerId = 'managerId';
  static const keyCreatedAt = 'createdAt';
  static const keyUpdatedAt = 'updatedAt';

  /// Adds a new delivery to Firestore
  @override
  Future<DataResult<DeliveryModel>> add(DeliveryModel delivery) async {
    WriteBatch batch = _firebase.batch();

    try {
      // Get a new document reference for the delivery
      final deliveryRef = deliveriesCollectionRef.doc();
      delivery.id = deliveryRef.id;

      // Prepare the delivery data to be added
      final deliveryMap = _prepareDeliveryMap(delivery);
      deliveryMap[keyCreatedAt] = FieldValue.serverTimestamp();
      deliveryMap[keyUpdatedAt] = FieldValue.serverTimestamp();

      // Add the delivery to the batch
      batch.set(deliveryRef, deliveryMap);
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

  /// Updates an existing delivery in Firestore
  @override
  Future<DataResult<DeliveryModel>> update(DeliveryModel delivery) async {
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

    try {
      // Get the document reference for the delivery
      final deliveryRef = deliveriesCollectionRef.doc(delivery.id);
      // Prepare the delivery data to be updated
      final deliveryMap = _prepareDeliveryMap(delivery);
      deliveryMap.remove(keyCreatedAt);
      deliveryMap[keyUpdatedAt] = FieldValue.serverTimestamp();

      // Add the update to the batch
      batch.update(deliveryRef, deliveryMap);
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

  /// Updates the managerId for all deliveries of a given shop
  @override
  Future<DataResult<void>> updateManagerId(
      String shopId, String managerId) async {
    try {
      // Get all deliveries for the given shop
      final deliverySnapshot = await deliveriesCollectionRef
          .where(keyShopId, isEqualTo: shopId)
          .get();

      WriteBatch batch = _firebase.batch();
      for (final doc in deliverySnapshot.docs) {
        // Update managerId for each delivery
        batch.update(doc.reference, {
          keyManagerId: managerId,
          keyUpdatedAt: FieldValue.serverTimestamp(),
        });
      }

      await batch.commit();
      return DataResult.success(null);
    } catch (err) {
      final message = 'DeliveriesFirebaseRepository.updateManagerId: $err';
      log(message);
      return DataResult.failure(GenericFailure(
        message: message,
        code: 615,
      ));
    }
  }

  /// Updates the status and other details of a delivery
  @override
  Future<DataResult<void>> updateStatus(DeliveryModel delivery) async {
    try {
      // Get the document reference for the delivery
      final deliveryDoc = deliveriesCollectionRef.doc(delivery.id);

      WriteBatch batch = _firebase.batch();
      // Update delivery details
      batch.update(deliveryDoc, {
        keyDeliveryId: delivery.deliveryId,
        keyDeliveryName: delivery.deliveryName,
        keyDeliveryPhone: delivery.deliveryPhone,
        keyStatus: delivery.status.index,
        keyUpdatedAt: FieldValue.serverTimestamp(),
      });

      await batch.commit();
      return DataResult.success(null);
    } catch (err) {
      final message = 'DeliveriesFirebaseRepository.updateStatus: $err';
      log(message);
      return DataResult.failure(GenericFailure(
        message: message,
        code: 615,
      ));
    }
  }

  /// Deletes a delivery from Firestore
  @override
  Future<DataResult<void>> delete(String deliveryId) async {
    try {
      final deliveryDoc = deliveriesCollectionRef.doc(deliveryId);
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

  /// Retrieves a delivery by its ID from Firestore
  @override
  Future<DataResult<DeliveryModel?>> get(String deliveryId) async {
    try {
      final deliveryRef =
          deliveriesCollectionRef.doc(deliveryId).withConverter<DeliveryModel>(
                fromFirestore: _fromFirestore,
                toFirestore: (delivery, _) => delivery.toMap(),
              );

      final deliveryDoc = await deliveryRef.get();
      if (!deliveryDoc.exists) {
        final message =
            'DeliveriesFirebaseRepository.get: delivery not found in $deliveryId';
        log(message);
        return DataResult.failure(GenericFailure(
          message: message,
          code: 603,
        ));
      }

      return DataResult.success(deliveryDoc.data());
    } catch (err, stackTrace) {
      final message = 'DeliveriesFirebaseRepository.get: $err';
      log(message, stackTrace: stackTrace);
      return DataResult.failure(FireStoreFailure(
        message: message,
        code: 613,
      ));
    }
  }

  /// Streams deliveries by shop ID
  @override
  Stream<List<DeliveryModel>> getByShopId(String shopId) {
    return _getDeliveriesStream(
      deliveriesCollectionRef.where(keyShopId, isEqualTo: shopId),
    );
  }

  /// Streams deliveries by manager ID
  @override
  Stream<List<DeliveryModel>> getByManagerId(String managerId) {
    return _getDeliveriesStream(
      deliveriesCollectionRef.where(keyManagerId, isEqualTo: managerId),
    );
  }

  /// Streams deliveries by owner ID
  @override
  Stream<List<DeliveryModel>> getByOwnerId(String ownerId) {
    return _getDeliveriesStream(
      deliveriesCollectionRef.where(keyOwnerId, isEqualTo: ownerId),
    );
  }

  /// Streams all deliveries
  @override
  Stream<List<DeliveryModel>> getAll() {
    return _getDeliveriesStream(deliveriesCollectionRef);
  }

  /// Streams nearby deliveries within a given radius
  @override
  Stream<List<DeliveryModel>> getNearby({
    required GeoPoint geopoint,
    required double radiusInKm,
    int limit = 30,
  }) {
    final GeoFirePoint center = GeoFirePoint(
      GeoPoint(
        geopoint.latitude,
        geopoint.longitude,
      ),
    );

    return GeoCollectionReference<Map<String, dynamic>>(deliveriesCollectionRef)
        .subscribeWithin(
      center: center,
      radiusInKm: radiusInKm,
      field: keyShopLocation,
      geopointFrom: geopointFrom,
      queryBuilder: _nearbyQueryBuilder,
    )
        .asyncMap((snapshot) async {
      final List<DeliveryModel> deliveries = [];
      final start = center.geopoint;
      for (final doc in snapshot) {
        final data = doc.data() as Map<String, dynamic>;
        final delivery = _deliveryModelFromFirestoreData(doc.id, data);

        final end = delivery.shopLocation.geopoint;
        if (_calculateDistanceSimple(start, end) < radiusInKm) {
          deliveries.add(delivery);
        }
      }
      return deliveries;
    });
  }

  /// Converts Firestore data to DeliveryModel
  DeliveryModel _deliveryModelFromFirestoreData(
      String id, Map<String, dynamic> data) {
    final createdAtTimestamp = data[keyCreatedAt] as Timestamp?;
    final updatedAtTimestamp = data[keyUpdatedAt] as Timestamp?;

    data.remove(keyCreatedAt);
    data.remove(keyUpdatedAt);

    return DeliveryModel.fromMap(data).copyWith(
      id: id,
      createdAt: createdAtTimestamp?.toDate(),
      updatedAt: updatedAtTimestamp?.toDate(),
    );
  }

  /// Prepares delivery data map for Firestore
  Map<String, dynamic> _prepareDeliveryMap(DeliveryModel delivery) {
    final deliveryMap = delivery.toMap();
    deliveryMap.remove('id');
    return deliveryMap;
  }

  /// Converts Firestore snapshot to DeliveryModel
  DeliveryModel _fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> snapshot, _) {
    final data = snapshot.data()!;
    return _deliveryModelFromFirestoreData(snapshot.id, data);
  }

  /// Streams deliveries based on a given Firestore query
  Stream<List<DeliveryModel>> _getDeliveriesStream(
      Query<Map<String, dynamic>> query) {
    return query.snapshots().asyncMap((snapshot) async {
      return Future.wait(snapshot.docs.map((doc) async {
        try {
          return _deliveryModelFromFirestoreData(doc.id, doc.data());
        } catch (err) {
          final message =
              'DeliveriesFirebaseRepository._getDeliveriesStream :$err';
          log(message);
          throw Exception(message);
        }
      }));
    });
  }

  /// Builds a query to filter nearby deliveries
  Query<Map<String, dynamic>> _nearbyQueryBuilder(
      Query<Map<String, dynamic>> query) {
    return query.where(
      keyStatus,
      whereIn: <int>[
        DeliveryStatus.orderRegisteredForPickup.index,
        DeliveryStatus.orderReservedForPickup.index,
      ],
    );
  }

  /// Calculates the approximate distance between two GeoPoints
  double _calculateDistanceSimple(GeoPoint start, GeoPoint end) {
    const double kmPerDegreeLat =
        111.32; // Approximately the number of km per degree of latitude
    const double kmPerDegreeLonAtEquator =
        111.32; // Approximately the number of km per degree of longitude at the equator

    double deltaLat = (end.latitude - start.latitude) * kmPerDegreeLat;
    double deltaLon = (end.longitude - start.longitude) *
        (kmPerDegreeLonAtEquator * math.cos(_toRadians(start.latitude)));

    return math.sqrt(deltaLat * deltaLat + deltaLon * deltaLon);
  }

  /// Converts degrees to radians
  double _toRadians(double degrees) {
    return degrees * math.pi / 180;
  }

  /// Extracts GeoPoint from Firestore data
  GeoPoint geopointFrom(Map<String, dynamic> data) =>
      (data[keyShopLocation] as Map<String, dynamic>)['geopoint'] as GeoPoint;
}
