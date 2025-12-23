import 'package:clean_architecture/core/utils/type_defs.dart';
import 'package:clean_architecture/features/work-orders/domain/entities/add_work_order_assignment.dart';

abstract interface class AddWorkOrderAssignmentRepository {
  FutureData<List<AddWorkOrderAssignmentEntity>> addAssignmentToWorkOrder(
    List<AddWorkOrderAssignmentEntity> assignments,
  );
}
