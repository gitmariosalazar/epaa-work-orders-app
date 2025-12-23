import 'package:clean_architecture/core/utils/type_defs.dart';
import 'package:clean_architecture/features/work-orders/domain/entities/work_order_entity.dart';

abstract interface class WorkOrderRepository {
  FutureData<List<WorkOrderEntity>> getAllWorkOrders();
  FutureData<WorkOrderEntity> createWorkOrder(WorkOrderEntity order);
}
