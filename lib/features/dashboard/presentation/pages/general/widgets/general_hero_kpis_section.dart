// features/dashboard/presentation/pages/general/widgets/general_hero_kpis_section.dart

import 'package:clean_architecture/features/dashboard/domain/entities/executive_overview_entity.dart';
import 'package:clean_architecture/features/dashboard/domain/entities/work_order_statistics_entities.dart';
import 'package:flutter/material.dart';

class GeneralHeroKpisSection extends StatelessWidget {
  final HeaderKpisEntity? headerKpis;
  final List<WorkOrderStatusStatisticEntity> statusStats;
  final List<WorkOrderPriorityStatisticEntity> priorityStats;

  const GeneralHeroKpisSection({
    super.key,
    required this.headerKpis,
    required this.statusStats,
    required this.priorityStats,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    // Métricas reales
    int total = headerKpis?.totalOrders ?? 0;
    int inProgress = headerKpis?.inProgress ?? 0;
    int pending = headerKpis?.pendingOrAssigned ?? 0;
    int completed = headerKpis?.completed ?? 0;
    int critical = (headerKpis?.emergency ?? 0) + (headerKpis?.urgent ?? 0);

    // Si headerKpis aún no vino, deducir de statusStats / priorityStats
    if (total == 0 && statusStats.isNotEmpty) {
      int p = 0;
      int ip = 0;
      int c = 0;
      for (final s in statusStats) {
        final id = s.statusId.toUpperCase().trim();
        final name = s.statusName.toUpperCase().trim();
        total += s.quantity;
        if (id.contains('COMPLETADA') ||
            id.contains('EJECUTADA') ||
            name.contains('COMPLETADA')) {
          c += s.quantity;
        } else if (id.contains('PROCESO') ||
            id == 'ASIGNADA' ||
            id == 'PREPARACION' ||
            name.contains('PROCESO')) {
          ip += s.quantity;
        } else {
          p += s.quantity;
        }
      }
      pending = p;
      inProgress = ip;
      completed = c;
    }

    if (critical == 0 && priorityStats.isNotEmpty) {
      for (final pr in priorityStats) {
        final lvl = pr.priorityLevel.toUpperCase().trim();
        if (lvl.contains('EMERGENCIA') ||
            lvl.contains('URGENTE') ||
            pr.priorityId >= 4) {
          critical += pr.quantity;
        }
      }
    }

    final completionPct = total > 0
        ? ((completed / total) * 100).toStringAsFixed(1)
        : (headerKpis?.completionRate?.toStringAsFixed(1) ?? '0.0');

    final cards = [
      _HeroCardData(
        title: 'Total Órdenes',
        value: total.toString(),
        subtitle: 'Registradas globales',
        badgeText: 'Base Global',
        icon: Icons.assignment_outlined,
        accentColor: const Color(0xFF3B82F6), // Azul
        isDark: isDark,
      ),
      _HeroCardData(
        title: 'En Ejecución',
        value: inProgress.toString(),
        subtitle: 'Técnicos en campo',
        badgeText: 'Activas Hoy',
        icon: Icons.engineering_rounded,
        accentColor: const Color(0xFFF59E0B), // Ámbar
        isDark: isDark,
        showPulse: true,
      ),
      _HeroCardData(
        title: 'Pendientes',
        value: pending.toString(),
        subtitle: 'Backlog por atender',
        badgeText: 'Por Despachar',
        icon: Icons.hourglass_top_rounded,
        accentColor: const Color(0xFF06B6D4), // Cyan
        isDark: isDark,
      ),
      _HeroCardData(
        title: 'Completadas',
        value: completed.toString(),
        subtitle: '$completionPct% tasa de éxito',
        badgeText: '$completionPct%',
        icon: Icons.task_alt_rounded,
        accentColor: const Color(0xFF10B981), // Esmeralda
        isDark: isDark,
        progressValue: total > 0 ? (completed / total).clamp(0.0, 1.0) : 0.0,
      ),
      _HeroCardData(
        title: 'Críticas / Urgentes',
        value: critical.toString(),
        subtitle: 'Atención prioritaria',
        badgeText: critical > 0 ? 'Prioridad 4/5' : 'Bajo control',
        icon: Icons.warning_amber_rounded,
        accentColor: const Color(0xFFEF4444), // Rojo
        isDark: isDark,
      ),
    ];

    return LayoutBuilder(
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
          itemCount: cards.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            mainAxisExtent: 140,
          ),
          itemBuilder: (context, index) {
            return _HeroCardWidget(data: cards[index]);
          },
        );
      },
    );
  }
}

class _HeroCardData {
  final String title;
  final String value;
  final String subtitle;
  final String badgeText;
  final IconData icon;
  final Color accentColor;
  final bool isDark;
  final bool showPulse;
  final double? progressValue;

  const _HeroCardData({
    required this.title,
    required this.value,
    required this.subtitle,
    required this.badgeText,
    required this.icon,
    required this.accentColor,
    required this.isDark,
    this.showPulse = false,
    this.progressValue,
  });
}

class _HeroCardWidget extends StatelessWidget {
  final _HeroCardData data;

  const _HeroCardWidget({required this.data});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final isDark = data.isDark;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? cs.surfaceContainerHighest : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: data.accentColor.withValues(alpha: isDark ? 0.35 : 0.25),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.25 : 0.04),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Fila superior: Icono badge y Tag
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: data.accentColor.withValues(
                    alpha: isDark ? 0.25 : 0.12,
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                alignment: Alignment.center,
                child: Icon(data.icon, size: 20, color: data.accentColor),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                decoration: BoxDecoration(
                  color: data.accentColor.withValues(
                    alpha: isDark ? 0.18 : 0.08,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (data.showPulse) ...[
                      Container(
                        width: 6,
                        height: 6,
                        decoration: BoxDecoration(
                          color: data.accentColor,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 4),
                    ],
                    Text(
                      data.badgeText,
                      style: TextStyle(
                        fontSize: 10.5,
                        fontWeight: FontWeight.bold,
                        color: data.accentColor,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          // Número central grande
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                data.value,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                  color: cs.onSurface,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 1),
              Text(
                data.title,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: cs.onSurfaceVariant,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),

          // Subtítulo inferior o Barra de Progreso
          if (data.progressValue != null)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: data.progressValue,
                    minHeight: 5,
                    backgroundColor: data.accentColor.withValues(
                      alpha: isDark ? 0.2 : 0.12,
                    ),
                    valueColor: AlwaysStoppedAnimation(data.accentColor),
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  data.subtitle,
                  style: TextStyle(
                    fontSize: 10.5,
                    color: cs.onSurfaceVariant,
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            )
          else
            Text(
              data.subtitle,
              style: TextStyle(
                fontSize: 10.5,
                color: cs.onSurfaceVariant,
                fontWeight: FontWeight.w500,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
        ],
      ),
    );
  }
}
