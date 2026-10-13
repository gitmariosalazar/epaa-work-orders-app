import 'package:clean_architecture/core/constants/work_order_status.dart';
import 'package:clean_architecture/features/work-orders/domain/entities/work_order_entity.dart';

class WorkOrderModel {
  final String workOrderId;
  final String orderCode;
  final String? origin;
  final int workTypeId;
  final int priorityId;
  final String clientId;
  final String location;
  final String description;
  final int createdUserId;
  final String? createdByUserId;
  final int assignedUserId;
  final int completedUserId;
  final String coordinates;
  final double? latitude;
  final double? longitude;
  final String? metadata;
  final String cadastralKey;
  final bool isDeleted;
  final DateTime creationDate;
  final DateTime? assignationDate;
  final DateTime? completionDate;
  final String status;

  const WorkOrderModel({
    required this.workOrderId,
    required this.orderCode,
    this.origin,
    required this.workTypeId,
    required this.priorityId,
    required this.clientId,
    required this.location,
    required this.description,
    required this.createdUserId,
    this.createdByUserId,
    required this.assignedUserId,
    required this.completedUserId,
    required this.coordinates,
    this.latitude,
    this.longitude,
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
      workOrderId:
          (json['workOrderId'] ??
                  json['work_order_id'] ??
                  json['record_id'] ??
                  '')
              .toString(),
      orderCode:
          (json['orderCode'] ?? json['order_code'] ?? json['codigoOrden'] ?? '')
              .toString(),
      origin: (json['origin'] ?? json['origen'])?.toString(),
      workTypeId: _toInt(json['workTypeId'] ?? json['id_tipo_trabajo']),
      priorityId: _toInt(json['priorityId'] ?? json['id_prioridad']),
      clientId: (json['clientId'] ?? json['id_cliente'] ?? '').toString(),
      location: (json['location'] ?? json['direccion'] ?? '').toString(),
      description: (json['description'] ?? json['descripcion'] ?? '')
          .toString(),
      createdUserId: _toInt(json['createdUserId'] ?? json['created_by']),
      createdByUserId: (json['createdByUserId'] ?? json['created_by_user_id'])
          ?.toString(),
      assignedUserId: _toInt(json['assignedUserId']),
      completedUserId: _toInt(json['completedUserId']),
      coordinates: (json['coordinates'] ?? '').toString(),
      latitude: _toDouble(json['latitude']),
      longitude: _toDouble(json['longitude']),
      metadata: json['metadata']?.toString(),
      cadastralKey: (json['cadastralKey'] ?? json['clave_catastral'] ?? '')
          .toString(),
      isDeleted: json['isDeleted'] as bool? ?? false,
      creationDate: json['creationDate'] != null
          ? DateTime.tryParse(json['creationDate'].toString()) ?? DateTime.now()
          : (json['processed_at'] != null
                ? DateTime.tryParse(json['processed_at'].toString()) ??
                      DateTime.now()
                : DateTime.now()),
      assignationDate: json['assignationDate'] != null
          ? DateTime.tryParse(json['assignationDate'].toString())
          : null,
      completionDate: json['completionDate'] != null
          ? DateTime.tryParse(json['completionDate'].toString())
          : null,
      status: WorkOrderStatus.normalize(
        (json['status'] ??
                json['current_status'] ??
                json['estado'] ??
                WorkOrderStatus.pendiente)
            .toString(),
      ),
    );
  }

  static int _toInt(dynamic value) {
    if (value is int) return value;
    if (value is String) return int.tryParse(value) ?? 0;
    return 0;
  }

  static double? _toDouble(dynamic value) {
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value);
    return null;
  }

  factory WorkOrderModel.fromDomain(WorkOrderEntity domain) {
    return WorkOrderModel(
      workOrderId: domain.workOrderId ?? '',
      orderCode: domain.orderCode ?? '',
      origin: domain.origin,
      workTypeId: domain.workTypeId,
      priorityId: domain.priorityId,
      clientId: domain.clientId,
      location: domain.location,
      description: domain.description,
      createdUserId: domain.createdUserId,
      createdByUserId: domain.createdByUserId,
      assignedUserId: domain.assignedUserId ?? 0,
      completedUserId: domain.completedUserId ?? 0,
      coordinates:
          domain.coordinates ??
          (domain.latitude != null && domain.longitude != null
              ? '${domain.latitude}, ${domain.longitude}'
              : ''),
      latitude: domain.latitude,
      longitude: domain.longitude,
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
    'origin': origin ?? 'SOLICITUD',
    'workTypeId': workTypeId,
    'priorityId': priorityId,
    'clientId': clientId,
    'location': location,
    if (cadastralKey.isNotEmpty) 'cadastralKey': cadastralKey,
    if (description.isNotEmpty) 'description': description,
    if (latitude != null) 'latitude': latitude,
    if (longitude != null) 'longitude': longitude,
    if (createdByUserId != null && createdByUserId!.isNotEmpty)
      'createdByUserId': createdByUserId,
    'createdUserId': createdUserId,
    if (metadata != null) 'metadata': metadata,
    'coordinates': coordinates,
    'status': status,
    if (workOrderId.isNotEmpty) 'workOrderId': workOrderId,
    if (orderCode.isNotEmpty) 'orderCode': orderCode,
  };

  WorkOrderEntity toEntity() {
    return WorkOrderEntity(
      workOrderId: workOrderId,
      orderCode: orderCode,
      origin: origin,
      workTypeId: workTypeId,
      priorityId: priorityId,
      clientId: clientId,
      location: location,
      description: description,
      createdUserId: createdUserId,
      createdByUserId: createdByUserId,
      assignedUserId: assignedUserId,
      completedUserId: completedUserId,
      coordinates: coordinates,
      latitude: latitude,
      longitude: longitude,
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
