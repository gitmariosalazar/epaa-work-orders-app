import 'package:clean_architecture/features/products/domain/entities/product_material_entity.dart';

class ProductMaterialModel {
  final int inventoryId;
  final String companyCode;
  final String accountCode;
  final String itemCode;
  final String itemName;
  final String itemStatus;
  final int minStock;
  final int currentStock;
  final int itemLevel;
  final double avgCostValue;
  final String itemType;
  final String unitOfMeasure;
  final String vatApplicable;
  final String? previousCode;
  ProductMaterialModel({
    required this.inventoryId,
    required this.companyCode,
    required this.accountCode,
    required this.itemCode,
    required this.itemName,
    required this.itemStatus,
    required this.minStock,
    required this.currentStock,
    required this.itemLevel,
    required this.avgCostValue,
    required this.itemType,
    required this.unitOfMeasure,
    required this.vatApplicable,
    this.previousCode,
  });

  factory ProductMaterialModel.fromJson(Map<String, dynamic> json) {
    return ProductMaterialModel(
      inventoryId: json['inventoryId'] as int,
      companyCode: json['companyCode'] as String,
      accountCode: json['accountCode'] as String,
      itemCode: json['itemCode'] as String,
      itemName: json['itemName'] as String,
      itemStatus: json['itemStatus'] as String,
      minStock: json['minStock'] as int,
      currentStock: json['currentStock'] as int,
      itemLevel: json['itemLevel'] as int,
      avgCostValue: (json['avgCostValue'] as num).toDouble(),
      itemType: json['itemType'] as String,
      unitOfMeasure: json['unitOfMeasure'] as String,
      vatApplicable: json['vatApplicable'] as String,
      previousCode: json['previousCode'] as String?,
    );
  }

  static List<ProductMaterialModel> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => ProductMaterialModel.fromJson(json)).toList();
  }

  Map<String, dynamic> toJson() {
    return {
      'inventoryId': inventoryId,
      'companyCode': companyCode,
      'accountCode': accountCode,
      'itemCode': itemCode,
      'itemName': itemName,
      'itemStatus': itemStatus,
      'minStock': minStock,
      'currentStock': currentStock,
      'itemLevel': itemLevel,
      'avgCostValue': avgCostValue,
      'itemType': itemType,
      'unitOfMeasure': unitOfMeasure,
      'vatApplicable': vatApplicable,
      'previousCode': previousCode,
    };
  }

  factory ProductMaterialModel.fromEntity(ProductMaterialEntity entity) {
    return ProductMaterialModel(
      inventoryId: entity.inventoryId,
      companyCode: entity.companyCode,
      accountCode: entity.accountCode,
      itemCode: entity.itemCode,
      itemName: entity.itemName,
      itemStatus: entity.itemStatus,
      minStock: entity.minStock,
      currentStock: entity.currentStock,
      itemLevel: entity.itemLevel,
      avgCostValue: entity.avgCostValue,
      itemType: entity.itemType,
      unitOfMeasure: entity.unitOfMeasure,
      vatApplicable: entity.vatApplicable,
      previousCode: entity.previousCode,
    );
  }

  ProductMaterialEntity toEntity() {
    return ProductMaterialEntity(
      inventoryId: inventoryId,
      companyCode: companyCode,
      accountCode: accountCode,
      itemCode: itemCode,
      itemName: itemName,
      itemStatus: itemStatus,
      minStock: minStock,
      currentStock: currentStock,
      itemLevel: itemLevel,
      avgCostValue: avgCostValue,
      itemType: itemType,
      unitOfMeasure: unitOfMeasure,
      vatApplicable: vatApplicable,
      previousCode: previousCode,
    );
  }
}
