import '../../common/models/user.dart';
import '../../locator.dart';
import '../../stores/pages/account_store.dart';
import '../../stores/user/user_store.dart';

class AccountController {
  final userStore = locator<UserStore>();
  final pageStore = AccountStore();

  UserModel? get currentUser => userStore.currentUser;
  bool get showQRCode => pageStore.showQRCode;
  void toogleShowQRCode() => pageStore.toogleShowQRCode();

  void init() {}
}
