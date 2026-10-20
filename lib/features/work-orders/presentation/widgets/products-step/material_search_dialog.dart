// lib/features/work-orders/presentation/widgets/material_search_dialog.dart

import 'package:clean_architecture/features/products/domain/entities/product_material_entity.dart';
import 'package:clean_architecture/features/products/domain/usecases/product_material_use_case.dart';
import 'package:clean_architecture/features/work-orders/presentation/widgets/products-step/step_select_materials.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
    _scrollController.addListener(_onScroll);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _loadMaterials(isRefresh: true);
      }
    });
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 200 &&
        !_isLoadingMore &&
        _hasMore &&
        !_isLoading) {
      _loadMaterials();
    }
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

  void _incrementQuantity() {
    final current = int.tryParse(_quantityController.text.trim()) ?? 1;
    final maxStock = selectedMaterial?.currentStock;
    if (maxStock != null && current >= maxStock) return;
    setState(() {
      _quantityController.text = (current + 1).toString();
    });
  }

  void _decrementQuantity() {
    final current = int.tryParse(_quantityController.text.trim()) ?? 1;
    if (current <= 1) return;
    setState(() {
      _quantityController.text = (current - 1).toString();
    });
  }

  void _addMaterial() {
    if (selectedMaterial == null) return;

    final qtyText = _quantityController.text.trim();
    final qty = int.tryParse(qtyText) ?? 0;

    if (qty <= 0 || qty > selectedMaterial!.currentStock) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(
                Icons.error_outline_rounded,
                color: Theme.of(context).colorScheme.onError,
                size: 20,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  qty <= 0
                      ? "Ingrese una cantidad válida mayor a 0"
                      : "La cantidad excede el stock disponible (${selectedMaterial!.currentStock})",
                  style: TextStyle(
                    fontSize: 13,
                    color: Theme.of(context).colorScheme.onError,
                  ),
                ),
              ),
            ],
          ),
          backgroundColor: Theme.of(context).colorScheme.error,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
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
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;
    final size = MediaQuery.of(context).size;

    final currentQty = int.tryParse(_quantityController.text.trim()) ?? 1;
    final canIncrement =
        selectedMaterial == null || currentQty < selectedMaterial!.currentStock;
    final canDecrement = currentQty > 1;

    return Dialog(
      backgroundColor: isDark ? cs.surfaceContainerHighest : Colors.white,
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
        side: BorderSide(
          color: isDark ? cs.outlineVariant : const Color(0xFFE2E8F0),
          width: 1,
        ),
      ),
      elevation: isDark ? 8 : 12,
      clipBehavior: Clip.antiAlias,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: 540,
          maxHeight: size.height * 0.85,
        ),
        child: Column(
          children: [
            // ── Header con icono distintivo y botón cerrar ──────────────────
            Container(
              padding: const EdgeInsets.fromLTRB(20, 18, 16, 16),
              decoration: BoxDecoration(
                color: isDark ? cs.surfaceContainerHighest : Colors.white,
                border: Border(
                  bottom: BorderSide(
                    color: isDark ? cs.outlineVariant : const Color(0xFFE2E8F0),
                    width: 1,
                  ),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: cs.primary.withValues(alpha: isDark ? 0.22 : 0.12),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: cs.primary.withValues(
                          alpha: isDark ? 0.45 : 0.25,
                        ),
                        width: 1,
                      ),
                    ),
                    alignment: Alignment.center,
                    child: Icon(
                      Icons.inventory_2_rounded,
                      color: isDark ? const Color(0xFF38BDF8) : cs.primary,
                      size: 22,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Agregar Material",
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w700,
                            letterSpacing: -0.3,
                            color: cs.onSurface,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          "Selecciona un ítem del inventario y define la cantidad",
                          style: TextStyle(
                            fontSize: 12,
                            color: cs.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.close_rounded,
                      color: cs.onSurfaceVariant,
                      size: 22,
                    ),
                    tooltip: 'Cerrar',
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),

            // ── Contenido Principal ─────────────────────────────────────────
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 14,
                ),
                child: Column(
                  children: [
                    // Campo de Búsqueda
                    Container(
                      decoration: BoxDecoration(
                        color: isDark
                            ? cs.surfaceContainerHigh
                            : const Color(0xFFF8FAFC),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: isDark
                              ? cs.outlineVariant
                              : const Color(0xFFE2E8F0),
                        ),
                      ),
                      child: TextField(
                        controller: _searchController,
                        autofocus: false,
                        style: TextStyle(
                          fontSize: 13.5,
                          color: cs.onSurface,
                          fontWeight: FontWeight.w500,
                        ),
                        decoration: InputDecoration(
                          hintText: "Buscar por nombre o código SKU...",
                          hintStyle: TextStyle(
                            fontSize: 13,
                            color: cs.onSurfaceVariant.withValues(alpha: 0.7),
                          ),
                          prefixIcon: Icon(
                            Icons.search_rounded,
                            size: 20,
                            color: isDark
                                ? const Color(0xFF38BDF8)
                                : cs.primary,
                          ),
                          suffixIcon: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              if (_searchController.text.isNotEmpty)
                                IconButton(
                                  icon: const Icon(
                                    Icons.clear_rounded,
                                    size: 18,
                                  ),
                                  color: cs.onSurfaceVariant,
                                  onPressed: () {
                                    _searchController.clear();
                                    _onSearchPressed();
                                  },
                                ),
                              Container(
                                margin: const EdgeInsets.only(
                                  right: 6,
                                  left: 4,
                                  top: 4,
                                  bottom: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: cs.primary,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: IconButton(
                                  constraints: const BoxConstraints(
                                    minWidth: 32,
                                    minHeight: 32,
                                  ),
                                  padding: EdgeInsets.zero,
                                  tooltip: 'Buscar',
                                  icon: const Icon(
                                    Icons.arrow_forward_rounded,
                                    size: 18,
                                    color: Colors.white,
                                  ),
                                  onPressed: _onSearchPressed,
                                ),
                              ),
                            ],
                          ),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 14,
                          ),
                        ),
                        onSubmitted: (_) => _onSearchPressed(),
                      ),
                    ),

                    const SizedBox(height: 10),

                    // Selector de Cantidad con Stepper (+ / -) y unidad
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 8, // ↑ más padding vertical
                      ),
                      decoration: BoxDecoration(
                        color: isDark
                            ? cs.surfaceContainerHigh
                            : const Color(0xFFF8FAFC),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: isDark
                              ? cs.outlineVariant
                              : const Color(0xFFE2E8F0),
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.format_list_numbered_rounded,
                            size: 22,
                            color: isDark
                                ? const Color(0xFF38BDF8)
                                : cs.primary,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  "Cantidad a utilizar",
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                    color: cs.onSurfaceVariant,
                                  ),
                                ),
                                const SizedBox(
                                  height: 2,
                                ), // pequeño espacio extra
                                TextField(
                                  controller: _quantityController,
                                  keyboardType: TextInputType.number,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly,
                                  ],
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    height: 1.3,
                                    color: cs.onSurface,
                                  ),
                                  decoration: const InputDecoration(
                                    border: InputBorder.none,
                                    isDense: false,
                                    contentPadding: EdgeInsets.only(
                                      left:
                                          8, // ← aquí controlas cuánto se mueve a la derecha
                                      top: 6,
                                      bottom: 6,
                                    ),
                                  ),
                                  onChanged: (_) => setState(() {}),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(width: 10),

                          // Botones de incremento / decremento
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              _StepperButton(
                                icon: Icons.add_rounded,
                                enabled: canIncrement,
                                onTap: _incrementQuantity,
                              ),
                              const SizedBox(height: 6),
                              _StepperButton(
                                icon: Icons.remove_rounded,
                                enabled: canDecrement,
                                onTap: _decrementQuantity,
                              ),
                            ],
                          ),

                          // Badge de Unidad de Medida
                          if (selectedMaterial != null) ...[
                            const SizedBox(width: 10),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: cs.primary.withValues(
                                  alpha: isDark ? 0.22 : 0.10,
                                ),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: cs.primary.withValues(
                                    alpha: isDark ? 0.45 : 0.25,
                                  ),
                                ),
                              ),
                              child: Text(
                                selectedMaterial!.unitOfMeasure,
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                  color: isDark
                                      ? const Color(0xFF38BDF8)
                                      : cs.primary,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),

                    // Tarjeta de Material Seleccionado (Banner destacado)
                    if (selectedMaterial != null)
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 250),
                        margin: const EdgeInsets.only(bottom: 10),
                        width: double.infinity,
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: cs.primary.withValues(
                            alpha: isDark ? 0.18 : 0.06,
                          ),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: cs.primary.withValues(
                              alpha: isDark ? 0.6 : 0.4,
                            ),
                            width: 1.4,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: cs.primary.withValues(
                                alpha: isDark ? 0.15 : 0.08,
                              ),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 2),
                              child: Icon(
                                Icons.check_circle_rounded,
                                color: isDark
                                    ? const Color(0xFF38BDF8)
                                    : cs.primary,
                                size: 20,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 6,
                                          vertical: 2,
                                        ),
                                        decoration: BoxDecoration(
                                          color: isDark
                                              ? cs.surfaceContainerHighest
                                              : Colors.white,
                                          borderRadius: BorderRadius.circular(
                                            6,
                                          ),
                                          border: Border.all(
                                            color: cs.primary.withValues(
                                              alpha: 0.3,
                                            ),
                                          ),
                                        ),
                                        child: Text(
                                          selectedMaterial!.itemCode,
                                          style: TextStyle(
                                            fontSize: 10.5,
                                            fontWeight: FontWeight.w700,
                                            fontFamily: 'monospace',
                                            color: isDark
                                                ? const Color(0xFF38BDF8)
                                                : cs.primary,
                                          ),
                                        ),
                                      ),
                                      const Spacer(),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 8,
                                          vertical: 2,
                                        ),
                                        decoration: BoxDecoration(
                                          color:
                                              selectedMaterial!.currentStock > 0
                                              ? (isDark
                                                    ? const Color(0xFF064E3B)
                                                    : const Color(0xFFDCFCE7))
                                              : (isDark
                                                    ? const Color(0xFF7F1D1D)
                                                    : const Color(0xFFFEE2E2)),
                                          borderRadius: BorderRadius.circular(
                                            6,
                                          ),
                                        ),
                                        child: Text(
                                          "Stock: ${selectedMaterial!.currentStock}",
                                          style: TextStyle(
                                            fontSize: 11,
                                            fontWeight: FontWeight.bold,
                                            color:
                                                selectedMaterial!.currentStock >
                                                    0
                                                ? (isDark
                                                      ? const Color(0xFF4ADE80)
                                                      : const Color(0xFF166534))
                                                : (isDark
                                                      ? const Color(0xFFF87171)
                                                      : const Color(
                                                          0xFF991B1B,
                                                        )),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    selectedMaterial!.itemName,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 13,
                                      color: cs.onSurface,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.close_rounded, size: 18),
                              tooltip: 'Deseleccionar',
                              color: cs.onSurfaceVariant,
                              onPressed: () {
                                setState(() {
                                  selectedMaterial = null;
                                });
                              },
                            ),
                          ],
                        ),
                      ),

                    // Contador / Info
                    Padding(
                      padding: const EdgeInsets.only(
                        bottom: 8,
                        left: 4,
                        right: 4,
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.list_alt_rounded,
                            size: 15,
                            color: cs.onSurfaceVariant,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            _isLoading
                                ? "Buscando existencias en bodega..."
                                : "Resultados: ${_materials.length} materiales",
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: cs.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Lista de Materiales
                    Expanded(
                      child: _isLoading
                          ? Center(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  CircularProgressIndicator(
                                    strokeWidth: 3,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      cs.primary,
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  Text(
                                    "Cargando inventario...",
                                    style: TextStyle(
                                      fontSize: 12.5,
                                      color: cs.onSurfaceVariant,
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : _errorMessage != null
                          ? Center(
                              child: Padding(
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.cloud_off_rounded,
                                      size: 42,
                                      color: cs.error,
                                    ),
                                    const SizedBox(height: 10),
                                    Text(
                                      _errorMessage!,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 13,
                                        color: cs.onSurface,
                                      ),
                                    ),
                                    const SizedBox(height: 12),
                                    OutlinedButton.icon(
                                      icon: const Icon(
                                        Icons.refresh_rounded,
                                        size: 16,
                                      ),
                                      label: const Text("Reintentar"),
                                      style: OutlinedButton.styleFrom(
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            10,
                                          ),
                                        ),
                                      ),
                                      onPressed: () =>
                                          _loadMaterials(isRefresh: true),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          : _materials.isEmpty
                          ? Center(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.inventory_outlined,
                                    size: 46,
                                    color: cs.onSurfaceVariant.withValues(
                                      alpha: 0.6,
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    "No se encontraron materiales",
                                    style: TextStyle(
                                      fontSize: 13.5,
                                      fontWeight: FontWeight.w600,
                                      color: cs.onSurface,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    "Intenta con otro término o código SKU",
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: cs.onSurfaceVariant,
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : ListView.separated(
                              controller: _scrollController,
                              physics: const BouncingScrollPhysics(),
                              itemCount:
                                  _materials.length + (_isLoadingMore ? 1 : 0),
                              separatorBuilder: (_, _) =>
                                  const SizedBox(height: 6),
                              itemBuilder: (context, index) {
                                if (index == _materials.length) {
                                  return const Center(
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(
                                        vertical: 14,
                                      ),
                                      child: SizedBox(
                                        width: 22,
                                        height: 22,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2.5,
                                        ),
                                      ),
                                    ),
                                  );
                                }

                                final item = _materials[index];
                                final isSelected =
                                    selectedMaterial?.itemCode == item.itemCode;
                                final hasStock = item.currentStock > 0;

                                return InkWell(
                                  borderRadius: BorderRadius.circular(14),
                                  onTap: () => _onMaterialSelected(item),
                                  child: AnimatedContainer(
                                    duration: const Duration(milliseconds: 200),
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 10,
                                    ),
                                    decoration: BoxDecoration(
                                      color: isSelected
                                          ? cs.primary.withValues(
                                              alpha: isDark ? 0.20 : 0.08,
                                            )
                                          : (isDark
                                                ? cs.surfaceContainerHigh
                                                : Colors.white),
                                      borderRadius: BorderRadius.circular(14),
                                      border: Border.all(
                                        color: isSelected
                                            ? cs.primary
                                            : (isDark
                                                  ? cs.outlineVariant
                                                  : const Color(0xFFE2E8F0)),
                                        width: isSelected ? 1.6 : 1,
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withValues(
                                            alpha: isDark
                                                ? 0.15
                                                : (isSelected ? 0.06 : 0.02),
                                          ),
                                          blurRadius: isSelected ? 6 : 4,
                                          offset: const Offset(0, 2),
                                        ),
                                      ],
                                    ),
                                    child: Row(
                                      children: [
                                        // Icono de material / selección
                                        Container(
                                          width: 38,
                                          height: 38,
                                          decoration: BoxDecoration(
                                            color: isSelected
                                                ? cs.primary
                                                : cs.primary.withValues(
                                                    alpha: isDark ? 0.20 : 0.08,
                                                  ),
                                            borderRadius: BorderRadius.circular(
                                              10,
                                            ),
                                          ),
                                          child: Icon(
                                            isSelected
                                                ? Icons.check_rounded
                                                : Icons.widgets_outlined,
                                            size: 20,
                                            color: isSelected
                                                ? Colors.white
                                                : (isDark
                                                      ? const Color(0xFF38BDF8)
                                                      : cs.primary),
                                          ),
                                        ),
                                        const SizedBox(width: 12),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                children: [
                                                  Container(
                                                    padding:
                                                        const EdgeInsets.symmetric(
                                                          horizontal: 6,
                                                          vertical: 1.5,
                                                        ),
                                                    decoration: BoxDecoration(
                                                      color: isDark
                                                          ? cs.surfaceContainerHighest
                                                          : const Color(
                                                              0xFFF1F5F9,
                                                            ),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            6,
                                                          ),
                                                      border: Border.all(
                                                        color: isDark
                                                            ? cs.outlineVariant
                                                            : const Color(
                                                                0xFFE2E8F0,
                                                              ),
                                                      ),
                                                    ),
                                                    child: Text(
                                                      item.itemCode,
                                                      style: TextStyle(
                                                        fontSize: 10,
                                                        fontWeight:
                                                            FontWeight.w700,
                                                        fontFamily: 'monospace',
                                                        color: isDark
                                                            ? const Color(
                                                                0xFF38BDF8,
                                                              )
                                                            : cs.primary,
                                                      ),
                                                    ),
                                                  ),
                                                  const SizedBox(width: 6),
                                                  Text(
                                                    item.unitOfMeasure,
                                                    style: TextStyle(
                                                      fontSize: 11,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      color:
                                                          cs.onSurfaceVariant,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(height: 3),
                                              Text(
                                                item.itemName,
                                                style: TextStyle(
                                                  fontSize: 12.5,
                                                  fontWeight: isSelected
                                                      ? FontWeight.w700
                                                      : FontWeight.w500,
                                                  color: cs.onSurface,
                                                ),
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: [
                                            Text(
                                              "Stock",
                                              style: TextStyle(
                                                fontSize: 10,
                                                fontWeight: FontWeight.w500,
                                                color: cs.onSurfaceVariant,
                                              ),
                                            ),
                                            const SizedBox(height: 2),
                                            Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: 8,
                                                    vertical: 2,
                                                  ),
                                              decoration: BoxDecoration(
                                                color: hasStock
                                                    ? (isDark
                                                          ? const Color(
                                                              0xFF064E3B,
                                                            )
                                                          : const Color(
                                                              0xFFDCFCE7,
                                                            ))
                                                    : (isDark
                                                          ? const Color(
                                                              0xFF7F1D1D,
                                                            )
                                                          : const Color(
                                                              0xFFFEE2E2,
                                                            )),
                                                borderRadius:
                                                    BorderRadius.circular(6),
                                              ),
                                              child: Text(
                                                "${item.currentStock}",
                                                style: TextStyle(
                                                  fontSize: 11,
                                                  fontWeight: FontWeight.bold,
                                                  color: hasStock
                                                      ? (isDark
                                                            ? const Color(
                                                                0xFF4ADE80,
                                                              )
                                                            : const Color(
                                                                0xFF166534,
                                                              ))
                                                      : (isDark
                                                            ? const Color(
                                                                0xFFF87171,
                                                              )
                                                            : const Color(
                                                                0xFF991B1B,
                                                              )),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                    ),
                  ],
                ),
              ),
            ),

            // ── Footer / Acciones ───────────────────────────────────────────
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              decoration: BoxDecoration(
                color: isDark ? cs.surfaceContainerHighest : Colors.white,
                border: Border(
                  top: BorderSide(
                    color: isDark ? cs.outlineVariant : const Color(0xFFE2E8F0),
                    width: 1,
                  ),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text(
                      "Cancelar",
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: cs.onSurfaceVariant,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.add_rounded, size: 18),
                    label: const Text(
                      "Agregar a la Orden",
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: cs.primary,
                      foregroundColor: cs.onPrimary,
                      elevation: 1,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      disabledBackgroundColor: isDark
                          ? cs.surfaceContainerHigh
                          : const Color(0xFFE2E8F0),
                      disabledForegroundColor: cs.onSurfaceVariant.withValues(
                        alpha: 0.6,
                      ),
                    ),
                    onPressed: selectedMaterial == null ? null : _addMaterial,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _searchController.dispose();
    _quantityController.dispose();
    _scrollController.dispose();
    super.dispose();
  }
}

class _StepperButton extends StatelessWidget {
  final IconData icon;
  final bool enabled;
  final VoidCallback onTap;

  const _StepperButton({
    required this.icon,
    required this.enabled,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    return Material(
      color: enabled
          ? (isDark ? cs.surfaceContainerHighest : Colors.white)
          : (isDark ? cs.surfaceContainerLow : const Color(0xFFE2E8F0)),
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        onTap: enabled ? onTap : null,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isDark ? cs.outlineVariant : const Color(0xFFE2E8F0),
            ),
          ),
          alignment: Alignment.center,
          child: Icon(
            icon,
            size: 16,
            color: enabled
                ? cs.onSurface
                : cs.onSurfaceVariant.withValues(alpha: 0.4),
          ),
        ),
      ),
    );
  }
}
