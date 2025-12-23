// features/work-orders/data/repositories/work_order_repository_impl.dart

import 'package:clean_architecture/core/data_handling/data_handler.dart';
import 'package:clean_architecture/core/services/internet/internet_service.dart';
import 'package:clean_architecture/core/utils/type_defs.dart';
import 'package:clean_architecture/features/work-orders/data/datasource/remote/work_orders_remote_datasource.dart';
import 'package:clean_architecture/features/work-orders/data/models/models/work_order_response.dart';
import 'package:clean_architecture/features/work-orders/domain/entities/work_order_entity.dart';
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
  FutureData<List<WorkOrderEntity>> getAllWorkOrders() async {
    final result = await DataHandler.fetchWithFallback<List<WorkOrderModel>>(
      _internet.isConnected,
      remoteCallback: _remoteDataSource.getAllWorkOrders,
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
}
