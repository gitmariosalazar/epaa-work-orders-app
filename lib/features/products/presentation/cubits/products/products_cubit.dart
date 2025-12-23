// features/products/presentation/cubits/products/products_cubit.dart

import 'package:clean_architecture/features/products/domain/usecases/product_material_use_case.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'products_state.dart';

class ProductsMaterialsCubit extends Cubit<ProductsMaterialsState> {
  final GetAllProductMaterialsUseCase getAllProductsMaterialsUseCase;

  ProductsMaterialsCubit({required this.getAllProductsMaterialsUseCase})
    : super(ProductsMaterialsInitial());
  Future<void> loadProductsMaterials() async {
    // Evita llamadas duplicadas si ya está cargando
    if (state is ProductsMaterialsLoading) return;

    emit(ProductsMaterialsLoading());

    try {
      final result = await getAllProductsMaterialsUseCase();

      result.when(
        success: (entities) {
          if (entities.isEmpty) {
            emit(ProductsMaterialsEmpty());
          } else {
            emit(ProductsMaterialsLoaded(entities));
          }
        },
        failure: (message, errorType) {
          emit(ProductsMaterialsError(message ?? 'Error del servidor'));
        },
        loading: () {
          // No debería llegar aquí, pero por seguridad
          if (state is! ProductsMaterialsLoading) if (isClosed) return;
          emit(ProductsMaterialsLoading());
        },
      );
    } catch (e, stackTrace) {
      print('ProductsMaterialsCubit ERROR: $e');
      print(stackTrace);
      emit(
        ProductsMaterialsError(
          'Error de conexión o inesperado. Intenta de nuevo.',
        ),
      );
    }
  }
}
