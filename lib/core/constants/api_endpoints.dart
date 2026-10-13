// core/constants/api_endpoints.dart

class ApiEndpoints {
  ApiEndpoints._();

  /// Base paths
  static const auth = "auth";
  static const workOrders = "work-orders"; // ← Nueva base para tu feature
  static const products = "inventory"; // ← Nueva base para tu feature
  static const assignments = "work-order-worker-assignment";
  static const materials = "detail-work-order-materials";
  static const workers = "worker-gateway";
  static const workOrderAttachments = "work-order-attachments";
  static const connections = "connections";

  // Auth
  static const login = "$auth/signin";
  static const refreshToken = "$auth/refresh";
  static const checkAuth = "$auth/check-auth";

  // Work Orders
  static const getAllWorkOrders = "$workOrders/get-all-work-orders";
  static const createWorkOrder = "$processWorkOrders/create-work-order";
  static const updateWorkOrder = "$workOrders/update-work-order";
  static const deleteWorkOrder = "$workOrders/delete-work-order";
  static const getWorkOrderById = "$workOrders/get-by-id"; // si lo necesitas

  // Process Work Orders
  static const String processWorkOrders = "process-work-orders";
  static const String createWorkOrderFromIncident =
      "$processWorkOrders/create-work-order-from-incident";
  static const String receiveWorkOrder =
      "$processWorkOrders/receive-work-order";
  static const String assignWorkOrderToCrew =
      "$processWorkOrders/assign-work-order-to-crew";
  static const String assignWorkOrderToWorker =
      "$processWorkOrders/assign-work-order-to-worker";
  static const String startPreparation = "$processWorkOrders/start-preparation";
  static const String createPreparationInspection =
      "$processWorkOrders/create-preparation-inspection";
  static const String addPreparationInspectionDetail =
      "$processWorkOrders/add-preparation-inspection-detail";
  static const String resolvePreparationInspection =
      "$processWorkOrders/resolve-preparation-inspection";
  static const String startExecution = "$processWorkOrders/start-execution";
  static const String addWorkOrderMaterial =
      "$processWorkOrders/add-work-order-material";
  static const String addWorkOrderMaterialsBatch =
      "$processWorkOrders/add-work-order-materials-batch";
  static const String addAdditionalCost =
      "$processWorkOrders/add-additional-cost";
  static const String addAdditionalCostsBatch =
      "$processWorkOrders/add-additional-costs-batch";
  static const String finishExecution = "$processWorkOrders/finish-execution";
  static const String createQualityControl =
      "$processWorkOrders/create-quality-control";
  static const String addQualityControlDetail =
      "$processWorkOrders/add-quality-control-detail";
  static const String resolveQualityControl =
      "$processWorkOrders/resolve-quality-control";
  static const String completeWorkOrder =
      "$processWorkOrders/complete-work-order";
  static const String registerSatisfactionSurvey =
      "$processWorkOrders/register-satisfaction-survey";
  static const String getDetalleByNumeroOrden =
      "$processWorkOrders/get-detalle-by-numero-orden";
  static const String getTrackingByNumeroOrden =
      "$processWorkOrders/get-tracking-by-numero-orden";
  static const String getOrdenesBySolicitudId =
      "$processWorkOrders/get-ordenes-by-solicitud-id";
  static const String addWorkerToWorkOrder = "$processWorkOrders/add-worker";
  static const String addWorkersBatchToWorkOrder =
      "$processWorkOrders/add-workers-batch";
  static const String removeWorkerFromWorkOrder =
      "$processWorkOrders/remove-worker";
  static const String advanceWorkOrderState =
      "$processWorkOrders/advance-state";
  static const String processAddWorkOrderAttachment =
      "$processWorkOrders/add-work-order-attachment";

  // Workers
  static const getAllWorkers = "$workers/find-all-workers";

  // Paginated Workers
  static const getAllWorkersPaginated = "$workers/find-all-workers-paginated";

  static const getAllProductsMaterials = "$products/get-all-inventories";
  static const getAllProductsMaterialsPaginated =
      "$products/find-all-inventories-paginated";

  // Work Order Assignments
  static const addWorkOrderAssignment =
      "$assignments/add-work-order-worker-assignments";

  // Work Order Materials
  static const addMaterialWorkOrders =
      "$materials/create-detail-work-order-materials";

  // Work Order Attachments
  static const addWorkOrderAttachment =
      "$workOrderAttachments/add-work-order-attachment";

  // Connections
  static const getAllConnections = "$connections/get-all-connections";

  static const getAllConnectionsPaginated =
      "$connections/get-all-connections-with-property";

  static const findConnectionByCadastralKeyOrCardId =
      "$connections/find-connection-by-cadastral-key-or-card-id";

  static const findConnectionWithPropertyByCadastralKey =
      "$connections/find-connection-with-property-by-cadastral-key";
}
