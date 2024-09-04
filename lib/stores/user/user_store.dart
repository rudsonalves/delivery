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
  UserModel? currentUser;

  @observable
  bool isLoggedIn = false;

  @observable
  String? errorMessage;

  @observable
  UserState state = UserState.stateInitial;

  @action
  void initializeUser() {
    state = UserState.stateLoading;
    auth.userChanges(
      logged: (UserModel userModel) async {
        currentUser = userModel;
        isLoggedIn = true;
        state = UserState.stateSuccess;
      },
      notLogged: () async {
        currentUser = null;
        isLoggedIn = false;
        state = UserState.stateSuccess;
      },
      onError: (error) {
        errorMessage = 'Error monitoring authentication changes: $error';
        log(errorMessage!);
        state = UserState.stateError;
      },
    );
  }

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
        log('User created: $user');
      },
    );

    return result;
  }

  @action
  Future<DataResult<UserModel>> login(String email, String password) async {
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
        log('User logged: $user');
        state = UserState.stateSuccess;
      },
    );

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
      return DataResult.success(null);
    } catch (err) {
      errorMessage = 'Erro ao fazer logout';
      log(errorMessage!);
      state = UserState.stateError;
      return DataResult.failure(GenericFailure(errorMessage));
    }
  }

  @action
  setState(UserState newState) {
    state = newState;
  }
}
