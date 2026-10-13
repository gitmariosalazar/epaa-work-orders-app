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
  });
}
