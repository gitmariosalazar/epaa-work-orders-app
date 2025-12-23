class WorkOrderEntity {
  final String? workOrderId;
  final String? orderCode;
  final int workTypeId;
  final int priorityId;
  final String clientId;
  final String location;
  final String description;
  final int createdUserId;
  final int? assignedUserId;
  final int? completedUserId;
  final String? coordinates;
  final String? metadata;
  final String cadastralKey;
  final bool? isDeleted;
  final DateTime? creationDate;
  final DateTime? assignationDate;
  final DateTime? completionDate;
  final int status;
  WorkOrderEntity({
    this.workOrderId,
    this.orderCode,
    required this.workTypeId,
    required this.priorityId,
    required this.clientId,
    required this.location,
    required this.description,
    required this.createdUserId,
    this.assignedUserId,
    this.completedUserId,
    this.coordinates,
    this.metadata,
    required this.cadastralKey,
    this.isDeleted,
    this.creationDate,
    this.assignationDate,
    this.completionDate,
    required this.status,
  });
}
