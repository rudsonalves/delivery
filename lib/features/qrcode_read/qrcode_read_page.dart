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

  late final MobileScannerController controller;

  StreamSubscription<BarcodeCapture>? _subscription;

  @override
  void initState() {
    super.initState();

    controller = MobileScannerController(
      autoStart: false,
      returnImage: true,
      detectionSpeed: DetectionSpeed.noDuplicates,
    );

    // Start listening to lifecycle changes.
    WidgetsBinding.instance.addObserver(this);

    // Start listening to the barcode events.
    _subscription = controller.barcodes.listen(_onDetect);
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
        isScanning = false; // Stop detection after the first scan
        controller.stop(); // Stop the camera
        log('Scanner stopped after detecting QR Code.');

        try {
          data = jsonDecode(code) as Map<String, dynamic>;
        } catch (err) {
          log('_onDetect Error: $err');
        }
      });

      break; // Only process the first detected QR Code
    }
  }

  void _backPage() {
    Navigator.pop(context, data);
  }

  @override
  void dispose() {
    log('Disposing the QRCodeReadPage');
    // Stop listening to lifecycle changes.
    WidgetsBinding.instance.removeObserver(this);
    // Stop listening to the barcode events.
    _subscription?.cancel();
    _subscription = null;
    // Dispose the widget itself.
    super.dispose();
    log('Leaving the page');
    // Stop the scanner if it's still running.
    controller.stop();
    log('Scanner explicitly stopped in dispose.');
    // Finally, dispose of the controller.
    controller.dispose();
    log('Controller disposed.');
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // If the controller is not ready, do not try to start or stop it.
    // Permission dialogs can trigger lifecycle changes before the controller is ready.
    if (!controller.value.isInitialized) {
      return;
    }

    switch (state) {
      case AppLifecycleState.resumed:
        // Restart the scanner when the app is resumed.
        if (isScanning) {
          unawaited(controller.start());
          log('Scanner started on resume.');
        }
        break;
      case AppLifecycleState.inactive:
      case AppLifecycleState.paused:
        // Stop the scanner when the app is paused.
        unawaited(controller.stop());
        log('Scanner stopped on pause or inactive state.');
        break;
      case AppLifecycleState.detached:
      case AppLifecycleState.hidden:
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
                            'Usuário: ${data?['name'] ?? 'Desculpe. Ocorreu um erro!'}',
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
