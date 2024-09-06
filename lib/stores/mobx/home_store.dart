import 'package:mobx/mobx.dart';

part 'home_store.g.dart';

// ignore: library_private_types_in_public_api
class HomeStore = _HomeStore with _$HomeStore;

abstract class _HomeStore with Store {
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
