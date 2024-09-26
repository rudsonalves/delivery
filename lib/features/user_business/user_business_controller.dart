import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';

import '../../common/models/user.dart';
import '../../common/settings/app_settings.dart';
import '../../locator.dart';
import '../../repository/firebase_store/deliveries_firebase_repository.dart';
import '../../stores/pages/user_delivery_store.dart';
import '../../stores/user/user_store.dart';

class UserBusinessController {
  StreamSubscription<User?>? _authSubscription;
  final userStore = locator<UserStore>();
  final app = locator<AppSettings>();
  final store = UserDeliveryStore();
  final deliveryRepository = DeliveriesFirebaseRepository();

  bool get isLoggedIn => userStore.isLoggedIn;
  bool get isDark => app.isDark;
  bool get isAdmin => userStore.isAdmin;
  bool get isBusiness => userStore.isBusiness;
  bool get isManager => userStore.isManager;
  bool get doesNotHavePhone =>
      currentUser!.phone == null || currentUser!.phone!.isEmpty;
  UserModel? get currentUser => userStore.currentUser;

  init() {
    if (isLoggedIn) {
      // store.setHasPhone(currentUser!.phone != null);
      // store.setHasAddress(currentUser!.address != null);
    }
  }

  void dispose() {
    _authSubscription?.cancel();
  }

  Future<void> logout() async {
    if (isLoggedIn) await userStore.logout();
  }
}
