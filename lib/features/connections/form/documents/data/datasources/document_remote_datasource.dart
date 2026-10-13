import 'dart:convert';
import 'package:clean_architecture/core/services/api/api_service.dart';
import 'package:clean_architecture/core/utils/type_defs.dart';
import 'package:clean_architecture/core/data_handling/data_handler.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import '../models/uploaded_document_model.dart';
import 'package:http_parser/http_parser.dart';

abstract interface class DocumentRemoteDataSource {
  FutureData<UploadedDocumentModel> uploadDocument({
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

@LazySingleton(as: DocumentRemoteDataSource)
class DocumentRemoteDataSourceImpl implements DocumentRemoteDataSource {
  final ApiService apiService;

  DocumentRemoteDataSourceImpl(this.apiService);

  @override
  FutureData<UploadedDocumentModel> uploadDocument({
    required Uint8List fileBytes,
    required String filename,
    required String codigoTipoDocumento,
    required String entityType,
    required String entityId,
    String? nivelAcceso,
    List<String>? rolesPermitidos,
    Map<String, dynamic>? metadatosExtras,
  }) {
    final mimeType = filename.endsWith('.pdf') ? 'application/pdf' : 'image/jpeg';
    
    final formDataMap = <String, dynamic>{
      'file': MultipartFile.fromBytes(
        fileBytes,
        filename: filename,
        contentType: MediaType.parse(mimeType),
      ),
      'codigoTipoDocumento': codigoTipoDocumento,
      'entityType': entityType,
      'entityId': entityId,
    };

    if (nivelAcceso != null) {
      formDataMap['nivelAcceso'] = nivelAcceso;
    }
    if (rolesPermitidos != null && rolesPermitidos.isNotEmpty) {
      formDataMap['rolesPermitidos'] = jsonEncode(rolesPermitidos);
    }
    if (metadatosExtras != null && metadatosExtras.isNotEmpty) {
      formDataMap['metadatosExtras'] = jsonEncode(metadatosExtras);
    }

    final formData = FormData.fromMap(formDataMap);

    return DataHandler.safeApiCall<UploadedDocumentModel, UploadedDocumentModel>(
      request: () => apiService.post(
        '/Documents/upload',
        data: formData,
      ),
      fromJson: (json) => UploadedDocumentModel.fromJson(json),
      isStandardResponse: true,
      responseDataKey: 'data',
    );
  }
}
