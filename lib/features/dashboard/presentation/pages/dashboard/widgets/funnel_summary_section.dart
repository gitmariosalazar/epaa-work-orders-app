// features/dashboard/presentation/pages/dashboard/widgets/funnel_summary_section.dart

import 'package:clean_architecture/features/dashboard/domain/entities/incident_vs_work_order_entities.dart';
import 'package:clean_architecture/features/dashboard/domain/usecases/incident_analytics_use_cases.dart';
import 'package:clean_architecture/features/dashboard/presentation/cubits/single_item/single_item_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';

class FunnelSummarySection extends StatelessWidget {
  const FunnelSummarySection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<SingleItemCubit<FunnelSummaryEntity>>(
      create: (_) => SingleItemCubit<FunnelSummaryEntity>(
        GetIt.I<GetFunnelSummaryUseCase>(),
      )..load(),
      child: const _FunnelSummaryContent(),
    );
  }
}

class _FunnelSummaryContent extends StatelessWidget {
  const _FunnelSummaryContent();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return BlocBuilder<
      SingleItemCubit<FunnelSummaryEntity>,
      SingleItemState<FunnelSummaryEntity>
    >(
      builder: (context, state) {
        if (state is SingleItemLoading<FunnelSummaryEntity>) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(32.0),
              child: CircularProgressIndicator(),
            ),
          );
        }

        if (state is SingleItemError<FunnelSummaryEntity>) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  const Icon(Icons.error_outline, color: Colors.red, size: 36),
                  const SizedBox(height: 8),
                  Text(
                    state.message,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 13),
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton.icon(
                    onPressed: () => context
                        .read<SingleItemCubit<FunnelSummaryEntity>>()
                        .load(),
                    icon: const Icon(Icons.refresh, size: 16),
                    label: const Text('Reintentar'),
                  ),
                ],
              ),
            ),
          );
        }

        final data = state is SingleItemLoaded<FunnelSummaryEntity>
            ? state.data
            : FunnelSummaryEntity.empty;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Título de la sección
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Trazabilidad: Incidentes vs Órdenes de Trabajo',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Embudo operativo de conversión y tiempos de resolución',
                      style: TextStyle(
                        fontSize: 11,
                        color: isDark
                            ? Colors.grey.shade400
                            : Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
                IconButton(
                  icon: const Icon(Icons.refresh, size: 20),
                  tooltip: 'Actualizar embudo',
                  onPressed: () => context
                      .read<SingleItemCubit<FunnelSummaryEntity>>()
                      .load(),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Grid con las 6 etapas del embudo
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 3,
              childAspectRatio: 1.15,
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
              children: [
                _FunnelCard(
                  title: 'Total Reportes',
                  value: data.totalReportesIngresados,
                  badge: '100%',
                  color: Colors.blue,
                  icon: Icons.campaign_rounded,
                ),
                _FunnelCard(
                  title: 'Por Evaluar (Sin OT)',
                  value: data.reportesEnTriajeSinOt,
                  color: Colors.amber.shade800,
                  icon: Icons.pending_actions_rounded,
                ),
                _FunnelCard(
                  title: 'Asignadas OT',
                  value: data.reportesConOrdenTrabajo,
                  badge:
                      '${data.pctTasaConversionAOt?.toStringAsFixed(1) ?? '0'}%',
                  color: Colors.indigo,
                  icon: Icons.assignment_turned_in_rounded,
                ),
                _FunnelCard(
                  title: 'Asignadas a Técnicos',
                  value: data.otAsignadasACuadrilla,
                  color: Colors.cyan.shade700,
                  icon: Icons.engineering_rounded,
                ),
                _FunnelCard(
                  title: 'En Proceso en Campo',
                  value: data.otEnProcesoEjecucion,
                  color: Colors.deepOrange,
                  icon: Icons.build_circle_rounded,
                ),
                _FunnelCard(
                  title: 'Completadas / Resueltas',
                  value: data.otCompletadasResueltas,
                  badge:
                      '${data.pctTasaResolucionGlobal?.toStringAsFixed(1) ?? '0'}%',
                  color: Colors.green.shade700,
                  icon: Icons.check_circle_rounded,
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Tiempos promedio de atención (Lead Time)
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isDark
                    ? theme.colorScheme.surfaceContainerHighest.withValues(
                        alpha: 0.3,
                      )
                    : Colors.grey.shade100,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isDark ? Colors.grey.shade800 : Colors.grey.shade300,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.timer_outlined,
                        size: 16,
                        color: theme.colorScheme.primary,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        'Tiempos Promedio de Ciclo Operativo',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: _MetricTimeItem(
                          label: 'Evaluación a Creación OT',
                          hours: data.horasPromedioTriajeACreacionOt,
                        ),
                      ),
                      Expanded(
                        child: _MetricTimeItem(
                          label: 'Asignación a Técnico',
                          hours: data.horasPromedioAsignacionTecnico,
                        ),
                      ),
                      Expanded(
                        child: _MetricTimeItem(
                          label: 'Ejecución en Campo',
                          hours: data.horasPromedioEjecucionCampo,
                        ),
                      ),
                      Expanded(
                        child: _MetricTimeItem(
                          label: 'Ciclo Completo Total',
                          hours: data.horasPromedioCicloCompletoResolucion,
                          highlight: true,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}

class _FunnelCard extends StatelessWidget {
  final String title;
  final int value;
  final String? badge;
  final Color color;
  final IconData icon;

  const _FunnelCard({
    required this.title,
    required this.value,
    this.badge,
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
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      decoration: BoxDecoration(
        color: effectiveColor.withValues(alpha: isDark ? 0.18 : 0.08),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: effectiveColor.withValues(alpha: isDark ? 0.40 : 0.25),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(icon, size: 18, color: effectiveColor),
              if (badge != null)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 5,
                    vertical: 1,
                  ),
                  decoration: BoxDecoration(
                    color: effectiveColor.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    badge!,
                    style: TextStyle(
                      fontSize: 9,
                      fontWeight: FontWeight.bold,
                      color: effectiveColor,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            NumberFormat.decimalPattern().format(value),
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: effectiveColor,
            ),
          ),
          Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 9.5,
              fontWeight: FontWeight.w500,
              color: isDark ? Colors.grey.shade300 : Colors.grey.shade700,
            ),
          ),
        ],
      ),
    );
  }
}

class _MetricTimeItem extends StatelessWidget {
  final String label;
  final double? hours;
  final bool highlight;

  const _MetricTimeItem({
    required this.label,
    required this.hours,
    this.highlight = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final valueText = hours != null ? '${hours!.toStringAsFixed(1)} h' : '—';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          valueText,
          style: TextStyle(
            fontSize: highlight ? 14 : 13,
            fontWeight: FontWeight.bold,
            color: highlight ? theme.colorScheme.primary : null,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          textAlign: TextAlign.center,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(fontSize: 9, color: Colors.grey.shade600),
        ),
      ],
    );
  }
}
