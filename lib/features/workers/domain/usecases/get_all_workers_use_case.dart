import 'package:clean_architecture/core/domain/use_cases/use_case.dart';
import 'package:clean_architecture/core/utils/type_defs.dart';
import 'package:clean_architecture/features/workers/domain/entities/worker_entity.dart';
import 'package:clean_architecture/features/workers/domain/repositories/worker_repository.dart';
import 'package:injectable/injectable.dart';

@LazySingleton()
class GetAllWorkersUseCase implements UseCaseNoParameter<List<WorkerEntity>> {
  final WorkerRepository _repository;

  GetAllWorkersUseCase(
    this._repository,
  ); // incluso más corto con constructor sintáctico

  @override
  FutureData<List<WorkerEntity>> call() => _repository.getAllWorkers();
}
