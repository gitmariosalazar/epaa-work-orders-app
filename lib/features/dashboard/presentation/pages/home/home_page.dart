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
import 'package:flutter/material.dart';

// features/dashboard/presentation/pages/home/home_page.dart

// ... tus imports permanecen iguales

@RoutePage()
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    // Datos de ejemplo
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

            // Tarjetas de resumen
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

            // Acciones rápidas - MÁS COMPACTAS
            BaseTitle(title: "Acciones Rápidas"),
            const SizedBox(height: 12),
            GridView.count(
              crossAxisCount: 3,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: 12, // reducido
              crossAxisSpacing: 12, // reducido
              childAspectRatio: 1.1, // más cuadrado (evita overflow)
              children: [
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
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Crear orden - Próximamente'),
                      ),
                    );
                  },
                ),
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
                  icon: Icons.map,
                  label: 'Mapa',
                  color: Colors.teal,
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Mapa - Próximamente')),
                    );
                  },
                ),
                _DashboardButton(
                  icon: Icons.bar_chart,
                  label: 'Reportes',
                  color: Colors.indigo,
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Reportes - Próximamente')),
                    );
                  },
                ),
                _DashboardButton(
                  icon: Icons.notifications_active,
                  label: 'Alertas',
                  color: Colors.red,
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Alertas - Próximamente')),
                    );
                  },
                ),
                _DashboardButton(
                  icon: Icons.history,
                  label: 'Historial',
                  color: Colors.brown,
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Historial - Próximamente')),
                    );
                  },
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
}

// Tarjetas de resumen (más pequeñas)
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

// Botones del grid - MÁS COMPACTOS
class _DashboardButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _DashboardButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(10), // reducido
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 30, color: color), // más pequeño
            const SizedBox(height: 6),
            Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 9, // más pequeño
                color: color,
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
