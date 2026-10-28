import 'dart:io';

class WorkOrderEntity {
  final String? workOrderId;
  final String? orderCode;
  final String? origin;
  final int workTypeId;
  final int priorityId;
  final String clientId;
  final String location;
  final String description;
  final int createdUserId;
  final String? createdByUserId;
  final int? assignedUserId;
  final int? completedUserId;
  final String? coordinates;
  final double? latitude;
  final double? longitude;
  final String? metadata;
  final String cadastralKey;
  final bool? isDeleted;
  final DateTime? creationDate;
  final DateTime? assignationDate;
  final DateTime? completionDate;
  final String status;

  final List<File>? attachments;

  final String? workTypeName;
  final int? departmentId;
  final String? departmentName;
  final String? priorityLevel;

  WorkOrderEntity({
    this.workOrderId,
    this.orderCode,
    this.origin,
    required this.workTypeId,
    required this.priorityId,
    required this.clientId,
    required this.location,
    required this.description,
    this.createdUserId = 1,
    this.createdByUserId,
    this.assignedUserId,
    this.completedUserId,
    this.coordinates,
    this.latitude,
    this.longitude,
    this.metadata,
    required this.cadastralKey,
    this.isDeleted,
    this.creationDate,
    this.assignationDate,
    this.completionDate,
    this.status = 'PENDIENTE',
    this.attachments,
    this.workTypeName,
    this.departmentId,
    this.departmentName,
    this.priorityLevel,
  });
}

/*
export interface DepartmentResponse {
  departmentId: number;
  departmentName: string;
  departmentDescription: string;
  workTypes: WorkType[];
}

export interface WorkType {
  typeCode: string;
  typeName: string;
  typeDescription: string;
  suggestedPriority: string;
}
 */

class DepartmentEntity {
  final int departmentId;
  final String departmentName;
  final String departmentDescription;
  final List<WorkTypeEntity> workTypes;

  DepartmentEntity({
    required this.departmentId,
    required this.departmentName,
    required this.departmentDescription,
    required this.workTypes,
  });
}

class WorkTypeEntity {
  final String typeCode;
  final String typeName;
  final String typeDescription;
  final String suggestedPriority;

  WorkTypeEntity({
    required this.typeCode,
    required this.typeName,
    required this.typeDescription,
    required this.suggestedPriority,
  });
}
