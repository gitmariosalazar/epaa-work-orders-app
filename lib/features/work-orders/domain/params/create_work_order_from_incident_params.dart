import 'package:equatable/equatable.dart';

/// Comando para generar una OT a partir de una incidencia.
/// Equivale a `CreateWorkOrderFromIncidentCommand` de epaa-web.
class CreateWorkOrderFromIncidentParams extends Equatable {
  final String incidentCode;

  /// Técnico inspector asignado (userId). Opcional en el backend.
  final String? userIdAssignee;

  const CreateWorkOrderFromIncidentParams({
    required this.incidentCode,
    this.userIdAssignee,
  });

  @override
  List<Object?> get props => [incidentCode, userIdAssignee];
}
