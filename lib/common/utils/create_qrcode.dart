import 'dart:convert';
import 'dart:typed_data';
import 'dart:ui';

import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:pdf/widgets.dart' as pw;

import '../models/delivery.dart';
import '../models/delivery_info.dart';

class CreateQrcode {
  CreateQrcode._();

  static Future<Uint8List> generatePdfFromDeliveryInfo(
    DeliveryInfoModel delivery,
  ) async {
    final pdf = pw.Document();

    // Generate QRCode
    final qrBytes = await _generateQRCode({'id': delivery.id});
    if (qrBytes == null) {
      throw Exception('QRCode generation error');
    }

    const fontStyle = pw.TextStyle(fontSize: 16);

    pdf.addPage(
      pw.Page(
        pageFormat: const PdfPageFormat(350, 450),
        build: (pw.Context context) {
          return pw.Center(
            child: pw.Column(
              mainAxisAlignment: pw.MainAxisAlignment.center,
              children: [
                pw.Image(pw.MemoryImage(qrBytes), width: 300, height: 300),
                pw.SizedBox(height: 12),
                pw.SizedBox(
                  width: 250,
                  child: pw.Column(
                    mainAxisAlignment: pw.MainAxisAlignment.center,
                    children: [
                      pw.Text(
                        delivery.id,
                        textAlign: pw.TextAlign.center,
                        style: fontStyle.copyWith(
                          fontWeight: pw.FontWeight.bold,
                        ),
                      ),
                      pw.Text(
                        '${delivery.clientName}'
                        '\n${delivery.clientPhone}',
                        textAlign: pw.TextAlign.center,
                        style: fontStyle,
                      ),
                      pw.Text(
                        delivery.clientAddress.replaceAll('Avenida', 'Av.'),
                        textAlign: pw.TextAlign.center,
                        style: fontStyle,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );

    return pdf.save();
  }

  static Future<Uint8List?> _generateQRCode(Map<String, dynamic> map) async {
    final data = json.encode(map);
    final qrPainter = QrPainter(
      data: data,
      version: QrVersions.auto,
      gapless: true,
    );

    final imageData = await qrPainter.toImageData(
      250,
      format: ImageByteFormat.png,
    );

    return imageData?.buffer.asUint8List();
  }

  static Future<Uint8List> generatePdfFromDelivery(
    DeliveryModel delivery,
  ) async {
    return await generatePdfFromDeliveryInfo(
        DeliveryInfoModel.fromDelivery(delivery));
  }

  static void printQRCode(DeliveryModel delivery) {
    Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async =>
          generatePdfFromDelivery(delivery),
    );
  }
}
