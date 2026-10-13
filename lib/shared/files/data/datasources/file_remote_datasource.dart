import 'dart:typed_data';

import 'package:clean_architecture/core/data_handling/data_handler.dart';
import 'package:clean_architecture/core/data_states/data_state.dart';
import 'package:clean_architecture/core/services/api/api_service.dart';
import 'package:clean_architecture/core/utils/type_defs.dart';
import 'package:clean_architecture/shared/files/domain/params/file_params.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

/// Endpoints `GET /files/:type/:filename/{preview|download}`.
abstract final class FileEndpoints {
  static String preview(FileParams p) =>
      'files/${p.category.value}/${Uri.encodeComponent(p.filename)}/preview';
  static String download(FileParams p) =>
      'files/${p.category.value}/${Uri.encodeComponent(p.filename)}/download';
}

abstract interface class FileRemoteDataSource {
  FutureData<Uint8List> getBytes(String path);
}

/// Usa el [ApiService] compartido: hereda token Bearer y refresh automático
/// del `AuthInterceptor` (no se crea un Dio paralelo).
@LazySingleton(as: FileRemoteDataSource)
final class FileRemoteDataSourceImpl implements FileRemoteDataSource {
  final ApiService _api;
  FileRemoteDataSourceImpl(this._api);

  @override
  FutureData<Uint8List> getBytes(String path) {
    return ErrorHandler.handleException(() async {
      final response = await _api.get(
        path,
        options: Options(responseType: ResponseType.bytes),
      );
      final data = response.data;
      final bytes = data is Uint8List
          ? data
          : data is List<int>
          ? Uint8List.fromList(data)
          : null;
      if (bytes == null || bytes.isEmpty) {
        return const FailureState<Uint8List>(
          message: 'El archivo está vacío o no existe',
          errorType: ErrorType.unknown,
        );
      }
      return SuccessState<Uint8List>(data: bytes);
    });
  }
}
