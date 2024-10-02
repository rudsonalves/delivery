import 'package:mobx/mobx.dart';

import '../../../common/models/client.dart';
import '../../../stores/pages/common/store_func.dart';

part 'clients_store.g.dart';

// ignore: library_private_types_in_public_api
class ClientsStore = _ClientsStore with _$ClientsStore;

abstract class _ClientsStore with Store {
  @observable
  PageState state = PageState.initial;

  @observable
  String? errorMessage;

  @observable
  ObservableList<ClientModel> clients = ObservableList<ClientModel>();

  @action
  setState(PageState newState) {
    state = newState;
  }

  @action
  void setClients(List<ClientModel> newShops) {
    clients = ObservableList<ClientModel>.of(newShops);
  }

  @action
  setError(String message) {
    errorMessage = message;
    setState(PageState.error);
  }
}
