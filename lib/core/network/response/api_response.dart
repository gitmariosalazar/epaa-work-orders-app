// core/network/api_response.dart o donde la tengas

class ApiResponse<T> {
  final int statusCode;
  final String time;
  final List<String> message;
  final String url;
  final T? data;

  ApiResponse({
    required this.statusCode,
    required this.time,
    required this.message,
    required this.url,
    this.data,
  });

  /// Factory constructor ESTÁTICO – esto es lo que permite llamar ApiResponse.fromJson<T>()
  factory ApiResponse.fromJson(
    Map<String, dynamic> json,
    T Function(dynamic) fromJsonT,
  ) {
    final dynamic rawData = json['data'];

    T? parsedData;
    if (rawData != null) {
      if (rawData is List) {
        parsedData = (rawData).map(fromJsonT).toList() as T;
      } else {
        parsedData = fromJsonT(rawData);
      }
    }

    return ApiResponse<T>(
      statusCode: json['status_code'] as int,
      time: json['time'] as String,
      message: List<String>.from(json['message'] ?? []),
      url: json['url'] as String,
      data: parsedData,
    );
  }
}
