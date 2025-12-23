import 'package:clean_architecture/core/utils/type_defs.dart';
import 'package:clean_architecture/features/connections/domain/entities/connection.dart';

abstract interface class ConnectionRepository {
  FutureData<List<ConnectionEntity>> getAllConnections({
    int? limit,
    int? offset,
  });
}
