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
      workerId: json['workerId'] as String?,
      identification: json['identification'] as String?,
      lastNames: json['lastNames'] as String?,
      firstNames: json['firstNames'] as String?,
      phoneNumber: json['phoneNumber'] as String?, // ← permite null
      cellPhone: json['cellPhone'] as String?,
      email: json['email'] as String?,
      address: json['address'] as String?,
    );
  }

  // Método para convertir a entity
  WorkerEntity toEntity() {
    return WorkerEntity(
      workerId: workerId ?? '',
      identification: identification ?? 'Hola',
      lastNames: lastNames ?? '',
      firstNames: firstNames ?? '',
      phoneNumber: phoneNumber ?? '',
      cellPhone: cellPhone ?? '',
      email: email ?? '',
      address: address ?? '',
    );
  }
}
