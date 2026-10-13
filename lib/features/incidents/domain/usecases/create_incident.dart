import 'package:injectable/injectable.dart';
import 'package:clean_architecture/core/utils/type_defs.dart';
import 'package:clean_architecture/core/domain/use_cases/use_case.dart';
import 'package:clean_architecture/features/incidents/data/models/requests/create_incident_request.dart';
import 'package:clean_architecture/features/incidents/data/models/models/incident.model.dart';
import 'package:clean_architecture/features/incidents/domain/repositories/incident_repository.dart';

@lazySingleton
class CreateIncidentUseCase
    implements UseCase<IncidentModel, CreateIncidentRequest> {
  final IncidentRepository repository;

  CreateIncidentUseCase(this.repository);

  @override
  FutureData<IncidentModel> call(CreateIncidentRequest params) {
    return repository.createIncident(request: params);
  }
}
