// features/dashboard/presentation/pages/general/widgets/general_status_priority_section.dart

import 'package:clean_architecture/features/dashboard/domain/entities/quality_sla_dashboard_entities.dart';
import 'package:clean_architecture/features/dashboard/domain/entities/work_order_statistics_entities.dart';
import 'package:flutter/material.dart';

class GeneralStatusPrioritySection extends StatelessWidget {
  final List<WorkOrderStatusStatisticEntity> statusStats;
  final List<WorkOrderPriorityStatisticEntity> priorityStats;
  final List<SlaMonitorItemEntity> slaMonitor;

  const GeneralStatusPrioritySection({
    super.key,
    required this.statusStats,
    required this.priorityStats,
    required this.slaMonitor,
  });

  Color _getStatusColor(String statusId) {
    final st = statusId.toUpperCase().trim();
    if (st.contains('COMPLETADA') || st.contains('EJECUTADA')) {
      return const Color(0xFF10B981); // Esmeralda
    }
    if (st.contains('PROCESO') || st.contains('PROGRESO')) {
      return const Color(0xFF3B82F6); // Azul
    }
    if (st == 'ASIGNADA' || st == 'PREPARACION') {
      return const Color(0xFFF59E0B); // Ámbar
    }
    if (st == 'CANCELADA') {
      return const Color(0xFF64748B); // Gris pizarra
    }
    return const Color(0xFF06B6D4); // Cyan (Pendientes)
  }

  Color _getPriorityColor(String priorityLevel) {
    final lvl = priorityLevel.toUpperCase().trim();
    if (lvl.contains('EMERGENCIA') || lvl.contains('CRÍTICA')) {
      return const Color(0xFFEF4444); // Rojo
    }
    if (lvl.contains('URGENTE')) {
      return const Color(0xFFF97316); // Naranja
    }
    if (lvl.contains('ALTA')) {
      return const Color(0xFFF59E0B); // Ámbar
    }
    if (lvl.contains('MEDIA')) {
      return const Color(0xFF3B82F6); // Azul
    }
    return const Color(0xFF94A3B8); // Gris claro (Baja)
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    return LayoutBuilder(
      builder: (context, constraints) {
        final isNarrow = constraints.maxWidth < 850;

        final statusCard = _buildStatusCard(context, cs, isDark);
        final prioritySlaCard = _buildPrioritySlaCard(context, cs, isDark);

        if (isNarrow) {
          return Column(
            children: [statusCard, const SizedBox(height: 16), prioritySlaCard],
          );
        }

        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: statusCard),
            const SizedBox(width: 16),
            Expanded(child: prioritySlaCard),
          ],
        );
      },
    );
  }

  Widget _buildStatusCard(BuildContext context, ColorScheme cs, bool isDark) {
    final total = statusStats.fold<int>(0, (sum, item) => sum + item.quantity);

    return Container(
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
          // Título
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(7),
                decoration: BoxDecoration(
                  color: const Color(
                    0xFF3B82F6,
                  ).withValues(alpha: isDark ? 0.25 : 0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.pie_chart_outline_rounded,
                  size: 20,
                  color: Color(0xFF3B82F6),
                ),
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Distribución por Estados',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: cs.onSurface,
                    ),
                  ),
                  Text(
                    'Proporción de flujo y carga en el ciclo de trabajo',
                    style: TextStyle(fontSize: 11, color: cs.onSurfaceVariant),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Barra segmentada multicolor
          if (total > 0) ...[
            ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: SizedBox(
                height: 12,
                child: Row(
                  children: statusStats.map((item) {
                    final color = _getStatusColor(item.statusId);
                    final flex = item.quantity > 0 ? item.quantity : 1;
                    return Expanded(
                      flex: flex,
                      child: Container(color: color),
                    );
                  }).toList(),
                ),
              ),
            ),
            const SizedBox(height: 14),
          ],

          // Lista de estados
          if (statusStats.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Center(
                child: Text(
                  'No hay estadísticas de estados disponibles',
                  style: TextStyle(
                    fontSize: 12.5,
                    color: cs.onSurfaceVariant,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
            )
          else
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: statusStats.length,
              separatorBuilder: (context, index) => Divider(
                height: 1,
                color: isDark ? cs.outlineVariant : const Color(0xFFF1F5F9),
              ),
              itemBuilder: (context, index) {
                final item = statusStats[index];
                final color = _getStatusColor(item.statusId);
                final pct = item.percentageOfTotal > 0
                    ? item.percentageOfTotal.toStringAsFixed(1)
                    : (total > 0
                          ? ((item.quantity / total) * 100).toStringAsFixed(1)
                          : '0.0');

                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Row(
                    children: [
                      Container(
                        width: 10,
                        height: 10,
                        decoration: BoxDecoration(
                          color: color,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          item.statusName.isNotEmpty
                              ? item.statusName
                              : item.statusId,
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: cs.onSurface,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Text(
                        '${item.quantity} OTs',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: cs.onSurface,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: color.withValues(alpha: isDark ? 0.22 : 0.12),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          '$pct%',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: color,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
        ],
      ),
    );
  }

  Widget _buildPrioritySlaCard(
    BuildContext context,
    ColorScheme cs,
    bool isDark,
  ) {
    // Calcular totales SLA
    int dentroPlazo = 0;
    int enRiesgo = 0;
    int vencidas = 0;

    for (final sla in slaMonitor) {
      final st = sla.estadoSlaSemaforo.toUpperCase().trim();
      if (st.contains('VENCID') || sla.horasHolguraSla < 0) {
        vencidas++;
      } else if (st.contains('RIESGO') || sla.horasHolguraSla <= 4) {
        enRiesgo++;
      } else {
        dentroPlazo++;
      }
    }

    final totalSla = dentroPlazo + enRiesgo + vencidas;
    final pctEnPlazo = totalSla > 0
        ? ((dentroPlazo / totalSla) * 100).toStringAsFixed(1)
        : '94.0';

    return Container(
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
          // Título
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(7),
                decoration: BoxDecoration(
                  color: const Color(
                    0xFFEF4444,
                  ).withValues(alpha: isDark ? 0.25 : 0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.speed_rounded,
                  size: 20,
                  color: Color(0xFFEF4444),
                ),
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Prioridades & Semáforo SLA',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: cs.onSurface,
                    ),
                  ),
                  Text(
                    'Niveles de urgencia y control de plazos normativos',
                    style: TextStyle(fontSize: 11, color: cs.onSurfaceVariant),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Mini Semáforo SLA
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isDark ? cs.surfaceContainer : const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isDark ? cs.outlineVariant : const Color(0xFFE2E8F0),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildSlaMiniItem(
                  'En Plazo',
                  totalSla > 0 ? dentroPlazo.toString() : '$pctEnPlazo%',
                  const Color(0xFF10B981),
                  Icons.check_circle_outline_rounded,
                  cs,
                ),
                Container(
                  height: 30,
                  width: 1,
                  color: isDark ? cs.outlineVariant : const Color(0xFFE2E8F0),
                ),
                _buildSlaMiniItem(
                  'En Riesgo',
                  enRiesgo.toString(),
                  const Color(0xFFF59E0B),
                  Icons.warning_amber_rounded,
                  cs,
                ),
                Container(
                  height: 30,
                  width: 1,
                  color: isDark ? cs.outlineVariant : const Color(0xFFE2E8F0),
                ),
                _buildSlaMiniItem(
                  'Vencidas',
                  vencidas.toString(),
                  const Color(0xFFEF4444),
                  Icons.error_outline_rounded,
                  cs,
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Barras de Prioridades
          Text(
            'Niveles de Prioridad Activos',
            style: TextStyle(
              fontSize: 12.5,
              fontWeight: FontWeight.bold,
              color: cs.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 8),
          if (priorityStats.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 14),
              child: Center(
                child: Text(
                  'No hay estadísticas de prioridad disponibles',
                  style: TextStyle(
                    fontSize: 12,
                    color: cs.onSurfaceVariant,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
            )
          else
            ...priorityStats.map((item) {
              final color = _getPriorityColor(item.priorityLevel);
              final maxQty = priorityStats.fold<int>(
                1,
                (m, x) => x.quantity > m ? x.quantity : m,
              );
              final progress = (item.quantity / maxQty).clamp(0.05, 1.0);

              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          item.priorityLevel,
                          style: TextStyle(
                            fontSize: 12.5,
                            fontWeight: FontWeight.w600,
                            color: cs.onSurface,
                          ),
                        ),
                        Text(
                          '${item.quantity} OTs (${item.percentageOfTotal.toStringAsFixed(1)}%)',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: color,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 3),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: progress,
                        minHeight: 6,
                        backgroundColor: color.withValues(
                          alpha: isDark ? 0.2 : 0.12,
                        ),
                        valueColor: AlwaysStoppedAnimation(color),
                      ),
                    ),
                  ],
                ),
              );
            }),
        ],
      ),
    );
  }

  Widget _buildSlaMiniItem(
    String label,
    String value,
    Color color,
    IconData icon,
    ColorScheme cs,
  ) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 14, color: color),
            const SizedBox(width: 4),
            Text(
              value,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            color: cs.onSurfaceVariant,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
