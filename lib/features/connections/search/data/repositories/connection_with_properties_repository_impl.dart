import 'package:clean_architecture/features/connections/search/data/datasources/remote_connection_with_properties_datasource.dart';
import 'package:injectable/injectable.dart';
import 'package:clean_architecture/features/connections/domain/entities/connection.dart';
import 'package:clean_architecture/features/connections/search/domain/repositories/connection_with_properties_repository.dart';
import 'package:clean_architecture/features/connections/search/data/mappers/connection_with_properties_mapper.dart';
import 'package:clean_architecture/features/connections/search/data/datasources/local_connection_datasource.dart';
import 'package:clean_architecture/core/network/network_info.dart';

@LazySingleton(as: ConnectionWithPropertiesRepository)
class ConnectionWithPropertiesRepositoryImpl
    implements ConnectionWithPropertiesRepository {
  final RemoteConnectionWithPropertiesDataSource
  remoteConnectionWithPropertiesDataSource;
  final LocalConnectionDataSource localConnectionDataSource;
  final NetworkInfo networkInfo;

  ConnectionWithPropertiesRepositoryImpl({
    required this.remoteConnectionWithPropertiesDataSource,
    required this.localConnectionDataSource,
    required this.networkInfo,
  });

  @override
  Future<ConnectionWithPropertiesEntity>
  getConnectionWithPropertiesByCadastralKey(String cadastralKey) async {
    if (await networkInfo.isConnected) {
      try {
        final dtoResponse = await remoteConnectionWithPropertiesDataSource
            .getConnectionWithProperties(cadastralKey);
        
        // Cachear localmente
        await localConnectionDataSource.cacheConnectionWithProperties(cadastralKey, dtoResponse);
        
        return dtoResponse.toEntity();
      } catch (e) {
        // Fallback local en caso de error remoto temporal
        final cached = await localConnectionDataSource.getCachedConnectionWithProperties(cadastralKey);
        if (cached != null) {
          return cached.toEntity();
        }
        rethrow;
      }
    } else {
      // Offline fallback
      final cached = await localConnectionDataSource.getCachedConnectionWithProperties(cadastralKey);
      if (cached != null) {
        return cached.toEntity();
      }
      throw Exception(
        'Sin conexión a internet y no se encontró registro local detallado para la clave catastral: $cadastralKey',
      );
    }
  }
}
