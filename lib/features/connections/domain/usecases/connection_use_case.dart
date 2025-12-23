import 'package:clean_architecture/core/domain/use_cases/use_case.dart';
import 'package:clean_architecture/core/utils/type_defs.dart';
import 'package:clean_architecture/features/connections/domain/entities/connection.dart';
import 'package:clean_architecture/features/connections/domain/repositories/connection_repository.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class GetAllConnectionsUseCase
    implements UseCaseNoParameter<List<ConnectionEntity>> {
  final ConnectionRepository _repository;

  GetAllConnectionsUseCase(this._repository);

  @override
  FutureData<List<ConnectionEntity>> call({int? limit, int? offset}) =>
      _repository.getAllConnections(limit: limit, offset: offset);
}

@lazySingleton
class GetAllConnectionsPaginatedUseCase
    implements UseCase<List<ConnectionEntity>, ConnectionPaginatedParams> {
  final ConnectionPaginatedRepository _repository;
  GetAllConnectionsPaginatedUseCase(this._repository);
  @override
  FutureData<List<ConnectionEntity>> call(ConnectionPaginatedParams params) =>
      _repository.getAllConnectionsPaginated(
        limit: params.limit,
        offset: params.offset,
        query: params.query,
      );
}

class ConnectionPaginatedParams {
  final int limit;
  final int offset;
  final String? query;

  ConnectionPaginatedParams({
    required this.limit,
    required this.offset,
    this.query,
  });
}
