// Copyright (C) 2024 Rudson Alves
// 
// This file is part of delivery.
// 
// delivery is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
// 
// delivery is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
// 
// You should have received a copy of the GNU General Public License
// along with delivery.  If not, see <https://www.gnu.org/licenses/>.

import 'dart:async';

import '/stores/common/store_func.dart';
import '../../common/models/user.dart';
import 'stores/clients_store.dart';
import '/stores/user/user_store.dart';
import '../../common/utils/data_result.dart';
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
    _clientsSubscription = clientRepository.streamAllClients().listen(
        (List<ClientModel> fetchedClients) {
      store.setClients(fetchedClients);
      store.setState(PageState.success);
    }, onError: (err) {
      store.setError('Erro ao buscar clientes: $err');
    });
  }

  Future<DataResult<void>> deleteClient(ClientModel client) async {
    return await clientRepository.delete(client.id!);
  }
}
