// features/dashboard/presentation/pages/dashboard/widgets/financial_and_trends_section.dart

import 'package:clean_architecture/features/dashboard/domain/entities/financial_dashboard_entities.dart';
import 'package:clean_architecture/features/dashboard/domain/entities/trends_geospatial_dashboard_entities.dart';
import 'package:clean_architecture/features/dashboard/domain/usecases/financial_analytics_use_cases.dart';
import 'package:clean_architecture/features/dashboard/domain/usecases/trends_geospatial_use_cases.dart';
import 'package:clean_architecture/features/dashboard/presentation/cubits/statistics/statistics_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';

class FinancialAndTrendsSection extends StatelessWidget {
  const FinancialAndTrendsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<StatisticsCubit<MaterialCostItemEntity>>(
          create:
              (_) => StatisticsCubit<MaterialCostItemEntity>(
                GetIt.I<GetMaterialCostsUseCase>(),
              )..load(),
        ),
        BlocProvider<StatisticsCubit<EconomicBalanceItemEntity>>(
          create:
              (_) => StatisticsCubit<EconomicBalanceItemEntity>(
                GetIt.I<GetEconomicBalanceUseCase>(),
              )..load(),
        ),
        BlocProvider<StatisticsCubit<DailyTrendItemEntity>>(
          create:
              (_) => StatisticsCubit<DailyTrendItemEntity>(
                GetIt.I<GetDailyTrendUseCase>(),
              )..load(),
        ),
      ],
      child: const _FinancialAndTrendsContent(),
    );
  }
}

class _FinancialAndTrendsContent extends StatelessWidget {
  const _FinancialAndTrendsContent();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final currencyFmt = NumberFormat.currency(symbol: '\$', decimalDigits: 2);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 1. Balance Económico Operativo Mensual
        Text(
          'Balance Económico: Costos Incurridos vs Recuperación',
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        BlocBuilder<
          StatisticsCubit<EconomicBalanceItemEntity>,
          StatisticsState<EconomicBalanceItemEntity>
        >(
          builder: (context, state) {
            final items =
                state is StatisticsLoaded<EconomicBalanceItemEntity>
                    ? state.items
                    : <EconomicBalanceItemEntity>[];

            if (items.isEmpty) {
              return const SizedBox.shrink();
            }

            final latest = items.first;

            return Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isDark ? Colors.grey.shade900 : Colors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: isDark ? Colors.grey.shade800 : Colors.grey.shade300,
                ),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Período: ${latest.mes.split('T').first}',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '${latest.totalOrdenes} OTs procesadas',
                        style: TextStyle(
                          fontSize: 11,
                          color:
                              isDark
                                  ? Colors.grey.shade400
                                  : Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: _CostCard(
                          label: 'Costo Operativo',
                          amount: currencyFmt.format(
                            latest.costoOperativoTotalIncurrido,
                          ),
                          color: Colors.red.shade700,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _CostCard(
                          label: 'Cobro Recuperable',
                          amount: currencyFmt.format(
                            latest.montoCobrableAUsuarios,
                          ),
                          color: Colors.blue.shade700,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _CostCard(
                          label: 'Saldo Neto',
                          amount: currencyFmt.format(
                            latest.balanceNetoRecuperacion,
                          ),
                          color:
                              latest.balanceNetoRecuperacion >= 0
                                  ? Colors.green.shade700
                                  : Colors.orange.shade800,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
        const SizedBox(height: 16),

        // 2. Materiales de Mayor Consumo
        Text(
          'Insumos y Materiales Más Utilizados',
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        BlocBuilder<
          StatisticsCubit<MaterialCostItemEntity>,
          StatisticsState<MaterialCostItemEntity>
        >(
          builder: (context, state) {
            final items =
                state is StatisticsLoaded<MaterialCostItemEntity>
                    ? state.items
                    : <MaterialCostItemEntity>[];

            if (items.isEmpty) {
              return const SizedBox.shrink();
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
                itemCount: items.take(6).length,
                separatorBuilder:
                    (_, _) => Divider(
                      height: 1,
                      color:
                          isDark ? Colors.grey.shade800 : Colors.grey.shade200,
                    ),
                itemBuilder: (context, index) {
                  final mat = items[index];

                  return Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 8,
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.inventory_2_outlined,
                          size: 16,
                          color: Colors.blueGrey,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                mat.descripcionMaterial,
                                style: const TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(
                                '${mat.departamento} • ${mat.ordenesQueLoUtilizaron} OTs',
                                style: TextStyle(
                                  fontSize: 9.5,
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
                            Text(
                              currencyFmt.format(mat.costoTotalMateriales),
                              style: const TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              'Cant: ${mat.cantidadTotalConsumida.toStringAsFixed(0)}',
                              style: TextStyle(
                                fontSize: 9.5,
                                color:
                                    isDark
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
            );
          },
        ),
        const SizedBox(height: 16),

        // 3. Tendencia Diaria de Flujo (Últimos días)
        Text(
          'Flujo Diario: Incidentes vs OTs Creadas vs Completadas',
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        BlocBuilder<
          StatisticsCubit<DailyTrendItemEntity>,
          StatisticsState<DailyTrendItemEntity>
        >(
          builder: (context, state) {
            final items =
                state is StatisticsLoaded<DailyTrendItemEntity>
                    ? state.items
                    : <DailyTrendItemEntity>[];

            if (items.isEmpty) {
              return const SizedBox.shrink();
            }

            return Container(
              padding: const EdgeInsets.all(10),
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
                itemCount: items.reversed.take(7).length,
                separatorBuilder:
                    (_, _) => Divider(
                      height: 1,
                      color:
                          isDark ? Colors.grey.shade800 : Colors.grey.shade200,
                    ),
                itemBuilder: (context, index) {
                  final day = items.reversed.toList()[index];
                  final isPositive = day.balanceFlujoNeto >= 0;

                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          day.fecha.split('T').first,
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Row(
                          children: [
                            _MiniPill(
                              label: 'Inc: ${day.incidentesReportados}',
                              color: Colors.blue,
                            ),
                            const SizedBox(width: 4),
                            _MiniPill(
                              label: 'OTs: ${day.ordenesCreadas}',
                              color: Colors.orange.shade800,
                            ),
                            const SizedBox(width: 4),
                            _MiniPill(
                              label: 'Fin: ${day.ordenesCompletadas}',
                              color: Colors.green.shade700,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              isPositive
                                  ? '+${day.balanceFlujoNeto}'
                                  : '${day.balanceFlujoNeto}',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color:
                                    isPositive
                                        ? Colors.green.shade700
                                        : Colors.red.shade700,
                              ),
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
      ],
    );
  }
}

class _CostCard extends StatelessWidget {
  final String label;
  final String amount;
  final Color color;

  const _CostCard({
    required this.label,
    required this.amount,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: isDark ? 0.15 : 0.08),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.25)),
      ),
      child: Column(
        children: [
          Text(
            amount,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: TextStyle(
              fontSize: 9,
              color: isDark ? Colors.grey.shade400 : Colors.grey.shade700,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _MiniPill extends StatelessWidget {
  final String label;
  final Color color;

  const _MiniPill({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 8.5,
          fontWeight: FontWeight.bold,
          color: color,
        ),
      ),
    );
  }
}
