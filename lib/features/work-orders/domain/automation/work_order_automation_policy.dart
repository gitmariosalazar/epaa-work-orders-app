// Política de automatización del proceso de Órdenes de Trabajo.
//
// Algunos pasos del flujo siempre se aprueban hoy (recepción, preparación,
// checklist, control de calidad...). Para reducir clics se ejecutan
// automáticamente con descripciones por defecto, SIN eliminar ningún paso:
// cada transición sigue registrándose en el backend y la UI manual se conserva.
//
// Para volver a hacer manual un paso en el futuro basta con quitarlo de
// [WorkOrderAutomationPolicy.enabled] (OCP: no se toca cubit ni UI).
//
//   - SRP: este archivo sólo DECIDE qué paso automático corresponde.
//   - OCP: nuevos pasos ⇒ nuevo valor de [AutoStep] + regla en el resolver.
//   - DIP: el cubit depende de la política, no de reglas codificadas.
import 'package:clean_architecture/features/work-orders/domain/entities/work_order_detail_entity.dart';

/// Pasos del flujo que pueden ejecutarse automáticamente.
enum AutoStep {
  receive,
  startPreparation,
  createChecklist,
  approveChecklist,
  restartPreparation,
  finishExecution,
  qualityControl,
}

/// Descripciones por defecto enviadas en los pasos automáticos.
abstract final class AutoStepDefaults {
  static const checklistObservations =
      'Checklist de preparación aprobado automáticamente.';
  static const checklistApproval =
      'Preparación aprobada automáticamente — iniciando ejecución.';
  static const qualityControlComments =
      'Control de calidad aprobado automáticamente al completar la orden.';
}

/// Configuración de qué pasos son automáticos.
class WorkOrderAutomationPolicy {
  final Set<AutoStep> enabled;

  const WorkOrderAutomationPolicy(this.enabled);

  /// Configuración actual: todos los pasos de aprobación son automáticos.
  const WorkOrderAutomationPolicy.defaults()
    : enabled = const {
        AutoStep.receive,
        AutoStep.startPreparation,
        AutoStep.createChecklist,
        AutoStep.approveChecklist,
        AutoStep.restartPreparation,
        AutoStep.finishExecution,
        AutoStep.qualityControl,
      };

  /// Flujo 100 % manual (comportamiento original).
  const WorkOrderAutomationPolicy.manual() : enabled = const {};

  bool isAuto(AutoStep step) => enabled.contains(step);
}

/// Resuelve el paso automático que corresponde al estado actual de la OT.
abstract final class WorkOrderAutoStepResolver {
  static const executionStates = {
    'EN_PROCESO',
    'EN_PROCESO_INSPECCION',
    'EN_PROCESO_INSTALACION',
  };

  static const executedStates = {
    'EJECUTADA',
    'INSPECCION_EJECUTADA',
    'INSTALACION_EJECUTADA',
  };

  static bool isExecution(String estado) =>
      executionStates.contains(estado.toUpperCase());

  static bool isExecuted(String estado) =>
      executedStates.contains(estado.toUpperCase());

  /// Pasos de "fondo" (no requieren datos del usuario). `null` ⇒ ninguno:
  /// el usuario debe actuar (asignar responsable, personal, materiales…).
  static AutoStep? nextBackgroundStep(
    WorkOrderDetailEntity order,
    WorkOrderAutomationPolicy policy,
  ) {
    final estado = order.estado.toUpperCase();
    final AutoStep? step = switch (estado) {
      'NOTIFICADA' => AutoStep.receive,
      'ASIGNADA' => AutoStep.startPreparation,
      'PREPARACION' =>
        order.idInspeccion == null
            ? AutoStep.createChecklist
            : AutoStep.approveChecklist,
      'REVISION_RECHAZADA' => AutoStep.restartPreparation,
      _ => null,
    };
    return (step != null && policy.isAuto(step)) ? step : null;
  }

  /// Pasos previos al cierre que se ejecutan al pulsar "Completar Orden".
  static List<AutoStep> completionSteps(
    WorkOrderDetailEntity order,
    WorkOrderAutomationPolicy policy,
  ) {
    final steps = <AutoStep>[];
    if (isExecution(order.estado) && policy.isAuto(AutoStep.finishExecution)) {
      steps.add(AutoStep.finishExecution);
    }
    if ((isExecution(order.estado) || isExecuted(order.estado)) &&
        order.idControl == null &&
        policy.isAuto(AutoStep.qualityControl)) {
      steps.add(AutoStep.qualityControl);
    }
    return steps;
  }
}
