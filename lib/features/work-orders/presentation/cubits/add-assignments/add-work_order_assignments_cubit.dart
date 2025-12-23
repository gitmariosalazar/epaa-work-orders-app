import 'package:clean_architecture/features/work-orders/domain/entities/add_work_order_assignment.dart';
import 'package:clean_architecture/features/work-orders/domain/usecases/add_work_order_assignment_use_case.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

part 'add-work_order_assignments_state.dart';

class AddWorkOrderAssignmentsCubit extends Cubit<AddWorkOrderAssignmentsState> {
  final AddWorkOrderAssignmentUseCase _addWorkOrderAssignmentUseCase;

  AddWorkOrderAssignmentsCubit({
    required AddWorkOrderAssignmentUseCase addWorkOrderAssignmentUseCase,
  }) : _addWorkOrderAssignmentUseCase = addWorkOrderAssignmentUseCase,
       super(AddWorkOrderAssignmentsInitial());

  Future<void> addAssignmentsToWorkOrder(
    List<AddWorkOrderAssignmentEntity> assignments,
  ) async {
    emit(AddWorkOrderAssignmentsLoading());

    try {
      final params = AddWorkOrderAssignmentParams(assignments: assignments);
      final result = await _addWorkOrderAssignmentUseCase(params);

      result.when(
        success: (addedAssignments) {
          emit(AddWorkOrderAssignmentsSuccess(addedAssignments));
        },
        failure: (message, errorType) {
          emit(
            AddWorkOrderAssignmentsError(
              message ?? 'Error al agregar las asignaciones',
            ),
          );
        },
        loading: () {
          if (state is! AddWorkOrderAssignmentsLoading) if (isClosed) return;
          emit(AddWorkOrderAssignmentsLoading());
        },
      );
    } catch (e) {
      emit(AddWorkOrderAssignmentsError('Error inesperado: $e'));
    }
  }
}
