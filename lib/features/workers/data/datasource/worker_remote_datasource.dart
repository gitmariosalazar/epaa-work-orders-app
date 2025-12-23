import 'package:clean_architecture/core/constants/api_endpoints.dart';
import 'package:clean_architecture/core/data_handling/data_handler.dart';
import 'package:clean_architecture/core/services/api/api_service.dart';
import 'package:clean_architecture/core/utils/type_defs.dart';
import 'package:clean_architecture/features/workers/data/models/models/worker_model.dart';
import 'package:injectable/injectable.dart';

abstract interface class WorkerRemoteDatasource {
  FutureData<List<WorkerModel>> getAllWorkers();
}

@LazySingleton(as: WorkerRemoteDatasource)
class WorkerRemoteDatasourceImpl implements WorkerRemoteDatasource {
  final ApiService _apiService;
  const WorkerRemoteDatasourceImpl({required ApiService apiService})
    : _apiService = apiService;
  @override
  FutureData<List<WorkerModel>> getAllWorkers() {
    return DataHandler.safeApiCall<List<WorkerModel>, WorkerModel>(
      request: () => _apiService.get(ApiEndpoints.getAllWorkers),
      fromJson: (json) => WorkerModel.fromJson(json),
      isStandardResponse: true,
      responseDataKey: 'data',
    );
  }
}
