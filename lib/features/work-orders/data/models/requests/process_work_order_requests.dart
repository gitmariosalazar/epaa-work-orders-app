import 'package:clean_architecture/features/work-orders/domain/params/create_work_order_from_incident_params.dart';
class ProcessWorkOrderTransitionRequest {
  final String workOrderId;
  final String? comment;
  final String? newStatus;
  final String? userId;

  ProcessWorkOrderTransitionRequest({
    required this.workOrderId,
    this.comment,
    this.newStatus,
    this.userId,
  });

  Map<String, dynamic> toJson() {
    return {
      'workOrderId': workOrderId,
      if (comment != null) 'comment': comment,
      if (newStatus != null) 'newStatus': newStatus,
      if (userId != null) 'userId': userId,
    };
  }
}

class CreateWorkOrderFromIncidentRequest {
  final String incidentCode;
  final String? userIdAssignee;

  const CreateWorkOrderFromIncidentRequest({
    required this.incidentCode,
    this.userIdAssignee,
  });

  factory CreateWorkOrderFromIncidentRequest.fromParams(
    CreateWorkOrderFromIncidentParams p,
  ) => CreateWorkOrderFromIncidentRequest(
    incidentCode: p.incidentCode,
    userIdAssignee: p.userIdAssignee,
  );

  Map<String, dynamic> toJson() => {
    'incidentCode': incidentCode,
    'userIdAssignee': (userIdAssignee?.isEmpty ?? true) ? null : userIdAssignee,
  };
}

class AssignWorkOrderToCrewRequest {
  final String workOrderId;
  final String crewId;
  final String? comment;
  final String? assignedByUserId;

  AssignWorkOrderToCrewRequest({
    required this.workOrderId,
    required this.crewId,
    this.comment,
    this.assignedByUserId,
  });

  Map<String, dynamic> toJson() {
    return {
      'workOrderId': workOrderId,
      'crewId': crewId,
      if (comment != null) 'comment': comment,
      'assignedByUserId': (assignedByUserId != null && assignedByUserId!.trim().isNotEmpty)
          ? assignedByUserId!
          : 'USER-ADMIN',
    };
  }
}

class AssignWorkOrderToWorkerRequest {
  final String workOrderId;
  final String workerId;
  final String? comment;
  final String? assignedByUserId;

  AssignWorkOrderToWorkerRequest({
    required this.workOrderId,
    required this.workerId,
    this.comment,
    this.assignedByUserId,
  });

  Map<String, dynamic> toJson() {
    return {
      'workOrderId': workOrderId,
      'workerId': workerId,
      if (comment != null) 'comment': comment,
      'assignedByUserId': (assignedByUserId != null && assignedByUserId!.trim().isNotEmpty)
          ? assignedByUserId!
          : 'USER-ADMIN',
    };
  }
}

class CreatePreparationInspectionRequest {
  final String workOrderId;
  final bool passed;
  final String? observations;
  final String? createdByUserId;

  CreatePreparationInspectionRequest({
    required this.workOrderId,
    required this.passed,
    this.observations,
    this.createdByUserId,
  });

  Map<String, dynamic> toJson() {
    return {
      'workOrderId': workOrderId,
      'passed': passed,
      if (observations != null) 'observations': observations,
      if (createdByUserId != null) 'createdByUserId': createdByUserId,
    };
  }
}

class AddPreparationInspectionDetailRequest {
  final String inspectionId;
  final String checklistId;
  final bool isChecked;
  final String? remarks;

  AddPreparationInspectionDetailRequest({
    required this.inspectionId,
    required this.checklistId,
    required this.isChecked,
    this.remarks,
  });

  Map<String, dynamic> toJson() {
    return {
      'inspectionId': inspectionId,
      'checklistId': checklistId,
      'isChecked': isChecked,
      if (remarks != null) 'remarks': remarks,
    };
  }
}

class ResolvePreparationInspectionRequest {
  final String workOrderId;
  final bool passed;
  final String? comment;
  final String? userId;

  ResolvePreparationInspectionRequest({
    required this.workOrderId,
    required this.passed,
    this.comment,
    this.userId,
  });

  Map<String, dynamic> toJson() {
    return {
      'workOrderId': workOrderId,
      'passed': passed,
      if (comment != null) 'comment': comment,
      if (userId != null) 'userId': userId,
    };
  }
}

class AddWorkOrderMaterialRequest {
  final int materialId;
  final double quantity;
  final double unitCost;
  final String? codigoMaterial;
  final String? nombreMaterial;

  AddWorkOrderMaterialRequest({
    required this.materialId,
    required this.quantity,
    required this.unitCost,
    this.codigoMaterial,
    this.nombreMaterial,
  });

  Map<String, dynamic> toJson() {
    return {
      'materialId': materialId,
      'quantity': quantity,
      'unitCost': unitCost,
      if (codigoMaterial != null) 'codigoMaterial': codigoMaterial,
      if (nombreMaterial != null) 'nombreMaterial': nombreMaterial,
    };
  }
}

class AddWorkOrderMaterialsBatchRequest {
  final String workOrderId;
  final String? createdByUserId;
  final List<AddWorkOrderMaterialRequest> materials;

  AddWorkOrderMaterialsBatchRequest({
    required this.workOrderId,
    this.createdByUserId,
    required this.materials,
  });

  Map<String, dynamic> toJson() {
    return {
      'workOrderId': workOrderId,
      if (createdByUserId != null) 'createdByUserId': createdByUserId,
      'materials': materials.map((m) => m.toJson()).toList(),
    };
  }
}

class AddAdditionalCostRequest {
  final String concept;
  final double quantity;
  final double unitCost;

  AddAdditionalCostRequest({
    required this.concept,
    required this.quantity,
    required this.unitCost,
  });

  Map<String, dynamic> toJson() {
    return {
      'concept': concept,
      'quantity': quantity,
      'unitCost': unitCost,
    };
  }
}

class AddAdditionalCostsBatchRequest {
  final String workOrderId;
  final String? createdByUserId;
  final List<AddAdditionalCostRequest> costs;

  AddAdditionalCostsBatchRequest({
    required this.workOrderId,
    this.createdByUserId,
    required this.costs,
  });

  Map<String, dynamic> toJson() {
    return {
      'workOrderId': workOrderId,
      if (createdByUserId != null) 'createdByUserId': createdByUserId,
      'costs': costs.map((c) => c.toJson()).toList(),
    };
  }
}

class CreateQualityControlRequest {
  final String workOrderId;
  final bool approved;
  final String? comments;
  final String? createdByUserId;

  CreateQualityControlRequest({
    required this.workOrderId,
    required this.approved,
    this.comments,
    this.createdByUserId,
  });

  Map<String, dynamic> toJson() {
    return {
      'workOrderId': workOrderId,
      'approved': approved,
      if (comments != null) 'comments': comments,
      if (createdByUserId != null) 'createdByUserId': createdByUserId,
    };
  }
}

class AddQualityControlDetailRequest {
  final String qualityControlId;
  final String checkpoint;
  final bool passed;
  final String? notes;

  AddQualityControlDetailRequest({
    required this.qualityControlId,
    required this.checkpoint,
    required this.passed,
    this.notes,
  });

  Map<String, dynamic> toJson() {
    return {
      'qualityControlId': qualityControlId,
      'checkpoint': checkpoint,
      'passed': passed,
      if (notes != null) 'notes': notes,
    };
  }
}

class ResolveQualityControlRequest {
  final String workOrderId;
  final bool approved;
  final String? comment;
  final String? userId;

  ResolveQualityControlRequest({
    required this.workOrderId,
    required this.approved,
    this.comment,
    this.userId,
  });

  Map<String, dynamic> toJson() {
    return {
      'workOrderId': workOrderId,
      'approved': approved,
      if (comment != null) 'comment': comment,
      if (userId != null) 'userId': userId,
    };
  }
}

class RegisterSatisfactionSurveyRequest {
  final String workOrderId;
  final int rating;
  final String? comments;
  final String? createdByUserId;

  RegisterSatisfactionSurveyRequest({
    required this.workOrderId,
    required this.rating,
    this.comments,
    this.createdByUserId,
  });

  Map<String, dynamic> toJson() {
    return {
      'workOrderId': workOrderId,
      'rating': rating,
      if (comments != null) 'comments': comments,
      if (createdByUserId != null) 'createdByUserId': createdByUserId,
    };
  }
}

class AddWorkerToWorkOrderRequest {
  final String workerId;
  final int? roleId;
  final bool? isResponsible;

  AddWorkerToWorkOrderRequest({
    required this.workerId,
    this.roleId,
    this.isResponsible,
  });

  Map<String, dynamic> toJson() {
    return {
      'workerId': workerId,
      if (roleId != null) 'roleId': roleId,
      if (isResponsible != null) 'isResponsible': isResponsible,
    };
  }
}

class AddWorkersBatchToWorkOrderRequest {
  final String workOrderId;
  final String? assignedByUserId;
  final List<AddWorkerToWorkOrderRequest> workers;

  AddWorkersBatchToWorkOrderRequest({
    required this.workOrderId,
    this.assignedByUserId,
    required this.workers,
  });

  Map<String, dynamic> toJson() {
    return {
      'workOrderId': workOrderId,
      if (assignedByUserId != null) 'assignedByUserId': assignedByUserId,
      'workers': workers.map((w) => w.toJson()).toList(),
    };
  }
}

class RemoveWorkerFromWorkOrderRequest {
  final String workOrderId;
  final String workerId;
  final String? removedByUserId;

  RemoveWorkerFromWorkOrderRequest({
    required this.workOrderId,
    required this.workerId,
    this.removedByUserId,
  });

  Map<String, dynamic> toJson() {
    return {
      'workOrderId': workOrderId,
      'workerId': workerId,
      if (removedByUserId != null) 'removedByUserId': removedByUserId,
    };
  }
}

class AdvanceWorkOrderStateRequest {
  final String workOrderId;
  final String newStatus;
  final String? comment;
  final String? userId;

  AdvanceWorkOrderStateRequest({
    required this.workOrderId,
    required this.newStatus,
    this.comment,
    this.userId,
  });

  Map<String, dynamic> toJson() {
    return {
      'workOrderId': workOrderId,
      'newStatus': newStatus,
      if (comment != null) 'comment': comment,
      if (userId != null) 'userId': userId,
    };
  }
}
