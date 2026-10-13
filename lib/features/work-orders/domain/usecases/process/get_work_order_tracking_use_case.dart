import 'package:clean_architecture/core/domain/use_cases/use_case.dart';
import 'package:clean_architecture/core/utils/type_defs.dart';
import 'package:clean_architecture/features/work-orders/domain/entities/work_order_tracking_entity.dart';
import 'package:clean_architecture/features/work-orders/domain/repositories/work_order_repository.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class GetWorkOrderTrackingUseCase
    implements UseCase<WorkOrderTrackingEntity, String> {
  final WorkOrderRepository _repository;

  GetWorkOrderTrackingUseCase(this._repository);

  @override
  FutureData<WorkOrderTrackingEntity> call(String numeroOrden) =>
      _repository.getTrackingByNumeroOrden(numeroOrden);
}
