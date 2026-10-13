import 'package:dio/dio.dart';

class ApiResponse<T extends Object?> {
  final T data;
  final int statusCode;
  final bool success;
  final String message;

  ApiResponse({
    required this.data,
    required this.statusCode,
    required this.success,
    required this.message,
  });

  factory ApiResponse.fromResponse(Response response) {
    Map<String, dynamic> data = response.data;
    int statusCode = data['status_code'] ?? response.statusCode ?? 0;
    bool success = statusCode >= 200 && statusCode < 300;

    String responseMessage = "";
    final rawMessage = data['message'];
    if (rawMessage is String) {
      responseMessage = rawMessage;
    } else if (rawMessage is List && rawMessage.isNotEmpty) {
      responseMessage = rawMessage.first as String;
    }

    return ApiResponse<T>(
      data: data['data'] as T,
      statusCode: statusCode,
      success: success,
      message: responseMessage,
    );
  }
}
