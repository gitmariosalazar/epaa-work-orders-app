import os

endpoints = [
    ("createWorkOrderFromIncident", "createWorkOrderFromIncident", "Post"),
    ("receiveWorkOrder", "receiveWorkOrder", "Post"),
    ("assignWorkOrderToCrew", "assignWorkOrderToCrew", "Post"),
    ("assignWorkOrderToWorker", "assignWorkOrderToWorker", "Post"),
    ("startPreparation", "startPreparation", "Post"),
    ("createPreparationInspection", "createPreparationInspection", "Post"),
    ("addPreparationInspectionDetail", "addPreparationInspectionDetail", "Post"),
    ("resolvePreparationInspection", "resolvePreparationInspection", "Post"),
    ("startExecution", "startExecution", "Post"),
    ("addWorkOrderMaterial", "addWorkOrderMaterial", "Post"),
    ("addWorkOrderMaterialsBatch", "addWorkOrderMaterialsBatch", "Post"),
    ("addAdditionalCost", "addAdditionalCost", "Post"),
    ("addAdditionalCostsBatch", "addAdditionalCostsBatch", "Post"),
    ("finishExecution", "finishExecution", "Post"),
    ("createQualityControl", "createQualityControl", "Post"),
    ("addQualityControlDetail", "addQualityControlDetail", "Post"),
    ("resolveQualityControl", "resolveQualityControl", "Post"),
    ("completeWorkOrder", "completeWorkOrder", "Post"),
    ("registerSatisfactionSurvey", "registerSatisfactionSurvey", "Post"),
    ("addWorkerToWorkOrder", "addWorkerToWorkOrder", "Post"),
    ("addWorkersBatchToWorkOrder", "addWorkersBatchToWorkOrder", "Post"),
    ("removeWorkerFromWorkOrder", "removeWorkerFromWorkOrder", "Post"),
    ("advanceWorkOrderState", "advanceWorkOrderState", "Post"),
    ("getDetalleByNumeroOrden", "getDetalleByNumeroOrden", "Get"),
    ("getTrackingByNumeroOrden", "getTrackingByNumeroOrden", "Get"),
    ("getOrdenesBySolicitudId", "getOrdenesBySolicitudId", "Get")
]

remote_ds_path = "/home/mariosalazar/Desktop/Epaa/Git/frontend/work_orders_epaa/lib/features/work-orders/data/datasource/remote/work_orders_remote_datasource.dart"
repo_impl_path = "/home/mariosalazar/Desktop/Epaa/Git/frontend/work_orders_epaa/lib/features/work-orders/data/repositories/work_order_repository_impl.dart"

# 1. Update WorkOrdersRemoteDataSource
with open(remote_ds_path, 'r') as f:
    content = f.read()

interfaces = []
impls = []

for name, api_name, method in endpoints:
    if name == 'getDetalleByNumeroOrden':
        interfaces.append(f"  FutureData<WorkOrderModel> {name}(String numeroOrden);")
        impls.append(f"""
  @override
  FutureData<WorkOrderModel> {name}(String numeroOrden) {{
    return DataHandler.safeApiCall<WorkOrderModel, WorkOrderModel>(
      request: () => _apiService.get(ApiEndpoints.{api_name}, queryParameters: {{'numeroOrden': numeroOrden}}),
      fromJson: (json) => WorkOrderModel.fromJson(json),
      isStandardResponse: true,
      responseDataKey: 'data',
    );
  }}
""")
    elif name == 'getOrdenesBySolicitudId':
        interfaces.append(f"  FutureData<List<WorkOrderModel>> {name}(String solicitudId);")
        impls.append(f"""
  @override
  FutureData<List<WorkOrderModel>> {name}(String solicitudId) {{
    return DataHandler.safeApiCall<List<WorkOrderModel>, WorkOrderModel>(
      request: () => _apiService.get(ApiEndpoints.{api_name}, queryParameters: {{'solicitudId': solicitudId}}),
      fromJson: (json) => WorkOrderModel.fromJson(json),
      isStandardResponse: true,
      responseDataKey: 'data',
    );
  }}
""")
    elif method == 'Get':
        interfaces.append(f"  FutureData<dynamic> {name}(String id);")
        impls.append(f"""
  @override
  FutureData<dynamic> {name}(String id) {{
    return DataHandler.safeApiCall<dynamic, dynamic>(
      request: () => _apiService.get(ApiEndpoints.{api_name}, queryParameters: {{'numeroOrden': id}}),
      fromJson: (json) => json,
      isStandardResponse: true,
      responseDataKey: 'data',
    );
  }}
""")
    else:
        interfaces.append(f"  FutureData<void> {name}(dynamic request);")
        impls.append(f"""
  @override
  FutureData<void> {name}(dynamic request) {{
    return DataHandler.safeApiCall<void, void>(
      request: () => _apiService.post(ApiEndpoints.{api_name}, data: request.toJson()),
      fromJson: (_) {{}},
      isStandardResponse: true,
      responseDataKey: 'data',
    );
  }}
""")

# Special case for addWorkOrderAttachment which is multipart, but we'll leave it as a placeholder or implement it properly
interfaces.append(f"  FutureData<void> addWorkOrderAttachment(String workOrderId, List<String> filePaths);")
impls.append(f"""
  @override
  FutureData<void> addWorkOrderAttachment(String workOrderId, List<String> filePaths) {{
    // Should be implemented via multipart request if needed inside the remote data source
    throw UnimplementedError("Use the dedicated attachment data source if multipart is needed.");
  }}
""")

interface_str = "\n".join(interfaces)
impl_str = "".join(impls)

content = content.replace("  FutureData<WorkOrderModel> createWorkOrder(WorkOrderModel order);", f"  FutureData<WorkOrderModel> createWorkOrder(WorkOrderModel order);\n\n{interface_str}")

# Insert impl_str before the VERY LAST closing brace in the file
last_brace = content.rfind('}')
if last_brace != -1:
    content = content[:last_brace] + impl_str + "\n}\n"
else:
    content += impl_str

with open(remote_ds_path, 'w') as f:
    f.write(content)


# 2. Update WorkOrderRepositoryImpl
with open(repo_impl_path, 'r') as f:
    repo_content = f.read()

repo_impls = []
for name, api_name, method in endpoints:
    if name == 'getDetalleByNumeroOrden':
        repo_impls.append(f"""
  @override
  FutureData<WorkOrderEntity> {name}(String numeroOrden) async {{
    final result = await DataHandler.fetchWithFallback<WorkOrderModel>(
      _internet.isConnected,
      remoteCallback: () => _remoteDataSource.{name}(numeroOrden),
    );
    return result.when(
      success: (model) => SuccessState<WorkOrderEntity>(data: model.toEntity()),
      failure: (message, errorType) => FailureState<WorkOrderEntity>(message: message, errorType: errorType),
      loading: () => LoadingState<WorkOrderEntity>(),
    );
  }}
""")
    elif name == 'getOrdenesBySolicitudId':
        repo_impls.append(f"""
  @override
  FutureData<List<WorkOrderEntity>> {name}(String solicitudId) async {{
    final result = await DataHandler.fetchWithFallback<List<WorkOrderModel>>(
      _internet.isConnected,
      remoteCallback: () => _remoteDataSource.{name}(solicitudId),
    );
    return result.when(
      success: (models) => SuccessState<List<WorkOrderEntity>>(data: models.map((m) => m.toEntity()).toList()),
      failure: (message, errorType) => FailureState<List<WorkOrderEntity>>(message: message, errorType: errorType),
      loading: () => LoadingState<List<WorkOrderEntity>>(),
    );
  }}
""")
    elif method == 'Get':
        repo_impls.append(f"""
  @override
  FutureData<dynamic> {name}(String id) async {{
    final result = await DataHandler.fetchWithFallback<dynamic>(
      _internet.isConnected,
      remoteCallback: () => _remoteDataSource.{name}(id),
    );
    return result.when(
      success: (data) => SuccessState<dynamic>(data: data),
      failure: (message, errorType) => FailureState<dynamic>(message: message, errorType: errorType),
      loading: () => LoadingState<dynamic>(),
    );
  }}
""")
    else:
        repo_impls.append(f"""
  @override
  FutureData<void> {name}(dynamic request) async {{
    final result = await DataHandler.fetchWithFallback<void>(
      _internet.isConnected,
      remoteCallback: () => _remoteDataSource.{name}(request),
    );
    return result.when(
      success: (_) => SuccessState<void>(data: null),
      failure: (message, errorType) => FailureState<void>(message: message, errorType: errorType),
      loading: () => LoadingState<void>(),
    );
  }}
""")

repo_impls.append(f"""
  @override
  FutureData<void> addWorkOrderAttachment(String workOrderId, List<String> filePaths) async {{
    final result = await DataHandler.fetchWithFallback<void>(
      _internet.isConnected,
      remoteCallback: () => _remoteDataSource.addWorkOrderAttachment(workOrderId, filePaths),
    );
    return result.when(
      success: (_) => SuccessState<void>(data: null),
      failure: (message, errorType) => FailureState<void>(message: message, errorType: errorType),
      loading: () => LoadingState<void>(),
    );
  }}
""")

repo_impl_str = "".join(repo_impls)

# Insert before the last closing brace
last_brace = repo_content.rfind('}')
if last_brace != -1:
    repo_content = repo_content[:last_brace] + repo_impl_str + "\n}\n"
else:
    repo_content += repo_impl_str

with open(repo_impl_path, 'w') as f:
    f.write(repo_content)

print("Generation complete!")
