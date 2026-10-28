// features/dashboard/domain/entities/executive_overview_entity.dart

import 'package:clean_architecture/features/dashboard/domain/entities/incident_vs_work_order_entities.dart';
import 'package:clean_architecture/features/dashboard/domain/entities/work_order_statistics_entities.dart';
import 'package:equatable/equatable.dart';

/// Tarjeta de KPIs globales de cabecera (2.1).
class HeaderKpisEntity extends Equatable {
  final int totalOrders;
  final int pendingOrAssigned;
  final int inProgress;
  final int onHold;
  final int criticalOrders;
  final int emergency;
  final int urgent;
  final int high;
  final int medium;
  final int low;
  final int createdToday;
  final int createdLast7Days;
  final int createdThisMonth;
  final int completed;
  final int closed;
  final double? completionRate;
  final double totalMaterialCost;
  final double? avgHoursToComplete;
  final double? avgHoursToAssignment;

  const HeaderKpisEntity({
    required this.totalOrders,
    required this.pendingOrAssigned,
    required this.inProgress,
    required this.onHold,
    required this.criticalOrders,
    required this.emergency,
    required this.urgent,
    required this.high,
    required this.medium,
    required this.low,
    required this.createdToday,
    required this.createdLast7Days,
    required this.createdThisMonth,
    required this.completed,
    required this.closed,
    this.completionRate,
    required this.totalMaterialCost,
    this.avgHoursToComplete,
    this.avgHoursToAssignment,
  });

  static const empty = HeaderKpisEntity(
    totalOrders: 0,
    pendingOrAssigned: 0,
    inProgress: 0,
    onHold: 0,
    criticalOrders: 0,
    emergency: 0,
    urgent: 0,
    high: 0,
    medium: 0,
    low: 0,
    createdToday: 0,
    createdLast7Days: 0,
    createdThisMonth: 0,
    completed: 0,
    closed: 0,
    completionRate: 0,
    totalMaterialCost: 0,
    avgHoursToComplete: null,
    avgHoursToAssignment: null,
  );

  @override
  List<Object?> get props => [
    totalOrders,
    pendingOrAssigned,
    inProgress,
    onHold,
    criticalOrders,
    emergency,
    urgent,
    high,
    medium,
    low,
    createdToday,
    createdLast7Days,
    createdThisMonth,
    completed,
    closed,
    completionRate,
    totalMaterialCost,
    avgHoursToComplete,
    avgHoursToAssignment,
  ];
}

/// Orden crítica que requiere atención inmediata para la bandeja ejecutiva.
class ExecutiveImmediateOrderEntity extends Equatable {
  final String codigoOrden;
  final String tipoTrabajo;
  final String prioridad;
  final String estado;
  final String tecnico;
  final double horasTranscurridas;
  final int slaHoras;

  const ExecutiveImmediateOrderEntity({
    required this.codigoOrden,
    required this.tipoTrabajo,
    required this.prioridad,
    required this.estado,
    required this.tecnico,
    required this.horasTranscurridas,
    required this.slaHoras,
  });

  @override
  List<Object?> get props => [
    codigoOrden,
    tipoTrabajo,
    prioridad,
    estado,
    tecnico,
    horasTranscurridas,
    slaHoras,
  ];
}

/// Payload completo y monolítico del dashboard ejecutivo (7.1).
class ExecutiveOverviewEntity extends Equatable {
  final String empresa;
  final String sistema;
  final String generadoEn;
  final FunnelSummaryEntity comparativa;
  final HeaderKpisEntity kpis;
  final List<WorkOrderStatusStatisticEntity> estados;
  final List<WorkOrderPriorityStatisticEntity> prioridades;
  final List<ExecutiveImmediateOrderEntity> ordenesAtencionInmediata;

  const ExecutiveOverviewEntity({
    required this.empresa,
    required this.sistema,
    required this.generadoEn,
    required this.comparativa,
    required this.kpis,
    required this.estados,
    required this.prioridades,
    required this.ordenesAtencionInmediata,
  });

  @override
  List<Object?> get props => [
    empresa,
    sistema,
    generadoEn,
    comparativa,
    kpis,
    estados,
    prioridades,
    ordenesAtencionInmediata,
  ];
}
