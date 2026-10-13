import 'package:clean_architecture/core/data_states/data_state.dart';
import 'dart:typed_data';

import 'package:clean_architecture/core/utils/type_defs.dart';
import 'package:clean_architecture/shared/files/data/datasources/file_remote_datasource.dart';
import 'package:clean_architecture/shared/files/domain/params/file_params.dart';
import 'package:clean_architecture/shared/files/domain/repositories/file_repository.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: FileRepository)
final class FileRepositoryImpl implements FileRepository {
  final FileRemoteDataSource _remote;

  /// Caché en memoria de previews (evita re-descargar al hacer scroll).
  final Map<FileParams, Uint8List> _previewCache = {};
  static const _maxCacheEntries = 60;

  FileRepositoryImpl(this._remote);

  @override
  FutureData<Uint8List> preview(FileParams params) async {
    final cached = _previewCache[params];
    if (cached != null) return SuccessState(data: cached);

    final result = await _remote.getBytes(FileEndpoints.preview(params));
    final bytes = result.data;
    if (bytes != null) {
      if (_previewCache.length >= _maxCacheEntries) {
        _previewCache.remove(_previewCache.keys.first);
      }
      _previewCache[params] = bytes;
    }
    return result;
  }

  @override
  FutureData<Uint8List> download(FileParams params) =>
      _remote.getBytes(FileEndpoints.download(params));
}
