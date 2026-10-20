// features/workers/data/models/models/worker_model.dart

import 'package:clean_architecture/features/workers/domain/entities/worker_entity.dart';

class WorkerModel {
  final String? workerId;
  final String? identification;
  final String? lastNames;
  final String? firstNames;
  final String? phoneNumber;
  final String? cellPhone;
  final String? email;
  final String? address;

  WorkerModel({
    required this.workerId,
    required this.identification,
    required this.lastNames,
    required this.firstNames,
    this.phoneNumber,
    this.cellPhone,
    this.email,
    this.address,
  });

  factory WorkerModel.fromJson(Map<String, dynamic> json) {
    return WorkerModel(
      workerId: (json['workerId'] ?? json['id'] ?? json['worker_id'])?.toString(),
      identification: (json['identification'] ??
              json['idCard'] ??
              json['cedula'] ??
              json['identification_number'])
          ?.toString(),
      lastNames: (json['lastNames'] ??
              json['lastName'] ??
              json['last_name'] ??
              json['last_names'])
          ?.toString(),
      firstNames: (json['firstNames'] ??
              json['firstName'] ??
              json['first_name'] ??
              json['first_names'] ??
              json['name'])
          ?.toString(),
      phoneNumber: (json['phoneNumber'] ??
              json['phone'] ??
              json['phone_number'])
          ?.toString(),
      cellPhone: (json['cellPhone'] ??
              json['cell_phone'] ??
              json['celular'])
          ?.toString(),
      email: (json['email'] ?? json['mail'])?.toString(),
      address: (json['address'] ?? json['direccion'])?.toString(),
    );
  }

  // Método para convertir a entity
  WorkerEntity toEntity() {
    return WorkerEntity(
      workerId: workerId ?? '',
      identification: identification ?? '',
      lastNames: lastNames ?? '',
      firstNames: firstNames ?? '',
      phoneNumber: phoneNumber ?? '',
      cellPhone: cellPhone ?? '',
      email: email ?? '',
      address: address ?? '',
    );
  }
}
