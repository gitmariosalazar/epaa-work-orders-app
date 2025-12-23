// features/work-orders/presentation/cubits/work-orders/work_orders_cubit.dart

import 'package:clean_architecture/features/work-orders/domain/usecases/get_all_work_order_use_case.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'work_orders_state.dart';

class WorkOrdersCubit extends Cubit<WorkOrdersState> {
  final GetAllWorkOrdersUseCase getAllWorkOrdersUseCase;

  WorkOrdersCubit({required this.getAllWorkOrdersUseCase})
    : super(WorkOrdersInitial());

  Future<void> loadWorkOrders() async {
    // Evita llamadas duplicadas si ya está cargando
    if (state is WorkOrdersLoading) return;

    emit(WorkOrdersLoading());

    try {
      final result = await getAllWorkOrdersUseCase();

      result.when(
        success: (entities) {
          if (entities.isEmpty) {
            emit(WorkOrdersEmpty());
          } else {
            emit(WorkOrdersLoaded(entities));
          }
        },
        failure: (message, errorType) {
          emit(WorkOrdersError(message ?? 'Error del servidor'));
        },
        loading: () {
          // No debería llegar aquí, pero por seguridad
          if (state is! WorkOrdersLoading) if (isClosed) return;
          emit(WorkOrdersLoading());
        },
      );
    } catch (e, stackTrace) {
      // Captura cualquier error inesperado (red, parsing, timeout, etc.)
      print('WorkOrdersCubit ERROR: $e');
      print(stackTrace);
      emit(
        WorkOrdersError('Error de conexión o inesperado. Intenta de nuevo.'),
      );
    }
  }
}
