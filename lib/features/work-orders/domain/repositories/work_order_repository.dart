import 'package:clean_architecture/features/work-orders/domain/entities/evidence_stage.dart';
import 'package:clean_architecture/features/work-orders/domain/params/create_work_order_from_incident_params.dart';
import 'package:clean_architecture/core/utils/type_defs.dart';
import 'package:clean_architecture/features/work-orders/domain/entities/work_order_detail_entity.dart';
import 'package:clean_architecture/features/work-orders/domain/entities/work_order_entity.dart';
import 'package:clean_architecture/features/work-orders/domain/entities/work_order_tracking_entity.dart';

abstract interface class WorkOrderRepository {
  FutureData<List<WorkOrderEntity>> getAllWorkOrders({
    String? searchValue,
    int? limit,
    int? offset,
  });
  FutureData<WorkOrderEntity> createWorkOrder(WorkOrderEntity order);

  // Process Work Order Endpoints
  FutureData<void> createWorkOrderFromIncident(
    CreateWorkOrderFromIncidentParams request,
  );
  FutureData<void> receiveWorkOrder(dynamic request);
  FutureData<void> assignWorkOrderToCrew(dynamic request);
  FutureData<void> assignWorkOrderToWorker(dynamic request);
  FutureData<void> startPreparation(dynamic request);
  FutureData<void> createPreparationInspection(dynamic request);
  FutureData<void> addPreparationInspectionDetail(dynamic request);
  FutureData<void> resolvePreparationInspection(dynamic request);
  FutureData<void> startExecution(dynamic request);
  FutureData<void> addWorkOrderMaterial(dynamic request);
  FutureData<void> addWorkOrderMaterialsBatch(dynamic request);
  FutureData<void> addAdditionalCost(dynamic request);
  FutureData<void> addAdditionalCostsBatch(dynamic request);
  FutureData<void> addWorkOrderAttachment(
    String workOrderId,
    List<String> filePaths, {
    String? createdByUserId,
    EvidenceStage? evidenceStage,
  });
  FutureData<void> finishExecution(dynamic request);
  FutureData<void> createQualityControl(dynamic request);
  FutureData<void> addQualityControlDetail(dynamic request);
  FutureData<void> resolveQualityControl(dynamic request);
  FutureData<void> completeWorkOrder(dynamic request);
  FutureData<void> registerSatisfactionSurvey(dynamic request);
  FutureData<WorkOrderDetailEntity> getDetalleByNumeroOrden(String numeroOrden);
  FutureData<WorkOrderTrackingEntity> getTrackingByNumeroOrden(
    String numeroOrden,
  );
  FutureData<List<WorkOrderEntity>> getOrdenesBySolicitudId(String solicitudId);
  FutureData<void> addWorkerToWorkOrder(dynamic request);
  FutureData<void> addWorkersBatchToWorkOrder(dynamic request);
  FutureData<void> removeWorkerFromWorkOrder(dynamic request);
  FutureData<void> advanceWorkOrderState(dynamic request);
}
