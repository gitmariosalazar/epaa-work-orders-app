import 'package:injectable/injectable.dart';
import 'dart:convert';
import 'package:clean_architecture/core/services/api/api_service.dart';
import 'package:clean_architecture/features/reading/data/model/create_reading_request.dart';
import 'package:clean_architecture/features/reading/data/model/reading_basic_info_response.dart';
import 'package:clean_architecture/features/reading/data/model/reading_info_response.dart';
import 'package:clean_architecture/features/reading/data/model/reading_response.dart';
import 'package:clean_architecture/features/reading/data/model/update_reading_request.dart';
import 'package:dio/dio.dart';

class ServerException implements Exception {
  final String message;
  final int? statusCode;
  ServerException(this.message, [this.statusCode]);
  @override
  String toString() => message;
}

abstract class RemoteReadingDataSource {
  Future<List<ReadingInfoResponse>> getReadingInfo(String cadastralKey);
  Future<List<ReadingBasicInfoResponse>> findBasicReading(String catastralCode);
  Future<ReadingResponse> updateCurrentReading(
    String readingId,
    UpdateReadingRequest request,
  );
  Future<ReadingResponse> createReading(CreateReadingRequest request);
}

@LazySingleton(as: RemoteReadingDataSource)
class RemoteReadingDataSourceImpl implements RemoteReadingDataSource {
  final ApiService apiService;

  RemoteReadingDataSourceImpl({required this.apiService});

  void _checkHttpStatus(int statusCode, dynamic errorBody) {
    if (statusCode == 401) {
      throw ServerException(
        'Sesión expirada. Por favor, inicie sesión de nuevo.',
        401,
      );
    }
    if (statusCode >= 400) {
      String errorMessage = 'Error del servidor ($statusCode)';
      try {
        if (errorBody is Map<String, dynamic> && errorBody.containsKey('message')) {
          if (errorBody['message'] is List) {
            errorMessage = (errorBody['message'] as List).join(', ');
          } else {
            errorMessage = errorBody['message'].toString();
          }
        }
      } catch (_) {}
      throw ServerException(errorMessage, statusCode);
    }
  }

  @override
  Future<List<ReadingInfoResponse>> getReadingInfo(String cadastralKey) async {
    try {
      final response = await apiService.get(
        '/Readings/find-reading-info/$cadastralKey',
      );

      final json = response.data as Map<String, dynamic>;

      if (json.isEmpty) {
        throw ServerException('Respuesta vacía del servidor');
      }

      final rawData = json['data'];
      if (rawData == null) {
        throw ServerException('No se encontró lectura para $cadastralKey');
      }

      List<ReadingInfoResponse> results = [];
      if (rawData is List) {
        results = rawData
            .map((e) => ReadingInfoResponse.fromJson(e as Map<String, dynamic>))
            .toList();
      } else if (rawData is Map<String, dynamic>) {
        results = [ReadingInfoResponse.fromJson(rawData)];
      } else {
        throw ServerException('Formato de datos de lectura desconocido');
      }

      if (results.isEmpty) {
        throw ServerException('No se encontró lectura para $cadastralKey');
      }
      return results;
    } on DioException catch (e) {
      _checkHttpStatus(e.response?.statusCode ?? 500, e.response?.data);
      throw ServerException(e.message ?? 'Unknown error');
    }
  }

  @override
  Future<List<ReadingBasicInfoResponse>> findBasicReading(
    String catastralCode,
  ) async {
    try {
      final response = await apiService.get(
        '/Readings/find-basic-reading/$catastralCode',
      );

      final json = response.data as Map<String, dynamic>;
      final rawData = json['data'];
      if (rawData == null) {
        return [];
      }

      List<ReadingBasicInfoResponse> results = [];
      if (rawData is List) {
        results = rawData
            .map((e) => ReadingBasicInfoResponse.fromJson(e as Map<String, dynamic>))
            .toList();
      } else if (rawData is Map<String, dynamic>) {
        results = [ReadingBasicInfoResponse.fromJson(rawData)];
      } else {
        throw ServerException('Formato de datos de lectura básico desconocido');
      }

      return results;
    } on DioException catch (e) {
      _checkHttpStatus(e.response?.statusCode ?? 500, e.response?.data);
      throw ServerException(e.message ?? 'Unknown error');
    }
  }

  @override
  Future<ReadingResponse> updateCurrentReading(
    String readingId,
    UpdateReadingRequest request,
  ) async {
    try {
      final response = await apiService.put(
        '/Readings/update-current-reading/$readingId',
        data: request.toJson(),
      );

      final json = response.data as Map<String, dynamic>;
      final data = json['data'];
      if (data is List) {
        if (data.isEmpty) throw ServerException('Empty response data');
        return ReadingResponse.fromJson(data.first as Map<String, dynamic>);
      } else if (data is Map<String, dynamic>) {
        return ReadingResponse.fromJson(data);
      } else {
        throw ServerException(json['message']?.toString() ?? 'Update failed');
      }
    } on DioException catch (e) {
      _checkHttpStatus(e.response?.statusCode ?? 500, e.response?.data);
      throw ServerException(e.message ?? 'Unknown error');
    }
  }

  @override
  Future<ReadingResponse> createReading(CreateReadingRequest request) async {
    try {
      final response = await apiService.post(
        '/Readings/create-reading',
        data: request.toJson(),
      );

      final json = response.data as Map<String, dynamic>;
      final data = json['data'];
      if (data is List) {
        if (data.isEmpty) throw ServerException('Empty response data');
        return ReadingResponse.fromJson(data.first as Map<String, dynamic>);
      } else if (data is Map<String, dynamic>) {
        return ReadingResponse.fromJson(data);
      } else {
        throw ServerException(json['message']?.toString() ?? 'Create failed');
      }
    } on DioException catch (e) {
      _checkHttpStatus(e.response?.statusCode ?? 500, e.response?.data);
      throw ServerException(e.message ?? 'Unknown error');
    }
  }
}
