import 'package:clean_architecture/features/connections/form/update/domain/repositories/connection_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class UpdateConnectionUseCase {
  final UpdateConnectionRepository repository;

  UpdateConnectionUseCase(this.repository);

  Future<void> call({
    required String connectionId,
    required UpdateConnectionParams params,
  }) {
    return repository.updateConnection(
      connectionId: connectionId,
      params: params,
    );
  }
}
