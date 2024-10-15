import 'dart:ui';

import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:pdf/widgets.dart' as pw;
import 'dart:typed_data';

import '../../common/models/delivery.dart';

class DeliveryQrcodeController {
  Future<Uint8List> _generatePdf(DeliveryModel delivery) async {
    final pdf = pw.Document();

    // Generate QRCode
    final qrPainter = QrPainter(
      data: delivery.id!,
      version: QrVersions.auto,
      gapless: false,
    );

    // Render the QRCode to an image
    final qrImage = await qrPainter.toImageData(
      250,
      format: ImageByteFormat.png,
    );
    final qrBytes = qrImage!.buffer.asUint8List();

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Column(
            mainAxisAlignment: pw.MainAxisAlignment.center,
            children: [
              pw.Image(pw.MemoryImage(qrBytes), width: 200, height: 200),
              pw.SizedBox(height: 12),
              pw.Text('Código: ${delivery.id!}'),
              pw.Text('Cliente: ${delivery.clientName}'),
            ],
          );
        },
      ),
    );

    return pdf.save();
  }

  void printQRCode(DeliveryModel delivery) {
    Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => _generatePdf(delivery),
    );
  }
}
