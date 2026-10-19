// Estrategias de pre-cierre según el ORIGEN de la orden de trabajo.
//
//   - SRP: cada handler sabe resolver sólo su origen.
//   - OCP: para un nuevo origen (RECLAMO, INSPECCION, ...) se crea otro
//     handler y se registra en [OrderCompletionCoordinator]; nada más cambia.
//   - LSP: todos los handlers son intercambiables vía la interfaz.
//   - DIP: la página depende del coordinador/abstracción, no de los handlers.
import 'package:auto_route/auto_route.dart';
import 'package:clean_architecture/features/work-orders/domain/entities/evidence_stage.dart';
import 'package:clean_architecture/features/work-orders/domain/entities/work_order_detail_entity.dart';
import 'package:clean_architecture/features/incidents/presentation/pages/solve_incident_screen.dart'
    show SolveIncidentResult;
import 'package:clean_architecture/features/work-orders/presentation/pages/process/dialogs/completion_description_dialog.dart';
import 'package:clean_architecture/routing/routes.gr.dart';
import 'package:flutter/material.dart';

/// Datos producidos por el paso previo (extensible por origen).
class CompletionPreStepResult {
  /// Descripción enviada al completar la orden.
  final String description;

  /// Rutas locales de evidencias a adjuntar a la OT antes del cierre.
  final List<String> evidencePaths;

  const CompletionPreStepResult({
    required this.description,
    this.evidencePaths = const [],
  });
}

/// Contrato: acción previa al cierre de una OT para un origen concreto.
abstract interface class OrderOriginCompletionHandler {
  /// ¿Este handler aplica a la orden?
  bool supports(WorkOrderDetailEntity order);

  /// Ejecuta el paso previo. Devuelve el resultado si se puede completar
  /// la OT, o `null` si el usuario canceló.
  Future<CompletionPreStepResult?> beforeComplete(
    BuildContext context,
    WorkOrderDetailEntity order,
  );
}

/// Origen INCIDENTE: abre la pantalla de resolución; sólo si se resuelve
/// se completa la orden (ambas operaciones juntas).
final class IncidentOriginCompletionHandler
    implements OrderOriginCompletionHandler {
  const IncidentOriginCompletionHandler();

  @override
  bool supports(WorkOrderDetailEntity order) =>
      order.origen.trim().toUpperCase().startsWith('INCIDEN') &&
      (order.idEntidadOrigen?.isNotEmpty ?? false);

  @override
  Future<CompletionPreStepResult?> beforeComplete(
    BuildContext context,
    WorkOrderDetailEntity order,
  ) async {
    final result = await context.router.push<Object?>(
      SolveIncidentScreen(
        incidentId: order.idEntidadOrigen!,
        incidentCode: order.codigoEntidadOrigen ?? order.codigoOrden,
      ),
    );
    if (result is SolveIncidentResult) {
      return CompletionPreStepResult(
        description: result.description,
        evidencePaths: result.imagePaths,
      );
    }
    return null;
  }
}

/// Fallback (Null Object): sin origen o sin paso previo → completar normal.
final class DefaultCompletionHandler implements OrderOriginCompletionHandler {
  const DefaultCompletionHandler();

  @override
  bool supports(WorkOrderDetailEntity order) => true;

  @override
  Future<CompletionPreStepResult?> beforeComplete(
    BuildContext context,
    WorkOrderDetailEntity order,
  ) async {
    final result = await showDialog<CompletionDescriptionDialogResult>(
      context: context,
      builder: (_) => const CompletionDescriptionDialog(),
    );
    if (result == null) return null;
    return CompletionPreStepResult(
      description: result.description,
      evidencePaths: result.evidencePaths,
    );
  }
}

/// Selecciona el handler adecuado y orquesta el cierre.
final class OrderCompletionCoordinator {
  final List<OrderOriginCompletionHandler> _handlers;

  const OrderCompletionCoordinator({
    List<OrderOriginCompletionHandler> handlers = const [
      IncidentOriginCompletionHandler(),
      // Registrar aquí nuevos orígenes.
    ],
  }) : _handlers = handlers;

  OrderOriginCompletionHandler _resolve(WorkOrderDetailEntity order) =>
      _handlers.firstWhere(
        (h) => h.supports(order),
        orElse: () => const DefaultCompletionHandler(),
      );

  /// Ejecuta el paso previo del origen; adjunta evidencias (si hay)
  /// mediante [uploadEvidence] y luego [complete].
  Future<void> run(
    BuildContext context,
    WorkOrderDetailEntity order, {
    required Future<void> Function(String description) complete,
    required Future<void> Function(List<String> paths, EvidenceStage stage)
    uploadEvidence,
  }) async {
    final result = await _resolve(order).beforeComplete(context, order);
    if (result == null || !context.mounted) return;
    if (result.evidencePaths.isNotEmpty) {
      // Evidencias del cierre (OT e incidente resuelto) = trabajo terminado.
      await uploadEvidence(result.evidencePaths, EvidenceStage.workCompleted);
    }
    await complete(result.description);
  }
}
