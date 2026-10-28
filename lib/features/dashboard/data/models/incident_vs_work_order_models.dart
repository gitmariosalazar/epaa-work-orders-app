// features/dashboard/data/models/incident_vs_work_order_models.dart

import 'package:clean_architecture/features/dashboard/data/models/dashboard_parsing_helpers.dart';
import 'package:clean_architecture/features/dashboard/domain/entities/incident_vs_work_order_entities.dart';

class FunnelSummaryModel extends FunnelSummaryEntity {
  const FunnelSummaryModel({
    required super.totalReportesIngresados,
    required super.reportesEnTriajeSinOt,
    required super.reportesConOrdenTrabajo,
    super.pctTasaConversionAOt,
    required super.otPendientesAsignar,
    required super.otAsignadasACuadrilla,
    required super.otEnProcesoEjecucion,
    required super.otEnEsperaPausadas,
    required super.otCompletadasResueltas,
    required super.otCanceladasOFalsosReportes,
    required super.totalCargaActivaPendiente,
    super.pctTasaResolucionGlobal,
    super.horasPromedioTriajeACreacionOt,
    super.horasPromedioAsignacionTecnico,
    super.horasPromedioEjecucionCampo,
    super.horasPromedioCicloCompletoResolucion,
  });

  factory FunnelSummaryModel.fromJson(Map<String, dynamic> json) =>
      FunnelSummaryModel(
        totalReportesIngresados: parseToInt(
          json['totalReportesIngresados'] ?? json['total_reportes'],
        ),
        reportesEnTriajeSinOt: parseToInt(
          json['reportesEnTriajeSinOt'] ?? json['reportes_sin_ot'],
        ),
        reportesConOrdenTrabajo: parseToInt(
          json['reportesConOrdenTrabajo'] ?? json['reportes_con_ot'],
        ),
        pctTasaConversionAOt: parseToDoubleOrNull(
          json['pctTasaConversionAOt'] ?? json['tasa_conversion_ot_pct'],
        ),
        otPendientesAsignar: parseToInt(
          json['otPendientesAsignar'] ?? json['ot_pendientes_asignacion'],
        ),
        otAsignadasACuadrilla: parseToInt(
          json['otAsignadasACuadrilla'] ?? json['ot_asignadas_a_cuadrilla'],
        ),
        otEnProcesoEjecucion: parseToInt(
          json['otEnProcesoEjecucion'] ?? json['ot_en_proceso_campo'],
        ),
        otEnEsperaPausadas: parseToInt(
          json['otEnEsperaPausadas'] ?? json['ot_en_espera'],
        ),
        otCompletadasResueltas: parseToInt(
          json['otCompletadasResueltas'] ?? json['ot_completadas_resueltas'],
        ),
        otCanceladasOFalsosReportes: parseToInt(
          json['otCanceladasOFalsosReportes'] ??
              json['ot_canceladas_falsos_reportes'],
        ),
        totalCargaActivaPendiente: parseToInt(
          json['totalCargaActivaPendiente'] ?? json['total_carga_activa'],
        ),
        pctTasaResolucionGlobal: parseToDoubleOrNull(
          json['pctTasaResolucionGlobal'] ?? json['tasa_resolucion_global_pct'],
        ),
        horasPromedioTriajeACreacionOt: parseToDoubleOrNull(
          json['horasPromedioTriajeACreacionOt'] ??
              json['horas_promedio_triaje_creacion_ot'],
        ),
        horasPromedioAsignacionTecnico: parseToDoubleOrNull(
          json['horasPromedioAsignacionTecnico'] ??
              json['horas_promedio_asignacion_tecnico'],
        ),
        horasPromedioEjecucionCampo: parseToDoubleOrNull(
          json['horasPromedioEjecucionCampo'] ??
              json['horas_promedio_ejecucion_campo'],
        ),
        horasPromedioCicloCompletoResolucion: parseToDoubleOrNull(
          json['horasPromedioCicloCompletoResolucion'] ??
              json['horas_promedio_ciclo_resolucion'],
        ),
      );

  FunnelSummaryEntity toEntity() => this;
}

class StateMatrixItemModel extends StateMatrixItemEntity {
  const StateMatrixItemModel({
    required super.estadoIncidente,
    required super.estadoOrdenTrabajo,
    required super.nombreEstadoOt,
    required super.cantidadReportes,
    required super.porcentajeDelTotalReportes,
    super.diasPromedioAbierto,
    required super.criticosEnEstaEtapa,
    required super.diagnosticoOperativo,
  });

  factory StateMatrixItemModel.fromJson(Map<String, dynamic> json) =>
      StateMatrixItemModel(
        estadoIncidente: parseToStr(json['estadoIncidente']),
        estadoOrdenTrabajo: parseToStr(json['estadoOrdenTrabajo']),
        nombreEstadoOt: parseToStr(json['nombreEstadoOt']),
        cantidadReportes: parseToInt(json['cantidadReportes']),
        porcentajeDelTotalReportes: parseToDouble(
          json['porcentajeDelTotalReportes'],
        ),
        diasPromedioAbierto: parseToDoubleOrNull(json['diasPromedioAbierto']),
        criticosEnEstaEtapa: parseToInt(json['criticosEnEstaEtapa']),
        diagnosticoOperativo: parseToStr(json['diagnosticoOperativo']),
      );

  StateMatrixItemEntity toEntity() => this;
}

class OriginChannelItemModel extends OriginChannelItemEntity {
  const OriginChannelItemModel({
    required super.canalOrigen,
    required super.totalReportes,
    required super.conOrdenTrabajo,
    super.tasaConversionOtPct,
    required super.asignadosATecnico,
    required super.enProcesoCampo,
    required super.totalResueltos,
    super.tasaExitoResolucionPct,
    required super.descartadosFalsos,
    super.tasaDescartePct,
    super.horasPromedioResolucion,
  });

  factory OriginChannelItemModel.fromJson(Map<String, dynamic> json) =>
      OriginChannelItemModel(
        canalOrigen: parseToStr(json['canalOrigen']),
        totalReportes: parseToInt(json['totalReportes']),
        conOrdenTrabajo: parseToInt(json['conOrdenTrabajo']),
        tasaConversionOtPct: parseToDoubleOrNull(json['tasaConversionOtPct']),
        asignadosATecnico: parseToInt(json['asignadosATecnico']),
        enProcesoCampo: parseToInt(json['enProcesoCampo']),
        totalResueltos: parseToInt(json['totalResueltos']),
        tasaExitoResolucionPct: parseToDoubleOrNull(
          json['tasaExitoResolucionPct'],
        ),
        descartadosFalsos: parseToInt(json['descartadosFalsos']),
        tasaDescartePct: parseToDoubleOrNull(json['tasaDescartePct']),
        horasPromedioResolucion: parseToDoubleOrNull(
          json['horasPromedioResolucion'],
        ),
      );

  OriginChannelItemEntity toEntity() => this;
}

class CategoryDepartmentItemModel extends CategoryDepartmentItemEntity {
  const CategoryDepartmentItemModel({
    required super.categoriaProblema,
    required super.tipoProblema,
    super.prioridadSugerida,
    required super.departamentoResponsable,
    required super.totalIncidentes,
    required super.totalOtsCreadas,
    required super.otsAsignadasActivas,
    required super.otsEnProcesoCampo,
    required super.totalCompletados,
    super.pctCumplimiento,
    required super.costoReparacionAcumulado,
    super.diasPromedioAtencion,
  });

  factory CategoryDepartmentItemModel.fromJson(Map<String, dynamic> json) =>
      CategoryDepartmentItemModel(
        categoriaProblema: parseToStr(json['categoriaProblema']),
        tipoProblema: parseToStr(json['tipoProblema']),
        prioridadSugerida: parseToStrOrNull(json['prioridadSugerida']),
        departamentoResponsable: parseToStr(json['departamentoResponsable']),
        totalIncidentes: parseToInt(json['totalIncidentes']),
        totalOtsCreadas: parseToInt(json['totalOtsCreadas']),
        otsAsignadasActivas: parseToInt(json['otsAsignadasActivas']),
        otsEnProcesoCampo: parseToInt(json['otsEnProcesoCampo']),
        totalCompletados: parseToInt(json['totalCompletados']),
        pctCumplimiento: parseToDoubleOrNull(json['pctCumplimiento']),
        costoReparacionAcumulado: parseToDouble(
          json['costoReparacionAcumulado'],
        ),
        diasPromedioAtencion: parseToDoubleOrNull(
          json['diasPromedioAtencion'],
        ),
      );

  CategoryDepartmentItemEntity toEntity() => this;
}

class SyncDiscrepancyItemModel extends SyncDiscrepancyItemEntity {
  const SyncDiscrepancyItemModel({
    required super.codigoIncidente,
    required super.codigoOrden,
    required super.estadoIncidente,
    required super.estadoOt,
    required super.fechaReporte,
    super.fechaCompletadaOt,
    super.fechaAsignacionOt,
    required super.tipoDesfase,
    required super.tecnicoAsignado,
  });

  factory SyncDiscrepancyItemModel.fromJson(Map<String, dynamic> json) =>
      SyncDiscrepancyItemModel(
        codigoIncidente: parseToStr(json['codigoIncidente']),
        codigoOrden: parseToStr(json['codigoOrden']),
        estadoIncidente: parseToStr(json['estadoIncidente']),
        estadoOt: parseToStr(json['estadoOt']),
        fechaReporte: parseToStr(json['fechaReporte']),
        fechaCompletadaOt: parseToStrOrNull(json['fechaCompletadaOt']),
        fechaAsignacionOt: parseToStrOrNull(json['fechaAsignacionOt']),
        tipoDesfase: parseToStr(json['tipoDesfase']),
        tecnicoAsignado: parseToStr(json['tecnicoAsignado']),
      );

  SyncDiscrepancyItemEntity toEntity() => this;
}

class DispatchControlItemModel extends DispatchControlItemEntity {
  const DispatchControlItemModel({
    required super.codigoIncidente,
    required super.fechaReporte,
    super.acometidaId,
    super.direccionReferencia,
    required super.origenReporte,
    required super.prioridadReporte,
    required super.estadoReporte,
    super.codigoOrden,
    required super.estadoOt,
    required super.nombreEstadoOt,
    super.tipoTrabajo,
    required super.tecnicoResponsable,
    super.fechaAsignacion,
    super.fechaInicioCampo,
    super.fechaCompletada,
    super.slaHoras,
    required super.horasDesdeReporte,
    required super.semaforoSla,
  });

  factory DispatchControlItemModel.fromJson(Map<String, dynamic> json) =>
      DispatchControlItemModel(
        codigoIncidente: parseToStr(json['codigoIncidente']),
        fechaReporte: parseToStr(json['fechaReporte']),
        acometidaId: parseToStrOrNull(json['acometidaId']),
        direccionReferencia: parseToStrOrNull(json['direccionReferencia']),
        origenReporte: parseToStr(json['origenReporte']),
        prioridadReporte: parseToStr(json['prioridadReporte']),
        estadoReporte: parseToStr(json['estadoReporte']),
        codigoOrden: parseToStrOrNull(json['codigoOrden']),
        estadoOt: parseToStr(json['estadoOt']),
        nombreEstadoOt: parseToStr(json['nombreEstadoOt']),
        tipoTrabajo: parseToStrOrNull(json['tipoTrabajo']),
        tecnicoResponsable: parseToStr(json['tecnicoResponsable']),
        fechaAsignacion: parseToStrOrNull(json['fechaAsignacion']),
        fechaInicioCampo: parseToStrOrNull(json['fechaInicioCampo']),
        fechaCompletada: parseToStrOrNull(json['fechaCompletada']),
        slaHoras: parseToIntOrNull(json['slaHoras']),
        horasDesdeReporte: parseToDouble(json['horasDesdeReporte']),
        semaforoSla: parseToStr(json['semaforoSla']),
      );

  DispatchControlItemEntity toEntity() => this;
}
