import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:delivery/common/models/delivery.dart';

import 'package:delivery/common/utils/data_result.dart';

import 'abstract_deliveries_repository.dart';

class DeliveriesFirebaseRepository implements AbstractDeliveriesRepository {
  final _firebase = FirebaseFirestore.instance;

  static const keyDeliveries = 'deliveries';
  static const keyShopId = 'shopId';
  static const keyClientId = 'clientId';
  static const keyStatus = 'status';

  @override
  Future<DataResult<DeliveryModel>> add(DeliveryModel delivery) async {
    try {
      // Save delivery witout address field
      final docRec =
          await _firebase.collection(keyDeliveries).add(delivery.toMap());
      // Update delivery id from firebase delivery object
      delivery.id = docRec.id;

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

      // Update delivery data in the main document
      await _firebase
          .collection(keyDeliveries)
          .doc(delivery.id)
          .update(delivery.toMap());

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
      final deliveryDoc =
          await _firebase.collection(keyDeliveries).doc(deliveryId).get();
      if (!deliveryDoc.exists) {
        final message =
            'ShopFirebaseRepository.get: delivery not found in $deliveryId';
        log(message);
        return DataResult.failure(GenericFailure(
          message: message,
          code: 603,
        ));
      }

      final data = deliveryDoc.data()!;
      final delivery = DeliveryModel.fromMap(data).copyWith(id: deliveryId);
      return DataResult.success(delivery);
    } catch (err) {
      final message = 'ShopFirebaseRepository.get: $err';
      log(message);
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
        .asyncMap(
      (snapshot) async {
        List<DeliveryModel> deliveries = await Future.wait(
          snapshot.docs.map(
            (doc) async {
              DeliveryModel delivery = DeliveryModel.fromMap(doc.data());
              return delivery.copyWith(id: doc.id);
            },
          ),
        );
        return deliveries;
      },
    );
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
