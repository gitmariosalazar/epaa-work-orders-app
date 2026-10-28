// features/dashboard/presentation/pages/dashboard/widgets/origin_channel_section.dart

import 'package:clean_architecture/features/dashboard/domain/entities/incident_vs_work_order_entities.dart';
import 'package:clean_architecture/features/dashboard/domain/usecases/incident_analytics_use_cases.dart';
import 'package:clean_architecture/features/dashboard/presentation/cubits/statistics/statistics_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

class OriginChannelSection extends StatelessWidget {
  const OriginChannelSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<StatisticsCubit<OriginChannelItemEntity>>(
      create:
          (_) => StatisticsCubit<OriginChannelItemEntity>(
            GetIt.I<GetOriginChannelsUseCase>(),
          )..load(),
      child: const _OriginChannelContent(),
    );
  }
}

class _OriginChannelContent extends StatelessWidget {
  const _OriginChannelContent();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return BlocBuilder<
      StatisticsCubit<OriginChannelItemEntity>,
      StatisticsState<OriginChannelItemEntity>
    >(
      builder: (context, state) {
        if (state is StatisticsLoading<OriginChannelItemEntity>) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: CircularProgressIndicator(),
            ),
          );
        }

        if (state is StatisticsError<OriginChannelItemEntity>) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Text(
                'Error al cargar canales: ${state.message}',
                style: const TextStyle(fontSize: 12, color: Colors.red),
              ),
            ),
          );
        }

        final items =
            state is StatisticsLoaded<OriginChannelItemEntity>
                ? state.items
                : <OriginChannelItemEntity>[];

        if (items.isEmpty) {
          return const SizedBox.shrink();
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Rendimiento por Canal de Ingreso de Reportes',
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: items.length,
              separatorBuilder: (_, _) => const SizedBox(height: 8),
              itemBuilder: (context, index) {
                final item = items[index];
                return _ChannelRowCard(item: item, isDark: isDark);
              },
            ),
          ],
        );
      },
    );
  }
}

class _ChannelRowCard extends StatelessWidget {
  final OriginChannelItemEntity item;
  final bool isDark;

  const _ChannelRowCard({required this.item, required this.isDark});

  IconData _getChannelIcon(String channel) {
    switch (channel.toUpperCase()) {
      case 'WEB_USUARIO':
        return Icons.language_rounded;
      case 'LECTURISTA':
        return Icons.qr_code_scanner_rounded;
      case 'ATENCION_AL_CLIENTE':
        return Icons.support_agent_rounded;
      case 'INSPECTOR':
        return Icons.verified_user_rounded;
      default:
        return Icons.devices_rounded;
    }
  }

  Color _getChannelColor(String channel) {
    switch (channel.toUpperCase()) {
      case 'WEB_USUARIO':
        return Colors.blue;
      case 'LECTURISTA':
        return Colors.teal;
      case 'ATENCION_AL_CLIENTE':
        return Colors.deepPurple;
      case 'INSPECTOR':
        return Colors.orange.shade800;
      default:
        return Colors.blueGrey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = _getChannelColor(item.canalOrigen);
    final icon = _getChannelIcon(item.canalOrigen);
    final convPct = item.tasaConversionOtPct ?? 0.0;
    final exitoPct = item.tasaExitoResolucionPct ?? 0.0;

    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: isDark ? Colors.grey.shade900 : Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: isDark ? Colors.grey.shade800 : Colors.grey.shade300,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 14,
                    backgroundColor: color.withValues(alpha: 0.15),
                    child: Icon(icon, size: 16, color: color),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    item.canalOrigen.replaceAll('_', ' '),
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  '${item.totalReportes} reportes',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Tasa Conversión a OT: ${convPct.toStringAsFixed(1)}%',
                      style: const TextStyle(fontSize: 10),
                    ),
                    const SizedBox(height: 3),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: (convPct / 100).clamp(0.0, 1.0),
                        backgroundColor: Colors.grey.shade200,
                        color: color,
                        minHeight: 5,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Tasa Resolución: ${exitoPct.toStringAsFixed(1)}%',
                      style: const TextStyle(fontSize: 10),
                    ),
                    const SizedBox(height: 3),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: (exitoPct / 100).clamp(0.0, 1.0),
                        backgroundColor: Colors.grey.shade200,
                        color: Colors.green,
                        minHeight: 5,
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
  }
}
