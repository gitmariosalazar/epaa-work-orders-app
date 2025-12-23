// features/products/presentation/pages/products_materials_home_page.dart

import 'package:auto_route/auto_route.dart';
import 'package:clean_architecture/features/products/domain/entities/product_material_entity.dart';
import 'package:clean_architecture/features/products/domain/usecases/product_material_use_case.dart';
import 'package:clean_architecture/features/products/presentation/cubits/products/products_cubit.dart';
import 'package:clean_architecture/features/products/presentation/cubits/products/products_state.dart';
import 'package:clean_architecture/features/products/presentation/widgets/products_materials_card.dart';
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

  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (context) {
        String tempType = _filterType ?? '';
        String tempStatus = _filterStatus ?? '';

        return AlertDialog(
          title: const Text('Filtros de Productos y Materiales'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                DropdownButtonFormField<String?>(
                  value: _filterType,
                  decoration: InputDecoration(
                    labelText: 'Tipo',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  items: const [
                    DropdownMenuItem(
                      value: null,
                      child: Text('Todos los tipos'),
                    ),
                    DropdownMenuItem(value: 'M', child: Text('Material')),
                    DropdownMenuItem(value: 'P', child: Text('Producto')),
                  ],
                  onChanged: (value) => setState(() => _filterType = value),
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String?>(
                  value: _filterStatus,
                  decoration: InputDecoration(
                    labelText: 'Estado',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  items: const [
                    DropdownMenuItem(
                      value: null,
                      child: Text('Todos los estados'),
                    ),
                    DropdownMenuItem(value: 'A', child: Text('Activo')),
                  ],
                  onChanged: (value) => setState(() => _filterStatus = value),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  _filterType = null;
                  _filterStatus = null;
                });
                Navigator.pop(context);
              },
              child: const Text('Limpiar'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Aplicar'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Productos y Materiales'),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: _showFilterDialog,
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () =>
                context.read<ProductsMaterialsCubit>().loadProductsMaterials(),
          ),
        ],
      ),
      body: Column(
        children: [
          // Barra de búsqueda
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Buscar por nombre, código o clave...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          setState(() {});
                        },
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: theme.brightness == Brightness.dark
                    ? Colors.grey[800]
                    : Colors.grey[100],
              ),
              onChanged: (value) => setState(() {}),
            ),
          ),
          // Lista
          Expanded(
            child: BlocBuilder<ProductsMaterialsCubit, ProductsMaterialsState>(
              builder: (context, state) {
                if (state is ProductsMaterialsLoading ||
                    state is ProductsMaterialsInitial) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (state is ProductsMaterialsError) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.cloud_off,
                          size: 80,
                          color: Colors.grey,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Error de conexión',
                          style: theme.textTheme.titleLarge,
                        ),
                        const SizedBox(height: 8),
                        Text(state.message, textAlign: TextAlign.center),
                        const SizedBox(height: 24),
                        ElevatedButton.icon(
                          onPressed: () => context
                              .read<ProductsMaterialsCubit>()
                              .loadProductsMaterials(),
                          icon: const Icon(Icons.refresh),
                          label: const Text('Reintentar'),
                        ),
                      ],
                    ),
                  );
                }

                final List<ProductMaterialEntity> products =
                    state is ProductsMaterialsLoaded ? state.materials : [];

                // Aplicar búsqueda y filtros
                final filteredProducts = products.where((product) {
                  final matchesSearch =
                      _searchController.text.isEmpty ||
                      product.itemName.toLowerCase().contains(
                        _searchController.text.toLowerCase(),
                      ) ||
                      product.itemCode.contains(_searchController.text) ||
                      product.companyCode.contains(_searchController.text);

                  final matchesType =
                      _filterType == null || product.itemType == _filterType;
                  final matchesStatus =
                      _filterStatus == null ||
                      product.itemStatus == _filterStatus;

                  return matchesSearch && matchesType && matchesStatus;
                }).toList();

                if (filteredProducts.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.inventory_2_outlined,
                          size: 80,
                          color: Colors.grey,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No se encontraron productos',
                          style: theme.textTheme.titleLarge,
                        ),
                        const SizedBox(height: 8),
                        const Text('Intenta con otros filtros'),
                      ],
                    ),
                  );
                }

                return RefreshIndicator(
                  onRefresh: () async => context
                      .read<ProductsMaterialsCubit>()
                      .loadProductsMaterials(),
                  child: ListView.builder(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.all(8),
                    itemCount: filteredProducts.length,
                    itemBuilder: (context, index) {
                      final product = filteredProducts[index];
                      return ProductsMaterialCard(product: product);
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
