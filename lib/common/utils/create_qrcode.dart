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
    final qrBytes = await _generateQRCode(delivery.id);
    if (qrBytes == null) {
      throw Exception('QRCode generation error');
    }

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Column(
            mainAxisAlignment: pw.MainAxisAlignment.center,
            children: [
              pw.Image(pw.MemoryImage(qrBytes), width: 200, height: 200),
              pw.SizedBox(height: 12),
              pw.Text('Código: ${delivery.id}'),
              pw.Text('Cliente: ${delivery.clientName}'
                  ' (${delivery.clientPhone})'),
              pw.Text(delivery.clientAddress),
            ],
          );
        },
      ),
    );

    return pdf.save();
  }

  static Future<Uint8List?> _generateQRCode(String doc) async {
    final qrPainter = QrPainter(
      data: doc,
      version: QrVersions.auto,
      gapless: false,
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
