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

class WorkOrdersEmpty extends WorkOrdersState {}

class WorkOrdersLoaded extends WorkOrdersState {
  final List<WorkOrderEntity> orders;
  final bool isLoadingMore;
  final bool hasMore;
  final String? partialErrorMessage;

  const WorkOrdersLoaded({
    required this.orders,
    this.isLoadingMore = false,
    this.hasMore = true,
    this.partialErrorMessage,
  });

  WorkOrdersLoaded copyWith({
    List<WorkOrderEntity>? orders,
    bool? isLoadingMore,
    bool? hasMore,
    String? partialErrorMessage,
  }) {
    return WorkOrdersLoaded(
      orders: orders ?? this.orders,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      hasMore: hasMore ?? this.hasMore,
      partialErrorMessage: partialErrorMessage ?? this.partialErrorMessage,
    );
  }

  @override
  List<Object?> get props => [
    orders,
    isLoadingMore,
    hasMore,
    partialErrorMessage,
  ];
}

class WorkOrdersError extends WorkOrdersState {
  final String message;

  const WorkOrdersError(this.message);

  @override
  List<Object?> get props => [message];
}
