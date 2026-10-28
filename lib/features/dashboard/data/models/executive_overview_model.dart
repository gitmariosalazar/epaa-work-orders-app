// features/dashboard/data/models/executive_overview_model.dart

import 'package:clean_architecture/features/dashboard/data/models/dashboard_parsing_helpers.dart';
import 'package:clean_architecture/features/dashboard/data/models/incident_vs_work_order_models.dart';
import 'package:clean_architecture/features/dashboard/data/models/work_order_statistics_models.dart';
import 'package:clean_architecture/features/dashboard/domain/entities/executive_overview_entity.dart';

class HeaderKpisModel extends HeaderKpisEntity {
  const HeaderKpisModel({
    required super.totalOrders,
    required super.pendingOrAssigned,
    required super.inProgress,
    required super.onHold,
    required super.criticalOrders,
    required super.emergency,
    required super.urgent,
    required super.high,
    required super.medium,
    required super.low,
    required super.createdToday,
    required super.createdLast7Days,
    required super.createdThisMonth,
    required super.completed,
    required super.closed,
    super.completionRate,
    required super.totalMaterialCost,
    super.avgHoursToComplete,
    super.avgHoursToAssignment,
  });

  factory HeaderKpisModel.fromJson(Map<String, dynamic> json) {
    final total = parseToInt(
      json['totalOrders'] ?? json['total_ordenes'] ?? json['total'],
    );
    final pending = parseToInt(
      json['pendingOrAssigned'] ??
          json['pendientes_o_asignadas'] ??
          json['pendientes'] ??
          json['asignadas'],
    );
    int inProg = parseToInt(
      json['inProgress'] ??
          json['in_progress'] ??
          json['en_progreso'] ??
          json['en_proceso'],
    );
    final completed = parseToInt(
      json['completed'] ??
          json['completadas'] ??
          json['completadas_resueltas'],
    );

    // Salvaguarda: si en_progreso viene en 0 pero la suma total excede pendientes + completadas
    if (inProg == 0 && total > (pending + completed)) {
      inProg = total - (pending + completed);
    }

    return HeaderKpisModel(
      totalOrders: total,
      pendingOrAssigned: pending,
      inProgress: inProg,
      onHold: parseToInt(
        json['onHold'] ?? json['en_espera'] ?? json['ot_en_espera'],
      ),
      criticalOrders: parseToInt(
        json['criticalOrders'] ?? json['criticas'] ?? json['criticas_ordenes'],
      ),
      emergency: parseToInt(
        json['emergency'] ?? json['emergencias'] ?? json['emergencia'],
      ),
      urgent: parseToInt(
        json['urgent'] ?? json['urgentes'] ?? json['urgente'],
      ),
      high: parseToInt(json['high'] ?? json['altas'] ?? json['alta']),
      medium: parseToInt(json['medium'] ?? json['medias'] ?? json['media']),
      low: parseToInt(json['low'] ?? json['bajas'] ?? json['baja']),
      createdToday: parseToInt(
        json['createdToday'] ?? json['creadas_hoy'] ?? json['hoy'],
      ),
      createdLast7Days: parseToInt(
        json['createdLast7Days'] ?? json['creadas_ultimos_7_dias'],
      ),
      createdThisMonth: parseToInt(
        json['createdThisMonth'] ?? json['creadas_este_mes'],
      ),
      completed: completed,
      closed: parseToInt(json['closed'] ?? json['cerradas']),
      completionRate: parseToDoubleOrNull(
        json['completionRate'] ?? json['tasa_cumplimiento_pct'],
      ),
      totalMaterialCost: parseToDouble(
        json['totalMaterialCost'] ??
            json['costo_total_materiales'] ??
            json['costo_materiales'],
      ),
      avgHoursToComplete: parseToDoubleOrNull(
        json['avgHoursToComplete'] ?? json['horas_promedio_resolucion'],
      ),
      avgHoursToAssignment: parseToDoubleOrNull(
        json['avgHoursToAssignment'] ?? json['horas_promedio_asignacion'],
      ),
    );
  }

  HeaderKpisEntity toEntity() => this;
}

class ExecutiveImmediateOrderModel extends ExecutiveImmediateOrderEntity {
  const ExecutiveImmediateOrderModel({
    required super.codigoOrden,
    required super.tipoTrabajo,
    required super.prioridad,
    required super.estado,
    required super.tecnico,
    required super.horasTranscurridas,
    required super.slaHoras,
  });

  factory ExecutiveImmediateOrderModel.fromJson(Map<String, dynamic> json) =>
      ExecutiveImmediateOrderModel(
        codigoOrden: parseToStr(json['codigoOrden'] ?? json['codigo_orden']),
        tipoTrabajo: parseToStr(json['tipoTrabajo'] ?? json['tipo_trabajo']),
        prioridad: parseToStr(json['prioridad']),
        estado: parseToStr(json['estado']),
        tecnico: parseToStr(json['tecnico']),
        horasTranscurridas: parseToDouble(
          json['horasTranscurridas'] ?? json['horas_transcurridas'],
        ),
        slaHoras: parseToInt(json['slaHoras'] ?? json['sla_horas']),
      );

  ExecutiveImmediateOrderEntity toEntity() => this;
}

class ExecutiveOverviewModel extends ExecutiveOverviewEntity {
  const ExecutiveOverviewModel({
    required super.empresa,
    required super.sistema,
    required super.generadoEn,
    required super.comparativa,
    required super.kpis,
    required super.estados,
    required super.prioridades,
    required super.ordenesAtencionInmediata,
  });

  factory ExecutiveOverviewModel.fromJson(Map<String, dynamic> json) {
    final metadata = json['metadata'] as Map<String, dynamic>? ?? {};
    final compJson = (json['comparativaIncidentesVsOts'] ??
            json['comparativa_incidentes_vs_ots'])
        as Map<String, dynamic>? ??
        {};
    final kpisJson = (json['kpisOrdenesTrabajo'] ??
            json['kpis_ordenes_trabajo'])
        as Map<String, dynamic>? ??
        {};
    final estadosList =
        (json['distribucionEstados'] ?? json['distribucion_estados'])
            as List<dynamic>? ??
            [];
    final prioridadesList =
        (json['distribucionPrioridades'] ?? json['distribucion_prioridades'])
            as List<dynamic>? ??
            [];
    final atencionList =
        (json['ordenesAtencionInmediata'] ??
            json['ordenes_atencion_inmediata'])
        as List<dynamic>? ??
        [];

    return ExecutiveOverviewModel(
      empresa: parseToStr(metadata['empresa']),
      sistema: parseToStr(metadata['sistema']),
      generadoEn: parseToStr(metadata['generadoEn']),
      comparativa: FunnelSummaryModel.fromJson(compJson),
      kpis: HeaderKpisModel.fromJson(kpisJson),
      estados:
          estadosList
              .map(
                (e) => WorkOrderStatusStatisticModel.fromJson(
                  e as Map<String, dynamic>,
                ),
              )
              .toList(),
      prioridades:
          prioridadesList
              .map(
                (e) => WorkOrderPriorityStatisticModel.fromJson(
                  e as Map<String, dynamic>,
                ),
              )
              .toList(),
      ordenesAtencionInmediata:
          atencionList
              .map(
                (e) => ExecutiveImmediateOrderModel.fromJson(
                  e as Map<String, dynamic>,
                ),
              )
              .toList(),
    );
  }

  ExecutiveOverviewEntity toEntity() => this;
}
