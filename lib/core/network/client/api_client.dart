// core/network/api_client.dart
import 'package:clean_architecture/core/network/response/api_response.dart';
import 'package:dio/dio.dart';

class ApiClient {
  final Dio dio;

  ApiClient(this.dio);

  Future<ApiResponse<T>> request<T>({
    required String path,
    String method = 'GET',
    Map<String, dynamic>? queryParameters,
    dynamic data,
    required T Function(dynamic) fromJsonT,
  }) async {
    try {
      final response = await dio.request(
        path,
        data: data,
        queryParameters: queryParameters,
        options: Options(method: method),
      );

      return ApiResponse.fromJson(
        response.data as Map<String, dynamic>,
        fromJsonT,
      );
    } on DioException catch (e) {
      if (e.response?.data != null) {
        return ApiResponse.fromJson(
          e.response!.data as Map<String, dynamic>,
          fromJsonT,
        );
      }
      rethrow;
    }
  }
}
