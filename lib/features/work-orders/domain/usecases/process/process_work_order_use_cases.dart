import 'package:clean_architecture/core/domain/use_cases/use_case.dart';
import 'package:clean_architecture/core/utils/type_defs.dart';
import 'package:clean_architecture/features/work-orders/data/models/requests/process_work_order_requests.dart';
import 'package:clean_architecture/features/work-orders/domain/repositories/work_order_repository.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class ReceiveWorkOrderUseCase
    implements UseCase<void, ProcessWorkOrderTransitionRequest> {
  final WorkOrderRepository _repository;

  ReceiveWorkOrderUseCase(this._repository);

  @override
  FutureData<void> call(ProcessWorkOrderTransitionRequest request) =>
      _repository.receiveWorkOrder(request);
}

@lazySingleton
class AssignWorkOrderToCrewUseCase
    implements UseCase<void, AssignWorkOrderToCrewRequest> {
  final WorkOrderRepository _repository;

  AssignWorkOrderToCrewUseCase(this._repository);

  @override
  FutureData<void> call(AssignWorkOrderToCrewRequest request) =>
      _repository.assignWorkOrderToCrew(request);
}

@lazySingleton
class AssignWorkOrderToWorkerUseCase
    implements UseCase<void, AssignWorkOrderToWorkerRequest> {
  final WorkOrderRepository _repository;

  AssignWorkOrderToWorkerUseCase(this._repository);

  @override
  FutureData<void> call(AssignWorkOrderToWorkerRequest request) =>
      _repository.assignWorkOrderToWorker(request);
}

@lazySingleton
class StartPreparationUseCase
    implements UseCase<void, ProcessWorkOrderTransitionRequest> {
  final WorkOrderRepository _repository;

  StartPreparationUseCase(this._repository);

  @override
  FutureData<void> call(ProcessWorkOrderTransitionRequest request) =>
      _repository.startPreparation(request);
}

@lazySingleton
class CreatePreparationInspectionUseCase
    implements UseCase<void, CreatePreparationInspectionRequest> {
  final WorkOrderRepository _repository;

  CreatePreparationInspectionUseCase(this._repository);

  @override
  FutureData<void> call(CreatePreparationInspectionRequest request) =>
      _repository.createPreparationInspection(request);
}

@lazySingleton
class ResolvePreparationInspectionUseCase
    implements UseCase<void, ResolvePreparationInspectionRequest> {
  final WorkOrderRepository _repository;

  ResolvePreparationInspectionUseCase(this._repository);

  @override
  FutureData<void> call(ResolvePreparationInspectionRequest request) =>
      _repository.resolvePreparationInspection(request);
}

@lazySingleton
class StartExecutionUseCase
    implements UseCase<void, ProcessWorkOrderTransitionRequest> {
  final WorkOrderRepository _repository;

  StartExecutionUseCase(this._repository);

  @override
  FutureData<void> call(ProcessWorkOrderTransitionRequest request) =>
      _repository.startExecution(request);
}

@lazySingleton
class FinishExecutionUseCase
    implements UseCase<void, ProcessWorkOrderTransitionRequest> {
  final WorkOrderRepository _repository;

  FinishExecutionUseCase(this._repository);

  @override
  FutureData<void> call(ProcessWorkOrderTransitionRequest request) =>
      _repository.finishExecution(request);
}

@lazySingleton
class AddWorkersBatchToWorkOrderUseCase
    implements UseCase<void, AddWorkersBatchToWorkOrderRequest> {
  final WorkOrderRepository _repository;

  AddWorkersBatchToWorkOrderUseCase(this._repository);

  @override
  FutureData<void> call(AddWorkersBatchToWorkOrderRequest request) =>
      _repository.addWorkersBatchToWorkOrder(request);
}

@lazySingleton
class RemoveWorkerFromWorkOrderUseCase
    implements UseCase<void, RemoveWorkerFromWorkOrderRequest> {
  final WorkOrderRepository _repository;

  RemoveWorkerFromWorkOrderUseCase(this._repository);

  @override
  FutureData<void> call(RemoveWorkerFromWorkOrderRequest request) =>
      _repository.removeWorkerFromWorkOrder(request);
}

@lazySingleton
class AddWorkOrderMaterialsBatchUseCase
    implements UseCase<void, AddWorkOrderMaterialsBatchRequest> {
  final WorkOrderRepository _repository;

  AddWorkOrderMaterialsBatchUseCase(this._repository);

  @override
  FutureData<void> call(AddWorkOrderMaterialsBatchRequest request) =>
      _repository.addWorkOrderMaterialsBatch(request);
}

@lazySingleton
class AddAdditionalCostsBatchUseCase
    implements UseCase<void, AddAdditionalCostsBatchRequest> {
  final WorkOrderRepository _repository;

  AddAdditionalCostsBatchUseCase(this._repository);

  @override
  FutureData<void> call(AddAdditionalCostsBatchRequest request) =>
      _repository.addAdditionalCostsBatch(request);
}

class UploadWorkOrderAttachmentsParams {
  final String workOrderId;
  final List<String> filePaths;
  final String? createdByUserId;

  UploadWorkOrderAttachmentsParams({
    required this.workOrderId,
    required this.filePaths,
    this.createdByUserId,
  });
}

@lazySingleton
class UploadWorkOrderAttachmentsUseCase
    implements UseCase<void, UploadWorkOrderAttachmentsParams> {
  final WorkOrderRepository _repository;

  UploadWorkOrderAttachmentsUseCase(this._repository);

  @override
  FutureData<void> call(UploadWorkOrderAttachmentsParams params) =>
      _repository.addWorkOrderAttachment(
        params.workOrderId,
        params.filePaths,
        createdByUserId: params.createdByUserId,
      );
}

@lazySingleton
class CreateQualityControlUseCase
    implements UseCase<void, CreateQualityControlRequest> {
  final WorkOrderRepository _repository;

  CreateQualityControlUseCase(this._repository);

  @override
  FutureData<void> call(CreateQualityControlRequest request) =>
      _repository.createQualityControl(request);
}

@lazySingleton
class CompleteWorkOrderUseCase
    implements UseCase<void, ProcessWorkOrderTransitionRequest> {
  final WorkOrderRepository _repository;

  CompleteWorkOrderUseCase(this._repository);

  @override
  FutureData<void> call(ProcessWorkOrderTransitionRequest request) =>
      _repository.completeWorkOrder(request);
}

@lazySingleton
class RegisterSatisfactionSurveyUseCase
    implements UseCase<void, RegisterSatisfactionSurveyRequest> {
  final WorkOrderRepository _repository;

  RegisterSatisfactionSurveyUseCase(this._repository);

  @override
  FutureData<void> call(RegisterSatisfactionSurveyRequest request) =>
      _repository.registerSatisfactionSurvey(request);
}

@lazySingleton
class AdvanceWorkOrderStateUseCase
    implements UseCase<void, AdvanceWorkOrderStateRequest> {
  final WorkOrderRepository _repository;

  AdvanceWorkOrderStateUseCase(this._repository);

  @override
  FutureData<void> call(AdvanceWorkOrderStateRequest request) =>
      _repository.advanceWorkOrderState(request);
}
