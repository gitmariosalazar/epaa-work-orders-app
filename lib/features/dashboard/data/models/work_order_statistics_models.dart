// features/dashboard/data/models/work_order_statistics_models.dart
//
// Modelos de datos: conocen el formato JSON y saben mapearse a entidades.
// PostgreSQL devuelve COUNT/ROUND/NUMERIC como string en muchos drivers,
// por eso se parsea de forma defensiva.

import 'package:clean_architecture/features/dashboard/domain/entities/work_order_statistics_entities.dart';

int _toInt(dynamic v, [int fallback = 0]) {
  if (v == null) return fallback;
  if (v is int) return v;
  if (v is num) return v.toInt();
  return int.tryParse(v.toString()) ??
      double.tryParse(v.toString())?.toInt() ??
      fallback;
}

int? _toIntOrNull(dynamic v) => v == null ? null : _toInt(v);

double _toDouble(dynamic v, [double fallback = 0]) {
  if (v == null) return fallback;
  if (v is num) return v.toDouble();
  return double.tryParse(v.toString()) ?? fallback;
}

double? _toDoubleOrNull(dynamic v) => v == null ? null : _toDouble(v);

String _toStr(dynamic v) => v?.toString() ?? '';

class WorkOrderPriorityStatisticModel extends WorkOrderPriorityStatisticEntity {
  const WorkOrderPriorityStatisticModel({
    required super.priorityLevel,
    required super.priorityId,
    required super.description,
    required super.quantity,
    required super.percentageOfTotal,
  });

  factory WorkOrderPriorityStatisticModel.fromJson(Map<String, dynamic> json) =>
      WorkOrderPriorityStatisticModel(
        priorityLevel: _toStr(
          json['priorityLevel'] ?? json['priority_level'] ?? json['prioridad'],
        ),
        priorityId: _toInt(json['priorityId'] ?? json['priority_id']),
        description: _toStr(json['description'] ?? json['descripcion']),
        quantity: _toInt(json['quantity'] ?? json['cantidad']),
        percentageOfTotal: _toDouble(
          json['percentageOfTotal'] ??
              json['percentage_of_total'] ??
              json['percentage'] ??
              json['porcentaje'],
        ),
      );

  WorkOrderPriorityStatisticEntity toEntity() => this;
}

class WorkOrderStatusStatisticModel extends WorkOrderStatusStatisticEntity {
  const WorkOrderStatusStatisticModel({
    required super.statusName,
    required super.statusId,
    required super.statusDescription,
    required super.quantity,
    required super.percentageOfTotal,
  });

  factory WorkOrderStatusStatisticModel.fromJson(Map<String, dynamic> json) =>
      WorkOrderStatusStatisticModel(
        statusName: _toStr(json['statusName'] ?? json['status_name']),
        statusId:
            _toStr(json['statusId'] ?? json['status_id'] ?? json['estado']),
        statusDescription: _toStr(json['statusDescription'] ??
            json['status_description'] ??
            json['descripcion']),
        quantity: _toInt(json['quantity'] ?? json['total'] ?? json['count']),
        percentageOfTotal: _toDouble(json['percentageOfTotal'] ??
            json['percentage_of_total'] ??
            json['porcentaje']),
      );

  WorkOrderStatusStatisticEntity toEntity() => this;
}

class WorkOrderTypeStatisticModel extends WorkOrderTypeStatisticEntity {
  const WorkOrderTypeStatisticModel({
    required super.workType,
    required super.workTypeId,
    required super.quantity,
    required super.completed,
    required super.completionRatePercentage,
  });

  factory WorkOrderTypeStatisticModel.fromJson(Map<String, dynamic> json) =>
      WorkOrderTypeStatisticModel(
        workType: _toStr(json['workType']),
        workTypeId: _toInt(json['workTypeId']),
        quantity: _toInt(json['quantity']),
        completed: _toInt(json['completed']),
        completionRatePercentage: _toDouble(json['completionRatePercentage']),
      );

  WorkOrderTypeStatisticEntity toEntity() => this;
}

class WorkOrdersKeyStatisticModel extends WorkOrdersKeyStatisticEntity {
  const WorkOrdersKeyStatisticModel({
    required super.totalOrders,
    required super.statusId,
    required super.statusName,
    required super.workTypeId,
    required super.workType,
    required super.departmentId,
    required super.departmentName,
    required super.emergency,
    required super.urgent,
    required super.high,
    required super.medium,
    required super.low,
    required super.criticalOrders,
    required super.createdToday,
    required super.createdLast7Days,
    required super.createdThisMonth,
    required super.closed,
    required super.completed,
    required super.avgHoursToComplete,
    required super.avgHoursToAssignment,
    required super.avgHoursToExecution,
    required super.pctCompletedInGroup,
    required super.pctPendingOrAssigned,
    required super.totalMaterialCost,
    required super.avgWorkersPerOrder,
    required super.totalWorkerAssignments,
  });

  factory WorkOrdersKeyStatisticModel.fromJson(Map<String, dynamic> json) =>
      WorkOrdersKeyStatisticModel(
        totalOrders: _toInt(json['totalOrders']),
        statusId: _toInt(json['statusId']),
        statusName: _toStr(json['statusName']),
        workTypeId: _toInt(json['workTypeId']),
        workType: _toStr(json['workType']),
        departmentId: _toInt(json['departmentId']),
        departmentName: _toStr(json['departmentName']),
        emergency: _toInt(json['emergency']),
        urgent: _toInt(json['urgent']),
        high: _toInt(json['high']),
        medium: _toInt(json['medium']),
        low: _toInt(json['low']),
        criticalOrders: _toInt(json['criticalOrders']),
        createdToday: _toInt(json['createdToday']),
        createdLast7Days: _toInt(json['createdLast7Days']),
        createdThisMonth: _toInt(json['createdThisMonth']),
        closed: _toInt(json['closed']),
        completed: _toInt(json['completed']),
        avgHoursToComplete: _toDoubleOrNull(json['avgHoursToComplete']),
        avgHoursToAssignment: _toDoubleOrNull(json['avgHoursToAssignment']),
        avgHoursToExecution: _toDoubleOrNull(json['avgHoursToExecution']),
        pctCompletedInGroup: _toDouble(json['pctCompletedInGroup']),
        pctPendingOrAssigned: _toDouble(json['pctPendingOrAssigned']),
        totalMaterialCost: _toDouble(json['totalMaterialCost']),
        avgWorkersPerOrder: _toDoubleOrNull(json['avgWorkersPerOrder']),
        totalWorkerAssignments: _toIntOrNull(json['totalWorkerAssignments']),
      );

  WorkOrdersKeyStatisticEntity toEntity() => this;
}
