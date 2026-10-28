// features/dashboard/domain/usecases/operations_analytics_use_cases.dart

import 'package:clean_architecture/core/domain/use_cases/use_case.dart';
import 'package:clean_architecture/core/utils/type_defs.dart';
import 'package:clean_architecture/features/dashboard/domain/entities/technician_dashboard_entities.dart';
import 'package:clean_architecture/features/dashboard/domain/repositories/dashboard_analytics_repository.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class GetTechnicianPerformanceUseCase
    implements UseCaseNoParameter<List<TechnicianPerformanceItemEntity>> {
  final TechnicianDashboardRepository _repository;

  const GetTechnicianPerformanceUseCase(this._repository);

  @override
  FutureData<List<TechnicianPerformanceItemEntity>> call() =>
      _repository.getTechnicianPerformance();
}

@lazySingleton
class GetTechnicianDailyFeedUseCase
    implements UseCase<List<TechnicianDailyFeedItemEntity>, String?> {
  final TechnicianDashboardRepository _repository;

  const GetTechnicianDailyFeedUseCase(this._repository);

  @override
  FutureData<List<TechnicianDailyFeedItemEntity>> call(String? request) =>
      _repository.getTechnicianDailyFeed(technicianId: request);
}

@lazySingleton
class GetCrewAssignmentsUseCase
    implements UseCaseNoParameter<List<CrewAssignmentItemEntity>> {
  final TechnicianDashboardRepository _repository;

  const GetCrewAssignmentsUseCase(this._repository);

  @override
  FutureData<List<CrewAssignmentItemEntity>> call() =>
      _repository.getCrewAssignments();
}
