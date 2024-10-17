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

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'package:qr_flutter/qr_flutter.dart';

import 'stores/account_store.dart';
import '../../stores/common/store_func.dart';
import 'account_controller.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({super.key});

  static const routeName = '/account';

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  final ctrl = AccountController();
  final store = AccountStore();
  double _size = 250;
  double _maxSize = 500;

  @override
  void initState() {
    super.initState();
    ctrl.init(store);
  }

  void _backPage() {
    Navigator.of(context).pop();
  }

  void _add() {
    setState(() {
      _size = _size < _maxSize ? _size + 10 : _maxSize;
    });
  }

  void _remove() {
    setState(() {
      _size = _size > 200 ? _size - 10 : 200;
    });
  }

  @override
  Widget build(BuildContext context) {
    _maxSize = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Conta Pessoal'),
        centerTitle: true,
        elevation: 5,
        leading: IconButton(
          onPressed: _backPage,
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
        ),
      ),
      body: Observer(builder: (context) {
        if (!store.showQRCode) {
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextButton.icon(
                    onPressed: store.toogleShowQRCode,
                    icon: const Icon(Symbols.qr_code_scanner_rounded),
                    label: const Text('Gerar QR Code'),
                  ),
                  TextButton.icon(
                    onPressed: ctrl.getManagerShops,
                    icon: const Icon(Symbols.refresh),
                    label: const Text('Carregar Lojas'),
                  ),
                  if (store.state == PageState.loading)
                    const Center(
                      child: CircularProgressIndicator(),
                    ),
                  if (store.state == PageState.success)
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          const Divider(),
                          const Text('Lojas Gerenciadas:'),
                          ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: store.shops.length,
                            itemBuilder: (context, index) => Card(
                              child: ListTile(
                                leading: const Icon(Icons.store),
                                title: Text(store.shops[index].name),
                                subtitle:
                                    Text(store.shops[index].description ?? ''),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          );
        }
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: QrImageView(
                data: jsonEncode({
                  "id": ctrl.currentUser!.id!,
                  "name": ctrl.currentUser!.name,
                }),
                version: QrVersions.auto,
                size: _size,
                gapless: true,
                backgroundColor: Colors.white,
                eyeStyle: const QrEyeStyle(
                  eyeShape: QrEyeShape.square,
                  color: Colors.black,
                ),
                dataModuleStyle: const QrDataModuleStyle(
                  dataModuleShape: QrDataModuleShape.square,
                  color: Colors.black,
                ),
              ),
            ),
            const SizedBox(height: 30),
            OverflowBar(
              alignment: MainAxisAlignment.spaceAround,
              children: [
                IconButton.filled(
                  icon: const Icon(Icons.add),
                  onPressed: _add,
                ),
                FilledButton.icon(
                  label: const Text('Fechar'),
                  icon: const Icon(Icons.close),
                  onPressed: store.toogleShowQRCode,
                ),
                IconButton.filled(
                  icon: const Icon(Icons.remove),
                  onPressed: _remove,
                ),
              ],
            ),
          ],
        );
      }),
    );
  }
}
