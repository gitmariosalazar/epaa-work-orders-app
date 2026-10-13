import 'dart:typed_data';
import 'package:clean_architecture/core/utils/type_defs.dart';
import '../entities/uploaded_document.dart';

abstract interface class DocumentRepository {
  FutureData<UploadedDocument> uploadDocument({
    required Uint8List fileBytes,
    required String filename,
    required String codigoTipoDocumento,
    required String entityType,
    required String entityId,
    String? nivelAcceso,
    List<String>? rolesPermitidos,
    Map<String, dynamic>? metadatosExtras,
  });
}
