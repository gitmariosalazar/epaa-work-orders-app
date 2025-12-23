// features/work-orders/data/datasources/add_work_order_assignment_remote_dat
import 'package:clean_architecture/core/data_states/data_state.dart';
import 'package:clean_architecture/core/utils/type_defs.dart';
import 'package:clean_architecture/features/work-orders/data/datasource/remote/add_work_order_assignment_remote_data_source.dart';
import 'package:clean_architecture/features/work-orders/data/models/models/add_work_order_assigment_response.dart';
import 'package:clean_architecture/features/work-orders/domain/entities/add_work_order_assignment.dart';
import 'package:clean_architecture/features/work-orders/domain/repositories/add_work_order_assignment_repository.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: AddWorkOrderAssignmentRepository)
class AddWorkOrderAssignmentRepositoryImpl
    implements AddWorkOrderAssignmentRepository {
  final AddWorkOrderAssignmentRemoteDataSource _remoteDataSource;

  AddWorkOrderAssignmentRepositoryImpl({
    required AddWorkOrderAssignmentRemoteDataSource remoteDataSource,
  }) : _remoteDataSource = remoteDataSource;

  @override
  FutureData<List<AddWorkOrderAssignmentEntity>> addAssignmentToWorkOrder(
    List<AddWorkOrderAssignmentEntity> assignments,
  ) async {
    final models = assignments
        .map((entity) => AddWorkOrderAssignmentModel.fromEntity(entity))
        .toList();

    final result = await _remoteDataSource.addAssignmentToWorkOrder(models);

    return result.when(
      success: (addedModels) {
        final entities = addedModels.map((model) => model.toEntity()).toList();
        return SuccessState<List<AddWorkOrderAssignmentEntity>>(data: entities);
      },
      failure: (message, errorType) {
        return FailureState<List<AddWorkOrderAssignmentEntity>>(
          message: message,
          errorType: errorType,
        );
      },
      loading: () {
        return LoadingState<List<AddWorkOrderAssignmentEntity>>();
      },
    );
  }
}
