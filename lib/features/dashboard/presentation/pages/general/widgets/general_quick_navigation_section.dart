// features/dashboard/presentation/pages/general/widgets/general_quick_navigation_section.dart

import 'package:clean_architecture/routing/routes.gr.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

class GeneralQuickNavigationSection extends StatelessWidget {
  const GeneralQuickNavigationSection({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    final modules = [
      _ModuleLinkData(
        title: 'Incidentes vs OTs',
        subtitle: 'Matriz cruzada y embudo por canal',
        icon: Icons.compare_arrows_rounded,
        color: const Color(0xFF6366F1), // Indigo
        onTap: () => context.router.push(const WorkOrdersDashboardRoute()),
      ),
      _ModuleLinkData(
        title: 'Despacho & Técnicos',
        subtitle: 'Capacidad de Técnicos y balance',
        icon: Icons.alt_route_rounded,
        color: const Color(0xFFF59E0B), // Ámbar
        onTap: () => context.router.push(const WorkOrdersDashboardRoute()),
      ),
      _ModuleLinkData(
        title: 'Calidad & Auditoría SLA',
        subtitle: 'Control normativo y semáforo',
        icon: Icons.verified_user_outlined,
        color: const Color(0xFF10B981), // Verde
        onTap: () => context.router.push(const WorkOrdersDashboardRoute()),
      ),
      _ModuleLinkData(
        title: 'Financiero & Costos',
        subtitle: 'Presupuesto, materiales y mapa',
        icon: Icons.attach_money_rounded,
        color: const Color(0xFF06B6D4), // Cyan
        onTap: () => context.router.push(const WorkOrdersDashboardRoute()),
      ),
      _ModuleLinkData(
        title: 'Portal de Técnico',
        subtitle: 'Vista móvil del técnico en campo',
        icon: Icons.assignment_ind_outlined,
        color: const Color(0xFF8B5CF6), // Violeta
        onTap: () => context.router.push(const TechnicianInitialRoute()),
      ),
    ];

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: isDark ? cs.surfaceContainerHighest : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark ? cs.outlineVariant : const Color(0xFFE2E8F0),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.25 : 0.04),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(7),
                decoration: BoxDecoration(
                  color: const Color(
                    0xFF8B5CF6,
                  ).withValues(alpha: isDark ? 0.25 : 0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.explore_outlined,
                  size: 20,
                  color: Color(0xFF8B5CF6),
                ),
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Navegación & Módulos Especializados',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: cs.onSurface,
                    ),
                  ),
                  Text(
                    'Acceso rápido a los tableros específicos de operación',
                    style: TextStyle(fontSize: 11, color: cs.onSurfaceVariant),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          LayoutBuilder(
            builder: (context, constraints) {
              final width = constraints.maxWidth;
              int crossAxisCount = 5;
              if (width < 600) {
                crossAxisCount = 1;
              } else if (width < 900) {
                crossAxisCount = 2;
              } else if (width < 1250) {
                crossAxisCount = 3;
              }

              return GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: modules.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: crossAxisCount,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  mainAxisExtent: 80,
                ),
                itemBuilder: (context, index) {
                  final item = modules[index];

                  return InkWell(
                    onTap: item.onTap,
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: isDark
                            ? cs.surfaceContainer
                            : const Color(0xFFF8FAFC),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isDark
                              ? cs.outlineVariant
                              : const Color(0xFFE2E8F0),
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 36,
                            height: 36,
                            decoration: BoxDecoration(
                              color: item.color.withValues(
                                alpha: isDark ? 0.22 : 0.12,
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            alignment: Alignment.center,
                            child: Icon(item.icon, size: 20, color: item.color),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  item.title,
                                  style: TextStyle(
                                    fontSize: 12.5,
                                    fontWeight: FontWeight.bold,
                                    color: cs.onSurface,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  item.subtitle,
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: cs.onSurfaceVariant,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                          Icon(
                            Icons.chevron_right_rounded,
                            size: 18,
                            color: cs.onSurfaceVariant.withValues(alpha: 0.6),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}

class _ModuleLinkData {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _ModuleLinkData({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.onTap,
  });
}
