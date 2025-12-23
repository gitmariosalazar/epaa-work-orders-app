// features/work-orders/presentation/cubits/work_orders/work_orders_state.dart

import 'package:clean_architecture/features/work-orders/domain/entities/work_order_entity.dart';
import 'package:equatable/equatable.dart';

sealed class WorkOrdersState extends Equatable {
  const WorkOrdersState();

  @override
  List<Object?> get props => [];
}

class WorkOrdersInitial extends WorkOrdersState {}

class WorkOrdersLoading extends WorkOrdersState {}

class WorkOrdersLoaded extends WorkOrdersState {
  final List<WorkOrderEntity> orders;

  const WorkOrdersLoaded(this.orders);

  @override
  List<Object?> get props => [orders];
}

class WorkOrdersError extends WorkOrdersState {
  final String message;

  const WorkOrdersError(this.message);

  @override
  List<Object?> get props => [message];
}

class WorkOrdersEmpty extends WorkOrdersState {}
