import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'user_repository.dart';
import '../../common/models/user.dart';
import '../../common/utils/data_result.dart';

const keyUsers = 'users';

class UserFirestoreRepository implements UserRepository {
  static final _firebase = FirebaseFirestore.instance;

  @override
  Future<DataResult<UserModel>> set(UserModel user) async {
    try {
      if (user.id == null) {
        throw Exception('User ID cannot be null for set operation.');
      }
      await _firebase.collection(keyUsers).doc(user.id).set(_userMapAttr(user));
      return DataResult.success(user);
    } catch (err) {
      final message = 'UserFirestoreRepository.set: $err';
      log(message);
      return DataResult.failure(FireStoreFailure(message));
    }
  }

  Map<String, dynamic> _userMapAttr(UserModel user) {
    return {
      'role': user.role.index,
      'userStatus': user.userStatus.index,
    };
  }

  @override
  Future<void> setEmailVerification(String userId, bool emailVerified) async {
    try {
      await _firebase.collection(keyUsers).doc(userId).update(
        {'emailVerified': emailVerified},
      );
      return;
    } catch (err) {
      final message = 'UserFirestoreRepository.setEmailVerification: $err';
      log(message);
      return;
    }
  }

  @override
  Future<DataResult<UserModel>> update(UserModel user) async {
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

  @override
  Future<DataResult<void>> delete(String userId) async {
    try {
      await _firebase.collection(keyUsers).doc(userId).delete();
      return DataResult.success(null);
    } catch (err) {
      final message = 'UserFirestoreRepository.delete: $err';
      log(message);
      return DataResult.failure(FireStoreFailure(message));
    }
  }

  @override
  Future<DataResult<UserModel?>> get(UserModel user) async {
    try {
      final docSnapshot =
          await _firebase.collection(keyUsers).doc(user.id).get();
      if (!docSnapshot.exists) {
        throw Exception('User not found');
      }
      final map = docSnapshot.data() as Map<String, dynamic>;
      final newUser = _setUserAttr(user, map);
      return DataResult.success(newUser);
    } catch (err) {
      final message = 'UserFirestoreRepository.get: $err';
      log(message);
      return DataResult.failure(FireStoreFailure(message));
    }
  }

  UserModel _setUserAttr(UserModel user, Map<String, dynamic> map) {
    return user.copyWith(
      role: UserRole.values[map['role'] as int],
      userStatus: UserStatus.values[map['userStatus'] as int],
    );
  }
}
