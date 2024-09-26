import 'package:mobx/mobx.dart';

part 'user_admin_store.g.dart';

// ignore: library_private_types_in_public_api
class UserAdminStore = _UserAdminStore with _$UserAdminStore;

abstract class _UserAdminStore with Store {
  @observable
  bool hasPhone = true;

  @observable
  bool hasAddress = true;

  @action
  setHasPhone(bool value) {
    hasPhone = value;
  }

  @action
  setHasAddress(bool value) {
    hasAddress = value;
  }
}
