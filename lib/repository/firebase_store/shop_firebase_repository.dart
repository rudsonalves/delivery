import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';

import '../../locator.dart';
import '../../stores/user/user_store.dart';
import '/common/models/address.dart';
import '/common/models/shop.dart';
import '/common/utils/data_result.dart';
import 'abstract_shop_repository.dart';

class ShopFirebaseRepository implements AbstractShopRepository {
  final _firebase = FirebaseFirestore.instance;

  static const keyShops = 'shops';
  static const keyAddress = 'addresses';
  static const keyUserId = 'userId';
  static const keyName = 'name';
  static const keyComments = 'comments';
  static const keyManagerId = 'managerId';
  static const keyManagerName = 'managerName';

  @override
  Future<DataResult<ShopModel>> add(ShopModel shop) async {
    WriteBatch batch = _firebase.batch();

    try {
      // Get shop reference
      final shopRef = _firebase.collection(keyShops).doc();

      // Update the shop object id to the return value
      shop.id = shopRef.id;

      // Add data to batch
      final shopMap = shop.toMap(); // a map without id
      batch.set(shopRef, shopMap);

      // Save address field
      if (shop.address != null) {
        // log('Shop Location: Latitude = ${shop.location!.latitude},'
        //     ' Longitude = ${shop.location!.longitude}');

        final addressMap = shop.address!.toMap();
        final addressRef = shopRef.collection(keyAddress).doc(shop.id);
        batch.set(addressRef, addressMap);
      }

      // Commit batch
      await batch.commit();

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

      WriteBatch batch = _firebase.batch();

      // get shop reference
      final shopRef = _firebase.collection(keyShops).doc(shop.id);

      // Update shop data in the main document
      final shopMap = shop.toMap();
      batch.set(shopRef, shopMap, SetOptions(merge: true));

      // Update the address if it exists and has a id
      if (shop.address != null) {
        final addressMap = shop.address!.toMap();
        final addressRef = shopRef.collection(keyAddress).doc(shop.id);
        batch.set(addressRef, addressMap, SetOptions(merge: true));
      }

      // Commit batch
      await batch.commit();

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
  Future<DataResult<List<ShopModel>>> getShopByManager(String managerId) async {
    try {
      final List<ShopModel> shops = [];
      final query = await _firebase
          .collection(keyShops)
          .where(keyManagerId, isEqualTo: managerId)
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
      final message = 'ShopFirebaseRepository.getShopByManager: $err';
      log(message);
      return DataResult.failure(FireStoreFailure(
        message: message,
        code: 514,
      ));
    }
  }

  @override
  Stream<List<ShopModel>> streamShopByName() {
    final currentUser = locator<UserStore>().currentUser;

    try {
      String accountId = currentUser != null ? currentUser.accountId : 'none';

      switch (accountId) {
        case 'admin':
          return _firebase
              .collection(keyShops)
              .orderBy(keyName)
              .snapshots()
              .map((snapshot) => snapshot.docs
                  .map(
                    (doc) => ShopModel.fromMap(doc.data()).copyWith(id: doc.id),
                  )
                  .toList());
        case 'none':
          return const Stream.empty();
        default:
          return _firebase
              .collection(keyShops)
              .where(keyUserId, isEqualTo: accountId)
              .orderBy(keyName)
              .snapshots()
              .map((snapshot) => snapshot.docs
                  .map(
                    (doc) => ShopModel.fromMap(doc.data()).copyWith(id: doc.id),
                  )
                  .toList());
      }
    } catch (err) {
      final message = 'ClientFirebaseRepository.streamClientsByName: $err';
      log(message);
      throw Exception(message);
    }
  }
}
