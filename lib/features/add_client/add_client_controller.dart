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

  void init() {
    saveClient = pageStore.saveClient;
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
