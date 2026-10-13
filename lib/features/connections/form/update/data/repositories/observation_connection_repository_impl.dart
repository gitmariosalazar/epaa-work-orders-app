import 'package:clean_architecture/core/network/network_info.dart';
import 'package:clean_architecture/core/network/offline_sync_manager.dart';
import 'package:clean_architecture/features/connections/form/update/data/datasources/observation_connection_remote_data_source.dart';
import 'package:clean_architecture/features/connections/form/update/domain/repositories/observation_connection_repository.dart';
import 'package:clean_architecture/features/connections/form/update/data/mappers/observation_connection_mapper.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: ObservationConnectionRepository)
class ObservationConnectionRepositoryImpl
    implements ObservationConnectionRepository {
  final ObservationConnectionRemoteDataSource remoteDataSource;
  final OfflineSyncManager offlineSyncManager;
  final NetworkInfo networkInfo;

  ObservationConnectionRepositoryImpl({
    required this.remoteDataSource,
    required this.offlineSyncManager,
    required this.networkInfo,
  });

  @override
  Future<void> addObservationConnection({
    required CreateObservationParams params,
  }) async {
    final request =
        ObservationConnectionMapper.toCreateObservationConnectionRequest(
          params,
        );
    
    if (await networkInfo.isConnected) {
      try {
        await remoteDataSource.addObservationConnection(request: request);
      } catch (e) {
        await offlineSyncManager.enqueueTask(
          type: 'observation',
          entityId: request.connectionId,
          payload: request.toJson(),
        );
      }
    } else {
      await offlineSyncManager.enqueueTask(
        type: 'observation',
        entityId: request.connectionId,
        payload: request.toJson(),
      );
    }
  }
}
