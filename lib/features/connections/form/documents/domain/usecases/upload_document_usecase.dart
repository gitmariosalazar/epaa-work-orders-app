import 'dart:typed_data';
import 'package:clean_architecture/core/utils/type_defs.dart';
import 'package:injectable/injectable.dart';
import '../entities/uploaded_document.dart';
import '../repositories/document_repository.dart';

@lazySingleton
class UploadDocumentUseCase {
  final DocumentRepository repository;

  UploadDocumentUseCase(this.repository);

  FutureData<UploadedDocument> call({
    required Uint8List fileBytes,
    required String filename,
    required String codigoTipoDocumento,
    required String entityType,
    required String entityId,
    String? nivelAcceso,
    List<String>? rolesPermitidos,
    Map<String, dynamic>? metadatosExtras,
  }) {
    return repository.uploadDocument(
      fileBytes: fileBytes,
      filename: filename,
      codigoTipoDocumento: codigoTipoDocumento,
      entityType: entityType,
      entityId: entityId,
      nivelAcceso: nivelAcceso,
      rolesPermitidos: rolesPermitidos,
      metadatosExtras: metadatosExtras,
    );
  }
}
