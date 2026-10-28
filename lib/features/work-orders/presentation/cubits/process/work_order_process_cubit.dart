import 'package:clean_architecture/features/work-orders/domain/entities/evidence_stage.dart';
import 'package:clean_architecture/core/data_states/data_state.dart';
import 'package:clean_architecture/core/services/session/session_service.dart';
import 'package:clean_architecture/features/work-orders/data/models/requests/process_work_order_requests.dart';
import 'package:clean_architecture/features/work-orders/domain/entities/work_order_detail_entity.dart';
import 'package:clean_architecture/features/work-orders/domain/entities/work_order_tracking_entity.dart';
import 'package:clean_architecture/features/work-orders/domain/usecases/process/get_work_order_detail_use_case.dart';
import 'package:clean_architecture/features/work-orders/domain/usecases/process/get_work_order_tracking_use_case.dart';
import 'package:clean_architecture/features/work-orders/domain/repositories/work_order_repository.dart';
import 'package:clean_architecture/features/work-orders/domain/usecases/process/process_work_order_use_cases.dart';
import 'dart:async';

import 'package:clean_architecture/features/work-orders/domain/automation/work_order_automation_policy.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

import 'work_order_process_state.dart';

@injectable
class WorkOrderProcessCubit extends Cubit<WorkOrderProcessState> {
  final GetWorkOrderDetailUseCase _getWorkOrderDetailUseCase;
  final GetWorkOrderTrackingUseCase _getWorkOrderTrackingUseCase;
  final ReceiveWorkOrderUseCase _receiveWorkOrderUseCase;
  final AssignWorkOrderToCrewUseCase? _assignWorkOrderToCrewUseCase;
  final AssignWorkOrderToWorkerUseCase _assignWorkOrderToWorkerUseCase;
  final StartPreparationUseCase _startPreparationUseCase;
  final CreatePreparationInspectionUseCase _createPreparationInspectionUseCase;
  final ResolvePreparationInspectionUseCase
  _resolvePreparationInspectionUseCase;
  final FinishExecutionUseCase _finishExecutionUseCase;
  final AddWorkersBatchToWorkOrderUseCase _addWorkersBatchToWorkOrderUseCase;
  final RemoveWorkerFromWorkOrderUseCase _removeWorkerFromWorkOrderUseCase;
  final AddWorkOrderMaterialsBatchUseCase _addWorkOrderMaterialsBatchUseCase;
  final AddAdditionalCostsBatchUseCase _addAdditionalCostsBatchUseCase;
  final UploadWorkOrderAttachmentsUseCase _uploadWorkOrderAttachmentsUseCase;
  final CreateQualityControlUseCase _createQualityControlUseCase;
  final CompleteWorkOrderUseCase _completeWorkOrderUseCase;
  final RegisterSatisfactionSurveyUseCase _registerSatisfactionSurveyUseCase;

  WorkOrderProcessCubit({
    required GetWorkOrderDetailUseCase getWorkOrderDetailUseCase,
    required GetWorkOrderTrackingUseCase getWorkOrderTrackingUseCase,
    required ReceiveWorkOrderUseCase receiveWorkOrderUseCase,
    AssignWorkOrderToCrewUseCase? assignWorkOrderToCrewUseCase,
    required AssignWorkOrderToWorkerUseCase assignWorkOrderToWorkerUseCase,
    required StartPreparationUseCase startPreparationUseCase,
    required CreatePreparationInspectionUseCase
    createPreparationInspectionUseCase,
    required ResolvePreparationInspectionUseCase
    resolvePreparationInspectionUseCase,
    required StartExecutionUseCase startExecutionUseCase,
    required FinishExecutionUseCase finishExecutionUseCase,
    required AddWorkersBatchToWorkOrderUseCase
    addWorkersBatchToWorkOrderUseCase,
    required RemoveWorkerFromWorkOrderUseCase removeWorkerFromWorkOrderUseCase,
    required AddWorkOrderMaterialsBatchUseCase
    addWorkOrderMaterialsBatchUseCase,
    required AddAdditionalCostsBatchUseCase addAdditionalCostsBatchUseCase,
    required UploadWorkOrderAttachmentsUseCase
    uploadWorkOrderAttachmentsUseCase,
    required CreateQualityControlUseCase createQualityControlUseCase,
    required CompleteWorkOrderUseCase completeWorkOrderUseCase,
    required RegisterSatisfactionSurveyUseCase
    registerSatisfactionSurveyUseCase,
  }) : _getWorkOrderDetailUseCase = getWorkOrderDetailUseCase,
       _getWorkOrderTrackingUseCase = getWorkOrderTrackingUseCase,
       _receiveWorkOrderUseCase = receiveWorkOrderUseCase,
       _assignWorkOrderToCrewUseCase =
           assignWorkOrderToCrewUseCase ??
           (GetIt.I.isRegistered<AssignWorkOrderToCrewUseCase>()
               ? GetIt.I<AssignWorkOrderToCrewUseCase>()
               : (GetIt.I.isRegistered<WorkOrderRepository>()
                     ? AssignWorkOrderToCrewUseCase(
                         GetIt.I<WorkOrderRepository>(),
                       )
                     : null)),
       _assignWorkOrderToWorkerUseCase = assignWorkOrderToWorkerUseCase,
       _startPreparationUseCase = startPreparationUseCase,
       _createPreparationInspectionUseCase = createPreparationInspectionUseCase,
       _resolvePreparationInspectionUseCase =
           resolvePreparationInspectionUseCase,
       _finishExecutionUseCase = finishExecutionUseCase,
       _addWorkersBatchToWorkOrderUseCase = addWorkersBatchToWorkOrderUseCase,
       _removeWorkerFromWorkOrderUseCase = removeWorkerFromWorkOrderUseCase,
       _addWorkOrderMaterialsBatchUseCase = addWorkOrderMaterialsBatchUseCase,
       _addAdditionalCostsBatchUseCase = addAdditionalCostsBatchUseCase,
       _uploadWorkOrderAttachmentsUseCase = uploadWorkOrderAttachmentsUseCase,
       _createQualityControlUseCase = createQualityControlUseCase,
       _completeWorkOrderUseCase = completeWorkOrderUseCase,
       _registerSatisfactionSurveyUseCase = registerSatisfactionSurveyUseCase,
       super(const WorkOrderProcessState());

  String get _currentUserId {
    return SessionUtil.I.isLoggedIn ? SessionUtil.I.userData.user.userId : '';
  }

  // ─── Automatización de pasos (reducción de clics) ─────────────────────
  final WorkOrderAutomationPolicy automationPolicy =
      GetIt.I.isRegistered<WorkOrderAutomationPolicy>()
      ? GetIt.I<WorkOrderAutomationPolicy>()
      : const WorkOrderAutomationPolicy.defaults();

  static const _maxAutoSteps = 8;
  bool _autoRunning = false;
  bool _completionRunning = false;

  /// Mientras es `true`, los pasos automáticos no muestran mensajes
  /// intermedios (recepción, checklist…): sólo un loading.
  bool _silent = false;

  @override
  void emit(WorkOrderProcessState state) {
    super.emit(
      _silent
          ? state.copyWith(clearSuccessMessage: true, isAutoProcessing: true)
          : state,
    );
  }

  void _beginSilent() {
    _silent = true;
    emit(state.copyWith(isAutoProcessing: true));
  }

  void _endSilent() {
    _silent = false;
    emit(
      state.copyWith(
        isAutoProcessing: false,
        isActionLoading: false,
        clearActionLoadingMessage: true,
      ),
    );
  }

  bool _hasPendingAutoStep(WorkOrderDetailEntity order) =>
      WorkOrderAutoStepResolver.nextBackgroundStep(order, automationPolicy) !=
      null;

  /// Ejecuta un paso reutilizando los métodos existentes (no duplica lógica).
  Future<void> _executeAutoStep(AutoStep step) => switch (step) {
    AutoStep.receive => receiveWorkOrder(),
    AutoStep.startPreparation => startPreparation(),
    AutoStep.createChecklist => createChecklist(
      passed: true,
      observations: AutoStepDefaults.checklistObservations,
    ),
    AutoStep.approveChecklist => resolveChecklist(
      approved: true,
      comment: AutoStepDefaults.checklistApproval,
    ),
    AutoStep.restartPreparation => restartPreparation(),
    AutoStep.finishExecution => finishExecution(),
    AutoStep.qualityControl => createQualityControl(
      approved: true,
      comments: AutoStepDefaults.qualityControlComments,
    ),
  };

  /// Ejecuta un paso y recarga la OT. Devuelve `false` si falló.
  Future<bool> _runStepAndReload(AutoStep step) async {
    await _executeAutoStep(step);
    if (state.errorMessage != null) return false;
    final code = state.order?.codigoOrden ?? state.orderCode;
    await loadWorkOrder(code, isSilentReload: true);
    return state.order != null;
  }

  /// Encadena los pasos de fondo hasta llegar a uno que requiera al usuario.
  Future<void> _runAutoSteps() async {
    if (_autoRunning) return;
    final current = state.order;
    if (current == null || !_hasPendingAutoStep(current)) {
      if (state.isAutoProcessing) emit(state.copyWith(isAutoProcessing: false));
      return;
    }
    _autoRunning = true;
    _beginSilent();
    try {
      for (var i = 0; i < _maxAutoSteps; i++) {
        final order = state.order;
        if (order == null) break;
        final step = WorkOrderAutoStepResolver.nextBackgroundStep(
          order,
          automationPolicy,
        );
        if (step == null) break;
        final before = '${order.estado}|${order.idInspeccion}';
        if (!await _runStepAndReload(step)) break;
        final after = '${state.order?.estado}|${state.order?.idInspeccion}';
        if (before == after) break; // sin progreso ⇒ evitar bucles
      }
    } finally {
      _autoRunning = false;
      _endSilent();
    }
  }

  /// "Completar Orden": ejecuta los pasos automáticos previos al cierre
  /// (finalizar ejecución, control de calidad) y luego completa la OT.
  Future<void> completeWorkOrderFlow(String finalizationDescription) async {
    if (_completionRunning) return;
    final order = state.order;
    if (order == null) return;

    _completionRunning = true;
    try {
      final steps = WorkOrderAutoStepResolver.completionSteps(
        order,
        automationPolicy,
      );
      if (steps.isNotEmpty) {
        _autoRunning = true;
        _beginSilent();
        try {
          for (final step in steps) {
            if (!await _runStepAndReload(step)) {
              throw StateError(
                state.errorMessage ??
                    'No se pudo completar un paso previo al cierre.',
              );
            }
          }
        } finally {
          _autoRunning = false;
          _endSilent();
        }
      }
      await completeWorkOrder(finalizationDescription);
    } finally {
      _completionRunning = false;
    }
  }

  void setExecutionSubStep(int step) {
    emit(state.copyWith(executionSubStep: step));
  }

  void clearMessages() {
    emit(state.copyWith(clearErrorMessage: true, clearSuccessMessage: true));
  }

  Future<void> loadWorkOrder(
    String orderCode, {
    bool isSilentReload = false,
  }) async {
    final code = orderCode.trim().toUpperCase();
    if (code.isEmpty) return;

    if (!isSilentReload) {
      emit(
        state.copyWith(
          orderCode: code,
          isLoading: true,
          clearErrorMessage: true,
          clearSuccessMessage: true,
        ),
      );
    } else {
      emit(state.copyWith(clearErrorMessage: true, clearSuccessMessage: true));
    }

    try {
      final detailFuture = _getWorkOrderDetailUseCase(code);
      final trackingFuture = _getWorkOrderTrackingUseCase(code);

      final results = await Future.wait([detailFuture, trackingFuture]);
      final detailResult = results[0] as DataState<WorkOrderDetailEntity>;
      final trackingResult = results[1] as DataState<WorkOrderTrackingEntity>;

      WorkOrderDetailEntity? detail;
      WorkOrderTrackingEntity? tracking;
      String? errorMessage;

      detailResult.when(
        success: (data) => detail = data,
        failure: (message, _) => errorMessage = message,
        loading: () {},
      );

      trackingResult.when(
        success: (data) => tracking = data,
        failure: (message, _) => errorMessage ??= message,
        loading: () {},
      );

      if (detail != null) {
        emit(
          state.copyWith(
            orderCode: code,
            isLoading: false,
            order: detail,
            tracking: tracking,
            successMessage: isSilentReload
                ? null
                : 'Orden de trabajo encontrada.',
            isAutoProcessing: _autoRunning || _hasPendingAutoStep(detail!),
          ),
        );
        // Avanza automáticamente los pasos que siempre se aprueban.
        if (!_autoRunning) unawaited(_runAutoSteps());
      } else {
        emit(
          state.copyWith(
            isLoading: false,
            errorMessage:
                errorMessage ?? 'No se pudo cargar la orden de trabajo.',
          ),
        );
      }
    } catch (e) {
      emit(state.copyWith(isLoading: false, errorMessage: e.toString()));
    }
  }

  Future<void> reloadCurrentOrder() async {
    final code = state.order?.codigoOrden ?? state.orderCode;
    if (code.isNotEmpty) {
      await loadWorkOrder(code, isSilentReload: true);
    }
  }

  Future<void> receiveWorkOrder() async {
    final order = state.order;
    if (order == null) return;

    emit(
      state.copyWith(
        isActionLoading: true,
        actionLoadingMessage: 'Recepcionando orden de trabajo...',
        clearErrorMessage: true,
        clearSuccessMessage: true,
      ),
    );

    final request = ProcessWorkOrderTransitionRequest(
      workOrderId: order.idOrdenTrabajo,
      newStatus: 'PENDIENTE',
      userId: _currentUserId,
      comment: 'OT recepcionada desde la aplicación',
    );

    final result = await _receiveWorkOrderUseCase(request);
    result.when(
      success: (_) async {
        emit(
          state.copyWith(
            isActionLoading: false,
            clearActionLoadingMessage: true,
            successMessage:
                'OT Recepcionada. La orden pasó a estado PENDIENTE.',
          ),
        );
        await reloadCurrentOrder();
      },
      failure: (message, _) {
        emit(
          state.copyWith(
            isActionLoading: false,
            clearActionLoadingMessage: true,
            errorMessage: message,
          ),
        );
      },
      loading: () {},
    );
  }

  Future<void> assignWorker({required String workerId, String? comment}) async {
    final order = state.order;
    if (order == null) return;

    emit(
      state.copyWith(
        isActionLoading: true,
        actionLoadingMessage: 'Asignando técnico responsable...',
        clearErrorMessage: true,
        clearSuccessMessage: true,
      ),
    );

    final userId = _currentUserId.isNotEmpty ? _currentUserId : 'USER-ADMIN';
    String? crewError;

    // 1. Usar el endpoint de epaa-web para asignar técnico responsable:
    // POST /process-work-orders/assign-work-order-to-crew
    if (_assignWorkOrderToCrewUseCase != null) {
      final crewRequest = AssignWorkOrderToCrewRequest(
        workOrderId: order.idOrdenTrabajo,
        crewId: workerId,
        assignedByUserId: userId,
        comment: comment ?? 'Asignación de técnico responsable',
      );

      final crewResult = await _assignWorkOrderToCrewUseCase(crewRequest);
      var succeeded = false;

      crewResult.when(
        success: (_) => succeeded = true,
        failure: (msg, _) => crewError = msg,
        loading: () {},
      );

      if (succeeded) {
        emit(
          state.copyWith(
            isActionLoading: false,
            clearActionLoadingMessage: true,
            successMessage: 'Técnico responsable asignado exitosamente.',
          ),
        );
        await reloadCurrentOrder();
        return;
      }
    }

    // 2. Si assign-work-order-to-crew no pasa, fallback a assign-work-order-to-worker
    final workerRequest = AssignWorkOrderToWorkerRequest(
      workOrderId: order.idOrdenTrabajo,
      workerId: workerId,
      assignedByUserId: userId,
      comment: comment ?? 'Asignación operativa a técnico',
    );

    final result = await _assignWorkOrderToWorkerUseCase(workerRequest);
    result.when(
      success: (_) async {
        emit(
          state.copyWith(
            isActionLoading: false,
            clearActionLoadingMessage: true,
            successMessage: 'Técnico asignado exitosamente.',
          ),
        );
        await reloadCurrentOrder();
      },
      failure: (message, _) {
        emit(
          state.copyWith(
            isActionLoading: false,
            clearActionLoadingMessage: true,
            errorMessage: crewError ?? message,
          ),
        );
      },
      loading: () {},
    );
  }

  Future<void> startPreparation() async {
    final order = state.order;
    if (order == null) return;

    emit(
      state.copyWith(
        isActionLoading: true,
        actionLoadingMessage: 'Iniciando preparación...',
        clearErrorMessage: true,
        clearSuccessMessage: true,
      ),
    );

    final request = ProcessWorkOrderTransitionRequest(
      workOrderId: order.idOrdenTrabajo,
      newStatus: 'PREPARACION',
      userId: _currentUserId,
      comment: 'Inicio de preparación de campo',
    );

    final result = await _startPreparationUseCase(request);
    result.when(
      success: (_) async {
        emit(
          state.copyWith(
            isActionLoading: false,
            clearActionLoadingMessage: true,
            successMessage: 'Preparación iniciada. Estado: PREPARACION.',
          ),
        );
        await reloadCurrentOrder();
      },
      failure: (message, _) {
        emit(
          state.copyWith(
            isActionLoading: false,
            clearActionLoadingMessage: true,
            errorMessage: message,
          ),
        );
      },
      loading: () {},
    );
  }

  Future<void> restartPreparation() async {
    final order = state.order;
    if (order == null) return;

    emit(
      state.copyWith(
        isActionLoading: true,
        actionLoadingMessage: 'Reiniciando preparación...',
        clearErrorMessage: true,
        clearSuccessMessage: true,
      ),
    );

    final request = ProcessWorkOrderTransitionRequest(
      workOrderId: order.idOrdenTrabajo,
      newStatus: 'PREPARACION',
      userId: _currentUserId,
      comment: 'Reinicio de preparación tras revisión rechazada',
    );

    final result = await _startPreparationUseCase(request);
    result.when(
      success: (_) async {
        emit(
          state.copyWith(
            isActionLoading: false,
            clearActionLoadingMessage: true,
            successMessage: 'Preparación reiniciada. Estado: PREPARACION.',
          ),
        );
        await reloadCurrentOrder();
      },
      failure: (message, _) {
        emit(
          state.copyWith(
            isActionLoading: false,
            clearActionLoadingMessage: true,
            errorMessage: message,
          ),
        );
      },
      loading: () {},
    );
  }

  Future<void> createChecklist({
    required bool passed,
    String? observations,
  }) async {
    final order = state.order;
    if (order == null) return;

    emit(
      state.copyWith(
        isActionLoading: true,
        actionLoadingMessage: 'Registrando checklist de preparación...',
        clearErrorMessage: true,
        clearSuccessMessage: true,
      ),
    );

    final request = CreatePreparationInspectionRequest(
      workOrderId: order.idOrdenTrabajo,
      passed: passed,
      observations: observations,
      createdByUserId: _currentUserId,
    );

    final result = await _createPreparationInspectionUseCase(request);
    result.when(
      success: (_) async {
        emit(
          state.copyWith(
            isActionLoading: false,
            clearActionLoadingMessage: true,
            successMessage: passed
                ? 'Checklist registrado (Preparación Aprobada).'
                : 'Checklist registrado (Preparación Rechazada).',
          ),
        );
        await reloadCurrentOrder();
      },
      failure: (message, _) {
        emit(
          state.copyWith(
            isActionLoading: false,
            clearActionLoadingMessage: true,
            errorMessage: message,
          ),
        );
      },
      loading: () {},
    );
  }

  Future<void> resolveChecklist({
    required bool approved,
    String? comment,
  }) async {
    final order = state.order;
    if (order == null) return;

    emit(
      state.copyWith(
        isActionLoading: true,
        actionLoadingMessage: 'Resolviendo checklist...',
        clearErrorMessage: true,
        clearSuccessMessage: true,
      ),
    );

    final request = ResolvePreparationInspectionRequest(
      workOrderId: order.idOrdenTrabajo,
      passed: approved,
      comment:
          comment ??
          (approved
              ? 'Inspección de preparación aprobada — iniciando ejecución'
              : 'Inspección de preparación rechazada'),
      userId: _currentUserId,
    );

    final result = await _resolvePreparationInspectionUseCase(request);
    result.when(
      success: (_) async {
        emit(
          state.copyWith(
            isActionLoading: false,
            clearActionLoadingMessage: true,
            successMessage: approved
                ? 'Checklist aprobado. La OT pasó a EN PROCESO.'
                : 'Checklist rechazado. En revisión.',
          ),
        );
        await reloadCurrentOrder();
      },
      failure: (message, _) {
        emit(
          state.copyWith(
            isActionLoading: false,
            clearActionLoadingMessage: true,
            errorMessage: message,
          ),
        );
      },
      loading: () {},
    );
  }

  Future<void> finishExecution() async {
    final order = state.order;
    if (order == null) return;

    emit(
      state.copyWith(
        isActionLoading: true,
        actionLoadingMessage: 'Finalizando ejecución técnica...',
        clearErrorMessage: true,
        clearSuccessMessage: true,
      ),
    );

    final nextStatus = order.estado == 'EN_PROCESO_INSPECCION'
        ? 'INSPECCION_EJECUTADA'
        : order.estado == 'EN_PROCESO_INSTALACION'
        ? 'INSTALACION_EJECUTADA'
        : 'EJECUTADA';

    final request = ProcessWorkOrderTransitionRequest(
      workOrderId: order.idOrdenTrabajo,
      newStatus: nextStatus,
      userId: _currentUserId,
      comment: 'Trabajo técnico finalizado en campo',
    );

    final result = await _finishExecutionUseCase(request);
    result.when(
      success: (_) async {
        emit(
          state.copyWith(
            isActionLoading: false,
            clearActionLoadingMessage: true,
            successMessage:
                'Ejecución finalizada. Procede al control de calidad.',
          ),
        );
        if (!_autoRunning) await reloadCurrentOrder();
      },
      failure: (message, _) {
        emit(
          state.copyWith(
            isActionLoading: false,
            clearActionLoadingMessage: true,
            errorMessage: message,
          ),
        );
        if (_autoRunning) {
          throw StateError(message ?? 'No se pudo finalizar la ejecución.');
        }
      },
      loading: () {},
    );
  }

  Future<void> addWorkersBatch(
    List<AddWorkerToWorkOrderRequest> workers,
  ) async {
    final order = state.order;
    if (order == null) return;

    emit(
      state.copyWith(
        isActionLoading: true,
        actionLoadingMessage: 'Guardando trabajadores...',
        clearErrorMessage: true,
        clearSuccessMessage: true,
      ),
    );

    final request = AddWorkersBatchToWorkOrderRequest(
      workOrderId: order.idOrdenTrabajo,
      assignedByUserId: _currentUserId,
      workers: workers,
    );

    final result = await _addWorkersBatchToWorkOrderUseCase(request);
    result.when(
      success: (_) async {
        emit(
          state.copyWith(
            isActionLoading: false,
            clearActionLoadingMessage: true,
            successMessage: 'Personal agregado a la orden de trabajo.',
          ),
        );
        await reloadCurrentOrder();
      },
      failure: (message, _) {
        emit(
          state.copyWith(
            isActionLoading: false,
            clearActionLoadingMessage: true,
            errorMessage: message,
          ),
        );
      },
      loading: () {},
    );
  }

  Future<void> removeWorker(String workerId) async {
    final order = state.order;
    if (order == null) return;

    emit(
      state.copyWith(
        isActionLoading: true,
        actionLoadingMessage: 'Removiendo trabajador...',
        clearErrorMessage: true,
        clearSuccessMessage: true,
      ),
    );

    final request = RemoveWorkerFromWorkOrderRequest(
      workOrderId: order.idOrdenTrabajo,
      workerId: workerId,
      removedByUserId: _currentUserId,
    );

    final result = await _removeWorkerFromWorkOrderUseCase(request);
    result.when(
      success: (_) async {
        emit(
          state.copyWith(
            isActionLoading: false,
            clearActionLoadingMessage: true,
            successMessage: 'Trabajador removido de la orden.',
          ),
        );
        await reloadCurrentOrder();
      },
      failure: (message, _) {
        emit(
          state.copyWith(
            isActionLoading: false,
            clearActionLoadingMessage: true,
            errorMessage: message,
          ),
        );
      },
      loading: () {},
    );
  }

  Future<void> addMaterialsBatch(
    List<AddWorkOrderMaterialRequest> materials,
  ) async {
    final order = state.order;
    if (order == null) return;

    emit(
      state.copyWith(
        isActionLoading: true,
        actionLoadingMessage: 'Registrando materiales...',
        clearErrorMessage: true,
        clearSuccessMessage: true,
      ),
    );

    final request = AddWorkOrderMaterialsBatchRequest(
      workOrderId: order.idOrdenTrabajo,
      createdByUserId: _currentUserId,
      materials: materials,
    );

    final result = await _addWorkOrderMaterialsBatchUseCase(request);
    result.when(
      success: (_) async {
        emit(
          state.copyWith(
            isActionLoading: false,
            clearActionLoadingMessage: true,
            successMessage: 'Materiales registrados correctamente.',
          ),
        );
        await reloadCurrentOrder();
      },
      failure: (message, _) {
        emit(
          state.copyWith(
            isActionLoading: false,
            clearActionLoadingMessage: true,
            errorMessage: message,
          ),
        );
      },
      loading: () {},
    );
  }

  Future<void> addCostsBatch(List<AddAdditionalCostRequest> costs) async {
    final order = state.order;
    if (order == null) return;

    emit(
      state.copyWith(
        isActionLoading: true,
        actionLoadingMessage: 'Registrando costos adicionales...',
        clearErrorMessage: true,
        clearSuccessMessage: true,
      ),
    );

    final request = AddAdditionalCostsBatchRequest(
      workOrderId: order.idOrdenTrabajo,
      createdByUserId: _currentUserId,
      costs: costs,
    );

    final result = await _addAdditionalCostsBatchUseCase(request);
    result.when(
      success: (_) async {
        emit(
          state.copyWith(
            isActionLoading: false,
            clearActionLoadingMessage: true,
            successMessage: 'Costos adicionales registrados correctamente.',
          ),
        );
        await reloadCurrentOrder();
      },
      failure: (message, _) {
        emit(
          state.copyWith(
            isActionLoading: false,
            clearActionLoadingMessage: true,
            errorMessage: message,
          ),
        );
      },
      loading: () {},
    );
  }

  Future<void> uploadAttachments(
    List<String> filePaths, [
    EvidenceStage stage = EvidenceStage.inProgress,
  ]) async {
    await _uploadAttachments(filePaths, stage);
  }

  Future<void> uploadCompletionEvidence(
    List<String> filePaths,
    EvidenceStage stage,
  ) async {
    final uploaded = await _uploadAttachments(filePaths, stage);
    if (!uploaded) {
      throw StateError('No se pudieron subir las evidencias de finalización.');
    }
  }

  Future<bool> _uploadAttachments(
    List<String> filePaths,
    EvidenceStage stage,
  ) async {
    final order = state.order;
    if (order == null || filePaths.isEmpty) return false;

    emit(
      state.copyWith(
        isActionLoading: true,
        actionLoadingMessage: 'Subiendo evidencias...',
        clearErrorMessage: true,
        clearSuccessMessage: true,
      ),
    );

    final params = UploadWorkOrderAttachmentsParams(
      workOrderId: order.idOrdenTrabajo,
      filePaths: filePaths,
      createdByUserId: _currentUserId,
      evidenceStage: stage,
    );

    final result = await _uploadWorkOrderAttachmentsUseCase(params);
    var uploaded = false;
    result.when(
      success: (_) async {
        uploaded = true;
        emit(
          state.copyWith(
            isActionLoading: false,
            clearActionLoadingMessage: true,
            successMessage: 'Evidencias subidas exitosamente.',
          ),
        );
        await reloadCurrentOrder();
      },
      failure: (message, _) {
        emit(
          state.copyWith(
            isActionLoading: false,
            clearActionLoadingMessage: true,
            errorMessage: message,
          ),
        );
      },
      loading: () {},
    );
    return uploaded;
  }

  Future<void> createQualityControl({
    required bool approved,
    String? comments,
  }) async {
    final order = state.order;
    if (order == null) return;

    emit(
      state.copyWith(
        isActionLoading: true,
        actionLoadingMessage: 'Registrando control de calidad...',
        clearErrorMessage: true,
        clearSuccessMessage: true,
      ),
    );

    final request = CreateQualityControlRequest(
      workOrderId: order.idOrdenTrabajo,
      approved: approved,
      comments: comments,
      createdByUserId: _currentUserId,
    );

    final result = await _createQualityControlUseCase(request);
    result.when(
      success: (_) async {
        emit(
          state.copyWith(
            isActionLoading: false,
            clearActionLoadingMessage: true,
            successMessage: approved
                ? 'Control de calidad aprobado.'
                : 'Control de calidad rechazado — orden devuelta a revisión.',
          ),
        );
        if (!_autoRunning) await reloadCurrentOrder();
      },
      failure: (message, _) {
        emit(
          state.copyWith(
            isActionLoading: false,
            clearActionLoadingMessage: true,
            errorMessage: message,
          ),
        );
        if (_autoRunning) {
          throw StateError(
            message ?? 'No se pudo registrar el control de calidad.',
          );
        }
      },
      loading: () {},
    );
  }

  Future<void> completeWorkOrder(String finalizationDescription) async {
    final order = state.order;
    if (order == null) return;

    emit(
      state.copyWith(
        isActionLoading: true,
        actionLoadingMessage: 'Completando y cerrando orden...',
        clearErrorMessage: true,
        clearSuccessMessage: true,
      ),
    );

    final nextStatus = order.estado == 'INSPECCION_EJECUTADA'
        ? 'INSPECCION_COMPLETADA'
        : order.estado == 'INSTALACION_EJECUTADA'
        ? 'INSTALACION_COMPLETADA'
        : 'COMPLETADA';

    final request = ProcessWorkOrderTransitionRequest(
      workOrderId: order.idOrdenTrabajo,
      newStatus: nextStatus,
      userId: _currentUserId,
      comment: 'Cierre administrativo desde la app móvil',
      finalizationDescription: finalizationDescription.trim(),
    );

    final result = await _completeWorkOrderUseCase(request);
    result.when(
      success: (_) async {
        emit(
          state.copyWith(
            isActionLoading: false,
            clearActionLoadingMessage: true,
            successMessage: 'Orden de trabajo completada y cerrada.',
          ),
        );
        await reloadCurrentOrder();
      },
      failure: (message, _) {
        emit(
          state.copyWith(
            isActionLoading: false,
            clearActionLoadingMessage: true,
            errorMessage: message,
          ),
        );
        throw StateError(message ?? 'No se pudo completar la orden.');
      },
      loading: () {},
    );
  }

  Future<void> registerSatisfactionSurvey({
    required int rating,
    String? comments,
  }) async {
    final order = state.order;
    if (order == null) return;

    emit(
      state.copyWith(
        isActionLoading: true,
        actionLoadingMessage: 'Registrando encuesta de satisfacción...',
        clearErrorMessage: true,
        clearSuccessMessage: true,
      ),
    );

    final request = RegisterSatisfactionSurveyRequest(
      workOrderId: order.idOrdenTrabajo,
      rating: rating,
      comments: comments,
      createdByUserId: _currentUserId,
    );

    final result = await _registerSatisfactionSurveyUseCase(request);
    result.when(
      success: (_) async {
        emit(
          state.copyWith(
            isActionLoading: false,
            clearActionLoadingMessage: true,
            successMessage:
                'Encuesta registrada con éxito ($rating/5 estrellas).',
          ),
        );
        await reloadCurrentOrder();
      },
      failure: (message, _) {
        emit(
          state.copyWith(
            isActionLoading: false,
            clearActionLoadingMessage: true,
            errorMessage: message,
          ),
        );
      },
      loading: () {},
    );
  }

  Future<void> registerSurvey({required int rating, String? comments}) =>
      registerSatisfactionSurvey(rating: rating, comments: comments);
}
