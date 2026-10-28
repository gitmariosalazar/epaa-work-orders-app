import 'package:clean_architecture/core/utils/type_defs.dart';
import 'package:clean_architecture/features/incidents/data/models/models/incident_detail_row_response.dart';
import 'package:clean_architecture/features/incidents/data/models/models/incident_kpi.model.dart';
import 'package:clean_architecture/features/incidents/data/models/requests/create_incident_request.dart';
import 'package:clean_architecture/features/incidents/data/models/requests/resolve_incident_request.dart';
import 'package:clean_architecture/features/incidents/data/models/models/incident-category.model.dart';
import 'package:clean_architecture/features/incidents/data/models/models/incident.model.dart';

/// Repository interface for Incident operations.
/// Follows LSP (Liskov Substitution Principle) and ISP (Interface Segregation Principle).
abstract class IncidentRepository {
  FutureData<IncidentModel> createIncident({
    required CreateIncidentRequest request,
  });

  FutureData<IncidentModel> resolveIncident({
    required String incidentId,
    required String resolverUserId,
    required ResolveIncidentRequest request,
  });

  FutureData<List<IncidentDetailRowResponse>> findIncidentsByConnection(
    String connectionId,
  );

  FutureData<IncidentModel> findById(String incidentId);

  FutureData<List<IncidentDetailRowResponse>> findIncidents({
    String? connectionId,
    String? status,
    String? priority,
    int? incidentTypeId,
    int? sector,
  });

  FutureData<List<IncidentCategoryModel>> findIncidentCategories();

  FutureData<IncidentDashboardKpiResponse> getIncidentDashboardKpis();
}
