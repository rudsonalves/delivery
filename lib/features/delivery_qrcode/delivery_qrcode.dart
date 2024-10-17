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

import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../common/utils/create_qrcode.dart';
import '/common/theme/app_text_style.dart';
import '../../common/models/delivery.dart';

class DeliveryQrcode extends StatelessWidget {
  final DeliveryModel delivery;

  const DeliveryQrcode(
    this.delivery, {
    super.key,
  });

  static const routeName = '/deliver_qrcode';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('QRCode da Entrega'),
        centerTitle: true,
        leading: IconButton(
          onPressed: Navigator.of(context).pop,
          icon: const Icon(Icons.arrow_back_ios_rounded),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              decoration: BoxDecoration(
                border: Border.all(),
              ),
              child: QrImageView(
                data: delivery.id!,
                version: QrVersions.auto,
                size: 250.0,
                gapless: false,
                backgroundColor: Colors.white,
                eyeStyle: const QrEyeStyle(
                  eyeShape: QrEyeShape.square,
                  color: Colors.black,
                ),
                dataModuleStyle: const QrDataModuleStyle(
                  dataModuleShape: QrDataModuleShape.circle,
                  color: Colors.black,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 12.0),
              child: Text(
                'Código: ${delivery.id!}',
                style: AppTextStyle.font18(),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 12.0),
              child: Text(
                'Cliente: ${delivery.clientName}',
                style: AppTextStyle.font18(),
              ),
            ),
            const SizedBox(height: 20),
            OverflowBar(
              alignment: MainAxisAlignment.spaceAround,
              children: [
                FilledButton.icon(
                  onPressed: () => CreateQrcode.printQRCode(delivery),
                  icon: const Icon(Icons.print_rounded),
                  label: const Text('Imprimir'),
                ),
                FilledButton.icon(
                  onPressed: Navigator.of(context).pop,
                  icon: const Icon(Icons.close),
                  label: const Text('Fechar'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
