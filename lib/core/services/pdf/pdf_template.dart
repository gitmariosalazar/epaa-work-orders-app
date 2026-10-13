import 'package:pdf/widgets.dart' as pw;

/// Contrato base para generar plantillas PDF de cualquier entidad <T> (OCP).
abstract interface class PdfTemplate<T> {
  Future<pw.Document> generate(T data);
}
