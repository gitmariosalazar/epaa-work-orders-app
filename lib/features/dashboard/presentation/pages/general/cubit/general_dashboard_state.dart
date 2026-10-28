// features/dashboard/presentation/pages/general/cubit/general_dashboard_state.dart

import 'package:clean_architecture/features/dashboard/domain/entities/executive_overview_entity.dart';
import 'package:clean_architecture/features/dashboard/domain/entities/incident_vs_work_order_entities.dart';
import 'package:clean_architecture/features/dashboard/domain/entities/quality_sla_dashboard_entities.dart';
import 'package:clean_architecture/features/dashboard/domain/entities/technician_dashboard_entities.dart';
import 'package:clean_architecture/features/dashboard/domain/entities/work_order_statistics_entities.dart';
import 'package:equatable/equatable.dart';

class GeneralDashboardState extends Equatable {
  final bool isLoading;
  final bool isRefreshing;
  final String? errorMessage;
  final String selectedPeriod;

  // 1. Cabecera ejecutiva y totales
  final HeaderKpisEntity? headerKpis;

  // 2. Estados y Prioridades
  final List<WorkOrderStatusStatisticEntity> statusStats;
  final List<WorkOrderPriorityStatisticEntity> priorityStats;

  // 3. Embudo de Incidentes vs Órdenes
  final FunnelSummaryEntity? funnelSummary;

  // 4. Semáforo de SLA
  final List<SlaMonitorItemEntity> slaMonitor;

  // 5. Carga de Cuadrillas / Técnicos
  final List<TechnicianPerformanceItemEntity> technicianPerformance;

  // 6. Tipos de trabajo
  final List<WorkOrderTypeStatisticEntity> typeStats;

  const GeneralDashboardState({
    this.isLoading = false,
    this.isRefreshing = false,
    this.errorMessage,
    this.selectedPeriod = 'Este Mes',
    this.headerKpis,
    this.statusStats = const [],
    this.priorityStats = const [],
    this.funnelSummary,
    this.slaMonitor = const [],
    this.technicianPerformance = const [],
    this.typeStats = const [],
  });

  factory GeneralDashboardState.initial() => const GeneralDashboardState(
        isLoading: true,
      );

  GeneralDashboardState copyWith({
    bool? isLoading,
    bool? isRefreshing,
    String? errorMessage,
    bool clearError = false,
    String? selectedPeriod,
    HeaderKpisEntity? headerKpis,
    List<WorkOrderStatusStatisticEntity>? statusStats,
    List<WorkOrderPriorityStatisticEntity>? priorityStats,
    FunnelSummaryEntity? funnelSummary,
    List<SlaMonitorItemEntity>? slaMonitor,
    List<TechnicianPerformanceItemEntity>? technicianPerformance,
    List<WorkOrderTypeStatisticEntity>? typeStats,
  }) {
    return GeneralDashboardState(
      isLoading: isLoading ?? this.isLoading,
      isRefreshing: isRefreshing ?? this.isRefreshing,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      selectedPeriod: selectedPeriod ?? this.selectedPeriod,
      headerKpis: headerKpis ?? this.headerKpis,
      statusStats: statusStats ?? this.statusStats,
      priorityStats: priorityStats ?? this.priorityStats,
      funnelSummary: funnelSummary ?? this.funnelSummary,
      slaMonitor: slaMonitor ?? this.slaMonitor,
      technicianPerformance:
          technicianPerformance ?? this.technicianPerformance,
      typeStats: typeStats ?? this.typeStats,
    );
  }

  @override
  List<Object?> get props => [
        isLoading,
        isRefreshing,
        errorMessage,
        selectedPeriod,
        headerKpis,
        statusStats,
        priorityStats,
        funnelSummary,
        slaMonitor,
        technicianPerformance,
        typeStats,
      ];
}
