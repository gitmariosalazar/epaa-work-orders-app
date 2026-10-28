// features/dashboard/domain/usecases/trends_geospatial_use_cases.dart

import 'package:clean_architecture/core/domain/use_cases/use_case.dart';
import 'package:clean_architecture/core/utils/type_defs.dart';
import 'package:clean_architecture/features/dashboard/domain/entities/trends_geospatial_dashboard_entities.dart';
import 'package:clean_architecture/features/dashboard/domain/repositories/dashboard_analytics_repository.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class GetDailyTrendUseCase
    implements UseCaseNoParameter<List<DailyTrendItemEntity>> {
  final TrendsAndGeospatialDashboardRepository _repository;

  const GetDailyTrendUseCase(this._repository);

  @override
  FutureData<List<DailyTrendItemEntity>> call() => _repository.getDailyTrend();
}

@lazySingleton
class GetTerritorialConcentrationUseCase
    implements UseCaseNoParameter<List<TerritorialConcentrationItemEntity>> {
  final TrendsAndGeospatialDashboardRepository _repository;

  const GetTerritorialConcentrationUseCase(this._repository);

  @override
  FutureData<List<TerritorialConcentrationItemEntity>> call() =>
      _repository.getTerritorialConcentration();
}
