import 'package:injectable/injectable.dart';
import 'package:clean_architecture/core/utils/type_defs.dart';
import 'package:clean_architecture/core/domain/use_cases/use_case.dart';
import 'package:clean_architecture/features/reading/data/model/create_reading_request.dart';
import 'package:clean_architecture/features/reading/domain/entities/reading_result.dart';
import 'package:clean_architecture/features/reading/domain/repositories/reading_repository.dart';

@lazySingleton
class CreateReadingUseCase implements UseCase<ReadingResult, CreateReadingRequest> {
  final ReadingRepository repository;

  CreateReadingUseCase(this.repository);

  @override
  FutureData<ReadingResult> call(CreateReadingRequest params) {
    return repository.createReading(params);
  }
}
