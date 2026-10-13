import 'package:clean_architecture/core/domain/use_cases/use_case.dart';
import 'package:clean_architecture/core/utils/type_defs.dart';
import 'package:clean_architecture/features/work-orders/domain/params/create_work_order_from_incident_params.dart';
import 'package:clean_architecture/features/work-orders/domain/repositories/work_order_repository.dart';
import 'package:injectable/injectable.dart';

/// POST process-work-orders/create-work-order-from-incident
/// (equivale a `CreateWorkOrderFromIncidentUseCase` de epaa-web).
@lazySingleton
class CreateWorkOrderFromIncidentUseCase
    implements UseCase<void, CreateWorkOrderFromIncidentParams> {
  final WorkOrderRepository _repository;

  CreateWorkOrderFromIncidentUseCase(this._repository);

  @override
  FutureData<void> call(CreateWorkOrderFromIncidentParams params) =>
      _repository.createWorkOrderFromIncident(params);
}
