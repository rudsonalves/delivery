import 'dart:async';
import 'dart:developer';

import 'package:mobx/mobx.dart';

import '../../common/models/user.dart';
import '../../common/utils/data_result.dart';
import '../../locator.dart';
import '../../repository/firebase/auth_repository.dart';
import '/repository/firebase/firebase_auth_repository.dart';
import '../../services/local_storage_service.dart';

part 'user_store.g.dart';

// ignore: library_private_types_in_public_api
class UserStore = _UserStore with _$UserStore;

enum UserState { stateLoading, stateSuccess, stateError, stateInitial }

abstract class _UserStore with Store {
  final localStore = locator<LocalStorageService>();
  final AuthRepository auth = FirebaseAuthRepository();

  @observable
  bool userStatus = true;

  @observable
  UserModel? currentUser;

  @observable
  bool isLoggedIn = false;

  @observable
  String? errorMessage;

  @observable
  UserState state = UserState.stateInitial;

  void dispose() {}

  String? get id => currentUser?.id;

  @action
  Future<void> initializeUser() async {
    state = UserState.stateLoading;

    final user = await auth.getCurrentUser();
    if (user != null) {
      currentUser = user;
      isLoggedIn = true;
      state = UserState.stateSuccess;
    } else {
      currentUser = null;
      isLoggedIn = false;
      state = UserState.stateInitial;
    }
    toogleUSerStatus();
  }

  bool get isAdmin =>
      currentUser != null && currentUser!.role == UserRole.admin;

  bool get isBusiness =>
      currentUser != null && currentUser!.role == UserRole.business;

  @action
  void toogleUSerStatus() => userStatus = !userStatus;

  @action
  Future<DataResult<UserModel>> signUp(UserModel user) async {
    state = UserState.stateLoading;
    final result = await auth.create(user);

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
        currentUser = result.data!;
        isLoggedIn = true;
        errorMessage = null;
        log('User created');
      },
    );

    return result;
  }

  @action
  Future<DataResult<UserModel>> signIn(String email, String password) async {
    state = UserState.stateLoading;
    final result = await auth.signIn(
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
      (user) async {
        currentUser = user;
        isLoggedIn = true;
        errorMessage = null;
        state = UserState.stateSuccess;
      },
    );
    toogleUSerStatus();
    return result;
  }

  @action
  Future<DataResult<void>> logout() async {
    try {
      state = UserState.stateLoading;
      await auth.signOut();
      isLoggedIn = false;
      errorMessage = null;
      currentUser = null;
      state = UserState.stateSuccess;
      toogleUSerStatus();
      return DataResult.success(null);
    } catch (err) {
      errorMessage = 'Erro ao fazer logout';
      log(errorMessage!);
      state = UserState.stateError;
      toogleUSerStatus();
      return DataResult.failure(GenericFailure(message: errorMessage));
    }
  }

  @action
  setState(UserState newState) {
    state = newState;
  }

  @action
  Future<DataResult<void>> sendSignInLinkToEmail(String email) async {
    try {
      if (isLoggedIn) await logout();
      await auth.sendSignInLinkToEmail(email);
      return DataResult.success(null);
    } catch (err) {
      await logout();
      errorMessage = 'Erro ao fazer logout';
      log(errorMessage!);
      state = UserState.stateError;
      return DataResult.failure(GenericFailure(message: errorMessage));
    }
  }
}
