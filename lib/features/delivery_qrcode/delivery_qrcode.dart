import 'package:delivery/common/theme/app_text_style.dart';
import 'package:delivery/features/delivery_qrcode/delivery_qrcode_controller.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../common/models/delivery.dart';

class DeliveryQrcode extends StatelessWidget {
  final DeliveryModel delivery;

  DeliveryQrcode(
    this.delivery, {
    super.key,
  });

  static const routeName = '/deliver_qrcode';

  final ctrl = DeliveryQrcodeController();

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
                  onPressed: () => ctrl.printQRCode(delivery),
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
