import 'package:injectable/injectable.dart';
import '../entities/dashboard_stats.dart';
import '../repositories/dashboard_repository.dart';

@lazySingleton
class WatchDashboardStatsUseCase {
  final DashboardRepository repository;

  WatchDashboardStatsUseCase(this.repository);

  Stream<DashboardStats> call() {
    return repository.watchDashboardStats();
  }
}
