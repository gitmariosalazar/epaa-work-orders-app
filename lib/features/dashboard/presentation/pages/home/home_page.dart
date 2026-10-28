// features/dashboard/presentation/pages/home/home_page.dart

import 'package:auto_route/auto_route.dart';
import 'package:clean_architecture/core/constants/app_colors.dart';
import 'package:clean_architecture/core/constants/app_icons.dart';
import 'package:clean_architecture/core/services/session/session_service.dart';
import 'package:clean_architecture/features/dashboard/presentation/pages/home/widgets/close_app_dialog.dart';
import 'package:clean_architecture/routing/routes.gr.dart';
import 'package:clean_architecture/shared_ui/ui/base/app_bar/base_app_bar.dart';
import 'package:clean_architecture/shared_ui/ui/base/base_scaffold.dart';
import 'package:clean_architecture/shared_ui/ui/base_title.dart';
import 'package:clean_architecture/features/dashboard/domain/entities/work_order_statistics_entities.dart';
import 'package:clean_architecture/features/dashboard/domain/usecases/work_order_statistics_use_cases.dart';
import 'package:clean_architecture/features/dashboard/presentation/cubits/statistics/statistics_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

@RoutePage()
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<StatisticsCubit<WorkOrdersKeyStatisticEntity>>(
      create: (_) => StatisticsCubit<WorkOrdersKeyStatisticEntity>(
        GetIt.I<GetWorkOrdersKeyStatisticsUseCase>(),
      )..load(),
      child: Builder(builder: _buildContent),
    );
  }

  Widget _buildContent(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    // Métricas del dashboard (GET work-orders/get-work-orders-statistics-key)
    final statsState = context
        .watch<StatisticsCubit<WorkOrdersKeyStatisticEntity>>()
        .state;
    final summary = statsState is StatisticsLoaded<WorkOrdersKeyStatisticEntity>
        ? WorkOrdersKeyStatisticsSummary.fromRows(statsState.items)
        : null;
    String kpi(int? value) => switch (statsState) {
      StatisticsError<WorkOrdersKeyStatisticEntity>() => '—',
      _ when summary == null => '…',
      _ => value.toString(),
    };
    final totalOrders = kpi(summary?.totalOrders);
    final pendingOrders = kpi(summary?.pendingOrAssigned);
    final inProgressOrders = kpi(summary?.inProgress);
    final urgentOrders = kpi(
      summary == null ? null : summary.emergency + summary.urgent,
    );

    // Colores semánticos adaptados según el tema
    final blueColor = isDark ? const Color(0xFF64B5F6) : Colors.blue;
    final orangeColor = isDark ? const Color(0xFFFFB74D) : Colors.orange;
    final purpleColor = isDark ? const Color(0xFFBA68C8) : Colors.purple;
    final redColor = isDark ? const Color(0xFFEF5350) : Colors.red;

    return BaseScaffold(
      onPopInvokedWithResult: () => showCloseAppDialog(context),
      onRefresh: () async {
        await context
            .read<StatisticsCubit<WorkOrdersKeyStatisticEntity>>()
            .load();
        if (!context.mounted) return;
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Datos actualizados')));
      },
      appBar: BaseAppBar(
        leading: Icon(
          AppIcons.user,
          size: 20,
          color: isDark ? colorScheme.onSurface : AppColors.base,
        ),
        title: SessionUtil.I.fullName,
        titleFontWeight: FontWeight.w600,
        actions: [
          IconButton(
            icon: Icon(
              Icons.notifications_outlined,
              color: isDark ? colorScheme.onSurface : null,
            ),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Notificaciones - Próximamente')),
              );
            },
          ),
        ],
      ),
      isScrollable: true,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Órdenes de Trabajo ──────────────────────────────────
            _ActionSection(
              title: 'Órdenes de Trabajo',
              subtitle: 'Gestión, creación y seguimiento de OT',
              icon: Icons.assignment_rounded,
              color: isDark ? const Color(0xFF60A5FA) : const Color(0xFF2563EB),
              actions: [
                _DashboardButton(
                  icon: Icons.list_alt,
                  label: 'Órdenes',
                  color: isDark ? const Color(0xFF64B5F6) : Colors.blue,
                  onTap: () => context.router.push(const WorkOrdersHomeRoute()),
                ),
                _DashboardButton(
                  icon: Icons.add_task,
                  label: 'Crear Orden',
                  color: isDark ? const Color(0xFF81C784) : Colors.green,
                  onTap: () =>
                      context.router.push(const CreateWorkOrderRoute()),
                ),
                _DashboardButton(
                  icon: Icons.map,
                  label: 'Mapa',
                  color: isDark ? const Color(0xFF4DB6AC) : Colors.teal,
                  onTap: () => context.router.push(const WorkOrdersMapRoute()),
                ),
                _DashboardButton(
                  icon: Icons.dashboard,
                  label: 'Dashboards',
                  color: isDark ? const Color(0xFF9FA8DA) : Colors.indigo,
                  onTap: () => showMenuDashboardDialog(context),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // ── Incidencias ─────────────────────────────────────────
            _ActionSection(
              title: 'Incidencias',
              subtitle: 'Reporte y seguimiento de incidentes',
              icon: Icons.report_problem_rounded,
              color: isDark ? const Color(0xFFF87171) : const Color(0xFFDC2626),
              actions: [
                _DashboardButton(
                  icon: Icons.report,
                  label: 'Reportar Incid.',
                  color: isDark ? const Color(0xFFFF8A80) : Colors.redAccent,
                  onTap: () => context.router.push(CreateIncidentForm()),
                ),
                _DashboardButton(
                  icon: Icons.history,
                  label: 'Historial',
                  color: isDark ? const Color(0xFF90A4AE) : Colors.blueGrey,
                  onTap: () =>
                      context.router.push(const IncidentHistoryRoute()),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // ── Acometidas ──────────────────────────────────────────
            _ActionSection(
              title: 'Acometidas',
              subtitle: 'Búsqueda de conexiones y predios',
              icon: Icons.water_drop_rounded,
              color: isDark ? const Color(0xFF22D3EE) : const Color(0xFF0891B2),
              actions: [
                _DashboardButton(
                  icon: Icons.qr_code_scanner_rounded,
                  label: 'Escanear QR',
                  color: isDark ? const Color(0xFF82B1FF) : Colors.blueAccent,
                  onTap: () => context.router.push(const PropertyScanRoute()),
                ),
                _DashboardButton(
                  icon: Icons.edit_note_rounded,
                  label: 'Editar Medidor',
                  color: isDark ? const Color(0xFFB39DDB) : Colors.deepPurple,
                  onTap: () => context.router.push(
                    const ManualEntryConnectionWithPropertiesScreen(),
                  ),
                ),
                _DashboardButton(
                  icon: Icons.cable,
                  label: 'Acometidas',
                  color: isDark ? const Color(0xFF81C784) : Colors.green,
                  onTap: () => context.router.push(SearchConnectionRoute()),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // ── Recursos y configuración ────────────────────────────
            _ActionSection(
              title: 'Recursos',
              subtitle: 'Personal, materiales y ajustes',
              icon: Icons.inventory_2_rounded,
              color: isDark ? const Color(0xFFA78BFA) : const Color(0xFF7C3AED),
              actions: [
                _DashboardButton(
                  icon: Icons.people,
                  label: 'Trabajadores',
                  color: isDark ? const Color(0xFFCE93D8) : Colors.purple,
                  onTap: () => context.router.push(const WorkersHomeRoute()),
                ),
                _DashboardButton(
                  icon: Icons.inventory,
                  label: 'Materiales',
                  color: isDark ? const Color(0xFFFFB74D) : Colors.orange,
                  onTap: () =>
                      context.router.push(const ProductsMaterialsHomeRoute()),
                ),
                _DashboardButton(
                  icon: Icons.settings,
                  label: 'Ajustes',
                  color: isDark ? const Color(0xFFB0BEC5) : Colors.grey,
                  onTap: () => context.router.push(const SettingRoute()),
                ),
              ],
            ),
            const SizedBox(height: 20),
            BaseTitle(
              title: "Dashboard de Órdenes de Trabajo",
              color: isDark ? colorScheme.onSurface : null,
            ),
            const SizedBox(height: 20),

            // Tarjetas de resumen
            Row(
              children: [
                Expanded(
                  child: _SummaryCard(
                    title: 'Total',
                    value: totalOrders,
                    icon: Icons.assignment,
                    color: blueColor,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _SummaryCard(
                    title: 'Pendientes',
                    value: pendingOrders,
                    icon: Icons.schedule,
                    color: orangeColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _SummaryCard(
                    title: 'En Progreso',
                    value: inProgressOrders,
                    icon: Icons.handyman,
                    color: purpleColor,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _SummaryCard(
                    title: 'Urgentes',
                    value: urgentOrders,
                    icon: Icons.warning,
                    color: redColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  // Diálogo para navegar a los dashboards
  Future<void> showMenuDashboardDialog(BuildContext context) async {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    return showDialog<void>(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          backgroundColor: isDark
              ? colorScheme.surfaceContainerHighest
              : colorScheme.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(
              color: isDark ? colorScheme.outlineVariant : Colors.transparent,
            ),
          ),
          title: Text(
            'Selecciona un Dashboard',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: colorScheme.onSurface,
            ),
            textAlign: TextAlign.center,
          ),
          content: SizedBox(
            width: double.maxFinite,
            child: GridView.count(
              crossAxisCount: 3,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 1.0,
              children: [
                _DashboardButton(
                  icon: Icons.pie_chart,
                  label: 'Prioridades',
                  color: isDark ? const Color(0xFFEF5350) : Colors.red,
                  iconSize: 24,
                  labelFontSize: 9,
                  padding: const EdgeInsets.all(5),
                  onTap: () {
                    Navigator.of(dialogContext).pop();
                    context.router.push(const DashboardPrioritiesRoute());
                  },
                ),
                _DashboardButton(
                  icon: Icons.category,
                  label: 'Tipos Trabajo',
                  color: isDark ? const Color(0xFF64B5F6) : Colors.blue,
                  iconSize: 24,
                  labelFontSize: 9,
                  padding: const EdgeInsets.all(5),
                  onTap: () {
                    Navigator.of(dialogContext).pop();
                    context.router.push(const DashboardWorkTypesRoute());
                  },
                ),
                _DashboardButton(
                  icon: Icons.swap_vert,
                  label: 'Estados',
                  color: isDark ? const Color(0xFF81C784) : Colors.green,
                  iconSize: 24,
                  labelFontSize: 9,
                  padding: const EdgeInsets.all(5),
                  onTap: () {
                    Navigator.of(dialogContext).pop();
                    context.router.push(const DashboardWorkStatusRoute());
                  },
                ),
                _DashboardButton(
                  icon: Icons.list_alt,
                  label: 'Ordenes de Trabajo',
                  color: isDark ? const Color(0xFFBA68C8) : Colors.purple,
                  iconSize: 24,
                  labelFontSize: 9,
                  padding: const EdgeInsets.all(5),
                  onTap: () {
                    Navigator.of(dialogContext).pop();
                    context.router.push(const WorkOrdersDashboardRoute());
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: Text(
                'Cancelar',
                style: TextStyle(color: colorScheme.primary),
              ),
            ),
          ],
        );
      },
    );
  }
}

/// Sección agrupada de accesos rápidos (cabecera + grilla).
class _ActionSection extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final List<Widget> actions;

  const _ActionSection({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.actions,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    final backgroundColor = isDark
        ? colorScheme.surfaceContainerHighest
        : Colors.white;

    final borderColor = isDark
        ? color.withValues(alpha: 0.35)
        : color.withValues(alpha: 0.15);

    final shadowColor = isDark
        ? Colors.black.withValues(alpha: 0.35)
        : color.withValues(alpha: 0.08);

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: borderColor),
        boxShadow: [
          BoxShadow(
            color: shadowColor,
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [color, color.withValues(alpha: 0.7)],
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: Colors.white, size: 18),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: colorScheme.onSurface,
                      ),
                    ),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 11,
                        color: isDark
                            ? colorScheme.onSurfaceVariant
                            : Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: isDark ? 0.22 : 0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '${actions.length}',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: isDark
                        ? Color.lerp(color, Colors.white, 0.2) ?? color
                        : color,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          GridView.count(
            crossAxisCount: 3,
            shrinkWrap: true,
            padding: EdgeInsets.zero,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
            childAspectRatio: 1.15,
            children: actions,
          ),
        ],
      ),
    );
  }
}

/// Tarjetas de resumen métrico del dashboard
class _SummaryCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const _SummaryCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: color.withValues(alpha: isDark ? 0.18 : 0.10),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color.withValues(alpha: isDark ? 0.45 : 0.30),
        ),
      ),
      child: Column(
        children: [
          Icon(icon, size: 28, color: color),
          const SizedBox(height: 6),
          Text(
            value,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: isDark
                  ? Color.lerp(color, Colors.white, 0.15) ?? color
                  : color,
            ),
          ),
        ],
      ),
    );
  }
}

/// Botón estilizado para acciones rápidas en la grilla del Dashboard
class _DashboardButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;
  final double iconSize;
  final double labelFontSize;
  final EdgeInsetsGeometry padding;

  const _DashboardButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
    this.iconSize = 30.0,
    this.labelFontSize = 9.0,
    this.padding = const EdgeInsets.all(10),
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final effectiveColor = isDark
        ? (Color.lerp(color, Colors.white, 0.15) ?? color)
        : color;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: padding,
        decoration: BoxDecoration(
          color: effectiveColor.withValues(alpha: isDark ? 0.20 : 0.10),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: effectiveColor.withValues(alpha: isDark ? 0.45 : 0.30),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: iconSize, color: effectiveColor),
            const SizedBox(height: 6),
            Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: labelFontSize,
                color: effectiveColor,
                fontWeight: FontWeight.w600,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
