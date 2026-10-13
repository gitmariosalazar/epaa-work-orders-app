import 'package:clean_architecture/core/services/api/api_service.dart';
import 'package:clean_architecture/features/connections/form/update/data/models/dto/request/update_customer_request.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

@LazySingleton()
class CustomerRemoteDataSource {
  final ApiService apiService;

  CustomerRemoteDataSource(this.apiService);

  Future<void> updateCustomer({
    required String customerId,
    required UpdateCustomerRequest request,
  }) async {
    try {
      final data = request.toJson()..['customerId'] = int.tryParse(customerId) ?? 0;
      
      await apiService.put(
        '/Customers/update-customer/$customerId',
        data: data,
      );
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw Exception('Token no autorizado');
      }
      throw Exception('Failed to update customer: ${e.response?.data}');
    } catch (e) {
      throw Exception('Error updating customer: $e');
    }
  }
}
