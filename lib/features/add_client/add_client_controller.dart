import 'dart:developer';

import 'package:flutter/material.dart';

import '../../repository/firestore/client_firebase_repository.dart';
import '/components/custons_text_controllers/masked_text_controller.dart';
import '../../stores/mobx/add_client_store.dart';

class AddClientController {
  final pageStore = AddClientStore();
  final repository = ClientFirebaseRepository();

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = MaskedTextController(mask: '(##) #####-####');
  final cepController = MaskedTextController(mask: '##.###-###');
  final numberController = TextEditingController();
  final complementController = TextEditingController();
  final addressTypeController = TextEditingController();

  Status get status => pageStore.status;
  bool get isValid => pageStore.isValid();

  void init() {}

  void dispose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    cepController.dispose();
    numberController.dispose();
    complementController.dispose();
    addressTypeController.dispose();
  }

  Future<void> saveClient() async {
    if (!isValid) return;
    final client = await pageStore.getClient();
    if (client == null) {
      throw Exception('Unexpected error');
    }
    log(client.toString());
    final result = await repository.add(client);
    if (result.isFailure) {
      log(result.error.toString());
      return;
    }
    log(result.data.toString());
  }
}
