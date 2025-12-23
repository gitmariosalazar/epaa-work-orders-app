// features/work-orders/domain/usecases/create_work_order_use_case.dart

import 'package:clean_architecture/core/domain/use_cases/use_case.dart';
import 'package:clean_architecture/core/utils/type_defs.dart';
import 'package:clean_architecture/features/work-orders/domain/entities/work_order_entity.dart';
import 'package:clean_architecture/features/work-orders/domain/repositories/work_order_repository.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class CreateWorkOrderUseCase
    implements UseCase<WorkOrderEntity, WorkOrderEntity> {
  final WorkOrderRepository _repository;

  CreateWorkOrderUseCase(this._repository);

  @override
  FutureData<WorkOrderEntity> call(WorkOrderEntity params) {
    return _repository.createWorkOrder(params);
  }
}
