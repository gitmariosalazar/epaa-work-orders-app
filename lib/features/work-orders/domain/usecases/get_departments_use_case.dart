import 'package:clean_architecture/core/domain/use_cases/use_case.dart';
import 'package:clean_architecture/core/utils/type_defs.dart';
import 'package:clean_architecture/features/work-orders/domain/entities/work_order_entity.dart';
import 'package:clean_architecture/features/work-orders/domain/repositories/work_order_repository.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class GetDepartmentsUseCase
    implements UseCaseNoParameter<List<DepartmentEntity>> {
  final WorkOrderRepository _repository;

  GetDepartmentsUseCase(this._repository);

  @override
  FutureData<List<DepartmentEntity>> call() => _repository.getDepartments();
}
