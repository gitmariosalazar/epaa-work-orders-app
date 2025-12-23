// features/work-orders/domain/entities/add_work_order_assignment_entity.dart

import 'package:equatable/equatable.dart';

class AddWorkOrderAssignmentEntity extends Equatable {
  final String workOrderId;
  final int workerId;
  final int rolId; // 1 = Normal, 2 = Técnico, 3 = Supervisor (ejemplo)

  const AddWorkOrderAssignmentEntity({
    required this.workOrderId,
    required this.workerId,
    required this.rolId,
  });

  // Para crear copias modificadas
  AddWorkOrderAssignmentEntity copyWith({
    String? workOrderId,
    int? workerId,
    int? rolId,
  }) {
    return AddWorkOrderAssignmentEntity(
      workOrderId: workOrderId ?? this.workOrderId,
      workerId: workerId ?? this.workerId,
      rolId: rolId ?? this.rolId,
    );
  }

  // Para enviar al backend
  Map<String, dynamic> toJson() {
    return {'workOrderId': workOrderId, 'workerId': workerId, 'rolId': rolId};
  }

  // Para recibir del backend (si necesitas parsear respuesta)
  factory AddWorkOrderAssignmentEntity.fromJson(Map<String, dynamic> json) {
    return AddWorkOrderAssignmentEntity(
      workOrderId: json['workOrderId'] as String,
      workerId: json['workerId'] as int,
      rolId: json['rolId'] as int,
    );
  }

  @override
  List<Object?> get props => [workOrderId, workerId, rolId];

  @override
  String toString() {
    return 'AddWorkOrderAssignmentEntity(workOrderId: $workOrderId, workerId: $workerId, rolId: $rolId)';
  }
}
