// features/work-orders/data/datasources/remote/work_orders_remote_datasource.dart

import 'package:clean_architecture/core/constants/api_endpoints.dart';
import 'package:clean_architecture/core/data_handling/data_handler.dart';
import 'package:clean_architecture/core/services/api/api_service.dart';
import 'package:clean_architecture/core/utils/type_defs.dart';
import 'package:clean_architecture/features/work-orders/data/models/models/work_order_response.dart';
import 'package:injectable/injectable.dart';

abstract interface class WorkOrdersRemoteDataSource {
  FutureData<List<WorkOrderModel>> getAllWorkOrders();
  FutureData<WorkOrderModel> createWorkOrder(WorkOrderModel order);
}

@LazySingleton(as: WorkOrdersRemoteDataSource)
class WorkOrdersRemoteDataSourceImpl implements WorkOrdersRemoteDataSource {
  final ApiService _apiService;

  const WorkOrdersRemoteDataSourceImpl({required ApiService apiService})
    : _apiService = apiService;

  @override
  FutureData<List<WorkOrderModel>> getAllWorkOrders() {
    return DataHandler.safeApiCall<List<WorkOrderModel>, WorkOrderModel>(
      request: () => _apiService.get(ApiEndpoints.getAllWorkOrders),
      fromJson: (json) => WorkOrderModel.fromJson(json),
      isStandardResponse: true,
      responseDataKey: 'data',
    );
  }

  @override
  FutureData<WorkOrderModel> createWorkOrder(WorkOrderModel order) {
    return DataHandler.safeApiCall<WorkOrderModel, WorkOrderModel>(
      request: () => _apiService.post(
        ApiEndpoints
            .createWorkOrder, // ← define esta constante: "work-orders/create"
        data: order.toJson(),
      ),
      fromJson: (json) => WorkOrderModel.fromJson(json),
      isStandardResponse: true,
      responseDataKey: 'data',
    );
  }
}
