import 'dart:async';
import 'package:injectable/injectable.dart';
import 'package:clean_architecture/core/utils/type_defs.dart';
import 'package:clean_architecture/features/connections/dashboard/data/datasources/dashboard_remote_datasource.dart';
import 'package:clean_architecture/features/connections/dashboard/data/models/dashboard_stats_model.dart';
import 'package:clean_architecture/features/connections/dashboard/domain/entities/dashboard_stats.dart';
import 'package:clean_architecture/features/connections/dashboard/domain/repositories/dashboard_repository.dart';

@LazySingleton(as: DashboardRepository)
class DashboardRepositoryImpl implements DashboardRepository {
  final DashboardRemoteDataSource remoteDataSource;

  final Duration pollingInterval;

  Timer? _pollingTimer;

  DashboardRepositoryImpl({
    required this.remoteDataSource,
    this.pollingInterval = const Duration(seconds: 60),
  });

  FutureData<DashboardStats> _fetchStats() async {
    final response = await remoteDataSource.getDashboardAdvance();
    return response.mapData((dto) => DashboardStatsModel.fromDto(dto));
  }

  @override
  FutureData<DashboardStats> getDashboardStats() {
    return _fetchStats();
  }

  @override
  Stream<DashboardStats> watchDashboardStats() {
    late StreamController<DashboardStats> controller;

    Future<void> loadAndEmit() async {
      if (controller.isClosed) return;
      final result = await _fetchStats();
      if (!controller.isClosed) {
        result.when(
          success: (stats) => controller.add(stats),
          failure: (message, _) => controller.addError(Exception(message)),
          loading: () {},
        );
      }
    }

    controller = StreamController<DashboardStats>.broadcast(
      onListen: () {
        loadAndEmit();
        _pollingTimer = Timer.periodic(pollingInterval, (_) => loadAndEmit());
      },
      onCancel: () {
        _pollingTimer?.cancel();
        _pollingTimer = null;
      },
    );

    return controller.stream;
  }
}
