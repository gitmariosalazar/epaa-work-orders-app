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
  late final WorkOrderProcessCubit _cubit;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _cubit = GetIt.I<WorkOrderProcessCubit>();

    if (widget.initialOrderCode != null && widget.initialOrderCode!.isNotEmpty) {
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

          return Scaffold(
            backgroundColor: const Color(0xFFF8FAFC),
            appBar: AppBar(
              title: Text(
                order != null
                    ? 'Proceso OT: ${order.codigoOrden}'
                    : 'Gestión de Proceso OT',
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              centerTitle: true,
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              actions: [
                if (order != null)
                  IconButton(
                    icon: const Icon(Icons.refresh_rounded),
                    tooltip: 'Recargar orden',
                    onPressed: state.isLoading || state.isActionLoading
                        ? null
                        : () => _cubit.reloadCurrentOrder(),
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
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Buscador
                    Card(
                      elevation: 1,
                      margin: EdgeInsets.zero,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                        child: Row(
                          children: [
                            const Icon(Icons.search, color: Colors.grey),
                            const SizedBox(width: 8),
                            Expanded(
                              child: TextField(
                                controller: _searchController,
                                textCapitalization: TextCapitalization.characters,
                                onSubmitted: (_) => _onSearch(),
                                decoration: const InputDecoration(
                                  hintText: 'Ingresar código de OT (ej. OT-2024-001)',
                                  hintStyle: TextStyle(fontSize: 13),
                                  border: InputBorder.none,
                                ),
                              ),
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primary,
                                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              onPressed: state.isLoading ? null : _onSearch,
                              child: const Text(
                                'Buscar',
                                style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
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
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      )
                    else if (order == null)
                      _buildEmptyState()
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
                        isActionLoading: state.isActionLoading,
                        loadingMessage: state.actionLoadingMessage,
                        executionSubStep: state.executionSubStep,
                        onSubStepChanged: (step) => _cubit.setExecutionSubStep(step),
                        onReceive: () => _cubit.receiveWorkOrder(),
                        onAssignWorker: () {
                          showDialog(
                            context: context,
                            builder: (ctx) => AssignWorkerDialog(
                              orderCode: order.codigoOrden,
                              onAssign: (workerId, comment) =>
                                  _cubit.assignWorker(workerId: workerId, comment: comment),
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
                              onSubmit: (passed, obs) =>
                                  _cubit.createChecklist(passed: passed, observations: obs),
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
                                  _cubit.createQualityControl(approved: approved, comments: comments),
                            ),
                          );
                        },
                        onCompleteOrder: () => const OrderCompletionCoordinator().run(
                          context,
                          order,
                          complete: _cubit.completeWorkOrder,
                          uploadEvidence: _cubit.uploadAttachments,
                        ),
                        onOpenSurvey: () {
                          showDialog(
                            context: context,
                            builder: (ctx) => SatisfactionSurveyDialog(
                              orderCode: order.codigoOrden,
                              onSubmit: (rating, comments) =>
                                  _cubit.registerSurvey(rating: rating, comments: comments),
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
                        onAddWorkers: (workers) => _cubit.addWorkersBatch(workers),
                        onRemoveWorker: (workerId) => _cubit.removeWorker(workerId),
                      ),
                      const SizedBox(height: 14),

                      // 6. Materiales y Costos
                      WorkOrderMaterialsCard(
                        order: order,
                        onAddMaterials: (mats) => _cubit.addMaterialsBatch(mats),
                        onAddCosts: (costs) => _cubit.addCostsBatch(costs),
                      ),
                      const SizedBox(height: 14),

                      // 7. Evidencias y Archivos
                      WorkOrderAttachmentsCard(
                        order: order,
                        onUploadAttachments: (paths) => _cubit.uploadAttachments(paths),
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

  Widget _buildEmptyState() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
      alignment: Alignment.center,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.assignment_outlined, size: 48, color: AppColors.primary),
          ),
          const SizedBox(height: 16),
          const Text(
            'Busque una Orden de Trabajo',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            'Ingrese el código de la orden de trabajo arriba para visualizar y ejecutar todas las etapas del proceso técnico.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 13, color: Colors.grey.shade600, height: 1.4),
          ),
        ],
      ),
    );
  }
}
