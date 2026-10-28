// features/dashboard/domain/repositories/dashboard_analytics_repository.dart

import 'package:clean_architecture/core/utils/type_defs.dart';
import 'package:clean_architecture/features/dashboard/domain/entities/executive_overview_entity.dart';
import 'package:clean_architecture/features/dashboard/domain/entities/financial_dashboard_entities.dart';
import 'package:clean_architecture/features/dashboard/domain/entities/incident_vs_work_order_entities.dart';
import 'package:clean_architecture/features/dashboard/domain/entities/quality_sla_dashboard_entities.dart';
import 'package:clean_architecture/features/dashboard/domain/entities/technician_dashboard_entities.dart';
import 'package:clean_architecture/features/dashboard/domain/entities/trends_geospatial_dashboard_entities.dart';
import 'package:clean_architecture/features/dashboard/domain/entities/work_order_statistics_entities.dart';

/// Contrato para el comparativo de incidentes ciudadanos vs órdenes de trabajo (ISP).
abstract interface class IncidentsVsWorkOrdersRepository {
  FutureData<FunnelSummaryEntity> getFunnelSummary();
  FutureData<List<StateMatrixItemEntity>> getStateMatrix();
  FutureData<List<OriginChannelItemEntity>> getOriginChannels();
  FutureData<List<CategoryDepartmentItemEntity>> getCategoryDepartments();
  FutureData<List<SyncDiscrepancyItemEntity>> getSyncDiscrepancies();
  FutureData<List<DispatchControlItemEntity>> getDispatchControl({int? limit});
}

/// Contrato para analítica de cuadrillas y técnicos de campo (ISP).
abstract interface class TechnicianDashboardRepository {
  FutureData<List<TechnicianPerformanceItemEntity>> getTechnicianPerformance();
  FutureData<List<TechnicianDailyFeedItemEntity>> getTechnicianDailyFeed({
    String? technicianId,
  });
  FutureData<List<CrewAssignmentItemEntity>> getCrewAssignments();
}

/// Contrato para el monitoreo de SLA, calidad y auditoría (ISP).
abstract interface class QualityAndSlaDashboardRepository {
  FutureData<List<SlaMonitorItemEntity>> getSlaMonitor();
  FutureData<List<QualityIndicatorItemEntity>> getQualityIndicators();
  FutureData<List<EscalationAuditItemEntity>> getEscalationAudit();
}

/// Contrato para costos de materiales y balance económico (ISP).
abstract interface class FinancialDashboardRepository {
  FutureData<List<MaterialCostItemEntity>> getMaterialCosts();
  FutureData<List<EconomicBalanceItemEntity>> getEconomicBalance();
}

/// Contrato para tendencias temporales y análisis territorial geoespacial (ISP).
abstract interface class TrendsAndGeospatialDashboardRepository {
  FutureData<List<DailyTrendItemEntity>> getDailyTrend();
  FutureData<List<TerritorialConcentrationItemEntity>>
  getTerritorialConcentration();
}

/// Contrato para el resumen ejecutivo de alto desempeño (ISP).
abstract interface class ExecutiveDashboardRepository {
  FutureData<HeaderKpisEntity> getHeaderKpis();
  FutureData<ExecutiveOverviewEntity> getExecutiveOverview();
  FutureData<List<WorkOrderStatusStatisticEntity>> getStatusDistribution();
  FutureData<List<WorkOrderPriorityStatisticEntity>> getPriorityDistribution();
  FutureData<List<WorkOrderTypeStatisticEntity>> getWorkTypePerformance();
  FutureData<List<WorkOrdersKeyStatisticEntity>> getKeyStatisticsMatrix();
}

/// Fachada unificada para inyección de dependencias completa del módulo de Dashboard.
abstract interface class DashboardAnalyticsRepository
    implements
        IncidentsVsWorkOrdersRepository,
        TechnicianDashboardRepository,
        QualityAndSlaDashboardRepository,
        FinancialDashboardRepository,
        TrendsAndGeospatialDashboardRepository,
        ExecutiveDashboardRepository {}
