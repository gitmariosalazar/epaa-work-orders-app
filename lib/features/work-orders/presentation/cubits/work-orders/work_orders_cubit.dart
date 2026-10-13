// features/work-orders/presentation/cubits/work_orders/work_orders_cubit.dart

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:clean_architecture/features/work-orders/domain/entities/work_order_entity.dart';
import 'package:clean_architecture/features/work-orders/domain/usecases/get_all_work_order_use_case.dart';

import 'work_orders_state.dart';

class WorkOrdersCubit extends Cubit<WorkOrdersState> {
  final GetAllWorkOrdersUseCase getAllWorkOrdersUseCase;

  WorkOrdersCubit({required this.getAllWorkOrdersUseCase})
    : super(WorkOrdersInitial());

  static const int _pageSize = 25;

  int _currentOffset = 0;
  bool _hasReachedEnd = false;
  final List<WorkOrderEntity> _cachedOrders = [];

  Future<void> loadWorkOrders({bool refresh = false}) async {
    if (refresh) {
      _currentOffset = 0;
      _hasReachedEnd = false;
      _cachedOrders.clear();
    }

    if (_hasReachedEnd && !refresh) return;

    final isLoading =
        state is WorkOrdersLoading ||
        (state is WorkOrdersLoaded &&
            (state as WorkOrdersLoaded).isLoadingMore);

    if (isLoading && !refresh) return;

    if (_currentOffset == 0 || refresh) {
      emit(WorkOrdersLoading());
    } else {
      emit((state as WorkOrdersLoaded).copyWith(isLoadingMore: true));
    }

    try {
      final result = await getAllWorkOrdersUseCase(
        limit: _pageSize,
        offset: _currentOffset,
      );

      result.when(
        success: (newOrders) {
          if (refresh) _cachedOrders.clear();
          _cachedOrders.addAll(newOrders);

          final hasMore = newOrders.length == _pageSize;
          _hasReachedEnd = !hasMore;
          _currentOffset += newOrders.length;

          if (_cachedOrders.isEmpty) {
            emit(WorkOrdersEmpty());
          } else {
            emit(
              WorkOrdersLoaded(
                orders: List.from(_cachedOrders),
                isLoadingMore: false,
                hasMore: hasMore,
              ),
            );
          }
        },
        failure: (message, _) {
          if (_currentOffset > 0) {
            // Error al cargar más → mantener lista actual
            emit(
              (state as WorkOrdersLoaded).copyWith(
                isLoadingMore: false,
                partialErrorMessage: message ?? 'Error al cargar más órdenes',
              ),
            );
          } else {
            emit(WorkOrdersError(message ?? 'Error del servidor'));
          }
        },
        loading: () {}, // no debería llegar aquí
      );
    } catch (e, stackTrace) {
      print('WorkOrdersCubit ERROR: $e\n$stackTrace');

      if (_currentOffset > 0) {
        emit(
          (state as WorkOrdersLoaded).copyWith(
            isLoadingMore: false,
            partialErrorMessage: 'Error de conexión al cargar más',
          ),
        );
      } else {
        emit(WorkOrdersError('Error de conexión. Intenta nuevamente.'));
      }
    }
  }

  Future<void> loadMore() async {
    if (state is! WorkOrdersLoaded) return;
    final current = state as WorkOrdersLoaded;
    if (current.isLoadingMore || !current.hasMore) return;

    await loadWorkOrders();
  }
}
