import 'package:flutter/material.dart';

import '../../common/models/client.dart';
import '../../common/utils/data_result.dart';
import '/components/custons_text_controllers/masked_text_controller.dart';
import '../../stores/mobx/add_client_store.dart';

class AddClientController {
  final pageStore = AddClientStore();

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = MaskedTextController(mask: '(##) #####-####');
  final cepController = MaskedTextController(mask: '##.###-###');
  final numberController = TextEditingController();
  final complementController = TextEditingController();
  final addressTypeController = TextEditingController();

  ZipStatus get zipStatus => pageStore.zipStatus;
  PageStatus get pageStatus => pageStore.pageStatus;
  bool get isValid => pageStore.isValid();
  late Future<DataResult<ClientModel?>> Function() saveClient;
  late Future<DataResult<ClientModel?>> Function() updateClient;

  bool isAddMode = true;
  bool get isEdited => pageStore.isEdited;

  void init(ClientModel? client) {
    saveClient = pageStore.saveClient;
    updateClient = pageStore.updateClient;

    if (client != null) {
      pageStore.setClientFromClient(client);
      nameController.text = client.name;
      emailController.text = client.email ?? '';
      phoneController.text = client.phone;
      addressTypeController.text = client.address?.type ?? 'Residencial';
      cepController.text = client.address?.zipCode ?? '';
      numberController.text = client.address?.number ?? '';
      complementController.text = client.address?.complement ?? '';
      isAddMode = false;
    }
  }

  void dispose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    cepController.dispose();
    numberController.dispose();
    complementController.dispose();
    addressTypeController.dispose();
  }
}
