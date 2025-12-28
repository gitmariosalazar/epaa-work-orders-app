// lib/features/work-orders/presentation/widgets/material_search_dialog.dart

import 'package:clean_architecture/core/constants/app_colors.dart';
import 'package:clean_architecture/core/data_states/data_state.dart';
import 'package:clean_architecture/features/products/domain/entities/product_material_entity.dart';
import 'package:clean_architecture/features/products/domain/usecases/product_material_use_case.dart';
import 'package:clean_architecture/features/work-orders/presentation/widgets/products-step/step_select_materials.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

final getIt = GetIt.instance;

class MaterialSearchDialog extends StatefulWidget {
  const MaterialSearchDialog({super.key});

  @override
  State<MaterialSearchDialog> createState() => _MaterialSearchDialogState();
}

class _MaterialSearchDialogState extends State<MaterialSearchDialog> {
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController(
    text: '1',
  );
  final ScrollController _scrollController = ScrollController();

  List<ProductMaterialEntity> _materials = [];
  bool _isLoading = true;
  bool _isLoadingMore = false;
  bool _hasMore = true;
  String? _errorMessage;
  String _currentQuery = '';
  int _offset = 0;
  final int _limit = 50;

  ProductMaterialEntity? selectedMaterial;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _loadMaterials(isRefresh: true);
      }
    });
  }

  Future<void> _loadMaterials({bool isRefresh = false}) async {
    if (isRefresh) {
      _offset = 0;
      _hasMore = true;
    }

    if (!_hasMore && !isRefresh) return;

    if (!mounted) return;

    setState(() {
      if (isRefresh) {
        _isLoading = true;
        _errorMessage = null;
      } else {
        _isLoadingMore = true;
      }
    });

    final useCase = getIt<GetAllProductMaterialsPaginatedUseCase>();
    final result = await useCase(
      ProductMaterialPaginatedParams(
        query: _currentQuery.isEmpty ? null : _currentQuery,
        limit: _limit,
        offset: _offset,
      ),
    );

    if (!mounted) return;

    result.when(
      success: (materials) {
        if (!mounted) return;

        setState(() {
          if (isRefresh) {
            _materials = materials;
          } else {
            _materials.addAll(materials);
          }

          _hasMore = materials.length == _limit;
          _offset += materials.length;
          _isLoading = false;
          _isLoadingMore = false;
        });
      },
      failure: (message, _) {
        if (!mounted) return;

        setState(() {
          _errorMessage = message ?? "Error al cargar materiales";
          _isLoading = false;
          _isLoadingMore = false;
        });
      },
      loading: () {},
    );
  }

  void _onSearchPressed() {
    _currentQuery = _searchController.text.trim();
    _loadMaterials(isRefresh: true);
  }

  void _onMaterialSelected(ProductMaterialEntity material) {
    setState(() {
      selectedMaterial = material;
      _quantityController.text = '1';
    });
  }

  void _addMaterial() {
    if (selectedMaterial == null) return;

    final qtyText = _quantityController.text.trim();
    final qty = int.tryParse(qtyText) ?? 0;

    if (qty <= 0 || qty > selectedMaterial!.currentStock) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            qty <= 0
                ? "Cantidad inválida"
                : "Cantidad excede el stock disponible",
          ),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    final result = MaterialWithQuantity(
      material: selectedMaterial!,
      quantity: qty,
    );

    Navigator.pop(context, result);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: const Text(
        "Agregar Material",
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
      content: SizedBox(
        width: double.maxFinite,
        height: MediaQuery.of(context).size.height * 0.7, // Altura fija
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _searchController,
              autofocus: true,
              style: const TextStyle(fontSize: 13),
              decoration: InputDecoration(
                hintText: "Buscar material",
                hintStyle: const TextStyle(fontSize: 13),
                prefixIcon: const Icon(Icons.search, size: 20),
                suffixIcon: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        _searchController.clear();
                        _onSearchPressed();
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.search),
                      onPressed: _onSearchPressed,
                      color: AppColors.primary,
                    ),
                  ],
                ),
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
              onSubmitted: (_) => _onSearchPressed(),
            ),

            const SizedBox(height: 8),

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

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  _isLoading
                      ? "Cargando..."
                      : "Mostrando ${_materials.length} materiales",
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[700],
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 12),

            if (selectedMaterial != null)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.blue.shade300, width: 1),
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
                          Text(_errorMessage!),
                          TextButton(
                            onPressed: () => _loadMaterials(isRefresh: true),
                            child: const Text("Reintentar"),
                          ),
                        ],
                      ),
                    )
                  : _materials.isEmpty
                  ? const Center(child: Text("No se encontraron resultados"))
                  : ListView.builder(
                      controller: _scrollController,
                      itemCount: _materials.length + (_isLoadingMore ? 1 : 0),
                      itemBuilder: (context, index) {
                        if (index == _materials.length) {
                          if (_hasMore) {
                            _loadMaterials();
                          }
                          return const Center(
                            child: Padding(
                              padding: EdgeInsets.all(8),
                              child: CircularProgressIndicator(),
                            ),
                          );
                        }

                        final item = _materials[index];
                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 3),
                          child: ListTile(
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 4,
                            ),
                            leading: const Icon(Icons.inventory_2, size: 20),
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
                            onTap: () => _onMaterialSelected(item),
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
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          onPressed: selectedMaterial == null ? null : _addMaterial,
          child: const Text(
            "Agregar",
            style: TextStyle(fontSize: 13, color: Colors.white),
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    _quantityController.dispose();
    _scrollController.dispose();
    super.dispose();
  }
}
