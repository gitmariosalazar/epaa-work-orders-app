import 'package:clean_architecture/features/connections/form/update/domain/repositories/observation_connection_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class AddObservationConnectionUseCase {
  final ObservationConnectionRepository repository;

  AddObservationConnectionUseCase(this.repository);
  Future<void> call({required CreateObservationParams params}) async {
    return await repository.addObservationConnection(params: params);
  }
}