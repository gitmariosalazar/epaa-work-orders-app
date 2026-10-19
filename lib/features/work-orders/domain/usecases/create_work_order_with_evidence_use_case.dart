import 'package:clean_architecture/core/data_states/data_state.dart';
import 'package:clean_architecture/core/domain/use_cases/use_case.dart';
import 'package:clean_architecture/core/utils/type_defs.dart';
import 'package:clean_architecture/features/work-orders/domain/entities/create_work_order_result.dart';
import 'package:clean_architecture/features/work-orders/domain/entities/evidence_stage.dart';
import 'package:clean_architecture/features/work-orders/domain/entities/work_order_entity.dart';
import 'package:clean_architecture/features/work-orders/domain/usecases/create_work_order_use_case.dart';
import 'package:clean_architecture/features/work-orders/domain/usecases/process/process_work_order_use_cases.dart';
import 'package:injectable/injectable.dart';

/// Crea la orden y sube sus evidencias iniciales (REPORTE_INICIAL).
/// Si la subida falla, la orden sigue siendo válida y se informa un warning.
@lazySingleton
class CreateWorkOrderWithEvidenceUseCase
    implements UseCase<CreateWorkOrderResult, WorkOrderEntity> {
  final CreateWorkOrderUseCase _createWorkOrder;
  final UploadWorkOrderAttachmentsUseCase _uploadAttachments;

  CreateWorkOrderWithEvidenceUseCase(
    this._createWorkOrder,
    this._uploadAttachments,
  );

  @override
  FutureData<CreateWorkOrderResult> call(WorkOrderEntity params) async {
    final created = await _createWorkOrder(params);

    return created.when(
      success: (order) async {
        final files = params.attachments ?? const [];
        if (files.isEmpty) {
          return SuccessState<CreateWorkOrderResult>(
            data: CreateWorkOrderResult(order: order),
          );
        }

        final workOrderId = order.workOrderId;
        if (workOrderId == null || workOrderId.isEmpty) {
          return SuccessState<CreateWorkOrderResult>(
            data: CreateWorkOrderResult(
              order: order,
              evidenceWarning:
                  'No se obtuvo el ID de la orden para adjuntar las evidencias.',
            ),
          );
        }

        final uploaded = await _uploadAttachments(
          UploadWorkOrderAttachmentsParams(
            workOrderId: workOrderId,
            filePaths: files.map((f) => f.path).toList(),
            createdByUserId: params.createdByUserId,
            evidenceStage: EvidenceStage.initialReport,
          ),
        );

        final warning = uploaded.when(
          success: (_) => null,
          failure: (message, _) =>
              message ?? 'No se pudieron subir las evidencias.',
          loading: () => null,
        );
        return SuccessState<CreateWorkOrderResult>(
          data: CreateWorkOrderResult(order: order, evidenceWarning: warning),
        );
      },
      failure: (message, errorType) async =>
          FailureState<CreateWorkOrderResult>(
            message: message,
            errorType: errorType,
          ),
      loading: () async => LoadingState<CreateWorkOrderResult>(),
    );
  }
}
