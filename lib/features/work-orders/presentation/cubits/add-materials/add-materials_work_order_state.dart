part of 'add-materials_work_orde_cubit.dart';

sealed class AddMaterialsWorkOrderState {}

class AddMaterialsWorkOrderInitial extends AddMaterialsWorkOrderState {}

class AddMaterialsWorkOrderLoading extends AddMaterialsWorkOrderState {}

class AddMaterialsWorkOrderSuccess extends AddMaterialsWorkOrderState {
  final List<AddMaterialWorkOrderEntity> addedMaterials;
  AddMaterialsWorkOrderSuccess(this.addedMaterials);
}

class AddMaterialsWorkOrderError extends AddMaterialsWorkOrderState {
  final String message;
  AddMaterialsWorkOrderError(this.message);
}
