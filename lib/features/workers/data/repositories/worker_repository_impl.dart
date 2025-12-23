import 'package:clean_architecture/core/data_handling/data_handler.dart';
import 'package:clean_architecture/core/data_states/data_state.dart';
import 'package:clean_architecture/core/services/internet/internet_service.dart';
import 'package:clean_architecture/core/utils/type_defs.dart';
import 'package:clean_architecture/features/workers/data/datasource/worker_remote_datasource.dart';
import 'package:clean_architecture/features/workers/data/models/models/worker_model.dart';
import 'package:clean_architecture/features/workers/domain/entities/worker_entity.dart';
import 'package:clean_architecture/features/workers/domain/repositories/worker_repository.dart';
import 'package:flutter/widgets.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: WorkerRepository)
class WorkerRepositoryImpl implements WorkerRepository {
  final InternetService _internetService;
  final WorkerRemoteDatasource _remoteDatasource;

  WorkerRepositoryImpl({
    required InternetService internetService,
    required WorkerRemoteDatasource remoteDatasource,
  }) : _internetService = internetService,

       _remoteDatasource = remoteDatasource;

  @override
  FutureData<List<WorkerEntity>> getAllWorkers() async {
    final result = await DataHandler.fetchWithFallback<List<WorkerModel>>(
      _internetService.isConnected,
      remoteCallback: _remoteDatasource.getAllWorkers,
    );

    return result.when(
      success: (models) {
        debugPrint('Models fetched: ${models[0].firstNames}');
        final entities = models.map((model) => model.toEntity()).toList();
        return SuccessState<List<WorkerEntity>>(data: entities);
      },
      failure: (message, errorType) {
        return FailureState<List<WorkerEntity>>(
          message: message,
          errorType: errorType,
        );
      },
      loading: () {
        return LoadingState<List<WorkerEntity>>();
      },
    );
  }
}
