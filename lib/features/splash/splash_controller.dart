import '../../common/models/user.dart';
import '../../locator.dart';
import '../../stores/user/user_store.dart';

class SplashController {
  final store = locator<UserStore>();

  UserModel? get currentUser => store.currentUser;
  bool get isLoggedIn => store.isLoggedIn;
  UserState get state => store.state;
  bool get userStatus => store.userStatus;

  Future<void> init() async {
    await store.initializeUser();
  }
}
