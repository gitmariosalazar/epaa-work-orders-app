import 'package:injectable/injectable.dart';
import 'package:clean_architecture/features/incidents/data/models/models/incident_detail_row_response.dart';
import 'package:clean_architecture/core/utils/type_defs.dart';
import 'package:clean_architecture/core/domain/use_cases/use_case.dart';
import 'package:clean_architecture/features/incidents/domain/repositories/incident_repository.dart';

@lazySingleton
class FindIncidentsByConnectionUseCase
    implements UseCase<List<IncidentDetailRowResponse>, String> {
  final IncidentRepository repository;

  FindIncidentsByConnectionUseCase(this.repository);

  @override
  FutureData<List<IncidentDetailRowResponse>> call(
    String connectionId,
  ) {
    return repository.findIncidentsByConnection(connectionId);
  }
}
