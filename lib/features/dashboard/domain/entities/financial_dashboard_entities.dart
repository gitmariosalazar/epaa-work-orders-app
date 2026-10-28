// features/dashboard/domain/entities/financial_dashboard_entities.dart

import 'package:equatable/equatable.dart';

/// Consumo y costo de materiales por tipo de trabajo y departamento (5.1).
class MaterialCostItemEntity extends Equatable {
  final String departamento;
  final String tipoTrabajo;
  final String? codigoMaterial;
  final String descripcionMaterial;
  final double cantidadTotalConsumida;
  final double? costoUnitarioPromedio;
  final double costoTotalMateriales;
  final int ordenesQueLoUtilizaron;

  const MaterialCostItemEntity({
    required this.departamento,
    required this.tipoTrabajo,
    this.codigoMaterial,
    required this.descripcionMaterial,
    required this.cantidadTotalConsumida,
    this.costoUnitarioPromedio,
    required this.costoTotalMateriales,
    required this.ordenesQueLoUtilizaron,
  });

  @override
  List<Object?> get props => [
    departamento,
    tipoTrabajo,
    codigoMaterial,
    descripcionMaterial,
    cantidadTotalConsumida,
    costoUnitarioPromedio,
    costoTotalMateriales,
    ordenesQueLoUtilizaron,
  ];
}

/// Balance económico operativo mensual: costos incurridos vs cobro recuperable (5.2).
class EconomicBalanceItemEntity extends Equatable {
  final String mes;
  final int totalOrdenes;
  final double costoTotalMaterialesEpaa;
  final double costoTotalAdicionalesEpaa;
  final double costoOperativoTotalIncurrido;
  final double montoCobrableAUsuarios;
  final double balanceNetoRecuperacion;

  const EconomicBalanceItemEntity({
    required this.mes,
    required this.totalOrdenes,
    required this.costoTotalMaterialesEpaa,
    required this.costoTotalAdicionalesEpaa,
    required this.costoOperativoTotalIncurrido,
    required this.montoCobrableAUsuarios,
    required this.balanceNetoRecuperacion,
  });

  @override
  List<Object?> get props => [
    mes,
    totalOrdenes,
    costoTotalMaterialesEpaa,
    costoTotalAdicionalesEpaa,
    costoOperativoTotalIncurrido,
    montoCobrableAUsuarios,
    balanceNetoRecuperacion,
  ];
}
