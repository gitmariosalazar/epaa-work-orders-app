import 'dart:io';

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
  final List<File>? attachments;

  // Step 2: Order details
  final String origin;
  final int workTypeId;
  final String? workTypeCode;
  final String? workTypeName;
  final int? departmentId;
  final String? departmentName;
  final WorkTypeEntity? selectedWorkType;
  final DepartmentEntity? selectedDepartment;
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
    this.workTypeId = 0,
    this.workTypeCode,
    this.workTypeName,
    this.departmentId,
    this.departmentName,
    this.selectedWorkType,
    this.selectedDepartment,
    this.priorityId = 2,
    this.cadastralKey = '',
    this.location = '',
    this.description = '',
    this.attachments,
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
    String? workTypeCode,
    String? workTypeName,
    int? departmentId,
    String? departmentName,
    WorkTypeEntity? selectedWorkType,
    bool clearSelectedWorkType = false,
    DepartmentEntity? selectedDepartment,
    bool clearSelectedDepartment = false,
    int? priorityId,
    String? cadastralKey,
    String? location,
    String? description,
    double? latitude,
    double? longitude,
    bool clearCoordinates = false,
    List<File>? attachments,
    bool clearAttachments = false,
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
      workTypeCode: workTypeCode ?? this.workTypeCode,
      workTypeName: workTypeName ?? this.workTypeName,
      departmentId: departmentId ?? this.departmentId,
      departmentName: departmentName ?? this.departmentName,
      selectedWorkType: clearSelectedWorkType
          ? null
          : (selectedWorkType ?? this.selectedWorkType),
      selectedDepartment: clearSelectedDepartment
          ? null
          : (selectedDepartment ?? this.selectedDepartment),
      priorityId: priorityId ?? this.priorityId,
      cadastralKey: cadastralKey ?? this.cadastralKey,
      location: location ?? this.location,
      description: description ?? this.description,
      latitude: clearCoordinates ? null : (latitude ?? this.latitude),
      longitude: clearCoordinates ? null : (longitude ?? this.longitude),
      attachments: clearAttachments ? null : (attachments ?? this.attachments),
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
      status: 'NOTIFICADA',
      attachments: attachments,
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
      final hasValidWorkType = form.workTypeId > 0 ||
          (form.workTypeCode != null && form.workTypeCode!.isNotEmpty);
      if (!hasValidWorkType) {
        errors['workTypeId'] = 'Seleccione el tipo de trabajo.';
      }
      if (form.priorityId <= 0) {
        errors['priorityId'] = 'Seleccione la prioridad.';
      }
    }

    return StepValidationResult(isValid: errors.isEmpty, errors: errors);
  }
}
