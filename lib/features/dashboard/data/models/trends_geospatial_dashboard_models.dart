// features/dashboard/data/models/trends_geospatial_dashboard_models.dart

import 'package:clean_architecture/features/dashboard/data/models/dashboard_parsing_helpers.dart';
import 'package:clean_architecture/features/dashboard/domain/entities/trends_geospatial_dashboard_entities.dart';

class DailyTrendItemModel extends DailyTrendItemEntity {
  const DailyTrendItemModel({
    required super.fecha,
    required super.incidentesReportados,
    required super.ordenesCreadas,
    required super.ordenesCompletadas,
    required super.balanceFlujoNeto,
  });

  factory DailyTrendItemModel.fromJson(Map<String, dynamic> json) =>
      DailyTrendItemModel(
        fecha: parseToStr(json['fecha']),
        incidentesReportados: parseToInt(json['incidentesReportados']),
        ordenesCreadas: parseToInt(json['ordenesCreadas']),
        ordenesCompletadas: parseToInt(json['ordenesCompletadas']),
        balanceFlujoNeto: parseToInt(json['balanceFlujoNeto']),
      );

  DailyTrendItemEntity toEntity() => this;
}

class TerritorialConcentrationItemModel
    extends TerritorialConcentrationItemEntity {
  const TerritorialConcentrationItemModel({
    required super.parroquia,
    required super.sectorHidrometrico,
    required super.totalIncidentesZona,
    required super.totalOtsZona,
    required super.otsActivasEnCampo,
    required super.incidentesCriticos,
    super.latitudCentroide,
    super.longitudCentroide,
  });

  factory TerritorialConcentrationItemModel.fromJson(
    Map<String, dynamic> json,
  ) => TerritorialConcentrationItemModel(
    parroquia: parseToStr(json['parroquia']),
    sectorHidrometrico: parseToStr(json['sectorHidrometrico']),
    totalIncidentesZona: parseToInt(json['totalIncidentesZona']),
    totalOtsZona: parseToInt(json['totalOtsZona']),
    otsActivasEnCampo: parseToInt(json['otsActivasEnCampo']),
    incidentesCriticos: parseToInt(json['incidentesCriticos']),
    latitudCentroide: parseToDoubleOrNull(json['latitudCentroide']),
    longitudCentroide: parseToDoubleOrNull(json['longitudCentroide']),
  );

  TerritorialConcentrationItemEntity toEntity() => this;
}
