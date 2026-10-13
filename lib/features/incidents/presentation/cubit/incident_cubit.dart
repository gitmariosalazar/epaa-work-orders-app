import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:clean_architecture/core/domain/use_cases/use_case.dart';
import 'package:clean_architecture/features/incidents/data/models/requests/create_incident_request.dart';
import 'package:clean_architecture/features/incidents/data/models/requests/resolve_incident_request.dart';
import 'package:clean_architecture/features/incidents/domain/usecases/create_incident.dart';
import 'package:clean_architecture/features/incidents/domain/usecases/resolve_incident.dart';
import 'package:clean_architecture/features/incidents/domain/usecases/find_incidents_by_connection.dart';
import 'package:clean_architecture/features/incidents/domain/usecases/find_incident_by_id.dart';
import 'package:clean_architecture/features/incidents/domain/usecases/find_incidents.dart';
import 'package:clean_architecture/features/incidents/domain/usecases/find_incident_categories.dart';
import 'incident_state.dart';
import 'package:injectable/injectable.dart';

@injectable
class IncidentCubit extends Cubit<IncidentState> {
  final CreateIncidentUseCase createIncidentUseCase;
  final ResolveIncidentUseCase resolveIncidentUseCase;
  final FindIncidentsByConnectionUseCase findIncidentsByConnectionUseCase;
  final FindIncidentByIdUseCase findIncidentByIdUseCase;
  final FindIncidentsUseCase findIncidentsUseCase;
  final FindIncidentCategoriesUseCase findIncidentCategoriesUseCase;

  IncidentCubit({
    required this.createIncidentUseCase,
    required this.resolveIncidentUseCase,
    required this.findIncidentsByConnectionUseCase,
    required this.findIncidentByIdUseCase,
    required this.findIncidentsUseCase,
    required this.findIncidentCategoriesUseCase,
  }) : super(IncidentInitial());

  Future<void> createIncident({required CreateIncidentRequest request}) async {
    emit(IncidentLoading());
    final result = await createIncidentUseCase(request);

    if (isClosed) return;
    result.when(
      success: (newIncident) => emit(
        IncidentOperationSuccess(
          incident: newIncident,
          message: 'Incidente registrado exitosamente.',
        ),
      ),
      failure: (message, _) => emit(IncidentError(message ?? 'Error')),
      loading: () {},
    );
  }

  Future<void> resolveIncident({
    required String incidentId,
    required String resolverUserId,
    required ResolveIncidentRequest request,
  }) async {
    emit(IncidentLoading());
    final result = await resolveIncidentUseCase(
      ResolveIncidentParams(
        incidentId: incidentId,
        resolverUserId: resolverUserId,
        request: request,
      ),
    );

    if (isClosed) return;
    result.when(
      success: (resolvedIncident) => emit(
        IncidentOperationSuccess(
          incident: resolvedIncident,
          message: 'Incidente resuelto exitosamente.',
        ),
      ),
      failure: (message, _) => emit(IncidentError(message ?? 'Error')),
      loading: () {},
    );
  }

  Future<void> loadIncidentsByConnection(String connectionId) async {
    emit(IncidentLoading());
    final result = await findIncidentsByConnectionUseCase(connectionId);

    if (isClosed) return;
    result.when(
      success: (incidents) => emit(IncidentsLoaded(incidents)),
      failure: (message, _) => emit(IncidentError(message ?? 'Error')),
      loading: () {},
    );
  }

  Future<void> loadIncidentById(String incidentId) async {
    emit(IncidentLoading());
    final result = await findIncidentByIdUseCase(incidentId);

    if (isClosed) return;
    result.when(
      success: (incident) => emit(IncidentDetailLoaded(incident)),
      failure: (message, _) => emit(IncidentError(message ?? 'Error')),
      loading: () {},
    );
  }

  Future<void> loadIncidents({
    String? connectionId,
    String? status,
    String? priority,
    int? incidentTypeId,
    int? sector,
  }) async {
    emit(IncidentLoading());
    final result = await findIncidentsUseCase(
      FindIncidentsParams(
        connectionId: connectionId,
        status: status,
        priority: priority,
        incidentTypeId: incidentTypeId,
        sector: sector,
      ),
    );

    if (isClosed) return;
    result.when(
      success: (incidents) => emit(IncidentsLoaded(incidents)),
      failure: (message, _) => emit(IncidentError(message ?? 'Error')),
      loading: () {},
    );
  }

  Future<void> loadIncidentCategories() async {
    emit(IncidentLoading());
    final result = await findIncidentCategoriesUseCase();

    if (isClosed) return;
    result.when(
      success: (categories) => emit(IncidentCategoriesLoaded(categories)),
      failure: (message, _) => emit(IncidentError(message ?? 'Error')),
      loading: () {},
    );
  }
}
