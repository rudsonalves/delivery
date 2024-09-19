import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'package:qr_flutter/qr_flutter.dart';

import 'account_controller.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({super.key});

  static const routeName = '/account';

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  final ctrl = AccountController();

  @override
  void initState() {
    super.initState();
    ctrl.init();
  }

  void _backPage() {
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
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
        if (!ctrl.showQRCode) {
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                IconButton(
                  onPressed: ctrl.toogleShowQRCode,
                  icon: const Icon(
                    Symbols.qr_code_scanner_rounded,
                    size: 80,
                  ),
                ),
              ],
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
                  backgroundColor: Colors.white,
                  dataModuleStyle: const QrDataModuleStyle(
                    dataModuleShape: QrDataModuleShape.circle,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
            FilledButton.tonalIcon(
              label: const Text('Fechar'),
              icon: const Icon(Icons.close),
              onPressed: ctrl.toogleShowQRCode,
            ),
          ],
        );
      }),
    );
  }
}
