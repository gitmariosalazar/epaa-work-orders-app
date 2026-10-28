// features/dashboard/presentation/pages/dashboard/widgets/state_matrix_section.dart

import 'package:clean_architecture/features/dashboard/domain/entities/incident_vs_work_order_entities.dart';
import 'package:clean_architecture/features/dashboard/domain/usecases/incident_analytics_use_cases.dart';
import 'package:clean_architecture/features/dashboard/presentation/cubits/statistics/statistics_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

class StateMatrixSection extends StatelessWidget {
  const StateMatrixSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<StatisticsCubit<StateMatrixItemEntity>>(
      create:
          (_) => StatisticsCubit<StateMatrixItemEntity>(
            GetIt.I<GetStateMatrixUseCase>(),
          )..load(),
      child: const _StateMatrixContent(),
    );
  }
}

class _StateMatrixContent extends StatelessWidget {
  const _StateMatrixContent();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return BlocBuilder<
      StatisticsCubit<StateMatrixItemEntity>,
      StatisticsState<StateMatrixItemEntity>
    >(
      builder: (context, state) {
        if (state is StatisticsLoading<StateMatrixItemEntity>) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: CircularProgressIndicator(),
            ),
          );
        }

        if (state is StatisticsError<StateMatrixItemEntity>) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Text(
                'Error al cargar matriz de estados: ${state.message}',
                style: const TextStyle(fontSize: 12, color: Colors.red),
              ),
            ),
          );
        }

        final items =
            state is StatisticsLoaded<StateMatrixItemEntity>
                ? state.items
                : <StateMatrixItemEntity>[];

        if (items.isEmpty) {
          return const SizedBox.shrink();
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Matriz Cruzada: Estado del Incidente vs Estado de la OT',
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Container(
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
                itemCount: items.length,
                separatorBuilder:
                    (_, _) => Divider(
                      height: 1,
                      color:
                          isDark ? Colors.grey.shade800 : Colors.grey.shade200,
                    ),
                itemBuilder: (context, index) {
                  final item = items[index];
                  final isWarning =
                      item.diagnosticoOperativo.toUpperCase().contains('ALERTA');

                  return Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 8,
                    ),
                    child: Row(
                      children: [
                        // Columna 1: Estados
                        Expanded(
                          flex: 5,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  _StatusChip(
                                    label: item.estadoIncidente,
                                    isIncident: true,
                                  ),
                                  const Padding(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 4,
                                    ),
                                    child: Icon(
                                      Icons.arrow_forward,
                                      size: 12,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  _StatusChip(
                                    label: item.nombreEstadoOt,
                                    isIncident: false,
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Text(
                                item.diagnosticoOperativo,
                                style: TextStyle(
                                  fontSize: 10,
                                  color:
                                      isWarning
                                          ? Colors.red.shade700
                                          : (isDark
                                              ? Colors.grey.shade400
                                              : Colors.grey.shade600),
                                  fontWeight:
                                      isWarning
                                          ? FontWeight.w600
                                          : FontWeight.normal,
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Columna 2: Cantidad y Porcentaje
                        Expanded(
                          flex: 2,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                '${item.cantidadReportes}',
                                style: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                '${item.porcentajeDelTotalReportes.toStringAsFixed(1)}%',
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
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}

class _StatusChip extends StatelessWidget {
  final String label;
  final bool isIncident;

  const _StatusChip({required this.label, required this.isIncident});

  @override
  Widget build(BuildContext context) {
    final color = isIncident ? Colors.deepPurple : Colors.blueGrey;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 9,
          fontWeight: FontWeight.bold,
          color: color,
        ),
      ),
    );
  }
}
