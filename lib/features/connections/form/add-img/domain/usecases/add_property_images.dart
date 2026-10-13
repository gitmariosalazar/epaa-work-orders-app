import 'package:clean_architecture/core/utils/type_defs.dart';
import 'package:injectable/injectable.dart';
import 'package:image_picker/image_picker.dart';
import '../entities/photo_connection.dart';
import '../entities/photo_connection_params.dart';
import '../repositories/property_image_repository.dart';

@lazySingleton
class AddPropertyImagesUseCase {
  final PropertyImageRepository repository;

  AddPropertyImagesUseCase(this.repository);

  FutureData<List<PhotoConnection>> call({
    required String connectionId,
    required List<XFile> images,
    String? description,
  }) {
    return repository.addPropertyImages(
      params: PhotoConnectionParams(
        connectionId: connectionId,
        images: images,
        description: description,
      ),
    );
  }
}
