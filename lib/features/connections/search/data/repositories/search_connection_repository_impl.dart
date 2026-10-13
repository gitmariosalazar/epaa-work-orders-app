import 'package:clean_architecture/core/network/network_info.dart';
import 'package:injectable/injectable.dart';
import 'package:clean_architecture/features/connections/search/data/datasources/local_connection_datasource.dart';
import 'package:clean_architecture/features/connections/search/data/datasources/remote_connection_datasource.dart';
import 'package:clean_architecture/features/connections/search/data/mappers/connection_mapper.dart';
import 'package:clean_architecture/features/connections/domain/entities/connection.dart';
import 'package:clean_architecture/features/connections/domain/entities/property_with_client.dart';
import 'package:clean_architecture/features/connections/search/domain/repositories/connection_with_properties_repository.dart';
import 'package:flutter/foundation.dart';

@LazySingleton(as: SearchConnectionRepository)
class SearchConnectionRepositoryImpl implements SearchConnectionRepository {
  final RemoteConnectionDataSource remoteConnectionDataSource;
  final LocalConnectionDataSource localConnectionDataSource;
  final NetworkInfo networkInfo;

  SearchConnectionRepositoryImpl({
    required this.remoteConnectionDataSource,
    required this.localConnectionDataSource,
    required this.networkInfo,
  });

  @override
  Future<List<ConnectionEntity>> getConnectionByCadastralKeyOrClientIdOrCardId(
    String searchValue,
  ) async {
    if (await networkInfo.isConnected) {
      try {
        final dtoResponse = await remoteConnectionDataSource
            .getConnectionByCadastralKeyOrClientIdOrCardId(searchValue);
        
        // Cachear localmente
        await localConnectionDataSource.cacheConnections(searchValue, dtoResponse);
        
        return dtoResponse.map((e) => e.toEntity()).toList();
      } catch (e) {
        // Fallback local en caso de error del servidor o de red temporal
        final cached = await localConnectionDataSource.getCachedConnections(searchValue);
        if (cached != null && cached.isNotEmpty) {
          return cached.map((e) => e.toEntity()).toList();
        }
        rethrow;
      }
    } else {
      // Offline fallback
      final cached = await localConnectionDataSource.getCachedConnections(searchValue);
      if (cached != null && cached.isNotEmpty) {
        return cached.map((e) => e.toEntity()).toList();
      }
      throw Exception(
        'Sin conexión a internet y no se encontró registro local para: $searchValue',
      );
    }
  }

  @override
  Future<List<PropertyWithClientEntity>> findPropertyWithClientByCadastralKeyOrCardIdOrLikeName(
    String searchValue, {
    int? limit,
    int? offset,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final dtos = await remoteConnectionDataSource
            .findPropertyWithClientByCadastralKeyOrCardIdOrLikeName(
          searchValue,
          limit: limit,
          offset: offset,
        );
        return dtos.map((e) => e.toEntity()).toList();
      } catch (e) {
        debugPrint('Error in findPropertyWithClient: $e');
        rethrow;
      }
    } else {
      throw Exception('Sin conexión a internet para realizar la búsqueda de predios');
    }
  }
}
