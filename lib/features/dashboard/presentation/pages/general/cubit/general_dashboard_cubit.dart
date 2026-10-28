// features/dashboard/presentation/pages/general/cubit/general_dashboard_cubit.dart

import 'package:clean_architecture/core/data_states/data_state.dart';
import 'package:clean_architecture/features/dashboard/domain/entities/executive_overview_entity.dart';
import 'package:clean_architecture/features/dashboard/domain/entities/incident_vs_work_order_entities.dart';
import 'package:clean_architecture/features/dashboard/domain/entities/quality_sla_dashboard_entities.dart';
import 'package:clean_architecture/features/dashboard/domain/entities/technician_dashboard_entities.dart';
import 'package:clean_architecture/features/dashboard/domain/entities/work_order_statistics_entities.dart';
import 'package:clean_architecture/features/dashboard/domain/usecases/executive_overview_use_cases.dart';
import 'package:clean_architecture/features/dashboard/domain/usecases/incident_analytics_use_cases.dart';
import 'package:clean_architecture/features/dashboard/domain/usecases/operations_analytics_use_cases.dart';
import 'package:clean_architecture/features/dashboard/domain/usecases/quality_sla_use_cases.dart';
import 'package:clean_architecture/features/dashboard/domain/usecases/work_order_statistics_use_cases.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'general_dashboard_state.dart';

class GeneralDashboardCubit extends Cubit<GeneralDashboardState> {
  final GetHeaderKpisUseCase getHeaderKpisUseCase;
  final GetWorkOrderStatusStatisticsUseCase getWorkOrderStatusStatisticsUseCase;
  final GetWorkOrderPriorityStatisticsUseCase
      getWorkOrderPriorityStatisticsUseCase;
  final GetFunnelSummaryUseCase getFunnelSummaryUseCase;
  final GetSlaMonitorUseCase getSlaMonitorUseCase;
  final GetTechnicianPerformanceUseCase getTechnicianPerformanceUseCase;
  final GetWorkOrderTypeStatisticsUseCase getWorkOrderTypeStatisticsUseCase;

  GeneralDashboardCubit({
    required this.getHeaderKpisUseCase,
    required this.getWorkOrderStatusStatisticsUseCase,
    required this.getWorkOrderPriorityStatisticsUseCase,
    required this.getFunnelSummaryUseCase,
    required this.getSlaMonitorUseCase,
    required this.getTechnicianPerformanceUseCase,
    required this.getWorkOrderTypeStatisticsUseCase,
  }) : super(GeneralDashboardState.initial());

  Future<void> loadDashboard({bool isRefresh = false}) async {
    if (!isRefresh) {
      emit(state.copyWith(isLoading: true, clearError: true));
    } else {
      emit(state.copyWith(isRefreshing: true, clearError: true));
    }

    try {
      // Ejecución paralela resiliente: ninguna falla tumba a las demás
      final results = await Future.wait([
        _safeCall(() => getHeaderKpisUseCase()),
        _safeCall(() => getWorkOrderStatusStatisticsUseCase()),
        _safeCall(() => getWorkOrderPriorityStatisticsUseCase()),
        _safeCall(() => getFunnelSummaryUseCase()),
        _safeCall(() => getSlaMonitorUseCase()),
        _safeCall(() => getTechnicianPerformanceUseCase()),
        _safeCall(() => getWorkOrderTypeStatisticsUseCase()),
      ]);

      final headerKpis = results[0] as HeaderKpisEntity?;
      final statusStats =
          (results[1] as List<WorkOrderStatusStatisticEntity>?) ?? state.statusStats;
      final priorityStats =
          (results[2] as List<WorkOrderPriorityStatisticEntity>?) ??
              state.priorityStats;
      final funnelSummary = results[3] as FunnelSummaryEntity?;
      final slaMonitor =
          (results[4] as List<SlaMonitorItemEntity>?) ?? state.slaMonitor;
      final technicianPerformance =
          (results[5] as List<TechnicianPerformanceItemEntity>?) ??
              state.technicianPerformance;
      final typeStats =
          (results[6] as List<WorkOrderTypeStatisticEntity>?) ?? state.typeStats;

      emit(state.copyWith(
        isLoading: false,
        isRefreshing: false,
        headerKpis: headerKpis ?? state.headerKpis,
        statusStats: statusStats,
        priorityStats: priorityStats,
        funnelSummary: funnelSummary ?? state.funnelSummary,
        slaMonitor: slaMonitor,
        technicianPerformance: technicianPerformance,
        typeStats: typeStats,
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        isRefreshing: false,
        errorMessage: 'Error al sincronizar datos del dashboard: $e',
      ));
    }
  }

  void changePeriod(String period) {
    if (state.selectedPeriod == period) return;
    emit(state.copyWith(selectedPeriod: period));
    loadDashboard(isRefresh: true);
  }

  Future<T?> _safeCall<T>(Future<DataState<T>> Function() call) async {
    try {
      final res = await call();
      if (res is SuccessState<T>) {
        return res.data;
      }
    } catch (_) {}
    return null;
  }
}
