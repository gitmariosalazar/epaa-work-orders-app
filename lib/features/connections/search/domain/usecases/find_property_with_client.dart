import 'package:clean_architecture/features/connections/domain/entities/property_with_client.dart';
import 'package:injectable/injectable.dart';
import 'package:clean_architecture/features/connections/search/domain/repositories/connection_with_properties_repository.dart';

@injectable
class FindPropertyWithClient {
  final SearchConnectionRepository repository;

  FindPropertyWithClient(this.repository);

  Future<List<PropertyWithClientEntity>> call(
    String searchValue, {
    int? limit,
    int? offset,
  }) {
    return repository.findPropertyWithClientByCadastralKeyOrCardIdOrLikeName(
      searchValue,
      limit: limit,
      offset: offset,
    );
  }
}
