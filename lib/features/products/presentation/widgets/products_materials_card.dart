// features/products/presentation/widgets/products_materials_card.dart

import 'package:clean_architecture/features/products/domain/entities/product_material_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ProductsMaterialCard extends StatelessWidget {
  final ProductMaterialEntity product;
  final void Function(ProductMaterialEntity)? onTap;

  const ProductsMaterialCard({super.key, required this.product, this.onTap});

  Color _getStockColor(BuildContext context, int current, int min) {
    final cs = Theme.of(context).colorScheme;
    if (current == 0) return cs.error;
    if (current < min) return const Color(0xFFF97316); // Amber / Warning
    return const Color(0xFF109335); // Success green
  }

  String _getStockLabel(int current, int min, String unit) {
    if (current == 0) return 'Agotado';
    if (current < min) return 'Stock Bajo';
    return 'En Stock';
  }

  IconData _getStockIcon(int current, int min) {
    if (current == 0) return Icons.error_outline_rounded;
    if (current < min) return Icons.warning_amber_rounded;
    return Icons.check_circle_outline_rounded;
  }

  bool get _isMaterial => product.itemType.toUpperCase() == 'M';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    final stockColor = _getStockColor(
      context,
      product.currentStock,
      product.minStock,
    );
    final stockLabel = _getStockLabel(
      product.currentStock,
      product.minStock,
      product.unitOfMeasure,
    );
    final stockIcon = _getStockIcon(product.currentStock, product.minStock);

    final typeLabel = _isMaterial ? 'Material' : 'Producto';
    final typeIcon = _isMaterial
        ? Icons.handyman_outlined
        : Icons.inventory_2_outlined;

    return Container(
      decoration: BoxDecoration(
        color: isDark
            ? cs.surfaceContainerHighest.withValues(alpha: 0.65)
            : theme.cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: cs.outlineVariant.withValues(alpha: isDark ? 0.35 : 0.55),
          width: 0.9,
        ),
        boxShadow: [
          BoxShadow(
            color: cs.shadow.withValues(alpha: isDark ? 0.25 : 0.04),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            if (onTap != null) {
              onTap!(product);
            } else {
              _showProductDetailsSheet(context);
            }
          },
          borderRadius: BorderRadius.circular(16),
          splashColor: cs.primary.withValues(alpha: 0.08),
          highlightColor: cs.primary.withValues(alpha: 0.04),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Fila Superior: Tipo Icon + Nombre + Badges de Tipo y Estado de Stock
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Icono de Tipo (Material o Producto)
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: cs.primary.withValues(alpha: isDark ? 0.2 : 0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: cs.primary.withValues(
                            alpha: isDark ? 0.4 : 0.25,
                          ),
                          width: 1,
                        ),
                      ),
                      alignment: Alignment.center,
                      child: Icon(typeIcon, size: 22, color: cs.primary),
                    ),
                    const SizedBox(width: 12),

                    // Nombre y Código
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            product.itemName.trim().isNotEmpty
                                ? product.itemName.trim()
                                : 'Sin Descripción',
                            style: theme.textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.w700,
                              fontSize: 14.5,
                              color: cs.onSurface,
                              height: 1.25,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 5),
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 6,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: cs.surfaceContainerHighest.withValues(
                                    alpha: isDark ? 0.5 : 0.7,
                                  ),
                                  borderRadius: BorderRadius.circular(6),
                                  border: Border.all(
                                    color: cs.outlineVariant.withValues(
                                      alpha: 0.5,
                                    ),
                                    width: 0.7,
                                  ),
                                ),
                                child: Text(
                                  'Cód: ${product.itemCode}',
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                    color: cs.onSurfaceVariant,
                                    letterSpacing: 0.2,
                                  ),
                                ),
                              ),
                              if (product.itemStatus == 'A') ...[
                                const SizedBox(width: 6),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 6,
                                    vertical: 2,
                                  ),
                                  decoration: BoxDecoration(
                                    color: const Color(
                                      0xFF109335,
                                    ).withValues(alpha: 0.12),
                                    borderRadius: BorderRadius.circular(6),
                                    border: Border.all(
                                      color: const Color(
                                        0xFF109335,
                                      ).withValues(alpha: 0.3),
                                      width: 0.7,
                                    ),
                                  ),
                                  child: const Text(
                                    'Activo',
                                    style: TextStyle(
                                      fontSize: 10.5,
                                      fontWeight: FontWeight.w700,
                                      color: Color(0xFF109335),
                                    ),
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(width: 8),

                    // Badges superiores: Tipo & Stock
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        // Badge Tipo
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color: cs.primary.withValues(
                              alpha: isDark ? 0.18 : 0.1,
                            ),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: cs.primary.withValues(
                                alpha: isDark ? 0.4 : 0.25,
                              ),
                              width: 0.8,
                            ),
                          ),
                          child: Text(
                            typeLabel,
                            style: TextStyle(
                              fontSize: 11,
                              color: cs.primary,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        const SizedBox(height: 5),

                        // Badge Estado de Stock
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color: stockColor.withValues(
                              alpha: isDark ? 0.18 : 0.12,
                            ),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: stockColor.withValues(alpha: 0.4),
                              width: 0.8,
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(stockIcon, size: 12, color: stockColor),
                              const SizedBox(width: 4),
                              Text(
                                stockLabel,
                                style: TextStyle(
                                  fontSize: 11,
                                  color: stockColor,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Divider(
                    height: 1,
                    thickness: 0.8,
                    color: cs.outlineVariant.withValues(
                      alpha: isDark ? 0.3 : 0.5,
                    ),
                  ),
                ),

                // Grid / Métricas de Stock, Costo y Cuenta
                Row(
                  children: [
                    // Stock Actual vs Mínimo
                    Expanded(
                      flex: 4,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                'Stock: ',
                                style: TextStyle(
                                  fontSize: 11.5,
                                  color: cs.onSurfaceVariant,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Text(
                                '${product.currentStock}',
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w800,
                                  color: stockColor,
                                ),
                              ),
                              Text(
                                ' / ${product.minStock} ${product.unitOfMeasure}',
                                style: TextStyle(
                                  fontSize: 11.5,
                                  color: cs.onSurfaceVariant,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          // Barra de progreso de stock
                          ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                            child: LinearProgressIndicator(
                              value: product.minStock > 0
                                  ? (product.currentStock /
                                            (product.minStock * 1.5))
                                        .clamp(0.0, 1.0)
                                  : (product.currentStock > 0 ? 1.0 : 0.0),
                              backgroundColor: cs.outlineVariant.withValues(
                                alpha: 0.3,
                              ),
                              valueColor: AlwaysStoppedAnimation<Color>(
                                stockColor,
                              ),
                              minHeight: 5,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(width: 14),

                    // Costo Promedio
                    Expanded(
                      flex: 3,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            'Costo Promedio',
                            style: TextStyle(
                              fontSize: 10.5,
                              color: cs.onSurfaceVariant,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            '\$${product.avgCostValue.toStringAsFixed(2)}',
                            style: TextStyle(
                              fontSize: 13.5,
                              fontWeight: FontWeight.w700,
                              color: cs.onSurface,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 8),

                // Fila Inferior: Cuenta Contable + Unidad de Medida
                Row(
                  children: [
                    Icon(
                      Icons.account_balance_wallet_outlined,
                      size: 14,
                      color: cs.onSurfaceVariant,
                    ),
                    const SizedBox(width: 5),
                    Text(
                      'Cuenta: ${product.accountCode}',
                      style: TextStyle(
                        fontSize: 11,
                        color: cs.onSurfaceVariant,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const Spacer(),
                    Icon(
                      Icons.straighten_outlined,
                      size: 14,
                      color: cs.onSurfaceVariant,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'Unidad: ${product.unitOfMeasure}',
                      style: TextStyle(
                        fontSize: 11,
                        color: cs.onSurfaceVariant,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showProductDetailsSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) => _ProductDetailBottomSheet(product: product),
    );
  }
}

class _ProductDetailBottomSheet extends StatelessWidget {
  final ProductMaterialEntity product;

  const _ProductDetailBottomSheet({required this.product});

  void _copyToClipboard(BuildContext context, String text, String label) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(
              Icons.check_circle_rounded,
              color: Colors.white,
              size: 18,
            ),
            const SizedBox(width: 8),
            Expanded(child: Text('$label copiado al portapapeles')),
          ],
        ),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    final isMaterial = product.itemType.toUpperCase() == 'M';
    final typeLabel = isMaterial ? 'Material de Bodega' : 'Producto Terminado';
    final typeIcon = isMaterial
        ? Icons.handyman_outlined
        : Icons.inventory_2_outlined;

    final stockColor = product.currentStock == 0
        ? cs.error
        : (product.currentStock < product.minStock
              ? const Color(0xFFF97316)
              : const Color(0xFF109335));

    return Container(
      decoration: BoxDecoration(
        color: isDark ? cs.surfaceContainerHigh : cs.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        border: Border(
          top: BorderSide(
            color: cs.outlineVariant.withValues(alpha: 0.4),
            width: 1,
          ),
        ),
      ),
      padding: EdgeInsets.fromLTRB(
        20,
        12,
        20,
        20 + MediaQuery.paddingOf(context).bottom,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Drag handle
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: cs.outlineVariant.withValues(alpha: 0.7),
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Icono principal
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: cs.primary.withValues(alpha: isDark ? 0.25 : 0.12),
              border: Border.all(
                color: cs.primary.withValues(alpha: isDark ? 0.5 : 0.3),
                width: 1.5,
              ),
            ),
            child: Icon(typeIcon, size: 28, color: cs.primary),
          ),
          const SizedBox(height: 12),

          // Nombre del producto
          Text(
            product.itemName.trim(),
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
              fontSize: 16,
              color: cs.onSurface,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 6),

          // Etiqueta de Tipo
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
            decoration: BoxDecoration(
              color: cs.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: cs.primary.withValues(alpha: 0.25)),
            ),
            child: Text(
              typeLabel,
              style: TextStyle(
                color: cs.primary,
                fontWeight: FontWeight.w700,
                fontSize: 11.5,
              ),
            ),
          ),

          const SizedBox(height: 18),

          // Tarjeta de Resumen de Stock
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: isDark
                  ? cs.surfaceContainerHighest.withValues(alpha: 0.4)
                  : cs.surfaceContainerLowest,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: cs.outlineVariant.withValues(alpha: 0.4),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _StockMetric(
                  label: 'Stock Actual',
                  value: '${product.currentStock}',
                  valueColor: stockColor,
                  unit: product.unitOfMeasure,
                ),
                Container(
                  height: 36,
                  width: 1,
                  color: cs.outlineVariant.withValues(alpha: 0.4),
                ),
                _StockMetric(
                  label: 'Stock Mínimo',
                  value: '${product.minStock}',
                  valueColor: cs.onSurface,
                  unit: product.unitOfMeasure,
                ),
                Container(
                  height: 36,
                  width: 1,
                  color: cs.outlineVariant.withValues(alpha: 0.4),
                ),
                _StockMetric(
                  label: 'Costo Promedio',
                  value: '\$${product.avgCostValue.toStringAsFixed(2)}',
                  valueColor: cs.onSurface,
                  unit: 'USD',
                ),
              ],
            ),
          ),

          const SizedBox(height: 14),

          // Lista de detalles completos con opción de copiado
          Container(
            decoration: BoxDecoration(
              color: isDark
                  ? cs.surfaceContainerHighest.withValues(alpha: 0.4)
                  : cs.surfaceContainerLowest,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: cs.outlineVariant.withValues(alpha: 0.4),
              ),
            ),
            child: Column(
              children: [
                _ItemDetailRow(
                  icon: Icons.tag_rounded,
                  title: 'Código de Artículo',
                  value: product.itemCode,
                  onCopy: () => _copyToClipboard(
                    context,
                    product.itemCode,
                    'Código de artículo',
                  ),
                ),
                Divider(
                  height: 1,
                  color: cs.outlineVariant.withValues(alpha: 0.3),
                ),
                _ItemDetailRow(
                  icon: Icons.account_balance_wallet_outlined,
                  title: 'Cuenta Contable',
                  value: product.accountCode,
                  onCopy: () => _copyToClipboard(
                    context,
                    product.accountCode,
                    'Cuenta contable',
                  ),
                ),
                Divider(
                  height: 1,
                  color: cs.outlineVariant.withValues(alpha: 0.3),
                ),
                _ItemDetailRow(
                  icon: Icons.business_outlined,
                  title: 'Código Empresa',
                  value: product.companyCode,
                  onCopy: () => _copyToClipboard(
                    context,
                    product.companyCode,
                    'Código empresa',
                  ),
                ),
                Divider(
                  height: 1,
                  color: cs.outlineVariant.withValues(alpha: 0.3),
                ),
                _ItemDetailRow(
                  icon: Icons.receipt_long_outlined,
                  title: 'Aplica IVA',
                  value: product.vatApplicable.toUpperCase() == 'S'
                      ? 'Sí (Gravamen vigente)'
                      : 'No (Tarifa 0% / Exento)',
                ),
                if (product.previousCode != null &&
                    product.previousCode!.isNotEmpty) ...[
                  Divider(
                    height: 1,
                    color: cs.outlineVariant.withValues(alpha: 0.3),
                  ),
                  _ItemDetailRow(
                    icon: Icons.history_rounded,
                    title: 'Código Anterior',
                    value: product.previousCode!,
                    onCopy: () => _copyToClipboard(
                      context,
                      product.previousCode!,
                      'Código anterior',
                    ),
                  ),
                ],
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Botón Cerrar
          SizedBox(
            width: double.infinity,
            child: FilledButton.tonal(
              onPressed: () => Navigator.pop(context),
              style: FilledButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
              child: const Text('Cerrar'),
            ),
          ),
        ],
      ),
    );
  }
}

class _StockMetric extends StatelessWidget {
  final String label;
  final String value;
  final Color valueColor;
  final String unit;

  const _StockMetric({
    required this.label,
    required this.value,
    required this.valueColor,
    required this.unit,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Column(
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 10.5,
            color: cs.onSurfaceVariant,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w800,
            color: valueColor,
          ),
        ),
        Text(
          unit,
          style: TextStyle(
            fontSize: 10,
            color: cs.onSurfaceVariant,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

class _ItemDetailRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final VoidCallback? onCopy;

  const _ItemDetailRow({
    required this.icon,
    required this.title,
    required this.value,
    this.onCopy,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: cs.primary.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, size: 16, color: cs.primary),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 11,
                    color: cs.onSurfaceVariant,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 1),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 13,
                    color: cs.onSurface,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          if (onCopy != null)
            IconButton(
              icon: Icon(
                Icons.copy_rounded,
                size: 16,
                color: cs.onSurfaceVariant.withValues(alpha: 0.7),
              ),
              tooltip: 'Copiar',
              onPressed: onCopy,
              visualDensity: VisualDensity.compact,
            ),
        ],
      ),
    );
  }
}
