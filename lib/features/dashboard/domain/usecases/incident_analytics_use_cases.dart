// features/dashboard/domain/usecases/incident_analytics_use_cases.dart

import 'package:clean_architecture/core/domain/use_cases/use_case.dart';
import 'package:clean_architecture/core/utils/type_defs.dart';
import 'package:clean_architecture/features/dashboard/domain/entities/incident_vs_work_order_entities.dart';
import 'package:clean_architecture/features/dashboard/domain/repositories/dashboard_analytics_repository.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class GetFunnelSummaryUseCase
    implements UseCaseNoParameter<FunnelSummaryEntity> {
  final IncidentsVsWorkOrdersRepository _repository;

  const GetFunnelSummaryUseCase(this._repository);

  @override
  FutureData<FunnelSummaryEntity> call() => _repository.getFunnelSummary();
}

@lazySingleton
class GetStateMatrixUseCase
    implements UseCaseNoParameter<List<StateMatrixItemEntity>> {
  final IncidentsVsWorkOrdersRepository _repository;

  const GetStateMatrixUseCase(this._repository);

  @override
  FutureData<List<StateMatrixItemEntity>> call() =>
      _repository.getStateMatrix();
}

@lazySingleton
class GetOriginChannelsUseCase
    implements UseCaseNoParameter<List<OriginChannelItemEntity>> {
  final IncidentsVsWorkOrdersRepository _repository;

  const GetOriginChannelsUseCase(this._repository);

  @override
  FutureData<List<OriginChannelItemEntity>> call() =>
      _repository.getOriginChannels();
}

@lazySingleton
class GetCategoryDepartmentsUseCase
    implements UseCaseNoParameter<List<CategoryDepartmentItemEntity>> {
  final IncidentsVsWorkOrdersRepository _repository;

  const GetCategoryDepartmentsUseCase(this._repository);

  @override
  FutureData<List<CategoryDepartmentItemEntity>> call() =>
      _repository.getCategoryDepartments();
}

@lazySingleton
class GetSyncDiscrepanciesUseCase
    implements UseCaseNoParameter<List<SyncDiscrepancyItemEntity>> {
  final IncidentsVsWorkOrdersRepository _repository;

  const GetSyncDiscrepanciesUseCase(this._repository);

  @override
  FutureData<List<SyncDiscrepancyItemEntity>> call() =>
      _repository.getSyncDiscrepancies();
}

@lazySingleton
class GetDispatchControlUseCase
    implements UseCase<List<DispatchControlItemEntity>, int?> {
  final IncidentsVsWorkOrdersRepository _repository;

  const GetDispatchControlUseCase(this._repository);

  @override
  FutureData<List<DispatchControlItemEntity>> call(int? request) =>
      _repository.getDispatchControl(limit: request);
}
