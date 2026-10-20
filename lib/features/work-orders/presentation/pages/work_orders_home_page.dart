// features/work-orders/presentation/pages/home_page.dart

import 'package:auto_route/auto_route.dart';
import 'package:clean_architecture/components/widgets/app_search_bar.dart';
import 'package:clean_architecture/core/constants/work_order_status.dart';
import 'package:clean_architecture/features/work-orders/domain/entities/work_order_entity.dart';
import 'package:clean_architecture/features/work-orders/domain/usecases/get_all_work_order_use_case.dart';
import 'package:clean_architecture/features/work-orders/presentation/cubits/work-orders/work_orders_cubit.dart';
import 'package:clean_architecture/features/work-orders/presentation/cubits/work-orders/work_orders_state.dart';
import 'package:clean_architecture/features/work-orders/presentation/widgets/loading_work_orders.dart';
import 'package:clean_architecture/features/work-orders/presentation/widgets/orders/work_order_card.dart';
import 'package:clean_architecture/routing/routes.gr.dart';
import 'package:clean_architecture/shared_ui/ui/base/app_bar/base_app_bar.dart';
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
  final _scrollController = ScrollController();
  String? _filterStatus;
  int? _filterPriority;
  int? _filterWorkType;
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.offset >=
            _scrollController.position.maxScrollExtent - 200 &&
        !_scrollController.position.outOfRange) {
      context.read<WorkOrdersCubit>().loadMore();
    }
  }

  Future<void> _showFilterDialog() async {
    var filterStatus = _filterStatus;
    var filterPriority = _filterPriority;
    var filterWorkType = _filterWorkType;

    await showDialog<void>(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) => AlertDialog(
            title: const Text(
              'Filtros Avanzados',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  DropdownButtonFormField<String?>(
                    decoration: InputDecoration(
                      labelText: 'Estado',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    initialValue: filterStatus,
                    items: [
                      const DropdownMenuItem(
                        value: null,
                        child: Text('Todos los estados'),
                      ),
                      ...WorkOrderStatus.all.map(
                        (status) => DropdownMenuItem(
                          value: status.code,
                          child: Text(status.label),
                        ),
                      ),
                    ],
                    onChanged: (value) =>
                        setDialogState(() => filterStatus = value),
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<int?>(
                    decoration: InputDecoration(
                      labelText: 'Prioridad',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    initialValue: filterPriority,
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
                    onChanged: (value) =>
                        setDialogState(() => filterPriority = value),
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<int?>(
                    decoration: InputDecoration(
                      labelText: 'Tipo de trabajo',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    initialValue: filterWorkType,
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
                    onChanged: (value) =>
                        setDialogState(() => filterWorkType = value),
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
                  });
                  Navigator.pop(context);
                },
                child: const Text('Limpiar'),
              ),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _filterStatus = filterStatus;
                    _filterPriority = filterPriority;
                    _filterWorkType = filterWorkType;
                  });
                  Navigator.pop(context);
                },
                child: const Text('Aplicar'),
              ),
            ],
          ),
        );
      },
    );
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
      appBar: BaseAppBar(
        title: 'Órdenes de Trabajo',
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list_rounded),
            onPressed: _showFilterDialog,
            tooltip: 'Filtros',
          ),
          IconButton(
            onPressed: () async {
              final cubit = context.read<WorkOrdersCubit>();

              await context.router.push(const CreateWorkOrderRoute());

              if (mounted) {
                await cubit.loadWorkOrders(refresh: true);
              }
            },
            icon: const Icon(Icons.add_task),
            tooltip: 'Nueva Orden de Trabajo',
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () =>
                context.read<WorkOrdersCubit>().loadWorkOrders(refresh: true),
            tooltip: 'Recargar',
          ),
        ],
      ),
      body: Column(
        children: [
          Tooltip(
            message: 'Buscar por código de orden, cédula o clave catastral',
            waitDuration: const Duration(
              milliseconds: 500,
            ), // Tiempo al pasar el mouse
            showDuration: const Duration(seconds: 2),
            child: AppSearchBar(
              controller: _searchController,
              hintText: 'Código de orden, cédula o clave catastral',
              onSearch: () => context.read<WorkOrdersCubit>().search(
                _searchController.text,
              ),
              onClear: () => context.read<WorkOrdersCubit>().search(null),
            ),
          ),
          Expanded(child: _buildOrdersBody(context, theme, bottomInset)),
        ],
      ),
    );
  }

  Widget _buildOrdersBody(
    BuildContext context,
    ThemeData theme,
    double bottomInset,
  ) {
    return BlocBuilder<WorkOrdersCubit, WorkOrdersState>(
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
                  onPressed: () => context
                      .read<WorkOrdersCubit>()
                      .loadWorkOrders(refresh: true),
                  icon: const Icon(Icons.refresh),
                  label: const Text('Reintentar'),
                ),
              ],
            ),
          );
        }

        final loadedState = state is WorkOrdersLoaded ? state : null;
        final orders = loadedState?.orders ?? <WorkOrderEntity>[];
        final filteredOrders = orders.where((order) {
          final matchesStatus =
              _filterStatus == null ||
              WorkOrderStatus.normalize(order.status) == _filterStatus;
          final matchesPriority =
              _filterPriority == null || order.priorityId == _filterPriority;
          final matchesWorkType =
              _filterWorkType == null || order.workTypeId == _filterWorkType;

          return matchesStatus && matchesPriority && matchesWorkType;
        }).toList();

        if (filteredOrders.isEmpty) {
          return RefreshIndicator(
            onRefresh: () =>
                context.read<WorkOrdersCubit>().loadWorkOrders(refresh: true),
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              children: [
                SizedBox(
                  height: 260,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.search_off,
                          size: 64,
                          color: Colors.grey,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          orders.isEmpty
                              ? 'No hay órdenes de trabajo'
                              : 'No hay órdenes cargadas que coincidan con los filtros',
                          textAlign: TextAlign.center,
                        ),
                        if (loadedState?.hasMore ?? false)
                          TextButton(
                            onPressed: () =>
                                context.read<WorkOrdersCubit>().loadMore(),
                            child: const Text('Buscar en más órdenes'),
                          ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: () =>
              context.read<WorkOrdersCubit>().loadWorkOrders(refresh: true),
          child: ListView.builder(
            controller: _scrollController,
            padding: const EdgeInsets.all(8),
            itemCount:
                filteredOrders.length +
                ((loadedState?.hasMore ?? false) ? 1 : 0),
            itemBuilder: (context, index) {
              if (index == filteredOrders.length) {
                return Padding(
                  padding: const EdgeInsets.all(16),
                  child: Center(
                    child: loadedState?.isLoadingMore ?? false
                        ? const CircularProgressIndicator()
                        : TextButton(
                            onPressed: () =>
                                context.read<WorkOrdersCubit>().loadMore(),
                            child: const Text('Cargar más órdenes'),
                          ),
                  ),
                );
              }
              final order = filteredOrders[index];
              return WorkOrderCard(
                order: order,
                onEdit: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text('Imprimir orden - Próximamente'),
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
    );
  }
}
