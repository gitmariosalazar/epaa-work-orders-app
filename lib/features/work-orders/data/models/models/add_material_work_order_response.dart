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

  static int _toInt(dynamic value, [int defaultValue = 0]) {
    if (value == null) return defaultValue;
    if (value is int) return value;
    if (value is num) return value.toInt();
    if (value is String) return int.tryParse(value.trim()) ?? defaultValue;
    return defaultValue;
  }

  static double _toDouble(dynamic value, [double defaultValue = 0.0]) {
    if (value == null) return defaultValue;
    if (value is double) return value;
    if (value is num) return value.toDouble();
    if (value is String) return double.tryParse(value.trim()) ?? defaultValue;
    return defaultValue;
  }

  factory AddMaterialWorkOrderModel.fromJson(Map<String, dynamic> json) {
    return AddMaterialWorkOrderModel(
      workOrderId: (json['workOrderId'] ?? json['work_order_id'] ?? '').toString(),
      materialId: _toInt(json['materialId'] ?? json['material_id']),
      quantity: _toDouble(json['quantity']),
      unitCost: _toDouble(json['unitCost'] ?? json['unit_cost']),
    );
  }
}
