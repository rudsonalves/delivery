import 'package:flutter/material.dart';

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

  Status get status => pageStore.status;

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
}
