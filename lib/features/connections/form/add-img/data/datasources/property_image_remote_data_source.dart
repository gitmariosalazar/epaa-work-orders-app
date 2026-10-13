import 'dart:io';
import 'package:clean_architecture/core/utils/type_defs.dart';
import 'package:clean_architecture/core/data_handling/data_handler.dart';
import 'package:clean_architecture/core/services/api/api_service.dart';
import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mime/mime.dart' as mime;
import 'package:http_parser/http_parser.dart';
import 'package:injectable/injectable.dart';
import '../../domain/entities/photo_connection.dart';

abstract class PropertyImageRemoteDataSource {
  FutureData<List<PhotoConnection>> addPropertyImages({
    required String connectionId,
    required List<XFile> images,
    String? description,
  });
}

@LazySingleton(as: PropertyImageRemoteDataSource)
class PropertyImageRemoteDataSourceImpl implements PropertyImageRemoteDataSource {
  final ApiService apiService;

  PropertyImageRemoteDataSourceImpl(this.apiService);

  @override
  FutureData<List<PhotoConnection>> addPropertyImages({
    required String connectionId,
    required List<XFile> images,
    String? description,
  }) async {
    final formDataMap = <String, dynamic>{
      'connectionId': connectionId,
    };

    if (description != null && description.trim().isNotEmpty) {
      formDataMap['description'] = description.trim();
    }

    final multipartFiles = <MultipartFile>[];
    for (final image in images) {
      final file = File(image.path);
      final fileName = image.path.split('/').last;
      final mimeType = mime.lookupMimeType(fileName) ?? 'image/jpeg';
      
      multipartFiles.add(
        await MultipartFile.fromFile(
          file.path,
          filename: fileName,
          contentType: MediaType.parse(mimeType),
        )
      );
    }
    
    formDataMap['images'] = multipartFiles;
    final formData = FormData.fromMap(formDataMap);

    return DataHandler.safeApiCall<List<PhotoConnection>, PhotoConnection>(
      request: () => apiService.post(
        '/photo-connection/create-photo-connection',
        data: formData,
      ),
      fromJson: (json) => PhotoConnection.fromJson(json),
      isStandardResponse: true,
      responseDataKey: 'data',
    );
  }
}
