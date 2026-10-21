// features/dashboard/domain/entities/work_order_statistics_entities.dart
//
// Entidades de dominio puras (sin dependencias de Flutter ni JSON) para las
// estadísticas de órdenes de trabajo expuestas por el gateway `work-orders`.

import 'package:equatable/equatable.dart';

/// GET work-orders/get-work-order-priority-statistics
class WorkOrderPriorityStatisticEntity extends Equatable {
  final String priorityLevel;
  final int priorityId;
  final String description;
  final int quantity;
  final double percentageOfTotal;

  const WorkOrderPriorityStatisticEntity({
    required this.priorityLevel,
    required this.priorityId,
    required this.description,
    required this.quantity,
    required this.percentageOfTotal,
  });

  @override
  List<Object?> get props => [
    priorityLevel,
    priorityId,
    description,
    quantity,
    percentageOfTotal,
  ];
}

/// GET work-orders/get-work-order-status-statistics
///
/// `statusId` es el código del estado (`cat_estado_orden.codigo`), por eso es
/// `String` y no `int`.
class WorkOrderStatusStatisticEntity extends Equatable {
  final String statusName;
  final String statusId;
  final String statusDescription;
  final int quantity;
  final double percentageOfTotal;

  const WorkOrderStatusStatisticEntity({
    required this.statusName,
    required this.statusId,
    required this.statusDescription,
    required this.quantity,
    required this.percentageOfTotal,
  });

  @override
  List<Object?> get props => [
    statusName,
    statusId,
    statusDescription,
    quantity,
    percentageOfTotal,
  ];
}

/// GET work-orders/get-work-order-type-statistics
class WorkOrderTypeStatisticEntity extends Equatable {
  final String workType;
  final int workTypeId;
  final int quantity;
  final int completed;
  final double completionRatePercentage;

  const WorkOrderTypeStatisticEntity({
    required this.workType,
    required this.workTypeId,
    required this.quantity,
    required this.completed,
    required this.completionRatePercentage,
  });

  @override
  List<Object?> get props => [
    workType,
    workTypeId,
    quantity,
    completed,
    completionRatePercentage,
  ];
}

/// GET work-orders/get-work-orders-statistics-key
///
/// Cada fila corresponde a un grupo (estado × tipo de trabajo × departamento)
/// de la vista `work_orders.view_work_order_key_statistics`.
class WorkOrdersKeyStatisticEntity extends Equatable {
  final int totalOrders;
  final int statusId;
  final String statusName;
  final int workTypeId;
  final String workType;
  final int departmentId;
  final String departmentName;
  final int emergency;
  final int urgent;
  final int high;
  final int medium;
  final int low;
  final int criticalOrders;
  final int createdToday;
  final int createdLast7Days;
  final int createdThisMonth;
  final int closed;
  final int completed;
  final double? avgHoursToComplete;
  final double? avgHoursToAssignment;
  final double? avgHoursToExecution;
  final double pctCompletedInGroup;
  final double pctPendingOrAssigned;
  final double totalMaterialCost;
  final double? avgWorkersPerOrder;
  final int? totalWorkerAssignments;

  const WorkOrdersKeyStatisticEntity({
    required this.totalOrders,
    required this.statusId,
    required this.statusName,
    required this.workTypeId,
    required this.workType,
    required this.departmentId,
    required this.departmentName,
    required this.emergency,
    required this.urgent,
    required this.high,
    required this.medium,
    required this.low,
    required this.criticalOrders,
    required this.createdToday,
    required this.createdLast7Days,
    required this.createdThisMonth,
    required this.closed,
    required this.completed,
    required this.avgHoursToComplete,
    required this.avgHoursToAssignment,
    required this.avgHoursToExecution,
    required this.pctCompletedInGroup,
    required this.pctPendingOrAssigned,
    required this.totalMaterialCost,
    required this.avgWorkersPerOrder,
    required this.totalWorkerAssignments,
  });

  /// Órdenes pendientes o asignadas del grupo (derivado del porcentaje).
  int get pendingOrAssigned =>
      (totalOrders * pctPendingOrAssigned / 100).round();

  @override
  List<Object?> get props => [
    totalOrders,
    statusId,
    workTypeId,
    departmentId,
    emergency,
    urgent,
    high,
    medium,
    low,
    criticalOrders,
    createdToday,
    createdLast7Days,
    createdThisMonth,
    closed,
    completed,
    avgHoursToComplete,
    avgHoursToAssignment,
    avgHoursToExecution,
    pctCompletedInGroup,
    pctPendingOrAssigned,
    totalMaterialCost,
    avgWorkersPerOrder,
    totalWorkerAssignments,
  ];
}

/// Agregado global calculado a partir de todas las filas de la vista de KPIs.
/// Lógica de negocio pura → vive en dominio y es fácilmente testeable.
class WorkOrdersKeyStatisticsSummary extends Equatable {
  final int totalOrders;
  final int pendingOrAssigned;
  final int criticalOrders;
  final int emergency;
  final int urgent;
  final int createdToday;
  final int createdLast7Days;
  final int createdThisMonth;
  final int completed;
  final int closed;
  final double totalMaterialCost;

  /// Promedio ponderado por cantidad de órdenes (null si no hay datos).
  final double? avgHoursToComplete;

  const WorkOrdersKeyStatisticsSummary({
    required this.totalOrders,
    required this.pendingOrAssigned,
    required this.criticalOrders,
    required this.emergency,
    required this.urgent,
    required this.createdToday,
    required this.createdLast7Days,
    required this.createdThisMonth,
    required this.completed,
    required this.closed,
    required this.totalMaterialCost,
    required this.avgHoursToComplete,
  });

  static const empty = WorkOrdersKeyStatisticsSummary(
    totalOrders: 0,
    pendingOrAssigned: 0,
    criticalOrders: 0,
    emergency: 0,
    urgent: 0,
    createdToday: 0,
    createdLast7Days: 0,
    createdThisMonth: 0,
    completed: 0,
    closed: 0,
    totalMaterialCost: 0,
    avgHoursToComplete: null,
  );

  /// En progreso = total − pendientes/asignadas − completadas − cerradas.
  int get inProgress {
    final value = totalOrders - pendingOrAssigned - completed - closed;
    return value < 0 ? 0 : value;
  }

  double get completionRate =>
      totalOrders == 0 ? 0 : (completed / totalOrders) * 100;

  factory WorkOrdersKeyStatisticsSummary.fromRows(
    List<WorkOrdersKeyStatisticEntity> rows,
  ) {
    if (rows.isEmpty) return empty;

    int sum(int Function(WorkOrdersKeyStatisticEntity e) f) =>
        rows.fold(0, (acc, e) => acc + f(e));

    double weightedHours = 0;
    int weight = 0;
    for (final r in rows) {
      final h = r.avgHoursToComplete;
      if (h != null && r.completed > 0) {
        weightedHours += h * r.completed;
        weight += r.completed;
      }
    }

    return WorkOrdersKeyStatisticsSummary(
      totalOrders: sum((e) => e.totalOrders),
      pendingOrAssigned: sum((e) => e.pendingOrAssigned),
      criticalOrders: sum((e) => e.criticalOrders),
      emergency: sum((e) => e.emergency),
      urgent: sum((e) => e.urgent),
      createdToday: sum((e) => e.createdToday),
      createdLast7Days: sum((e) => e.createdLast7Days),
      createdThisMonth: sum((e) => e.createdThisMonth),
      completed: sum((e) => e.completed),
      closed: sum((e) => e.closed),
      totalMaterialCost: rows.fold(0.0, (a, e) => a + e.totalMaterialCost),
      avgHoursToComplete: weight == 0 ? null : weightedHours / weight,
    );
  }

  @override
  List<Object?> get props => [
    totalOrders,
    pendingOrAssigned,
    criticalOrders,
    emergency,
    urgent,
    createdToday,
    createdLast7Days,
    createdThisMonth,
    completed,
    closed,
    totalMaterialCost,
    avgHoursToComplete,
  ];
}
