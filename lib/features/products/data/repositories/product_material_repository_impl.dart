import 'package:clean_architecture/core/data_handling/data_handler.dart';
import 'package:clean_architecture/core/services/internet/internet_service.dart';
import 'package:clean_architecture/core/utils/type_defs.dart';
import 'package:clean_architecture/features/products/data/datasource/remote/product_material_remote_datasource.dart';
import 'package:clean_architecture/features/products/data/models/product_material_model.dart';
import 'package:clean_architecture/features/products/domain/entities/product_material_entity.dart';
import 'package:clean_architecture/features/products/domain/repositories/product_material_repository.dart';
import 'package:injectable/injectable.dart';
import 'package:clean_architecture/core/data_states/data_state.dart';

@LazySingleton(as: ProductMaterialRepository)
class ProductMaterialRepositoryImpl implements ProductMaterialRepository {
  final InternetService _internet;
  final ProductMaterialRemoteDatasource _remoteDataSource;

  ProductMaterialRepositoryImpl({
    required InternetService internet,
    required ProductMaterialRemoteDatasource remoteDataSource,
  }) : _internet = internet,
       _remoteDataSource = remoteDataSource;

  @override
  FutureData<List<ProductMaterialEntity>> getAllProductMaterials() async {
    final result =
        await DataHandler.fetchWithFallback<List<ProductMaterialModel>>(
          _internet.isConnected,
          remoteCallback: _remoteDataSource.getAllProductMaterials,
        );

    return result.when(
      success: (models) {
        final entities = models.map((model) => model.toEntity()).toList();
        return SuccessState<List<ProductMaterialEntity>>(data: entities);
      },
      failure: (message, errorType) {
        return FailureState<List<ProductMaterialEntity>>(
          message: message,
          errorType: errorType,
        );
      },
      loading: () {
        return LoadingState<List<ProductMaterialEntity>>();
      },
    );
  }
}
