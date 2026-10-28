// features/dashboard/data/models/quality_sla_dashboard_models.dart

import 'package:clean_architecture/features/dashboard/data/models/dashboard_parsing_helpers.dart';
import 'package:clean_architecture/features/dashboard/domain/entities/quality_sla_dashboard_entities.dart';

class SlaMonitorItemModel extends SlaMonitorItemEntity {
  const SlaMonitorItemModel({
    required super.codigoOrden,
    required super.tipoTrabajo,
    required super.departamento,
    required super.prioridad,
    required super.slaHoras,
    required super.fechaCreacion,
    required super.tecnicoAsignado,
    required super.horasTranscurridas,
    required super.horasHolguraSla,
    required super.estadoSlaSemaforo,
  });

  factory SlaMonitorItemModel.fromJson(Map<String, dynamic> json) =>
      SlaMonitorItemModel(
        codigoOrden: parseToStr(json['codigoOrden']),
        tipoTrabajo: parseToStr(json['tipoTrabajo']),
        departamento: parseToStr(json['departamento']),
        prioridad: parseToStr(json['prioridad']),
        slaHoras: parseToInt(json['slaHoras']),
        fechaCreacion: parseToStr(json['fechaCreacion']),
        tecnicoAsignado: parseToStr(json['tecnicoAsignado']),
        horasTranscurridas: parseToDouble(json['horasTranscurridas']),
        horasHolguraSla: parseToDouble(json['horasHolguraSla']),
        estadoSlaSemaforo: parseToStr(json['estadoSlaSemaforo']),
      );

  SlaMonitorItemEntity toEntity() => this;
}

class QualityIndicatorItemModel extends QualityIndicatorItemEntity {
  const QualityIndicatorItemModel({
    required super.departamento,
    required super.tipoTrabajo,
    required super.totalOrdenesInspeccionadas,
    required super.totalInspeccionesPreparacion,
    required super.preinspeccionesAprobadas,
    required super.preinspeccionesRechazadas,
    super.pctAprobacionPreinspeccion,
    required super.totalControlesCalidad,
    required super.trabajosCalidadAprobados,
    required super.trabajosCalidadRechazadosRetrabajo,
    super.pctAprobacionCalidadFinal,
  });

  factory QualityIndicatorItemModel.fromJson(Map<String, dynamic> json) =>
      QualityIndicatorItemModel(
        departamento: parseToStr(json['departamento']),
        tipoTrabajo: parseToStr(json['tipoTrabajo']),
        totalOrdenesInspeccionadas: parseToInt(
          json['totalOrdenesInspeccionadas'],
        ),
        totalInspeccionesPreparacion: parseToInt(
          json['totalInspeccionesPreparacion'],
        ),
        preinspeccionesAprobadas: parseToInt(
          json['preinspeccionesAprobadas'],
        ),
        preinspeccionesRechazadas: parseToInt(
          json['preinspeccionesRechazadas'],
        ),
        pctAprobacionPreinspeccion: parseToDoubleOrNull(
          json['pctAprobacionPreinspeccion'],
        ),
        totalControlesCalidad: parseToInt(json['totalControlesCalidad']),
        trabajosCalidadAprobados: parseToInt(
          json['trabajosCalidadAprobados'],
        ),
        trabajosCalidadRechazadosRetrabajo: parseToInt(
          json['trabajosCalidadRechazadosRetrabajo'],
        ),
        pctAprobacionCalidadFinal: parseToDoubleOrNull(
          json['pctAprobacionCalidadFinal'],
        ),
      );

  QualityIndicatorItemEntity toEntity() => this;
}

class EscalationAuditItemModel extends EscalationAuditItemEntity {
  const EscalationAuditItemModel({
    required super.codigoOrden,
    required super.tipoTrabajo,
    required super.departamento,
    required super.estadoActual,
    required super.fechaCreacion,
    super.tecnicoQueEscalo,
    super.motivoEscalamiento,
  });

  factory EscalationAuditItemModel.fromJson(Map<String, dynamic> json) =>
      EscalationAuditItemModel(
        codigoOrden: parseToStr(json['codigoOrden']),
        tipoTrabajo: parseToStr(json['tipoTrabajo']),
        departamento: parseToStr(json['departamento']),
        estadoActual: parseToStr(json['estadoActual']),
        fechaCreacion: parseToStr(json['fechaCreacion']),
        tecnicoQueEscalo: parseToStrOrNull(json['tecnicoQueEscalo']),
        motivoEscalamiento: parseToStrOrNull(json['motivoEscalamiento']),
      );

  EscalationAuditItemEntity toEntity() => this;
}
