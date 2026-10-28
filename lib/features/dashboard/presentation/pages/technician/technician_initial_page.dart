// features/dashboard/presentation/pages/technician/technician_initial_page.dart

import 'package:auto_route/auto_route.dart';
import 'package:clean_architecture/core/utils/responsive/responsive_utils.dart';
import 'package:clean_architecture/features/dashboard/domain/usecases/executive_overview_use_cases.dart';
import 'package:clean_architecture/features/dashboard/domain/usecases/operations_analytics_use_cases.dart';
import 'package:clean_architecture/features/dashboard/domain/usecases/work_order_statistics_use_cases.dart';
import 'package:clean_architecture/features/dashboard/presentation/pages/technician/cubit/technician_initial_cubit.dart';
import 'package:clean_architecture/features/dashboard/presentation/pages/technician/cubit/technician_initial_state.dart';
import 'package:clean_architecture/features/dashboard/presentation/pages/technician/widgets/priority_task_card.dart';
import 'package:clean_architecture/features/dashboard/presentation/pages/technician/widgets/quick_actions_bar.dart';
import 'package:clean_architecture/features/dashboard/presentation/pages/technician/widgets/technician_header_section.dart';
import 'package:clean_architecture/features/dashboard/presentation/pages/technician/widgets/technician_kpi_card.dart';
import 'package:clean_architecture/features/dashboard/presentation/pages/technician/widgets/today_orders_section.dart';
import 'package:clean_architecture/features/work-orders/domain/usecases/get_all_work_order_use_case.dart';
import 'package:clean_architecture/routing/routes.gr.dart';
import 'package:clean_architecture/shared_ui/ui/base/base_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

@RoutePage()
class TechnicianInitialPage extends StatelessWidget {
  const TechnicianInitialPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TechnicianInitialCubit(
        getAllWorkOrdersUseCase: GetIt.I<GetAllWorkOrdersUseCase>(),
        getTechnicianDailyFeedUseCase:
            GetIt.I.isRegistered<GetTechnicianDailyFeedUseCase>()
            ? GetIt.I<GetTechnicianDailyFeedUseCase>()
            : null,
        getWorkOrderStatusStatisticsUseCase:
            GetIt.I.isRegistered<GetWorkOrderStatusStatisticsUseCase>()
            ? GetIt.I<GetWorkOrderStatusStatisticsUseCase>()
            : null,
        getHeaderKpisUseCase: GetIt.I.isRegistered<GetHeaderKpisUseCase>()
            ? GetIt.I<GetHeaderKpisUseCase>()
            : null,
      )..loadInitialData(),
      child: const _TechnicianInitialView(),
    );
  }
}

class _TechnicianInitialView extends StatelessWidget {
  const _TechnicianInitialView();

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
        child: BlocConsumer<TechnicianInitialCubit, TechnicianInitialState>(
          listener: (context, state) {
            if (state.errorMessage != null && state.errorMessage!.isNotEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.errorMessage!),
                  backgroundColor: Colors.red.shade700,
                  duration: const Duration(seconds: 3),
                ),
              );
            }
          },
          builder: (context, state) {
            final cubit = context.read<TechnicianInitialCubit>();

            return Column(
              children: [
                // 1. Header: Avatar, Saludo, Fecha, Campana (Fijo arriba, no se oculta al hacer scroll)
                const Padding(
                  padding: EdgeInsets.fromLTRB(16, 14, 16, 10),
                  child: TechnicianHeaderSection(),
                ),

                // Contenido principal scrolleable con pull-to-refresh
                Expanded(
                  child: state.isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : RefreshIndicator(
                          onRefresh: () => cubit.syncData(),
                          child: SingleChildScrollView(
                            physics: const AlwaysScrollableScrollPhysics(),
                            padding: const EdgeInsets.fromLTRB(16, 4, 16, 20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // 2. Tarjeta: KPI Rápido
                                TechnicianKpiCard(
                                  pendingCount: state.pendingCount,
                                  inProgressCount: state.inProgressCount,
                                  completedCount: state.completedCount,
                                  onPendingTap: () => context.router.push(
                                    const WorkOrdersHomeRoute(),
                                  ),
                                  onInProgressTap: () => context.router.push(
                                    const WorkOrdersHomeRoute(),
                                  ),
                                  onCompletedTap: () => context.router.push(
                                    const WorkOrdersHomeRoute(),
                                  ),
                                ),
                                const SizedBox(height: 20),

                                // 3. Tarea Prioritaria / En Curso
                                PriorityTaskCard(
                                  order: state.priorityOrder,
                                  onContinueOrder: (order) {
                                    context.router.push(
                                      WorkOrderProcessRoute(
                                        initialOrderCode: order.orderCode,
                                      ),
                                    );
                                  },
                                  onViewMap: (order) {
                                    context.router.push(
                                      WorkOrderMapRoute(order: order),
                                    );
                                  },
                                  onEmptyAction: () {
                                    context.router.push(
                                      const WorkOrdersHomeRoute(),
                                    );
                                  },
                                ),
                                const SizedBox(height: 20),

                                // 4. Acciones Rápidas
                                QuickActionsBar(
                                  isSyncing: state.isSyncing,
                                  onSearchTap: () => context.router.push(
                                    const WorkOrdersHomeRoute(),
                                  ),
                                  onNewOrderTap: () => context.router.push(
                                    const CreateWorkOrderRoute(),
                                  ),
                                  onSyncTap: () async {
                                    await cubit.syncData();
                                    if (context.mounted) {
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                            'Órdenes sincronizadas con éxito',
                                          ),
                                          duration: Duration(seconds: 2),
                                        ),
                                      );
                                    }
                                  },
                                ),
                                const SizedBox(height: 20),
                                Center(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisSize: MainAxisSize.min,
                                    spacing: context.width * 0.007,
                                    children: [
                                      TextButton.icon(
                                        onPressed: () => context.router.push(
                                          const HomeRoute(),
                                        ),
                                        icon: Icon(
                                          Icons.dashboard_customize_outlined,
                                          size: 16,
                                          color: cs.onSurfaceVariant,
                                        ),
                                        label: Text(
                                          'Panel General de Módulos',
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: cs.onSurfaceVariant,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        style: TextButton.styleFrom(
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              12,
                                            ),
                                            side: BorderSide(
                                              color: cs.onSurfaceVariant,
                                            ),
                                          ),
                                        ),
                                      ),
                                      TextButton.icon(
                                        onPressed: () => context.router.push(
                                          const GeneralDashboardRoute(),
                                        ),
                                        icon: Icon(
                                          Icons.analytics_outlined,
                                          size: 16,
                                          color: cs.onSurfaceVariant,
                                        ),
                                        label: Text(
                                          'Dashboard General',
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: cs.onSurfaceVariant,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        style: TextButton.styleFrom(
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              12,
                                            ),
                                            side: BorderSide(
                                              color: cs.onSurfaceVariant,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 20),

                                // 5. Órdenes de Hoy
                                TodayOrdersSection(
                                  orders: state.todayOrders,
                                  onViewAllTap: () => context.router.push(
                                    const WorkOrdersHomeRoute(),
                                  ),
                                  onOrderTap: (order) {
                                    context.router.push(
                                      WorkOrderDetailRoute(order: order),
                                    );
                                  },
                                ),
                                const SizedBox(height: 18),
                              ],
                            ),
                          ),
                        ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
