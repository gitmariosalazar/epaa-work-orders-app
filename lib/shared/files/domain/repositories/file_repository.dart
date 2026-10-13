import 'dart:typed_data';

import 'package:clean_architecture/core/utils/type_defs.dart';
import 'package:clean_architecture/shared/files/domain/params/file_params.dart';

/// Contrato de acceso a archivos protegidos del backend.
abstract interface class FileRepository {
  /// Bytes del archivo para previsualización (inline).
  FutureData<Uint8List> preview(FileParams params);

  /// Bytes del archivo para descarga (attachment).
  FutureData<Uint8List> download(FileParams params);
}
