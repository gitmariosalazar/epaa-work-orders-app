// features/dashboard/domain/entities/trends_geospatial_dashboard_entities.dart

import 'package:equatable/equatable.dart';

/// Tendencia diaria de ingresos vs resoluciones (6.1).
class DailyTrendItemEntity extends Equatable {
  final String fecha;
  final int incidentesReportados;
  final int ordenesCreadas;
  final int ordenesCompletadas;
  final int balanceFlujoNeto;

  const DailyTrendItemEntity({
    required this.fecha,
    required this.incidentesReportados,
    required this.ordenesCreadas,
    required this.ordenesCompletadas,
    required this.balanceFlujoNeto,
  });

  @override
  List<Object?> get props => [
    fecha,
    incidentesReportados,
    ordenesCreadas,
    ordenesCompletadas,
    balanceFlujoNeto,
  ];
}

/// Concentración geográfica y densidad geoespacial por parroquia / sector (6.2).
class TerritorialConcentrationItemEntity extends Equatable {
  final String parroquia;
  final String sectorHidrometrico;
  final int totalIncidentesZona;
  final int totalOtsZona;
  final int otsActivasEnCampo;
  final int incidentesCriticos;
  final double? latitudCentroide;
  final double? longitudCentroide;

  const TerritorialConcentrationItemEntity({
    required this.parroquia,
    required this.sectorHidrometrico,
    required this.totalIncidentesZona,
    required this.totalOtsZona,
    required this.otsActivasEnCampo,
    required this.incidentesCriticos,
    this.latitudCentroide,
    this.longitudCentroide,
  });

  @override
  List<Object?> get props => [
    parroquia,
    sectorHidrometrico,
    totalIncidentesZona,
    totalOtsZona,
    otsActivasEnCampo,
    incidentesCriticos,
    latitudCentroide,
    longitudCentroide,
  ];
}
