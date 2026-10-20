// features/dashboard/presentation/pages/technician/cubit/technician_initial_state.dart

import 'package:clean_architecture/features/work-orders/domain/entities/work_order_entity.dart';
import 'package:flutter/foundation.dart';

@immutable
class TechnicianInitialState {
  final bool isLoading;
  final bool isSyncing;
  final String? errorMessage;
  final int pendingCount;
  final int inProgressCount;
  final int completedCount;
  final WorkOrderEntity? priorityOrder;
  final List<WorkOrderEntity> todayOrders;
  final List<WorkOrderEntity> allOrders;

  const TechnicianInitialState({
    this.isLoading = false,
    this.isSyncing = false,
    this.errorMessage,
    this.pendingCount = 0,
    this.inProgressCount = 0,
    this.completedCount = 0,
    this.priorityOrder,
    this.todayOrders = const [],
    this.allOrders = const [],
  });

  factory TechnicianInitialState.initial() => const TechnicianInitialState(
        isLoading: true,
      );

  TechnicianInitialState copyWith({
    bool? isLoading,
    bool? isSyncing,
    String? errorMessage,
    int? pendingCount,
    int? inProgressCount,
    int? completedCount,
    WorkOrderEntity? priorityOrder,
    bool clearPriorityOrder = false,
    List<WorkOrderEntity>? todayOrders,
    List<WorkOrderEntity>? allOrders,
  }) {
    return TechnicianInitialState(
      isLoading: isLoading ?? this.isLoading,
      isSyncing: isSyncing ?? this.isSyncing,
      errorMessage: errorMessage,
      pendingCount: pendingCount ?? this.pendingCount,
      inProgressCount: inProgressCount ?? this.inProgressCount,
      completedCount: completedCount ?? this.completedCount,
      priorityOrder:
          clearPriorityOrder ? null : (priorityOrder ?? this.priorityOrder),
      todayOrders: todayOrders ?? this.todayOrders,
      allOrders: allOrders ?? this.allOrders,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is TechnicianInitialState &&
        other.isLoading == isLoading &&
        other.isSyncing == isSyncing &&
        other.errorMessage == errorMessage &&
        other.pendingCount == pendingCount &&
        other.inProgressCount == inProgressCount &&
        other.completedCount == completedCount &&
        other.priorityOrder == priorityOrder &&
        listEquals(other.todayOrders, todayOrders) &&
        listEquals(other.allOrders, allOrders);
  }

  @override
  int get hashCode {
    return Object.hash(
      isLoading,
      isSyncing,
      errorMessage,
      pendingCount,
      inProgressCount,
      completedCount,
      priorityOrder,
      Object.hashAll(todayOrders),
      Object.hashAll(allOrders),
    );
  }
}
