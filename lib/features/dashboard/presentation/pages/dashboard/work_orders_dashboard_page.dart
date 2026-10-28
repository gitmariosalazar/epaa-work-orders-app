// features/dashboard/presentation/pages/dashboard/work_orders_dashboard_page.dart

import 'package:auto_route/auto_route.dart';
import 'package:clean_architecture/features/dashboard/domain/entities/work_order_statistics_entities.dart';
import 'package:clean_architecture/features/dashboard/domain/usecases/work_order_statistics_use_cases.dart';
import 'package:clean_architecture/features/dashboard/presentation/cubits/statistics/statistics_cubit.dart';
import 'package:clean_architecture/features/dashboard/presentation/pages/dashboard/widgets/dispatch_control_section.dart';
import 'package:clean_architecture/features/dashboard/presentation/pages/dashboard/widgets/financial_and_trends_section.dart';
import 'package:clean_architecture/features/dashboard/presentation/pages/dashboard/widgets/funnel_summary_section.dart';
import 'package:clean_architecture/features/dashboard/presentation/pages/dashboard/widgets/origin_channel_section.dart';
import 'package:clean_architecture/features/dashboard/presentation/pages/dashboard/widgets/sla_and_quality_section.dart';
import 'package:clean_architecture/features/dashboard/presentation/pages/dashboard/widgets/state_matrix_section.dart';
import 'package:clean_architecture/features/dashboard/presentation/pages/dashboard/widgets/technician_workload_section.dart';
import 'package:clean_architecture/shared_ui/ui/base/app_bar/base_app_bar.dart';
import 'package:clean_architecture/shared_ui/ui/base/base_scaffold.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

@RoutePage()
class WorkOrdersDashboardPage extends StatefulWidget {
  const WorkOrdersDashboardPage({super.key});

  @override
  State<WorkOrdersDashboardPage> createState() =>
      _WorkOrdersDashboardPageState();
}

class _WorkOrdersDashboardPageState extends State<WorkOrdersDashboardPage>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    return MultiBlocProvider(
      providers: [
        BlocProvider<StatisticsCubit<WorkOrdersKeyStatisticEntity>>(
          create: (_) => StatisticsCubit<WorkOrdersKeyStatisticEntity>(
            GetIt.I<GetWorkOrdersKeyStatisticsUseCase>(),
          )..load(),
        ),
        BlocProvider<StatisticsCubit<WorkOrderStatusStatisticEntity>>(
          create: (_) => StatisticsCubit<WorkOrderStatusStatisticEntity>(
            GetIt.I<GetWorkOrderStatusStatisticsUseCase>(),
          )..load(),
        ),
        BlocProvider<StatisticsCubit<WorkOrderPriorityStatisticEntity>>(
          create: (_) => StatisticsCubit<WorkOrderPriorityStatisticEntity>(
            GetIt.I<GetWorkOrderPriorityStatisticsUseCase>(),
          )..load(),
        ),
        BlocProvider<StatisticsCubit<WorkOrderTypeStatisticEntity>>(
          create: (_) => StatisticsCubit<WorkOrderTypeStatisticEntity>(
            GetIt.I<GetWorkOrderTypeStatisticsUseCase>(),
          )..load(),
        ),
      ],
      child: Builder(
        builder: (providerContext) {
          return BaseScaffold(
            appBar: BaseAppBar(
              title: 'Dashboard de Gestión EPAA',
              titleFontWeight: FontWeight.w600,
              actions: [
                IconButton(
                  icon: const Icon(Icons.refresh_rounded),
                  tooltip: 'Recargar todos los datos',
                  onPressed: () => _refreshAll(providerContext),
                ),
              ],
            ),
            isScrollable: false,
            body: Column(
              children: [
                // Barra de pestañas estilizada
                Container(
                  color: isDark ? colorScheme.surface : Colors.white,
                  child: TabBar(
                    controller: _tabController,
                    isScrollable: true,
                    labelColor: colorScheme.primary,
                    unselectedLabelColor: isDark
                        ? Colors.grey.shade400
                        : Colors.grey.shade600,
                    indicatorColor: colorScheme.primary,
                    indicatorWeight: 3,
                    labelStyle: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                    unselectedLabelStyle: const TextStyle(fontSize: 12),
                    tabAlignment: TabAlignment.start,
                    tabs: const [
                      Tab(
                        icon: Icon(Icons.compare_arrows_rounded, size: 18),
                        text: 'Incidentes vs OTs',
                      ),
                      Tab(
                        icon: Icon(Icons.pie_chart_outline_rounded, size: 18),
                        text: 'Dashboard OTs',
                      ),
                      Tab(
                        icon: Icon(Icons.groups_rounded, size: 18),
                        text: 'Técnicos y SLA',
                      ),
                      Tab(
                        icon: Icon(Icons.analytics_outlined, size: 18),
                        text: 'Finanzas y Tendencias',
                      ),
                    ],
                  ),
                ),
                const Divider(height: 1, thickness: 1),

                // Contenido dinámico por pestaña
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      // Pestaña 1: Comparativa Incidentes vs OTs
                      RefreshIndicator(
                        onRefresh: () async => _refreshAll(providerContext),
                        child: SingleChildScrollView(
                          physics: const AlwaysScrollableScrollPhysics(),
                          padding: const EdgeInsets.all(0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              FunnelSummarySection(),
                              SizedBox(height: 12),
                              OriginChannelSection(),
                              SizedBox(height: 12),
                              StateMatrixSection(),
                              SizedBox(height: 12),
                              DispatchControlSection(),
                              SizedBox(height: 16),
                            ],
                          ),
                        ),
                      ),

                      // Pestaña 2: Dashboard OTs (KPIs, Donut Charts y Tipos)
                      RefreshIndicator(
                        onRefresh: () async => _refreshAll(providerContext),
                        child: SingleChildScrollView(
                          physics: const AlwaysScrollableScrollPhysics(),
                          padding: const EdgeInsets.all(12),
                          child: const _WorkOrdersOverviewTab(),
                        ),
                      ),

                      // Pestaña 3: Cuadrillas & SLA
                      RefreshIndicator(
                        onRefresh: () async => _refreshAll(providerContext),
                        child: SingleChildScrollView(
                          physics: const AlwaysScrollableScrollPhysics(),
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              TechnicianWorkloadSection(),
                              SizedBox(height: 12),
                              SlaAndQualitySection(),
                              SizedBox(height: 20),
                            ],
                          ),
                        ),
                      ),

                      // Pestaña 4: Finanzas & Tendencias
                      RefreshIndicator(
                        onRefresh: () async => _refreshAll(providerContext),
                        child: SingleChildScrollView(
                          physics: const AlwaysScrollableScrollPhysics(),
                          padding: const EdgeInsets.all(6),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              FinancialAndTrendsSection(),
                              SizedBox(height: 20),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _refreshAll(BuildContext context) {
    context.read<StatisticsCubit<WorkOrdersKeyStatisticEntity>>().load();
    context.read<StatisticsCubit<WorkOrderStatusStatisticEntity>>().load();
    context.read<StatisticsCubit<WorkOrderPriorityStatisticEntity>>().load();
    context.read<StatisticsCubit<WorkOrderTypeStatisticEntity>>().load();
  }
}

/// Contenido de la Pestaña 2: Dashboard Ejecutivo de Órdenes de Trabajo
class _WorkOrdersOverviewTab extends StatelessWidget {
  const _WorkOrdersOverviewTab();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final keyStatsState = context
        .watch<StatisticsCubit<WorkOrdersKeyStatisticEntity>>()
        .state;
    final statusState = context
        .watch<StatisticsCubit<WorkOrderStatusStatisticEntity>>()
        .state;
    final priorityState = context
        .watch<StatisticsCubit<WorkOrderPriorityStatisticEntity>>()
        .state;
    final typeState = context
        .watch<StatisticsCubit<WorkOrderTypeStatisticEntity>>()
        .state;

    final summary =
        keyStatsState is StatisticsLoaded<WorkOrdersKeyStatisticEntity>
        ? WorkOrdersKeyStatisticsSummary.fromRows(keyStatsState.items)
        : null;

    final statusItems =
        statusState is StatisticsLoaded<WorkOrderStatusStatisticEntity>
        ? statusState.items
        : <WorkOrderStatusStatisticEntity>[];

    final priorityItems =
        priorityState is StatisticsLoaded<WorkOrderPriorityStatisticEntity>
        ? priorityState.items
        : <WorkOrderPriorityStatisticEntity>[];

    final typeItems =
        typeState is StatisticsLoaded<WorkOrderTypeStatisticEntity>
        ? typeState.items
        : <WorkOrderTypeStatisticEntity>[];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Tarjetas superiores de KPIs
        Text(
          'Métricas Generales de Órdenes',
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 3,
          childAspectRatio: 1.25,
          mainAxisSpacing: 8,
          crossAxisSpacing: 8,
          children: [
            _MetricCard(
              title: 'Total Órdenes',
              value: summary?.totalOrders.toString() ?? '…',
              color: Colors.blue,
              icon: Icons.assignment_outlined,
            ),
            _MetricCard(
              title: 'Pendientes / Asignadas',
              value: summary?.pendingOrAssigned.toString() ?? '…',
              color: Colors.amber.shade800,
              icon: Icons.pending_actions_outlined,
            ),
            _MetricCard(
              title: 'En Progreso',
              value: summary?.inProgress.toString() ?? '…',
              color: Colors.cyan.shade700,
              icon: Icons.run_circle_outlined,
            ),
            _MetricCard(
              title: 'Críticas / Urgentes',
              value: summary != null
                  ? (summary.emergency + summary.urgent).toString()
                  : '…',
              color: Colors.red.shade700,
              icon: Icons.warning_amber_rounded,
            ),
            _MetricCard(
              title: 'Completadas',
              value: summary?.completed.toString() ?? '…',
              color: Colors.green.shade700,
              icon: Icons.check_circle_outline_rounded,
            ),
            _MetricCard(
              title: 'Tasa Cumplimiento',
              value: summary != null
                  ? '${summary.completionRate.toStringAsFixed(1)}%'
                  : '…',
              color: Colors.deepPurple,
              icon: Icons.task_alt_rounded,
            ),
          ],
        ),
        const SizedBox(height: 16),

        // Gráfico Donut de Estados
        Text(
          'Distribución por Estado',
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        _DonutChartCard(
          items: statusItems
              .map(
                (e) => _ChartItem(
                  label: e.statusName,
                  value: e.quantity,
                  percentage: e.percentageOfTotal,
                  color: _getStatusColor(e.statusId),
                ),
              )
              .toList(),
        ),
        const SizedBox(height: 16),

        // Gráfico Donut de Prioridades y SLA
        Text(
          'Distribución por Nivel de Prioridad y SLA',
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        _DonutChartCard(
          items: priorityItems
              .map(
                (e) => _ChartItem(
                  label: e.priorityLevel,
                  value: e.quantity,
                  percentage: e.percentageOfTotal,
                  color: _getPriorityColor(e.priorityLevel),
                ),
              )
              .toList(),
        ),
        const SizedBox(height: 16),

        // Rendimiento por Tipo de Trabajo
        Text(
          'Rendimiento por Tipo de Trabajo',
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: typeItems.take(6).length,
          separatorBuilder: (_, _) => const SizedBox(height: 6),
          itemBuilder: (context, index) {
            final t = typeItems[index];
            final pct = t.completionRatePercentage;

            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              decoration: BoxDecoration(
                color: isDark ? Colors.grey.shade900 : Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: isDark ? Colors.grey.shade800 : Colors.grey.shade200,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          t.workType,
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Text(
                        '${t.completed} de ${t.quantity} (${pct.toStringAsFixed(1)}%)',
                        style: TextStyle(
                          fontSize: 10,
                          color: isDark
                              ? Colors.grey.shade400
                              : Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(3),
                    child: LinearProgressIndicator(
                      value: (pct / 100).clamp(0.0, 1.0),
                      backgroundColor: Colors.grey.shade200,
                      color: Colors.blue.shade700,
                      minHeight: 4,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
        const SizedBox(height: 24),
      ],
    );
  }

  static Color _getStatusColor(String statusId) {
    switch (statusId.toUpperCase()) {
      case 'NOTIFICADA':
        return Colors.grey;
      case 'PENDIENTE':
        return Colors.amber.shade800;
      case 'ASIGNADA':
        return Colors.blue;
      case 'EN_PROGRESO':
        return Colors.cyan;
      case 'EN_ESPERA':
        return Colors.orange;
      case 'REANUDADA':
        return Colors.teal;
      case 'COMPLETADA':
        return Colors.green;
      case 'CANCELADA':
        return Colors.red;
      default:
        return Colors.blueGrey;
    }
  }

  static Color _getPriorityColor(String level) {
    switch (level.toLowerCase()) {
      case 'emergencia':
        return Colors.red.shade800;
      case 'urgente':
        return Colors.deepOrange;
      case 'alta':
        return Colors.amber.shade800;
      case 'media':
        return Colors.blue.shade700;
      case 'baja':
        return Colors.green.shade700;
      default:
        return Colors.grey;
    }
  }
}

class _ChartItem {
  final String label;
  final int value;
  final double percentage;
  final Color color;

  const _ChartItem({
    required this.label,
    required this.value,
    required this.percentage,
    required this.color,
  });
}

class _DonutChartCard extends StatelessWidget {
  final List<_ChartItem> items;

  const _DonutChartCard({required this.items});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (items.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isDark ? Colors.grey.shade900 : Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: isDark ? Colors.grey.shade800 : Colors.grey.shade300,
        ),
      ),
      child: Column(
        children: [
          SizedBox(
            height: 160,
            child: PieChart(
              PieChartData(
                sectionsSpace: 2,
                centerSpaceRadius: 36,
                sections: items.map((e) {
                  return PieChartSectionData(
                    value: e.value.toDouble(),
                    title: '',
                    color: e.color,
                    radius: 20,
                  );
                }).toList(),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 12,
            runSpacing: 6,
            children: items.map((e) {
              return Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: e.color,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '${e.label}: ${e.value} (${e.percentage.toStringAsFixed(1)}%)',
                    style: const TextStyle(fontSize: 10),
                  ),
                ],
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}

class _MetricCard extends StatelessWidget {
  final String title;
  final String value;
  final Color color;
  final IconData icon;

  const _MetricCard({
    required this.title,
    required this.value,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final effectiveColor = isDark
        ? Color.lerp(color, Colors.white, 0.2) ?? color
        : color;

    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: effectiveColor.withValues(alpha: isDark ? 0.15 : 0.08),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: effectiveColor.withValues(alpha: isDark ? 0.35 : 0.2),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 16, color: effectiveColor),
          const SizedBox(height: 2),
          Text(
            value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: effectiveColor,
            ),
          ),
          Text(
            title,
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 9,
              color: isDark ? Colors.grey.shade400 : Colors.grey.shade700,
            ),
          ),
        ],
      ),
    );
  }
}
