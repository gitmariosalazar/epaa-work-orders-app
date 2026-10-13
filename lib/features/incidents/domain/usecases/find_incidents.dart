import 'package:injectable/injectable.dart';
import 'package:clean_architecture/features/incidents/data/models/models/incident_detail_row_response.dart';
import 'package:clean_architecture/core/utils/type_defs.dart';
import 'package:clean_architecture/core/domain/use_cases/use_case.dart';
import 'package:clean_architecture/features/incidents/domain/repositories/incident_repository.dart';

@lazySingleton
@lazySingleton
class FindIncidentsParams {
  final String? connectionId;
  final String? status;
  final String? priority;
  final int? incidentTypeId;
  final int? sector;

  const FindIncidentsParams({
    this.connectionId,
    this.status,
    this.priority,
    this.incidentTypeId,
    this.sector,
  });
}

@lazySingleton
class FindIncidentsUseCase
    implements UseCase<List<IncidentDetailRowResponse>, FindIncidentsParams> {
  final IncidentRepository repository;

  FindIncidentsUseCase(this.repository);

  @override
  FutureData<List<IncidentDetailRowResponse>> call(
    FindIncidentsParams params,
  ) {
    return repository.findIncidents(
      connectionId: params.connectionId,
      status: params.status,
      priority: params.priority,
      incidentTypeId: params.incidentTypeId,
      sector: params.sector,
    );
  }
}
