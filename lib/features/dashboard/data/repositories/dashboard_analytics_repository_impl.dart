// features/dashboard/data/repositories/dashboard_analytics_repository_impl.dart

import 'package:clean_architecture/core/data_handling/data_handler.dart';
import 'package:clean_architecture/core/data_states/data_state.dart';
import 'package:clean_architecture/core/services/internet/internet_service.dart';
import 'package:clean_architecture/core/utils/type_defs.dart';
import 'package:clean_architecture/features/dashboard/data/datasource/remote/dashboard_remote_datasource.dart';
import 'package:clean_architecture/features/dashboard/domain/entities/executive_overview_entity.dart';
import 'package:clean_architecture/features/dashboard/domain/entities/financial_dashboard_entities.dart';
import 'package:clean_architecture/features/dashboard/domain/entities/incident_vs_work_order_entities.dart';
import 'package:clean_architecture/features/dashboard/domain/entities/quality_sla_dashboard_entities.dart';
import 'package:clean_architecture/features/dashboard/domain/entities/technician_dashboard_entities.dart';
import 'package:clean_architecture/features/dashboard/domain/entities/trends_geospatial_dashboard_entities.dart';
import 'package:clean_architecture/features/dashboard/domain/entities/work_order_statistics_entities.dart';
import 'package:clean_architecture/features/dashboard/domain/repositories/dashboard_analytics_repository.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: DashboardAnalyticsRepository)
class DashboardAnalyticsRepositoryImpl implements DashboardAnalyticsRepository {
  final InternetService _internet;
  final DashboardRemoteDataSource _remote;

  DashboardAnalyticsRepositoryImpl({
    required InternetService internet,
    required DashboardRemoteDataSource remoteDataSource,
  }) : _internet = internet,
       _remote = remoteDataSource;

  FutureData<List<E>> _fetchList<M, E>(
    FutureData<List<M>> Function() remoteCall,
    E Function(M model) toEntity,
  ) async {
    final result = await DataHandler.fetchWithFallback<List<M>>(
      _internet.isConnected,
      remoteCallback: remoteCall,
    );

    return result.when(
      success: (models) =>
          SuccessState<List<E>>(data: models.map(toEntity).toList()),
      failure: (message, errorType) =>
          FailureState<List<E>>(message: message, errorType: errorType),
      loading: () => LoadingState<List<E>>(),
    );
  }

  FutureData<E> _fetchObject<M, E>(
    FutureData<M> Function() remoteCall,
    E Function(M model) toEntity,
  ) async {
    final result = await DataHandler.fetchWithFallback<M>(
      _internet.isConnected,
      remoteCallback: remoteCall,
    );

    return result.when(
      success: (model) => SuccessState<E>(data: toEntity(model)),
      failure: (message, errorType) =>
          FailureState<E>(message: message, errorType: errorType),
      loading: () => LoadingState<E>(),
    );
  }

  // 1. Incidentes vs OTs
  @override
  FutureData<FunnelSummaryEntity> getFunnelSummary() =>
      _fetchObject(_remote.getFunnelSummary, (m) => m.toEntity());

  @override
  FutureData<List<StateMatrixItemEntity>> getStateMatrix() =>
      _fetchList(_remote.getStateMatrix, (m) => m.toEntity());

  @override
  FutureData<List<OriginChannelItemEntity>> getOriginChannels() =>
      _fetchList(_remote.getOriginChannels, (m) => m.toEntity());

  @override
  FutureData<List<CategoryDepartmentItemEntity>> getCategoryDepartments() =>
      _fetchList(_remote.getCategoryDepartments, (m) => m.toEntity());

  @override
  FutureData<List<SyncDiscrepancyItemEntity>> getSyncDiscrepancies() =>
      _fetchList(_remote.getSyncDiscrepancies, (m) => m.toEntity());

  @override
  FutureData<List<DispatchControlItemEntity>> getDispatchControl({
    int? limit,
  }) => _fetchList(() => _remote.getDispatchControl(limit: limit), (m) => m.toEntity());

  // 2. KPIs y Distribuciones
  @override
  FutureData<HeaderKpisEntity> getHeaderKpis() =>
      _fetchObject(_remote.getHeaderKpis, (m) => m.toEntity());

  @override
  FutureData<List<WorkOrderStatusStatisticEntity>> getStatusDistribution() =>
      _fetchList(_remote.getStatusDistribution, (m) => m.toEntity());

  @override
  FutureData<List<WorkOrderPriorityStatisticEntity>>
  getPriorityDistribution() =>
      _fetchList(_remote.getPriorityDistribution, (m) => m.toEntity());

  @override
  FutureData<List<WorkOrderTypeStatisticEntity>> getWorkTypePerformance() =>
      _fetchList(_remote.getWorkTypePerformance, (m) => m.toEntity());

  @override
  FutureData<List<WorkOrdersKeyStatisticEntity>> getKeyStatisticsMatrix() =>
      _fetchList(_remote.getKeyStatisticsMatrix, (m) => m.toEntity());

  @override
  FutureData<ExecutiveOverviewEntity> getExecutiveOverview() =>
      _fetchObject(_remote.getExecutiveOverview, (m) => m.toEntity());

  // 3. Cuadrillas y Técnicos
  @override
  FutureData<List<TechnicianPerformanceItemEntity>>
  getTechnicianPerformance() =>
      _fetchList(_remote.getTechnicianPerformance, (m) => m.toEntity());

  @override
  FutureData<List<TechnicianDailyFeedItemEntity>> getTechnicianDailyFeed({
    String? technicianId,
  }) => _fetchList(
    () => _remote.getTechnicianDailyFeed(technicianId: technicianId),
    (m) => m.toEntity(),
  );

  @override
  FutureData<List<CrewAssignmentItemEntity>> getCrewAssignments() =>
      _fetchList(_remote.getCrewAssignments, (m) => m.toEntity());

  // 4. SLA y Calidad
  @override
  FutureData<List<SlaMonitorItemEntity>> getSlaMonitor() =>
      _fetchList(_remote.getSlaMonitor, (m) => m.toEntity());

  @override
  FutureData<List<QualityIndicatorItemEntity>> getQualityIndicators() =>
      _fetchList(_remote.getQualityIndicators, (m) => m.toEntity());

  @override
  FutureData<List<EscalationAuditItemEntity>> getEscalationAudit() =>
      _fetchList(_remote.getEscalationAudit, (m) => m.toEntity());

  // 5. Financiero
  @override
  FutureData<List<MaterialCostItemEntity>> getMaterialCosts() =>
      _fetchList(_remote.getMaterialCosts, (m) => m.toEntity());

  @override
  FutureData<List<EconomicBalanceItemEntity>> getEconomicBalance() =>
      _fetchList(_remote.getEconomicBalance, (m) => m.toEntity());

  // 6. Tendencias y Geoespacial
  @override
  FutureData<List<DailyTrendItemEntity>> getDailyTrend() =>
      _fetchList(_remote.getDailyTrend, (m) => m.toEntity());

  @override
  FutureData<List<TerritorialConcentrationItemEntity>>
  getTerritorialConcentration() =>
      _fetchList(_remote.getTerritorialConcentration, (m) => m.toEntity());
}

@module
abstract class DashboardRepositoriesModule {
  @lazySingleton
  IncidentsVsWorkOrdersRepository incidentsVsWorkOrdersRepository(
    DashboardAnalyticsRepository repo,
  ) => repo;

  @lazySingleton
  TechnicianDashboardRepository technicianDashboardRepository(
    DashboardAnalyticsRepository repo,
  ) => repo;

  @lazySingleton
  QualityAndSlaDashboardRepository qualityAndSlaDashboardRepository(
    DashboardAnalyticsRepository repo,
  ) => repo;

  @lazySingleton
  FinancialDashboardRepository financialDashboardRepository(
    DashboardAnalyticsRepository repo,
  ) => repo;

  @lazySingleton
  TrendsAndGeospatialDashboardRepository
  trendsAndGeospatialDashboardRepository(DashboardAnalyticsRepository repo) =>
      repo;

  @lazySingleton
  ExecutiveDashboardRepository executiveDashboardRepository(
    DashboardAnalyticsRepository repo,
  ) => repo;
}
