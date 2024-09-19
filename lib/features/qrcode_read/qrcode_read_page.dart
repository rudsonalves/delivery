import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

import '/common/theme/app_text_style.dart';
import '/components/widgets/big_bottom.dart';

class QRCodeReadPage extends StatefulWidget {
  const QRCodeReadPage({super.key});

  static const routeName = '/qrcode_read';

  @override
  State<QRCodeReadPage> createState() => _QRCodeReadPageState();
}

class _QRCodeReadPageState extends State<QRCodeReadPage> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? controller;
  Map<String, dynamic>? data;

  // Para lidar com hot reload
  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller?.pauseCamera();
    }
    controller?.resumeCamera();
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      if (mounted) {
        setState(() {
          // Opcional: Parar a câmera após escanear
          controller.pauseCamera();

          try {
            data = jsonDecode(scanData.code!) as Map<String, dynamic>;
          } catch (err) {
            log('_onQRViewCreated Error: $err');
          }
        });
      }
    });
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  void _backPage() {
    Navigator.pop(context, data);
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
            child: QRView(
              key: qrKey,
              onQRViewCreated: _onQRViewCreated,
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
