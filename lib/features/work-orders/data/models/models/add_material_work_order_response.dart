import 'package:clean_architecture/features/work-orders/domain/entities/add_material_work_order_entity.dart';

class AddMaterialWorkOrderModel {
  final String workOrderId;
  final int materialId;
  final double quantity;
  final double unitCost;
  const AddMaterialWorkOrderModel({
    required this.workOrderId,
    required this.materialId,
    required this.quantity,
    required this.unitCost,
  });

  factory AddMaterialWorkOrderModel.fromEntity(
    AddMaterialWorkOrderEntity entity,
  ) {
    return AddMaterialWorkOrderModel(
      workOrderId: entity.workOrderId,
      materialId: entity.materialId,
      quantity: entity.quantity,
      unitCost: entity.unitCost,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'workOrderId': workOrderId,
      'materialId': materialId,
      'quantity': quantity,
      'unitCost': unitCost,
    };
  }

  AddMaterialWorkOrderEntity toEntity() {
    return AddMaterialWorkOrderEntity(
      workOrderId: workOrderId,
      materialId: materialId,
      quantity: quantity,
      unitCost: unitCost,
    );
  }

  factory AddMaterialWorkOrderModel.fromJson(Map<String, dynamic> json) {
    return AddMaterialWorkOrderModel(
      workOrderId: json['workOrderId'] as String,
      materialId: json['materialId'] as int,
      quantity: (json['quantity'] as num).toDouble(),
      unitCost: (json['unitCost'] as num).toDouble(),
    );
  }
}
