import 'package:clean_architecture/core/constants/api_endpoints.dart';
import 'package:clean_architecture/core/data_handling/data_handler.dart';
import 'package:clean_architecture/core/services/api/api_service.dart';
import 'package:clean_architecture/core/utils/type_defs.dart';
import 'package:clean_architecture/features/products/data/models/product_material_model.dart';
import 'package:injectable/injectable.dart';

abstract interface class ProductMaterialRemoteDatasource {
  FutureData<List<ProductMaterialModel>> getAllProductMaterials();
}

@LazySingleton(as: ProductMaterialRemoteDatasource)
class ProductMaterialRemoteDatasourceImpl
    implements ProductMaterialRemoteDatasource {
  final ApiService _apiService;
  const ProductMaterialRemoteDatasourceImpl({required ApiService apiService})
    : _apiService = apiService;

  @override
  FutureData<List<ProductMaterialModel>> getAllProductMaterials() {
    return DataHandler.safeApiCall<
      List<ProductMaterialModel>,
      ProductMaterialModel
    >(
      request: () => _apiService.get(ApiEndpoints.getAllProductsMaterials),
      fromJson: (json) => ProductMaterialModel.fromJson(json),
      isStandardResponse: true,
      responseDataKey: 'data',
    );
  }
}

abstract interface class ProductMaterialPaginatedRemoteDatasource {
  FutureData<List<ProductMaterialModel>> getAllProductMaterialsPaginated({
    required int limit,
    required int offset,
    required String? query,
  });
}

@LazySingleton(as: ProductMaterialPaginatedRemoteDatasource)
class ProductMaterialPaginatedRemoteDatasourceImpl
    implements ProductMaterialPaginatedRemoteDatasource {
  final ApiService _apiService;
  const ProductMaterialPaginatedRemoteDatasourceImpl({
    required ApiService apiService,
  }) : _apiService = apiService;
  @override
  FutureData<List<ProductMaterialModel>> getAllProductMaterialsPaginated({
    required int limit,
    required int offset,
    required String? query,
  }) {
    final queryParameters = <String, dynamic>{};
    queryParameters['limit'] = limit;
    queryParameters['offset'] = offset;
    if (query != null && query.isNotEmpty) {
      queryParameters['query'] = query;
    }
    return DataHandler.safeApiCall<
      List<ProductMaterialModel>,
      ProductMaterialModel
    >(
      request: () => _apiService.get(
        ApiEndpoints.getAllProductsMaterialsPaginated,
        queryParameters: queryParameters,
      ),
      fromJson: (json) => ProductMaterialModel.fromJson(json),
      isStandardResponse: true,
      responseDataKey: 'data',
    );
  }
}
