// features/products/presentation/widgets/products_material_card.dart

import 'package:clean_architecture/features/products/domain/entities/product_material_entity.dart';
import 'package:flutter/material.dart';

class ProductsMaterialCard extends StatelessWidget {
  final ProductMaterialEntity product;

  const ProductsMaterialCard({super.key, required this.product});

  Color _getStockColor(int current, int min) {
    if (current == 0) return Colors.red;
    if (current < min) return Colors.orange;
    return Colors.green;
  }

  String _getTypeText(String type) {
    return type == 'M' ? 'Material' : 'Producto';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final stockColor = _getStockColor(product.currentStock, product.minStock);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 2, vertical: 4),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product.itemName,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Código: ${product.itemCode}',
                        style: const TextStyle(
                          fontSize: 11,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: theme.primaryColor.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: theme.primaryColor),
                      ),
                      child: Text(
                        _getTypeText(product.itemType),
                        style: TextStyle(
                          fontSize: 10,
                          color: theme.primaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: stockColor.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: stockColor),
                      ),
                      child: Text(
                        'Stock: ${product.currentStock}',
                        style: TextStyle(
                          fontSize: 10,
                          color: stockColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(
                  Icons.account_balance_wallet,
                  size: 16,
                  color: Colors.grey[600],
                ),
                const SizedBox(width: 6),
                Text(
                  'Cuenta: ${product.accountCode}',
                  style: const TextStyle(fontSize: 11, color: Colors.grey),
                ),
                const Spacer(),
                Text(
                  'Mínimo: ${product.minStock}',
                  style: const TextStyle(fontSize: 11, color: Colors.grey),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                Icon(Icons.price_check, size: 16, color: Colors.grey[600]),
                const SizedBox(width: 6),
                Text(
                  'Costo promedio: \$${product.avgCostValue.toStringAsFixed(2)}',
                  style: const TextStyle(fontSize: 11, color: Colors.grey),
                ),
                const Spacer(),
                Text(
                  'Unidad: ${product.unitOfMeasure}',
                  style: const TextStyle(fontSize: 11, color: Colors.grey),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
