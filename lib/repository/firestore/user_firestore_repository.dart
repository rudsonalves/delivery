import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';

import '../../common/models/user.dart';
import '../../common/utils/data_result.dart';

const keyUsers = 'users';

class UserFirestoreRepository {
  UserFirestoreRepository._();

  static final _firebase = FirebaseFirestore.instance;

  /// Add a new user to Firestore and return the result
  static Future<DataResult<UserModel>> add(UserModel user) async {
    try {
      final docRef = await _firebase.collection(keyUsers).add(user.toMap());
      user.id = docRef.id;
      return DataResult.success(user);
    } catch (err) {
      final message = 'UserFirestoreRepository.add: $err';
      log(message);
      return DataResult.failure(FireStoreFailure(message));
    }
  }

  /// Set a user document in Firestore with a specified ID and return the result
  static Future<DataResult<UserModel>> set(UserModel user) async {
    try {
      if (user.id == null) {
        throw Exception('User ID cannot be null for set operation.');
      }
      await _firebase.collection(keyUsers).doc(user.id).set(user.toMap());
      return DataResult.success(user);
    } catch (err) {
      final message = 'UserFirestoreRepository.set: $err';
      log(message);
      return DataResult.failure(FireStoreFailure(message));
    }
  }

  /// Update an existing user document in Firestore and return the result
  static Future<DataResult<UserModel>> update(UserModel user) async {
    try {
      if (user.id == null) {
        throw Exception('User ID cannot be null for update operation.');
      }
      await _firebase.collection(keyUsers).doc(user.id).update(user.toMap());
      return DataResult.success(user);
    } catch (err) {
      final message = 'UserFirestoreRepository.update: $err';
      log(message);
      return DataResult.failure(FireStoreFailure(message));
    }
  }

  /// Delete a user document from Firestore and return the result
  static Future<DataResult<void>> delete(String userId) async {
    try {
      await _firebase.collection(keyUsers).doc(userId).delete();
      return DataResult.success(null);
    } catch (err) {
      final message = 'UserFirestoreRepository.delete: $err';
      log(message);
      return DataResult.failure(FireStoreFailure(message));
    }
  }

  /// Fetch a single user document from Firestore and return the result
  static Future<DataResult<UserModel>> get(String userId) async {
    try {
      final docSnapshot =
          await _firebase.collection(keyUsers).doc(userId).get();
      if (!docSnapshot.exists) {
        throw Exception('User not found');
      }
      final user =
          UserModel.fromMap(docSnapshot.data() as Map<String, dynamic>);
      return DataResult.success(user);
    } catch (err) {
      final message = 'UserFirestoreRepository.get: $err';
      log(message);
      return DataResult.failure(FireStoreFailure(message));
    }
  }

  /// Fetch all users from Firestore and return the result
  static Future<DataResult<List<UserModel>>> getAll() async {
    try {
      final querySnapshot = await _firebase.collection(keyUsers).get();
      final users = querySnapshot.docs
          .map((doc) => UserModel.fromMap(doc.data()))
          .toList();
      return DataResult.success(users);
    } catch (err) {
      final message = 'UserFirestoreRepository.getAll: $err';
      log(message);
      return DataResult.failure(FireStoreFailure(message));
    }
  }

  /// Listen to real-time updates of all users from Firestore
  static Stream<DataResult<List<UserModel>>> getStream() {
    return _firebase.collection(keyUsers).snapshots().map((querySnapshot) {
      try {
        final users = querySnapshot.docs.map((doc) {
          return UserModel.fromMap(doc.data());
        }).toList();
        return DataResult.success(users);
      } catch (err) {
        final message = 'UserFirestoreRepository.getStream: $err';
        log(message);
        return DataResult.failure(FireStoreFailure(message));
      }
    });
  }
}
