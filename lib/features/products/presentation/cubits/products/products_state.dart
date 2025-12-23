// features/work-orders/presentation/cubits/work_orders/work_orders_state.dart

import 'package:clean_architecture/features/products/domain/entities/product_material_entity.dart';
import 'package:equatable/equatable.dart';

sealed class ProductsMaterialsState extends Equatable {
  const ProductsMaterialsState();

  @override
  List<Object?> get props => [];
}

class ProductsMaterialsInitial extends ProductsMaterialsState {}

class ProductsMaterialsLoading extends ProductsMaterialsState {}

class ProductsMaterialsLoaded extends ProductsMaterialsState {
  final List<ProductMaterialEntity> materials;

  const ProductsMaterialsLoaded(this.materials);

  @override
  List<Object?> get props => [materials];
}

class ProductsMaterialsError extends ProductsMaterialsState {
  final String message;

  const ProductsMaterialsError(this.message);

  @override
  List<Object?> get props => [message];
}

class ProductsMaterialsEmpty extends ProductsMaterialsState {}
