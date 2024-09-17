import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';

import '/common/models/address.dart';
import '/common/models/shop.dart';
import '/common/utils/data_result.dart';
import 'abstract_shop_repository.dart';

class ShopFirebaseRepository implements AbstractShopRepository {
  final _firebase = FirebaseFirestore.instance;

  static const keyShops = 'shops';
  static const keyAddress = 'addresses';
  static const userId = 'userId';
  static const keyName = 'name';
  static const keyComments = 'comments';

  @override
  Future<DataResult<ShopModel>> add(ShopModel shop) async {
    try {
      // Save shop witout address field
      final docRec = await _firebase.collection(keyShops).add(shop.toMap());
      // Update shop id from firebase shop object
      shop.id = docRec.id;

      // Save address field
      if (shop.address != null) {
        final doc =
            await docRec.collection(keyAddress).add(shop.address!.toMap());
        shop.address!.id = doc.id;
      }

      return DataResult.success(shop);
    } catch (err) {
      final message = 'ShopFirebaseRepository.add: $err';
      log(message);
      return DataResult.failure(FireStoreFailure(
        message: message,
        code: 510,
      ));
    }
  }

  @override
  Future<DataResult<ShopModel>> update(ShopModel shop) async {
    try {
      if (shop.id == null) {
        const message =
            'ShopFirebaseRepository.update: shop ID cannot be null for update operation';
        log(message);
        return DataResult.failure(const GenericFailure(
          message: message,
          code: 501,
        ));
      }

      // Update shop data in the main document
      await _firebase.collection(keyShops).doc(shop.id).update(shop.toMap());

      // Update the address if it exists and has a id
      if (shop.address != null && shop.address!.id != null) {
        await _firebase
            .collection(keyShops)
            .doc(shop.id)
            .collection(keyAddress)
            .doc(shop.address!.id!)
            .update(shop.address!.toMap());
      } else if (shop.address != null && shop.address!.id == null) {
        await _firebase
            .collection(keyShops)
            .doc(shop.id)
            .collection(keyAddress)
            .add(shop.address!.toMap());
      }

      return DataResult.success(shop);
    } catch (err) {
      final message = 'ShopFirebaseRepository.update: $err';
      log(message);
      return DataResult.failure(FireStoreFailure(
        message: message,
        code: 511,
      ));
    }
  }

  @override
  Future<DataResult<void>> delete(String shopId) async {
    try {
      final shopDoc = _firebase.collection(keyShops).doc(shopId);

      // Delete documents from the addresses subcollectin before deleting
      // the shop
      final addresses = await shopDoc.collection(keyAddress).get();
      for (final doc in addresses.docs) {
        await doc.reference.delete();
      }

      // Now delete the main shop document
      await shopDoc.delete();

      return DataResult.success(null);
    } catch (err) {
      final message = 'ShopFirebaseRepository.delete: $err';
      log(message);
      return DataResult.failure(FireStoreFailure(
        message: message,
        code: 512,
      ));
    }
  }

  @override
  Future<DataResult<ShopModel?>> get(String shopId) async {
    try {
      final shopDoc = await _firebase.collection(keyShops).doc(shopId).get();
      if (!shopDoc.exists) {
        final message = 'ShopFirebaseRepository.get: shop not found in $shopId';
        log(message);
        return DataResult.failure(GenericFailure(
          message: message,
          code: 503,
        ));
      }

      final data = shopDoc.data()!;
      final shop = ShopModel.fromMap(data).copyWith(id: shopId);
      final addresses = await _getAddresses(shopDoc);
      shop.address = addresses.first;
      return DataResult.success(shop);
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
  Future<DataResult<List<AddressModel>>> getAddressesForShop(
    String shopId,
  ) async {
    try {
      final shopDoc = await _firebase.collection(keyShops).doc(shopId).get();
      final addresses = await _getAddresses(shopDoc);
      return DataResult.success(addresses);
    } catch (err) {
      final message = 'ShopFirebaseRepository.getAddressesForShop: $err';
      log(message);
      return DataResult.failure(FireStoreFailure(
        message: message,
        code: 513,
      ));
    }
  }

  Future<List<AddressModel>> _getAddresses(
      DocumentSnapshot<Map<String, dynamic>> shopDoc) async {
    if (!shopDoc.exists) {
      const message = 'shop document does not exist.';
      log(message);
      throw Exception(message);
    }

    try {
      final addressDoc = await shopDoc.reference.collection(keyAddress).get();
      final addresses = addressDoc.docs
          .map((doc) => AddressModel.fromMap(doc.data()).copyWith(id: doc.id))
          .toList();

      return addresses;
    } catch (err) {
      throw Exception(err.toString());
    }
  }

  @override
  Future<DataResult<List<ShopModel>>> getShopByName(String name) async {
    try {
      final List<ShopModel> shops = [];
      final query = await _firebase
          .collection(keyShops)
          .where(keyName, isEqualTo: name)
          .get();

      if (query.docs.isEmpty) {
        return DataResult.success([]);
      }

      for (final doc in query.docs) {
        final shop = ShopModel.fromMap(doc.data()).copyWith(id: doc.id);
        // final address = await getAddressesForShop(shopId: shop.id!);
        // shop.address = address?.first;
        shops.add(shop);
      }
      return DataResult.success(shops);
    } catch (err) {
      final message = 'ShopFirebaseRepository.getClientsByName: $err';
      log(message);
      return DataResult.failure(FireStoreFailure(
        message: message,
        code: 514,
      ));
    }
  }

  @override
  Stream<List<ShopModel>> streamShopByName() {
    try {
      return _firebase
          .collection(keyShops)
          .orderBy(keyName)
          .snapshots()
          .map((snapshot) => snapshot.docs
              .map(
                (doc) => ShopModel.fromMap(doc.data()).copyWith(id: doc.id),
              )
              .toList());
    } catch (err) {
      final message = 'ClientFirebaseRepository.streamClientsByName: $err';
      log(message);
      throw Exception(message);
    }
  }
}
