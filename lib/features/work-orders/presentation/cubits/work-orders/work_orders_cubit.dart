// features/work-orders/presentation/cubits/work_orders/work_orders_cubit.dart

import 'package:flutter/foundation.dart';
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
  String? _searchValue;

  String? get searchValue => _searchValue;
  final List<WorkOrderEntity> _cachedOrders = [];

  /// Searches in the database by order code, card id or cadastral key.
  Future<void> search(String? value) {
    final trimmed = value?.trim();
    _searchValue = (trimmed == null || trimmed.isEmpty) ? null : trimmed;
    return loadWorkOrders(refresh: true);
  }

  Future<void> loadWorkOrders({bool refresh = false}) async {
    if (refresh) {
      _currentOffset = 0;
      _hasReachedEnd = false;
      _cachedOrders.clear();
    }

    if (_hasReachedEnd && !refresh) return;

    final currentState = state;
    final isLoading =
        currentState is WorkOrdersLoading ||
        (currentState is WorkOrdersLoaded && currentState.isLoadingMore);

    if (isLoading && !refresh) return;

    if (refresh || _currentOffset == 0 || currentState is! WorkOrdersLoaded) {
      emit(WorkOrdersLoading());
    } else {
      emit(currentState.copyWith(isLoadingMore: true));
    }

    try {
      final result = await getAllWorkOrdersUseCase(
        searchValue: _searchValue,
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
          final s = state;
          if (s is WorkOrdersLoaded && _currentOffset > 0) {
            // Error al cargar más → mantener lista actual
            emit(
              s.copyWith(
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
      debugPrint('WorkOrdersCubit ERROR: $e\n$stackTrace');

      final s = state;
      if (s is WorkOrdersLoaded && _currentOffset > 0) {
        emit(
          s.copyWith(
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
    final currentState = state;
    if (currentState is! WorkOrdersLoaded) return;
    if (currentState.isLoadingMore || !currentState.hasMore) return;

    await loadWorkOrders();
  }
}
