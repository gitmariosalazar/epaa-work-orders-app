// features/dashboard/presentation/pages/dashboard/widgets/technician_workload_section.dart

import 'package:clean_architecture/features/dashboard/domain/entities/technician_dashboard_entities.dart';
import 'package:clean_architecture/features/dashboard/domain/usecases/operations_analytics_use_cases.dart';
import 'package:clean_architecture/features/dashboard/presentation/cubits/statistics/statistics_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

class TechnicianWorkloadSection extends StatelessWidget {
  const TechnicianWorkloadSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<StatisticsCubit<TechnicianPerformanceItemEntity>>(
      create: (_) => StatisticsCubit<TechnicianPerformanceItemEntity>(
        GetIt.I<GetTechnicianPerformanceUseCase>(),
      )..load(),
      child: const _TechnicianWorkloadContent(),
    );
  }
}

class _TechnicianWorkloadContent extends StatelessWidget {
  const _TechnicianWorkloadContent();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return BlocBuilder<
      StatisticsCubit<TechnicianPerformanceItemEntity>,
      StatisticsState<TechnicianPerformanceItemEntity>
    >(
      builder: (context, state) {
        if (state is StatisticsLoading<TechnicianPerformanceItemEntity>) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: CircularProgressIndicator(),
            ),
          );
        }

        if (state is StatisticsError<TechnicianPerformanceItemEntity>) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Text(
                'Error al cargar técnicos: ${state.message}',
                style: const TextStyle(fontSize: 12, color: Colors.red),
              ),
            ),
          );
        }

        final items = state is StatisticsLoaded<TechnicianPerformanceItemEntity>
            ? state.items
            : <TechnicianPerformanceItemEntity>[];

        if (items.isEmpty) {
          return const SizedBox.shrink();
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Carga Operativa y Rendimiento de Técnicos',
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '${items.length} técnicos activos',
                  style: TextStyle(
                    fontSize: 11,
                    color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                  ),
                ),
              ],
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
                separatorBuilder: (_, _) => Divider(
                  height: 1,
                  color: isDark ? Colors.grey.shade800 : Colors.grey.shade200,
                ),
                itemBuilder: (context, index) {
                  final item = items[index];
                  final slaPct = item.tasaCumplimientoSlaPct ?? 0.0;

                  return Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 8,
                    ),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 16,
                          backgroundColor: theme.colorScheme.primary.withValues(
                            alpha: 0.12,
                          ),
                          child: Text(
                            item.nombreTecnico.isNotEmpty
                                ? item.nombreTecnico[0].toUpperCase()
                                : 'T',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: theme.colorScheme.primary,
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item.nombreTecnico,
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                'Cédula: ${item.cedula ?? 'S/N'} • Ext: ${item.telefonoInterno ?? 'N/A'}',
                                style: TextStyle(
                                  fontSize: 10,
                                  color: isDark
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
                            Row(
                              children: [
                                _KpiBadge(
                                  label: '${item.totalBacklogActivo} activas',
                                  color: Colors.orange.shade800,
                                ),
                                const SizedBox(width: 4),
                                _KpiBadge(
                                  label: '${item.totalCompletadas} fin.',
                                  color: Colors.green.shade700,
                                ),
                              ],
                            ),
                            const SizedBox(height: 2),
                            Text(
                              'SLA: ${slaPct.toStringAsFixed(0)}% • ${item.horasPromedioEnCampo?.toStringAsFixed(1) ?? '—'}h campo',
                              style: TextStyle(
                                fontSize: 9.5,
                                color: isDark
                                    ? Colors.grey.shade400
                                    : Colors.grey.shade600,
                              ),
                            ),
                          ],
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

class _KpiBadge extends StatelessWidget {
  final String label;
  final Color color;

  const _KpiBadge({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1.5),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(4),
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
