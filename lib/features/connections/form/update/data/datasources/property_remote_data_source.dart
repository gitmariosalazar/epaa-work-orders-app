import 'package:clean_architecture/core/services/api/api_service.dart';
import 'package:clean_architecture/features/connections/form/update/data/models/dto/request/update_property_request.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

@LazySingleton()
class PropertyRemoteDataSource {
  final ApiService apiService;

  PropertyRemoteDataSource(this.apiService);

  Future<void> updateProperty({
    required String cadastralKey,
    required UpdatePropertyRequest request,
  }) async {
    try {
      await apiService.put(
        '/properties/update-property/$cadastralKey',
        data: request.toJson(),
      );
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw Exception('Token no autorizado');
      }
      throw Exception('Failed to update property: ${e.response?.data}');
    } catch (e) {
      throw Exception('Error updating property: $e');
    }
  }
}
