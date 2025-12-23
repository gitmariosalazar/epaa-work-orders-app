// lib/features/work-orders/presentation/widgets/step_select_materials.dart

import 'package:clean_architecture/core/constants/app_colors.dart';
import 'package:clean_architecture/core/utils/responsive/responsive_utils.dart';
import 'package:clean_architecture/features/products/domain/entities/product_material_entity.dart';
import 'package:clean_architecture/features/work-orders/presentation/widgets/products-step/material_search_dialog.dart';
import 'package:flutter/material.dart';

class StepSelectMaterials extends StatefulWidget {
  final Map<String, dynamic> formData;
  final Function(String, dynamic) updateData;

  const StepSelectMaterials({
    super.key,
    required this.formData,
    required this.updateData,
  });

  @override
  State<StepSelectMaterials> createState() => _StepSelectMaterialsState();
}

class _StepSelectMaterialsState extends State<StepSelectMaterials> {
  static const Map<String, dynamic> _noCostItem = {
    "inventoryId": -1,
    "itemCode": "SIN-VALOR",
    "itemName": "Orden sin uso de Productos o Materiales",
    "currentStock": 999999,
    "avgCostValue": 0.0,
    "quantity": 1,
    "totalCost": 0.0,
    "isNoCostItem": true,
  };

  void _toggleNoCostItem() {
    final list = List<Map<String, dynamic>>.from(
      widget.formData['selectedMaterials'] ?? [],
    );

    final hasNoCostItem = list.any((item) => item['isNoCostItem'] == true);

    if (hasNoCostItem) {
      list.removeWhere((item) => item['isNoCostItem'] == true);
    } else {
      list.clear();
      list.add(_noCostItem);
    }

    widget.updateData('selectedMaterials', list);
  }

  void _openAddMaterialDialog() async {
    final result = await showDialog<MaterialWithQuantity>(
      context: context,
      barrierDismissible: false,
      builder: (_) => const MaterialSearchDialog(),
    );

    if (result != null && mounted) {
      final list = List<Map<String, dynamic>>.from(
        widget.formData['selectedMaterials'] ?? [],
      );

      list.add({
        "materialId": result.material.inventoryId,
        "itemCode": result.material.itemCode,
        "itemName": result.material.itemName,
        "quantity": result.quantity,
        "unitCost": result.material.avgCostValue,
        "totalCost": result.quantity * result.material.avgCostValue,
        "unitOfMeasure": result.material.unitOfMeasure,
      });

      widget.updateData('selectedMaterials', list);
    }
  }

  @override
  Widget build(BuildContext context) {
    final materials = List<Map<String, dynamic>>.from(
      widget.formData['selectedMaterials'] ?? [],
    );
    final total = materials.fold<double>(
      0.0,
      (sum, m) => sum + (m['totalCost'] ?? 0.0),
    );

    final hasNoCostItem = materials.any((m) => m['isNoCostItem'] == true);

    return SingleChildScrollView(
      padding: context.screenPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Materiales y Productos",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                    ),
                    ElevatedButton.icon(
                      onPressed: hasNoCostItem ? null : _openAddMaterialDialog,
                      icon: const Icon(
                        Icons.add,
                        size: 16,
                        color: Colors.white,
                      ),
                      label: const Text(
                        "Agregar",
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 6,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                GestureDetector(
                  onTap: _toggleNoCostItem,
                  child: Row(
                    children: [
                      Checkbox(
                        value: hasNoCostItem,
                        onChanged: (_) => _toggleNoCostItem(),
                        activeColor: Colors.orange,
                      ),
                      const Text(
                        "No agregar materiales",
                        style: TextStyle(fontSize: 13),
                      ),
                    ],
                  ),
                ),
                if (hasNoCostItem)
                  const Padding(
                    padding: EdgeInsets.only(left: 40, top: 4),
                    child: Text(
                      "No se pueden agregar materiales, está por continuar una orden sin materiales, desmarque esta opción para agregar materiales.",
                      style: TextStyle(fontSize: 12, color: Colors.orange),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          if (materials.isEmpty)
            const Center(
              child: Padding(
                padding: EdgeInsets.all(8),
                child: Text(
                  "No hay materiales agregados aún",
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
              ),
            )
          else
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 2),
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(5),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      blurRadius: 12,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(5),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minWidth: MediaQuery.of(context).size.width - 32,
                      ),
                      child: DataTable(
                        headingRowColor: MaterialStatePropertyAll(
                          AppColors.primary.withOpacity(0.12),
                        ),
                        columnSpacing: 16,
                        dataRowHeight: 40,
                        columns: const [
                          DataColumn(
                            label: Text(
                              'Material',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 11,
                              ),
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              'Código',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 11,
                              ),
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              'Cant.',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 11,
                              ),
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              'SubT.',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 11,
                              ),
                            ),
                          ),
                          DataColumn(label: Text('')),
                        ],
                        rows: materials.map((m) {
                          final isNoCost = m['isNoCostItem'] == true;
                          return DataRow(
                            color: MaterialStatePropertyAll(
                              isNoCost ? Colors.orange.shade50 : null,
                            ),
                            cells: [
                              DataCell(
                                Text(
                                  m['itemName'],
                                  style: const TextStyle(fontSize: 10),
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              DataCell(
                                Text(
                                  isNoCost ? "—" : m['itemCode'],
                                  style: const TextStyle(
                                    fontSize: 10,
                                    color: Colors.grey,
                                  ),
                                ),
                              ),
                              DataCell(
                                Text(
                                  isNoCost ? "—" : m['quantity'].toString(),
                                  style: TextStyle(
                                    color: isNoCost
                                        ? Colors.orange
                                        : AppColors.primary,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 10,
                                  ),
                                ),
                              ),
                              DataCell(
                                Text(
                                  "\$${m['totalCost'].toStringAsFixed(2)}",
                                  style: const TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              DataCell(
                                IconButton(
                                  icon: const Icon(
                                    Icons.delete,
                                    color: Colors.red,
                                    size: 20,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      materials.remove(m);
                                      widget.updateData(
                                        'selectedMaterials',
                                        materials,
                                      );
                                    });
                                  },
                                ),
                              ),
                            ],
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ),
              ),
            ),

          if (materials.isNotEmpty)
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 2, vertical: 10),
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.green.shade50,
                borderRadius: BorderRadius.circular(5),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        "${materials.length} material${materials.length == 1 ? '' : 'es'}",
                        style: TextStyle(fontSize: 13, color: Colors.grey[700]),
                      ),
                    ],
                  ),
                  const SizedBox(width: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      const Text(
                        "Total estimado: ",
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "\$${total.toStringAsFixed(2)}",
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

          if (materials.isEmpty && !hasNoCostItem)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Text(
                "Debe agregar al menos un material o marcar 'No agregar materiales'",
                style: TextStyle(
                  color: Colors.red.shade700,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),

          const SizedBox(height: 20),
        ],
      ),
    );
  }
}

// Clase auxiliar para devolver material + cantidad
class MaterialWithQuantity {
  final ProductMaterialEntity material;
  final int quantity;

  MaterialWithQuantity({required this.material, required this.quantity});
}
