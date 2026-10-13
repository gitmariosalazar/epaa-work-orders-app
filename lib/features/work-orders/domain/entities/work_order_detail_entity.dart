import 'package:equatable/equatable.dart';

class AssignedWorkerEntity extends Equatable {
  final String idAsignacion;
  final String idTrabajador;
  final String nombreTrabajador;
  final String? rol;
  final bool esResponsable;
  final String fechaAsignacion;

  const AssignedWorkerEntity({
    required this.idAsignacion,
    required this.idTrabajador,
    required this.nombreTrabajador,
    this.rol,
    required this.esResponsable,
    required this.fechaAsignacion,
  });

  String get nombreCompleto => nombreTrabajador;
  String? get nombreRol => rol;
  int? get idRolTrabajador => esResponsable ? 1 : 2;

  @override
  List<Object?> get props => [
        idAsignacion,
        idTrabajador,
        nombreTrabajador,
        rol,
        esResponsable,
        fechaAsignacion,
      ];
}

class UsedMaterialEntity extends Equatable {
  final String idDetalle;
  final String idMaterial;
  final String? codigoMaterial;
  final String? nombreMaterial;
  final double cantidad;
  final double costoUnitario;
  final double subtotal;

  const UsedMaterialEntity({
    required this.idDetalle,
    required this.idMaterial,
    this.codigoMaterial,
    this.nombreMaterial,
    required this.cantidad,
    required this.costoUnitario,
    required this.subtotal,
  });

  @override
  List<Object?> get props => [
        idDetalle,
        idMaterial,
        codigoMaterial,
        nombreMaterial,
        cantidad,
        costoUnitario,
        subtotal,
      ];
}

class AdditionalCostEntity extends Equatable {
  final String idCosto;
  final String concepto;
  final double cantidad;
  final double costoUnitario;
  final double total;

  const AdditionalCostEntity({
    required this.idCosto,
    required this.concepto,
    required this.cantidad,
    required this.costoUnitario,
    required this.total,
  });

  double get subtotal => total;

  @override
  List<Object?> get props => [
        idCosto,
        concepto,
        cantidad,
        costoUnitario,
        total,
      ];
}

class EvidenceAttachmentEntity extends Equatable {
  final String idAdjunto;
  final String nombreArchivo;
  final String url;
  final String tipoAdjunto;
  final String? mimeType;
  final String fechaCarga;

  const EvidenceAttachmentEntity({
    required this.idAdjunto,
    required this.nombreArchivo,
    required this.url,
    required this.tipoAdjunto,
    this.mimeType,
    required this.fechaCarga,
  });

  String get urlArchivo => url;
  String? get fechaSubida => fechaCarga;

  @override
  List<Object?> get props => [
        idAdjunto,
        nombreArchivo,
        url,
        tipoAdjunto,
        mimeType,
        fechaCarga,
      ];
}

class LogObservationEntity extends Equatable {
  final String idObservacion;
  final String texto;
  final String fecha;
  final String autorId;

  const LogObservationEntity({
    required this.idObservacion,
    required this.texto,
    required this.fecha,
    required this.autorId,
  });

  @override
  List<Object?> get props => [idObservacion, texto, fecha, autorId];
}

class WorkOrderDetailEntity extends Equatable {
  // Identificación
  final String idOrdenTrabajo;
  final String codigoOrden;
  final int numeroSecuencial;
  final int version;
  final String estado;
  final String estadoLabel;
  final String origen;
  final String origenLabel;
  final String? codigoEntidadOrigen;
  final String? idEntidadOrigen;

  // Clasificación
  final String tipoTrabajo;
  final String? tipoTrabajoDescripcion;
  final String departamento;
  final String prioridad;
  final int slaHoras;

  // Ubicación
  final String? direccion;
  final String? ubicacionDetalles;
  final String? claveCatastral;
  final double? latitud;
  final double? longitud;

  // Descripción y Metadata
  final String? descripcion;
  final Map<String, dynamic>? metadata;

  // Métricas de Tiempo
  final String fechaCreacion;
  final String? fechaAsignacion;
  final String? fechaInicioCampo;
  final String? fechaCompletada;
  final int diasEnProceso;
  final int horasTotalesProceso;
  final int? horasHastaAsignacion;
  final int? horasEjecucionCampo;

  // SLA
  final bool cumpleSla;
  final int horasRestantesSla;

  // Asignación Operativa
  final String? inspectorNombre;
  final String? nombreAsignador;
  final String? nombreCompletador;
  final String creadorNombre;

  // Cliente Vinculado
  final String? idCliente;
  final String? clienteNombre;
  final String? clienteTelefono;
  final String? clienteEmail;
  final String? acometidaNumeroMedidor;
  final String? acometidaTarifa;

  // Bloques
  final List<AssignedWorkerEntity> personalAsignado;
  final List<UsedMaterialEntity> materiales;
  final List<AdditionalCostEntity> costosAdicionales;
  final List<EvidenceAttachmentEntity> adjuntos;
  final List<LogObservationEntity> observaciones;

  // Resumen Costos
  final double costoTotalMateriales;
  final double costoTotalAdicionales;
  final double costoTotalOrden;

  // Checklist de Preparación
  final String? idInspeccion;
  final bool? checklistAprobado;
  final String? observacionesChecklist;

  // Control de Calidad
  final String? idControl;
  final bool? calidadAprobada;
  final String? comentariosCalidad;

  // Encuesta de Satisfacción
  final String? idEncuesta;
  final int? calificacionSatisfaccion;
  final String? comentariosSatisfaccion;

  const WorkOrderDetailEntity({
    required this.idOrdenTrabajo,
    required this.codigoOrden,
    this.numeroSecuencial = 0,
    this.version = 1,
    required this.estado,
    required this.estadoLabel,
    required this.origen,
    required this.origenLabel,
    this.codigoEntidadOrigen,
    this.idEntidadOrigen,
    required this.tipoTrabajo,
    this.tipoTrabajoDescripcion,
    this.departamento = '',
    required this.prioridad,
    this.slaHoras = 48,
    this.direccion,
    this.ubicacionDetalles,
    this.claveCatastral,
    this.latitud,
    this.longitud,
    this.descripcion,
    this.metadata,
    required this.fechaCreacion,
    this.fechaAsignacion,
    this.fechaInicioCampo,
    this.fechaCompletada,
    this.diasEnProceso = 0,
    this.horasTotalesProceso = 0,
    this.horasHastaAsignacion,
    this.horasEjecucionCampo,
    this.cumpleSla = true,
    this.horasRestantesSla = 0,
    this.inspectorNombre,
    this.nombreAsignador,
    this.nombreCompletador,
    this.creadorNombre = '',
    this.idCliente,
    this.clienteNombre,
    this.clienteTelefono,
    this.clienteEmail,
    this.acometidaNumeroMedidor,
    this.acometidaTarifa,
    this.personalAsignado = const [],
    this.materiales = const [],
    this.costosAdicionales = const [],
    this.adjuntos = const [],
    this.observaciones = const [],
    this.costoTotalMateriales = 0.0,
    this.costoTotalAdicionales = 0.0,
    this.costoTotalOrden = 0.0,
    this.idInspeccion,
    this.checklistAprobado,
    this.observacionesChecklist,
    this.idControl,
    this.calidadAprobada,
    this.comentariosCalidad,
    this.idEncuesta,
    this.calificacionSatisfaccion,
    this.comentariosSatisfaccion,
  });

  @override
  List<Object?> get props => [
        idOrdenTrabajo,
        codigoOrden,
        numeroSecuencial,
        version,
        estado,
        estadoLabel,
        origen,
        origenLabel,
        codigoEntidadOrigen,
        idEntidadOrigen,
        tipoTrabajo,
        tipoTrabajoDescripcion,
        departamento,
        prioridad,
        slaHoras,
        direccion,
        ubicacionDetalles,
        claveCatastral,
        latitud,
        longitud,
        descripcion,
        metadata,
        fechaCreacion,
        fechaAsignacion,
        fechaInicioCampo,
        fechaCompletada,
        diasEnProceso,
        horasTotalesProceso,
        cumpleSla,
        horasRestantesSla,
        inspectorNombre,
        nombreAsignador,
        nombreCompletador,
        creadorNombre,
        idCliente,
        clienteNombre,
        clienteTelefono,
        clienteEmail,
        personalAsignado,
        materiales,
        costosAdicionales,
        adjuntos,
        observaciones,
        costoTotalMateriales,
        costoTotalAdicionales,
        costoTotalOrden,
        idInspeccion,
        checklistAprobado,
        observacionesChecklist,
        idControl,
        calidadAprobada,
        comentariosCalidad,
        idEncuesta,
        calificacionSatisfaccion,
        comentariosSatisfaccion,
      ];

  // Helper getters
  String? get nombreCliente => clienteNombre;
  String? get identificacionCliente => metadata?['identificacion']?.toString();
  String? get telefonoCliente => clienteTelefono;
  String? get emailCliente => clienteEmail;
  String? get numeroMedidor => acometidaNumeroMedidor;
  String? get barrio => ubicacionDetalles;
  String? get cuentaContrato => metadata?['cuentaContrato']?.toString();
  List<AssignedWorkerEntity> get trabajadoresAsignados => personalAsignado;
  String? get tipoOrigen => origen;

  QualityControlInfo? get controlCalidad => idControl != null
      ? QualityControlInfo(
          idControl: idControl,
          aprobado: calidadAprobada ?? true,
          comentarios: comentariosCalidad,
          auditor: inspectorNombre,
        )
      : null;

  SurveyInfo? get encuestaSatisfaccion => idEncuesta != null
      ? SurveyInfo(
          idEncuesta: idEncuesta,
          calificacion: calificacionSatisfaccion ?? 5,
          comentarios: comentariosSatisfaccion,
        )
      : null;
}

class QualityControlInfo {
  final String? idControl;
  final bool aprobado;
  final String? comentarios;
  final String? auditor;
  final String? fechaControl;

  const QualityControlInfo({
    this.idControl,
    required this.aprobado,
    this.comentarios,
    this.auditor,
    this.fechaControl,
  });
}

class SurveyInfo {
  final String? idEncuesta;
  final int calificacion;
  final String? comentarios;
  final String? fechaEncuesta;

  const SurveyInfo({
    this.idEncuesta,
    required this.calificacion,
    this.comentarios,
    this.fechaEncuesta,
  });
}
