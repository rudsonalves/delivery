import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';

import '/common/models/address.dart';
import '/common/utils/data_result.dart';
import 'abstract_address_repository.dart';

class AddressFirebaseRepository implements AbstractAddressClientRepository {
  static final _firebase = FirebaseFirestore.instance;

  static const keyAddresses = 'addresses';

  @override
  Future<DataResult<AddressModel>> add(AddressModel address) async {
    try {
      // Save address
      final docRef = await _firebase.collection(keyAddresses).add(
            address.toMap(),
          );

      // Update Address id from firebase address object
      address.id = docRef.id;

      return DataResult.success(address);
    } catch (err) {
      final message = 'AddressFirebaseRepository.add: $err';
      log(message);
      return DataResult.failure(APIFailure(message: message, code: 400));
    }
  }

  @override
  Future<DataResult<AddressModel?>> get(String addressId) async {
    try {
      final docSnapshot =
          await _firebase.collection(keyAddresses).doc(addressId).get();
      if (!docSnapshot.exists) {
        throw Exception('Address $addressId not found!');
      }
      final data = docSnapshot.data()!;
      final address = AddressModel.fromMap(data);
      return DataResult.success(address);
    } catch (err) {
      final message = 'AddressFirebaseRepository.get: $err';
      log(message);
      return DataResult.failure(APIFailure(message: message, code: 401));
    }
  }

  @override
  Future<DataResult<AddressModel>> update(AddressModel address) async {
    try {
      if (address.id == null) {
        throw Exception('user address have id null');
      }
      await _firebase
          .collection(keyAddresses)
          .doc(address.id)
          .update(address.toMap());
      return DataResult.success(address);
    } catch (err) {
      final message = 'AddressFirebaseRepository.update: $err';
      log(message);
      return DataResult.failure(APIFailure(message: message, code: 401));
    }
  }

  @override
  Future<DataResult<void>> delete(String addressId) async {
    // TODO: implement delete
    throw UnimplementedError();
  }
}
