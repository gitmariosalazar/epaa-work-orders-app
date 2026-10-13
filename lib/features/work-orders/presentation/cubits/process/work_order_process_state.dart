import 'package:clean_architecture/features/work-orders/domain/entities/work_order_detail_entity.dart';
import 'package:clean_architecture/features/work-orders/domain/entities/work_order_tracking_entity.dart';

class WorkOrderProcessState {
  final String orderCode;
  final bool isLoading;
  final bool isActionLoading;
  final String? actionLoadingMessage;
  final WorkOrderDetailEntity? order;
  final WorkOrderTrackingEntity? tracking;
  final String? errorMessage;
  final String? successMessage;
  final int executionSubStep; // 0: Personal y Materiales, 1: Evidencias

  const WorkOrderProcessState({
    this.orderCode = '',
    this.isLoading = false,
    this.isActionLoading = false,
    this.actionLoadingMessage,
    this.order,
    this.tracking,
    this.errorMessage,
    this.successMessage,
    this.executionSubStep = 0,
  });

  WorkOrderProcessState copyWith({
    String? orderCode,
    bool? isLoading,
    bool? isActionLoading,
    String? actionLoadingMessage,
    bool clearActionLoadingMessage = false,
    WorkOrderDetailEntity? order,
    bool clearOrder = false,
    WorkOrderTrackingEntity? tracking,
    bool clearTracking = false,
    String? errorMessage,
    bool clearErrorMessage = false,
    String? successMessage,
    bool clearSuccessMessage = false,
    int? executionSubStep,
  }) {
    return WorkOrderProcessState(
      orderCode: orderCode ?? this.orderCode,
      isLoading: isLoading ?? this.isLoading,
      isActionLoading: isActionLoading ?? this.isActionLoading,
      actionLoadingMessage: clearActionLoadingMessage
          ? null
          : (actionLoadingMessage ?? this.actionLoadingMessage),
      order: clearOrder ? null : (order ?? this.order),
      tracking: clearTracking ? null : (tracking ?? this.tracking),
      errorMessage: clearErrorMessage ? null : (errorMessage ?? this.errorMessage),
      successMessage: clearSuccessMessage
          ? null
          : (successMessage ?? this.successMessage),
      executionSubStep: executionSubStep ?? this.executionSubStep,
    );
  }
}
