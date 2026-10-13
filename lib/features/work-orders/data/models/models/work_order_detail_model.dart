import 'package:clean_architecture/features/work-orders/domain/entities/work_order_detail_entity.dart';

int _parseInt(dynamic value, [int defaultValue = 0]) {
  if (value == null) return defaultValue;
  if (value is int) return value;
  if (value is num) return value.toInt();
  if (value is String) {
    final trimmed = value.trim();
    return int.tryParse(trimmed) ?? double.tryParse(trimmed)?.toInt() ?? defaultValue;
  }
  return defaultValue;
}

int? _parseNullableInt(dynamic value) {
  if (value == null) return null;
  if (value is int) return value;
  if (value is num) return value.toInt();
  if (value is String) {
    final trimmed = value.trim();
    if (trimmed.isEmpty) return null;
    return int.tryParse(trimmed) ?? double.tryParse(trimmed)?.toInt();
  }
  return null;
}

double _parseDouble(dynamic value, [double defaultValue = 0.0]) {
  if (value == null) return defaultValue;
  if (value is double) return value;
  if (value is num) return value.toDouble();
  if (value is String) {
    final trimmed = value.trim();
    return double.tryParse(trimmed) ?? defaultValue;
  }
  return defaultValue;
}

double? _parseNullableDouble(dynamic value) {
  if (value == null) return null;
  if (value is double) return value;
  if (value is num) return value.toDouble();
  if (value is String) {
    final trimmed = value.trim();
    if (trimmed.isEmpty) return null;
    return double.tryParse(trimmed);
  }
  return null;
}

class AssignedWorkerModel {
  final String idAsignacion;
  final String idTrabajador;
  final String nombreTrabajador;
  final String? rol;
  final bool esResponsable;
  final String fechaAsignacion;

  AssignedWorkerModel({
    required this.idAsignacion,
    required this.idTrabajador,
    required this.nombreTrabajador,
    this.rol,
    required this.esResponsable,
    required this.fechaAsignacion,
  });

  factory AssignedWorkerModel.fromJson(Map<String, dynamic> json) {
    return AssignedWorkerModel(
      idAsignacion: (json['idAsignacion'] ?? json['id_asignacion'] ?? '').toString(),
      idTrabajador: (json['idTrabajador'] ?? json['id_trabajador'] ?? json['workerId'] ?? '').toString(),
      nombreTrabajador: (json['nombreTrabajador'] ?? json['nombre_trabajador'] ?? json['workerName'] ?? '').toString(),
      rol: json['rol']?.toString(),
      esResponsable: json['esResponsable'] == true || json['es_responsable'] == true || json['isResponsible'] == true,
      fechaAsignacion: (json['fechaAsignacion'] ?? json['fecha_asignacion'] ?? '').toString(),
    );
  }

  AssignedWorkerEntity toEntity() {
    return AssignedWorkerEntity(
      idAsignacion: idAsignacion,
      idTrabajador: idTrabajador,
      nombreTrabajador: nombreTrabajador,
      rol: rol,
      esResponsable: esResponsable,
      fechaAsignacion: fechaAsignacion,
    );
  }
}

class UsedMaterialModel {
  final String idDetalle;
  final String idMaterial;
  final String? codigoMaterial;
  final String? nombreMaterial;
  final double cantidad;
  final double costoUnitario;
  final double subtotal;

  UsedMaterialModel({
    required this.idDetalle,
    required this.idMaterial,
    this.codigoMaterial,
    this.nombreMaterial,
    required this.cantidad,
    required this.costoUnitario,
    required this.subtotal,
  });

  factory UsedMaterialModel.fromJson(Map<String, dynamic> json) {
    final qty = _parseDouble(json['cantidad'] ?? json['quantity'], 0.0);
    final cost = _parseDouble(json['costoUnitario'] ?? json['costo_unitario'] ?? json['unitCost'], 0.0);
    final sub = json['subtotal'] != null
        ? _parseDouble(json['subtotal'], qty * cost)
        : (qty * cost);

    return UsedMaterialModel(
      idDetalle: (json['idDetalle'] ?? json['id_detalle'] ?? '').toString(),
      idMaterial: (json['idMaterial'] ?? json['id_material'] ?? json['materialId'] ?? '').toString(),
      codigoMaterial: json['codigoMaterial']?.toString() ?? json['codigo_material']?.toString(),
      nombreMaterial: json['nombreMaterial']?.toString() ?? json['nombre_material']?.toString(),
      cantidad: qty,
      costoUnitario: cost,
      subtotal: sub,
    );
  }

  UsedMaterialEntity toEntity() {
    return UsedMaterialEntity(
      idDetalle: idDetalle,
      idMaterial: idMaterial,
      codigoMaterial: codigoMaterial,
      nombreMaterial: nombreMaterial,
      cantidad: cantidad,
      costoUnitario: costoUnitario,
      subtotal: subtotal,
    );
  }
}

class AdditionalCostModel {
  final String idCosto;
  final String concepto;
  final double cantidad;
  final double costoUnitario;
  final double total;

  AdditionalCostModel({
    required this.idCosto,
    required this.concepto,
    required this.cantidad,
    required this.costoUnitario,
    required this.total,
  });

  factory AdditionalCostModel.fromJson(Map<String, dynamic> json) {
    final qty = _parseDouble(json['cantidad'] ?? json['quantity'], 1.0);
    final cost = _parseDouble(json['costoUnitario'] ?? json['costo_unitario'] ?? json['unitCost'], 0.0);
    final tot = json['total'] != null
        ? _parseDouble(json['total'], qty * cost)
        : (qty * cost);

    return AdditionalCostModel(
      idCosto: (json['idCosto'] ?? json['id_costo'] ?? '').toString(),
      concepto: (json['concepto'] ?? '').toString(),
      cantidad: qty,
      costoUnitario: cost,
      total: tot,
    );
  }

  AdditionalCostEntity toEntity() {
    return AdditionalCostEntity(
      idCosto: idCosto,
      concepto: concepto,
      cantidad: cantidad,
      costoUnitario: costoUnitario,
      total: total,
    );
  }
}

class EvidenceAttachmentModel {
  final String idAdjunto;
  final String nombreArchivo;
  final String url;
  final String tipoAdjunto;
  final String? mimeType;
  final String fechaCarga;

  EvidenceAttachmentModel({
    required this.idAdjunto,
    required this.nombreArchivo,
    required this.url,
    required this.tipoAdjunto,
    this.mimeType,
    required this.fechaCarga,
  });

  factory EvidenceAttachmentModel.fromJson(Map<String, dynamic> json) {
    return EvidenceAttachmentModel(
      idAdjunto: (json['idAdjunto'] ?? json['id_adjunto'] ?? '').toString(),
      nombreArchivo: (json['nombreArchivo'] ?? json['nombre_archivo'] ?? json['nombre'] ?? '').toString(),
      url: (json['url'] ?? '').toString(),
      tipoAdjunto: (json['tipoAdjunto'] ?? json['tipo_adjunto'] ?? json['tipo'] ?? 'EVIDENCIA').toString(),
      mimeType: json['mimeType']?.toString() ?? json['mime_type']?.toString(),
      fechaCarga: (json['fechaCarga'] ?? json['fecha_carga'] ?? '').toString(),
    );
  }

  EvidenceAttachmentEntity toEntity() {
    return EvidenceAttachmentEntity(
      idAdjunto: idAdjunto,
      nombreArchivo: nombreArchivo,
      url: url,
      tipoAdjunto: tipoAdjunto,
      mimeType: mimeType,
      fechaCarga: fechaCarga,
    );
  }
}

class LogObservationModel {
  final String idObservacion;
  final String texto;
  final String fecha;
  final String autorId;

  LogObservationModel({
    required this.idObservacion,
    required this.texto,
    required this.fecha,
    required this.autorId,
  });

  factory LogObservationModel.fromJson(Map<String, dynamic> json) {
    return LogObservationModel(
      idObservacion: (json['idObservacion'] ?? json['id_observacion'] ?? '').toString(),
      texto: (json['texto'] ?? json['comentario'] ?? '').toString(),
      fecha: (json['fecha'] ?? '').toString(),
      autorId: (json['autorId'] ?? json['autor_id'] ?? json['usuarioId'] ?? '').toString(),
    );
  }

  LogObservationEntity toEntity() {
    return LogObservationEntity(
      idObservacion: idObservacion,
      texto: texto,
      fecha: fecha,
      autorId: autorId,
    );
  }
}

class WorkOrderDetailModel {
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

  final String tipoTrabajo;
  final String? tipoTrabajoDescripcion;
  final String departamento;
  final String prioridad;
  final int slaHoras;

  final String? direccion;
  final String? ubicacionDetalles;
  final String? claveCatastral;
  final double? latitud;
  final double? longitud;

  final String? descripcion;
  final Map<String, dynamic>? metadata;

  final String fechaCreacion;
  final String? fechaAsignacion;
  final String? fechaInicioCampo;
  final String? fechaCompletada;
  final int diasEnProceso;
  final int horasTotalesProceso;
  final int? horasHastaAsignacion;
  final int? horasEjecucionCampo;

  final bool cumpleSla;
  final int horasRestantesSla;

  final String? inspectorNombre;
  final String? nombreAsignador;
  final String? nombreCompletador;
  final String creadorNombre;

  final String? idCliente;
  final String? clienteNombre;
  final String? clienteTelefono;
  final String? clienteEmail;
  final String? acometidaNumeroMedidor;
  final String? acometidaTarifa;

  final List<AssignedWorkerModel> personalAsignado;
  final List<UsedMaterialModel> materiales;
  final List<AdditionalCostModel> costosAdicionales;
  final List<EvidenceAttachmentModel> adjuntos;
  final List<LogObservationModel> observaciones;

  final double costoTotalMateriales;
  final double costoTotalAdicionales;
  final double costoTotalOrden;

  final String? idInspeccion;
  final bool? checklistAprobado;
  final String? observacionesChecklist;

  final String? idControl;
  final bool? calidadAprobada;
  final String? comentariosCalidad;

  final String? idEncuesta;
  final int? calificacionSatisfaccion;
  final String? comentariosSatisfaccion;

  WorkOrderDetailModel({
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

  factory WorkOrderDetailModel.fromJson(Map<String, dynamic> json) {
    // Normalizar cliente
    String? cNombre;
    String? cTel;
    String? cEmail;

    if (json['person'] is Map) {
      final p = json['person'] as Map<String, dynamic>;
      cNombre = '${p['firstName'] ?? ''} ${p['lastName'] ?? ''}'.trim();
      if (p['phones'] is List && (p['phones'] as List).isNotEmpty) {
        cTel = (p['phones'] as List).first['numero']?.toString();
      }
      if (p['emails'] is List && (p['emails'] as List).isNotEmpty) {
        cEmail = (p['emails'] as List).first['correo']?.toString();
      }
    } else if (json['company'] is Map) {
      final c = json['company'] as Map<String, dynamic>;
      cNombre = c['businessName']?.toString() ?? c['commercialName']?.toString();
      if (c['phones'] is List && (c['phones'] as List).isNotEmpty) {
        cTel = (c['phones'] as List).first['numero']?.toString();
      }
      if (c['emails'] is List && (c['emails'] as List).isNotEmpty) {
        cEmail = (c['emails'] as List).first['correo']?.toString();
      }
    }

    // Normalizar acometida
    String? meterNum;
    String? rate;
    if (json['acometida'] is Map) {
      final ac = json['acometida'] as Map<String, dynamic>;
      meterNum = ac['meter_number']?.toString();
      rate = ac['rate_name']?.toString();
    }

    final workers = (json['personalAsignado'] as List?)
            ?.map((e) => AssignedWorkerModel.fromJson(Map<String, dynamic>.from(e as Map)))
            .toList() ??
        [];

    final mats = (json['materiales'] as List?)
            ?.map((e) => UsedMaterialModel.fromJson(Map<String, dynamic>.from(e as Map)))
            .toList() ??
        [];

    final costs = (json['costosAdicionales'] as List?)
            ?.map((e) => AdditionalCostModel.fromJson(Map<String, dynamic>.from(e as Map)))
            .toList() ??
        [];

    final atts = (json['adjuntos'] as List?)
            ?.map((e) => EvidenceAttachmentModel.fromJson(Map<String, dynamic>.from(e as Map)))
            .toList() ??
        [];

    final obs = (json['observaciones'] as List?)
            ?.map((e) => LogObservationModel.fromJson(Map<String, dynamic>.from(e as Map)))
            .toList() ??
        [];

    return WorkOrderDetailModel(
      idOrdenTrabajo: (json['idOrdenTrabajo'] ?? json['id_orden_trabajo'] ?? json['workOrderId'] ?? '').toString(),
      codigoOrden: (json['codigoOrden'] ?? json['codigo_orden'] ?? json['orderCode'] ?? '').toString(),
      numeroSecuencial: _parseInt(json['numeroSecuencial'] ?? json['numero_secuencial']),
      version: _parseInt(json['version'], 1),
      estado: (json['estado'] ?? json['status'] ?? 'NOTIFICADA').toString(),
      estadoLabel: (json['estadoLabel'] ?? json['estado'] ?? 'Notificada').toString(),
      origen: (json['origen'] ?? 'SOLICITUD').toString(),
      origenLabel: (json['origenLabel'] ?? json['origen'] ?? 'Solicitud').toString(),
      codigoEntidadOrigen: json['codigoEntidadOrigen']?.toString(),
      idEntidadOrigen: (json['idEntidadOrigen'] ?? json['id_entidad_origen'])?.toString(),
      tipoTrabajo: (json['tipoTrabajo'] ?? json['workTypeName'] ?? 'Mantenimiento').toString(),
      tipoTrabajoDescripcion: json['tipoTrabajoDescripcion']?.toString(),
      departamento: (json['departamento'] ?? '').toString(),
      prioridad: (json['prioridad'] ?? 'Media').toString(),
      slaHoras: _parseInt(json['slaHoras'] ?? json['sla_horas'], 48),
      direccion: json['direccion']?.toString() ?? json['location']?.toString(),
      ubicacionDetalles: json['ubicacionDetalles']?.toString(),
      claveCatastral: json['claveCatastral']?.toString() ?? json['cadastralKey']?.toString(),
      latitud: _parseNullableDouble(json['latitud'] ?? json['latitude']),
      longitud: _parseNullableDouble(json['longitud'] ?? json['longitude']),
      descripcion: json['descripcion']?.toString() ?? json['description']?.toString(),
      metadata: json['metadata'] is Map ? Map<String, dynamic>.from(json['metadata'] as Map) : null,
      fechaCreacion: (json['fechaCreacion'] ?? json['createdAt'] ?? '').toString(),
      fechaAsignacion: json['fechaAsignacion']?.toString(),
      fechaInicioCampo: json['fechaInicioCampo']?.toString(),
      fechaCompletada: json['fechaCompletada']?.toString(),
      diasEnProceso: _parseInt(json['diasEnProceso'] ?? json['dias_en_proceso']),
      horasTotalesProceso: _parseInt(json['horasTotalesProceso'] ?? json['horas_totales_proceso']),
      horasHastaAsignacion: _parseNullableInt(json['horasHastaAsignacion'] ?? json['horas_hasta_asignacion']),
      horasEjecucionCampo: _parseNullableInt(json['horasEjecucionCampo'] ?? json['horas_ejecucion_campo']),
      cumpleSla: json['cumpleSla'] != false,
      horasRestantesSla: _parseInt(json['horasRestantesSla'] ?? json['horas_restantes_sla']),
      inspectorNombre: json['inspectorNombre']?.toString(),
      nombreAsignador: json['nombreAsignador']?.toString(),
      nombreCompletador: json['nombreCompletador']?.toString(),
      creadorNombre: (json['creadorNombre'] ?? json['creadorUsername'] ?? '').toString(),
      idCliente: json['idCliente']?.toString() ?? json['clientId']?.toString(),
      clienteNombre: cNombre,
      clienteTelefono: cTel,
      clienteEmail: cEmail,
      acometidaNumeroMedidor: meterNum,
      acometidaTarifa: rate,
      personalAsignado: workers,
      materiales: mats,
      costosAdicionales: costs,
      adjuntos: atts,
      observaciones: obs,
      costoTotalMateriales: _parseDouble(json['costoTotalMateriales'] ?? json['costo_total_materiales']),
      costoTotalAdicionales: _parseDouble(json['costoTotalAdicionales'] ?? json['costo_total_adicionales']),
      costoTotalOrden: _parseDouble(json['costoTotalOrden'] ?? json['costo_total_orden']),
      idInspeccion: json['idInspeccion']?.toString(),
      checklistAprobado: json['checklistAprobado'] as bool?,
      observacionesChecklist: json['observacionesChecklist']?.toString(),
      idControl: json['idControl']?.toString(),
      calidadAprobada: json['calidadAprobada'] as bool?,
      comentariosCalidad: json['comentariosCalidad']?.toString(),
      idEncuesta: json['idEncuesta']?.toString(),
      calificacionSatisfaccion: _parseNullableInt(json['calificacionSatisfaccion'] ?? json['calificacion_satisfaccion'] ?? json['rating']),
      comentariosSatisfaccion: json['comentariosSatisfaccion']?.toString(),
    );
  }

  WorkOrderDetailEntity toEntity() {
    return WorkOrderDetailEntity(
      idOrdenTrabajo: idOrdenTrabajo,
      codigoOrden: codigoOrden,
      numeroSecuencial: numeroSecuencial,
      version: version,
      estado: estado,
      estadoLabel: estadoLabel,
      origen: origen,
      origenLabel: origenLabel,
      codigoEntidadOrigen: codigoEntidadOrigen,
      idEntidadOrigen: idEntidadOrigen,
      tipoTrabajo: tipoTrabajo,
      tipoTrabajoDescripcion: tipoTrabajoDescripcion,
      departamento: departamento,
      prioridad: prioridad,
      slaHoras: slaHoras,
      direccion: direccion,
      ubicacionDetalles: ubicacionDetalles,
      claveCatastral: claveCatastral,
      latitud: latitud,
      longitud: longitud,
      descripcion: descripcion,
      metadata: metadata,
      fechaCreacion: fechaCreacion,
      fechaAsignacion: fechaAsignacion,
      fechaInicioCampo: fechaInicioCampo,
      fechaCompletada: fechaCompletada,
      diasEnProceso: diasEnProceso,
      horasTotalesProceso: horasTotalesProceso,
      horasHastaAsignacion: horasHastaAsignacion,
      horasEjecucionCampo: horasEjecucionCampo,
      cumpleSla: cumpleSla,
      horasRestantesSla: horasRestantesSla,
      inspectorNombre: inspectorNombre,
      nombreAsignador: nombreAsignador,
      nombreCompletador: nombreCompletador,
      creadorNombre: creadorNombre,
      idCliente: idCliente,
      clienteNombre: clienteNombre,
      clienteTelefono: clienteTelefono,
      clienteEmail: clienteEmail,
      acometidaNumeroMedidor: acometidaNumeroMedidor,
      acometidaTarifa: acometidaTarifa,
      personalAsignado: personalAsignado.map((m) => m.toEntity()).toList(),
      materiales: materiales.map((m) => m.toEntity()).toList(),
      costosAdicionales: costosAdicionales.map((m) => m.toEntity()).toList(),
      adjuntos: adjuntos.map((m) => m.toEntity()).toList(),
      observaciones: observaciones.map((m) => m.toEntity()).toList(),
      costoTotalMateriales: costoTotalMateriales,
      costoTotalAdicionales: costoTotalAdicionales,
      costoTotalOrden: costoTotalOrden,
      idInspeccion: idInspeccion,
      checklistAprobado: checklistAprobado,
      observacionesChecklist: observacionesChecklist,
      idControl: idControl,
      calidadAprobada: calidadAprobada,
      comentariosCalidad: comentariosCalidad,
      idEncuesta: idEncuesta,
      calificacionSatisfaccion: calificacionSatisfaccion,
      comentariosSatisfaccion: comentariosSatisfaccion,
    );
  }
}
