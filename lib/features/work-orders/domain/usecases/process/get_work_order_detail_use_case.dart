import 'package:clean_architecture/core/domain/use_cases/use_case.dart';
import 'package:clean_architecture/core/utils/type_defs.dart';
import 'package:clean_architecture/features/work-orders/domain/entities/work_order_detail_entity.dart';
import 'package:clean_architecture/features/work-orders/domain/repositories/work_order_repository.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class GetWorkOrderDetailUseCase
    implements UseCase<WorkOrderDetailEntity, String> {
  final WorkOrderRepository _repository;

  GetWorkOrderDetailUseCase(this._repository);

  @override
  FutureData<WorkOrderDetailEntity> call(String numeroOrden) =>
      _repository.getDetalleByNumeroOrden(numeroOrden);
}
