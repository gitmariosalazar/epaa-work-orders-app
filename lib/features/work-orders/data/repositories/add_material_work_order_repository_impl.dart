import 'package:clean_architecture/core/data_states/data_state.dart';
import 'package:clean_architecture/core/utils/type_defs.dart';
import 'package:clean_architecture/features/work-orders/data/datasource/remote/add_material_work_order_remote_datasource.dart';
import 'package:clean_architecture/features/work-orders/data/models/models/add_material_work_order_response.dart';
import 'package:clean_architecture/features/work-orders/domain/entities/add_material_work_order_entity.dart';
import 'package:clean_architecture/features/work-orders/domain/repositories/add_material_work_order_repository.dart';

import 'package:injectable/injectable.dart';

@LazySingleton(as: AddMaterialWorkOrderRepository)
class AddMaterialWorkOrderRepositoryImpl
    implements AddMaterialWorkOrderRepository {
  final AddMaterialWorkOrderRemoteDatasource _remoteDataSource;
  AddMaterialWorkOrderRepositoryImpl({
    required AddMaterialWorkOrderRemoteDatasource remoteDataSource,
  }) : _remoteDataSource = remoteDataSource;

  @override
  FutureData<List<AddMaterialWorkOrderEntity>> addMaterialToWorkOrders(
    List<AddMaterialWorkOrderEntity> materials,
  ) async {
    final models = materials
        .map((entity) => AddMaterialWorkOrderModel.fromEntity(entity))
        .toList();

    final result = await _remoteDataSource.addMaterialToWorkOrders(models);

    return result.when(
      success: (addedModels) {
        final entities = addedModels.map((model) => model.toEntity()).toList();
        return SuccessState<List<AddMaterialWorkOrderEntity>>(data: entities);
      },
      failure: (message, errorType) {
        return FailureState<List<AddMaterialWorkOrderEntity>>(
          message: message,
          errorType: errorType,
        );
      },
      loading: () {
        return LoadingState<List<AddMaterialWorkOrderEntity>>();
      },
    );
  }
}
