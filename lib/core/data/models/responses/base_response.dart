import 'package:clean_architecture/core/utils/type_defs.dart';

class BaseResponse<T> {
  final int statusCode;
  final String time;
  final List<String> message;
  final String url;
  final T? data;

  BaseResponse({
    required this.statusCode,
    required this.time,
    required this.message,
    required this.url,
    this.data,
  });

  factory BaseResponse.fromJson(
    MapDynamic json,
    T? Function(dynamic json) fromJsonT,
  ) {
    return BaseResponse<T>(
      statusCode: json['status_code'] ?? 0,
      time: json['time'] ?? "",
      message: List<String>.from(json['message'] ?? []),
      url: json['url'] ?? "",
      data: json['data'] != null ? fromJsonT(json['data']) : null,
    );
  }
}
