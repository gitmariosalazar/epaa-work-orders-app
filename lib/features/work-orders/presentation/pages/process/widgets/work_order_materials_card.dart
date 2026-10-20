import 'package:clean_architecture/core/constants/app_colors.dart';
import 'package:clean_architecture/features/work-orders/data/models/requests/process_work_order_requests.dart';
import 'package:clean_architecture/features/work-orders/domain/entities/work_order_detail_entity.dart';
import 'package:clean_architecture/features/work-orders/presentation/pages/process/dialogs/add_costs_dialog.dart';
import 'package:clean_architecture/features/work-orders/presentation/widgets/products-step/material_search_dialog.dart';
import 'package:clean_architecture/features/work-orders/presentation/widgets/products-step/step_select_materials.dart';
import 'package:flutter/material.dart';

class WorkOrderMaterialsCard extends StatelessWidget {
  final WorkOrderDetailEntity order;
  final Function(List<AddWorkOrderMaterialRequest> materials) onAddMaterials;
  final Function(List<AddAdditionalCostRequest> costs) onAddCosts;

  const WorkOrderMaterialsCard({
    super.key,
    required this.order,
    required this.onAddMaterials,
    required this.onAddCosts,
  });

  bool get _isEditable {
    final status = order.estado.toUpperCase();
    return [
      'EN_PROCESO',
      'EN_PROCESO_INSPECCION',
      'EN_PROCESO_INSTALACION',
    ].contains(status);
  }

  Future<void> _openAddMaterial(BuildContext context) async {
    final result = await showDialog<MaterialWithQuantity>(
      context: context,
      builder: (context) => const MaterialSearchDialog(),
    );

    if (result != null) {
      final req = AddWorkOrderMaterialRequest(
        materialId: result.material.inventoryId,
        quantity: result.quantity.toDouble(),
        unitCost: result.material.avgCostValue,
        codigoMaterial: result.material.itemCode,
        nombreMaterial: result.material.itemName,
      );
      onAddMaterials([req]);
    }
  }

  Future<void> _openAddCost(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (context) => AddCostsDialog(
        orderCode: order.codigoOrden,
        onSubmit: (cost) => onAddCosts([cost]),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final materials = order.materiales;
    final costs = order.costosAdicionales;
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    final totalMaterials = materials.fold<double>(
      0.0,
      (sum, m) => sum + m.subtotal,
    );
    final totalCosts = costs.fold<double>(0.0, (sum, c) => sum + c.subtotal);
    final grandTotal = totalMaterials + totalCosts;

    return Card(
      elevation: 2,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.inventory_2_outlined,
                      color: AppColors.primary,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      'Materiales y Costos',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                if (_isEditable)
                  Row(
                    children: [
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 6,
                          ),
                          minimumSize: Size.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onPressed: () => _openAddMaterial(context),
                        icon: const Icon(
                          Icons.add,
                          size: 13,
                          color: Colors.white,
                        ),
                        label: const Text(
                          'Material',
                          style: TextStyle(fontSize: 11, color: Colors.white),
                        ),
                      ),
                      const SizedBox(width: 6),
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue.shade700,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 6,
                          ),
                          minimumSize: Size.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onPressed: () => _openAddCost(context),
                        icon: const Icon(
                          Icons.add,
                          size: 13,
                          color: Colors.white,
                        ),
                        label: const Text(
                          'Costo',
                          style: TextStyle(fontSize: 11, color: Colors.white),
                        ),
                      ),
                    ],
                  ),
              ],
            ),
            const Divider(height: 16),

            // Materiales
            const Text(
              'Materiales de Bodega',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
            ),
            const SizedBox(height: 8),
            if (materials.isEmpty)
              Text(
                'Sin materiales registrados aún.',
                style: TextStyle(
                  fontSize: 12,
                  color: isDark ? cs.onSurfaceVariant : Colors.grey.shade500,
                  fontStyle: FontStyle.italic,
                ),
              )
            else
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: materials.length,
                separatorBuilder: (context, index) => const Divider(height: 8),
                itemBuilder: (context, index) {
                  final m = materials[index];
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              m.nombreMaterial ?? 'Sin nombre',
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 12.5,
                              ),
                            ),
                            Text(
                              'Cód: ${m.codigoMaterial ?? 'S/C'} • Cant: ${m.cantidad.toStringAsFixed(1)} x \$${m.costoUnitario.toStringAsFixed(2)}',
                              style: TextStyle(
                                fontSize: 11,
                                color: isDark
                                    ? cs.onSurfaceVariant
                                    : Colors.grey.shade600,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        '\$${m.subtotal.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  );
                },
              ),

            const SizedBox(height: 16),
            // Costos Adicionales
            const Text(
              'Costos Adicionales',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
            ),
            const SizedBox(height: 8),
            if (costs.isEmpty)
              Text(
                'Sin costos adicionales registrados.',
                style: TextStyle(
                  fontSize: 12,
                  color: isDark ? cs.onSurfaceVariant : Colors.grey.shade500,
                  fontStyle: FontStyle.italic,
                ),
              )
            else
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: costs.length,
                separatorBuilder: (context, index) => const Divider(height: 8),
                itemBuilder: (context, index) {
                  final c = costs[index];
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              c.concepto,
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 12.5,
                              ),
                            ),
                            Text(
                              'Cant: ${c.cantidad.toStringAsFixed(1)} x \$${c.costoUnitario.toStringAsFixed(2)}',
                              style: TextStyle(
                                fontSize: 11,
                                color: isDark
                                    ? cs.onSurfaceVariant
                                    : Colors.grey.shade600,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        '\$${c.subtotal.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  );
                },
              ),

            const Divider(height: 20),
            // Resumen de Totales
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isDark
                    ? cs.surfaceContainerHighest.withValues(alpha: 0.3)
                    : Colors.grey.shade50,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: isDark
                      ? theme.dividerColor.withValues(alpha: 0.2)
                      : Colors.grey.shade200,
                ),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Subtotal Materiales:',
                        style: TextStyle(
                          fontSize: 12,
                          color: isDark
                              ? cs.onSurfaceVariant
                              : Colors.grey.shade700,
                        ),
                      ),
                      Text(
                        '\$${totalMaterials.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Subtotal Costos Extra:',
                        style: TextStyle(
                          fontSize: 12,
                          color: isDark
                              ? cs.onSurfaceVariant
                              : Colors.grey.shade700,
                        ),
                      ),
                      Text(
                        '\$${totalCosts.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  const Divider(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Total Liquidación OT:',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '\$${grandTotal.toStringAsFixed(2)}',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
