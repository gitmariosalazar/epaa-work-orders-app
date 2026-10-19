import 'dart:typed_data';
import 'package:clean_architecture/core/utils/type_defs.dart';
import 'package:injectable/injectable.dart';
import '../datasources/document_remote_datasource.dart';
import '../../domain/entities/uploaded_document.dart';
import '../../domain/repositories/document_repository.dart';

@LazySingleton(as: DocumentRepository)
class DocumentRepositoryImpl implements DocumentRepository {
  final DocumentRemoteDataSource remoteDataSource;

  DocumentRepositoryImpl(this.remoteDataSource);

  @override
  FutureData<UploadedDocument> uploadDocument({
    required Uint8List fileBytes,
    required String filename,
    required String codigoTipoDocumento,
    required String entityType,
    required String entityId,
    String? nivelAcceso,
    List<String>? rolesPermitidos,
    Map<String, dynamic>? metadatosExtras,
  }) async {
    return await remoteDataSource.uploadDocument(
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
