import 'package:flutter/material.dart';

import '../../common/models/client.dart';
import '../../common/utils/data_result.dart';
import '../../stores/mobx/common/store_func.dart';
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

  ZipStatus get zipStatus => pageStore.zipStatus;
  PageState get state => pageStore.state;
  bool get isValid => pageStore.isValid();
  bool get isEdited => pageStore.isEdited;

  Future<DataResult<ClientModel?>> saveClient() => pageStore.saveClient();
  Future<DataResult<ClientModel?>> updateClient() => pageStore.updateClient();

  bool isAddMode = true;

  void init(ClientModel? client) {
    if (client != null) {
      pageStore.setClientFromClient(client);
      nameController.text = client.name;
      emailController.text = client.email ?? '';
      phoneController.text = client.phone;
      pageStore.addressType = client.address?.type ?? 'Residencial';
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
  }
}
