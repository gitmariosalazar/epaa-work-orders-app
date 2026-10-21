// features/dashboard/domain/usecases/work_order_statistics_use_cases.dart

import 'package:clean_architecture/core/domain/use_cases/use_case.dart';
import 'package:clean_architecture/core/utils/type_defs.dart';
import 'package:clean_architecture/features/dashboard/domain/entities/work_order_statistics_entities.dart';
import 'package:clean_architecture/features/dashboard/domain/repositories/work_order_statistics_repository.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class GetWorkOrderPriorityStatisticsUseCase
    implements UseCaseNoParameter<List<WorkOrderPriorityStatisticEntity>> {
  final WorkOrderStatisticsRepository _repository;

  const GetWorkOrderPriorityStatisticsUseCase(this._repository);

  @override
  FutureData<List<WorkOrderPriorityStatisticEntity>> call() =>
      _repository.getPriorityStatistics();
}

@lazySingleton
class GetWorkOrderStatusStatisticsUseCase
    implements UseCaseNoParameter<List<WorkOrderStatusStatisticEntity>> {
  final WorkOrderStatisticsRepository _repository;

  const GetWorkOrderStatusStatisticsUseCase(this._repository);

  @override
  FutureData<List<WorkOrderStatusStatisticEntity>> call() =>
      _repository.getStatusStatistics();
}

@lazySingleton
class GetWorkOrderTypeStatisticsUseCase
    implements UseCaseNoParameter<List<WorkOrderTypeStatisticEntity>> {
  final WorkOrderStatisticsRepository _repository;

  const GetWorkOrderTypeStatisticsUseCase(this._repository);

  @override
  FutureData<List<WorkOrderTypeStatisticEntity>> call() =>
      _repository.getTypeStatistics();
}

@lazySingleton
class GetWorkOrdersKeyStatisticsUseCase
    implements UseCaseNoParameter<List<WorkOrdersKeyStatisticEntity>> {
  final WorkOrderStatisticsRepository _repository;

  const GetWorkOrdersKeyStatisticsUseCase(this._repository);

  @override
  FutureData<List<WorkOrdersKeyStatisticEntity>> call() =>
      _repository.getKeyStatistics();
}
