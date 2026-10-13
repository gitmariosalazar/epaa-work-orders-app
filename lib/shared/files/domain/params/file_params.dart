import 'package:clean_architecture/shared/files/domain/entities/file_category.dart';
import 'package:equatable/equatable.dart';

/// Referencia a un archivo del backend (categoría + nombre).
class FileParams extends Equatable {
  final FileCategory category;
  final String filename;

  const FileParams({required this.category, required this.filename});

  /// Crea la referencia a partir de una ruta como
  /// `/files/incidents/foto.jpg`, `uploads/incidents/foto.jpg` o `foto.jpg`.
  /// Si la ruta no indica categoría se usa [fallback].
  factory FileParams.fromPath(
    String path, {
    FileCategory fallback = FileCategory.incidents,
  }) {
    final segments = path
        .split(RegExp(r'[\\/]'))
        .where((s) => s.isNotEmpty)
        .toList();
    final filename = segments.isEmpty ? '' : segments.last;
    final category = FileCategory.values.firstWhere(
      (c) => segments.contains(c.value),
      orElse: () => fallback,
    );
    return FileParams(category: category, filename: filename);
  }

  bool get isValid => filename.trim().isNotEmpty;

  @override
  List<Object?> get props => [category, filename];
}
