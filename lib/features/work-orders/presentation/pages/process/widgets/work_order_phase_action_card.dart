import 'package:clean_architecture/core/constants/app_colors.dart';
import 'package:clean_architecture/features/work-orders/domain/entities/work_order_detail_entity.dart';
import 'package:clean_architecture/features/work-orders/domain/automation/work_order_automation_policy.dart';
import 'package:flutter/material.dart';

class WorkOrderPhaseActionCard extends StatelessWidget {
  final WorkOrderDetailEntity order;
  final bool isActionLoading;
  final String? loadingMessage;
  final int executionSubStep;
  final ValueChanged<int> onSubStepChanged;
  final VoidCallback onReceive;
  final VoidCallback onAssignWorker;
  final VoidCallback onStartPrep;
  final VoidCallback onRestartPrep;
  final VoidCallback onCreateChecklist;
  final Function(bool approved) onResolveChecklist;
  final VoidCallback onFinishExecution;
  final VoidCallback onOpenQualityControl;
  final VoidCallback onCompleteOrder;
  final VoidCallback onOpenSurvey;

  /// Define qué pasos se ocultan porque se ejecutan automáticamente.
  final WorkOrderAutomationPolicy automationPolicy;

  const WorkOrderPhaseActionCard({
    super.key,
    required this.order,
    required this.isActionLoading,
    this.loadingMessage,
    required this.executionSubStep,
    required this.onSubStepChanged,
    required this.onReceive,
    required this.onAssignWorker,
    required this.onStartPrep,
    required this.onRestartPrep,
    required this.onCreateChecklist,
    required this.onResolveChecklist,
    required this.onFinishExecution,
    required this.onOpenQualityControl,
    required this.onCompleteOrder,
    required this.onOpenSurvey,
    this.automationPolicy = const WorkOrderAutomationPolicy.manual(),
  });

  bool get _autoFinish => automationPolicy.isAuto(AutoStep.finishExecution);
  bool get _autoQualityControl =>
      automationPolicy.isAuto(AutoStep.qualityControl);

  bool get isExecutionState {
    final s = order.estado.toUpperCase();
    return [
      'EN_PROCESO',
      'EN_PROCESO_INSPECCION',
      'EN_PROCESO_INSTALACION',
    ].contains(s);
  }

  bool get isExecutedState {
    final s = order.estado.toUpperCase();
    return [
      'EJECUTADA',
      'INSPECCION_EJECUTADA',
      'INSTALACION_EJECUTADA',
    ].contains(s);
  }

  bool get isCompletedState {
    final s = order.estado.toUpperCase();
    return [
      'COMPLETADA',
      'INSPECCION_COMPLETADA',
      'INSTALACION_COMPLETADA',
    ].contains(s);
  }

  @override
  Widget build(BuildContext context) {
    final estado = order.estado.toUpperCase();

    String phaseBadge = 'Fase del Proceso';
    String title = 'Acción Requerida';
    String description = '';
    Color themeColor = AppColors.primary;
    IconData phaseIcon = Icons.info_outline;

    Widget actionButtons = const SizedBox.shrink();

    if (estado == 'NOTIFICADA') {
      phaseBadge = 'Recepción Operativa';
      title = 'Recepción de Orden';
      description =
          'La orden ha sido emitida. Recepcione la orden para pasarla al estado PENDIENTE.';
      themeColor = const Color(0xFF2563EB);
      phaseIcon = Icons.inbox_rounded;
      actionButtons = ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          backgroundColor: themeColor,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        onPressed: isActionLoading ? null : onReceive,
        icon: const Icon(
          Icons.check_circle_outline,
          color: Colors.white,
          size: 18,
        ),
        label: const Text(
          'Recepcionar Orden de Trabajo',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      );
    } else if (estado == 'PENDIENTE') {
      phaseBadge = 'Asignación de Personal';
      title = 'Asignación de Técnico';
      description =
          'La orden está recepcionada. Asigne al técnico responsable que liderará la cuadrilla.';
      themeColor = const Color(0xFF6366F1);
      phaseIcon = Icons.person_add_rounded;
      actionButtons = ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          backgroundColor: themeColor,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        onPressed: isActionLoading ? null : onAssignWorker,
        icon: const Icon(Icons.person_add, color: Colors.white, size: 18),
        label: const Text(
          'Asignar Técnico Responsable',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      );
    } else if (estado == 'ASIGNADA') {
      phaseBadge = 'Fase 3 - Preparación de Campo';
      title = 'Inicio de Preparación';
      description =
          'El técnico fue asignado. Inicie la preparación para alistar herramientas, EPP y planos.';
      themeColor = const Color(0xFF0D9488);
      phaseIcon = Icons.play_arrow_rounded;
      actionButtons = ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          backgroundColor: themeColor,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        onPressed: isActionLoading ? null : onStartPrep,
        icon: const Icon(Icons.play_circle_fill, color: Colors.white, size: 18),
        label: const Text(
          'Iniciar Preparación',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      );
    } else if (estado == 'PREPARACION' && order.idInspeccion == null) {
      phaseBadge = 'Fase 3 - Checklist de Preparación';
      title = 'Inspección Previa Requerida';
      description =
          'Diligencie el checklist de verificación antes de que la cuadrilla se desplace a campo.';
      themeColor = const Color(0xFFD97706);
      phaseIcon = Icons.checklist_rounded;
      actionButtons = ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          backgroundColor: themeColor,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        onPressed: isActionLoading ? null : onCreateChecklist,
        icon: const Icon(Icons.checklist, color: Colors.white, size: 18),
        label: const Text(
          'Registrar Checklist',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      );
    } else if (estado == 'PREPARACION' && order.idInspeccion != null) {
      phaseBadge = 'Fase 3 - Resolución de Checklist';
      title = 'Resolver Preparación';
      description =
          'El checklist ha sido registrado. Apruebe para pasar a ejecución o rechace para corregir.';
      themeColor = const Color(0xFFD97706);
      phaseIcon = Icons.assignment_turned_in_rounded;
      actionButtons = Wrap(
        spacing: 10,
        runSpacing: 10,
        children: [
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green.shade600,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: isActionLoading ? null : () => onResolveChecklist(true),
            icon: const Icon(Icons.check_circle, color: Colors.white, size: 18),
            label: const Text(
              'Aprobar e Iniciar Ejecución',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          OutlinedButton.icon(
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.red.shade700,
              side: BorderSide(color: Colors.red.shade400),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: isActionLoading ? null : () => onResolveChecklist(false),
            icon: const Icon(Icons.cancel_outlined, size: 18),
            label: const Text(
              'Rechazar Preparación',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      );
    } else if (estado == 'REVISION_RECHAZADA') {
      phaseBadge = 'Fase 3 - Corrección de Preparación';
      title = 'Preparación Rechazada';
      description =
          'La preparación fue rechazada. Corrija los requisitos faltantes y reinicie la etapa.';
      themeColor = const Color(0xFFDC2626);
      phaseIcon = Icons.warning_amber_rounded;
      actionButtons = ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          backgroundColor: themeColor,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        onPressed: isActionLoading ? null : onRestartPrep,
        icon: const Icon(Icons.refresh, color: Colors.white, size: 18),
        label: const Text(
          'Reiniciar Preparación',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      );
    } else if (isExecutionState) {
      phaseBadge = 'Fase 4 - Ejecución en Campo';
      title = executionSubStep == 0
          ? 'Paso 1: Personal y Materiales'
          : 'Paso 2: Evidencias y Finalización';
      description = executionSubStep == 0
          ? 'Asigne personal de apoyo y registre materiales y costos adicionales utilizados en la labor.'
          : 'Suba fotos y documentos de evidencia técnica y finalice los trabajos en campo.';
      themeColor = const Color(0xFF0284C7);
      phaseIcon = Icons.engineering_rounded;

      actionButtons = Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Sub-step switcher
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () => onSubStepChanged(0),
                    borderRadius: BorderRadius.circular(8),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      decoration: BoxDecoration(
                        color: executionSubStep == 0
                            ? AppColors.primary
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        '1. Personal y Materiales',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: executionSubStep == 0
                              ? Colors.white
                              : Colors.grey.shade700,
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: InkWell(
                    onTap: () => onSubStepChanged(1),
                    borderRadius: BorderRadius.circular(8),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      decoration: BoxDecoration(
                        color: executionSubStep == 1
                            ? AppColors.primary
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        '2. Evidencias de Campo',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: executionSubStep == 1
                              ? Colors.white
                              : Colors.grey.shade700,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF059669),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: isActionLoading
                ? null
                : (_autoFinish ? onCompleteOrder : onFinishExecution),
            icon: Icon(
              _autoFinish ? Icons.task_alt : Icons.done_all_rounded,
              color: Colors.white,
              size: 18,
            ),
            label: Text(
              _autoFinish ? 'Completar Orden' : 'Finalizar Ejecución Técnica',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      );
    } else if (isExecutedState) {
      phaseBadge = 'Fase 5 - Calidad y Cierre';
      title = 'Control de Calidad y Cierre Operativo';
      description =
          'La ejecución finalizó. Emita el dictamen de control de calidad y proceda al cierre administrativo.';
      themeColor = const Color(0xFF7C3AED);
      phaseIcon = Icons.shield_rounded;

      actionButtons = Wrap(
        spacing: 10,
        runSpacing: 10,
        children: [
          if (!_autoQualityControl)
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: themeColor,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: isActionLoading ? null : onOpenQualityControl,
              icon: const Icon(
                Icons.verified_user_outlined,
                color: Colors.white,
                size: 18,
              ),
              label: const Text(
                'Emitir Control de Calidad',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF047857),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: isActionLoading ? null : onCompleteOrder,
            icon: const Icon(Icons.task_alt, color: Colors.white, size: 18),
            label: const Text(
              'Completar Orden',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      );
    } else if (isCompletedState && order.idEncuesta == null) {
      phaseBadge = 'Fase 6 - Encuesta de Satisfacción';
      title = 'Cierre con el Cliente';
      description =
          'La orden ha sido completada. Registre la calificación y opinión del usuario servido.';
      themeColor = const Color(0xFFB45309);
      phaseIcon = Icons.star_rate_rounded;

      actionButtons = ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          backgroundColor: themeColor,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        onPressed: isActionLoading ? null : onOpenSurvey,
        icon: const Icon(Icons.star_rounded, color: Colors.white, size: 18),
        label: const Text(
          'Registrar Encuesta de Satisfacción',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      );
    } else {
      phaseBadge = 'Fase 6 - Orden Finalizada';
      title = 'Proceso Completado';
      description =
          'Esta orden de trabajo ha cumplido satisfactoriamente con todas las etapas operativas y de calidad.';
      themeColor = Colors.green.shade700;
      phaseIcon = Icons.check_circle_outline_rounded;
      actionButtons = Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.green.shade50,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.green.shade300),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.check_circle, color: Colors.green.shade700, size: 16),
            const SizedBox(width: 8),
            Text(
              'Ciclo de Vida Completado',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 12,
                color: Colors.green.shade800,
              ),
            ),
          ],
        ),
      );
    }

    return Card(
      elevation: 2,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: themeColor.withOpacity(0.3), width: 1.5),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            colors: [themeColor.withOpacity(0.06), Colors.white],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: themeColor.withOpacity(0.12),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(phaseIcon, color: themeColor, size: 22),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: themeColor.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          phaseBadge,
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: themeColor,
                          ),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              description,
              style: TextStyle(
                fontSize: 12.5,
                color: Colors.grey.shade700,
                height: 1.35,
              ),
            ),
            const SizedBox(height: 14),
            if (isActionLoading)
              Container(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Row(
                  children: [
                    SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: themeColor,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      loadingMessage ?? 'Procesando operación...',
                      style: TextStyle(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w600,
                        color: themeColor,
                      ),
                    ),
                  ],
                ),
              )
            else
              actionButtons,
          ],
        ),
      ),
    );
  }
}
