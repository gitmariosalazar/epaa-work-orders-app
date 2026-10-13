import 'package:clean_architecture/core/utils/type_defs.dart';
import 'package:injectable/injectable.dart';
import '../entities/dashboard_stats.dart';
import '../repositories/dashboard_repository.dart';

@lazySingleton
class GetDashboardStatsUseCase {
  final DashboardRepository repository;

  GetDashboardStatsUseCase(this.repository);

  FutureData<DashboardStats> call() {
    return repository.getDashboardStats();
  }
}
