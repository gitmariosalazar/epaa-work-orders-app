import 'package:clean_architecture/core/utils/type_defs.dart';
import 'package:clean_architecture/features/workers/domain/entities/worker_entity.dart';

abstract class WorkerRepository {
  // Define los métodos del repositorio de trabajadores aquí
  FutureData<List<WorkerEntity>> getAllWorkers();
}

abstract class WorkerPaginatedRepository {
  FutureData<List<WorkerEntity>> getAllWorkersPaginated({
    required int limit,
    required int offset,
    required String? query,
  });
}
