// features/dashboard/presentation/pages/technician/cubit/technician_initial_cubit.dart

import 'package:clean_architecture/core/data_states/data_state.dart';
import 'package:clean_architecture/features/work-orders/domain/entities/work_order_entity.dart';
import 'package:clean_architecture/features/work-orders/domain/usecases/get_all_work_order_use_case.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'technician_initial_state.dart';

class TechnicianInitialCubit extends Cubit<TechnicianInitialState> {
  final GetAllWorkOrdersUseCase getAllWorkOrdersUseCase;

  TechnicianInitialCubit({required this.getAllWorkOrdersUseCase})
      : super(TechnicianInitialState.initial());

  /// Carga inicial de datos de órdenes de trabajo y cálculo de KPIs.
  Future<void> loadInitialData({bool isRefresh = false}) async {
    if (!isRefresh && !state.isLoading) {
      emit(state.copyWith(isLoading: true, errorMessage: null));
    }

    try {
      final result = await getAllWorkOrdersUseCase(limit: 50, offset: 0);

      if (result is SuccessState<List<WorkOrderEntity>>) {
        final orders = result.data ?? [];
        if (orders.isEmpty) {
          _emitFallbackOrders();
        } else {
          _processAndEmitOrders(orders);
        }
      } else if (result is FailureState<List<WorkOrderEntity>>) {
        // En caso de fallo de red o backend, emitir datos de fallback
        _emitFallbackOrders(
          errorMessage: result.message ?? 'No se pudieron sincronizar las órdenes',
        );
      } else {
        _emitFallbackOrders();
      }
    } catch (e) {
      _emitFallbackOrders(errorMessage: 'Error al conectar: $e');
    }
  }

  /// Sincroniza las órdenes de trabajo con el backend.
  Future<void> syncData() async {
    emit(state.copyWith(isSyncing: true, errorMessage: null));

    try {
      final result = await getAllWorkOrdersUseCase(limit: 50, offset: 0);

      if (result is SuccessState<List<WorkOrderEntity>>) {
        final orders = result.data ?? [];
        if (orders.isEmpty) {
          _emitFallbackOrders(isSyncing: false);
        } else {
          _processAndEmitOrders(orders, isSyncing: false);
        }
      } else if (result is FailureState<List<WorkOrderEntity>>) {
        emit(state.copyWith(
          isSyncing: false,
          errorMessage: result.message ?? 'Fallo de sincronización',
        ));
      } else {
        emit(state.copyWith(isSyncing: false));
      }
    } catch (e) {
      emit(state.copyWith(
        isSyncing: false,
        errorMessage: 'Error de sincronización: $e',
      ));
    }
  }

  void _processAndEmitOrders(
    List<WorkOrderEntity> orders, {
    bool isSyncing = false,
  }) {
    int pending = 0;
    int inProgress = 0;
    int completed = 0;

    for (final order in orders) {
      final st = order.status.trim().toUpperCase();
      if (st.contains('COMPLETADA') || st.contains('EJECUTADA')) {
        completed++;
      } else if (st.contains('PROCESO') ||
          st == 'ASIGNADA' ||
          st == 'PREPARACION') {
        inProgress++;
      } else if (st == 'PENDIENTE' || st == 'NOTIFICADA') {
        pending++;
      }
    }

    // Identificar tarea prioritaria o en curso
    WorkOrderEntity? priority;

    // 1. Buscar primero en proceso
    final inProgressList = orders.where((o) {
      final st = o.status.trim().toUpperCase();
      return st.contains('PROCESO') || st == 'ASIGNADA';
    }).toList();

    if (inProgressList.isNotEmpty) {
      priority = inProgressList.first;
    } else {
      // 2. Buscar por alta prioridad
      final highPriority =
          orders.where((o) => o.priorityId >= 4 && o.status != 'COMPLETADA');
      if (highPriority.isNotEmpty) {
        priority = highPriority.first;
      } else if (orders.isNotEmpty) {
        priority = orders.first;
      }
    }

    // Órdenes de hoy (excluir la que está como destacada para evitar duplicar, o tomar las primeras)
    final todayList = orders
        .where((o) =>
            priority == null || o.orderCode != priority.orderCode)
        .take(4)
        .toList();

    emit(TechnicianInitialState(
      isLoading: false,
      isSyncing: isSyncing,
      pendingCount: pending,
      inProgressCount: inProgress,
      completedCount: completed,
      priorityOrder: priority,
      todayOrders: todayList,
      allOrders: orders,
    ));
  }

  void _emitFallbackOrders({String? errorMessage, bool isSyncing = false}) {
    final fallbackPriority = WorkOrderEntity(
      workOrderId: 'mock-090',
      orderCode: 'OT-2026-90',
      description: 'Instalación / Inspección de Medidor',
      location: 'Sector 5',
      cadastralKey: '5-102',
      clientId: 'Carlos Andrade',
      status: 'EN_PROCESO',
      priorityId: 4,
      workTypeId: 2,
    );

    final fallbackToday = [
      WorkOrderEntity(
        workOrderId: 'mock-091',
        orderCode: 'OT-2026-0091',
        description: 'Revisión de fuga',
        location: 'Sector 3',
        cadastralKey: '3-045',
        clientId: 'María López',
        status: 'PENDIENTE',
        priorityId: 3,
        workTypeId: 1,
      ),
      WorkOrderEntity(
        workOrderId: 'mock-092',
        orderCode: 'OT-2026-0092',
        description: 'Cambio de medidor dañado',
        location: 'Sector 1',
        cadastralKey: '1-112',
        clientId: 'Juan Pérez',
        status: 'PENDIENTE',
        priorityId: 2,
        workTypeId: 2,
      ),
      WorkOrderEntity(
        workOrderId: 'mock-093',
        orderCode: 'OT-2026-0093',
        description: 'Corte / Suspensión',
        location: 'Sector 4',
        cadastralKey: '4-089',
        clientId: 'Rosa Gómez',
        status: 'PENDIENTE',
        priorityId: 2,
        workTypeId: 3,
      ),
    ];

    emit(TechnicianInitialState(
      isLoading: false,
      isSyncing: isSyncing,
      errorMessage: errorMessage,
      pendingCount: 3,
      inProgressCount: 1,
      completedCount: 5,
      priorityOrder: fallbackPriority,
      todayOrders: fallbackToday,
      allOrders: [fallbackPriority, ...fallbackToday],
    ));
  }
}
