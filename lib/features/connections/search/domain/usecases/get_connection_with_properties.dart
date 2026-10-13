import 'package:clean_architecture/features/connections/domain/entities/connection.dart';
import 'package:injectable/injectable.dart';
import 'package:clean_architecture/features/connections/search/domain/repositories/connection_with_properties_repository.dart';

@injectable
class GetConnectionWithProperties {
  final ConnectionWithPropertiesRepository repository;

  GetConnectionWithProperties(this.repository);

  Future<ConnectionWithPropertiesEntity> call(String cadastralKey) {
    return repository.getConnectionWithPropertiesByCadastralKey(cadastralKey);
  }
}

@injectable
class GetConnection {
  final SearchConnectionRepository repository;

  GetConnection(this.repository);

  Future<List<ConnectionEntity>> call(String searchValue) {
    return repository.getConnectionByCadastralKeyOrClientIdOrCardId(
      searchValue,
    );
  }
}
