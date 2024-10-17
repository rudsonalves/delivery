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

import 'dart:developer';

import 'package:flutter/material.dart';

import '../../locator.dart';
import '../../stores/user/user_store.dart';
import '/components/custons_text_controllers/masked_text_controller.dart';
import 'stores/personal_data_store.dart';
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
