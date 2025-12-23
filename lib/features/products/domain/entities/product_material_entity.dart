/*
Example Dart code for product_material_entity.dart
{
      "inventoryId": 1,
      "companyCode": "1.3.1.01.11",
      "accountCode": "1.3.1.01.11",
      "itemCode": "0001",
      "itemName": "ABRAZADERA DE 3/8\" PSI BREEZE",
      "itemStatus": "A",
      "minStock": 100,
      "currentStock": 1533,
      "itemLevel": 1,
      "avgCostValue": 1.187618,
      "itemType": "M",
      "unitOfMeasure": "UNIDAD",
      "vatApplicable": "N",
      "previousCode": null
    },
 */

class ProductMaterialEntity {
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

  ProductMaterialEntity({
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
}
