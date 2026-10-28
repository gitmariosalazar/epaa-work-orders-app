// features/dashboard/presentation/pages/dashboard/widgets/sla_and_quality_section.dart

import 'package:clean_architecture/features/dashboard/domain/entities/quality_sla_dashboard_entities.dart';
import 'package:clean_architecture/features/dashboard/domain/usecases/quality_sla_use_cases.dart';
import 'package:clean_architecture/features/dashboard/presentation/cubits/statistics/statistics_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

class SlaAndQualitySection extends StatelessWidget {
  const SlaAndQualitySection({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<StatisticsCubit<SlaMonitorItemEntity>>(
          create:
              (_) => StatisticsCubit<SlaMonitorItemEntity>(
                GetIt.I<GetSlaMonitorUseCase>(),
              )..load(),
        ),
        BlocProvider<StatisticsCubit<QualityIndicatorItemEntity>>(
          create:
              (_) => StatisticsCubit<QualityIndicatorItemEntity>(
                GetIt.I<GetQualityIndicatorsUseCase>(),
              )..load(),
        ),
      ],
      child: const _SlaAndQualityContent(),
    );
  }
}

class _SlaAndQualityContent extends StatelessWidget {
  const _SlaAndQualityContent();

  Color _getSemaforoColor(String estado) {
    if (estado.contains('VENCIDA') || estado.contains('Incumplida')) {
      return Colors.red.shade700;
    }
    if (estado.contains('RIESGO') || estado.contains('PRECAUCIÓN')) {
      return Colors.orange.shade800;
    }
    return Colors.green.shade700;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 1. Monitor Semáforo de SLA
        Text(
          'Monitor de Semáforo de SLA (Órdenes Activas)',
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        BlocBuilder<
          StatisticsCubit<SlaMonitorItemEntity>,
          StatisticsState<SlaMonitorItemEntity>
        >(
          builder: (context, state) {
            if (state is StatisticsLoading<SlaMonitorItemEntity>) {
              return const Center(
                child: Padding(
                  padding: EdgeInsets.all(12.0),
                  child: CircularProgressIndicator(),
                ),
              );
            }

            final items =
                state is StatisticsLoaded<SlaMonitorItemEntity>
                    ? state.items
                    : <SlaMonitorItemEntity>[];

            if (items.isEmpty) {
              return Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: isDark ? Colors.grey.shade900 : Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: isDark ? Colors.grey.shade800 : Colors.grey.shade300,
                  ),
                ),
                child: const Center(
                  child: Text(
                    'No hay órdenes en riesgo o fuera de SLA',
                    style: TextStyle(fontSize: 12),
                  ),
                ),
              );
            }

            return Container(
              decoration: BoxDecoration(
                color: isDark ? Colors.grey.shade900 : Colors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: isDark ? Colors.grey.shade800 : Colors.grey.shade300,
                ),
              ),
              child: ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: items.take(8).length,
                separatorBuilder:
                    (_, _) => Divider(
                      height: 1,
                      color:
                          isDark ? Colors.grey.shade800 : Colors.grey.shade200,
                    ),
                itemBuilder: (context, index) {
                  final item = items[index];
                  final semColor = _getSemaforoColor(item.estadoSlaSemaforo);

                  return Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 8,
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 4,
                          height: 36,
                          decoration: BoxDecoration(
                            color: semColor,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${item.codigoOrden} • ${item.tipoTrabajo}',
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                '${item.departamento} • Técnico: ${item.tecnicoAsignado}',
                                style: TextStyle(
                                  fontSize: 10,
                                  color:
                                      isDark
                                          ? Colors.grey.shade400
                                          : Colors.grey.shade600,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 1.5,
                              ),
                              decoration: BoxDecoration(
                                color: semColor.withValues(alpha: 0.12),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                item.estadoSlaSemaforo,
                                style: TextStyle(
                                  fontSize: 9,
                                  fontWeight: FontWeight.bold,
                                  color: semColor,
                                ),
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              'Holgura: ${item.horasHolguraSla.toStringAsFixed(1)} h',
                              style: const TextStyle(fontSize: 9.5),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
            );
          },
        ),
        const SizedBox(height: 16),

        // 2. Indicadores de Calidad y Retrabajos
        Text(
          'Control de Calidad y Pre-inspecciones',
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        BlocBuilder<
          StatisticsCubit<QualityIndicatorItemEntity>,
          StatisticsState<QualityIndicatorItemEntity>
        >(
          builder: (context, state) {
            final items =
                state is StatisticsLoaded<QualityIndicatorItemEntity>
                    ? state.items
                    : <QualityIndicatorItemEntity>[];

            if (items.isEmpty) {
              return const SizedBox.shrink();
            }

            return ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: items.length,
              separatorBuilder: (_, _) => const SizedBox(height: 8),
              itemBuilder: (context, index) {
                final item = items[index];
                final prePct = item.pctAprobacionPreinspeccion ?? 0.0;
                final finalPct = item.pctAprobacionCalidadFinal ?? 0.0;

                return Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: isDark ? Colors.grey.shade900 : Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color:
                          isDark ? Colors.grey.shade800 : Colors.grey.shade300,
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
                              '${item.tipoTrabajo} (${item.departamento})',
                              style: const TextStyle(
                                fontSize: 11.5,
                                fontWeight: FontWeight.bold,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Text(
                            '${item.totalOrdenesInspeccionadas} OTs',
                            style: TextStyle(
                              fontSize: 10,
                              color:
                                  isDark
                                      ? Colors.grey.shade400
                                      : Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Pre-inspección: ${prePct.toStringAsFixed(1)}% apr.',
                                  style: const TextStyle(fontSize: 10),
                                ),
                                const SizedBox(height: 2),
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(3),
                                  child: LinearProgressIndicator(
                                    value: (prePct / 100).clamp(0.0, 1.0),
                                    backgroundColor: Colors.grey.shade200,
                                    color: Colors.blue,
                                    minHeight: 4,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Calidad Final: ${finalPct.toStringAsFixed(1)}% apr.',
                                  style: const TextStyle(fontSize: 10),
                                ),
                                const SizedBox(height: 2),
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(3),
                                  child: LinearProgressIndicator(
                                    value: (finalPct / 100).clamp(0.0, 1.0),
                                    backgroundColor: Colors.grey.shade200,
                                    color: Colors.green,
                                    minHeight: 4,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            );
          },
        ),
      ],
    );
  }
}
