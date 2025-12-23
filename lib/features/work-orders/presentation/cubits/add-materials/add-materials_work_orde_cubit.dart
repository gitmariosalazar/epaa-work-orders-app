import 'package:clean_architecture/features/work-orders/domain/entities/add_material_work_order_entity.dart';
import 'package:clean_architecture/features/work-orders/domain/usecases/add_material_work_order_use_case.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

part 'add-materials_work_order_state.dart';

@lazySingleton
class AddMaterialsWorkOrderCubit extends Cubit<AddMaterialsWorkOrderState> {
  final AddMaterialWorkOrderUseCase _addMaterialsWorkOrderUseCase;

  AddMaterialsWorkOrderCubit({
    required AddMaterialWorkOrderUseCase addMaterialsWorkOrderUseCase,
  }) : _addMaterialsWorkOrderUseCase = addMaterialsWorkOrderUseCase,
       super(AddMaterialsWorkOrderInitial());

  Future<void> addMaterialsToWorkOrder(
    List<AddMaterialWorkOrderEntity> materials
  ) async {
    emit(AddMaterialsWorkOrderLoading());

    try {
      final params = AddMaterialWorkOrderParams(materials: materials);
      final result = await _addMaterialsWorkOrderUseCase(params);
      result.when(
        success: (addedMaterials) {
          emit(AddMaterialsWorkOrderSuccess(addedMaterials));
        },
        failure: (message, errorType) {
          emit(
            AddMaterialsWorkOrderError(
              message ?? 'Error al agregar los materiales',
            ),
          );
        },
        loading: () {
          if (state is! AddMaterialsWorkOrderLoading) if (isClosed) return;
          emit(AddMaterialsWorkOrderLoading());
        },
      );
    } catch (e) {
      emit(AddMaterialsWorkOrderError('Error inesperado: $e'));
    }
  }
}
