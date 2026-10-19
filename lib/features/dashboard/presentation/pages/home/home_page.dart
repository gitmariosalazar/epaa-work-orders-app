// features/dashboard/presentation/pages/home/home_page.dart
// TU CÓDIGO ORIGINAL 100% INTACTO + SOLO AÑADÍ UN BOTÓN PARA EL NUEVO DASHBOARD

import 'package:auto_route/auto_route.dart';
import 'package:clean_architecture/core/constants/app_colors.dart';
import 'package:clean_architecture/core/constants/app_icons.dart';
import 'package:clean_architecture/core/services/session/session_service.dart';
import 'package:clean_architecture/features/dashboard/presentation/pages/home/widgets/close_app_dialog.dart';
import 'package:clean_architecture/routing/routes.gr.dart';
import 'package:clean_architecture/shared_ui/ui/base/app_bar/base_app_bar.dart';
import 'package:clean_architecture/shared_ui/ui/base/base_scaffold.dart';
import 'package:clean_architecture/shared_ui/ui/base_title.dart';
import 'package:flutter/material.dart';

@RoutePage()
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    // Tus datos originales
    final totalOrders = 156;
    final pendingOrders = 23;
    final inProgressOrders = 45;
    final urgentOrders = 8;

    return BaseScaffold(
      onPopInvokedWithResult: () => showCloseAppDialog(context),
      onRefresh: () async {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Datos actualizados')));
      },
      appBar: BaseAppBar(
        leading: const Icon(AppIcons.user, size: 20, color: AppColors.base),
        title: SessionUtil.I.fullName,
        titleFontWeight: FontWeight.w600,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
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
            BaseTitle(title: "Dashboard de Órdenes de Trabajo"),
            const SizedBox(height: 20),

            // Tarjetas de resumen (originales)
            Row(
              children: [
                Expanded(
                  child: _SummaryCard(
                    title: 'Total',
                    value: totalOrders.toString(),
                    icon: Icons.assignment,
                    color: Colors.blue,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _SummaryCard(
                    title: 'Pendientes',
                    value: pendingOrders.toString(),
                    icon: Icons.schedule,
                    color: Colors.orange,
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
                    value: inProgressOrders.toString(),
                    icon: Icons.handyman,
                    color: Colors.purple,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _SummaryCard(
                    title: 'Urgentes',
                    value: urgentOrders.toString(),
                    icon: Icons.warning,
                    color: Colors.red,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),

            // ── Órdenes de Trabajo ──────────────────────────────────
            _ActionSection(
              title: 'Órdenes de Trabajo ',
              subtitle: 'Gestión, creación y seguimiento de OT',
              icon: Icons.assignment_rounded,
              color: const Color(0xFF2563EB),
              actions: [
                _DashboardButton(
                  icon: Icons.list_alt,
                  label: 'Órdenes',
                  color: Colors.blue,
                  onTap: () => context.router.push(const WorkOrdersHomeRoute()),
                ),
                _DashboardButton(
                  icon: Icons.add_task,
                  label: 'Crear Orden',
                  color: Colors.green,
                  onTap: () =>
                      context.router.push(const CreateWorkOrderRoute()),
                ),
                _DashboardButton(
                  icon: Icons.map,
                  label: 'Mapa',
                  color: Colors.teal,
                  onTap: () => context.router.push(const WorkOrdersMapRoute()),
                ),
                _DashboardButton(
                  icon: Icons.dashboard,
                  label: 'Dashboards',
                  color: Colors.indigo,
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
              color: const Color(0xFFDC2626),
              actions: [
                _DashboardButton(
                  icon: Icons.report,
                  label: 'Reportar Incid.',
                  color: Colors.redAccent,
                  onTap: () => context.router.push(CreateIncidentForm()),
                ),
                _DashboardButton(
                  icon: Icons.history,
                  label: 'Historial',
                  color: Colors.blueGrey,
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
              color: const Color(0xFF0891B2),
              actions: [
                _DashboardButton(
                  icon: Icons.qr_code_scanner_rounded,
                  label: 'Escanear QR',
                  color: Colors.blueAccent,
                  onTap: () => context.router.push(const PropertyScanRoute()),
                ),
                _DashboardButton(
                  icon: Icons.edit_note_rounded,
                  label: 'Editar Medidor',
                  color: Colors.deepPurple,
                  onTap: () => context.router.push(
                    const ManualEntryConnectionWithPropertiesScreen(),
                  ),
                ),
                _DashboardButton(
                  icon: Icons.cable,
                  label: 'Acometidas',
                  color: Colors.green,
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
              color: const Color(0xFF7C3AED),
              actions: [
                _DashboardButton(
                  icon: Icons.people,
                  label: 'Trabajadores',
                  color: Colors.purple,
                  onTap: () => context.router.push(const WorkersHomeRoute()),
                ),
                _DashboardButton(
                  icon: Icons.inventory,
                  label: 'Materiales',
                  color: Colors.orange,
                  onTap: () =>
                      context.router.push(const ProductsMaterialsHomeRoute()),
                ),
                _DashboardButton(
                  icon: Icons.settings,
                  label: 'Ajustes',
                  color: Colors.grey,
                  onTap: () => context.router.push(const SettingRoute()),
                ),
              ],
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  // Dialog for go to dashboards
  Future<void> showMenuDashboardDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Selecciona un Dashboard',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            textAlign: TextAlign.center,
          ),
          content: SizedBox(
            width: double
                .maxFinite, // Importante: permite que el diálogo use todo el ancho disponible
            child: GridView.count(
              crossAxisCount: 3,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio:
                  1.0, // ← Cambiado a 1.0 → cuadrado, evita overflow
              children: [
                _DashboardButton(
                  icon: Icons.pie_chart,
                  label: 'Prioridades',
                  color: Colors.red,
                  iconSize: 24,
                  labelFontSize: 9,
                  padding: const EdgeInsets.all(5),
                  onTap: () {
                    Navigator.of(context).pop(); // Cierra el diálogo
                    context.router.push(const DashboardPrioritiesRoute());
                  },
                ),
                _DashboardButton(
                  icon: Icons.category,
                  label: 'Tipos Trabajo',
                  color: Colors.blue,
                  iconSize: 24,
                  labelFontSize: 9,
                  padding: const EdgeInsets.all(5),
                  onTap: () {
                    Navigator.of(context).pop();
                    context.router.push(const DashboardWorkTypesRoute());
                  },
                ),
                _DashboardButton(
                  icon: Icons.swap_vert,
                  label: 'Estados',
                  color: Colors.green,
                  iconSize: 24,
                  labelFontSize: 9,
                  padding: const EdgeInsets.all(5),
                  onTap: () {
                    Navigator.of(context).pop();
                    context.router.push(const DashboardWorkStatusRoute());
                  },
                ),
                _DashboardButton(
                  icon: Icons.list_alt,
                  label: 'Ordenes de Trabajo',
                  color: Colors.purple,
                  iconSize: 24,
                  labelFontSize: 9,
                  padding: const EdgeInsets.all(5),
                  onTap: () {
                    Navigator.of(context).pop();
                    context.router.push(const WorkOrdersDashboardRoute());
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancelar'),
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
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: color.withValues(alpha: 0.15)),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.08),
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
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '${actions.length}',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: color,
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

// Tus widgets originales (sin tocar)
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
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
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
          Text(title, style: TextStyle(fontSize: 11, color: color)),
        ],
      ),
    );
  }
}

class _DashboardButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  // Parámetros opcionales con valores por defecto coherentes con tu diseño actual
  final double iconSize;
  final double labelFontSize;
  final FontWeight labelFontWeight;
  final int maxLines;
  final EdgeInsetsGeometry padding;
  final double borderOpacity;
  final double backgroundOpacity;
  final double borderRadiusValue;

  const _DashboardButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
    this.iconSize = 30.0,
    this.labelFontSize = 9.0,
    this.labelFontWeight = FontWeight.w600,
    this.maxLines = 2,
    this.padding = const EdgeInsets.all(10),
    this.borderOpacity = 0.3,
    this.backgroundOpacity = 0.1,
    this.borderRadiusValue = 12.0,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(borderRadiusValue),
      child: Container(
        padding: padding,
        decoration: BoxDecoration(
          color: color.withOpacity(backgroundOpacity),
          borderRadius: BorderRadius.circular(borderRadiusValue),
          border: Border.all(color: color.withOpacity(borderOpacity)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: iconSize, color: color),
            const SizedBox(height: 6),
            Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: labelFontSize,
                color: color,
                fontWeight: labelFontWeight,
              ),
              maxLines: maxLines,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
