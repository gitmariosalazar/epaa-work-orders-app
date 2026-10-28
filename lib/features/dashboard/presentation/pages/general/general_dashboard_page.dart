// features/dashboard/presentation/pages/general/general_dashboard_page.dart

import 'package:auto_route/auto_route.dart';
import 'package:clean_architecture/features/dashboard/domain/usecases/executive_overview_use_cases.dart';
import 'package:clean_architecture/features/dashboard/domain/usecases/incident_analytics_use_cases.dart';
import 'package:clean_architecture/features/dashboard/domain/usecases/operations_analytics_use_cases.dart';
import 'package:clean_architecture/features/dashboard/domain/usecases/quality_sla_use_cases.dart';
import 'package:clean_architecture/features/dashboard/domain/usecases/work_order_statistics_use_cases.dart';
import 'package:clean_architecture/features/dashboard/presentation/pages/general/cubit/general_dashboard_cubit.dart';
import 'package:clean_architecture/features/dashboard/presentation/pages/general/cubit/general_dashboard_state.dart';
import 'package:clean_architecture/features/dashboard/presentation/pages/general/widgets/general_crews_preview_section.dart';
import 'package:clean_architecture/features/dashboard/presentation/pages/general/widgets/general_funnel_section.dart';
import 'package:clean_architecture/features/dashboard/presentation/pages/general/widgets/general_header_section.dart';
import 'package:clean_architecture/features/dashboard/presentation/pages/general/widgets/general_hero_kpis_section.dart';
import 'package:clean_architecture/features/dashboard/presentation/pages/general/widgets/general_quick_navigation_section.dart';
import 'package:clean_architecture/features/dashboard/presentation/pages/general/widgets/general_status_priority_section.dart';
import 'package:clean_architecture/shared_ui/ui/base/base_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

@RoutePage()
class GeneralDashboardPage extends StatelessWidget {
  const GeneralDashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => GeneralDashboardCubit(
        getHeaderKpisUseCase: GetIt.I<GetHeaderKpisUseCase>(),
        getWorkOrderStatusStatisticsUseCase:
            GetIt.I<GetWorkOrderStatusStatisticsUseCase>(),
        getWorkOrderPriorityStatisticsUseCase:
            GetIt.I<GetWorkOrderPriorityStatisticsUseCase>(),
        getFunnelSummaryUseCase: GetIt.I<GetFunnelSummaryUseCase>(),
        getSlaMonitorUseCase: GetIt.I<GetSlaMonitorUseCase>(),
        getTechnicianPerformanceUseCase:
            GetIt.I<GetTechnicianPerformanceUseCase>(),
        getWorkOrderTypeStatisticsUseCase:
            GetIt.I<GetWorkOrderTypeStatisticsUseCase>(),
      )..loadDashboard(),
      child: const _GeneralDashboardView(),
    );
  }
}

class _GeneralDashboardView extends StatelessWidget {
  const _GeneralDashboardView();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    return BaseScaffold(
      isScrollable: false,
      usePadding: false,
      body: Container(
        color: isDark ? theme.scaffoldBackgroundColor : const Color(0xFFF8FAFC),
        child: BlocConsumer<GeneralDashboardCubit, GeneralDashboardState>(
          listener: (context, state) {
            if (state.errorMessage != null && state.errorMessage!.isNotEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.errorMessage!),
                  backgroundColor: cs.error,
                  duration: const Duration(seconds: 3),
                ),
              );
            }
          },
          builder: (context, state) {
            final cubit = context.read<GeneralDashboardCubit>();

            if (state.isLoading) {
              return Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircularProgressIndicator(color: cs.primary),
                    const SizedBox(height: 14),
                    Text(
                      'Cargando métricas ejecutivas...',
                      style: TextStyle(
                        fontSize: 13,
                        color: cs.onSurfaceVariant,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              );
            }

            return RefreshIndicator(
              onRefresh: () => cubit.loadDashboard(isRefresh: true),
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 16,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 1. Header Ejecutivo y Filtro de Período
                    GeneralHeaderSection(
                      selectedPeriod: state.selectedPeriod,
                      onPeriodChanged: (period) => cubit.changePeriod(period),
                      onRefresh: () => cubit.loadDashboard(isRefresh: true),
                      isRefreshing: state.isRefreshing,
                    ),
                    const SizedBox(height: 16),

                    // 2. Tarjetas Hero de KPIs Globales Reales
                    GeneralHeroKpisSection(
                      headerKpis: state.headerKpis,
                      statusStats: state.statusStats,
                      priorityStats: state.priorityStats,
                    ),
                    const SizedBox(height: 16),

                    // 3. Embudo de Conversión: Incidentes vs OTs
                    GeneralFunnelSection(
                      funnelSummary: state.funnelSummary,
                    ),
                    const SizedBox(height: 16),

                    // 4. Estados y Semáforo SLA
                    GeneralStatusPrioritySection(
                      statusStats: state.statusStats,
                      priorityStats: state.priorityStats,
                      slaMonitor: state.slaMonitor,
                    ),
                    const SizedBox(height: 16),

                    // 5. Cuadrillas & Técnicos en Campo
                    GeneralCrewsPreviewSection(
                      technicianPerformance: state.technicianPerformance,
                    ),
                    const SizedBox(height: 16),

                    // 6. Accesos Rápidos Modulares
                    const GeneralQuickNavigationSection(),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
