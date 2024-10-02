import 'dart:async';

import 'package:delivery/stores/pages/common/store_func.dart';
import 'package:flutter/material.dart';

import '../../common/models/user.dart';
import 'stores/clients_store.dart';
import '/stores/user/user_store.dart';
import '../../common/utils/data_result.dart';
import '/features/add_client/add_cliend_page.dart';
import '../../common/models/client.dart';
import '../../locator.dart';
import '../../repository/firebase_store/abstract_client_repository.dart';

class ClientsController {
  final clientRepository = locator<AbstractClientRepository>();
  final userStore = locator<UserStore>();
  late final ClientsStore store;

  StreamSubscription<List<ClientModel>>? _clientsSubscription;

  UserModel get user => userStore.currentUser!;

  bool get isAdmin => userStore.isAdmin;
  bool get isBusines => userStore.isBusiness;

  void init(ClientsStore newStore) {
    store = newStore;
    getClients();
  }

  void dispose() {
    _clientsSubscription?.cancel();
  }

  Future<void> getClients() async {
    store.setState(PageState.loading);
    _clientsSubscription?.cancel();
    _clientsSubscription = clientRepository.streamClientByName().listen(
        (List<ClientModel> fetchedClients) {
      store.setClients(fetchedClients);
      store.setState(PageState.success);
    }, onError: (err) {
      store.setError('Erro ao buscar clientes: $err');
    });
  }

  Future<void> editClient(BuildContext context, ClientModel client) async {
    final address = await clientRepository.getAddressesForClient(client.id!);

    if (address != null && address.isNotEmpty) {
      client.address = address.first;
    }

    if (context.mounted) {
      await Navigator.pushNamed(
        context,
        AddClientPage.routeName,
        arguments: client,
      );
    }
  }

  Future<DataResult<void>> deleteClient(ClientModel client) async {
    return await clientRepository.delete(client.id!);
  }
}
