import 'package:flutter/material.dart';

import '/components/custons_text_controllers/masked_text_controller.dart';
import '/stores/mobx/delivery_person_store.dart';

class DeliveryPersonController {
  final nameController = TextEditingController();
  final phoneController = MaskedTextController(mask: '(##) ####-#####');
  final cepController = MaskedTextController(mask: '##-###.###');
  final cpfController = MaskedTextController(mask: '###.###.###-##');
  final numberController = TextEditingController();
  final complementController = TextEditingController();
  final emailController = TextEditingController();
  final passWordController = TextEditingController();
  final passWordCheckController = TextEditingController();

  final formKey = GlobalKey<FormState>();

  final deliveryPerson = DeliveryPersonStore();
}
