import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';

import '../../common/models/address.dart';
import '/common/models/client.dart';
import '/common/utils/data_result.dart';
import 'abstract_client_repository.dart';

// Error codes
// 300 - generic error
// 301 - client ID cannot be null for update operation
// 302 - client not found in clientId
class ClientFirebaseRepository implements AbstractClientRepository {
  final _firebase = FirebaseFirestore.instance;

  static const keyClients = 'clients';
  static const keyAddresses = 'addresses';
  static const keyPhone = 'phone';
  static const keyName = 'name';

  @override
  Future<DataResult<ClientModel>> add(ClientModel client) async {
    try {
      // Update address geo localization
      if (client.address == null) {
        throw Exception('Client does not have an address');
      }
      final newAddress = await client.address!.updateLocation();
      client.address = newAddress;
      client.addressString = client.address!.geoAddressString;
      client.location = newAddress.location;

      // Save client without address field
      final docRef = await _firebase.collection(keyClients).add(client.toMap());
      // Update client id from firebase client object
      client.id = docRef.id;

      // Save address field
      final doc =
          await docRef.collection(keyAddresses).add(client.address!.toMap());
      client.address!.id = doc.id;

      return DataResult.success(client);
    } catch (err) {
      final message = 'ClientFirebaseRepository.add: $err';
      log(message);
      return DataResult.failure(FireStoreFailure(
        message: message,
        code: 300,
      ));
    }
  }

  @override
  Future<DataResult<ClientModel>> update(ClientModel client) async {
    try {
      if (client.id == null) {
        const message =
            'ClientFirebaseRepository.update: client ID cannot be null for update operation.';
        log(message);
        return DataResult.failure(const GenericFailure(
          message: message,
          code: 301,
        ));
      }

      // Update client data in the main document
      await _firebase.collection(keyClients).doc(client.id).update(
            client.toMap(),
          );

      // Update the address if it exists and has a id
      if (client.address != null && client.address!.id != null) {
        await _firebase
            .collection(keyClients)
            .doc(client.id)
            .collection(keyAddresses)
            .doc(client.address!.id!)
            .update(client.address!.toMap());
      } else if (client.address != null && client.address!.id == null) {
        // if the address has no id, it means it is a new address, so we add it
        await _firebase
            .collection(keyClients)
            .doc(client.id)
            .collection(keyAddresses)
            .add(client.address!.toMap());
      }

      return DataResult.success(client);
    } catch (err) {
      final message = 'ClientFirebaseRepository.update: $err';
      log(message);
      return DataResult.failure(FireStoreFailure(
        message: message,
        code: 310,
      ));
    }
  }

  @override
  Future<DataResult<void>> delete(String clientId) async {
    try {
      final clientDoc = _firebase.collection(keyClients).doc(clientId);

      // Delete documents from the addresses subcollectin before deleting
      // the client
      final addresses = await clientDoc.collection(keyAddresses).get();
      for (final doc in addresses.docs) {
        await doc.reference.delete();
      }

      // Now delete the main client document
      await clientDoc.delete();

      return DataResult.success(null);
    } catch (err) {
      final message = 'ClientFirebaseRepository.delete: $err';
      log(message);
      return DataResult.failure(FireStoreFailure(
        message: message,
        code: 300,
      ));
    }
  }

  @override
  Future<DataResult<ClientModel?>> get(String clientId) async {
    try {
      final clientDoc =
          await _firebase.collection(keyClients).doc(clientId).get();
      if (!clientDoc.exists) {
        final message =
            'ClientFirebaseRepository.get: client not found $clientId';
        log(message);
        return DataResult.failure(GenericFailure(
          message: message,
          code: 302,
        ));
      }

      final data = clientDoc.data()!;
      final client = ClientModel.fromMap(data).copyWith(id: clientId);
      final addresses = await getAddressesForClient(clientId);
      client.address = addresses?.first;
      return DataResult.success(client);
    } catch (err) {
      final message = 'ClientFirebaseRepository.get: $err';
      log(message);
      return DataResult.failure(FireStoreFailure(
        message: message,
        code: 300,
      ));
    }
  }

  @override
  Future<List<AddressModel>?> getAddressesForClient(String clientId) async {
    try {
      final addressDoc = await _firebase
          .collection(keyClients)
          .doc(clientId)
          .collection(keyAddresses)
          .get();

      // Map each document in the subcollection to an AddressModel object
      final addreseses = addressDoc.docs
          .map((doc) => AddressModel.fromMap(doc.data()).copyWith(id: doc.id))
          .toList();

      return addreseses;
    } catch (err) {
      final message = 'ClientFirebaseRepository.getAddressesForClient: $err';
      log(message);
      return null;
    }
  }

  @override
  Future<DataResult<List<ClientModel>>> getClientsByName(String name) async {
    try {
      final List<ClientModel> clients = [];
      final querySnapshot = await _firebase
          .collection(keyClients)
          .where(keyName, isEqualTo: name)
          .get();

      if (querySnapshot.docs.isEmpty) {
        log('No client found with name $name.');
        return DataResult.success([]);
      }

      for (final doc in querySnapshot.docs) {
        final client = ClientModel.fromMap(doc.data()).copyWith(id: doc.id);
        // final address = await getAddressesForClient(client.id!);
        // client.address = address?.first;
        clients.add(client);
      }
      return DataResult.success(clients);
    } catch (err) {
      final message = 'ClientFirebaseRepository.getClientsByName: $err';
      log(message);
      return DataResult.failure(FireStoreFailure(
        message: message,
        code: 300,
      ));
    }
  }

  @override
  Future<DataResult<List<ClientModel>>> getClientsByPhone(String phone) async {
    try {
      final List<ClientModel> clients = [];
      final querySnapshot = await _firebase
          .collection(keyClients)
          .where(keyPhone, isEqualTo: phone)
          .get();

      if (querySnapshot.docs.isEmpty) {
        log('No client found with name $phone.');
        return DataResult.success([]);
      }

      for (final doc in querySnapshot.docs) {
        final client = ClientModel.fromMap(doc.data()).copyWith(id: doc.id);
        // final address = await getAddressesForClient(client.id!);
        // client.address = address?.first;
        clients.add(client);
      }
      return DataResult.success(clients);
    } catch (err) {
      final message = 'ClientFirebaseRepository.getClientsByName: $err';
      log(message);
      return DataResult.failure(FireStoreFailure(
        message: message,
        code: 300,
      ));
    }
  }

  @override
  Stream<List<ClientModel>> streamClientByName() {
    try {
      return _firebase
          .collection(keyClients)
          .orderBy(keyName)
          .snapshots()
          .map((snapshot) => snapshot.docs
              .map(
                (doc) => ClientModel.fromMap(doc.data()).copyWith(id: doc.id),
              )
              .toList());
    } catch (err) {
      final message = 'ClientFirebaseRepository.streamClientsByName: $err';
      log(message);
      throw Exception(message);
    }
  }
}
