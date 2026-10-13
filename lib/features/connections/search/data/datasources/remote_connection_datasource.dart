import 'package:clean_architecture/core/services/api/api_service.dart';
import 'package:clean_architecture/features/connections/search/data/model/schemas/dto/response/connection_response.dart';
import 'package:clean_architecture/features/connections/search/data/model/schemas/dto/response/property_with_client_response.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

abstract class RemoteConnectionDataSource {
  Future<List<ConnectionResponse>>
  getConnectionByCadastralKeyOrClientIdOrCardId(String searchValue);

  Future<List<PropertyWithClientResponse>>
  findPropertyWithClientByCadastralKeyOrCardIdOrLikeName(
    String searchValue, {
    int? limit,
    int? offset,
  });
}

@LazySingleton(as: RemoteConnectionDataSource)
class RemoteConnectionDataSourceImpl implements RemoteConnectionDataSource {
  final ApiService apiService;

  RemoteConnectionDataSourceImpl(this.apiService);

  @override
  Future<List<ConnectionResponse>>
  getConnectionByCadastralKeyOrClientIdOrCardId(String searchValue) async {
    try {
      final response = await apiService.get(
        '/connections/find-connection-by-cadastral-key-or-card-id/$searchValue',
      );

      final json = response.data as Map<String, dynamic>;

      if (json['status_code'] != null && (json['status_code'] < 200 || json['status_code'] >= 300)) {
        throw Exception(json['message']);
      }
      final rawData = json['data'];
      if (rawData == null) {
        throw Exception(
          'No se encontró conexión para la clave catastral: $searchValue',
        );
      }

      List<ConnectionResponse> connections = [];
      if (rawData is List) {
        connections = rawData
            .map((e) => ConnectionResponse.fromJson(e as Map<String, dynamic>))
            .toList();
      } else if (rawData is Map<String, dynamic>) {
        connections = [ConnectionResponse.fromJson(rawData)];
      } else {
        throw Exception('Formato de datos de conexión desconocido');
      }

      return connections;
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        throw Exception('No se encontró registro para el número de cédula/RUC o clave catastral: $searchValue');
      }
      throw Exception('Error al conectar con el servidor: ${e.message}');
    } catch (e) {
      throw Exception('Error parseando ConnectionResponse: $e');
    }
  }

  @override
  Future<List<PropertyWithClientResponse>>
  findPropertyWithClientByCadastralKeyOrCardIdOrLikeName(
    String searchValue, {
    int? limit,
    int? offset,
  }) async {
    try {
      final response = await apiService.get(
        '/connections/find-property-with-client-by-cadastral-key-or-card-id-or-like-name/$searchValue',
        queryParameters: {'limit': limit ?? 10, 'offset': offset ?? 0},
      );
      
      final json = response.data as Map<String, dynamic>;

      if (json['status_code'] != null && (json['status_code'] < 200 || json['status_code'] >= 300)) {
        throw Exception(json['message']);
      }
      final rawData = json['data'];

      if (rawData == null) {
        throw Exception(
          'No se encontró propiedad para el valor: $searchValue',
        );
      }

      List<PropertyWithClientResponse> properties = [];
      if (rawData is List) {
        properties = rawData
            .map((e) => PropertyWithClientResponse.fromJson(e as Map<String, dynamic>))
            .toList();
      } else if (rawData is Map<String, dynamic>) {
        properties = [PropertyWithClientResponse.fromJson(rawData)];
      } else {
        throw Exception('Formato de datos desconocido');
      }

      return properties;
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        throw Exception('No se encontró registro para el valor dado: $searchValue');
      }
      throw Exception('Error al conectar con el servidor: ${e.message}');
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
}
