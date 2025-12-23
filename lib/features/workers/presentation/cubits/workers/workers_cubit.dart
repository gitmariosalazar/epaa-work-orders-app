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

      result.when(
        success: (entities) {
          if (entities.isEmpty) {
            emit(WorkersEmpty());
          } else {
            emit(WorkersLoaded(entities));
          }
        },
        failure: (message, errorType) {
          emit(WorkersError(message ?? 'Error del servidor'));
        },
        loading: () {
          // No debería llegar aquí, pero por seguridad
          if (state is! WorkersLoading) if (isClosed) return;
          emit(WorkersLoading());
        },
      );
    } catch (e, stackTrace) {
      // Captura cualquier error inesperado (red, parsing, timeout, etc.)
      print('WorkersCubit ERROR: $e');
      print(stackTrace);
      emit(WorkersError('Error de conexión o inesperado. Intenta de nuevo.'));
    }
  }
}
