import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import '/common/theme/app_text_style.dart';
import '/components/widgets/big_bottom.dart';

class QRCodeReadPage extends StatefulWidget {
  const QRCodeReadPage({super.key});

  static const routeName = '/qrcode_read';

  @override
  State<QRCodeReadPage> createState() => _QRCodeReadPageState();
}

class _QRCodeReadPageState extends State<QRCodeReadPage> {
  Map<String, dynamic>? data;
  bool isScanning = true;

  MobileScannerController controller = MobileScannerController();

  void _backPage() {
    Navigator.pop(context, data);
  }

  void _onDetect(BarcodeCapture barcodeCapture) {
    if (!mounted || !isScanning) return;

    for (final barcode in barcodeCapture.barcodes) {
      final String? code = barcode.rawValue;
      if (code == null) {
        log('QR Code vazio');
        continue;
      }

      setState(() {
        isScanning = false; // Parar a detecção após o primeiro scan
        controller.stop(); // Parar a câmera

        try {
          data = jsonDecode(code) as Map<String, dynamic>;
        } catch (err) {
          log('_onDetect Error: $err');
        }
      });

      break; // Apenas processar o primeiro QR Code detectado
    }
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ler QR Code'),
        leading: IconButton(
          onPressed: _backPage,
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Expanded(
            flex: 4,
            child: MobileScanner(
              controller: controller,
              onDetect: _onDetect,
              // allowDuplicates: false,
              // Configurações adicionais, se necessário
            ),
          ),
          Expanded(
            flex: 1,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                  child: (data != null)
                      ? Text(
                          'Usuário: ${data?['name'] ?? 'Desculpe. Ocorreu um erro!'}',
                          style: AppTextStyle.font15Bold(),
                        )
                      : const Text(
                          'Gere o QRCode no aparelho do gerente,\ne escaneie o QRCode.',
                        ),
                ),
                if (data != null)
                  BigButton(
                    color: Colors.greenAccent,
                    label: 'Retornar',
                    onPressed: _backPage,
                  ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
