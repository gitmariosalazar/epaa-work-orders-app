// features/work-orders/presentation/pages/home_page.dart

import 'package:auto_route/auto_route.dart';
import 'package:clean_architecture/features/work-orders/domain/entities/work_order_entity.dart';
import 'package:clean_architecture/features/work-orders/domain/usecases/get_all_work_order_use_case.dart';
import 'package:clean_architecture/features/work-orders/presentation/cubits/work-orders/work_orders_cubit.dart';
import 'package:clean_architecture/features/work-orders/presentation/cubits/work-orders/work_orders_state.dart';
import 'package:clean_architecture/features/work-orders/presentation/widgets/empty_work_orders.dart';
import 'package:clean_architecture/features/work-orders/presentation/widgets/loading_work_orders.dart';
import 'package:clean_architecture/features/work-orders/presentation/widgets/work_order_card.dart';
import 'package:clean_architecture/routing/routes.gr.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

@RoutePage()
class WorkOrdersHomePage extends StatelessWidget {
  const WorkOrdersHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => WorkOrdersCubit(
        getAllWorkOrdersUseCase: GetIt.I<GetAllWorkOrdersUseCase>(),
      )..loadWorkOrders(),
      child: const _WorkOrdersHomeView(),
    );
  }
}

class _WorkOrdersHomeView extends StatefulWidget {
  const _WorkOrdersHomeView();

  @override
  State<_WorkOrdersHomeView> createState() => _WorkOrdersHomeViewState();
}

class _WorkOrdersHomeViewState extends State<_WorkOrdersHomeView> {
  final _searchController = TextEditingController();
  int? _filterStatus;
  int? _filterPriority;
  int? _filterWorkType;
  String? _filterClientId;
  String? _filterOrderCode;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text(
            'Filtros Avanzados',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  decoration: InputDecoration(
                    labelText: 'Código de orden',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onChanged: (value) =>
                      _filterOrderCode = value.isEmpty ? null : value,
                ),
                const SizedBox(height: 12),
                TextField(
                  decoration: InputDecoration(
                    labelText: 'Cliente ID',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onChanged: (value) =>
                      _filterClientId = value.isEmpty ? null : value,
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<int?>(
                  decoration: InputDecoration(
                    labelText: 'Estado',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  value: _filterStatus,
                  items: [
                    const DropdownMenuItem(
                      value: null,
                      child: Text('Todos los estados'),
                    ),
                    ...[1, 2, 3, 4, 5, 6, 7, 8].map(
                      (s) => DropdownMenuItem(
                        value: s,
                        child: Text(_getStatusText(s)),
                      ),
                    ),
                  ],
                  onChanged: (value) => setState(() => _filterStatus = value),
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<int?>(
                  decoration: InputDecoration(
                    labelText: 'Prioridad',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  value: _filterPriority,
                  items: [
                    const DropdownMenuItem(
                      value: null,
                      child: Text('Todas las prioridades'),
                    ),
                    ...[1, 2, 3, 4, 5].map(
                      (p) => DropdownMenuItem(
                        value: p,
                        child: Text(_getPriorityText(p)),
                      ),
                    ),
                  ],
                  onChanged: (value) => setState(() => _filterPriority = value),
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<int?>(
                  decoration: InputDecoration(
                    labelText: 'Tipo de trabajo',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  value: _filterWorkType,
                  items: [
                    const DropdownMenuItem(
                      value: null,
                      child: Text('Todos los tipos'),
                    ),
                    ...[1, 2, 3, 4, 5].map(
                      (t) => DropdownMenuItem(
                        value: t,
                        child: Text(_getWorkTypeText(t)),
                      ),
                    ),
                  ],
                  onChanged: (value) => setState(() => _filterWorkType = value),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  _filterStatus = null;
                  _filterPriority = null;
                  _filterWorkType = null;
                  _filterClientId = null;
                  _filterOrderCode = null;
                });
                Navigator.pop(context);
              },
              child: const Text('Limpiar'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Aplicar'),
            ),
          ],
        );
      },
    );
  }

  String _getStatusText(int status) {
    switch (status) {
      case 1:
        return 'Pendiente';
      case 2:
        return 'Asignada';
      case 3:
        return 'Reasignada';
      case 4:
        return 'En Progreso';
      case 5:
        return 'En Espera';
      case 6:
        return 'Reanudada';
      case 7:
        return 'Completada';
      case 8:
        return 'Cancelada';
      default:
        return 'Desconocido';
    }
  }

  String _getPriorityText(int priority) {
    switch (priority) {
      case 1:
        return 'Baja';
      case 2:
        return 'Media';
      case 3:
        return 'Alta';
      case 4:
        return 'Urgente';
      case 5:
        return 'Emergencia';
      default:
        return 'Desconocida';
    }
  }

  String _getWorkTypeText(int type) {
    switch (type) {
      case 1:
        return 'ALCANTARILLADO';
      case 2:
        return 'AGUA POTABLE';
      case 3:
        return 'COMERCIALIZACION';
      case 4:
        return 'MANTENIMIENTO';
      case 5:
        return 'LABORATORIO';
      default:
        return 'DESCONOCIDO';
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Calculamos el padding inferior una sola vez por build (seguro y eficiente)
    final double bottomInset = MediaQuery.of(context).padding.bottom + 24;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Órdenes de Trabajo',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: theme.primaryColorDark,
            fontSize: 16,
          ),
        ),
        actions: [
          IconButton(
            color: theme.primaryColorDark,
            icon: const Icon(Icons.filter_list_rounded),
            onPressed: _showFilterDialog,
          ),
          IconButton(
            onPressed: () async {
              // Navegamos a crear orden
              await context.router.push(const CreateWorkOrderRoute());

              // *** AQUÍ ESTÁ LA SOLUCIÓN ***
              // Siempre recargamos los datos al volver, sin depender del resultado
              context.read<WorkOrdersCubit>().loadWorkOrders();
            },
            icon: const Icon(Icons.add_task),
            color: theme.primaryColorDark,
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            color: theme.primaryColorDark,
            onPressed: () => context.read<WorkOrdersCubit>().loadWorkOrders(),
          ),
        ],
      ),
      body: BlocBuilder<WorkOrdersCubit, WorkOrdersState>(
        builder: (context, state) {
          if (state is WorkOrdersLoading || state is WorkOrdersInitial) {
            return const LoadingWorkOrders();
          }

          if (state is WorkOrdersError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.cloud_off, size: 80, color: Colors.grey),
                  const SizedBox(height: 16),
                  Text('Error de conexión', style: theme.textTheme.titleLarge),
                  const SizedBox(height: 8),
                  Text(
                    state.message,
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: () =>
                        context.read<WorkOrdersCubit>().loadWorkOrders(),
                    icon: const Icon(Icons.refresh),
                    label: const Text('Reintentar'),
                  ),
                ],
              ),
            );
          }

          final orders = state is WorkOrdersLoaded
              ? state.orders
              : <WorkOrderEntity>[];

          // Aplicar filtros
          final filteredOrders = orders.where((order) {
            final matchesSearch =
                _searchController.text.isEmpty ||
                order.orderCode!.toLowerCase().contains(
                  _searchController.text.toLowerCase(),
                ) ||
                order.description.toLowerCase().contains(
                  _searchController.text.toLowerCase(),
                ) ||
                (_filterClientId == null ||
                    order.clientId.contains(_filterClientId!)) ||
                (_filterOrderCode == null ||
                    order.orderCode!.contains(_filterOrderCode!));

            final matchesStatus =
                _filterStatus == null || order.status == _filterStatus;
            final matchesPriority =
                _filterPriority == null || order.priorityId == _filterPriority;
            final matchesWorkType =
                _filterWorkType == null || order.workTypeId == _filterWorkType;

            return matchesSearch &&
                matchesStatus &&
                matchesPriority &&
                matchesWorkType;
          }).toList();

          if (filteredOrders.isEmpty) {
            return const EmptyWorkOrders();
          }

          return RefreshIndicator(
            onRefresh: () async =>
                context.read<WorkOrdersCubit>().loadWorkOrders(),
            child: ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: filteredOrders.length,
              itemBuilder: (context, index) {
                final order = filteredOrders[index];
                return WorkOrderCard(
                  order: order,
                  onEdit: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: const Text('Editar orden - Próximamente'),
                        behavior: SnackBarBehavior.floating,
                        margin: EdgeInsets.only(
                          left: 16,
                          right: 16,
                          bottom: bottomInset,
                        ),
                        backgroundColor: Colors.blueAccent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    );
                  },
                  onDelete: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: const Text('Eliminar orden - Próximamente'),
                        behavior: SnackBarBehavior.floating,
                        margin: EdgeInsets.only(
                          left: 16,
                          right: 16,
                          bottom: bottomInset,
                        ),
                        backgroundColor: Colors.redAccent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          );
        },
      ),
    );
  }
}
