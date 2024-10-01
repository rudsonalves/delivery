import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../stores/pages/account_store.dart';
import '../../stores/pages/common/store_func.dart';
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

  @override
  void initState() {
    super.initState();
    ctrl.init(store);
  }

  void _backPage() {
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

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
            Padding(
              padding: const EdgeInsets.only(bottom: 32),
              child: Center(
                child: QrImageView(
                  data: jsonEncode({
                    "id": ctrl.currentUser!.id!,
                    "name": ctrl.currentUser!.name,
                  }),
                  version: QrVersions.auto,
                  size: 250.0,
                  gapless: false,
                  backgroundColor: colorScheme.onSurface,
                  dataModuleStyle: QrDataModuleStyle(
                    dataModuleShape: QrDataModuleShape.circle,
                    color: colorScheme.onTertiary,
                  ),
                ),
              ),
            ),
            FilledButton.tonalIcon(
              label: const Text('Fechar'),
              icon: const Icon(Icons.close),
              onPressed: store.toogleShowQRCode,
            ),
          ],
        );
      }),
    );
  }
}
