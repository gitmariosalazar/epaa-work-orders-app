import 'package:clean_architecture/core/utils/type_defs.dart';
import 'package:clean_architecture/features/connections/data/datasources/remote/connection_remote_datasource.dart';
import 'package:clean_architecture/features/connections/domain/entities/connection.dart';
import 'package:clean_architecture/features/connections/domain/repositories/connection_repository.dart';
import 'package:clean_architecture/features/connections/data/models/connection.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: ConnectionRepository)
class ConnectionRepositoryImpl implements ConnectionRepository {
  final ConnectionRemoteDatasource _remoteDatasource;

  const ConnectionRepositoryImpl({
    required ConnectionRemoteDatasource remoteDatasource,
  }) : _remoteDatasource = remoteDatasource;

  @override
  FutureData<List<ConnectionEntity>> getAllConnections({
    int? limit,
    int? offset,
  }) async {
    final response = await _remoteDatasource.getAllConnections(
      limit: limit,
      offset: offset,
    );
    return response.mapData((data) => data.map((e) => e.toEntity()).toList());
  }
}

@LazySingleton(as: ConnectionPaginatedRepository)
class ConnectionPaginatedRepositoryImpl
    implements ConnectionPaginatedRepository {
  final ConnectionPaginatedRemoteDatasource _remoteDatasource;

  const ConnectionPaginatedRepositoryImpl({
    required ConnectionPaginatedRemoteDatasource remoteDatasource,
  }) : _remoteDatasource = remoteDatasource;

  @override
  FutureData<List<ConnectionEntity>> getAllConnectionsPaginated({
    required int limit,
    required int offset,
    required String? query,
  }) async {
    final response = await _remoteDatasource.getAllConnectionsPaginated(
      limit: limit,
      offset: offset,
      query: query,
    );
    return response.mapData((data) => data.map((e) => e.toEntity()).toList());
  }
}
