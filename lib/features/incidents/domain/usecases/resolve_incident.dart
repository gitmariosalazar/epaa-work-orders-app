import 'package:injectable/injectable.dart';
import 'package:clean_architecture/core/utils/type_defs.dart';
import 'package:clean_architecture/core/domain/use_cases/use_case.dart';
import 'package:clean_architecture/features/incidents/data/models/requests/resolve_incident_request.dart';
import 'package:clean_architecture/features/incidents/data/models/models/incident.model.dart';
import 'package:clean_architecture/features/incidents/domain/repositories/incident_repository.dart';

class ResolveIncidentParams {
  final String incidentId;
  final String resolverUserId;
  final ResolveIncidentRequest request;

  const ResolveIncidentParams({
    required this.incidentId,
    required this.resolverUserId,
    required this.request,
  });
}

@lazySingleton
class ResolveIncidentUseCase
    implements UseCase<IncidentModel, ResolveIncidentParams> {
  final IncidentRepository repository;

  ResolveIncidentUseCase(this.repository);

  @override
  FutureData<IncidentModel> call(ResolveIncidentParams params) {
    return repository.resolveIncident(
      incidentId: params.incidentId,
      resolverUserId: params.resolverUserId,
      request: params.request,
    );
  }
}
