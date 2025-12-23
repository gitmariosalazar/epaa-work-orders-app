import 'package:clean_architecture/core/domain/use_cases/use_case.dart';
import 'package:clean_architecture/core/utils/type_defs.dart';
import 'package:clean_architecture/features/work-orders/domain/entities/work_order_entity.dart';
import 'package:clean_architecture/features/work-orders/domain/repositories/work_order_repository.dart';
import 'package:injectable/injectable.dart';

@LazySingleton()
class GetAllWorkOrdersUseCase
    implements UseCaseNoParameter<List<WorkOrderEntity>> {
  final WorkOrderRepository _repository;

  GetAllWorkOrdersUseCase(
    this._repository,
  ); // incluso más corto con constructor sintáctico

  @override
  FutureData<List<WorkOrderEntity>> call() => _repository.getAllWorkOrders();
}
