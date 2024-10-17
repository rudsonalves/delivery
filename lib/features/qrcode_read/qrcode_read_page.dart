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
import 'dart:developer';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '/common/theme/app_text_style.dart';

class QRCodeReadPage extends StatefulWidget {
  const QRCodeReadPage({super.key});

  static const routeName = '/qrcode_read';

  @override
  State<QRCodeReadPage> createState() => _QRCodeReadPageState();
}

class _QRCodeReadPageState extends State<QRCodeReadPage>
    with WidgetsBindingObserver {
  Map<String, dynamic>? data;
  bool isScanning = false;

  late final MobileScannerController controller = MobileScannerController(
    autoStart: false,
    torchEnabled: false,
    useNewCameraSelector: true,
    returnImage: true,
  );

  StreamSubscription<Object?>? _subscription;

  @override
  void initState() {
    super.initState();

    // Start listening to lifecycle changes.
    WidgetsBinding.instance.addObserver(this);

    // Start listening to the barcode events.
    _subscription = controller.barcodes.listen(_onDetect);

    _startScanning();
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
        isScanning = false;
        controller.stop();
        log('Scanner stopped after detecting QR Code.');

        try {
          data = jsonDecode(code) as Map<String, dynamic>;
        } catch (err) {
          log('_onDetect Error: $err');
        }
      });

      break;
    }
  }

  void _backPage() {
    Navigator.pop(context, data);
  }

  @override
  Future<void> dispose() async {
    WidgetsBinding.instance.removeObserver(this);
    unawaited(_subscription?.cancel());
    _subscription = null;
    super.dispose();
    await controller.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (!controller.value.hasCameraPermission) {
      log('You don\'t have camera controller permissions.');
      return;
    }

    switch (state) {
      case AppLifecycleState.detached:
      case AppLifecycleState.hidden:
      case AppLifecycleState.paused:
        log('Scan is paused, hidden or detached');
        return;
      case AppLifecycleState.resumed:
        _subscription = controller.barcodes.listen(_onDetect);
        unawaited(controller.start());
        log('Scanner started on resume.');
        break;
      case AppLifecycleState.inactive:
        unawaited(_subscription?.cancel());
        _subscription = null;
        unawaited(controller.stop());
        log('Scanner stopped on pause or inactive state.');
        break;
    }
  }

  Future<void> _startScanning() async {
    setState(() {
      isScanning = true;
      data = null;
    });
    await controller.start();
    log('Scanner started by user action.');
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Ler QR Code'),
        leading: IconButton(
          onPressed: _backPage,
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
        ),
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          if (isScanning)
            MobileScanner(
              fit: BoxFit.contain,
              controller: controller,
              onDetect: _onDetect,
            ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: (data != null)
                    ? Column(
                        children: [
                          Text(
                            data!.containsKey('name')
                                ? 'Usuário: ${data!['name']}'
                                : 'id : ${data!['id']}',
                            style: AppTextStyle.font15Bold(),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 26),
                            child: QrImageView(
                              data: jsonEncode(data),
                              version: QrVersions.auto,
                              size: 200.0,
                              gapless: false,
                              backgroundColor: colorScheme.onPrimaryContainer,
                            ),
                          ),
                        ],
                      )
                    : Column(
                        children: [
                          Container(
                            height: 250,
                            width: 250,
                            decoration: BoxDecoration(
                              color: Colors.transparent,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.white),
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text(
                              'Gere o QRCode no aparelho do gerente,\ne escaneie o QRCode.',
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
              ),
              OverflowBar(
                alignment: MainAxisAlignment.spaceAround,
                children: [
                  FilledButton.icon(
                    onPressed: _backPage,
                    label: const Text('Retornar'),
                    icon: const Icon(Icons.arrow_back_ios_new_rounded),
                  ),
                  if (!isScanning)
                    FilledButton.icon(
                      onPressed: _startScanning,
                      label: const Text('Scannear'),
                      icon: const Icon(Icons.qr_code_2_rounded),
                    ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
