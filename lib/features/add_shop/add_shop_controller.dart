import 'package:delivery/components/custons_text_controllers/masked_text_controller.dart';
import 'package:flutter/material.dart';

import '/stores/mobx/add_shop_store.dart';

class AddShopController {
  final pageStore = AddShopStore();

  final nameController = TextEditingController();
  final descriptionController = TextEditingController();
  final cepController = MaskedTextController(mask: '##.###-###');
  final numberController = TextEditingController();
  final complementController = TextEditingController();

  bool isEdited = false;
  bool isAddMode = true;

  void dispose() {
    nameController.dispose();
    cepController.dispose();
    numberController.dispose();
    complementController.dispose();
    descriptionController.dispose();
  }
}
