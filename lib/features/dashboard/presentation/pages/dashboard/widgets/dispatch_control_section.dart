// features/dashboard/presentation/pages/dashboard/widgets/dispatch_control_section.dart

import 'package:clean_architecture/core/domain/use_cases/use_case.dart';
import 'package:clean_architecture/core/utils/type_defs.dart';
import 'package:clean_architecture/features/dashboard/domain/entities/incident_vs_work_order_entities.dart';
import 'package:clean_architecture/features/dashboard/domain/usecases/incident_analytics_use_cases.dart';
import 'package:clean_architecture/features/dashboard/presentation/cubits/statistics/statistics_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

class DispatchControlSection extends StatelessWidget {
  const DispatchControlSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<StatisticsCubit<DispatchControlItemEntity>>(
      create:
          (_) => StatisticsCubit<DispatchControlItemEntity>(
            _NoParamDispatchControlAdapter(
              GetIt.I<GetDispatchControlUseCase>(),
            ),
          )..load(),
      child: const _DispatchControlContent(),
    );
  }
}

class _NoParamDispatchControlAdapter
    implements UseCaseNoParameter<List<DispatchControlItemEntity>> {
  final GetDispatchControlUseCase _useCase;
  _NoParamDispatchControlAdapter(this._useCase);

  @override
  FutureData<List<DispatchControlItemEntity>> call() => _useCase(15);
}

class _DispatchControlContent extends StatelessWidget {
  const _DispatchControlContent();

  Color _getSemaforoColor(String semaforo) {
    if (semaforo.contains('ROJO')) return Colors.red.shade700;
    if (semaforo.contains('AMARILLO')) return Colors.orange.shade800;
    return Colors.green.shade700;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return BlocBuilder<
      StatisticsCubit<DispatchControlItemEntity>,
      StatisticsState<DispatchControlItemEntity>
    >(
      builder: (context, state) {
        if (state is StatisticsLoading<DispatchControlItemEntity>) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: CircularProgressIndicator(),
            ),
          );
        }

        if (state is StatisticsError<DispatchControlItemEntity>) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Text(
                'Error al cargar control de despacho: ${state.message}',
                style: const TextStyle(fontSize: 12, color: Colors.red),
              ),
            ),
          );
        }

        final items =
            state is StatisticsLoaded<DispatchControlItemEntity>
                ? state.items
                : <DispatchControlItemEntity>[];

        if (items.isEmpty) {
          return const SizedBox.shrink();
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Bandeja de Control de Despacho (Semáforo SLA)',
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
                  final semColor = _getSemaforoColor(item.semaforoSla);

                  return Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 8,
                    ),
                    child: Row(
                      children: [
                        // Indicador de semáforo lateral
                        Container(
                          width: 4,
                          height: 38,
                          decoration: BoxDecoration(
                            color: semColor,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                        const SizedBox(width: 8),

                        // Datos principales
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    item.codigoIncidente,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                    ),
                                  ),
                                  if (item.codigoOrden != null) ...[
                                    const Text(' → ', style: TextStyle(fontSize: 11)),
                                    Text(
                                      item.codigoOrden!,
                                      style: TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w600,
                                        color: theme.colorScheme.primary,
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                              const SizedBox(height: 2),
                              Text(
                                '${item.direccionReferencia ?? item.acometidaId ?? 'Sin dirección'} • Técnico: ${item.tecnicoResponsable}',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
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

                        // Badge de estado y horas
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: semColor.withValues(alpha: 0.12),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                item.nombreEstadoOt,
                                style: TextStyle(
                                  fontSize: 9,
                                  fontWeight: FontWeight.bold,
                                  color: semColor,
                                ),
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              '${item.horasDesdeReporte.toStringAsFixed(0)}h abiertas',
                              style: const TextStyle(fontSize: 9),
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
