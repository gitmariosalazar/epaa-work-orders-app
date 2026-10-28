// features/dashboard/domain/entities/quality_sla_dashboard_entities.dart

import 'package:equatable/equatable.dart';

/// Monitor de semáforo de SLA por orden activa (4.1).
class SlaMonitorItemEntity extends Equatable {
  final String codigoOrden;
  final String tipoTrabajo;
  final String departamento;
  final String prioridad;
  final int slaHoras;
  final String fechaCreacion;
  final String tecnicoAsignado;
  final double horasTranscurridas;
  final double horasHolguraSla;
  final String estadoSlaSemaforo;

  const SlaMonitorItemEntity({
    required this.codigoOrden,
    required this.tipoTrabajo,
    required this.departamento,
    required this.prioridad,
    required this.slaHoras,
    required this.fechaCreacion,
    required this.tecnicoAsignado,
    required this.horasTranscurridas,
    required this.horasHolguraSla,
    required this.estadoSlaSemaforo,
  });

  @override
  List<Object?> get props => [
    codigoOrden,
    tipoTrabajo,
    departamento,
    prioridad,
    slaHoras,
    fechaCreacion,
    tecnicoAsignado,
    horasTranscurridas,
    horasHolguraSla,
    estadoSlaSemaforo,
  ];
}

/// Indicadores de control de calidad y pre-inspecciones (4.2).
class QualityIndicatorItemEntity extends Equatable {
  final String departamento;
  final String tipoTrabajo;
  final int totalOrdenesInspeccionadas;
  final int totalInspeccionesPreparacion;
  final int preinspeccionesAprobadas;
  final int preinspeccionesRechazadas;
  final double? pctAprobacionPreinspeccion;
  final int totalControlesCalidad;
  final int trabajosCalidadAprobados;
  final int trabajosCalidadRechazadosRetrabajo;
  final double? pctAprobacionCalidadFinal;

  const QualityIndicatorItemEntity({
    required this.departamento,
    required this.tipoTrabajo,
    required this.totalOrdenesInspeccionadas,
    required this.totalInspeccionesPreparacion,
    required this.preinspeccionesAprobadas,
    required this.preinspeccionesRechazadas,
    this.pctAprobacionPreinspeccion,
    required this.totalControlesCalidad,
    required this.trabajosCalidadAprobados,
    required this.trabajosCalidadRechazadosRetrabajo,
    this.pctAprobacionCalidadFinal,
  });

  @override
  List<Object?> get props => [
    departamento,
    tipoTrabajo,
    totalOrdenesInspeccionadas,
    totalInspeccionesPreparacion,
    preinspeccionesAprobadas,
    preinspeccionesRechazadas,
    pctAprobacionPreinspeccion,
    totalControlesCalidad,
    trabajosCalidadAprobados,
    trabajosCalidadRechazadosRetrabajo,
    pctAprobacionCalidadFinal,
  ];
}

/// Registro de auditoría de escalamiento a supervisores (4.3).
class EscalationAuditItemEntity extends Equatable {
  final String codigoOrden;
  final String tipoTrabajo;
  final String departamento;
  final String estadoActual;
  final String fechaCreacion;
  final String? tecnicoQueEscalo;
  final String? motivoEscalamiento;

  const EscalationAuditItemEntity({
    required this.codigoOrden,
    required this.tipoTrabajo,
    required this.departamento,
    required this.estadoActual,
    required this.fechaCreacion,
    this.tecnicoQueEscalo,
    this.motivoEscalamiento,
  });

  @override
  List<Object?> get props => [
    codigoOrden,
    tipoTrabajo,
    departamento,
    estadoActual,
    fechaCreacion,
    tecnicoQueEscalo,
    motivoEscalamiento,
  ];
}
