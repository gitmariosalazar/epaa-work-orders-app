import 'package:clean_architecture/core/constants/api_endpoints.dart';
import 'package:clean_architecture/core/data_handling/data_handler.dart';
import 'package:clean_architecture/core/services/api/api_service.dart';
import 'package:clean_architecture/core/utils/type_defs.dart';
import 'package:clean_architecture/features/work-orders/data/models/models/add_material_work_order_response.dart';
import 'package:injectable/injectable.dart';

abstract interface class AddMaterialWorkOrderRemoteDatasource {
  FutureData<List<AddMaterialWorkOrderModel>> addMaterialToWorkOrders(
    List<AddMaterialWorkOrderModel> materials,
  );
}

@LazySingleton(as: AddMaterialWorkOrderRemoteDatasource)
class AddMaterialWorkOrderRemoteDatasourceImpl
    implements AddMaterialWorkOrderRemoteDatasource {
  final ApiService _apiService;
  const AddMaterialWorkOrderRemoteDatasourceImpl({
    required ApiService apiService,
  }) : _apiService = apiService;

  @override
  FutureData<List<AddMaterialWorkOrderModel>> addMaterialToWorkOrders(
    List<AddMaterialWorkOrderModel> materials,
  ) {
    // Implementa la llamada a la API para agregar materiales a la orden de trabajo
    return DataHandler.safeApiCall<
      List<AddMaterialWorkOrderModel>,
      AddMaterialWorkOrderModel
    >(
      request: () => _apiService.post(
        ApiEndpoints.addMaterialWorkOrders,
        data: materials.map((e) => e.toJson()).toList(),
      ),
      fromJson: (json) => AddMaterialWorkOrderModel.fromJson(json),
      isStandardResponse: true,
      responseDataKey: 'data',
    );
  }
}
