import 'package:injectable/injectable.dart';
import 'package:clean_architecture/core/utils/type_defs.dart';
import 'package:clean_architecture/core/domain/use_cases/use_case.dart';
import 'package:clean_architecture/features/reading/domain/entities/reading.dart';
import 'package:clean_architecture/features/reading/domain/repositories/reading_repository.dart';

@lazySingleton
class GetReadingInfo implements UseCase<List<Reading>, String> {
  final ReadingRepository repository;

  GetReadingInfo(this.repository);

  @override
  FutureData<List<Reading>> call(String params) {
    return repository.getReadingInfo(params);
  }
}
