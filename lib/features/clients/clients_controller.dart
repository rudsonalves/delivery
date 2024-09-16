import 'package:flutter/material.dart';

import '../../common/models/user.dart';
import '/stores/user/user_store.dart';
import '../../common/utils/data_result.dart';
import '/features/add_client/add_cliend_page.dart';
import '../../common/models/client.dart';
import '../../locator.dart';
import '../../repository/firebase_store/abstract_client_repository.dart';

class ClientsController {
  final clientRepository = locator<AbstractClientRepository>();
  final userStore = locator<UserStore>();

  UserModel get user => userStore.currentUser!;

  bool get isAdmin => userStore.isAdmin;
  bool get isBusines => userStore.isBusiness;

  void init() {}

  Future<void> editClient(BuildContext context, ClientModel client) async {
    final address = await clientRepository.getAddressesForClient(client.id!);

    if (address != null && address.isNotEmpty) {
      client.address = address.first;
    }

    if (context.mounted) {
      await Navigator.pushNamed(
        context,
        AddClientPage.routeName,
        arguments: {'client': client},
      );
    }
  }

  Future<DataResult<void>> deleteClient(ClientModel client) async {
    return await clientRepository.delete(client.id!);
  }
}
