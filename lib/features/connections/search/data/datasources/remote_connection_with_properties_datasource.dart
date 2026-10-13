import 'package:clean_architecture/core/services/api/api_service.dart';
import 'package:clean_architecture/features/connections/search/data/model/schemas/dto/response/connection_with_properties_response.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

abstract class RemoteConnectionWithPropertiesDataSource {
  Future<ConnectionWithPropertiesResponse> getConnectionWithProperties(String cadastralKey);
}

@LazySingleton(as: RemoteConnectionWithPropertiesDataSource)
class RemoteConnectionWithPropertiesDataSourceImpl implements RemoteConnectionWithPropertiesDataSource {
  final ApiService apiService;

  RemoteConnectionWithPropertiesDataSourceImpl(this.apiService);

  @override
  Future<ConnectionWithPropertiesResponse> getConnectionWithProperties(String cadastralKey) async {
    try {
      final response = await apiService.get(
        '/connections/find-connection-with-property-by-cadastral-key/$cadastralKey',
      );
      final json = response.data as Map<String, dynamic>;

      if (json['status_code'] != null && (json['status_code'] < 200 || json['status_code'] >= 300)) {
        final msg = json['message'];
        final message = msg is List ? msg.join(', ') : (msg ?? 'Error al obtener predio');
        throw Exception(message);
      }

      final rawData = json['data'];
      if (rawData == null) {
        throw Exception('No se encontró información del predio para la clave: $cadastralKey');
      }

      return ConnectionWithPropertiesResponse.fromJson(rawData as Map<String, dynamic>);
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        throw Exception('No se encontró predio para la clave catastral: $cadastralKey');
      }
      final serverMsg = e.response?.data is Map ? e.response?.data['message'] : null;
      if (serverMsg != null) {
        throw Exception(serverMsg is List ? serverMsg.join(', ') : serverMsg);
      }
      throw Exception('Error de red (${e.response?.statusCode ?? 'sin conexión'}): ${e.message}');
    } catch (e) {
      throw Exception(e.toString().replaceAll('Exception: ', ''));
    }
  }
}
