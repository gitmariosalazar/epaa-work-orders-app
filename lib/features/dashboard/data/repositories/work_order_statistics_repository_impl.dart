// features/dashboard/data/repositories/work_order_statistics_repository_impl.dart

import 'package:clean_architecture/core/data_handling/data_handler.dart';
import 'package:clean_architecture/core/data_states/data_state.dart';
import 'package:clean_architecture/core/services/internet/internet_service.dart';
import 'package:clean_architecture/core/utils/type_defs.dart';
import 'package:clean_architecture/features/dashboard/data/datasource/remote/work_order_statistics_remote_datasource.dart';
import 'package:clean_architecture/features/dashboard/domain/entities/work_order_statistics_entities.dart';
import 'package:clean_architecture/features/dashboard/domain/repositories/work_order_statistics_repository.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: WorkOrderStatisticsRepository)
class WorkOrderStatisticsRepositoryImpl
    implements WorkOrderStatisticsRepository {
  final InternetService _internet;
  final WorkOrderStatisticsRemoteDataSource _remoteDataSource;

  WorkOrderStatisticsRepositoryImpl({
    required InternetService internet,
    required WorkOrderStatisticsRemoteDataSource remoteDataSource,
  }) : _internet = internet,
       _remoteDataSource = remoteDataSource;

  /// Ejecuta la llamada remota y mapea modelo → entidad conservando el
  /// estado de error original (mismo patrón que `WorkOrderRepositoryImpl`).
  FutureData<List<E>> _fetch<M, E>(
    FutureData<List<M>> Function() remote,
    E Function(M model) toEntity,
  ) async {
    final result = await DataHandler.fetchWithFallback<List<M>>(
      _internet.isConnected,
      remoteCallback: remote,
    );

    return result.when(
      success: (models) =>
          SuccessState<List<E>>(data: models.map(toEntity).toList()),
      failure: (message, errorType) =>
          FailureState<List<E>>(message: message, errorType: errorType),
      loading: () => LoadingState<List<E>>(),
    );
  }

  @override
  FutureData<List<WorkOrderPriorityStatisticEntity>> getPriorityStatistics() =>
      _fetch(_remoteDataSource.getPriorityStatistics, (m) => m.toEntity());

  @override
  FutureData<List<WorkOrderStatusStatisticEntity>> getStatusStatistics() =>
      _fetch(_remoteDataSource.getStatusStatistics, (m) => m.toEntity());

  @override
  FutureData<List<WorkOrderTypeStatisticEntity>> getTypeStatistics() =>
      _fetch(_remoteDataSource.getTypeStatistics, (m) => m.toEntity());

  @override
  FutureData<List<WorkOrdersKeyStatisticEntity>> getKeyStatistics() =>
      _fetch(_remoteDataSource.getKeyStatistics, (m) => m.toEntity());
}
