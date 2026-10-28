import 'package:clean_architecture/features/work-orders/data/models/requests/process_work_order_requests.dart';
import 'package:clean_architecture/features/work-orders/domain/params/create_work_order_from_incident_params.dart';
// features/work-orders/data/datasources/remote/work_orders_remote_datasource.dart

import 'package:clean_architecture/core/constants/api_endpoints.dart';
import 'package:clean_architecture/core/data_handling/data_handler.dart';
import 'package:clean_architecture/core/services/api/api_service.dart';
import 'package:clean_architecture/core/utils/type_defs.dart';
import 'package:clean_architecture/features/work-orders/data/models/models/work_order_detail_model.dart';
import 'package:clean_architecture/features/work-orders/data/models/models/work_order_response.dart';
import 'package:clean_architecture/features/work-orders/data/models/models/work_order_tracking_model.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

abstract interface class WorkOrdersRemoteDataSource {
  FutureData<List<WorkOrderModel>> getAllWorkOrders({
    String? searchValue,
    int? limit,
    int? offset,
  });
  FutureData<WorkOrderModel> createWorkOrder(WorkOrderModel order);

  FutureData<void> createWorkOrderFromIncident(
    CreateWorkOrderFromIncidentParams request,
  );
  FutureData<void> receiveWorkOrder(dynamic request);
  FutureData<void> assignWorkOrderToCrew(dynamic request);
  FutureData<void> assignWorkOrderToWorker(dynamic request);
  FutureData<void> startPreparation(dynamic request);
  FutureData<void> createPreparationInspection(dynamic request);
  FutureData<void> addPreparationInspectionDetail(dynamic request);
  FutureData<void> resolvePreparationInspection(dynamic request);
  FutureData<void> startExecution(dynamic request);
  FutureData<void> addWorkOrderMaterial(dynamic request);
  FutureData<void> addWorkOrderMaterialsBatch(dynamic request);
  FutureData<void> addAdditionalCost(dynamic request);
  FutureData<void> addAdditionalCostsBatch(dynamic request);
  FutureData<void> finishExecution(dynamic request);
  FutureData<void> createQualityControl(dynamic request);
  FutureData<void> addQualityControlDetail(dynamic request);
  FutureData<void> resolveQualityControl(dynamic request);
  FutureData<void> completeWorkOrder(dynamic request);
  FutureData<void> registerSatisfactionSurvey(dynamic request);
  FutureData<void> addWorkerToWorkOrder(dynamic request);
  FutureData<void> addWorkersBatchToWorkOrder(dynamic request);
  FutureData<void> removeWorkerFromWorkOrder(dynamic request);
  FutureData<void> advanceWorkOrderState(dynamic request);
  FutureData<WorkOrderDetailModel> getDetalleByNumeroOrden(String numeroOrden);
  FutureData<WorkOrderTrackingModel> getTrackingByNumeroOrden(String id);
  FutureData<List<WorkOrderModel>> getOrdenesBySolicitudId(String solicitudId);
  FutureData<void> addWorkOrderAttachment(
    String workOrderId,
    List<String> filePaths, {
    String? createdByUserId,
    String? evidenceStageCode,
  });
  FutureData<List<DepartmentModel>> getDepartments();
}

@LazySingleton(as: WorkOrdersRemoteDataSource)
class WorkOrdersRemoteDataSourceImpl implements WorkOrdersRemoteDataSource {
  final ApiService _apiService;

  const WorkOrdersRemoteDataSourceImpl({required ApiService apiService})
    : _apiService = apiService;

  @override
  FutureData<List<WorkOrderModel>> getAllWorkOrders({
    String? searchValue,
    int? limit,
    int? offset,
  }) {
    return DataHandler.safeApiCall<List<WorkOrderModel>, WorkOrderModel>(
      request: () => _apiService.get(
        ApiEndpoints.getAllWorkOrders,
        queryParameters: {
          if (searchValue != null && searchValue.trim().isNotEmpty)
            'searchValue': searchValue.trim(),
          if (limit != null) 'limit': limit,
          if (offset != null) 'offset': offset,
        },
      ),
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

  @override
  FutureData<void> createWorkOrderFromIncident(
    CreateWorkOrderFromIncidentParams request,
  ) {
    return DataHandler.safeApiCall<void, void>(
      request: () => _apiService.post(
        ApiEndpoints.createWorkOrderFromIncident,
        data: CreateWorkOrderFromIncidentRequest.fromParams(request).toJson(),
      ),
      fromJson: (_) {},
      isStandardResponse: true,
      responseDataKey: 'data',
    );
  }

  @override
  FutureData<void> receiveWorkOrder(dynamic request) {
    return DataHandler.safeApiCall<void, void>(
      request: () => _apiService.post(
        ApiEndpoints.receiveWorkOrder,
        data: request.toJson(),
      ),
      fromJson: (_) {},
      isStandardResponse: true,
      responseDataKey: 'data',
    );
  }

  @override
  FutureData<void> assignWorkOrderToCrew(dynamic request) {
    return DataHandler.safeApiCall<void, void>(
      request: () => _apiService.post(
        ApiEndpoints.assignWorkOrderToCrew,
        data: request.toJson(),
      ),
      fromJson: (_) {},
      isStandardResponse: true,
      responseDataKey: 'data',
    );
  }

  @override
  FutureData<void> assignWorkOrderToWorker(dynamic request) {
    return DataHandler.safeApiCall<void, void>(
      request: () => _apiService.post(
        ApiEndpoints.assignWorkOrderToWorker,
        data: request.toJson(),
      ),
      fromJson: (_) {},
      isStandardResponse: true,
      responseDataKey: 'data',
    );
  }

  @override
  FutureData<void> startPreparation(dynamic request) {
    return DataHandler.safeApiCall<void, void>(
      request: () => _apiService.post(
        ApiEndpoints.startPreparation,
        data: request.toJson(),
      ),
      fromJson: (_) {},
      isStandardResponse: true,
      responseDataKey: 'data',
    );
  }

  @override
  FutureData<void> createPreparationInspection(dynamic request) {
    return DataHandler.safeApiCall<void, void>(
      request: () => _apiService.post(
        ApiEndpoints.createPreparationInspection,
        data: request.toJson(),
      ),
      fromJson: (_) {},
      isStandardResponse: true,
      responseDataKey: 'data',
    );
  }

  @override
  FutureData<void> addPreparationInspectionDetail(dynamic request) {
    return DataHandler.safeApiCall<void, void>(
      request: () => _apiService.post(
        ApiEndpoints.addPreparationInspectionDetail,
        data: request.toJson(),
      ),
      fromJson: (_) {},
      isStandardResponse: true,
      responseDataKey: 'data',
    );
  }

  @override
  FutureData<void> resolvePreparationInspection(dynamic request) {
    return DataHandler.safeApiCall<void, void>(
      request: () => _apiService.post(
        ApiEndpoints.resolvePreparationInspection,
        data: request.toJson(),
      ),
      fromJson: (_) {},
      isStandardResponse: true,
      responseDataKey: 'data',
    );
  }

  @override
  FutureData<void> startExecution(dynamic request) {
    return DataHandler.safeApiCall<void, void>(
      request: () =>
          _apiService.post(ApiEndpoints.startExecution, data: request.toJson()),
      fromJson: (_) {},
      isStandardResponse: true,
      responseDataKey: 'data',
    );
  }

  @override
  FutureData<void> addWorkOrderMaterial(dynamic request) {
    return DataHandler.safeApiCall<void, void>(
      request: () => _apiService.post(
        ApiEndpoints.addWorkOrderMaterial,
        data: request.toJson(),
      ),
      fromJson: (_) {},
      isStandardResponse: true,
      responseDataKey: 'data',
    );
  }

  @override
  FutureData<void> addWorkOrderMaterialsBatch(dynamic request) {
    return DataHandler.safeApiCall<void, void>(
      request: () => _apiService.post(
        ApiEndpoints.addWorkOrderMaterialsBatch,
        data: request.toJson(),
      ),
      fromJson: (_) {},
      isStandardResponse: true,
      responseDataKey: 'data',
    );
  }

  @override
  FutureData<void> addAdditionalCost(dynamic request) {
    return DataHandler.safeApiCall<void, void>(
      request: () => _apiService.post(
        ApiEndpoints.addAdditionalCost,
        data: request.toJson(),
      ),
      fromJson: (_) {},
      isStandardResponse: true,
      responseDataKey: 'data',
    );
  }

  @override
  FutureData<void> addAdditionalCostsBatch(dynamic request) {
    return DataHandler.safeApiCall<void, void>(
      request: () => _apiService.post(
        ApiEndpoints.addAdditionalCostsBatch,
        data: request.toJson(),
      ),
      fromJson: (_) {},
      isStandardResponse: true,
      responseDataKey: 'data',
    );
  }

  @override
  FutureData<void> finishExecution(dynamic request) {
    return DataHandler.safeApiCall<void, void>(
      request: () => _apiService.post(
        ApiEndpoints.finishExecution,
        data: request.toJson(),
      ),
      fromJson: (_) {},
      isStandardResponse: true,
      responseDataKey: 'data',
    );
  }

  @override
  FutureData<void> createQualityControl(dynamic request) {
    return DataHandler.safeApiCall<void, void>(
      request: () => _apiService.post(
        ApiEndpoints.createQualityControl,
        data: request.toJson(),
      ),
      fromJson: (_) {},
      isStandardResponse: true,
      responseDataKey: 'data',
    );
  }

  @override
  FutureData<void> addQualityControlDetail(dynamic request) {
    return DataHandler.safeApiCall<void, void>(
      request: () => _apiService.post(
        ApiEndpoints.addQualityControlDetail,
        data: request.toJson(),
      ),
      fromJson: (_) {},
      isStandardResponse: true,
      responseDataKey: 'data',
    );
  }

  @override
  FutureData<void> resolveQualityControl(dynamic request) {
    return DataHandler.safeApiCall<void, void>(
      request: () => _apiService.post(
        ApiEndpoints.resolveQualityControl,
        data: request.toJson(),
      ),
      fromJson: (_) {},
      isStandardResponse: true,
      responseDataKey: 'data',
    );
  }

  @override
  FutureData<void> completeWorkOrder(dynamic request) {
    return DataHandler.safeApiCall<void, void>(
      request: () => _apiService.post(
        ApiEndpoints.completeWorkOrder,
        data: request.toJson(),
      ),
      fromJson: (_) {},
      isStandardResponse: true,
      responseDataKey: 'data',
    );
  }

  @override
  FutureData<void> registerSatisfactionSurvey(dynamic request) {
    return DataHandler.safeApiCall<void, void>(
      request: () => _apiService.post(
        ApiEndpoints.registerSatisfactionSurvey,
        data: request.toJson(),
      ),
      fromJson: (_) {},
      isStandardResponse: true,
      responseDataKey: 'data',
    );
  }

  @override
  FutureData<void> addWorkerToWorkOrder(dynamic request) {
    return DataHandler.safeApiCall<void, void>(
      request: () => _apiService.post(
        ApiEndpoints.addWorkerToWorkOrder,
        data: request.toJson(),
      ),
      fromJson: (_) {},
      isStandardResponse: true,
      responseDataKey: 'data',
    );
  }

  @override
  FutureData<void> addWorkersBatchToWorkOrder(dynamic request) {
    return DataHandler.safeApiCall<void, void>(
      request: () => _apiService.post(
        ApiEndpoints.addWorkersBatchToWorkOrder,
        data: request.toJson(),
      ),
      fromJson: (_) {},
      isStandardResponse: true,
      responseDataKey: 'data',
    );
  }

  @override
  FutureData<void> removeWorkerFromWorkOrder(dynamic request) {
    return DataHandler.safeApiCall<void, void>(
      request: () => _apiService.post(
        ApiEndpoints.removeWorkerFromWorkOrder,
        data: request.toJson(),
      ),
      fromJson: (_) {},
      isStandardResponse: true,
      responseDataKey: 'data',
    );
  }

  @override
  FutureData<void> advanceWorkOrderState(dynamic request) {
    return DataHandler.safeApiCall<void, void>(
      request: () => _apiService.post(
        ApiEndpoints.advanceWorkOrderState,
        data: request.toJson(),
      ),
      fromJson: (_) {},
      isStandardResponse: true,
      responseDataKey: 'data',
    );
  }

  @override
  FutureData<WorkOrderDetailModel> getDetalleByNumeroOrden(String numeroOrden) {
    return DataHandler.safeApiCall<WorkOrderDetailModel, WorkOrderDetailModel>(
      request: () => _apiService.get(
        ApiEndpoints.getDetalleByNumeroOrden,
        queryParameters: {'numeroOrden': numeroOrden},
      ),
      fromJson: (json) => WorkOrderDetailModel.fromJson(json),
      isStandardResponse: true,
      responseDataKey: 'data',
    );
  }

  @override
  FutureData<WorkOrderTrackingModel> getTrackingByNumeroOrden(String id) {
    return DataHandler.safeApiCall<
      WorkOrderTrackingModel,
      WorkOrderTrackingModel
    >(
      request: () => _apiService.get(
        ApiEndpoints.getTrackingByNumeroOrden,
        queryParameters: {'searchValue': id},
      ),
      fromJson: (json) => WorkOrderTrackingModel.fromJson(json),
      isStandardResponse: true,
      responseDataKey: 'data',
    );
  }

  @override
  FutureData<List<WorkOrderModel>> getOrdenesBySolicitudId(String solicitudId) {
    return DataHandler.safeApiCall<List<WorkOrderModel>, WorkOrderModel>(
      request: () => _apiService.get(
        ApiEndpoints.getOrdenesBySolicitudId,
        queryParameters: {'solicitudId': solicitudId},
      ),
      fromJson: (json) => WorkOrderModel.fromJson(json),
      isStandardResponse: true,
      responseDataKey: 'data',
    );
  }

  @override
  FutureData<void> addWorkOrderAttachment(
    String workOrderId,
    List<String> filePaths, {
    String? createdByUserId,
    String? evidenceStageCode,
  }) async {
    final formData = FormData();
    formData.fields.add(MapEntry('workOrderId', workOrderId));
    if (createdByUserId != null && createdByUserId.isNotEmpty) {
      formData.fields.add(MapEntry('createdByUserId', createdByUserId));
    }
    if (evidenceStageCode != null && evidenceStageCode.isNotEmpty) {
      formData.fields.add(MapEntry('evidenceStageCode', evidenceStageCode));
    }
    for (final path in filePaths) {
      final fileName = path.split('/').last;
      formData.files.add(
        MapEntry(
          'files',
          await MultipartFile.fromFile(path, filename: fileName),
        ),
      );
    }
    return DataHandler.safeApiCall<void, void>(
      request: () => _apiService.post(
        ApiEndpoints.processAddWorkOrderAttachment,
        data: formData,
      ),
      fromJson: (_) {},
      isStandardResponse: true,
      responseDataKey: 'data',
    );
  }

  @override
  FutureData<List<DepartmentModel>> getDepartments() {
    return DataHandler.safeApiCall<List<DepartmentModel>, DepartmentModel>(
      request: () => _apiService.get(ApiEndpoints.getAllDepartments),
      fromJson: (json) => DepartmentModel.fromJson(json),
      isStandardResponse: true,
      responseDataKey: 'data',
    );
  }
}
