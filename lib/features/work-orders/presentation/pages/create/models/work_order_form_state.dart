import 'package:clean_architecture/features/connections/domain/entities/connection.dart';
import 'package:clean_architecture/features/work-orders/domain/entities/work_order_entity.dart';

class WorkOrderFormState {
  // Step 1: Client data
  final String clientId;
  final String clientName;
  final String clientEmail;
  final String clientPhone;
  final String tipoPersona; // 'NATURAL' | 'JURIDICA'
  final ConnectionEntity? selectedConnection;

  // Step 2: Order details
  final String origin;
  final int workTypeId;
  final int priorityId;
  final String cadastralKey;
  final String location;
  final String description;
  final double? latitude;
  final double? longitude;

  const WorkOrderFormState({
    this.clientId = '',
    this.clientName = '',
    this.clientEmail = '',
    this.clientPhone = '',
    this.tipoPersona = 'NATURAL',
    this.selectedConnection,
    this.origin = 'SOLICITUD',
    this.workTypeId = 1,
    this.priorityId = 2,
    this.cadastralKey = '',
    this.location = '',
    this.description = '',
    this.latitude,
    this.longitude,
  });

  WorkOrderFormState copyWith({
    String? clientId,
    String? clientName,
    String? clientEmail,
    String? clientPhone,
    String? tipoPersona,
    ConnectionEntity? selectedConnection,
    bool clearSelectedConnection = false,
    String? origin,
    int? workTypeId,
    int? priorityId,
    String? cadastralKey,
    String? location,
    String? description,
    double? latitude,
    double? longitude,
    bool clearCoordinates = false,
  }) {
    return WorkOrderFormState(
      clientId: clientId ?? this.clientId,
      clientName: clientName ?? this.clientName,
      clientEmail: clientEmail ?? this.clientEmail,
      clientPhone: clientPhone ?? this.clientPhone,
      tipoPersona: tipoPersona ?? this.tipoPersona,
      selectedConnection: clearSelectedConnection
          ? null
          : (selectedConnection ?? this.selectedConnection),
      origin: origin ?? this.origin,
      workTypeId: workTypeId ?? this.workTypeId,
      priorityId: priorityId ?? this.priorityId,
      cadastralKey: cadastralKey ?? this.cadastralKey,
      location: location ?? this.location,
      description: description ?? this.description,
      latitude: clearCoordinates ? null : (latitude ?? this.latitude),
      longitude: clearCoordinates ? null : (longitude ?? this.longitude),
    );
  }

  WorkOrderEntity toEntity({required String createdByUserId}) {
    return WorkOrderEntity(
      origin: origin,
      workTypeId: workTypeId,
      priorityId: priorityId,
      clientId: clientId,
      cadastralKey: cadastralKey,
      location: location,
      description: description,
      latitude: latitude,
      longitude: longitude,
      createdByUserId: createdByUserId,
      status: 'NOTIFICADA', // NOTIFICADA
    );
  }
}

class StepValidationResult {
  final bool isValid;
  final Map<String, String> errors;

  const StepValidationResult({required this.isValid, required this.errors});
}

abstract class WorkOrderValidationHelper {
  static StepValidationResult validateStep(int step, WorkOrderFormState form) {
    final Map<String, String> errors = {};

    if (step == 1) {
      if (form.clientId.trim().isEmpty) {
        errors['clientId'] =
            'Busque por cédula o clave catastral y seleccione una acometida.';
      }
      if (form.clientName.trim().isEmpty) {
        errors['clientName'] =
            'No se ha seleccionado un cliente. Realice una búsqueda.';
      }
      if (form.cadastralKey.trim().isEmpty) {
        errors['cadastralKey'] =
            'Seleccione una acometida de los resultados de búsqueda.';
      }
    } else if (step == 2) {
      if (form.location.trim().isEmpty) {
        errors['location'] = 'La dirección / lugar del trabajo es obligatoria.';
      }
      if (form.workTypeId <= 0) {
        errors['workTypeId'] = 'Seleccione el tipo de trabajo.';
      }
      if (form.priorityId <= 0) {
        errors['priorityId'] = 'Seleccione la prioridad.';
      }
    }

    return StepValidationResult(isValid: errors.isEmpty, errors: errors);
  }
}
