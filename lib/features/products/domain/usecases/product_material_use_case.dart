import 'package:clean_architecture/core/domain/use_cases/use_case.dart';
import 'package:clean_architecture/core/utils/type_defs.dart';
import 'package:clean_architecture/features/products/domain/entities/product_material_entity.dart';
import 'package:clean_architecture/features/products/domain/repositories/product_material_repository.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class GetAllProductMaterialsUseCase
    implements UseCaseNoParameter<List<ProductMaterialEntity>> {
  final ProductMaterialRepository _repository;

  GetAllProductMaterialsUseCase(
    this._repository,
  ); // incluso más corto con constructor sintáctico

  @override
  FutureData<List<ProductMaterialEntity>> call() =>
      _repository.getAllProductMaterials();
}
