import 'dart:developer';
import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:printing/printing.dart';

import '../../common/models/delivery_info.dart';
import '/common/utils/create_qrcode.dart';

class ShowQrcode extends StatefulWidget {
  final dynamic delivery;

  const ShowQrcode(
    this.delivery, {
    super.key,
  });

  static const routeName = '/show_qrcode';

  @override
  State<ShowQrcode> createState() => _ShowQrcodeState();
}

class _ShowQrcodeState extends State<ShowQrcode> {
  void _backPage() {
    Navigator.pop(context);
  }

  Future<Uint8List?> convertPdfToImage(dynamic delivery) async {
    try {
      // Inicializa o raster e processa a primeira página como exemplo
      final pdfData = (delivery is DeliveryInfoModel)
          ? await CreateQrcode.generatePdfFromDeliveryInfo(delivery)
          : await CreateQrcode.generatePdfFromDelivery(delivery);
      final stream = Printing.raster(
        pdfData,
        pages: [0], // Aqui você pode especificar outras páginas, se necessário.
        dpi: 100, // Define a resolução da imagem
      );

      await for (final PdfRaster page in stream) {
        // Converte PdfRaster para Uint8List (imagem PNG)
        final pngBytes = await page.toImage();
        final byteData = await pngBytes.toByteData(format: ImageByteFormat.png);
        return byteData?.buffer
            .asUint8List(); // Retorna a imagem da primeira página
      }
    } catch (e) {
      log('Error converting PDF to image: $e');
      return null;
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('QRCode'),
        centerTitle: true,
        leading: IconButton(
          onPressed: _backPage,
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FutureBuilder<Uint8List?>(
            future: convertPdfToImage(widget.delivery),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError || !snapshot.hasData) {
                return const Center(
                  child: Text('Erro ao converter PDF para imagem'),
                );
              } else {
                return Padding(
                  padding: const EdgeInsets.all(8),
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: Colors.black,
                    ),
                    child: Center(
                      child: Image.memory(
                        color: Colors.white,
                        snapshot.data!,
                        fit: BoxFit.fitWidth,
                      ),
                    ),
                  ),
                );
              }
            },
          ),
          const SizedBox(height: 20),
          FilledButton(
            onPressed: _backPage,
            child: const Text('Próximo'),
          ),
        ],
      ),
    );
  }
}
