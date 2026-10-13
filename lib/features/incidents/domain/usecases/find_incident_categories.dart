import 'package:injectable/injectable.dart';
import 'package:clean_architecture/core/utils/type_defs.dart';
import 'package:clean_architecture/core/domain/use_cases/use_case.dart';
import 'package:clean_architecture/features/incidents/data/models/models/incident-category.model.dart';
import 'package:clean_architecture/features/incidents/domain/repositories/incident_repository.dart';

@lazySingleton
class FindIncidentCategoriesUseCase
    implements UseCaseNoParameter<List<IncidentCategoryModel>> {
  final IncidentRepository repository;

  FindIncidentCategoriesUseCase(this.repository);

  @override
  FutureData<List<IncidentCategoryModel>> call({int? limit, int? offset}) {
    return repository.findIncidentCategories();
  }
}
