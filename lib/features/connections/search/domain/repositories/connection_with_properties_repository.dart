import 'package:clean_architecture/features/connections/domain/entities/connection.dart';
import 'package:clean_architecture/features/connections/domain/entities/property_with_client.dart';

abstract class ConnectionWithPropertiesRepository {
  Future<ConnectionWithPropertiesEntity>
  getConnectionWithPropertiesByCadastralKey(String cadastralKey);
}

abstract class SearchConnectionRepository {
  Future<List<ConnectionEntity>> getConnectionByCadastralKeyOrClientIdOrCardId(
    String searchValue,
  );

  Future<List<PropertyWithClientEntity>> findPropertyWithClientByCadastralKeyOrCardIdOrLikeName(
    String searchValue, {
    int? limit,
    int? offset,
  });
}
