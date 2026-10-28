// features/dashboard/presentation/pages/general/widgets/general_funnel_section.dart

import 'package:clean_architecture/features/dashboard/domain/entities/incident_vs_work_order_entities.dart';
import 'package:clean_architecture/routing/routes.gr.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

class GeneralFunnelSection extends StatelessWidget {
  final FunnelSummaryEntity? funnelSummary;

  const GeneralFunnelSection({super.key, required this.funnelSummary});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    final incidentes = funnelSummary?.totalReportesIngresados ?? 0;
    final convertidos = funnelSummary?.reportesConOrdenTrabajo ?? 0;
    final completadas = funnelSummary?.otCompletadasResueltas ?? 0;
    final conversionPct =
        funnelSummary?.pctTasaConversionAOt?.toStringAsFixed(1) ??
        (incidentes > 0
            ? ((convertidos / incidentes) * 100).toStringAsFixed(1)
            : '0.0');
    final resolucionPct =
        funnelSummary?.pctTasaResolucionGlobal?.toStringAsFixed(1) ??
        (convertidos > 0
            ? ((completadas / convertidos) * 100).toStringAsFixed(1)
            : '0.0');
    final diasPromedio =
        funnelSummary?.horasPromedioCicloCompletoResolucion != null
        ? (funnelSummary!.horasPromedioCicloCompletoResolucion! / 24.0)
              .toStringAsFixed(1)
        : '1.8';
    final discrepancias = funnelSummary?.reportesEnTriajeSinOt ?? 0;

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
          // Encabezado del Embudo
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(7),
                    decoration: BoxDecoration(
                      color: const Color(
                        0xFF6366F1,
                      ).withValues(alpha: isDark ? 0.25 : 0.12),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(
                      Icons.filter_alt_outlined,
                      size: 20,
                      color: Color(0xFF6366F1),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Operativo: Incidentes ➔ OTs ➔ Solución',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: cs.onSurface,
                        ),
                      ),
                      Text(
                        'Eficiencia del ciclo y tasas de conversión',
                        style: TextStyle(
                          fontSize: 11,
                          color: cs.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              TextButton.icon(
                onPressed: () =>
                    context.router.push(const WorkOrdersDashboardRoute()),
                icon: const Icon(Icons.arrow_forward_rounded, size: 14),
                label: const Text('Detalle'),
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  textStyle: const TextStyle(fontSize: 12),
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),

          // Flujo Visual por Etapas
          LayoutBuilder(
            builder: (context, constraints) {
              final isNarrow = constraints.maxWidth < 700;

              final steps = [
                _FunnelStepData(
                  stepNumber: '1',
                  label: 'Incidentes Reportados',
                  value: incidentes.toString(),
                  icon: Icons.report_problem_outlined,
                  color: const Color(0xFFF97316), // Naranja
                ),
                _FunnelStepData(
                  stepNumber: '2',
                  label: 'Asignadas OT',
                  value: convertidos.toString(),
                  badgeText: '$conversionPct% Conv.',
                  icon: Icons.assignment_outlined,
                  color: const Color(0xFF3B82F6), // Azul
                ),
                _FunnelStepData(
                  stepNumber: '3',
                  label: 'OTs Resueltas en Campo',
                  value: completadas.toString(),
                  badgeText: '$resolucionPct% Resuelto',
                  icon: Icons.task_alt_rounded,
                  color: const Color(0xFF10B981), // Verde
                ),
              ];

              if (isNarrow) {
                return Column(
                  children: steps
                      .map(
                        (step) => Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: _FunnelStepCard(data: step, isDark: isDark),
                        ),
                      )
                      .toList(),
                );
              }

              return Row(
                children: [
                  Expanded(
                    child: _FunnelStepCard(data: steps[0], isDark: isDark),
                  ),
                  const SizedBox(width: 8),
                  Icon(
                    Icons.keyboard_double_arrow_right_rounded,
                    color: cs.onSurfaceVariant.withValues(alpha: 0.5),
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _FunnelStepCard(data: steps[1], isDark: isDark),
                  ),
                  const SizedBox(width: 8),
                  Icon(
                    Icons.keyboard_double_arrow_right_rounded,
                    color: cs.onSurfaceVariant.withValues(alpha: 0.5),
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _FunnelStepCard(data: steps[2], isDark: isDark),
                  ),
                ],
              );
            },
          ),
          const SizedBox(height: 14),

          // Métricas Secundarias Inferiores (Días de ciclo y discrepancias)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: isDark ? cs.surfaceContainer : const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isDark ? cs.outlineVariant : const Color(0xFFE2E8F0),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.timer_outlined, size: 16, color: cs.primary),
                    const SizedBox(width: 6),
                    Text(
                      'Tiempo promedio de resolución: ',
                      style: TextStyle(
                        fontSize: 12,
                        color: cs.onSurfaceVariant,
                      ),
                    ),
                    Text(
                      '$diasPromedio días',
                      style: TextStyle(
                        fontSize: 12.5,
                        fontWeight: FontWeight.bold,
                        color: cs.onSurface,
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: discrepancias > 0
                        ? const Color(0xFFEF4444).withValues(alpha: 0.15)
                        : const Color(0xFF10B981).withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    discrepancias > 0
                        ? '$discrepancias discrepancias'
                        : 'Flujo 100% Sincronizado',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: discrepancias > 0
                          ? const Color(0xFFEF4444)
                          : const Color(0xFF10B981),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _FunnelStepData {
  final String stepNumber;
  final String label;
  final String value;
  final String? badgeText;
  final IconData icon;
  final Color color;

  const _FunnelStepData({
    required this.stepNumber,
    required this.label,
    required this.value,
    this.badgeText,
    required this.icon,
    required this.color,
  });
}

class _FunnelStepCard extends StatelessWidget {
  final _FunnelStepData data;
  final bool isDark;

  const _FunnelStepCard({required this.data, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isDark ? cs.surfaceContainer : Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: data.color.withValues(alpha: isDark ? 0.35 : 0.2),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: data.color.withValues(alpha: isDark ? 0.25 : 0.12),
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Icon(data.icon, size: 18, color: data.color),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      data.value,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: cs.onSurface,
                      ),
                    ),
                    if (data.badgeText != null)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: data.color.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          data.badgeText!,
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: data.color,
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  data.label,
                  style: TextStyle(
                    fontSize: 11.5,
                    color: cs.onSurfaceVariant,
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
