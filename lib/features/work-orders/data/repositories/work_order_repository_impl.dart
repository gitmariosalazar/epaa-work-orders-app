import 'package:clean_architecture/features/work-orders/domain/params/create_work_order_from_incident_params.dart';
// features/work-orders/data/repositories/work_order_repository_impl.dart

import 'package:clean_architecture/core/data_handling/data_handler.dart';
import 'package:clean_architecture/core/services/internet/internet_service.dart';
import 'package:clean_architecture/core/utils/type_defs.dart';
import 'package:clean_architecture/features/work-orders/data/datasource/remote/work_orders_remote_datasource.dart';
import 'package:clean_architecture/features/work-orders/data/models/models/work_order_detail_model.dart';
import 'package:clean_architecture/features/work-orders/data/models/models/work_order_response.dart';
import 'package:clean_architecture/features/work-orders/data/models/models/work_order_tracking_model.dart';
import 'package:clean_architecture/features/work-orders/domain/entities/work_order_detail_entity.dart';
import 'package:clean_architecture/features/work-orders/domain/entities/work_order_entity.dart';
import 'package:clean_architecture/features/work-orders/domain/entities/work_order_tracking_entity.dart';
import 'package:clean_architecture/features/work-orders/domain/repositories/work_order_repository.dart';
import 'package:injectable/injectable.dart';
import 'package:clean_architecture/core/data_states/data_state.dart';

@LazySingleton(as: WorkOrderRepository)
class WorkOrderRepositoryImpl implements WorkOrderRepository {
  final InternetService _internet;
  final WorkOrdersRemoteDataSource _remoteDataSource;

  WorkOrderRepositoryImpl({
    required InternetService internet,
    required WorkOrdersRemoteDataSource remoteDataSource,
  }) : _internet = internet,
       _remoteDataSource = remoteDataSource;

  @override
  FutureData<List<WorkOrderEntity>> getAllWorkOrders({int? limit, int? offset}) async {
    final result = await DataHandler.fetchWithFallback<List<WorkOrderModel>>(
      _internet.isConnected,
      remoteCallback: () => _remoteDataSource.getAllWorkOrders(limit: limit, offset: offset),
    );

    return result.when(
      success: (models) {
        final entities = models.map((model) => model.toEntity()).toList();
        return SuccessState<List<WorkOrderEntity>>(data: entities);
      },
      failure: (message, errorType) {
        return FailureState<List<WorkOrderEntity>>(
          message: message,
          errorType: errorType,
        );
      },
      loading: () {
        return LoadingState<List<WorkOrderEntity>>();
      },
    );
  }

  @override
  FutureData<WorkOrderEntity> createWorkOrder(WorkOrderEntity order) async {
    try {
      final model = WorkOrderModel.fromDomain(
        order,
      ); // necesitas este método en el model
      final result = await _remoteDataSource.createWorkOrder(model);

      return result.when(
        success: (createdModel) {
          final entity = createdModel.toEntity();
          return SuccessState<WorkOrderEntity>(data: entity);
        },
        failure: (message, errorType) {
          return FailureState<WorkOrderEntity>(
            message: message,
            errorType: errorType,
          );
        },
        loading: () {
          return LoadingState<WorkOrderEntity>();
        },
      );
    } catch (e) {
      return FailureState<WorkOrderEntity>(
        message: 'Unexpected error: $e',
        errorType: ErrorType.unknown,
      );
    }
  }

  @override
  FutureData<void> createWorkOrderFromIncident(CreateWorkOrderFromIncidentParams request) async {
    final result = await DataHandler.fetchWithFallback<void>(
      _internet.isConnected,
      remoteCallback: () =>
          _remoteDataSource.createWorkOrderFromIncident(request),
    );
    return result.when(
      success: (_) => SuccessState<void>(data: null),
      failure: (message, errorType) =>
          FailureState<void>(message: message, errorType: errorType),
      loading: () => LoadingState<void>(),
    );
  }

  @override
  FutureData<void> receiveWorkOrder(dynamic request) async {
    final result = await DataHandler.fetchWithFallback<void>(
      _internet.isConnected,
      remoteCallback: () => _remoteDataSource.receiveWorkOrder(request),
    );
    return result.when(
      success: (_) => SuccessState<void>(data: null),
      failure: (message, errorType) =>
          FailureState<void>(message: message, errorType: errorType),
      loading: () => LoadingState<void>(),
    );
  }

  @override
  FutureData<void> assignWorkOrderToCrew(dynamic request) async {
    final result = await DataHandler.fetchWithFallback<void>(
      _internet.isConnected,
      remoteCallback: () => _remoteDataSource.assignWorkOrderToCrew(request),
    );
    return result.when(
      success: (_) => SuccessState<void>(data: null),
      failure: (message, errorType) =>
          FailureState<void>(message: message, errorType: errorType),
      loading: () => LoadingState<void>(),
    );
  }

  @override
  FutureData<void> assignWorkOrderToWorker(dynamic request) async {
    final result = await DataHandler.fetchWithFallback<void>(
      _internet.isConnected,
      remoteCallback: () => _remoteDataSource.assignWorkOrderToWorker(request),
    );
    return result.when(
      success: (_) => SuccessState<void>(data: null),
      failure: (message, errorType) =>
          FailureState<void>(message: message, errorType: errorType),
      loading: () => LoadingState<void>(),
    );
  }

  @override
  FutureData<void> startPreparation(dynamic request) async {
    final result = await DataHandler.fetchWithFallback<void>(
      _internet.isConnected,
      remoteCallback: () => _remoteDataSource.startPreparation(request),
    );
    return result.when(
      success: (_) => SuccessState<void>(data: null),
      failure: (message, errorType) =>
          FailureState<void>(message: message, errorType: errorType),
      loading: () => LoadingState<void>(),
    );
  }

  @override
  FutureData<void> createPreparationInspection(dynamic request) async {
    final result = await DataHandler.fetchWithFallback<void>(
      _internet.isConnected,
      remoteCallback: () =>
          _remoteDataSource.createPreparationInspection(request),
    );
    return result.when(
      success: (_) => SuccessState<void>(data: null),
      failure: (message, errorType) =>
          FailureState<void>(message: message, errorType: errorType),
      loading: () => LoadingState<void>(),
    );
  }

  @override
  FutureData<void> addPreparationInspectionDetail(dynamic request) async {
    final result = await DataHandler.fetchWithFallback<void>(
      _internet.isConnected,
      remoteCallback: () =>
          _remoteDataSource.addPreparationInspectionDetail(request),
    );
    return result.when(
      success: (_) => SuccessState<void>(data: null),
      failure: (message, errorType) =>
          FailureState<void>(message: message, errorType: errorType),
      loading: () => LoadingState<void>(),
    );
  }

  @override
  FutureData<void> resolvePreparationInspection(dynamic request) async {
    final result = await DataHandler.fetchWithFallback<void>(
      _internet.isConnected,
      remoteCallback: () =>
          _remoteDataSource.resolvePreparationInspection(request),
    );
    return result.when(
      success: (_) => SuccessState<void>(data: null),
      failure: (message, errorType) =>
          FailureState<void>(message: message, errorType: errorType),
      loading: () => LoadingState<void>(),
    );
  }

  @override
  FutureData<void> startExecution(dynamic request) async {
    final result = await DataHandler.fetchWithFallback<void>(
      _internet.isConnected,
      remoteCallback: () => _remoteDataSource.startExecution(request),
    );
    return result.when(
      success: (_) => SuccessState<void>(data: null),
      failure: (message, errorType) =>
          FailureState<void>(message: message, errorType: errorType),
      loading: () => LoadingState<void>(),
    );
  }

  @override
  FutureData<void> addWorkOrderMaterial(dynamic request) async {
    final result = await DataHandler.fetchWithFallback<void>(
      _internet.isConnected,
      remoteCallback: () => _remoteDataSource.addWorkOrderMaterial(request),
    );
    return result.when(
      success: (_) => SuccessState<void>(data: null),
      failure: (message, errorType) =>
          FailureState<void>(message: message, errorType: errorType),
      loading: () => LoadingState<void>(),
    );
  }

  @override
  FutureData<void> addWorkOrderMaterialsBatch(dynamic request) async {
    final result = await DataHandler.fetchWithFallback<void>(
      _internet.isConnected,
      remoteCallback: () =>
          _remoteDataSource.addWorkOrderMaterialsBatch(request),
    );
    return result.when(
      success: (_) => SuccessState<void>(data: null),
      failure: (message, errorType) =>
          FailureState<void>(message: message, errorType: errorType),
      loading: () => LoadingState<void>(),
    );
  }

  @override
  FutureData<void> addAdditionalCost(dynamic request) async {
    final result = await DataHandler.fetchWithFallback<void>(
      _internet.isConnected,
      remoteCallback: () => _remoteDataSource.addAdditionalCost(request),
    );
    return result.when(
      success: (_) => SuccessState<void>(data: null),
      failure: (message, errorType) =>
          FailureState<void>(message: message, errorType: errorType),
      loading: () => LoadingState<void>(),
    );
  }

  @override
  FutureData<void> addAdditionalCostsBatch(dynamic request) async {
    final result = await DataHandler.fetchWithFallback<void>(
      _internet.isConnected,
      remoteCallback: () => _remoteDataSource.addAdditionalCostsBatch(request),
    );
    return result.when(
      success: (_) => SuccessState<void>(data: null),
      failure: (message, errorType) =>
          FailureState<void>(message: message, errorType: errorType),
      loading: () => LoadingState<void>(),
    );
  }

  @override
  FutureData<void> finishExecution(dynamic request) async {
    final result = await DataHandler.fetchWithFallback<void>(
      _internet.isConnected,
      remoteCallback: () => _remoteDataSource.finishExecution(request),
    );
    return result.when(
      success: (_) => SuccessState<void>(data: null),
      failure: (message, errorType) =>
          FailureState<void>(message: message, errorType: errorType),
      loading: () => LoadingState<void>(),
    );
  }

  @override
  FutureData<void> createQualityControl(dynamic request) async {
    final result = await DataHandler.fetchWithFallback<void>(
      _internet.isConnected,
      remoteCallback: () => _remoteDataSource.createQualityControl(request),
    );
    return result.when(
      success: (_) => SuccessState<void>(data: null),
      failure: (message, errorType) =>
          FailureState<void>(message: message, errorType: errorType),
      loading: () => LoadingState<void>(),
    );
  }

  @override
  FutureData<void> addQualityControlDetail(dynamic request) async {
    final result = await DataHandler.fetchWithFallback<void>(
      _internet.isConnected,
      remoteCallback: () => _remoteDataSource.addQualityControlDetail(request),
    );
    return result.when(
      success: (_) => SuccessState<void>(data: null),
      failure: (message, errorType) =>
          FailureState<void>(message: message, errorType: errorType),
      loading: () => LoadingState<void>(),
    );
  }

  @override
  FutureData<void> resolveQualityControl(dynamic request) async {
    final result = await DataHandler.fetchWithFallback<void>(
      _internet.isConnected,
      remoteCallback: () => _remoteDataSource.resolveQualityControl(request),
    );
    return result.when(
      success: (_) => SuccessState<void>(data: null),
      failure: (message, errorType) =>
          FailureState<void>(message: message, errorType: errorType),
      loading: () => LoadingState<void>(),
    );
  }

  @override
  FutureData<void> completeWorkOrder(dynamic request) async {
    final result = await DataHandler.fetchWithFallback<void>(
      _internet.isConnected,
      remoteCallback: () => _remoteDataSource.completeWorkOrder(request),
    );
    return result.when(
      success: (_) => SuccessState<void>(data: null),
      failure: (message, errorType) =>
          FailureState<void>(message: message, errorType: errorType),
      loading: () => LoadingState<void>(),
    );
  }

  @override
  FutureData<void> registerSatisfactionSurvey(dynamic request) async {
    final result = await DataHandler.fetchWithFallback<void>(
      _internet.isConnected,
      remoteCallback: () =>
          _remoteDataSource.registerSatisfactionSurvey(request),
    );
    return result.when(
      success: (_) => SuccessState<void>(data: null),
      failure: (message, errorType) =>
          FailureState<void>(message: message, errorType: errorType),
      loading: () => LoadingState<void>(),
    );
  }

  @override
  FutureData<void> addWorkerToWorkOrder(dynamic request) async {
    final result = await DataHandler.fetchWithFallback<void>(
      _internet.isConnected,
      remoteCallback: () => _remoteDataSource.addWorkerToWorkOrder(request),
    );
    return result.when(
      success: (_) => SuccessState<void>(data: null),
      failure: (message, errorType) =>
          FailureState<void>(message: message, errorType: errorType),
      loading: () => LoadingState<void>(),
    );
  }

  @override
  FutureData<void> addWorkersBatchToWorkOrder(dynamic request) async {
    final result = await DataHandler.fetchWithFallback<void>(
      _internet.isConnected,
      remoteCallback: () =>
          _remoteDataSource.addWorkersBatchToWorkOrder(request),
    );
    return result.when(
      success: (_) => SuccessState<void>(data: null),
      failure: (message, errorType) =>
          FailureState<void>(message: message, errorType: errorType),
      loading: () => LoadingState<void>(),
    );
  }

  @override
  FutureData<void> removeWorkerFromWorkOrder(dynamic request) async {
    final result = await DataHandler.fetchWithFallback<void>(
      _internet.isConnected,
      remoteCallback: () =>
          _remoteDataSource.removeWorkerFromWorkOrder(request),
    );
    return result.when(
      success: (_) => SuccessState<void>(data: null),
      failure: (message, errorType) =>
          FailureState<void>(message: message, errorType: errorType),
      loading: () => LoadingState<void>(),
    );
  }

  @override
  FutureData<void> advanceWorkOrderState(dynamic request) async {
    final result = await DataHandler.fetchWithFallback<void>(
      _internet.isConnected,
      remoteCallback: () => _remoteDataSource.advanceWorkOrderState(request),
    );
    return result.when(
      success: (_) => SuccessState<void>(data: null),
      failure: (message, errorType) =>
          FailureState<void>(message: message, errorType: errorType),
      loading: () => LoadingState<void>(),
    );
  }

  @override
  FutureData<WorkOrderDetailEntity> getDetalleByNumeroOrden(
    String numeroOrden,
  ) async {
    final result = await DataHandler.fetchWithFallback<WorkOrderDetailModel>(
      _internet.isConnected,
      remoteCallback: () =>
          _remoteDataSource.getDetalleByNumeroOrden(numeroOrden),
    );
    return result.when(
      success: (model) =>
          SuccessState<WorkOrderDetailEntity>(data: model.toEntity()),
      failure: (message, errorType) =>
          FailureState<WorkOrderDetailEntity>(
            message: message,
            errorType: errorType,
          ),
      loading: () => LoadingState<WorkOrderDetailEntity>(),
    );
  }

  @override
  FutureData<WorkOrderTrackingEntity> getTrackingByNumeroOrden(
    String numeroOrden,
  ) async {
    final result = await DataHandler.fetchWithFallback<WorkOrderTrackingModel>(
      _internet.isConnected,
      remoteCallback: () =>
          _remoteDataSource.getTrackingByNumeroOrden(numeroOrden),
    );
    return result.when(
      success: (model) =>
          SuccessState<WorkOrderTrackingEntity>(data: model.toEntity()),
      failure: (message, errorType) =>
          FailureState<WorkOrderTrackingEntity>(
            message: message,
            errorType: errorType,
          ),
      loading: () => LoadingState<WorkOrderTrackingEntity>(),
    );
  }

  @override
  FutureData<List<WorkOrderEntity>> getOrdenesBySolicitudId(
    String solicitudId,
  ) async {
    final result = await DataHandler.fetchWithFallback<List<WorkOrderModel>>(
      _internet.isConnected,
      remoteCallback: () =>
          _remoteDataSource.getOrdenesBySolicitudId(solicitudId),
    );
    return result.when(
      success: (models) => SuccessState<List<WorkOrderEntity>>(
        data: models.map((m) => m.toEntity()).toList(),
      ),
      failure: (message, errorType) => FailureState<List<WorkOrderEntity>>(
        message: message,
        errorType: errorType,
      ),
      loading: () => LoadingState<List<WorkOrderEntity>>(),
    );
  }

  @override
  FutureData<void> addWorkOrderAttachment(
    String workOrderId,
    List<String> filePaths, {
    String? createdByUserId,
  }) async {
    final result = await DataHandler.fetchWithFallback<void>(
      _internet.isConnected,
      remoteCallback: () => _remoteDataSource.addWorkOrderAttachment(
        workOrderId,
        filePaths,
        createdByUserId: createdByUserId,
      ),
    );
    return result.when(
      success: (_) => SuccessState<void>(data: null),
      failure: (message, errorType) =>
          FailureState<void>(message: message, errorType: errorType),
      loading: () => LoadingState<void>(),
    );
  }
}
