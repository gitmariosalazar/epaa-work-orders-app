// core/constants/api_endpoints.dart

class ApiEndpoints {
  ApiEndpoints._();

  /// Base paths
  static const auth = "api/auth/";
  static const workOrders = "work-orders/"; // ← Nueva base para tu feature
  static const products = "inventory/"; // ← Nueva base para tu feature
  static const assignments = "work-order-worker-assignment/";
  static const materials = "/detail-work-order-materials/";
  static const workers = "worker-gateway/";
  static const workOrderAttachments = "work-order-attachments/";
  static const connections = "connections/";

  // Auth
  static const login = "${auth}login";
  static const refreshToken = "${auth}refreshToken";
  static const checkAuth = "${auth}check-auth";

  // Work Orders
  static const getAllWorkOrders = "$workOrders/get-all-work-orders";
  static const createWorkOrder = "$workOrders/create-work-order";
  static const updateWorkOrder = "$workOrders/update-work-order";
  static const deleteWorkOrder = "$workOrders/delete-work-order";
  static const getWorkOrderById = "$workOrders/get-by-id"; // si lo necesitas
  // Agrega más según tus endpoints reales

  // Workers
  static const getAllWorkers = "$workers/find-all-workers";
  static const getAllProductsMaterials = "$products/get-all-inventories";

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
  static const getAllConnections = "${connections}get-all-connections";
}
