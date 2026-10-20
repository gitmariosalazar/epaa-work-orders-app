import 'package:clean_architecture/features/work-orders/presentation/completion/order_completion_handlers.dart';
import 'package:auto_route/auto_route.dart';
import 'package:clean_architecture/core/constants/app_colors.dart';
import 'package:clean_architecture/features/work-orders/presentation/cubits/process/work_order_process_cubit.dart';
import 'package:clean_architecture/features/work-orders/presentation/cubits/process/work_order_process_state.dart';
import 'package:clean_architecture/features/work-orders/presentation/pages/process/dialogs/assign_worker_dialog.dart';
import 'package:clean_architecture/features/work-orders/presentation/pages/process/dialogs/checklist_dialog.dart';
import 'package:clean_architecture/features/work-orders/presentation/pages/process/dialogs/quality_control_dialog.dart';
import 'package:clean_architecture/features/work-orders/presentation/pages/process/dialogs/satisfaction_survey_dialog.dart';
import 'package:clean_architecture/features/work-orders/presentation/pages/process/widgets/work_order_attachments_card.dart';
import 'package:clean_architecture/features/work-orders/presentation/pages/process/widgets/work_order_hero_card.dart';
import 'package:clean_architecture/features/work-orders/presentation/pages/process/widgets/work_order_info_card.dart';
import 'package:clean_architecture/features/work-orders/presentation/pages/process/widgets/work_order_materials_card.dart';
import 'package:clean_architecture/features/work-orders/presentation/pages/process/widgets/work_order_phase_action_card.dart';
import 'package:clean_architecture/features/work-orders/presentation/pages/process/widgets/work_order_process_stepper.dart';
import 'package:clean_architecture/features/work-orders/presentation/pages/process/widgets/work_order_quality_card.dart';
import 'package:clean_architecture/features/work-orders/presentation/pages/process/widgets/work_order_survey_card.dart';
import 'package:clean_architecture/features/work-orders/presentation/pages/process/widgets/work_order_timeline_card.dart';
import 'package:clean_architecture/features/work-orders/presentation/pages/process/widgets/work_order_workers_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

@RoutePage()
class WorkOrderProcessPage extends StatefulWidget {
  final String? initialOrderCode;

  const WorkOrderProcessPage({super.key, this.initialOrderCode});

  @override
  State<WorkOrderProcessPage> createState() => _WorkOrderProcessPageState();
}

class _WorkOrderProcessPageState extends State<WorkOrderProcessPage> {
  static const double _searchBarHeight = 44;
  late final WorkOrderProcessCubit _cubit;
  final TextEditingController _searchController = TextEditingController();
  bool _completionFlowRunning = false;

  @override
  void initState() {
    super.initState();
    _cubit = GetIt.I<WorkOrderProcessCubit>();

    if (widget.initialOrderCode != null &&
        widget.initialOrderCode!.isNotEmpty) {
      _searchController.text = widget.initialOrderCode!;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _cubit.loadWorkOrder(widget.initialOrderCode!);
      });
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    _cubit.close();
    super.dispose();
  }

  void _onSearch() {
    final query = _searchController.text.trim();
    if (query.isNotEmpty) {
      FocusScope.of(context).unfocus();
      _cubit.loadWorkOrder(query);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _cubit,
      child: BlocConsumer<WorkOrderProcessCubit, WorkOrderProcessState>(
        listener: (context, state) {
          if (state.successMessage != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.successMessage!),
                backgroundColor: const Color(0xFF059669),
                behavior: SnackBarBehavior.floating,
              ),
            );
            _cubit.clearMessages();
          }

          if (state.errorMessage != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.errorMessage!),
                backgroundColor: const Color(0xFFDC2626),
                behavior: SnackBarBehavior.floating,
              ),
            );
            _cubit.clearMessages();
          }
        },
        builder: (context, state) {
          final order = state.order;
          final theme = Theme.of(context);
          final isDark = theme.brightness == Brightness.dark;

          return Scaffold(
            backgroundColor: isDark
                ? theme.scaffoldBackgroundColor
                : const Color(0xFFF8FAFC),
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              foregroundColor: Colors.white,
              elevation: 0,
              centerTitle: true,
              leading: Padding(
                padding: const EdgeInsets.only(left: 12.0),
                child: Center(
                  child: Material(
                    color: Colors.white.withValues(alpha: 0.15),
                    shape: const CircleBorder(),
                    clipBehavior: Clip.antiAlias,
                    child: IconButton(
                      iconSize: 20,
                      splashRadius: 22,
                      constraints: const BoxConstraints(
                        minWidth: 38,
                        minHeight: 38,
                      ),
                      icon: const Icon(
                        Icons.arrow_back_rounded,
                        color: Colors.white, // Color blanco garantizado
                      ),
                      tooltip: 'Atrás',
                      onPressed: () => Navigator.of(context).maybePop(),
                    ),
                  ),
                ),
              ),

              // Borde inferior sutilmente redondeado
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(15),
                ),
              ),
              // Fondo con degradado moderno
              flexibleSpace: Container(
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      AppColors.primary,
                      Color(0xFF0033BC), // Un tono ligeramente más vibrante
                    ],
                  ),
                  borderRadius: const BorderRadius.vertical(
                    bottom: Radius.circular(8),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.25),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
              ),
              title: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    order != null ? 'PROCESO OT' : 'GESTIÓN DE ORDEN',
                    style: TextStyle(
                      fontSize: 11,
                      letterSpacing: 1.2,
                      fontWeight: FontWeight.w600,
                      color: Colors.white.withValues(alpha: 0.85),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    order != null ? order.codigoOrden : 'Proceso OT',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 17,
                      letterSpacing: 0.5,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              actions: [
                if (order != null)
                  Padding(
                    padding: const EdgeInsets.only(right: 12.0),
                    child: Center(
                      child: Material(
                        color: Colors.white.withValues(alpha: 0.15),
                        shape: const CircleBorder(),
                        clipBehavior: Clip.antiAlias,
                        child: IconButton(
                          iconSize: 20,
                          splashRadius: 22,
                          constraints: const BoxConstraints(
                            minWidth: 38,
                            minHeight: 38,
                          ),
                          icon: state.isLoading || state.isActionLoading
                              ? const SizedBox(
                                  width: 18,
                                  height: 18,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white,
                                    ),
                                  ),
                                )
                              : const Icon(
                                  Icons.refresh_rounded,
                                  color: Colors.white,
                                ),
                          tooltip: 'Recargar orden',
                          onPressed: state.isLoading || state.isActionLoading
                              ? null
                              : () => _cubit.reloadCurrentOrder(),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            body: RefreshIndicator(
              onRefresh: () async {
                if (order != null) {
                  await _cubit.reloadCurrentOrder();
                }
              },
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 10,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Buscador
                    Card(
                      elevation: 1,
                      margin: EdgeInsets.zero,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 4,
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.search, color: Colors.grey),
                            const SizedBox(width: 8),
                            Expanded(
                              child: SizedBox(
                                height: _searchBarHeight,
                                child: TextField(
                                  controller: _searchController,
                                  textCapitalization:
                                      TextCapitalization.characters,
                                  textAlignVertical: TextAlignVertical.center,
                                  onSubmitted: (_) => _onSearch(),
                                  decoration: const InputDecoration(
                                    hintText:
                                        'Ingresar código de OT (ej. OT-2024-001)',
                                    hintStyle: TextStyle(fontSize: 13),
                                    isDense: true,
                                    contentPadding: EdgeInsets.symmetric(
                                      horizontal: 15,
                                      vertical: 15,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            SizedBox(
                              height: _searchBarHeight,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.primary,
                                  minimumSize: const Size(0, _searchBarHeight),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 15,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                onPressed: state.isLoading ? null : _onSearch,
                                child: const Text(
                                  'Buscar',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),

                    if (state.isLoading)
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 40),
                        child: Center(child: CircularProgressIndicator()),
                      )
                    else if (state.isAutoProcessing)
                      const _AutoProcessingView()
                    else if (order == null)
                      _buildEmptyState(theme, isDark)
                    else ...[
                      // 1. Stepper visual
                      WorkOrderProcessStepper(
                        status: order.estado,
                        executionSubStep: state.executionSubStep,
                      ),
                      const SizedBox(height: 14),

                      // 2. Action Card de la fase activa
                      WorkOrderPhaseActionCard(
                        order: order,
                        automationPolicy: _cubit.automationPolicy,
                        isActionLoading:
                            state.isActionLoading || _completionFlowRunning,
                        loadingMessage: _completionFlowRunning
                            ? 'Procesando cierre...'
                            : state.actionLoadingMessage,
                        executionSubStep: state.executionSubStep,
                        onSubStepChanged: (step) =>
                            _cubit.setExecutionSubStep(step),
                        onReceive: () => _cubit.receiveWorkOrder(),
                        onAssignWorker: () {
                          showDialog(
                            context: context,
                            builder: (ctx) => AssignWorkerDialog(
                              orderCode: order.codigoOrden,
                              onAssign: (workerId, comment) =>
                                  _cubit.assignWorker(
                                    workerId: workerId,
                                    comment: comment,
                                  ),
                            ),
                          );
                        },
                        onStartPrep: () => _cubit.startPreparation(),
                        onRestartPrep: () => _cubit.restartPreparation(),
                        onCreateChecklist: () {
                          showDialog(
                            context: context,
                            builder: (ctx) => ChecklistDialog(
                              orderCode: order.codigoOrden,
                              onSubmit: (passed, obs) => _cubit.createChecklist(
                                passed: passed,
                                observations: obs,
                              ),
                            ),
                          );
                        },
                        onResolveChecklist: (approved) =>
                            _cubit.resolveChecklist(approved: approved),
                        onFinishExecution: () => _cubit.finishExecution(),
                        onOpenQualityControl: () {
                          showDialog(
                            context: context,
                            builder: (ctx) => QualityControlDialog(
                              orderCode: order.codigoOrden,
                              onSubmit: (approved, comments) =>
                                  _cubit.createQualityControl(
                                    approved: approved,
                                    comments: comments,
                                  ),
                            ),
                          );
                        },
                        onCompleteOrder: () async {
                          if (_completionFlowRunning) return;
                          setState(() => _completionFlowRunning = true);
                          try {
                            await const OrderCompletionCoordinator().run(
                              context,
                              order,
                              complete: _cubit.completeWorkOrderFlow,
                              uploadEvidence: _cubit.uploadCompletionEvidence,
                            );
                          } catch (error) {
                            if (!context.mounted) return;
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  error is StateError
                                      ? error.message.toString()
                                      : 'No se pudo completar la orden: $error',
                                ),
                              ),
                            );
                          } finally {
                            if (mounted) {
                              setState(() => _completionFlowRunning = false);
                            }
                          }
                        },
                        onOpenSurvey: () {
                          showDialog(
                            context: context,
                            builder: (ctx) => SatisfactionSurveyDialog(
                              orderCode: order.codigoOrden,
                              onSubmit: (rating, comments) =>
                                  _cubit.registerSurvey(
                                    rating: rating,
                                    comments: comments,
                                  ),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 14),

                      // 3. Tarjeta Hero (Resumen cabecera)
                      WorkOrderHeroCard(order: order),
                      const SizedBox(height: 14),

                      // 4. Información del Predio y Solicitante
                      WorkOrderInfoCard(order: order),
                      const SizedBox(height: 14),

                      // 5. Personal Asignado en Campo
                      WorkOrderWorkersCard(
                        order: order,
                        onAddWorkers: (workers) =>
                            _cubit.addWorkersBatch(workers),
                        onRemoveWorker: (workerId) =>
                            _cubit.removeWorker(workerId),
                      ),
                      const SizedBox(height: 14),

                      // 6. Materiales y Costos
                      WorkOrderMaterialsCard(
                        order: order,
                        onAddMaterials: (mats) =>
                            _cubit.addMaterialsBatch(mats),
                        onAddCosts: (costs) => _cubit.addCostsBatch(costs),
                      ),
                      const SizedBox(height: 14),

                      // 7. Evidencias y Archivos
                      WorkOrderAttachmentsCard(
                        order: order,
                        onUploadAttachments: (paths) =>
                            _cubit.uploadAttachments(paths),
                      ),
                      const SizedBox(height: 14),

                      // 8. Control de Calidad
                      WorkOrderQualityCard(
                        order: order,
                        onRegisterQuality: order.controlCalidad == null
                            ? () {
                                showDialog(
                                  context: context,
                                  builder: (ctx) => QualityControlDialog(
                                    orderCode: order.codigoOrden,
                                    onSubmit: (approved, comments) =>
                                        _cubit.createQualityControl(
                                          approved: approved,
                                          comments: comments,
                                        ),
                                  ),
                                );
                              }
                            : null,
                      ),
                      const SizedBox(height: 14),

                      // 9. Encuesta de Satisfacción
                      WorkOrderSurveyCard(
                        order: order,
                        onRegisterSurvey: order.encuestaSatisfaccion == null
                            ? () {
                                showDialog(
                                  context: context,
                                  builder: (ctx) => SatisfactionSurveyDialog(
                                    orderCode: order.codigoOrden,
                                    onSubmit: (rating, comments) =>
                                        _cubit.registerSurvey(
                                          rating: rating,
                                          comments: comments,
                                        ),
                                  ),
                                );
                              }
                            : null,
                      ),
                      const SizedBox(height: 14),

                      // 10. Trazabilidad y Auditoría
                      WorkOrderTimelineCard(tracking: state.tracking),
                      const SizedBox(height: 20),
                    ],
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildEmptyState(ThemeData theme, bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
      alignment: Alignment.center,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: isDark
                  ? theme.colorScheme.primary.withValues(alpha: 0.15)
                  : Colors.blue.shade50,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.assignment_outlined,
              size: 48,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Busque una Orden de Trabajo',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Ingrese el código de la orden de trabajo arriba para visualizar y ejecutar todas las etapas del proceso técnico.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 13,
              color: isDark
                  ? theme.colorScheme.onSurfaceVariant
                  : Colors.grey.shade600,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}

/// Loading mostrado mientras se ejecutan los pasos automáticos ocultos.
class _AutoProcessingView extends StatelessWidget {
  const _AutoProcessingView();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Column(
        children: [
          const SizedBox(
            width: 44,
            height: 44,
            child: CircularProgressIndicator(strokeWidth: 3.5),
          ),
          const SizedBox(height: 18),
          const Text(
            'Preparando la orden de trabajo...',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 6),
          Text(
            'Esto tomará solo unos segundos',
            style: TextStyle(
              fontSize: 12,
              color: cs.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}
