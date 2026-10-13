import 'dart:typed_data';

import 'package:injectable/injectable.dart';
import 'package:printing/printing.dart';

import 'pdf_template.dart';

abstract interface class PdfExportService {
  /// Genera y comparte (WhatsApp, correo, etc.) el PDF.
  Future<void> exportDocument<T>({
    required T data,
    required String filename,
    required PdfTemplate<T> template,
  });

  /// Abre el diálogo nativo de impresión.
  Future<void> printDocument<T>({
    required T data,
    required String filename,
    required PdfTemplate<T> template,
  });

  /// Devuelve los bytes del PDF.
  Future<Uint8List> generateDocumentBytes<T>({
    required T data,
    required PdfTemplate<T> template,
  });
}

@LazySingleton(as: PdfExportService)
final class PdfExportServiceImpl implements PdfExportService {
  @override
  Future<Uint8List> generateDocumentBytes<T>({
    required T data,
    required PdfTemplate<T> template,
  }) async {
    final pdf = await template.generate(data);
    return pdf.save();
  }

  @override
  Future<void> exportDocument<T>({
    required T data,
    required String filename,
    required PdfTemplate<T> template,
  }) async {
    final bytes = await generateDocumentBytes(data: data, template: template);
    await Printing.sharePdf(bytes: bytes, filename: filename);
  }

  @override
  Future<void> printDocument<T>({
    required T data,
    required String filename,
    required PdfTemplate<T> template,
  }) async {
    final bytes = await generateDocumentBytes(data: data, template: template);
    await Printing.layoutPdf(name: filename, onLayout: (_) async => bytes);
  }
}
