import 'package:clean_architecture/core/services/api/api_service.dart';
import 'package:clean_architecture/features/connections/form/update/data/models/dto/request/create_observation_request.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

@LazySingleton()
class ObservationConnectionRemoteDataSource {
  final ApiService apiService;

  ObservationConnectionRemoteDataSource(this.apiService);

  Future<void> addObservationConnection({
    required CreateObservationRequest request,
  }) async {
    try {
      await apiService.post(
        '/observation-connection/create-observation-connection',
        data: request.toJson(),
      );
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw Exception('Token no autorizado');
      }
      throw Exception('Failed to create observation connection: ${e.response?.data}');
    } catch (e) {
      throw Exception('Error creating observation connection: $e');
    }
  }
}
