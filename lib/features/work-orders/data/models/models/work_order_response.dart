import 'package:clean_architecture/features/work-orders/domain/entities/work_order_entity.dart';

class WorkOrderModel {
  final String workOrderId;
  final String orderCode;
  final int workTypeId;
  final int priorityId;
  final String clientId;
  final String location;
  final String description;
  final int createdUserId;
  final int assignedUserId;
  final int completedUserId;
  final String coordinates;
  final String? metadata;
  final String cadastralKey;
  final bool isDeleted;
  final DateTime creationDate;
  final DateTime? assignationDate;
  final DateTime? completionDate;
  final int status;
  const WorkOrderModel({
    required this.workOrderId,
    required this.orderCode,
    required this.workTypeId,
    required this.priorityId,
    required this.clientId,
    required this.location,
    required this.description,
    required this.createdUserId,
    required this.assignedUserId,
    required this.completedUserId,
    required this.coordinates,
    this.metadata,
    required this.cadastralKey,
    required this.isDeleted,
    required this.creationDate,
    this.assignationDate,
    this.completionDate,
    required this.status,
  });

  factory WorkOrderModel.fromJson(Map<String, dynamic> json) {
    return WorkOrderModel(
      workOrderId: json['workOrderId'] as String,
      orderCode: json['orderCode'] as String,
      workTypeId: _toInt(json['workTypeId']),
      priorityId: _toInt(json['priorityId']),
      clientId: json['clientId'] as String,
      location: json['location'] as String? ?? '',
      description: json['description'] as String? ?? '',
      createdUserId: _toInt(json['createdUserId']),
      assignedUserId: _toInt(json['assignedUserId']),
      completedUserId: _toInt(json['completedUserId']),
      coordinates: json['coordinates'] as String? ?? '',
      metadata: json['metadata'] as String?,
      cadastralKey: json['cadastralKey'] as String? ?? '',
      isDeleted: json['isDeleted'] as bool? ?? false,
      creationDate: DateTime.parse(json['creationDate'] as String),
      assignationDate: json['assignationDate'] != null
          ? DateTime.parse(json['assignationDate'] as String)
          : null,
      completionDate: json['completionDate'] != null
          ? DateTime.parse(json['completionDate'] as String)
          : null,
      status: _toInt(json['status']),
    );
  }

  // Función helper para convertir String o int a int
  static int _toInt(dynamic value) {
    if (value is int) return value;
    if (value is String) return int.tryParse(value) ?? 0;
    return 0;
  }

  factory WorkOrderModel.fromDomain(WorkOrderEntity domain) {
    return WorkOrderModel(
      workOrderId: domain.workOrderId ?? '',
      orderCode: domain.orderCode ?? '',
      workTypeId: domain.workTypeId,
      priorityId: domain.priorityId,
      clientId: domain.clientId,
      location: domain.location,
      description: domain.description,
      createdUserId: domain.createdUserId,
      assignedUserId: domain.assignedUserId ?? 0,
      completedUserId: domain.completedUserId ?? 0,
      coordinates: domain.coordinates ?? '',
      metadata: domain.metadata,
      cadastralKey: domain.cadastralKey,
      isDeleted: domain.isDeleted ?? false,
      creationDate: domain.creationDate ?? DateTime.now(),
      assignationDate: domain.assignationDate,
      completionDate: domain.completionDate,
      status: domain.status,
    );
  }

  Map<String, dynamic> toJson() => {
    'workOrderId': workOrderId,
    'orderCode': orderCode,
    'workTypeId': workTypeId,
    'priorityId': priorityId,
    'clientId': clientId,
    'location': location,
    'description': description,
    'createdUserId': createdUserId,
    'assignedUserId': assignedUserId,
    'completedUserId': completedUserId,
    'coordinates': coordinates,
    'metadata': metadata,
    'cadastralKey': cadastralKey,
    'isDeleted': isDeleted,
    'creationDate': creationDate.toIso8601String(),
    'assignationDate': assignationDate?.toIso8601String(),
    'completionDate': completionDate?.toIso8601String(),
    'status': status,
  };

  WorkOrderEntity toEntity() {
    return WorkOrderEntity(
      workOrderId: workOrderId,
      orderCode: orderCode,
      workTypeId: workTypeId,
      priorityId: priorityId,
      clientId: clientId,
      location: location,
      description: description,
      createdUserId: createdUserId,
      assignedUserId: assignedUserId,
      completedUserId: completedUserId,
      coordinates: coordinates,
      metadata: metadata,
      cadastralKey: cadastralKey,
      isDeleted: isDeleted,
      creationDate: creationDate,
      assignationDate: assignationDate,
      completionDate: completionDate,
      status: status,
    );
  }
}
