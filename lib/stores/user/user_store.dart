import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:mobx/mobx.dart';

import '../../common/models/user.dart';
import '/repository/firebase/firebase_auth_repository.dart';

part 'user_store.g.dart';

// ignore: library_private_types_in_public_api
class UserStore = _UserStore with _$UserStore;

enum UserState { stateLoading, stateSuccess, stateError, stateInitial }

abstract class _UserStore with Store {
  @observable
  User? currentUser;

  @observable
  bool isLoggedIn = false;

  @observable
  String? errorMessage;

  @observable
  UserState state = UserState.stateInitial;

  @action
  void initializeUser() {
    state = UserState.stateInitial;
    FirebaseAuthRepository.userChanges(
      logged: () async {
        currentUser = FirebaseAuthRepository.getCurrentUser();
        isLoggedIn = currentUser != null;
      },
      notLogged: () async {
        currentUser = null;
        isLoggedIn = false;
      },
      onError: (error) {
        errorMessage = 'Error monitoring authentication changes: $error';
        log(errorMessage!);
        state = UserState.stateError;
      },
    );
  }

  @action
  Future<void> signUp(UserModel user) async {
    state = UserState.stateLoading;
    final result = await FirebaseAuthRepository.create(user);

    result.fold(
      (failure) {
        state = UserState.stateError;
        currentUser = null;
        isLoggedIn = false;
        errorMessage = failure.message;
        log('Create user error: $errorMessage');
      },
      (user) {
        state = UserState.stateSuccess;
        currentUser = FirebaseAuthRepository.getCurrentUser();
        isLoggedIn = true;
        errorMessage = null;
        log('User created: $user');
      },
    );
  }

  @action
  Future<void> login(String email, String password) async {
    state = UserState.stateLoading;
    final result = await FirebaseAuthRepository.signIn(
      email: email,
      password: password,
    );

    result.fold(
      (failure) {
        isLoggedIn = false;
        errorMessage = failure.message;
        log('Login user error: $errorMessage');
        currentUser = null;
        state = UserState.stateError;
      },
      (user) {
        currentUser = FirebaseAuthRepository.getCurrentUser();
        isLoggedIn = true;
        errorMessage = null;
        log('User logged: $user');
        state = UserState.stateSuccess;
      },
    );
  }

  @action
  Future<void> logout() async {
    try {
      state = UserState.stateLoading;
      await FirebaseAuthRepository.signOut();
      isLoggedIn = false;
      errorMessage = null;
      currentUser = null;
      state = UserState.stateSuccess;
    } catch (err) {
      errorMessage = 'Erro ao fazer logout';
      log(errorMessage!);
      state = UserState.stateError;
    }
  }

  @action
  setState(UserState newState) {
    state = newState;
  }

  @action
  Future<void> updateProfile({
    String? displayName,
    String? photoURL,
    String? newPassword,
    PhoneAuthCredential? phoneCredential,
  }) async {
    if (currentUser == null) return;
    try {
      currentUser = await FirebaseAuthRepository.updateProfile(
        currentUser: currentUser!,
        displayName: displayName,
        photoURL: photoURL,
        newPassword: newPassword,
        phoneCredential: phoneCredential,
      );
    } catch (err) {
      errorMessage = 'Update profile error: $err';
      log(errorMessage!);
    }
  }
}
