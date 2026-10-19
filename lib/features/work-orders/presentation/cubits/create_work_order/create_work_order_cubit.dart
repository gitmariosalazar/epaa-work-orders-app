import 'package:clean_architecture/features/work-orders/domain/entities/work_order_entity.dart';
import 'package:clean_architecture/features/work-orders/domain/usecases/create_work_order_with_evidence_use_case.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

part 'create_work_order_state.dart';

@injectable
class CreateWorkOrderCubit extends Cubit<CreateWorkOrderState> {
  final CreateWorkOrderWithEvidenceUseCase _createWorkOrderUseCase;

  CreateWorkOrderCubit({
    required CreateWorkOrderWithEvidenceUseCase createWorkOrderUseCase,
  }) : _createWorkOrderUseCase = createWorkOrderUseCase,
       super(CreateWorkOrderInitial());

  Future<void> createWorkOrder(WorkOrderEntity order) async {
    emit(CreateWorkOrderLoading());

    try {
      final result = await _createWorkOrderUseCase(order);

      result.when(
        success: (result) {
          emit(
            CreateWorkOrderSuccess(
              result.order,
              evidenceWarning: result.evidenceWarning,
            ),
          );
        },
        failure: (message, errorType) {
          emit(CreateWorkOrderError(message ?? 'Error al crear la orden'));
        },
        loading: () {
          // No debería llegar aquí, pero por seguridad
          if (state is! CreateWorkOrderLoading) if (isClosed) return;
          emit(CreateWorkOrderLoading());
        },
      );
    } catch (e) {
      emit(CreateWorkOrderError('Error inesperado: $e'));
    }
  }
}
