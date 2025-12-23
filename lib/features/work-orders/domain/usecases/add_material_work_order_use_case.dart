import 'package:clean_architecture/core/data_states/data_state.dart';
import 'package:clean_architecture/core/domain/use_cases/use_case.dart';
import 'package:clean_architecture/core/utils/type_defs.dart';
import 'package:clean_architecture/features/work-orders/domain/entities/add_material_work_order_entity.dart';
import 'package:clean_architecture/features/work-orders/domain/repositories/add_material_work_order_repository.dart';

import 'package:injectable/injectable.dart';

@lazySingleton
class AddMaterialWorkOrderUseCase
    implements
        UseCase<List<AddMaterialWorkOrderEntity>, AddMaterialWorkOrderParams> {
  final AddMaterialWorkOrderRepository _repository;

  AddMaterialWorkOrderUseCase(this._repository);

  @override
  FutureData<List<AddMaterialWorkOrderEntity>> call(
    AddMaterialWorkOrderParams params,
  ) async {
    try {
      final result = await _repository.addMaterialToWorkOrders(
        params.materials,
      );
      return SuccessState<List<AddMaterialWorkOrderEntity>>(
        data: result is SuccessState ? result.data : [],
      );
    } catch (e) {
      return FailureState<List<AddMaterialWorkOrderEntity>>(
        message: e.toString(),
        errorType: ErrorType.unknown,
      );
    }
  }
}

/// Parámetros para el UseCase
/// Contiene la lista de materiales a agregar
class AddMaterialWorkOrderParams {
  final List<AddMaterialWorkOrderEntity> materials;
  AddMaterialWorkOrderParams({required this.materials});
}
