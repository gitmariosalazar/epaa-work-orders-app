import 'dart:convert';
import 'package:clean_architecture/core/services/api/api_service.dart';
import 'package:clean_architecture/features/connections/form/update/data/models/dto/request/update_connection_request.dart';
import 'package:clean_architecture/features/connections/form/update/data/models/dto/request/change_meter_request.dart';
import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart';
import 'package:injectable/injectable.dart';

@LazySingleton()
class ConnectionRemoteDataSource {
  final ApiService apiService;

  ConnectionRemoteDataSource(this.apiService);

  Future<void> updateConnection({
    required String connectionId,
    required UpdateConnectionRequest request,
  }) async {
    try {
      await apiService.put(
        '/connections/update-connection/$connectionId',
        data: request.toJson(),
      );
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw Exception('Token no autorizado');
      }
      throw Exception('Failed to update connection: ${e.response?.data}');
    } catch (e) {
      throw Exception('Error updating connection: $e');
    }
  }

  Future<void> changeMeter({
    required ChangeMeterRequest request,
  }) async {
    try {
      final formData = FormData();

      formData.fields.add(MapEntry(
        'changeDetail',
        jsonEncode(request.changeDetail.toJson()),
      ));

      if (request.imageDescriptions.isNotEmpty) {
        formData.fields.add(MapEntry(
          'imageDescriptions',
          jsonEncode(request.imageDescriptions),
        ));
      }

      for (var file in request.images) {
        final extension = file.path.split('.').last.toLowerCase();
        String contentTypeStr = 'image/jpeg';
        
        switch (extension) {
          case 'png':
            contentTypeStr = 'image/png';
            break;
          case 'webp':
            contentTypeStr = 'image/webp';
            break;
          case 'gif':
            contentTypeStr = 'image/gif';
            break;
        }

        formData.files.add(MapEntry(
          'images',
          await MultipartFile.fromFile(
            file.path,
            filename: file.path.split('/').last,
            contentType: MediaType.parse(contentTypeStr),
          ),
        ));
      }

      await apiService.post(
        '/connections/change-meter/${request.connectionId}',
        data: formData,
      );
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw Exception('Token no autorizado');
      }
      throw Exception('Failed to change meter: ${e.response?.data}');
    } catch (e) {
      throw Exception('Error changing meter: $e');
    }
  }
}
