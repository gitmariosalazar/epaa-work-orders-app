// features/dashboard/data/datasource/remote/dashboard_remote_datasource.dart

import 'package:clean_architecture/core/constants/api_endpoints.dart';
import 'package:clean_architecture/core/data_handling/data_handler.dart';
import 'package:clean_architecture/core/services/api/api_service.dart';
import 'package:clean_architecture/core/utils/type_defs.dart';
import 'package:clean_architecture/features/dashboard/data/models/executive_overview_model.dart';
import 'package:clean_architecture/features/dashboard/data/models/financial_dashboard_models.dart';
import 'package:clean_architecture/features/dashboard/data/models/incident_vs_work_order_models.dart';
import 'package:clean_architecture/features/dashboard/data/models/quality_sla_dashboard_models.dart';
import 'package:clean_architecture/features/dashboard/data/models/technician_dashboard_models.dart';
import 'package:clean_architecture/features/dashboard/data/models/trends_geospatial_dashboard_models.dart';
import 'package:clean_architecture/features/dashboard/data/models/work_order_statistics_models.dart';
import 'package:injectable/injectable.dart';

abstract interface class DashboardRemoteDataSource {
  // Sección 1: Incidentes vs Órdenes de Trabajo
  FutureData<FunnelSummaryModel> getFunnelSummary();
  FutureData<List<StateMatrixItemModel>> getStateMatrix();
  FutureData<List<OriginChannelItemModel>> getOriginChannels();
  FutureData<List<CategoryDepartmentItemModel>> getCategoryDepartments();
  FutureData<List<SyncDiscrepancyItemModel>> getSyncDiscrepancies();
  FutureData<List<DispatchControlItemModel>> getDispatchControl({int? limit});

  // Sección 2: KPIs y Distribuciones de Órdenes
  FutureData<HeaderKpisModel> getHeaderKpis();
  FutureData<List<WorkOrderStatusStatisticModel>> getStatusDistribution();
  FutureData<List<WorkOrderPriorityStatisticModel>> getPriorityDistribution();
  FutureData<List<WorkOrderTypeStatisticModel>> getWorkTypePerformance();
  FutureData<List<WorkOrdersKeyStatisticModel>> getKeyStatisticsMatrix();
  FutureData<ExecutiveOverviewModel> getExecutiveOverview();

  // Sección 3: Cuadrillas y Técnicos
  FutureData<List<TechnicianPerformanceItemModel>> getTechnicianPerformance();
  FutureData<List<TechnicianDailyFeedItemModel>> getTechnicianDailyFeed({
    String? technicianId,
  });
  FutureData<List<CrewAssignmentItemModel>> getCrewAssignments();

  // Sección 4: SLA y Control de Calidad
  FutureData<List<SlaMonitorItemModel>> getSlaMonitor();
  FutureData<List<QualityIndicatorItemModel>> getQualityIndicators();
  FutureData<List<EscalationAuditItemModel>> getEscalationAudit();

  // Sección 5: Financiero y Costos
  FutureData<List<MaterialCostItemModel>> getMaterialCosts();
  FutureData<List<EconomicBalanceItemModel>> getEconomicBalance();

  // Sección 6: Tendencias y Geoespacial
  FutureData<List<DailyTrendItemModel>> getDailyTrend();
  FutureData<List<TerritorialConcentrationItemModel>>
  getTerritorialConcentration();
}

@LazySingleton(as: DashboardRemoteDataSource)
class DashboardRemoteDataSourceImpl implements DashboardRemoteDataSource {
  final ApiService _apiService;

  const DashboardRemoteDataSourceImpl({required ApiService apiService})
    : _apiService = apiService;

  FutureData<List<M>> _getList<M>(
    String endpoint,
    M Function(Map<String, dynamic> json) fromJson, {
    Map<String, dynamic>? queryParameters,
  }) {
    return DataHandler.safeApiCall<List<M>, M>(
      request:
          () => _apiService.get(endpoint, queryParameters: queryParameters),
      fromJson: fromJson,
      isStandardResponse: true,
      responseDataKey: 'data',
    );
  }

  FutureData<M> _getObject<M>(
    String endpoint,
    M Function(Map<String, dynamic> json) fromJson, {
    Map<String, dynamic>? queryParameters,
  }) {
    return DataHandler.safeApiCall<M, M>(
      request:
          () => _apiService.get(endpoint, queryParameters: queryParameters),
      fromJson: fromJson,
      isStandardResponse: true,
      responseDataKey: 'data',
    );
  }

  // 1. Incidentes vs OTs
  @override
  FutureData<FunnelSummaryModel> getFunnelSummary() => _getObject(
    ApiEndpoints.dashboardFunnelSummary,
    FunnelSummaryModel.fromJson,
  );

  @override
  FutureData<List<StateMatrixItemModel>> getStateMatrix() =>
      _getList(ApiEndpoints.dashboardStateMatrix, StateMatrixItemModel.fromJson);

  @override
  FutureData<List<OriginChannelItemModel>> getOriginChannels() => _getList(
    ApiEndpoints.dashboardOriginChannel,
    OriginChannelItemModel.fromJson,
  );

  @override
  FutureData<List<CategoryDepartmentItemModel>> getCategoryDepartments() =>
      _getList(
        ApiEndpoints.dashboardCategoryDepartment,
        CategoryDepartmentItemModel.fromJson,
      );

  @override
  FutureData<List<SyncDiscrepancyItemModel>> getSyncDiscrepancies() => _getList(
    ApiEndpoints.dashboardSyncDiscrepancies,
    SyncDiscrepancyItemModel.fromJson,
  );

  @override
  FutureData<List<DispatchControlItemModel>> getDispatchControl({int? limit}) =>
      _getList(
        ApiEndpoints.dashboardDispatchControl,
        DispatchControlItemModel.fromJson,
        queryParameters: limit != null ? {'limit': limit} : null,
      );

  // 2. KPIs y Distribuciones
  @override
  FutureData<HeaderKpisModel> getHeaderKpis() =>
      _getObject(ApiEndpoints.dashboardHeaderKpis, HeaderKpisModel.fromJson);

  @override
  FutureData<List<WorkOrderStatusStatisticModel>> getStatusDistribution() =>
      _getList(
        ApiEndpoints.dashboardStatusDistribution,
        WorkOrderStatusStatisticModel.fromJson,
      );

  @override
  FutureData<List<WorkOrderPriorityStatisticModel>> getPriorityDistribution() =>
      _getList(
        ApiEndpoints.dashboardPriorityDistribution,
        WorkOrderPriorityStatisticModel.fromJson,
      );

  @override
  FutureData<List<WorkOrderTypeStatisticModel>> getWorkTypePerformance() =>
      _getList(
        ApiEndpoints.dashboardWorkTypePerformance,
        WorkOrderTypeStatisticModel.fromJson,
      );

  @override
  FutureData<List<WorkOrdersKeyStatisticModel>> getKeyStatisticsMatrix() =>
      _getList(
        ApiEndpoints.dashboardKeyStatisticsMatrix,
        WorkOrdersKeyStatisticModel.fromJson,
      );

  @override
  FutureData<ExecutiveOverviewModel> getExecutiveOverview() => _getObject(
    ApiEndpoints.dashboardExecutiveOverview,
    ExecutiveOverviewModel.fromJson,
  );

  // 3. Cuadrillas y Técnicos
  @override
  FutureData<List<TechnicianPerformanceItemModel>>
  getTechnicianPerformance() => _getList(
    ApiEndpoints.dashboardTechnicianPerformance,
    TechnicianPerformanceItemModel.fromJson,
  );

  @override
  FutureData<List<TechnicianDailyFeedItemModel>> getTechnicianDailyFeed({
    String? technicianId,
  }) => _getList(
    ApiEndpoints.dashboardTechnicianDailyFeed,
    TechnicianDailyFeedItemModel.fromJson,
    queryParameters:
        technicianId != null ? {'technicianId': technicianId} : null,
  );

  @override
  FutureData<List<CrewAssignmentItemModel>> getCrewAssignments() => _getList(
    ApiEndpoints.dashboardCrewAssignments,
    CrewAssignmentItemModel.fromJson,
  );

  // 4. SLA y Calidad
  @override
  FutureData<List<SlaMonitorItemModel>> getSlaMonitor() =>
      _getList(ApiEndpoints.dashboardSlaMonitor, SlaMonitorItemModel.fromJson);

  @override
  FutureData<List<QualityIndicatorItemModel>> getQualityIndicators() => _getList(
    ApiEndpoints.dashboardQualityIndicators,
    QualityIndicatorItemModel.fromJson,
  );

  @override
  FutureData<List<EscalationAuditItemModel>> getEscalationAudit() => _getList(
    ApiEndpoints.dashboardEscalationAudit,
    EscalationAuditItemModel.fromJson,
  );

  // 5. Financiero
  @override
  FutureData<List<MaterialCostItemModel>> getMaterialCosts() => _getList(
    ApiEndpoints.dashboardMaterialCosts,
    MaterialCostItemModel.fromJson,
  );

  @override
  FutureData<List<EconomicBalanceItemModel>> getEconomicBalance() => _getList(
    ApiEndpoints.dashboardEconomicBalance,
    EconomicBalanceItemModel.fromJson,
  );

  // 6. Tendencias y Geoespacial
  @override
  FutureData<List<DailyTrendItemModel>> getDailyTrend() =>
      _getList(ApiEndpoints.dashboardDailyTrend, DailyTrendItemModel.fromJson);

  @override
  FutureData<List<TerritorialConcentrationItemModel>>
  getTerritorialConcentration() => _getList(
    ApiEndpoints.dashboardTerritorialConcentration,
    TerritorialConcentrationItemModel.fromJson,
  );
}
