// features/dashboard/presentation/pages/technician/cubit/technician_initial_cubit.dart

import 'package:clean_architecture/core/data_states/data_state.dart';
import 'package:clean_architecture/core/services/session/session_service.dart';
import 'package:clean_architecture/features/dashboard/domain/entities/executive_overview_entity.dart';
import 'package:clean_architecture/features/dashboard/domain/entities/technician_dashboard_entities.dart';
import 'package:clean_architecture/features/dashboard/domain/entities/work_order_statistics_entities.dart';
import 'package:clean_architecture/features/dashboard/domain/usecases/executive_overview_use_cases.dart';
import 'package:clean_architecture/features/dashboard/domain/usecases/operations_analytics_use_cases.dart';
import 'package:clean_architecture/features/dashboard/domain/usecases/work_order_statistics_use_cases.dart';
import 'package:clean_architecture/features/work-orders/domain/entities/work_order_entity.dart';
import 'package:clean_architecture/features/work-orders/domain/usecases/get_all_work_order_use_case.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'technician_initial_state.dart';

class TechnicianInitialCubit extends Cubit<TechnicianInitialState> {
  final GetAllWorkOrdersUseCase getAllWorkOrdersUseCase;
  final GetTechnicianDailyFeedUseCase? getTechnicianDailyFeedUseCase;
  final GetWorkOrderStatusStatisticsUseCase?
  getWorkOrderStatusStatisticsUseCase;
  final GetHeaderKpisUseCase? getHeaderKpisUseCase;

  TechnicianInitialCubit({
    required this.getAllWorkOrdersUseCase,
    this.getTechnicianDailyFeedUseCase,
    this.getWorkOrderStatusStatisticsUseCase,
    this.getHeaderKpisUseCase,
  }) : super(TechnicianInitialState.initial());

  @override
  void emit(TechnicianInitialState state) {
    if (!isClosed) {
      super.emit(state);
    }
  }

  /// Carga inicial de datos reales de órdenes de trabajo y cálculo de KPIs globales.
  Future<void> loadInitialData({bool isRefresh = false}) async {
    if (isClosed) return;
    if (!isRefresh && !state.isLoading) {
      emit(state.copyWith(isLoading: true, errorMessage: null));
    }

    try {
      // 1. Obtener estadísticas reales globales de la BD (conteo total de todos los registros)
      final globalKpis = await _fetchGlobalStatusCounts();
      if (isClosed) return;

      // 2. Intentar primero con el feed operativo especializado del técnico si está disponible
      if (getTechnicianDailyFeedUseCase != null) {
        final technicianId = SessionUtil.I.isLoggedIn
            ? SessionUtil.I.userData.user.userId
            : null;
        final feedResult = await getTechnicianDailyFeedUseCase!(technicianId);
        if (isClosed) return;

        if (feedResult is SuccessState<List<TechnicianDailyFeedItemEntity>>) {
          final feedItems = feedResult.data ?? [];
          if (feedItems.isNotEmpty) {
            final mappedOrders = feedItems
                .map((e) => _mapDailyFeedToWorkOrder(e))
                .toList();
            _processAndEmitOrders(
              mappedOrders,
              explicitPending: globalKpis?.$1,
              explicitInProgress: globalKpis?.$2,
              explicitCompleted: globalKpis?.$3,
            );
            return;
          }
        }
      }

      // 3. Consulta de órdenes de trabajo del repositorio principal
      final result = await getAllWorkOrdersUseCase(limit: 50, offset: 0);
      if (isClosed) return;

      if (result is SuccessState<List<WorkOrderEntity>>) {
        final orders = result.data ?? [];
        if (orders.isEmpty && globalKpis == null) {
          _emitEmptyOrders();
        } else {
          _processAndEmitOrders(
            orders,
            explicitPending: globalKpis?.$1,
            explicitInProgress: globalKpis?.$2,
            explicitCompleted: globalKpis?.$3,
          );
        }
      } else if (result is FailureState<List<WorkOrderEntity>>) {
        if (globalKpis != null) {
          _processAndEmitOrders(
            [],
            explicitPending: globalKpis.$1,
            explicitInProgress: globalKpis.$2,
            explicitCompleted: globalKpis.$3,
          );
        } else {
          _emitEmptyOrders(
            errorMessage:
                result.message ?? 'No se pudieron sincronizar las órdenes',
          );
        }
      } else {
        _emitEmptyOrders();
      }
    } catch (e) {
      if (isClosed) return;
      _emitEmptyOrders(errorMessage: 'Error al conectar: $e');
    }
  }

  /// Sincroniza las órdenes de trabajo con el backend en tiempo real.
  Future<void> syncData() async {
    if (isClosed) return;
    emit(state.copyWith(isSyncing: true, errorMessage: null));

    try {
      // 1. Refrescar métricas globales reales
      final globalKpis = await _fetchGlobalStatusCounts();
      if (isClosed) return;

      // 2. Refrescar feed de técnico si aplica
      if (getTechnicianDailyFeedUseCase != null) {
        final technicianId = SessionUtil.I.isLoggedIn
            ? SessionUtil.I.userData.user.userId
            : null;
        final feedResult = await getTechnicianDailyFeedUseCase!(technicianId);
        if (isClosed) return;

        if (feedResult is SuccessState<List<TechnicianDailyFeedItemEntity>>) {
          final feedItems = feedResult.data ?? [];
          if (feedItems.isNotEmpty) {
            final mappedOrders = feedItems
                .map((e) => _mapDailyFeedToWorkOrder(e))
                .toList();
            _processAndEmitOrders(
              mappedOrders,
              isSyncing: false,
              explicitPending: globalKpis?.$1,
              explicitInProgress: globalKpis?.$2,
              explicitCompleted: globalKpis?.$3,
            );
            return;
          }
        }
      }

      // 3. Refrescar listado general
      final result = await getAllWorkOrdersUseCase(limit: 50, offset: 0);
      if (isClosed) return;

      if (result is SuccessState<List<WorkOrderEntity>>) {
        final orders = result.data ?? [];
        _processAndEmitOrders(
          orders,
          isSyncing: false,
          explicitPending: globalKpis?.$1,
          explicitInProgress: globalKpis?.$2,
          explicitCompleted: globalKpis?.$3,
        );
      } else if (result is FailureState<List<WorkOrderEntity>>) {
        emit(
          state.copyWith(
            isSyncing: false,
            errorMessage: result.message ?? 'Fallo de sincronización',
          ),
        );
      } else {
        emit(state.copyWith(isSyncing: false));
      }
    } catch (e) {
      if (isClosed) return;
      emit(
        state.copyWith(
          isSyncing: false,
          errorMessage: 'Error de sincronización: $e',
        ),
      );
    }
  }

  /// Consulta los totales globales reales de estados en toda la base de datos
  /// Retorna una tupla: (pendientes, enCurso, completadas)
  Future<(int, int, int)?> _fetchGlobalStatusCounts() async {
    try {
      // Opción Principal: GetHeaderKpisUseCase (KPIs agregados de cabecera directamente desde el backend)
      if (getHeaderKpisUseCase != null) {
        final headerResult = await getHeaderKpisUseCase!();
        if (headerResult is SuccessState<HeaderKpisEntity> &&
            headerResult.data != null) {
          final h = headerResult.data!;
          int p = h.pendingOrAssigned;
          int ip = h.inProgress;
          int c = h.completed;

          // Salvaguarda: si en_progreso viene en 0 del backend pero el total supera pendientes + completadas
          if (ip == 0 && h.totalOrders > (p + c)) {
            ip = h.totalOrders - (p + c);
          }

          return (p, ip, c);
        }
      }

      // Opción Secundaria / Fallback: GetWorkOrderStatusStatisticsUseCase (conteo agrupado de la tabla orden_trabajo)
      if (getWorkOrderStatusStatisticsUseCase != null) {
        final statsResult = await getWorkOrderStatusStatisticsUseCase!();
        if (statsResult is SuccessState<List<WorkOrderStatusStatisticEntity>>) {
          final stats = statsResult.data ?? [];
          if (stats.isNotEmpty) {
            int p = 0;
            int ip = 0;
            int c = 0;

            for (final item in stats) {
              final sid = item.statusId.toUpperCase().trim();
              final sname = item.statusName.toUpperCase().trim();

              if (sid.contains('COMPLETADA') ||
                  sid.contains('EJECUTADA') ||
                  sid.contains('FINALIZADA') ||
                  sname.contains('COMPLETADA') ||
                  sname.contains('EJECUTADA')) {
                c += item.quantity;
              } else if (sid.contains('PROCESO') ||
                  sid.contains('PROGRESO') ||
                  sid == 'PREPARACION' ||
                  sid == 'EN_ESPERA' ||
                  sname.contains('PROCESO') ||
                  sname.contains('PROGRESO')) {
                ip += item.quantity;
              } else if (sid.contains('PENDIENTE') ||
                  sid.contains('NOTIFICADA') ||
                  sid.contains('CREADA') ||
                  sid == 'ASIGNADA' ||
                  sid == 'REASIGNADA' ||
                  sname.contains('PENDIENTE') ||
                  sname.contains('ASIGNADA')) {
                p += item.quantity;
              }
            }
            return (p, ip, c);
          }
        }
      }
    } catch (_) {
      // Ignorar fallo y degradar a conteo de lista local
    }
    return null;
  }

  void _processAndEmitOrders(
    List<WorkOrderEntity> orders, {
    bool isSyncing = false,
    int? explicitPending,
    int? explicitInProgress,
    int? explicitCompleted,
  }) {
    if (isClosed) return;
    int pending = explicitPending ?? 0;
    int inProgress = explicitInProgress ?? 0;
    int completed = explicitCompleted ?? 0;

    // Si no vinieron estadísticas globales exactas del backend, calcular sobre la lista local
    if (explicitPending == null &&
        explicitInProgress == null &&
        explicitCompleted == null) {
      for (final order in orders) {
        final st = order.status.trim().toUpperCase();
        if (st.contains('COMPLETADA') || st.contains('EJECUTADA')) {
          completed++;
        } else if (st.contains('PROCESO') ||
            st == 'PREPARACION') {
          inProgress++;
        } else if (st == 'PENDIENTE' || st == 'NOTIFICADA' || st == 'ASIGNADA') {
          pending++;
        }
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
      // 2. Buscar por alta prioridad entre las no completadas
      final highPriority = orders.where((o) {
        final st = o.status.trim().toUpperCase();
        return o.priorityId >= 4 && !st.contains('COMPLETADA');
      }).toList();

      if (highPriority.isNotEmpty) {
        priority = highPriority.first;
      } else {
        final activeOrders = orders.where((o) {
          final st = o.status.trim().toUpperCase();
          return !st.contains('COMPLETADA');
        }).toList();

        if (activeOrders.isNotEmpty) {
          priority = activeOrders.first;
        }
      }
    }

    // Órdenes de hoy (excluir la que está como destacada para evitar duplicar)
    final todayList = orders
        .where((o) => priority == null || o.orderCode != priority.orderCode)
        .take(5)
        .toList();

    emit(
      TechnicianInitialState(
        isLoading: false,
        isSyncing: isSyncing,
        pendingCount: pending,
        inProgressCount: inProgress,
        completedCount: completed,
        priorityOrder: priority,
        todayOrders: todayList,
        allOrders: orders,
      ),
    );
  }

  void _emitEmptyOrders({String? errorMessage, bool isSyncing = false}) {
    if (isClosed) return;
    emit(
      TechnicianInitialState(
        isLoading: false,
        isSyncing: isSyncing,
        errorMessage: errorMessage,
        pendingCount: 0,
        inProgressCount: 0,
        completedCount: 0,
        priorityOrder: null,
        todayOrders: const [],
        allOrders: const [],
      ),
    );
  }

  WorkOrderEntity _mapDailyFeedToWorkOrder(TechnicianDailyFeedItemEntity item) {
    int parsedPriority = 3;
    final pUpper = item.prioridad.toUpperCase();
    if (pUpper.contains('EMERGENCIA') || pUpper.contains('CRÍTICA')) {
      parsedPriority = 5;
    } else if (pUpper.contains('URGENTE') || pUpper.contains('ALTA')) {
      parsedPriority = 4;
    } else if (pUpper.contains('MEDIA')) {
      parsedPriority = 3;
    } else if (pUpper.contains('BAJA')) {
      parsedPriority = 2;
    }

    return WorkOrderEntity(
      workOrderId: item.idOrdenTrabajo.toString(),
      orderCode: item.codigoOrden,
      status: item.estado,
      description: item.tipoTrabajo,
      location: (item.direccion != null && item.direccion!.trim().isNotEmpty)
          ? item.direccion!.trim()
          : (item.ubicacionDetalles ?? ''),
      cadastralKey: item.claveCatastral ?? '',
      clientId: '',
      latitude: item.latitud,
      longitude: item.longitud,
      priorityId: parsedPriority,
      workTypeId: 1,
      creationDate: item.fechaAsignacion != null
          ? DateTime.tryParse(item.fechaAsignacion!)
          : null,
      assignationDate: item.fechaAsignacion != null
          ? DateTime.tryParse(item.fechaAsignacion!)
          : null,
    );
  }
}
