import 'package:clean_architecture/core/services/api/api_service.dart';
import 'package:clean_architecture/features/connections/form/update/data/models/dto/request/update_company_request.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

@LazySingleton()
class CompanyRemoteDataSource {
  final ApiService apiService;

  CompanyRemoteDataSource(this.apiService);

  Future<void> updateCompany({
    required String companyRuc,
    required UpdateCompanyRequest request,
  }) async {
    try {
      final data = request.toJson()..['companyRuc'] = companyRuc;
      await apiService.put(
        '/Customers/update-company/$companyRuc',
        data: data,
      );
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw Exception('Token no autorizado');
      }
      throw Exception('Failed to update company: ${e.response?.data}');
    } catch (e) {
      throw Exception('Error updating company: $e');
    }
  }
}
