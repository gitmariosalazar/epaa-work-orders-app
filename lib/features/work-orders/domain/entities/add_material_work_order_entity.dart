import 'package:equatable/equatable.dart';

class AddMaterialWorkOrderEntity extends Equatable {
  final String workOrderId;
  final int materialId;
  final double quantity;
  final double unitCost;

  const AddMaterialWorkOrderEntity({
    required this.workOrderId,
    required this.materialId,
    required this.quantity,
    required this.unitCost,
  });

  AddMaterialWorkOrderEntity copyWith({
    String? workOrderId,
    int? materialId,
    double? quantity,
    double? unitCost,
  }) {
    return AddMaterialWorkOrderEntity(
      workOrderId: workOrderId ?? this.workOrderId,
      materialId: materialId ?? this.materialId,
      quantity: quantity ?? this.quantity,
      unitCost: unitCost ?? this.unitCost,
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

  factory AddMaterialWorkOrderEntity.fromJson(Map<String, dynamic> json) {
    return AddMaterialWorkOrderEntity(
      workOrderId: json['workOrderId'] as String,
      materialId: json['materialId'] as int,
      quantity: (json['quantity'] as num).toDouble(),
      unitCost: (json['unitCost'] as num).toDouble(),
    );
  }

  @override
  List<Object?> get props => [workOrderId, materialId, quantity, unitCost];
}
