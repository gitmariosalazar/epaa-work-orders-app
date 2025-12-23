import 'package:clean_architecture/core/data_handling/data_handler.dart';
import 'package:clean_architecture/core/services/internet/internet_service.dart';
import 'package:clean_architecture/core/utils/type_defs.dart';
import 'package:injectable/injectable.dart';
import 'package:clean_architecture/core/data_states/data_state.dart';

import 'package:clean_architecture/features/connections/data/datasources/remote/connection_remote_datasource.dart';
import 'package:clean_architecture/features/connections/data/models/connection.dart';
import 'package:clean_architecture/features/connections/domain/entities/connection.dart';
import 'package:clean_architecture/features/connections/domain/repositories/connection_repository.dart';

@LazySingleton(as: ConnectionRepository)
class ConnectionRepositoryImpl implements ConnectionRepository {
  final InternetService _internet;
  final ConnectionRemoteDatasource _remoteDataSource;

  ConnectionRepositoryImpl({
    required InternetService internet,
    required ConnectionRemoteDatasource remoteDataSource,
  }) : _internet = internet,
       _remoteDataSource = remoteDataSource;

  @override
  FutureData<List<ConnectionEntity>> getAllConnections({
    int? limit,
    int? offset,
  }) async {
    final result = await DataHandler.fetchWithFallback<List<ConnectionModel>>(
      _internet.isConnected,
      remoteCallback: () =>
          _remoteDataSource.getAllConnections(limit: limit, offset: offset),
    );
    return result.when(
      success: (models) {
        final entities = models.map((model) => model.toEntity()).toList();
        return SuccessState<List<ConnectionEntity>>(data: entities);
      },
      failure: (message, errorType) {
        return FailureState<List<ConnectionEntity>>(
          message: message,
          errorType: errorType,
        );
      },
      loading: () {
        return LoadingState<List<ConnectionEntity>>();
      },
    );
  }
}
