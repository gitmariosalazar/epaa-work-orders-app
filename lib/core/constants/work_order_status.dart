/// Catálogo de estados de Orden de Trabajo (fuente única de verdad).
///
/// Refleja la tabla de estados del backend: `code`, `label`, `description`,
/// `isActive`. No depende de Flutter (dominio puro); los colores e íconos se
/// resuelven en la capa de presentación (`MapUtils`).
class WorkOrderStatus {
  final String code;
  final String label;
  final String description;
  final bool isActive;

  const WorkOrderStatus(
    this.code,
    this.label,
    this.description, {
    this.isActive = true,
  });

  // ── Flujo general ──────────────────────────────────────────────────────
  static const notificada = 'NOTIFICADA';
  static const pendiente = 'PENDIENTE';
  static const asignada = 'ASIGNADA';
  static const preparacion = 'PREPARACION';
  static const revisionRechazada = 'REVISION_RECHAZADA';
  static const enProceso = 'EN_PROCESO';
  static const ejecutada = 'EJECUTADA';
  static const rechazadaTecnica = 'RECHAZADA_TECNICA';
  static const completada = 'COMPLETADA';
  static const cancelada = 'CANCELADA';

  // ── Inspección ─────────────────────────────────────────────────────────
  static const notificadaInspeccion = 'NOTIFICADA_INSPECCION';
  static const pendienteInspeccion = 'PENDIENTE_INSPECCION';
  static const enProcesoInspeccion = 'EN_PROCESO_INSPECCION';
  static const inspeccionEjecutada = 'INSPECCION_EJECUTADA';
  static const inspeccionCompletada = 'INSPECCION_COMPLETADA';

  // ── Instalación ────────────────────────────────────────────────────────
  static const notificadaInstalacion = 'NOTIFICADA_INSTALACION';
  static const pendienteInstalacion = 'PENDIENTE_INSTALACION';
  static const enProcesoInstalacion = 'EN_PROCESO_INSTALACION';
  static const instalacionEjecutada = 'INSTALACION_EJECUTADA';
  static const instalacionCompletada = 'INSTALACION_COMPLETADA';

  static const List<WorkOrderStatus> all = [
    WorkOrderStatus(notificada, 'Notificada',
        'OT registrada, pendiente de recepción por operaciones'),
    WorkOrderStatus(pendiente, 'Pendiente',
        'OT recibida, en espera de asignación de personal'),
    WorkOrderStatus(asignada, 'Asignada',
        'Personal asignado, en espera de inicio de preparación'),
    WorkOrderStatus(preparacion, 'En Preparación',
        'El equipo está preparando materiales y EPP en campo'),
    WorkOrderStatus(revisionRechazada, 'Revisión Rechazada',
        'La inspección de seguridad no fue superada, retorna a preparación'),
    WorkOrderStatus(enProceso, 'En Proceso',
        'Trabajo en ejecución activa en campo'),
    WorkOrderStatus(ejecutada, 'Ejecutada',
        'Trabajo finalizado, pendiente de evaluación de calidad'),
    WorkOrderStatus(rechazadaTecnica, 'Rechazada Técnica',
        'La evaluación de calidad falló, retorna a ejecución'),
    WorkOrderStatus(completada, 'Completada',
        'OT finalizada con éxito y aprobada en todos los controles'),
    WorkOrderStatus(cancelada, 'Cancelada',
        'OT cancelada por el administrador'),
    WorkOrderStatus(notificadaInspeccion, 'Notificada — Inspección',
        'OT de inspección de factibilidad creada, en espera de inicio'),
    WorkOrderStatus(pendienteInspeccion, 'Pendiente Inspección',
        'Inspector asignado, en espera de inicio de la visita técnica'),
    WorkOrderStatus(enProcesoInspeccion, 'Inspección en Proceso',
        'Inspector activo en campo realizando el levantamiento'),
    WorkOrderStatus(inspeccionEjecutada, 'Inspección Ejecutada',
        'Inspector finalizó en campo, informe técnico pendiente de carga'),
    WorkOrderStatus(inspeccionCompletada, 'Inspección Completada',
        'Informe técnico aprobado, OT de inspección cerrada'),
    WorkOrderStatus(notificadaInstalacion, 'Notificada — Instalación',
        'OT de instalación de acometida creada, en espera de inicio'),
    WorkOrderStatus(pendienteInstalacion, 'Pendiente Instalación',
        'Técnico asignado, en espera de inicio de la instalación'),
    WorkOrderStatus(enProcesoInstalacion, 'Instalación en Proceso',
        'Técnico activo en campo ejecutando la instalación'),
    WorkOrderStatus(instalacionEjecutada, 'Instalación Ejecutada',
        'Técnico finalizó en campo, cierre y registro catastral pendiente'),
    WorkOrderStatus(instalacionCompletada, 'Instalación Completada',
        'Suministro activado y catastro registrado, OT cerrada'),
  ];

  static final Map<String, WorkOrderStatus> _byCode = {
    for (final s in all) s.code: s,
  };

  /// Normaliza el código recibido (mayúsculas, sin espacios).
  static String normalize(String? code) =>
      (code ?? '').trim().toUpperCase().replaceAll(' ', '_');

  static WorkOrderStatus? of(String? code) => _byCode[normalize(code)];

  static String labelOf(String? code) =>
      of(code)?.label ??
      (normalize(code).isEmpty ? 'Desconocido' : normalize(code).replaceAll('_', ' '));

  static String descriptionOf(String? code) => of(code)?.description ?? '';

  /// Estados finales (la OT ya no admite acciones).
  static bool isFinal(String? code) => const {
    completada,
    cancelada,
    inspeccionCompletada,
    instalacionCompletada,
  }.contains(normalize(code));

  // ── Flujos secuenciales (camino feliz) ─────────────────────────────────
  static const List<String> generalFlow = [
    notificada,
    pendiente,
    asignada,
    preparacion,
    enProceso,
    ejecutada,
    completada,
  ];

  static const List<String> inspectionFlow = [
    notificadaInspeccion,
    pendienteInspeccion,
    enProcesoInspeccion,
    inspeccionEjecutada,
    inspeccionCompletada,
  ];

  static const List<String> installationFlow = [
    notificadaInstalacion,
    pendienteInstalacion,
    enProcesoInstalacion,
    instalacionEjecutada,
    instalacionCompletada,
  ];

  /// Flujo al que pertenece el estado (rechazos vuelven al flujo general).
  static List<String> flowOf(String? code) {
    final c = normalize(code);
    if (inspectionFlow.contains(c)) return inspectionFlow;
    if (installationFlow.contains(c)) return installationFlow;
    return generalFlow;
  }

  /// Siguiente estado del flujo, o null si es final.
  static String? nextOf(String? code) {
    final c = normalize(code);
    if (c == revisionRechazada) return preparacion;
    if (c == rechazadaTecnica) return enProceso;
    final flow = flowOf(c);
    final i = flow.indexOf(c);
    return (i >= 0 && i < flow.length - 1) ? flow[i + 1] : null;
  }
}
