import 'package:clean_architecture/features/work-orders/domain/entities/add_work_order_attachment_entity.dart';
import 'package:clean_architecture/features/work-orders/domain/usecases/add_work_order_attachment_use_case.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'add-work_order_attachments_state.dart';

class AddWorkOrderAttachmentsCubit extends Cubit<AddWorkOrderAttachmentsState> {
  final AddWorkOrderAttachmentUseCase _addWorkOrderAttachmentUseCase;

  AddWorkOrderAttachmentsCubit({
    required AddWorkOrderAttachmentUseCase addWorkOrderAttachmentUseCase,
  }) : _addWorkOrderAttachmentUseCase = addWorkOrderAttachmentUseCase,
       super(AddWorkOrderAttachmentsInitial());

  Future<void> addAttachmentsToWorkOrder(
    List<AddWorkOrderAttachmentEntity> attachments,
  ) async {
    emit(AddWorkOrderAttachmentsLoading());

    try {
      final params = AddWorkOrderAttachmentParams(
        workOrderId: attachments.first.workOrderId,
        files:
            [], // Aquí deberías mapear los attachments a PlatformFile si es necesario
        description: '', // Puedes agregar una descripción si es necesario  
      );
      final result = await _addWorkOrderAttachmentUseCase(params);

      result.when(
        success: (addedAttachments) {
          emit(AddWorkOrderAttachmentsSuccess(addedAttachments));
        },
        failure: (message, errorType) {
          emit(
            AddWorkOrderAttachmentsError(
              message ?? 'Error al agregar las asignaciones',
            ),
          );
        },
        loading: () {
          if (state is! AddWorkOrderAttachmentsLoading) if (isClosed) return;
          emit(AddWorkOrderAttachmentsLoading());
        },
      );
    } catch (e) {
      emit(AddWorkOrderAttachmentsError('Error inesperado: $e'));
    }
  }
}
