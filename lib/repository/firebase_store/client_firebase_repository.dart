import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';

import '../../common/models/address.dart';
import '../../locator.dart';
import '../../stores/user/user_store.dart';
import '/common/models/client.dart';
import '/common/utils/data_result.dart';
import 'abstract_client_repository.dart';

const keyClient = 'clients';
const keyAddress = 'addresses';
const keyPhone = 'phone';
const keyName = 'name';

// Error codes
// 300 - generic error
// 301 - client ID cannot be null for update operation
// 302 - client not found in clientId
class ClientFirebaseRepository implements AbstractClientRepository {
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
      await _firebase.collection(keyAddress).doc(client.id).update(
            client.toMap(),
          );

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
      final currentUser = locator<UserStore>().currentUser!;
      log('${currentUser.role.name}: ${currentUser.role.index}');
      return DataResult.failure(FireStoreFailure(
        message: message,
        code: 300,
      ));
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
      return DataResult.failure(FireStoreFailure(
        message: message,
        code: 300,
      ));
    }
  }

  @override
  Future<DataResult<ClientModel?>> get(String clientId) async {
    try {
      final docSnapshot =
          await _firebase.collection(keyClient).doc(clientId).get();
      if (!docSnapshot.exists) {
        const message = 'ClientFirebaseRepository.get: client not found';
        log(message);
        return DataResult.failure(const GenericFailure(
          message: message,
          code: 302,
        ));
      }

      final data = docSnapshot.data()!;
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
      final querySnapshot = await _firebase
          .collection(keyClient)
          .doc(clientId)
          .collection(keyAddress)
          .get();

      // Map each document in the subcollection to an AddressModel object
      final addreseses = querySnapshot.docs
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
          .collection(keyClient)
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
          .collection(keyClient)
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
          .collection(keyClient)
          .orderBy(keyName)
          .snapshots()
          .map((snapshot) => snapshot.docs.map((doc) {
                final client =
                    ClientModel.fromMap(doc.data()).copyWith(id: doc.id);
                return client;
              }).toList());
    } catch (err) {
      final message = 'ClientFirebaseRepository.streamClientsByName: $err';
      log(message);
      throw Exception(message);
    }
  }
}
