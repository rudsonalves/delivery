import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';

import '../../common/models/address.dart';
import '/common/models/client.dart';
import '/common/utils/data_result.dart';
import 'client_repository.dart';

const keyClient = 'clients';
const keyAddress = 'addresses';
const keyPhone = 'phone';
const keyName = 'name';

class ClientFirebaseRepository implements ClientRepository {
  static final _firebase = FirebaseFirestore.instance;

  @override
  Future<DataResult<ClientModel>> add(ClientModel client) async {
    try {
      // Save client witout address field
      final docRef = await _firebase.collection(keyClient).add(client.toMap());

      // Update client id from firebase client object
      client.id = docRef.id;

      // Save address field
      if (client.address != null) {
        await docRef.collection(keyAddress).add(client.address!.toMap());
      }

      return DataResult.success(client);
    } catch (err) {
      final message = 'ClientFirebaseRepository.add: $err';
      log(message);
      return DataResult.failure(FireStoreFailure(message: message));
    }
  }

  @override
  Future<DataResult<ClientModel>> update(ClientModel client) async {
    try {
      if (client.id == null) {
        throw Exception('Client ID cannot be null for update operation.');
      }

      // Updae client data in the main document
      await _firebase
          .collection(keyAddress)
          .doc(client.id)
          .update(client.toMap());

      // Update the address if it exists and has a id
      if (client.address != null && client.address!.id != null) {
        await _firebase
            .collection(keyClient)
            .doc(client.id)
            .collection(keyAddress)
            .doc(client.address!.id!)
            .update(client.address!.toMap());
      } else if (client.address != null && client.address!.id == null) {
        // if the address has no id, it means it is a new address, so we add it
        await _firebase
            .collection(keyClient)
            .doc(client.id)
            .collection(keyAddress)
            .add(client.address!.toMap());
      }

      return DataResult.success(client);
    } catch (err) {
      final message = 'ClientFirebaseRepository.update: $err';
      log(message);
      return DataResult.failure(FireStoreFailure(message: message));
    }
  }

  @override
  Future<DataResult<void>> delete(String clientId) async {
    try {
      final clientDoc = _firebase.collection(keyClient).doc(clientId);

      // Delete documents from the addresses subcollectin before deleting the client
      final addresses = await clientDoc.collection(keyAddress).get();
      for (final doc in addresses.docs) {
        await doc.reference.delete();
      }

      // Now delete the main client document
      await clientDoc.delete();

      return DataResult.success(null);
    } catch (err) {
      final message = 'ClientFirebaseRepository.delete: $err';
      log(message);
      return DataResult.failure(FireStoreFailure(message: message));
    }
  }

  @override
  Future<DataResult<ClientModel?>> get(String clientId) async {
    try {
      final docSnapshot =
          await _firebase.collection(keyClient).doc(clientId).get();
      if (!docSnapshot.exists) {
        throw Exception('Client not found');
      }

      final data = docSnapshot.data()!;
      final client = ClientModel.fromMap(data);
      final addresses = await getAddressesForClient(clientId);
      client.address = addresses?.first;
      return DataResult.success(client);
    } catch (err) {
      final message = 'ClientFirebaseRepository.get: $err';
      log(message);
      return DataResult.failure(FireStoreFailure(message: message));
    }
  }

  @override
  Future<List<AddressModel>?> getAddressesForClient(String clientId) async {
    try {
      final querySnapshot = await _firebase
          .collection(keyClient)
          .doc(clientId)
          .collection(keyAddress)
          .get();

      // Map each document in the subcollection to an AddressModel object
      final addreseses = querySnapshot.docs
          .map((doc) => AddressModel.fromMap(
                doc.data(),
              ))
          .toList();

      return addreseses;
    } catch (err) {
      final message = 'ClientFirebaseRepository.getAddressesForClient: $err';
      log(message);
      return null;
    }
  }

  Future<DataResult<ClientModel?>> getClientByPhone(String phone) async {
    try {
      final querySnapshot = await _firebase
          .collection(keyClient)
          .where(keyPhone, isEqualTo: phone)
          .limit(1)
          .get();

      if (querySnapshot.docs.isEmpty) {
        log('No client found with phone $phone.');
      }

      final data = querySnapshot.docs.first.data();
      final client = ClientModel.fromMap(data);
      final address = await getAddressesForClient(client.id!);
      client.address = address?.first;
      return DataResult.success(client);
    } catch (err) {
      final message = 'ClientFirebaseRepository.getClientByPhone: $err';
      log(message);
      return DataResult.failure(FireStoreFailure(message: message));
    }
  }

  @override
  Future<DataResult<List<ClientModel>>> getClientsByName(String name) async {
    try {
      final List<ClientModel> clients = [];
      final querySnapshot = await _firebase
          .collection(keyClient)
          .where(keyName, isEqualTo: name)
          .get();

      if (querySnapshot.docs.isEmpty) {
        log('No client found with name $name.');
      }

      // for (final doc in querySnapshot.docs) {
      //   final client = ClientModel.fromMap(doc.data());
      //   final address = await getAddressesForClient(client.id!);
      //   client.address = address?.first;
      //   clients.add(client);
      // }
      return DataResult.success(clients);
    } catch (err) {
      final message = 'ClientFirebaseRepository.getClientsByName: $err';
      log(message);
      return DataResult.failure(FireStoreFailure(message: message));
    }
  }
}
