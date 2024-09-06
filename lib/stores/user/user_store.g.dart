// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$UserStore on _UserStore, Store {
  late final _$userStatusAtom =
      Atom(name: '_UserStore.userStatus', context: context);

  @override
  bool get userStatus {
    _$userStatusAtom.reportRead();
    return super.userStatus;
  }

  @override
  set userStatus(bool value) {
    _$userStatusAtom.reportWrite(value, super.userStatus, () {
      super.userStatus = value;
    });
  }

  late final _$currentUserAtom =
      Atom(name: '_UserStore.currentUser', context: context);

  @override
  UserModel? get currentUser {
    _$currentUserAtom.reportRead();
    return super.currentUser;
  }

  @override
  set currentUser(UserModel? value) {
    _$currentUserAtom.reportWrite(value, super.currentUser, () {
      super.currentUser = value;
    });
  }

  late final _$isLoggedInAtom =
      Atom(name: '_UserStore.isLoggedIn', context: context);

  @override
  bool get isLoggedIn {
    _$isLoggedInAtom.reportRead();
    return super.isLoggedIn;
  }

  @override
  set isLoggedIn(bool value) {
    _$isLoggedInAtom.reportWrite(value, super.isLoggedIn, () {
      super.isLoggedIn = value;
    });
  }

  late final _$errorMessageAtom =
      Atom(name: '_UserStore.errorMessage', context: context);

  @override
  String? get errorMessage {
    _$errorMessageAtom.reportRead();
    return super.errorMessage;
  }

  @override
  set errorMessage(String? value) {
    _$errorMessageAtom.reportWrite(value, super.errorMessage, () {
      super.errorMessage = value;
    });
  }

  late final _$stateAtom = Atom(name: '_UserStore.state', context: context);

  @override
  UserState get state {
    _$stateAtom.reportRead();
    return super.state;
  }

  @override
  set state(UserState value) {
    _$stateAtom.reportWrite(value, super.state, () {
      super.state = value;
    });
  }

  late final _$initializeUserAsyncAction =
      AsyncAction('_UserStore.initializeUser', context: context);

  @override
  Future<void> initializeUser() {
    return _$initializeUserAsyncAction.run(() => super.initializeUser());
  }

  late final _$signUpAsyncAction =
      AsyncAction('_UserStore.signUp', context: context);

  @override
  Future<DataResult<UserModel>> signUp(UserModel user) {
    return _$signUpAsyncAction.run(() => super.signUp(user));
  }

  late final _$signInAsyncAction =
      AsyncAction('_UserStore.signIn', context: context);

  @override
  Future<DataResult<UserModel>> signIn(String email, String password) {
    return _$signInAsyncAction.run(() => super.signIn(email, password));
  }

  late final _$logoutAsyncAction =
      AsyncAction('_UserStore.logout', context: context);

  @override
  Future<DataResult<void>> logout() {
    return _$logoutAsyncAction.run(() => super.logout());
  }

  late final _$sendSignInLinkToEmailAsyncAction =
      AsyncAction('_UserStore.sendSignInLinkToEmail', context: context);

  @override
  Future<DataResult<void>> sendSignInLinkToEmail(String email) {
    return _$sendSignInLinkToEmailAsyncAction
        .run(() => super.sendSignInLinkToEmail(email));
  }

  late final _$_UserStoreActionController =
      ActionController(name: '_UserStore', context: context);

  @override
  void toogleUSerStatus() {
    final _$actionInfo = _$_UserStoreActionController.startAction(
        name: '_UserStore.toogleUSerStatus');
    try {
      return super.toogleUSerStatus();
    } finally {
      _$_UserStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic setState(UserState newState) {
    final _$actionInfo =
        _$_UserStoreActionController.startAction(name: '_UserStore.setState');
    try {
      return super.setState(newState);
    } finally {
      _$_UserStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
userStatus: ${userStatus},
currentUser: ${currentUser},
isLoggedIn: ${isLoggedIn},
errorMessage: ${errorMessage},
state: ${state}
    ''';
  }
}
