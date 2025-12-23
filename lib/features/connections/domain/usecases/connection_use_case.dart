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
