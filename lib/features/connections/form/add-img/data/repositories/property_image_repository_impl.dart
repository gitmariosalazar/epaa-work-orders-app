import 'package:clean_architecture/core/utils/type_defs.dart';
import 'package:injectable/injectable.dart';
import '../datasources/property_image_remote_data_source.dart';
import '../../domain/entities/photo_connection.dart';
import '../../domain/entities/photo_connection_params.dart';
import '../../domain/repositories/property_image_repository.dart';

@LazySingleton(as: PropertyImageRepository)
class PropertyImageRepositoryImpl implements PropertyImageRepository {
  final PropertyImageRemoteDataSource remoteDataSource;

  PropertyImageRepositoryImpl(this.remoteDataSource);

  @override
  FutureData<List<PhotoConnection>> addPropertyImages({
    required PhotoConnectionParams params,
  }) async {
    return await remoteDataSource.addPropertyImages(
      connectionId: params.connectionId,
      images: params.images,
      description: params.description,
    );
  }
}
