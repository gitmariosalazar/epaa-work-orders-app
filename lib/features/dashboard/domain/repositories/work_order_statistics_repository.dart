// features/dashboard/domain/repositories/work_order_statistics_repository.dart

import 'package:clean_architecture/core/utils/type_defs.dart';
import 'package:clean_architecture/features/dashboard/domain/entities/work_order_statistics_entities.dart';

/// Contrato de solo-lectura para estadísticas de órdenes de trabajo.
///
/// Se mantiene separado de `WorkOrderRepository` (ISP): los dashboards no
/// necesitan conocer las operaciones de proceso de una orden.
abstract interface class WorkOrderStatisticsRepository {
  FutureData<List<WorkOrderPriorityStatisticEntity>> getPriorityStatistics();
  FutureData<List<WorkOrderStatusStatisticEntity>> getStatusStatistics();
  FutureData<List<WorkOrderTypeStatisticEntity>> getTypeStatistics();
  FutureData<List<WorkOrdersKeyStatisticEntity>> getKeyStatistics();
}
