import 'package:delivery/locator.dart';

import '../../repository/firebase_store/shop_firebase_repository.dart';
import '../../stores/mobx/common/generic_functions.dart';
import '../../stores/mobx/shops_store.dart';
import '../../stores/user/user_store.dart';

class ShopsController {
  final pageStore = ShopsStore();
  final shopRepository = ShopFirebaseRepository();
  final userStore = locator<UserStore>();

  PageState get state => pageStore.state;

  bool get isAdmin => userStore.isAdmin;
}
