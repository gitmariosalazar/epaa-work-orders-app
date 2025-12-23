import 'package:clean_architecture/core/constants/api_endpoints.dart';
import 'package:clean_architecture/core/data_handling/data_handler.dart';
import 'package:clean_architecture/core/services/api/api_service.dart';
import 'package:clean_architecture/core/utils/type_defs.dart';
import 'package:clean_architecture/features/work-orders/data/models/models/add_work_order_assigment_response.dart';
import 'package:injectable/injectable.dart';

abstract class AddWorkOrderAssignmentRemoteDataSource {
  FutureData<List<AddWorkOrderAssignmentModel>> addAssignmentToWorkOrder(
    List<AddWorkOrderAssignmentModel> assignments,
  );
}

@LazySingleton(as: AddWorkOrderAssignmentRemoteDataSource)
class AddWorkOrderAssignmentRemoteDataSourceImpl
    implements AddWorkOrderAssignmentRemoteDataSource {
  final ApiService _apiService;
  const AddWorkOrderAssignmentRemoteDataSourceImpl({
    required ApiService apiService,
  }) : _apiService = apiService;
  @override
  FutureData<List<AddWorkOrderAssignmentModel>> addAssignmentToWorkOrder(
    List<AddWorkOrderAssignmentModel> assignments,
  ) {
    // Implementa la llamada a la API para agregar asignaciones a la orden de trabajo
    return DataHandler.safeApiCall<
      List<AddWorkOrderAssignmentModel>,
      AddWorkOrderAssignmentModel
    >(
      request: () => _apiService.post(
        ApiEndpoints.addWorkOrderAssignment,
        data: assignments.map((e) => e.toJson()).toList(),
      ),
      fromJson: (json) => AddWorkOrderAssignmentModel.fromJson(json),
      isStandardResponse: true,
      responseDataKey: 'data',
    );
  }
}
