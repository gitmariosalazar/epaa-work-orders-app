// features/dashboard/domain/entities/incident_vs_work_order_entities.dart

import 'package:equatable/equatable.dart';

/// Resumen ejecutivo del embudo de conversión de incidentes/reportes a órdenes de trabajo (1.1).
class FunnelSummaryEntity extends Equatable {
  final int totalReportesIngresados;
  final int reportesEnTriajeSinOt;
  final int reportesConOrdenTrabajo;
  final double? pctTasaConversionAOt;
  final int otPendientesAsignar;
  final int otAsignadasACuadrilla;
  final int otEnProcesoEjecucion;
  final int otEnEsperaPausadas;
  final int otCompletadasResueltas;
  final int otCanceladasOFalsosReportes;
  final int totalCargaActivaPendiente;
  final double? pctTasaResolucionGlobal;
  final double? horasPromedioTriajeACreacionOt;
  final double? horasPromedioAsignacionTecnico;
  final double? horasPromedioEjecucionCampo;
  final double? horasPromedioCicloCompletoResolucion;

  const FunnelSummaryEntity({
    required this.totalReportesIngresados,
    required this.reportesEnTriajeSinOt,
    required this.reportesConOrdenTrabajo,
    this.pctTasaConversionAOt,
    required this.otPendientesAsignar,
    required this.otAsignadasACuadrilla,
    required this.otEnProcesoEjecucion,
    required this.otEnEsperaPausadas,
    required this.otCompletadasResueltas,
    required this.otCanceladasOFalsosReportes,
    required this.totalCargaActivaPendiente,
    this.pctTasaResolucionGlobal,
    this.horasPromedioTriajeACreacionOt,
    this.horasPromedioAsignacionTecnico,
    this.horasPromedioEjecucionCampo,
    this.horasPromedioCicloCompletoResolucion,
  });

  static const empty = FunnelSummaryEntity(
    totalReportesIngresados: 0,
    reportesEnTriajeSinOt: 0,
    reportesConOrdenTrabajo: 0,
    pctTasaConversionAOt: 0,
    otPendientesAsignar: 0,
    otAsignadasACuadrilla: 0,
    otEnProcesoEjecucion: 0,
    otEnEsperaPausadas: 0,
    otCompletadasResueltas: 0,
    otCanceladasOFalsosReportes: 0,
    totalCargaActivaPendiente: 0,
    pctTasaResolucionGlobal: 0,
    horasPromedioTriajeACreacionOt: null,
    horasPromedioAsignacionTecnico: null,
    horasPromedioEjecucionCampo: null,
    horasPromedioCicloCompletoResolucion: null,
  );

  @override
  List<Object?> get props => [
    totalReportesIngresados,
    reportesEnTriajeSinOt,
    reportesConOrdenTrabajo,
    pctTasaConversionAOt,
    otPendientesAsignar,
    otAsignadasACuadrilla,
    otEnProcesoEjecucion,
    otEnEsperaPausadas,
    otCompletadasResueltas,
    otCanceladasOFalsosReportes,
    totalCargaActivaPendiente,
    pctTasaResolucionGlobal,
    horasPromedioTriajeACreacionOt,
    horasPromedioAsignacionTecnico,
    horasPromedioEjecucionCampo,
    horasPromedioCicloCompletoResolucion,
  ];
}

/// Elemento de la matriz cruzada de estado del incidente vs estado de la OT (1.2).
class StateMatrixItemEntity extends Equatable {
  final String estadoIncidente;
  final String estadoOrdenTrabajo;
  final String nombreEstadoOt;
  final int cantidadReportes;
  final double porcentajeDelTotalReportes;
  final double? diasPromedioAbierto;
  final int criticosEnEstaEtapa;
  final String diagnosticoOperativo;

  const StateMatrixItemEntity({
    required this.estadoIncidente,
    required this.estadoOrdenTrabajo,
    required this.nombreEstadoOt,
    required this.cantidadReportes,
    required this.porcentajeDelTotalReportes,
    this.diasPromedioAbierto,
    required this.criticosEnEstaEtapa,
    required this.diagnosticoOperativo,
  });

  @override
  List<Object?> get props => [
    estadoIncidente,
    estadoOrdenTrabajo,
    nombreEstadoOt,
    cantidadReportes,
    porcentajeDelTotalReportes,
    diasPromedioAbierto,
    criticosEnEstaEtapa,
    diagnosticoOperativo,
  ];
}

/// Rendimiento y tasa de conversión por canal de origen del reporte (1.3).
class OriginChannelItemEntity extends Equatable {
  final String canalOrigen;
  final int totalReportes;
  final int conOrdenTrabajo;
  final double? tasaConversionOtPct;
  final int asignadosATecnico;
  final int enProcesoCampo;
  final int totalResueltos;
  final double? tasaExitoResolucionPct;
  final int descartadosFalsos;
  final double? tasaDescartePct;
  final double? horasPromedioResolucion;

  const OriginChannelItemEntity({
    required this.canalOrigen,
    required this.totalReportes,
    required this.conOrdenTrabajo,
    this.tasaConversionOtPct,
    required this.asignadosATecnico,
    required this.enProcesoCampo,
    required this.totalResueltos,
    this.tasaExitoResolucionPct,
    required this.descartadosFalsos,
    this.tasaDescartePct,
    this.horasPromedioResolucion,
  });

  @override
  List<Object?> get props => [
    canalOrigen,
    totalReportes,
    conOrdenTrabajo,
    tasaConversionOtPct,
    asignadosATecnico,
    enProcesoCampo,
    totalResueltos,
    tasaExitoResolucionPct,
    descartadosFalsos,
    tasaDescartePct,
    horasPromedioResolucion,
  ];
}

/// Desglose por categoría/tipo de problema vs departamento ejecutor (1.4).
class CategoryDepartmentItemEntity extends Equatable {
  final String categoriaProblema;
  final String tipoProblema;
  final String? prioridadSugerida;
  final String departamentoResponsable;
  final int totalIncidentes;
  final int totalOtsCreadas;
  final int otsAsignadasActivas;
  final int otsEnProcesoCampo;
  final int totalCompletados;
  final double? pctCumplimiento;
  final double costoReparacionAcumulado;
  final double? diasPromedioAtencion;

  const CategoryDepartmentItemEntity({
    required this.categoriaProblema,
    required this.tipoProblema,
    this.prioridadSugerida,
    required this.departamentoResponsable,
    required this.totalIncidentes,
    required this.totalOtsCreadas,
    required this.otsAsignadasActivas,
    required this.otsEnProcesoCampo,
    required this.totalCompletados,
    this.pctCumplimiento,
    required this.costoReparacionAcumulado,
    this.diasPromedioAtencion,
  });

  @override
  List<Object?> get props => [
    categoriaProblema,
    tipoProblema,
    prioridadSugerida,
    departamentoResponsable,
    totalIncidentes,
    totalOtsCreadas,
    otsAsignadasActivas,
    otsEnProcesoCampo,
    totalCompletados,
    pctCumplimiento,
    costoReparacionAcumulado,
    diasPromedioAtencion,
  ];
}

/// Registro de desfase entre estado del incidente y de la OT (1.5).
class SyncDiscrepancyItemEntity extends Equatable {
  final String codigoIncidente;
  final String codigoOrden;
  final String estadoIncidente;
  final String estadoOt;
  final String fechaReporte;
  final String? fechaCompletadaOt;
  final String? fechaAsignacionOt;
  final String tipoDesfase;
  final String tecnicoAsignado;

  const SyncDiscrepancyItemEntity({
    required this.codigoIncidente,
    required this.codigoOrden,
    required this.estadoIncidente,
    required this.estadoOt,
    required this.fechaReporte,
    this.fechaCompletadaOt,
    this.fechaAsignacionOt,
    required this.tipoDesfase,
    required this.tecnicoAsignado,
  });

  @override
  List<Object?> get props => [
    codigoIncidente,
    codigoOrden,
    estadoIncidente,
    estadoOt,
    fechaReporte,
    fechaCompletadaOt,
    fechaAsignacionOt,
    tipoDesfase,
    tecnicoAsignado,
  ];
}

/// Fila para la tabla de control de despacho con semáforo SLA (1.6).
class DispatchControlItemEntity extends Equatable {
  final String codigoIncidente;
  final String fechaReporte;
  final String? acometidaId;
  final String? direccionReferencia;
  final String origenReporte;
  final String prioridadReporte;
  final String estadoReporte;
  final String? codigoOrden;
  final String estadoOt;
  final String nombreEstadoOt;
  final String? tipoTrabajo;
  final String tecnicoResponsable;
  final String? fechaAsignacion;
  final String? fechaInicioCampo;
  final String? fechaCompletada;
  final int? slaHoras;
  final double horasDesdeReporte;
  final String semaforoSla;

  const DispatchControlItemEntity({
    required this.codigoIncidente,
    required this.fechaReporte,
    this.acometidaId,
    this.direccionReferencia,
    required this.origenReporte,
    required this.prioridadReporte,
    required this.estadoReporte,
    this.codigoOrden,
    required this.estadoOt,
    required this.nombreEstadoOt,
    this.tipoTrabajo,
    required this.tecnicoResponsable,
    this.fechaAsignacion,
    this.fechaInicioCampo,
    this.fechaCompletada,
    this.slaHoras,
    required this.horasDesdeReporte,
    required this.semaforoSla,
  });

  @override
  List<Object?> get props => [
    codigoIncidente,
    fechaReporte,
    acometidaId,
    direccionReferencia,
    origenReporte,
    prioridadReporte,
    estadoReporte,
    codigoOrden,
    estadoOt,
    nombreEstadoOt,
    tipoTrabajo,
    tecnicoResponsable,
    fechaAsignacion,
    fechaInicioCampo,
    fechaCompletada,
    slaHoras,
    horasDesdeReporte,
    semaforoSla,
  ];
}
