import 'package:clean_architecture/core/constants/api_endpoints.dart';
import 'package:clean_architecture/core/data_handling/data_handler.dart';
import 'package:clean_architecture/core/services/api/api_service.dart';
import 'package:clean_architecture/core/utils/type_defs.dart';
import 'package:clean_architecture/features/connections/data/models/connection.dart';
import 'package:injectable/injectable.dart';

abstract interface class ConnectionRemoteDatasource {
  FutureData<List<ConnectionModel>> getAllConnections({
    int? limit,
    int? offset,
  });
}

@LazySingleton(as: ConnectionRemoteDatasource)
class ConnectionRemoteDatasourceImpl implements ConnectionRemoteDatasource {
  final ApiService _apiService;
  const ConnectionRemoteDatasourceImpl({required ApiService apiService})
    : _apiService = apiService;

  @override
  FutureData<List<ConnectionModel>> getAllConnections({
    int? limit,
    int? offset,
  }) {
    final queryParameters = <String, dynamic>{};
    if (limit != null) {
      queryParameters['limit'] = limit;
    }
    if (offset != null) {
      queryParameters['offset'] = offset;
    }
    return DataHandler.safeApiCall<List<ConnectionModel>, ConnectionModel>(
      request: () => _apiService.get(
        ApiEndpoints.getAllConnections,
        queryParameters: queryParameters,
      ),
      fromJson: (json) => ConnectionModel.fromJson(json),
      isStandardResponse: true,
      responseDataKey: 'data',
    );
  }
}

// Paginated version could be added here in the future

abstract interface class ConnectionPaginatedRemoteDatasource {
  FutureData<List<ConnectionModel>> getAllConnectionsPaginated({
    required int limit,
    required int offset,
    required String? query,
  });
}

@LazySingleton(as: ConnectionPaginatedRemoteDatasource)
class ConnectionPaginatedRemoteDatasourceImpl
    implements ConnectionPaginatedRemoteDatasource {
  final ApiService _apiService;
  const ConnectionPaginatedRemoteDatasourceImpl({
    required ApiService apiService,
  }) : _apiService = apiService;
  @override
  FutureData<List<ConnectionModel>> getAllConnectionsPaginated({
    required int limit,
    required int offset,
    required String? query,
  }) {
    final queryParameters = <String, dynamic>{'limit': limit, 'offset': offset};
    if (query != null && query.isNotEmpty) {
      queryParameters['query'] = query;
    }
    return DataHandler.safeApiCall<List<ConnectionModel>, ConnectionModel>(
      request: () => _apiService.get(
        ApiEndpoints.getAllConnectionsPaginated,
        queryParameters: queryParameters,
      ),
      fromJson: (json) => ConnectionModel.fromJson(json),
      isStandardResponse: true,
      responseDataKey: 'data',
    );
  }
}
