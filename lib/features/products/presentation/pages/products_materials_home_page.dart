// features/products/presentation/pages/products_materials_home_page.dart

import 'package:auto_route/auto_route.dart';
import 'package:clean_architecture/components/loaders/professional_loader.dart';
import 'package:clean_architecture/features/products/domain/entities/product_material_entity.dart';
import 'package:clean_architecture/features/products/domain/usecases/product_material_use_case.dart';
import 'package:clean_architecture/features/products/presentation/cubits/products/products_cubit.dart';
import 'package:clean_architecture/features/products/presentation/cubits/products/products_state.dart';
import 'package:clean_architecture/features/products/presentation/widgets/products_materials_card.dart';
import 'package:clean_architecture/shared_ui/ui/base/app_bar/base_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

@RoutePage()
class ProductsMaterialsHomePage extends StatelessWidget {
  const ProductsMaterialsHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ProductsMaterialsCubit(
        getAllProductsMaterialsUseCase:
            GetIt.I<GetAllProductMaterialsUseCase>(),
      )..loadProductsMaterials(),
      child: const _ProductsMaterialsView(),
    );
  }
}

class _ProductsMaterialsView extends StatefulWidget {
  const _ProductsMaterialsView();

  @override
  State<_ProductsMaterialsView> createState() => _ProductsMaterialsViewState();
}

class _ProductsMaterialsViewState extends State<_ProductsMaterialsView> {
  final _searchController = TextEditingController();
  String? _filterType; // 'M' = Material, 'P' = Producto
  String? _filterStatus; // 'A' = Activo

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  int get _activeFilterCount =>
      (_filterType != null ? 1 : 0) + (_filterStatus != null ? 1 : 0);

  bool get _hasActiveFilters => _activeFilterCount > 0;
  bool get _hasActiveSearch => _searchController.text.trim().isNotEmpty;
  bool get _hasAnyFilterOrSearch => _hasActiveFilters || _hasActiveSearch;

  void _clearAllFilters() {
    setState(() {
      _searchController.clear();
      _filterType = null;
      _filterStatus = null;
    });
  }

  void _showFilterModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (modalContext) {
        String? tempType = _filterType;
        String? tempStatus = _filterStatus;

        return StatefulBuilder(
          builder: (context, setModalState) {
            final cs = Theme.of(context).colorScheme;
            final isDark = Theme.of(context).brightness == Brightness.dark;

            return Container(
              decoration: BoxDecoration(
                color: isDark ? cs.surfaceContainerHigh : cs.surface,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(24),
                ),
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
                20 + MediaQuery.of(modalContext).padding.bottom,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Drag Handle
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
                  const SizedBox(height: 14),

                  // Título del modal
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(7),
                            decoration: BoxDecoration(
                              color: cs.primary.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(
                              Icons.tune_rounded,
                              size: 18,
                              color: cs.primary,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Text(
                            'Filtros de Inventario',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: cs.onSurface,
                            ),
                          ),
                        ],
                      ),
                      if (tempType != null || tempStatus != null)
                        TextButton(
                          onPressed: () {
                            setModalState(() {
                              tempType = null;
                              tempStatus = null;
                            });
                          },
                          child: Text(
                            'Restablecer',
                            style: TextStyle(
                              color: cs.primary,
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 18),

                  // Sección: Tipo de Ítem
                  Text(
                    'Tipo de Registro',
                    style: TextStyle(
                      fontSize: 12.5,
                      fontWeight: FontWeight.w600,
                      color: cs.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    children: [
                      _FilterChoiceChip(
                        label: 'Todos los tipos',
                        icon: Icons.all_inclusive_rounded,
                        isSelected: tempType == null,
                        onSelected: () => setModalState(() => tempType = null),
                      ),
                      _FilterChoiceChip(
                        label: 'Materiales (M)',
                        icon: Icons.handyman_outlined,
                        isSelected: tempType == 'M',
                        onSelected: () => setModalState(() => tempType = 'M'),
                      ),
                      _FilterChoiceChip(
                        label: 'Productos (P)',
                        icon: Icons.inventory_2_outlined,
                        isSelected: tempType == 'P',
                        onSelected: () => setModalState(() => tempType = 'P'),
                      ),
                    ],
                  ),

                  const SizedBox(height: 18),

                  // Sección: Estado
                  Text(
                    'Estado en Inventario',
                    style: TextStyle(
                      fontSize: 12.5,
                      fontWeight: FontWeight.w600,
                      color: cs.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    children: [
                      _FilterChoiceChip(
                        label: 'Todos los estados',
                        icon: Icons.all_inclusive_rounded,
                        isSelected: tempStatus == null,
                        onSelected: () =>
                            setModalState(() => tempStatus = null),
                      ),
                      _FilterChoiceChip(
                        label: 'Solo Activos (A)',
                        icon: Icons.check_circle_outline_rounded,
                        isSelected: tempStatus == 'A',
                        onSelected: () => setModalState(() => tempStatus = 'A'),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // Botones de acción
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => Navigator.pop(modalContext),
                          style: OutlinedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            side: BorderSide(
                              color: cs.outlineVariant.withValues(alpha: 0.6),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                          child: Text(
                            'Cancelar',
                            style: TextStyle(
                              color: cs.onSurface,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: FilledButton.icon(
                          onPressed: () {
                            setState(() {
                              _filterType = tempType;
                              _filterStatus = tempStatus;
                            });
                            Navigator.pop(modalContext);
                          },
                          icon: const Icon(Icons.check_rounded, size: 18),
                          label: const Text('Aplicar Filtros'),
                          style: FilledButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: BaseAppBar(
        title: 'Productos y Materiales',
        centerTitle: true,
        actions: [
          IconButton(
            icon: Badge.count(
              count: _activeFilterCount,
              isLabelVisible: _hasActiveFilters,
              backgroundColor: cs.primary,
              textColor: cs.onPrimary,
              child: const Icon(Icons.tune_rounded),
            ),
            onPressed: _showFilterModal,
            tooltip: 'Filtros',
          ),
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            onPressed: () =>
                context.read<ProductsMaterialsCubit>().loadProductsMaterials(),
            tooltip: 'Recargar',
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Barra de Búsqueda Moderna
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 6),
            child: Container(
              decoration: BoxDecoration(
                color: isDark
                    ? cs.surfaceContainerHighest.withValues(alpha: 0.5)
                    : theme.cardColor,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: cs.outlineVariant.withValues(
                    alpha: isDark ? 0.35 : 0.6,
                  ),
                  width: 0.9,
                ),
                boxShadow: [
                  BoxShadow(
                    color: cs.shadow.withValues(alpha: isDark ? 0.2 : 0.04),
                    blurRadius: 10,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: TextField(
                controller: _searchController,
                textInputAction: TextInputAction.search,
                style: TextStyle(
                  color: cs.onSurface,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
                decoration: InputDecoration(
                  hintText: 'Buscar por nombre, código o clave...',
                  hintStyle: TextStyle(
                    color: cs.onSurfaceVariant.withValues(alpha: 0.7),
                    fontSize: 13.5,
                  ),
                  prefixIcon: Icon(
                    Icons.search_rounded,
                    color: cs.primary,
                    size: 21,
                  ),
                  suffixIcon: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (_searchController.text.isNotEmpty)
                        IconButton(
                          icon: const Icon(Icons.clear_rounded, size: 18),
                          color: cs.onSurfaceVariant,
                          tooltip: 'Borrar texto',
                          onPressed: () {
                            _searchController.clear();
                            setState(() {});
                          },
                        ),
                      IconButton(
                        icon: Badge.count(
                          count: _activeFilterCount,
                          isLabelVisible: _hasActiveFilters,
                          backgroundColor: cs.primary,
                          textColor: cs.onPrimary,
                          child: Icon(
                            Icons.tune_rounded,
                            size: 20,
                            color: _hasActiveFilters
                                ? cs.primary
                                : cs.onSurfaceVariant,
                          ),
                        ),
                        tooltip: 'Filtros avanzados',
                        onPressed: _showFilterModal,
                      ),
                      const SizedBox(width: 4),
                    ],
                  ),
                  filled: false,
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 12,
                  ),
                ),
                onChanged: (_) => setState(() {}),
              ),
            ),
          ),

          // Selector Rápido de Categorías (Pills: Todos, Materiales, Productos)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              child: Row(
                children: [
                  _QuickTypeTab(
                    label: 'Todos',
                    icon: Icons.grid_view_rounded,
                    isSelected: _filterType == null,
                    onTap: () => setState(() => _filterType = null),
                  ),
                  const SizedBox(width: 8),
                  _QuickTypeTab(
                    label: 'Materiales',
                    icon: Icons.handyman_outlined,
                    isSelected: _filterType == 'M',
                    onTap: () => setState(() => _filterType = 'M'),
                  ),
                  const SizedBox(width: 8),
                  _QuickTypeTab(
                    label: 'Productos',
                    icon: Icons.inventory_2_outlined,
                    isSelected: _filterType == 'P',
                    onTap: () => setState(() => _filterType = 'P'),
                  ),
                  if (_filterStatus == 'A') ...[
                    const SizedBox(width: 8),
                    InputChip(
                      avatar: const Icon(
                        Icons.check_circle_outline_rounded,
                        size: 14,
                        color: Color(0xFF109335),
                      ),
                      label: const Text('Solo Activos'),
                      labelStyle: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF109335),
                      ),
                      backgroundColor: const Color(
                        0xFF109335,
                      ).withValues(alpha: 0.1),
                      side: BorderSide(
                        color: const Color(0xFF109335).withValues(alpha: 0.3),
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      onDeleted: () => setState(() => _filterStatus = null),
                    ),
                  ],
                ],
              ),
            ),
          ),

          // Chips de búsqueda activa
          if (_hasActiveSearch)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
              child: Row(
                children: [
                  InputChip(
                    avatar: Icon(
                      Icons.search_rounded,
                      size: 14,
                      color: cs.primary,
                    ),
                    label: Text('"${_searchController.text.trim()}"'),
                    labelStyle: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: cs.onSurface,
                    ),
                    backgroundColor: cs.primary.withValues(
                      alpha: isDark ? 0.15 : 0.08,
                    ),
                    side: BorderSide(
                      color: cs.primary.withValues(alpha: isDark ? 0.35 : 0.25),
                      width: 0.8,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    onDeleted: () {
                      _searchController.clear();
                      setState(() {});
                    },
                  ),
                  const SizedBox(width: 6),
                  TextButton.icon(
                    onPressed: _clearAllFilters,
                    icon: const Icon(Icons.close_rounded, size: 14),
                    label: const Text('Limpiar todo'),
                    style: TextButton.styleFrom(
                      visualDensity: VisualDensity.compact,
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      textStyle: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),

          // Contenido Principal
          Expanded(
            child: BlocBuilder<ProductsMaterialsCubit, ProductsMaterialsState>(
              builder: (context, state) {
                if (state is ProductsMaterialsLoading ||
                    state is ProductsMaterialsInitial) {
                  return const Center(
                    child: ProfessionalLoader(
                      label: 'Cargando inventario...',
                      description:
                          'Obteniendo productos y materiales de bodega',
                    ),
                  );
                }

                if (state is ProductsMaterialsError) {
                  return Center(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(28),
                      child: Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: isDark
                              ? cs.surfaceContainerHighest.withValues(
                                  alpha: 0.5,
                                )
                              : theme.cardColor,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: cs.error.withValues(alpha: 0.25),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: cs.shadow.withValues(
                                alpha: isDark ? 0.2 : 0.04,
                              ),
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: cs.error.withValues(alpha: 0.1),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.cloud_off_rounded,
                                size: 44,
                                color: cs.error,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Error de sincronización',
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w700,
                                color: cs.onSurface,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              state.message,
                              style: TextStyle(
                                color: cs.onSurfaceVariant,
                                fontSize: 13,
                                height: 1.4,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 20),
                            FilledButton.icon(
                              onPressed: () => context
                                  .read<ProductsMaterialsCubit>()
                                  .loadProductsMaterials(),
                              icon: const Icon(Icons.refresh_rounded, size: 18),
                              label: const Text('Reintentar conexión'),
                              style: FilledButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 22,
                                  vertical: 11,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }

                final List<ProductMaterialEntity> products =
                    state is ProductsMaterialsLoaded ? state.materials : [];

                final query = _searchController.text.trim().toLowerCase();

                // Aplicar búsqueda y filtros
                final filteredProducts = products.where((product) {
                  final name = product.itemName.toLowerCase();
                  final code = product.itemCode.toLowerCase();
                  final companyCode = product.companyCode.toLowerCase();

                  final matchesSearch =
                      query.isEmpty ||
                      name.contains(query) ||
                      code.contains(query) ||
                      companyCode.contains(query);

                  final matchesType =
                      _filterType == null || product.itemType == _filterType;
                  final matchesStatus =
                      _filterStatus == null ||
                      product.itemStatus == _filterStatus;

                  return matchesSearch && matchesType && matchesStatus;
                }).toList();

                if (filteredProducts.isEmpty) {
                  return Center(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(32),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(18),
                            decoration: BoxDecoration(
                              color: cs.primary.withValues(
                                alpha: isDark ? 0.15 : 0.08,
                              ),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              _hasAnyFilterOrSearch
                                  ? Icons.search_off_rounded
                                  : Icons.inventory_2_outlined,
                              size: 46,
                              color: cs.primary,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            _hasAnyFilterOrSearch
                                ? 'No se encontraron artículos'
                                : 'No hay inventario registrado',
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w700,
                              color: cs.onSurface,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            _hasAnyFilterOrSearch
                                ? 'No hay productos ni materiales que coincidan con los filtros o la búsqueda ingresada.'
                                : 'Aún no se encuentran productos ni materiales disponibles en la bodega.',
                            style: TextStyle(
                              color: cs.onSurfaceVariant,
                              fontSize: 13,
                              height: 1.4,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 20),
                          if (_hasAnyFilterOrSearch)
                            OutlinedButton.icon(
                              onPressed: _clearAllFilters,
                              icon: const Icon(
                                Icons.filter_alt_off_rounded,
                                size: 16,
                              ),
                              label: const Text('Limpiar búsqueda y filtros'),
                              style: OutlinedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                side: BorderSide(
                                  color: cs.primary.withValues(alpha: 0.4),
                                ),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 18,
                                  vertical: 11,
                                ),
                              ),
                            )
                          else
                            FilledButton.icon(
                              onPressed: () => context
                                  .read<ProductsMaterialsCubit>()
                                  .loadProductsMaterials(),
                              icon: const Icon(Icons.refresh_rounded, size: 16),
                              label: const Text('Actualizar inventario'),
                              style: FilledButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 18,
                                  vertical: 11,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  );
                }

                return Column(
                  children: [
                    // Contador de resultados
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 18,
                        vertical: 6,
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 3,
                            ),
                            decoration: BoxDecoration(
                              color: cs.primary.withValues(
                                alpha: isDark ? 0.16 : 0.08,
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              '${filteredProducts.length}',
                              style: TextStyle(
                                color: cs.primary,
                                fontWeight: FontWeight.w800,
                                fontSize: 12,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            _hasAnyFilterOrSearch
                                ? 'de ${products.length} artículos coincidentes'
                                : 'artículos en bodega en total',
                            style: TextStyle(
                              color: cs.onSurfaceVariant,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Lista de productos y materiales
                    Expanded(
                      child: RefreshIndicator(
                        color: cs.primary,
                        backgroundColor: isDark
                            ? cs.surfaceContainerHigh
                            : cs.surface,
                        onRefresh: () async => context
                            .read<ProductsMaterialsCubit>()
                            .loadProductsMaterials(),
                        child: ListView.separated(
                          physics: const BouncingScrollPhysics(
                            parent: AlwaysScrollableScrollPhysics(),
                          ),
                          padding: EdgeInsets.only(
                            left: 16,
                            right: 16,
                            top: 8,
                            bottom: 24 + MediaQuery.paddingOf(context).bottom,
                          ),
                          itemCount: filteredProducts.length,
                          separatorBuilder: (context, index) =>
                              const SizedBox(height: 10),
                          itemBuilder: (context, index) {
                            final product = filteredProducts[index];
                            return ProductsMaterialCard(product: product);
                          },
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _QuickTypeTab extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const _QuickTypeTab({
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: isSelected
                ? cs.primary
                : (isDark
                      ? cs.surfaceContainerHighest.withValues(alpha: 0.45)
                      : cs.surfaceContainerHighest.withValues(alpha: 0.5)),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: isSelected
                  ? cs.primary
                  : cs.outlineVariant.withValues(alpha: 0.5),
              width: 0.8,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: 14,
                color: isSelected ? cs.onPrimary : cs.onSurfaceVariant,
              ),
              const SizedBox(width: 6),
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                  color: isSelected ? cs.onPrimary : cs.onSurface,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FilterChoiceChip extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onSelected;

  const _FilterChoiceChip({
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return ChoiceChip(
      avatar: Icon(
        icon,
        size: 15,
        color: isSelected ? cs.onPrimary : cs.primary,
      ),
      label: Text(label),
      labelStyle: TextStyle(
        fontSize: 12.5,
        fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
        color: isSelected ? cs.onPrimary : cs.onSurface,
      ),
      selected: isSelected,
      selectedColor: cs.primary,
      backgroundColor: isDark
          ? cs.surfaceContainerHighest.withValues(alpha: 0.5)
          : cs.surfaceContainerLowest,
      side: BorderSide(
        color: isSelected
            ? cs.primary
            : cs.outlineVariant.withValues(alpha: 0.5),
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      onSelected: (_) => onSelected(),
    );
  }
}
