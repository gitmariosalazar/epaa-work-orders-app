import 'package:clean_architecture/core/network/network_info.dart';
import 'package:injectable/injectable.dart';
import 'package:clean_architecture/core/network/offline_sync_manager.dart';
import 'package:clean_architecture/features/connections/form/update/data/datasources/connection_remote_data_source.dart';
import 'package:clean_architecture/features/connections/form/update/data/mappers/connection_mapper.dart';
import 'package:clean_architecture/features/connections/form/update/domain/repositories/connection_repository.dart';
import 'package:clean_architecture/features/connections/form/update/data/models/dto/request/change_meter_request.dart';

@LazySingleton(as: UpdateConnectionRepository)
class UpdateConnectionRepositoryImpl implements UpdateConnectionRepository {
  final ConnectionRemoteDataSource remoteDataSource;
  final OfflineSyncManager offlineSyncManager;
  final NetworkInfo networkInfo;

  UpdateConnectionRepositoryImpl({
    required this.remoteDataSource,
    required this.offlineSyncManager,
    required this.networkInfo,
  });

  @override
  Future<void> updateConnection({
    required String connectionId,
    required UpdateConnectionParams params,
  }) async {
    final request = ConnectionMapper.toRequest(params, connectionId);
    
    if (await networkInfo.isConnected) {
      try {
        await remoteDataSource.updateConnection(
          connectionId: connectionId,
          request: request,
        );
      } catch (e) {
        // En caso de fallo temporal de red/servidor, encolamos localmente
        await offlineSyncManager.enqueueTask(
          type: 'connection',
          entityId: connectionId,
          payload: request.toJson(),
        );
      }
    } else {
      // Encolado offline
      await offlineSyncManager.enqueueTask(
        type: 'connection',
        entityId: connectionId,
        payload: request.toJson(),
      );
    }
  }

  @override
  Future<void> changeMeter(ChangeMeterRequest request) async {
    if (await networkInfo.isConnected) {
      await remoteDataSource.changeMeter(request: request);
    } else {
      throw Exception('No hay conexión a internet para subir las fotos y cambiar el medidor.');
    }
  }
}
