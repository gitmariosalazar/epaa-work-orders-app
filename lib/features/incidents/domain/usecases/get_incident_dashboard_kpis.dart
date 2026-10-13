import 'package:injectable/injectable.dart';
import 'package:clean_architecture/core/utils/type_defs.dart';
import 'package:clean_architecture/features/incidents/data/models/models/incident_kpi.model.dart';
import 'package:clean_architecture/features/incidents/domain/repositories/incident_repository.dart';

@lazySingleton
class GetIncidentDashboardKpis {
  final IncidentRepository repository;

  GetIncidentDashboardKpis(this.repository);

  FutureData<IncidentDashboardKpiResponse> call() async {
    return repository.getIncidentDashboardKpis();
  }
}
