// features/work-orders/presentation/cubits/create_work_order/create_work_order_state.dart

part of 'create_work_order_cubit.dart';

sealed class CreateWorkOrderState {}

class CreateWorkOrderInitial extends CreateWorkOrderState {}

class CreateWorkOrderLoading extends CreateWorkOrderState {}

class CreateWorkOrderSuccess extends CreateWorkOrderState {
  final WorkOrderEntity createdOrder;
  final String? evidenceWarning;
  CreateWorkOrderSuccess(this.createdOrder, {this.evidenceWarning});
}

class CreateWorkOrderError extends CreateWorkOrderState {
  final String message;
  CreateWorkOrderError(this.message);
}
