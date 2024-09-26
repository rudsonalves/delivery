import '../../common/models/shop.dart';
import '../../common/models/user.dart';
import '../../locator.dart';
import '../../stores/pages/account_store.dart';
import '../../stores/pages/common/store_func.dart';
import '../../stores/user/user_store.dart';

class AccountController {
  final userStore = locator<UserStore>();
  final pageStore = AccountStore();

  UserModel? get currentUser => userStore.currentUser;
  bool get showQRCode => pageStore.showQRCode;
  PageState get state => pageStore.state;
  List<ShopModel> get shops => pageStore.shops;
  void toogleShowQRCode() => pageStore.toogleShowQRCode();

  Future<void> init() async {
    await pageStore.init();
  }

  Future<void> getManagerShops() async {
    await pageStore.getManagerShops();
  }
}
