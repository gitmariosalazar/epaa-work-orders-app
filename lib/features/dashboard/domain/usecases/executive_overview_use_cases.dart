// features/dashboard/domain/usecases/executive_overview_use_cases.dart

import 'package:clean_architecture/core/domain/use_cases/use_case.dart';
import 'package:clean_architecture/core/utils/type_defs.dart';
import 'package:clean_architecture/features/dashboard/domain/entities/executive_overview_entity.dart';
import 'package:clean_architecture/features/dashboard/domain/repositories/dashboard_analytics_repository.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class GetHeaderKpisUseCase implements UseCaseNoParameter<HeaderKpisEntity> {
  final ExecutiveDashboardRepository _repository;

  const GetHeaderKpisUseCase(this._repository);

  @override
  FutureData<HeaderKpisEntity> call() => _repository.getHeaderKpis();
}

@lazySingleton
class GetExecutiveOverviewUseCase
    implements UseCaseNoParameter<ExecutiveOverviewEntity> {
  final ExecutiveDashboardRepository _repository;

  const GetExecutiveOverviewUseCase(this._repository);

  @override
  FutureData<ExecutiveOverviewEntity> call() =>
      _repository.getExecutiveOverview();
}
