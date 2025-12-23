import 'package:clean_architecture/core/utils/type_defs.dart';
import 'package:clean_architecture/features/products/domain/entities/product_material_entity.dart';

abstract interface class ProductMaterialRepository {
  FutureData<List<ProductMaterialEntity>> getAllProductMaterials();
}
