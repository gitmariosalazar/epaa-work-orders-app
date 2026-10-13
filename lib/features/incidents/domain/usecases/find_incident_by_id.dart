import 'package:injectable/injectable.dart';
import 'package:clean_architecture/core/utils/type_defs.dart';
import 'package:clean_architecture/core/domain/use_cases/use_case.dart';
import 'package:clean_architecture/features/incidents/data/models/models/incident.model.dart';
import 'package:clean_architecture/features/incidents/domain/repositories/incident_repository.dart';

@lazySingleton
class FindIncidentByIdUseCase implements UseCase<IncidentModel, String> {
  final IncidentRepository repository;

  FindIncidentByIdUseCase(this.repository);

  @override
  FutureData<IncidentModel> call(String incidentId) {
    return repository.findById(incidentId);
  }
}
