// features/work-orders/presentation/widgets/step_select_materials.dart

import 'package:clean_architecture/core/constants/app_colors.dart';
import 'package:clean_architecture/core/utils/responsive/responsive_utils.dart';
import 'package:clean_architecture/features/products/domain/entities/product_material_entity.dart';
import 'package:clean_architecture/features/products/domain/usecases/product_material_use_case.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

final getIt = GetIt.instance;

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
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController(
    text: '1',
  );

  // Ítem especial para "sin materiales con valor"
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

  List<ProductMaterialEntity> _allMaterials = [];
  List<ProductMaterialEntity> _filteredMaterials = [];
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadMaterials();
  }

  Future<void> _loadMaterials() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final useCase = getIt<GetAllProductMaterialsUseCase>();
    final result = await useCase();

    result.when(
      success: (materials) {
        setState(() {
          _allMaterials = materials;
          _filteredMaterials = materials;
          _isLoading = false;
        });
      },
      failure: (message, _) {
        setState(() {
          _errorMessage = message ?? "Error al cargar los materiales";
          _isLoading = false;
          _filteredMaterials = [];
        });
      },
      loading: () {
        // No hacemos nada, ya estamos en loading
      },
    );
  }

  void _filterMaterials(String query) {
    final lowerQuery = query.toLowerCase().trim();

    if (lowerQuery.isEmpty) {
      setState(() {
        _filteredMaterials = _allMaterials;
      });
    } else {
      setState(() {
        _filteredMaterials = _allMaterials.where((item) {
          return (item.itemCode?.toLowerCase().contains(lowerQuery) ?? false) ||
              (item.itemName?.toLowerCase().contains(lowerQuery) ?? false);
        }).toList();
      });
    }
  }

  void _openAddMaterialDialog() {
    _searchController.clear();
    _quantityController.text = '1';

    ProductMaterialEntity? selectedMaterial;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return AlertDialog(
              backgroundColor: Colors.white,
              surfaceTintColor: Colors.transparent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              title: const Text(
                "Agregar Material",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              content: SizedBox(
                width: double.maxFinite,
                height: MediaQuery.of(context).size.height * 0.8,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Búsqueda
                    TextField(
                      controller: _searchController,
                      autofocus: true,
                      style: const TextStyle(fontSize: 13),
                      decoration: InputDecoration(
                        hintText: "Buscar material",
                        hintStyle: const TextStyle(fontSize: 13),
                        prefixIcon: const Icon(Icons.search, size: 20),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        filled: true,
                        fillColor: Colors.grey.shade100,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 10,
                        ),
                      ),
                      onChanged: (value) {
                        _filterMaterials(value);
                        setStateDialog(() {});
                      },
                    ),

                    const SizedBox(height: 8),

                    // Cantidad
                    TextField(
                      controller: _quantityController,
                      keyboardType: TextInputType.number,
                      style: const TextStyle(fontSize: 13),
                      decoration: InputDecoration(
                        labelText: "Cantidad",
                        labelStyle: const TextStyle(fontSize: 12),
                        prefixText: "# ",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        filled: true,
                        fillColor: Colors.grey.shade100,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 10,
                        ),
                      ),
                    ),

                    const SizedBox(height: 12),
                    // CONTADOR DE PRODUCTOS EN EL DIÁLOGO
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Mostrando ${_filteredMaterials.length} de ${_allMaterials.length} materiales",
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[700],
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 12),

                    // Material seleccionado
                    if (selectedMaterial != null)
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.blue.shade50,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: Colors.blue.shade300,
                            width: 1,
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Icon(
                                  Icons.check_circle,
                                  color: Colors.blue,
                                  size: 18,
                                ),
                                const SizedBox(width: 6),
                                Expanded(
                                  child: Text(
                                    "${selectedMaterial!.itemCode} - ${selectedMaterial!.itemName}",
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 11,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(
                              "Unidad: ${selectedMaterial!.unitOfMeasure} | Stock: ${selectedMaterial!.currentStock}",
                              style: const TextStyle(fontSize: 12),
                            ),
                          ],
                        ),
                      ),

                    const SizedBox(height: 8),

                    Expanded(
                      child: _isLoading
                          ? const Center(child: CircularProgressIndicator())
                          : _errorMessage != null
                          ? Center(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(
                                    Icons.error_outline,
                                    color: Colors.red,
                                    size: 48,
                                  ),
                                  const SizedBox(height: 8),
                                  Text(_errorMessage!),
                                  TextButton(
                                    onPressed: _loadMaterials,
                                    child: const Text("Reintentar"),
                                  ),
                                ],
                              ),
                            )
                          : _filteredMaterials.isEmpty
                          ? const Center(
                              child: Text(
                                "No se encontraron resultados",
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 13,
                                ),
                              ),
                            )
                          : ListView.builder(
                              padding: EdgeInsets.zero,
                              itemCount: _filteredMaterials.length,
                              itemBuilder: (context, index) {
                                final item = _filteredMaterials[index];
                                return Card(
                                  margin: const EdgeInsets.symmetric(
                                    vertical: 3,
                                  ),
                                  child: ListTile(
                                    contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 4,
                                    ),
                                    leading: const Icon(
                                      Icons.inventory_2,
                                      size: 20,
                                    ),
                                    title: Text(
                                      "${item.itemCode} - ${item.itemName}",
                                      style: const TextStyle(fontSize: 12),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    subtitle: Text(
                                      "Stock: ${item.currentStock}",
                                      style: const TextStyle(fontSize: 11),
                                    ),
                                    onTap: () {
                                      selectedMaterial = item;
                                      setStateDialog(() {});
                                    },
                                  ),
                                );
                              },
                            ),
                    ),
                  ],
                ),
              ),
              actionsPadding: const EdgeInsets.only(bottom: 0, top: 8),
              actionsAlignment: MainAxisAlignment.center,
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Cancelar", style: TextStyle(fontSize: 13)),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: selectedMaterial == null
                      ? null
                      : () {
                          final qtyText = _quantityController.text.trim();
                          if (qtyText.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Ingrese una cantidad"),
                              ),
                            );
                            return;
                          }

                          final qty = int.tryParse(qtyText);
                          if (qty == null || qty <= 0) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Cantidad inválida"),
                              ),
                            );
                            return;
                          }

                          if (qty > selectedMaterial!.currentStock) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  "Cantidad excede el stock disponible",
                                ),
                              ),
                            );
                            return;
                          }

                          final newItem = {
                            "materialId": selectedMaterial!.inventoryId,
                            "itemCode": selectedMaterial!.itemCode,
                            "itemName": selectedMaterial!.itemName,
                            "quantity": qty,
                            "unitCost": selectedMaterial!.avgCostValue,
                            "totalCost": qty * selectedMaterial!.avgCostValue,
                            "unitOfMeasure": selectedMaterial!.unitOfMeasure,
                          };

                          setState(() {
                            final list = List<Map<String, dynamic>>.from(
                              widget.formData['selectedMaterials'] ?? [],
                            );
                            list.add(newItem);
                            widget.updateData('selectedMaterials', list);
                          });

                          Navigator.pop(context);
                        },
                  child: const Text(
                    "Agregar",
                    style: TextStyle(fontSize: 13, color: Colors.white),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

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

          // VALIDACIÓN VISUAL: Mensaje si no hay materiales y no está marcado "No agregar materiales"
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

  @override
  void dispose() {
    _searchController.dispose();
    _quantityController.dispose();
    super.dispose();
  }
}
