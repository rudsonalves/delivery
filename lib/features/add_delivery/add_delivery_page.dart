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

import 'package:delivery/features/add_client/add_cliend_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

import '../../common/models/client.dart';
import 'widgets/build_main_content_form.dart';
import '../../common/theme/app_text_style.dart';
import 'stores/add_delivery_store.dart';
import '../../stores/common/store_func.dart';
import 'add_delivery_controller.dart';
import 'widgets/error_card.dart';

class AddDeliveryPage extends StatefulWidget {
  const AddDeliveryPage({super.key});

  static const routeName = '/ad_delivery';

  @override
  State<AddDeliveryPage> createState() => _AddDeliveryPageState();
}

class _AddDeliveryPageState extends State<AddDeliveryPage> {
  final ctrl = AddDeliveryController();
  final store = AddDeliveryStore();

  @override
  void initState() {
    super.initState();

    ctrl.init(store);
  }

  @override
  void dispose() {
    ctrl.dispose();

    super.dispose();
  }

  void _backPage() {
    Navigator.pop(context);
  }

  void _submitName(String name) {
    ctrl.searchClientsByName(name);
  }

  void _submitPhone(String phone) {
    ctrl.searchClentsByPhone(phone);
  }

  Future<void> _createDelivery() async {
    await ctrl.createDelivery();
    if (mounted && store.state == PageState.success) {
      Navigator.pop(context);
    }
  }

  Future<void> _addClient() async {
    await Navigator.pushNamed(context, AddClientPage.routeName);
  }

  Future<void> _editClient(ClientModel? client) async {
    await Navigator.pushNamed(context, AddClientPage.routeName,
        arguments: client);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Solicitação de Entrega'),
        centerTitle: true,
        leading: IconButton(
          onPressed: _backPage,
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: Observer(
          builder: (context) {
            if (store.state == PageState.loading) {
              return const Center(child: CircularProgressIndicator());
            } else if (store.state == PageState.error) {
              return Center(
                child: Text(store.errorMessage ?? 'Erro desconhecido',
                    style: AppTextStyle.font16Bold()),
              );
            }

            switch (ctrl.noShopsState) {
              case NoShopState.unknowError:
                return ErrorCard(
                  title: 'Erro desconhecido.',
                  message: 'Está tendo algum problema com a conexão. Por favor,'
                      ' tente mais tarde.',
                  iconData: Icons.error_outline_rounded,
                  color: Colors.red[400],
                );
              case NoShopState.noShops:
                return ErrorCard(
                  title: 'Lojas não Encontradas',
                  message: 'Sua conta não possui lojas associadas.'
                      ' É necessário que algum comerciante associe uma de suas'
                      ' lojas a sua conta como gerente de entregas.',
                  iconData: Icons.work_off_outlined,
                  color: Colors.orange[400],
                );
              case NoShopState.ready:
                return BuildMainContentForm(
                  ctrl: ctrl,
                  store: store,
                  submitName: _submitName,
                  submitPhone: _submitPhone,
                  createDelivery: _createDelivery,
                  addClient: _addClient,
                  editClient: _editClient,
                );
              case NoShopState.waiting:
                return const Center(
                  child: CircularProgressIndicator(),
                );
            }
          },
        ),
      ),
    );
  }
}
