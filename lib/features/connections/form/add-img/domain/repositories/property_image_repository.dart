import 'package:clean_architecture/core/utils/type_defs.dart';
import '../entities/photo_connection.dart';
import '../entities/photo_connection_params.dart';

abstract class PropertyImageRepository {
  FutureData<List<PhotoConnection>> addPropertyImages({
    required PhotoConnectionParams params,
  });
}
