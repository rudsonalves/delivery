import 'dart:developer';

import 'package:flutter/material.dart';

import '../../locator.dart';
import '../../stores/user/user_store.dart';
import '/components/custons_text_controllers/masked_text_controller.dart';
import '../../stores/pages/personal_data_store.dart';
import 'widgets/text_input_dialog.dart';

class PersonController {
  final nameController = TextEditingController();
  final phoneController = MaskedTextController(mask: '(##) ####-#####');
  final cepController = MaskedTextController(mask: '##-###.###');
  // final cpfController = MaskedTextController(mask: '###.###.###-##');
  final numberController = TextEditingController();
  final complementController = TextEditingController();
  final emailController = TextEditingController();
  final passWordController = TextEditingController();
  final passWordCheckController = TextEditingController();

  final user = locator<UserStore>();

  final formKey = GlobalKey<FormState>();

  final personalData = PersonalDataStore();

  bool get isValid => personalData.isValid();

  Future<void> save(BuildContext context) async {
    try {
      await user.auth.requestPhoneNumberVerification(personalData.phone!);

      if (context.mounted) {
        final response = await TextInputDialog.open(
          context,
          title: 'Código SMS',
          message: 'message',
        ) as String?;
        log(response.toString());
        if (response == null || response.isEmpty) return;
        await user.auth.updatePhoneInAuth(response);
      }
    } catch (err) {
      log(err.toString());
    }
  }
}
