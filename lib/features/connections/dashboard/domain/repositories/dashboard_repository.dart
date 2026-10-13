import 'package:clean_architecture/core/utils/type_defs.dart';
import '../entities/dashboard_stats.dart';

abstract class DashboardRepository {
  FutureData<DashboardStats> getDashboardStats();

  Stream<DashboardStats> watchDashboardStats();
}
