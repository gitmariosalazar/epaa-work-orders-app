import 'dart:typed_data';

import 'package:clean_architecture/core/data_states/data_state.dart';
import 'package:clean_architecture/core/domain/use_cases/use_case.dart';
import 'package:clean_architecture/core/utils/type_defs.dart';
import 'package:clean_architecture/shared/files/domain/params/file_params.dart';
import 'package:clean_architecture/shared/files/domain/repositories/file_repository.dart';
import 'package:injectable/injectable.dart';

FailureState<Uint8List> _invalid() => const FailureState<Uint8List>(
  message: 'El nombre del archivo no puede estar vacío',
  errorType: ErrorType.unknown,
);

/// Obtiene un archivo para previsualizar.
@lazySingleton
class PreviewFileUseCase implements UseCase<Uint8List, FileParams> {
  final FileRepository _repository;
  PreviewFileUseCase(this._repository);

  @override
  FutureData<Uint8List> call(FileParams params) async =>
      params.isValid ? _repository.preview(params) : _invalid();
}

/// Obtiene un archivo para descargar.
@lazySingleton
class DownloadFileUseCase implements UseCase<Uint8List, FileParams> {
  final FileRepository _repository;
  DownloadFileUseCase(this._repository);

  @override
  FutureData<Uint8List> call(FileParams params) async =>
      params.isValid ? _repository.download(params) : _invalid();
}
