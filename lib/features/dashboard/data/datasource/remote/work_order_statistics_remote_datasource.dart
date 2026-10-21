// features/dashboard/data/datasource/remote/work_order_statistics_remote_datasource.dart

import 'package:clean_architecture/core/constants/api_endpoints.dart';
import 'package:clean_architecture/core/data_handling/data_handler.dart';
import 'package:clean_architecture/core/services/api/api_service.dart';
import 'package:clean_architecture/core/utils/type_defs.dart';
import 'package:clean_architecture/features/dashboard/data/models/work_order_statistics_models.dart';
import 'package:injectable/injectable.dart';

abstract interface class WorkOrderStatisticsRemoteDataSource {
  FutureData<List<WorkOrderPriorityStatisticModel>> getPriorityStatistics();
  FutureData<List<WorkOrderStatusStatisticModel>> getStatusStatistics();
  FutureData<List<WorkOrderTypeStatisticModel>> getTypeStatistics();
  FutureData<List<WorkOrdersKeyStatisticModel>> getKeyStatistics();
}

@LazySingleton(as: WorkOrderStatisticsRemoteDataSource)
class WorkOrderStatisticsRemoteDataSourceImpl
    implements WorkOrderStatisticsRemoteDataSource {
  final ApiService _apiService;

  const WorkOrderStatisticsRemoteDataSourceImpl({
    required ApiService apiService,
  }) : _apiService = apiService;

  /// Única implementación de la llamada GET de lista estándar (DRY).
  FutureData<List<M>> _getList<M>(
    String endpoint,
    M Function(Map<String, dynamic> json) fromJson,
  ) {
    return DataHandler.safeApiCall<List<M>, M>(
      request: () => _apiService.get(endpoint),
      fromJson: fromJson,
      isStandardResponse: true,
      responseDataKey: 'data',
    );
  }

  @override
  FutureData<List<WorkOrderPriorityStatisticModel>> getPriorityStatistics() =>
      _getList(
        ApiEndpoints.getWorkOrderPriorityStatistics,
        WorkOrderPriorityStatisticModel.fromJson,
      );

  @override
  FutureData<List<WorkOrderStatusStatisticModel>> getStatusStatistics() =>
      _getList(
        ApiEndpoints.getWorkOrderStatusStatistics,
        WorkOrderStatusStatisticModel.fromJson,
      );

  @override
  FutureData<List<WorkOrderTypeStatisticModel>> getTypeStatistics() => _getList(
    ApiEndpoints.getWorkOrderTypeStatistics,
    WorkOrderTypeStatisticModel.fromJson,
  );

  @override
  FutureData<List<WorkOrdersKeyStatisticModel>> getKeyStatistics() => _getList(
    ApiEndpoints.getWorkOrdersStatisticsKey,
    WorkOrdersKeyStatisticModel.fromJson,
  );
}
