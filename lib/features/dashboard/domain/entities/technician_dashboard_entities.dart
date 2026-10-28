// features/dashboard/domain/entities/technician_dashboard_entities.dart

import 'package:equatable/equatable.dart';

/// Carga de trabajo y métricas de desempeño por técnico de cuadrilla (3.1).
class TechnicianPerformanceItemEntity extends Equatable {
  final String idTecnico;
  final String nombreTecnico;
  final String? cedula;
  final String? telefonoInterno;
  final int totalOrdenesAsignadasHistoricas;
  final int ordenesPorIniciar;
  final int ordenesEnEjecucionHoy;
  final int ordenesEnPausa;
  final int totalBacklogActivo;
  final int totalCompletadas;
  final int completadasEsteMes;
  final double? tasaCumplimientoSlaPct;
  final double? horasPromedioEnCampo;

  const TechnicianPerformanceItemEntity({
    required this.idTecnico,
    required this.nombreTecnico,
    this.cedula,
    this.telefonoInterno,
    required this.totalOrdenesAsignadasHistoricas,
    required this.ordenesPorIniciar,
    required this.ordenesEnEjecucionHoy,
    required this.ordenesEnPausa,
    required this.totalBacklogActivo,
    required this.totalCompletadas,
    required this.completadasEsteMes,
    this.tasaCumplimientoSlaPct,
    this.horasPromedioEnCampo,
  });

  @override
  List<Object?> get props => [
    idTecnico,
    nombreTecnico,
    cedula,
    telefonoInterno,
    totalOrdenesAsignadasHistoricas,
    ordenesPorIniciar,
    ordenesEnEjecucionHoy,
    ordenesEnPausa,
    totalBacklogActivo,
    totalCompletadas,
    completadasEsteMes,
    tasaCumplimientoSlaPct,
    horasPromedioEnCampo,
  ];
}

/// Tarea del feed diario del técnico autenticado (3.2).
class TechnicianDailyFeedItemEntity extends Equatable {
  final int idOrdenTrabajo;
  final String codigoOrden;
  final String estado;
  final String nombreEstado;
  final String tipoTrabajo;
  final String prioridad;
  final int slaHoras;
  final String? direccion;
  final String? ubicacionDetalles;
  final String? claveCatastral;
  final String? fechaAsignacion;
  final String? fechaInicioCampo;
  final double? latitud;
  final double? longitud;
  final double horasRestantesSla;
  final bool esOrdenMasPrioritaria;

  const TechnicianDailyFeedItemEntity({
    required this.idOrdenTrabajo,
    required this.codigoOrden,
    required this.estado,
    required this.nombreEstado,
    required this.tipoTrabajo,
    required this.prioridad,
    required this.slaHoras,
    this.direccion,
    this.ubicacionDetalles,
    this.claveCatastral,
    this.fechaAsignacion,
    this.fechaInicioCampo,
    this.latitud,
    this.longitud,
    required this.horasRestantesSla,
    required this.esOrdenMasPrioritaria,
  });

  @override
  List<Object?> get props => [
    idOrdenTrabajo,
    codigoOrden,
    estado,
    nombreEstado,
    tipoTrabajo,
    prioridad,
    slaHoras,
    direccion,
    ubicacionDetalles,
    claveCatastral,
    fechaAsignacion,
    fechaInicioCampo,
    latitud,
    longitud,
    horasRestantesSla,
    esOrdenMasPrioritaria,
  ];
}

/// Composición de cuadrilla y rol por orden de trabajo (3.3).
class CrewAssignmentItemEntity extends Equatable {
  final String codigoOrden;
  final String estadoOt;
  final String tipoTrabajo;
  final String nombreTrabajador;
  final String? cedula;
  final String? rolEnCuadrilla;
  final bool esResponsable;
  final String? fechaAsignacion;

  const CrewAssignmentItemEntity({
    required this.codigoOrden,
    required this.estadoOt,
    required this.tipoTrabajo,
    required this.nombreTrabajador,
    this.cedula,
    this.rolEnCuadrilla,
    required this.esResponsable,
    this.fechaAsignacion,
  });

  @override
  List<Object?> get props => [
    codigoOrden,
    estadoOt,
    tipoTrabajo,
    nombreTrabajador,
    cedula,
    rolEnCuadrilla,
    esResponsable,
    fechaAsignacion,
  ];
}
