import 'dart:convert';
import 'dart:developer';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '/common/theme/app_text_style.dart';
import '/components/widgets/big_bottom.dart';

class QRCodeReadPage extends StatefulWidget {
  const QRCodeReadPage({super.key});

  static const routeName = '/qrcode_read';

  @override
  State<QRCodeReadPage> createState() => _QRCodeReadPageState();
}

class _QRCodeReadPageState extends State<QRCodeReadPage>
    with WidgetsBindingObserver {
  Map<String, dynamic>? data;
  bool isScanning = true;

  final MobileScannerController controller = MobileScannerController(
    returnImage: true,
  );
  StreamSubscription<BarcodeCapture>? _subscription;

  @override
  void initState() {
    super.initState();
    // Start listening to lifecycle changes.
    WidgetsBinding.instance.addObserver(this);

    // Start listening to the barcode events.
    _subscription = controller.barcodes.listen(_onDetect);

    // Finally, start the scanner itself.
    unawaited(controller.start());
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

  void _backPage() {
    Navigator.pop(context, data);
  }

  @override
  void dispose() {
    // Stop listening to lifecycle changes.
    WidgetsBinding.instance.removeObserver(this);
    // Stop listening to the barcode events.
    unawaited(_subscription?.cancel());
    _subscription = null;
    // Dispose the widget itself.
    super.dispose();
    // Finally, dispose of the controller.
    controller.dispose();
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
        // Don't forget to resume listening to the barcode events.
        _subscription = controller.barcodes.listen(_onDetect);
        unawaited(controller.start());
        break;
      case AppLifecycleState.inactive:
        // Stop the scanner when the app is paused.
        // Also stop the barcode events subscription.
        unawaited(_subscription?.cancel());
        _subscription = null;
        unawaited(controller.stop());
        break;
      case AppLifecycleState.detached:
      case AppLifecycleState.hidden:
      case AppLifecycleState.paused:
        // _barcodeSubscription?.cancel();
        // controller.stop();
        break;
    }
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
      body: Column(
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
    );
  }
}
