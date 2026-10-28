// features/dashboard/data/models/financial_dashboard_models.dart

import 'package:clean_architecture/features/dashboard/data/models/dashboard_parsing_helpers.dart';
import 'package:clean_architecture/features/dashboard/domain/entities/financial_dashboard_entities.dart';

class MaterialCostItemModel extends MaterialCostItemEntity {
  const MaterialCostItemModel({
    required super.departamento,
    required super.tipoTrabajo,
    super.codigoMaterial,
    required super.descripcionMaterial,
    required super.cantidadTotalConsumida,
    super.costoUnitarioPromedio,
    required super.costoTotalMateriales,
    required super.ordenesQueLoUtilizaron,
  });

  factory MaterialCostItemModel.fromJson(Map<String, dynamic> json) =>
      MaterialCostItemModel(
        departamento: parseToStr(json['departamento']),
        tipoTrabajo: parseToStr(json['tipoTrabajo']),
        codigoMaterial: parseToStrOrNull(json['codigoMaterial']),
        descripcionMaterial: parseToStr(json['descripcionMaterial']),
        cantidadTotalConsumida: parseToDouble(json['cantidadTotalConsumida']),
        costoUnitarioPromedio: parseToDoubleOrNull(
          json['costoUnitarioPromedio'],
        ),
        costoTotalMateriales: parseToDouble(json['costoTotalMateriales']),
        ordenesQueLoUtilizaron: parseToInt(json['ordenesQueLoUtilizaron']),
      );

  MaterialCostItemEntity toEntity() => this;
}

class EconomicBalanceItemModel extends EconomicBalanceItemEntity {
  const EconomicBalanceItemModel({
    required super.mes,
    required super.totalOrdenes,
    required super.costoTotalMaterialesEpaa,
    required super.costoTotalAdicionalesEpaa,
    required super.costoOperativoTotalIncurrido,
    required super.montoCobrableAUsuarios,
    required super.balanceNetoRecuperacion,
  });

  factory EconomicBalanceItemModel.fromJson(Map<String, dynamic> json) =>
      EconomicBalanceItemModel(
        mes: parseToStr(json['mes']),
        totalOrdenes: parseToInt(json['totalOrdenes']),
        costoTotalMaterialesEpaa: parseToDouble(
          json['costoTotalMaterialesEpaa'],
        ),
        costoTotalAdicionalesEpaa: parseToDouble(
          json['costoTotalAdicionalesEpaa'],
        ),
        costoOperativoTotalIncurrido: parseToDouble(
          json['costoOperativoTotalIncurrido'],
        ),
        montoCobrableAUsuarios: parseToDouble(json['montoCobrableAUsuarios']),
        balanceNetoRecuperacion: parseToDouble(json['balanceNetoRecuperacion']),
      );

  EconomicBalanceItemEntity toEntity() => this;
}
