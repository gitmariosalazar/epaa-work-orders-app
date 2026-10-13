import 'package:injectable/injectable.dart';
import 'package:clean_architecture/core/data_states/data_state.dart';
import 'package:clean_architecture/core/utils/type_defs.dart';
import 'package:clean_architecture/features/incidents/data/models/models/incident_detail_row_response.dart';
import 'package:clean_architecture/features/incidents/data/models/models/incident_kpi.model.dart';
import 'package:clean_architecture/features/incidents/data/datasources/incident_remote_datasource.dart';
import 'package:clean_architecture/features/incidents/data/models/requests/create_incident_request.dart';
import 'package:clean_architecture/features/incidents/data/models/requests/resolve_incident_request.dart';
import 'package:clean_architecture/features/incidents/data/models/models/incident-category.model.dart';
import 'package:clean_architecture/features/incidents/data/models/models/incident.model.dart';
import 'package:clean_architecture/features/incidents/domain/repositories/incident_repository.dart';

@LazySingleton(as: IncidentRepository)
class IncidentRepositoryImpl implements IncidentRepository {
  final IncidentRemoteDataSource remoteDataSource;

  IncidentRepositoryImpl({required this.remoteDataSource});

  @override
  FutureData<IncidentModel> createIncident({
    required CreateIncidentRequest request,
  }) async {
    try {
      final result = await remoteDataSource.createIncident(request: request);
      return SuccessState(data: result);
    } on ServerException catch (e) {
      return FailureState(message: e.message);
    } catch (e) {
      return FailureState(message: 'Error al registrar el incidente: $e');
    }
  }

  @override
  FutureData<IncidentModel> resolveIncident({
    required String incidentId,
    required String resolverUserId,
    required ResolveIncidentRequest request,
  }) async {
    try {
      final result = await remoteDataSource.resolveIncident(
        incidentId: incidentId,
        resolverUserId: resolverUserId,
        request: request,
      );
      return SuccessState(data: result);
    } on ServerException catch (e) {
      return FailureState(message: e.message);
    } catch (e) {
      return FailureState(message: 'Error al resolver el incidente: $e');
    }
  }

  @override
  FutureData<List<IncidentDetailRowResponse>>
  findIncidentsByConnection(String connectionId) async {
    try {
      final list = await remoteDataSource.findIncidentsByConnection(
        connectionId,
      );
      return SuccessState(data: list);
    } on ServerException catch (e) {
      return FailureState(message: e.message);
    } catch (e) {
      return FailureState(message: 'Error al buscar incidentes de la conexión: $e');
    }
  }

  @override
  FutureData<IncidentModel> findById(String incidentId) async {
    try {
      final incident = await remoteDataSource.findById(incidentId);
      return SuccessState(data: incident);
    } on ServerException catch (e) {
      return FailureState(message: e.message);
    } catch (e) {
      return FailureState(message: 'Error al buscar el incidente por ID: $e');
    }
  }

  @override
  FutureData<List<IncidentDetailRowResponse>> findIncidents({
    String? connectionId,
    String? status,
    String? priority,
    int? incidentTypeId,
    int? sector,
  }) async {
    try {
      final list = await remoteDataSource.findIncidents(
        connectionId: connectionId,
        status: status,
        priority: priority,
        incidentTypeId: incidentTypeId,
        sector: sector,
      );
      return SuccessState(data: list);
    } on ServerException catch (e) {
      return FailureState(message: e.message);
    } catch (e) {
      return FailureState(message: 'Error al filtrar incidentes: $e');
    }
  }

  @override
  FutureData<List<IncidentCategoryModel>>
  findIncidentCategories() async {
    try {
      final categories = await remoteDataSource.findIncidentCategories();
      return SuccessState(data: categories);
    } on ServerException catch (e) {
      return FailureState(message: e.message);
    } catch (e) {
      return FailureState(message: 'Error al obtener categorías de incidentes: $e');
    }
  }

  @override
  FutureData<IncidentDashboardKpiResponse>
  getIncidentDashboardKpis() async {
    try {
      final kpis = await remoteDataSource.getIncidentDashboardKpis();
      return SuccessState(data: kpis);
    } on ServerException catch (e) {
      return FailureState(message: e.message);
    } catch (e) {
      return FailureState(message: e.toString());
    }
  }
}
