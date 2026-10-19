import 'package:clean_architecture/features/work-orders/domain/entities/add_work_order_assignment.dart';

class AddWorkOrderAssignmentModel {
  final String workOrderId;
  final int workerId;
  final int rolId;

  const AddWorkOrderAssignmentModel({
    required this.workOrderId,
    required this.workerId,
    required this.rolId,
  });

  factory AddWorkOrderAssignmentModel.fromEntity(
    AddWorkOrderAssignmentEntity entity,
  ) {
    return AddWorkOrderAssignmentModel(
      workOrderId: entity.workOrderId,
      workerId: entity.workerId,
      rolId: entity.rolId,
    );
  }

  Map<String, dynamic> toJson() {
    return {'workOrderId': workOrderId, 'workerId': workerId, 'rolId': rolId};
  }

  AddWorkOrderAssignmentEntity toEntity() {
    return AddWorkOrderAssignmentEntity(
      workOrderId: workOrderId,
      workerId: workerId,
      rolId: rolId,
    );
  }

  // Función helper para convertir String o int a int
  static int _toInt(dynamic value) {
    if (value is int) return value;
    if (value is String) return int.tryParse(value) ?? 0;
    return 0;
  }

  factory AddWorkOrderAssignmentModel.fromJson(Map<String, dynamic> json) {
    return AddWorkOrderAssignmentModel(
      workOrderId: (json['workOrderId'] ?? json['work_order_id'] ?? '')
          .toString(),
      workerId: _toInt(json['workerId']),
      rolId: _toInt(json['rolId']),
    );
  }
}
