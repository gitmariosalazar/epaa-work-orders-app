import 'package:clean_architecture/features/workers/domain/usecases/get_all_workers_use_case.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'workers_state.dart';

class WorkersCubit extends Cubit<WorkersState> {
  final GetAllWorkersUseCase getAllWorkersUseCase;

  WorkersCubit({required this.getAllWorkersUseCase}) : super(WorkersInitial());
  Future<void> loadWorkers() async {
    // Evita llamadas duplicadas si ya está cargando
    if (state is WorkersLoading) return;

    emit(WorkersLoading());
    try {
      final result = await getAllWorkersUseCase();

      if (isClosed) return;

      result.when(
        success: (entities) {
          if (isClosed) return;
          if (entities.isEmpty) {
            emit(WorkersEmpty());
          } else {
            emit(WorkersLoaded(entities));
          }
        },
        failure: (message, errorType) {
          if (isClosed) return;
          emit(WorkersError(message ?? 'Error del servidor'));
        },
        loading: () {
          // No debería llegar aquí, pero por seguridad
          if (state is! WorkersLoading && !isClosed) {
            emit(WorkersLoading());
          }
        },
      );
    } catch (e, stackTrace) {
      // Captura cualquier error inesperado (red, parsing, timeout, etc.)
      print('WorkersCubit ERROR: $e');
      print(stackTrace);
      if (!isClosed) {
        emit(WorkersError('Error de conexión o inesperado. Intenta de nuevo.'));
      }
    }
  }
}
