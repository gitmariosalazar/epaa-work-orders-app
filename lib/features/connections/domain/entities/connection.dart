import 'package:clean_architecture/features/connections/domain/entities/company.dart';
import 'package:clean_architecture/features/connections/domain/entities/person.dart';

class ConnectionEntity {
  final String connectionId;
  final String clientId;
  final int connectionRateId;
  final String connectionRateName;
  final String? connectionMeterNumber;
  final int connectionSector;
  final int connectionAccount;
  final String connectionCadastralKey;
  final String? connectionContractNumber;
  final bool? connectionSewerage;
  final bool? connectionStatus;
  final String connectionAddress;
  final String? connectionInstallationDate;
  final int? connectionPeopleNumber;
  final int? connectionZone;
  final String? connectionCoordinates;
  final String? connectionReference;
  final Map<String, dynamic>? connectionMetadata;
  final double? connectionAltitude;
  final double? connectionPrecision;
  final DateTime? connectionGeolocationDate;
  final String? connectionGeometricZone;
  final String? propertyCadastralKey;
  final int? zoneId;
  final String? zoneCode;
  final String? zoneName;
  final PersonEntity? person;
  final CompanyEntity? company;

  const ConnectionEntity({
    required this.connectionId,
    required this.clientId,
    required this.connectionRateId,
    required this.connectionRateName,
    this.connectionMeterNumber,
    required this.connectionSector,
    required this.connectionAccount,
    required this.connectionCadastralKey,
    this.connectionContractNumber,
    this.connectionSewerage,
    this.connectionStatus,
    required this.connectionAddress,
    required this.connectionInstallationDate,
    this.connectionPeopleNumber,
    this.connectionZone,
    this.connectionCoordinates,
    this.connectionReference,
    this.connectionMetadata,
    this.connectionAltitude,
    this.connectionPrecision,
    this.connectionGeolocationDate,
    this.connectionGeometricZone,
    this.propertyCadastralKey,
    this.zoneId,
    this.zoneCode,
    this.zoneName,
    this.person,
    this.company,
  });
}
