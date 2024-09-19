import 'package:mobx/mobx.dart';

part 'account_store.g.dart';

// ignore: library_private_types_in_public_api
class AccountStore = _AccountStore with _$AccountStore;

abstract class _AccountStore with Store {
  @observable
  bool showQRCode = false;

  @action
  void toogleShowQRCode() {
    showQRCode = !showQRCode;
  }
}
