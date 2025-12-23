// features/work-orders/domain/usecases/add_work_order_assignment_usecase.dart

import 'package:clean_architecture/core/data_states/data_state.dart';
import 'package:clean_architecture/core/domain/use_cases/use_case.dart';
import 'package:clean_architecture/core/utils/type_defs.dart';
import 'package:clean_architecture/features/work-orders/domain/entities/add_work_order_assignment.dart';
import 'package:clean_architecture/features/work-orders/domain/repositories/add_work_order_assignment_repository.dart';

import 'package:injectable/injectable.dart';

/// UseCase para asignar uno o varios trabajadores a una orden de trabajo
@lazySingleton
class AddWorkOrderAssignmentUseCase
    implements
        UseCase<
          List<AddWorkOrderAssignmentEntity>,
          AddWorkOrderAssignmentParams
        > {
  final AddWorkOrderAssignmentRepository _repository;

  AddWorkOrderAssignmentUseCase(this._repository);

  @override
  FutureData<List<AddWorkOrderAssignmentEntity>> call(
    AddWorkOrderAssignmentParams params,
  ) async {
    try {
      final result = await _repository.addAssignmentToWorkOrder(
        params.assignments,
      );
      return SuccessState<List<AddWorkOrderAssignmentEntity>>(
        data: result is SuccessState ? result.data : [],
      );
    } catch (e) {
      return FailureState<List<AddWorkOrderAssignmentEntity>>(
        message: e.toString(),
        errorType: ErrorType.unknown,
      );
    }
  }
}

/// Parámetros para el UseCase
/// Contiene el ID de la orden y la lista de asignaciones
class AddWorkOrderAssignmentParams {
  final List<AddWorkOrderAssignmentEntity> assignments;

  AddWorkOrderAssignmentParams({required this.assignments});
}
