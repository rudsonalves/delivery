import 'dart:developer';

import 'package:mobx/mobx.dart';

import '/repository/firebase/firebase_auth_repository.dart';

part 'user_store.g.dart';

// ignore: library_private_types_in_public_api
class UserStore = _UserStore with _$UserStore;

abstract class _UserStore with Store {
  @observable
  bool isLoggedIn = false;

  @observable
  String? errorMessage;

  @action
  Future<void> signUp(String email, String password) async {
    final result = await FirebaseAuthRepository.create(
      email: email,
      password: password,
    );

    result.fold(
      (failure) {
        isLoggedIn = false;
        errorMessage = failure.message;
        log('Create user error: $errorMessage');
      },
      (userCredential) {
        isLoggedIn = true;
        errorMessage = null;
        log('User created: ${userCredential.user}');
      },
    );
  }

  @action
  Future<void> login(String email, String password) async {
    final result = await FirebaseAuthRepository.signIn(
      email: email,
      password: password,
    );

    result.fold(
      (failure) {
        isLoggedIn = false;
        errorMessage = failure.message;
        log('Login user error: $errorMessage');
      },
      (userCredential) {
        isLoggedIn = true;
        errorMessage = null;
        log('User logged: ${userCredential.user}');
      },
    );
  }

  @action
  Future<void> logout() async {
    try {
      await FirebaseAuthRepository.signOut();
      isLoggedIn = false;
      errorMessage = null;
    } catch (err) {
      log('Erro ao fazer logout: $err');
      errorMessage = 'Erro ao fazer logout';
    }
  }
}
