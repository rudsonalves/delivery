import 'package:mobx/mobx.dart';

part 'user_business_store.g.dart';

// ignore: library_private_types_in_public_api
class UserBusinessStore = _UserBusinessStore with _$UserBusinessStore;

abstract class _UserBusinessStore with Store {
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
