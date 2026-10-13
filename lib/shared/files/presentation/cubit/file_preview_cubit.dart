import 'dart:typed_data';

import 'package:clean_architecture/shared/files/domain/params/file_params.dart';
import 'package:clean_architecture/shared/files/domain/usecases/file_use_cases.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

/// Estado de la previsualización de un archivo
/// (equivale a `UseFilePreviewResult` de app-properties).
class FilePreviewState extends Equatable {
  final Uint8List? bytes;
  final bool loading;
  final String? error;

  const FilePreviewState({this.bytes, this.loading = false, this.error});

  const FilePreviewState.initial() : this();

  bool get hasData => bytes != null;

  @override
  List<Object?> get props => [bytes?.length, loading, error];
}

/// Un cubit por archivo (equivale al `StateNotifierProvider.family`).
class FilePreviewCubit extends Cubit<FilePreviewState> {
  final PreviewFileUseCase _previewFile;

  FilePreviewCubit({PreviewFileUseCase? previewFile})
    : _previewFile = previewFile ?? GetIt.I<PreviewFileUseCase>(),
      super(const FilePreviewState.initial());

  Future<void> load(FileParams params) async {
    emit(const FilePreviewState(loading: true));
    final result = await _previewFile(params);
    if (isClosed) return;
    result.when(
      success: (bytes) => emit(FilePreviewState(bytes: bytes)),
      failure: (message, _) => emit(
        FilePreviewState(error: message ?? 'No se pudo cargar el archivo'),
      ),
      loading: () => emit(const FilePreviewState(loading: true)),
    );
  }

  void clear() => emit(const FilePreviewState.initial());
}
